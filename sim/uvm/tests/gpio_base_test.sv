// gpio_base_test.sv

`ifndef __GPIO_BASE_TEST
`define __GPIO_BASE_TEST

class gpio_base_test extends uvm_test;

`uvm_component_utils(gpio_base_test)

// primary parameters
int     axi_alen = 64;
int     axi_dlen = 64;
longint axi_base_addr = 0;

// environment
gpio_env        env;
gpio_env_config env_cfg;

// constructor
function new(string name="gpio_base_test", uvm_component parent);
  super.new(name, parent);
  `uvm_info("TEST", $sformatf("%s constructor", name), UVM_LOW)
endfunction

// parameter functions
virtual function void set_axi_alen(int axi_alen);
  this.axi_alen = axi_alen;
endfunction

virtual function void set_axi_dlen(int axi_dlen);
  this.axi_dlen = axi_dlen;
endfunction

virtual function void set_axi_base_addr(longint axi_base_addr);
  this.axi_base_addr = axi_base_addr;
endfunction


// build phase
function void build_phase(uvm_phase phase);
  `uvm_info("TEST", "build_phase", UVM_LOW)

  // create objects
  env_cfg = gpio_env_config::type_id::create("env_cfg", this);
  env = gpio_env::type_id::create("env", this);

  // configure
  env_cfg.axi_alen = axi_alen;
  env_cfg.axi_dlen = axi_dlen;
  env_cfg.axi_base_addr = axi_base_addr;

  // set to config_db
  uvm_config_db #(gpio_env_config)::set(this, "env", "env_cfg", env_cfg);
  uvm_config_db #(int)::set(this, "*", "axi_alen", axi_alen);
  uvm_config_db #(int)::set(this, "*", "axi_dlen", axi_dlen);
  uvm_config_db #(longint)::set(this, "*", "axi_base_addr", axi_base_addr);
endfunction

task run_phase(uvm_phase phase);
  // axi_lite_sequence  axil_seq;
  // gpio_sequence      gpio_seq;

  phase.raise_objection(this, "Starting uvm sequence...");
  // axil_seq = axi_lite_sequnce::type_id::create("axil_seq");
  // gpio_seq = gpio_sequence::type_id::create("gpio_seq");

  // fork
    // axil_seq.start(env.axil_agnt.sequencer);
    // gpio_seq.start(env.gpio_agnt.sequencer);
  // join_any

  #1000;
  phase.drop_objection(this);
endtask

endclass

`endif
