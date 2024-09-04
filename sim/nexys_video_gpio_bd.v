// nexys_video_gpio_bd.v

`default_nettype none

module nexys_video_gpio_bd # (
  parameter integer                 AXI_ALEN = 64,
  parameter integer                 AXI_DLEN = 64,
  parameter integer                 AXI_SLEN = AXI_DLEN / 8,
  parameter reg     [AXI_ALEN-1:0]  AXI_BASE_ADDR = 0,
  parameter reg     [AXI_ALEN-1:0]  R_STATUS_OFFSET = 0,
  parameter reg     [AXI_ALEN-1:0]  W_LED_OFFSET = 0
)(
  input wire                   aclk,
  input wire                   aresetn,

  input wire                   s_axi_awvalid,
  output wire                 s_axi_awready,
  input wire   [AXI_ALEN-1:0]  s_axi_awaddr,
  input wire   [2:0]           s_axi_awprot,

  input wire                   s_axi_wvalid,
  output wire                 s_axi_wready,
  input wire   [AXI_DLEN-1:0]  s_axi_wdata,
  input wire   [AXI_SLEN-1:0]  s_axi_wstrb,

  output wire                 s_axi_bvalid,
  input wire                   s_axi_bready,
  output wire [1:0]           s_axi_bresp,

  input wire                   s_axi_arvalid,
  output wire                 s_axi_arready,
  input wire   [AXI_ALEN-1:0]  s_axi_araddr,
  input wire   [2:0]           s_axi_arprot,

  output wire                 s_axi_rvalid,
  input wire                   s_axi_rready,
  output wire [AXI_DLEN-1:0]  s_axi_rdata,
  output wire [1:0]           s_axi_rresp,

  output wire [7:0]           o_led
);


nexys_video_gpio_bd_conn # (
  .AXI_ALEN         (AXI_ALEN),
  .AXI_DLEN         (AXI_DLEN),
  .AXI_SLEN         (AXI_SLEN),
  .AXI_BASE_ADDR    (AXI_BASE_ADDR),
  .R_STATUS_OFFSET  (R_STATUS_OFFSET),
  .W_LED_OFFSET     (W_LED_OFFSET)
) u_BD_CONN (
  .aclk       (aclk),
  .aresetn    (aresetn),
  .s_axi_awvalid  (s_axi_awvalid),
  .s_axi_awready  (s_axi_awready),
  .s_axi_awaddr   (s_axi_awaddr),
  .s_axi_awprot   (s_axi_awprot),
  .s_axi_wvalid   (s_axi_wvalid),
  .s_axi_wready   (s_axi_wready),
  .s_axi_wdata    (s_axi_wdata),
  .s_axi_wstrb    (s_axi_wstrb),
  .s_axi_bvalid   (s_axi_bvalid),
  .s_axi_bready   (s_axi_bready),
  .s_axi_bresp    (s_axi_bresp),
  .s_axi_arvalid  (s_axi_arvalid),
  .s_axi_arready  (s_axi_arready),
  .s_axi_araddr   (s_axi_araddr),
  .s_axi_arprot   (s_axi_arprot),
  .s_axi_rvalid   (s_axi_rvalid),
  .s_axi_rready   (s_axi_rready),
  .s_axi_rdata    (s_axi_rdata),
  .s_axi_rresp    (s_axi_rresp),
  .o_led          (o_led)
);

endmodule
