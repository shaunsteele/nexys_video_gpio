// tb_nexys_video_gpio.sv

`default_nettype none

module tb_nexys_video_gpio;

import axi_vip_pkg::*;
import design_1_axi_vip_0_0_pkg::*;

bit clk;
initial begin
  clk = 0;
  #5;
  forever #5 clk = ~clk;
end

bit rstn;
initial begin
  rstn = 0;
  #100;
  rstn = 1;
end

logic [7:0] ld;

design_1_axi_vip_0_0_mst_t  master_agent;
xil_axi_prot_t prot = 0;
xil_axi_resp_t resp;

design_1 u_D1 (
  .aclk     (clk),
  .aresetn  (rstn),
  .LD       (ld)
);

initial begin
  u_D1.axi_vip_0.inst.IF.set_xilinx_reset_check_to_warn();
  master_agent = new("master vip agent", u_D1.axi_vip_0.inst.IF);

  master_agent.start_master();

  #200;
  master_agent.AXI4LITE_WRITE_BURST(0, prot, 64'hAA, resp);

  #800;
  $finish;
end

endmodule
