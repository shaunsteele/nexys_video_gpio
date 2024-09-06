// tb_top.sv

`default_nettype none

`include "uvm_macros.svh"

module tb_top;

// import xil_common_vip_pkg::*;
// import axi_vip_pkg::*;

import uvm_pkg::*;
import gpio_env_pkg::*;
import gpio_test_pkg::*;


// clocking
localparam int  HalfClkPeriod = 5;
localparam int  ClkPeriod = HalfClkPeriod * 2;
int             clk_frequency = (10**9)/ClkPeriod;
bit             clk;
initial begin
  clk = 0;
  forever #(HalfClkPeriod) clk = ~clk;
end


// reset
localparam int  ResetCycles = 1;
bit             rstn;
initial begin
  rstn = 0;
  repeat (ResetCycles) @(negedge clk);
  rstn = 1;
end


// interfaces
// axi4_lite_if  tb_axi(.clk(clk), .rstn(rstn));
// axi4_lite_if  vip_axi(.clk(clk), .rstn(rstn));
axi4_lite_if  axi(.aclk(clk), .aresetn(rstn));
gpio_if       gpio();


// passthrough Xilinx AXI VIP
// axi_vip_0 # (
//   .PROTOCOL         ("AXI4LITE"),
//   .INTERFACE_MODE   ("PASS_THROUGH"),
//   .READ_WRITE_MODE  ("READ_WRITE"),
//   .ADDR_WIDTH       (64),
//   .DATA_WIDTH       (64),
//   .HAS_PROT         (0)
// ) u_AXI (
//   .aclk           (clk),
//   .aresetn        (rstn),
//   .s_axi_awaddr   (tb_axi.awaddr),
//   .s_axi_awvalid  (tb_axi.awvalid),
//   .s_axi_awready  (tb_axi.awready),
//   .s_axi_wdata    (tb_axi.wdata),
//   .s_axi_wstrb    (tb_axi.wstrb),
//   .s_axi_wvalid   (tb_axi.wvalid),
//   .s_axi_wready   (tb_axi.wready),
//   .s_axi_bresp    (tb_axi.bresp),
//   .s_axi_bvalid   (tb_axi.bvalid),
//   .s_axi_bready   (tb_axi.bready),
//   .s_axi_araddr   (tb_axi.araddr),
//   .s_axi_arvalid  (tb_axi.arvalid),
//   .s_axi_arready  (tb_axi.arready),
//   .s_axi_rdata    (tb_axi.rdata),
//   .s_axi_rresp    (tb_axi.rresp),
//   .s_axi_rvalid   (tb_axi.rvalid),
//   .s_axi_rready   (tb_axi.rready),
//   .m_axi_awaddr   (vip_axi.awaddr),
//   .m_axi_awvalid  (vip_axi.awvalid),
//   .m_axi_awready  (vip_axi.awready),
//   .m_axi_wdata    (vip_axi.wdata),
//   .m_axi_wstrb    (vip_axi.wstrb),
//   .m_axi_wvalid   (vip_axi.wvalid),
//   .m_axi_wready   (vip_axi.wready),
//   .m_axi_bresp    (vip_axi.bresp),
//   .m_axi_bvalid   (vip_axi.bvalid),
//   .m_axi_bready   (vip_axi.bready),
//   .m_axi_araddr   (vip_axi.araddr),
//   .m_axi_arvalid  (vip_axi.arvalid),
//   .m_axi_arready  (vip_axi.arready),
//   .m_axi_rdata    (vip_axi.rdata),
//   .m_axi_rresp    (vip_axi.rresp),
//   .m_axi_rvalid   (vip_axi.rvalid),
//   .m_axi_rready   (vip_axi.rready)
// );


// DUT
nexys_video_gpio u_DUT (
  .clk    (clk),
  .rstn   (rstn),
  // .axi    (vip_axi),
  .axi    (axi),
  .o_led  (gpio.led)
);


// Start Tests
initial begin
  // initialize interface signals
  axi.awvalid = 0;
  axi.awaddr = {(axi.ALEN){1'b1}};
  axi.wvalid = 0;
  axi.wdata = 0;
  axi.wstrb = 0;
  axi.bready = 0;
  axi.arvalid = 0;
  axi.araddr = {(axi.ALEN){1'b1}};
  axi.rready = 0;

  // add values to config_db
  // uvm_config_db #(virtual axi4_lite_if)::set(null, "*", "axi", tb_axi);
  uvm_config_db #(virtual axi4_lite_if)::set(null, "*", "axi", axi);
  uvm_config_db #(virtual gpio_if)::set(null, "*", "gpio", gpio);

  // run tests
  run_test("gpio_base_test");
end


endmodule
