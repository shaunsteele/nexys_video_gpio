// gpio_env_config.sv

`ifndef __GPIO_ENV_CONFIG
`define __GPIO_ENV_CONFIG

class gpio_env_config extends uvm_object;

`uvm_object_utils(gpio_env_config)

int     axi_alen = 64;
int     axi_dlen = 64;
longint axi_base_addr = 0;

function new(string name="gpio_env_config");
  super.new(name);
  `uvm_info("GPIO_ENV_CFG", "working", UVM_LOW)
endfunction

endclass

`endif
