// gpio_env.sv

`ifndef __GPIO_ENV
`define __GPIO_ENV

class gpio_env extends uvm_env;

`uvm_component_utils(gpio_env)

// env_config           env_cfg;

// axi_agent            axi_agnt;
// axi_predictor        axi_pred;

// gpio_agent           gpio_agnt;
// axi_gpio_checker     gpio_chk;

function new(string name="gpio_env", uvm_component parent);
  super.new(name, parent);
  `uvm_info("ENV", "constructor", UVM_LOW)
endfunction

function void build_phase(uvm_phase phase);
  // axi_agent_config   axi_cfgg;
  // gpio_agent_config  gpio_cfg;
  // analysis_configs   analysis_cfg;
  
  super.build_phase(phase);

  // create agents and objects

  // get environment configs

endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // connect axi_agnt port to axi_pred export
  // connect axi_pred port to gpio_chk before export
  // connect axi_pred port to gpio_chk after export
endfunction

task run_phase(uvm_phase phase);
  `uvm_info("ENV", "run_phase", UVM_LOW)
endtask

endclass

`endif
