// gpio_if.sv

`default_nettype none

interface gpio_if # (
  parameter int LED_LEN = 8
);

logic [LED_LEN-1:0] led;

endinterface
