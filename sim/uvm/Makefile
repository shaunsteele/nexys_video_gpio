
REPO_DIR = /home/shaun/repos/nexys_video_gpio

PKG_DIR := $(REPO_DIR)/packages
IP_DIR	:= $(REPO_DIR)/ip
ITF_DIR := $(REPO_DIR)/interfaces
RTL_DIR := $(REPO_DIR)/rtl
SIM_DIR := $(REPO_DIR)/sim/uvm
TCL_DIR := $(REPO_DIR)/tcl

SRCS += $(SIM_DIR)/tb_uart_pkg.sv

# SRCS += $(SIM_DIR)/uart_seq_item.sv
# SRCS += $(SIM_DIR)/uart_sequence.sv
# SRCS += $(SIM_DIR)/axi4_lite_driver.sv
# SRCS += $(SIM_DIR)/axi4_lite_monitor.sv
# SRCS += $(SIM_DIR)/axi4_lite_agent.sv
# SRCS += $(SIM_DIR)/uart_scoreboard.sv
# SRCS += $(SIM_DIR)/uart_env.sv
# SRCS += $(SIM_DIR)/uart_test.sv

SRCS += $(ITF_DIR)/axi4_lite_if.sv

SRCS += $(RTL_DIR)/nexys_video_gpio.sv

SRCS += $(SIM_DIR)/tb_nexys_video_gpio_top.sv

COMP_ARGS += --incr --relax
COMP_ARGS += -L uvm

ELAB_ARGS += -L uvm
ELAB_ARGS += -L axi_vip_0_0

SIM_ARGS += -testplusarg UVM_VERBOSITY=UVM_LOW

DEFINES := 

TOP = tb_uart_top

.PHONY: simulate
simulate: $(TOP)_snapshot.wdb

.PHONY: elaborate
elaborate: .elab.timestamp

.PHONY: compile
compile: .comp.timestamp

.PHONY: waves
waves:
	gtkwave dump.vcd

$(TOP)_snapshot.wdb: .elab.timestamp
	xsim $(TOP)_snapshot -tclbatch $(TCL_DIR)/xsim_cfg.tcl $(SIM_ARGS)

.elab.timestamp: .comp.timestamp
	xelab -debug all $(ELAB_ARGS) -top $(TOP) -snapshot $(TOP)_snapshot
	touch .elab.timestamp

.comp.timestamp: $(SRCS)
	xvlog $(COMP_ARGS) $(DEFINES) --sv $(SRCS)
	touch .comp.timestamp

LINT_RULES += --rules=-line-length

.PHONY: lint
lint:
	verible-verilog-lint $(SRCS) $(LINT_RULES)

.PHONY: clean
clean:
	rm -rf *.jou *.log *.pb *.wdb xsim.dir
	rm -rf .*.timestamp
