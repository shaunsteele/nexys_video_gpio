
# project directory
REPO_DIR = /home/shaun/repos/nexys_video_gpio

# project folders
IP_DIR	:= $(REPO_DIR)/ip
ITF_DIR := $(REPO_DIR)/interfaces
RTL_DIR := $(REPO_DIR)/rtl
SIM_DIR := $(REPO_DIR)/sim/uvm
TCL_DIR := $(REPO_DIR)/tcl

# environments
SRCS += $(SIM_DIR)/env/gpio_env_pkg.sv
SRCS += $(SIM_DIR)/env/gpio_env_config.sv
SRCS += $(SIM_DIR)/env/gpio_env.sv

# tests
SRCS += $(SIM_DIR)/tests/gpio_test_pkg.sv
SRCS += $(SIM_DIR)/tests/gpio_base_test.sv

# interfaces
SRCS += $(ITF_DIR)/axi4_lite_if.sv
SRCS += $(ITF_DIR)/gpio_if.sv

# rtl
SRCS += $(RTL_DIR)/nexys_video_gpio.sv

# testbench top
SRCS += $(SIM_DIR)/tb_top.sv

INCLUDES :=
DEFINES := 

COMP_ARGS += --incr --relax
COMP_ARGS += -L uvm

ELAB_ARGS += -L uvm

SIM_ARGS += -testplusarg UVM_VERBOSITY=UVM_LOW

TOP = tb_top

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
	@echo
	@echo "### SIMULATING ###"
	xsim $(TOP)_snapshot -tclbatch $(TCL_DIR)/xsim_cfg.tcl $(SIM_ARGS)

.elab.timestamp: .comp.timestamp
	@echo
	@echo "### ELABORATING ###"
	xelab -debug all $(ELAB_ARGS) -top $(TOP) -snapshot $(TOP)_snapshot
	touch .elab.timestamp

.comp.timestamp: $(SRCS)
	@echo
	@echo "### COMPILING ###"
	xvlog $(COMP_ARGS) $(INCLUDES) $(DEFINES) --sv $(SRCS)
	touch .comp.timestamp

LINT_RULES += --rules=-line-length

.PHONY: lint
lint:
	verible-verilog-lint $(SRCS) $(LINT_RULES)

.PHONY: clean
clean:
	rm -rf *.jou *.log *.pb *.wdb xsim.dir
	rm -rf .*.timestamp
