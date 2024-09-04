// nexys_video_gpio.sv

`default_nettype none

module nexys_video_gpio # (
  parameter int                 AXI_ALEN = 64,
  parameter int                 AXI_DLEN = 64,
  parameter int                 AXI_SLEN = AXI_DLEN / 8,
  parameter bit [AXI_ALEN-1:0]  AXI_BASE_ADDR = 0,
  parameter bit [AXI_ALEN-1:0]  R_STATUS_OFFSET = 0,
  parameter bit [AXI_ALEN-1:0]  W_LED_OFFSET = 0
)(
  input var               clk,
  input var               rstn,

  axi4_lite_if.S          axi,

  output var logic  [7:0] o_led
);


/* Write Controller */
// register write enable
logic aw_en;
logic w_en;
logic b_en;
always_comb begin
  b_en = aw_en & w_en;
end

// write address enable latch
always_ff @(posedge clk) begin
  if (!rstn) begin
    aw_en <= 0;
  end else begin
    if (aw_en) begin
      aw_en <= ~b_en;
    end else begin
      aw_en <= axi.awvalid;
    end
  end
end

// write address channel ready
always_ff @(posedge clk) begin
  if (!rstn) begin
    axi.awready <= 0;
  end else begin
    axi.awready <= ~(axi.awvalid ^ aw_en);
  end
end

// LED write address latch
logic valid_led_aw;
always_ff @(posedge clk) begin
  if (!rstn) begin
    valid_led_aw <= 0;
  end else begin
    if (valid_led_aw) begin
      valid_led_aw <= ~b_en;
    end else begin
      valid_led_aw <= axi.awvalid & (axi.awaddr == (AXI_BASE_ADDR + W_LED_OFFSET));
    end
  end
end

// write data enable latch
always_ff @(posedge clk) begin
  if (!rstn) begin
    w_en <= 0;
  end else begin
    if (w_en) begin
      w_en <= ~b_en;
    end else begin
      w_en <= axi.wvalid;
    end
  end
end

// write data channel ready
always_ff @(posedge clk) begin
  if (!rstn) begin
    axi.wready <= 0;
  end else begin
    axi.wready <= ~(axi.wvalid ^ w_en);
  end
end

// valid led write data latch
logic valid_led_w;
always_ff @(posedge clk) begin
  if (!rstn) begin
    valid_led_w <= 0;
  end else begin
    if (valid_led_w) begin
      valid_led_w <= ~b_en;
    end else begin
      valid_led_w <= axi.wvalid & axi.wstrb[0];
    end
  end
end

// write data channel buffer
logic [AXI_DLEN-1:0] wdata;
always_ff @(posedge clk) begin
  if (axi.wvalid) begin
    for (int i=0; i < AXI_SLEN; i++) begin
      wdata[i+:8] <= (axi.wstrb[i]) ? axi.wdata[i+:8] : 8'b0;
    end
  end else begin
    wdata <= wdata;
  end
end

// led register
always_ff @(posedge clk) begin
  if (!rstn) begin
    o_led <= 0;
  end else begin
    if (valid_led_aw && valid_led_w) begin
      o_led <= wdata;
    end else begin
      o_led <= o_led;
    end
  end
end

// write response valid
always_ff @(posedge clk) begin
  if (!rstn) begin
    axi.bvalid <= 0;
  end else begin
    if (axi.bvalid) begin
      axi.bvalid <= ~axi.bready;
    end else begin
      axi.bvalid <= b_en;
    end
  end
end

// write response field
always_ff @(posedge clk) begin
  if (!rstn) begin
    axi.bresp <= 2'b00;
  end else begin
    if (b_en && !valid_led_aw) begin
      axi.bresp <= 2'b11; // DECERR
    end else if (b_en && valid_led_aw && !valid_led_w) begin
      axi.bresp <= 2'b10; // SLVERR
    end else begin
      axi.bresp <= 2'b00; // OKAY
    end
  end
end


/* Read Controller */
// read status enable
logic read_status;
always_comb begin
  read_status = axi.arvalid | (axi.araddr == AXI_BASE_ADDR);
end

// status data
assign status = {
  {(AXI_DLEN-8){1'b0}},
  o_led
};

// read address channel ready
always_ff @(posedge clk) begin
  if (!rstn) begin
    axi.arready <= 0;
  end else begin
    axi.arready <= ~(axi.arvalid ^ axi.rready);
  end
end

// read data channel valid
always_ff @(posedge clk) begin
  if (!rstn) begin
    axi.rvalid <= 0;
  end else begin
    if (axi.rvalid) begin
      axi.rvalid <= ~axi.rready;
    end else begin
      axi.rvalid <= axi.arvalid & axi.aready;
    end
  end
end

// read data
always_ff @(posedge clk) begin
  axi.rdata <= status;
end

// read response
always_ff @(posedge clk) begin
  if (!rstn) begin
    axi.rresp <= 2'b00;
  end else begin
    if (read_status) begin
      axi.rresp <= 2'b00; // OKAY
    end else if (axi.arvalid && !read_status) begin
      axi.rresp <= 2'b11; // DECERR
    end else begin
      axi.rresp <= 2'b00;
    end
  end
end


endmodule
