// nexys_video_gpio_bd_conn.sv

`default_nettype none

module nexys_video_gpio_bd_conn # (
  parameter int                 AXI_ALEN = 64,
  parameter int                 AXI_DLEN = 64,
  parameter int                 AXI_SLEN = AXI_DLEN / 8,
  parameter bit [AXI_ALEN-1:0]  AXI_BASE_ADDR = 0,
  parameter int                 R_STATUS_OFFSET = 0,
  parameter int                 W_LED_OFFSET = 0
)(
  input var                         aclk,
  input var                         aresetn,

  input var                         s_axi_awvalid,
  output var logic                  s_axi_awready,
  input var         [AXI_ALEN-1:0]  s_axi_awaddr,
  input var         [2:0]           s_axi_awprot,

  input var                         s_axi_wvalid,
  output var logic                  s_axi_wready,
  input var         [AXI_DLEN-1:0]  s_axi_wdata,
  input var         [AXI_SLEN-1:0]  s_axi_wstrb,

  output var logic                  s_axi_bvalid,
  input var                         s_axi_bready,
  output var logic  [1:0]           s_axi_bresp,

  input var                         s_axi_arvalid,
  output var logic                  s_axi_arready,
  input var         [AXI_ALEN-1:0]  s_axi_araddr,
  input var         [2:0]           s_axi_arprot,

  output var logic                  s_axi_rvalid,
  input var                         s_axi_rready,
  output var logic  [AXI_DLEN-1:0]  s_axi_rdata,
  output var logic  [1:0]           s_axi_rresp,

  output var logic  [7:0]           o_led
);


// interface declaration
axi4_lite_if # (
  .ALEN (AXI_ALEN),
  .DLEN (AXI_DLEN)
) s_axi (
  .aclk(aclk),
  .aresetn(aresetn)
);

// connect bd verilog interface to IP
assign s_axi.awvalid = s_axi_awvalid;
assign s_axi_awready = s_axi.awready;
assign s_axi.awaddr = s_axi_awaddr;
assign s_axi.awprot = s_axi_awprot;
assign s_axi.wvalid = s_axi_wvalid;
assign s_axi_wready = s_axi.wready;
assign s_axi.wdata = s_axi_wdata;
assign s_axi.wstrb = s_axi_wstrb;
assign s_axi_bvalid = s_axi.bvalid;
assign s_axi.bready = s_axi_bready;
assign s_axi_bresp = s_axi.bresp;
assign s_axi.arvalid = s_axi_arvalid;
assign s_axi_arready = s_axi.arready;
assign s_axi.araddr = s_axi_araddr;
assign s_axi.arprot = s_axi_arprot;
assign s_axi_rvalid = s_axi.rvalid;
assign s_axi.rready = s_axi_rready;
assign s_axi_rdata = s_axi.rdata;
assign s_axi_rresp = s_axi.rresp;

// IP
nexys_video_gpio # (
  .AXI_ALEN         (AXI_ALEN),
  .AXI_DLEN         (AXI_DLEN),
  .AXI_SLEN         (AXI_SLEN),
  .AXI_BASE_ADDR    (AXI_BASE_ADDR),
  .R_STATUS_OFFSET  (R_STATUS_OFFSET),
  .W_LED_OFFSET     (W_LED_OFFSET)
) u_GPIO (
  .clk    (aclk),
  .rstn   (aresetn),
  .axi    (s_axi),
  .o_led  (o_led)
);


endmodule
