BOARD=tangnano
FAMILY=GW1NZ-1
DEVICE=GW1NZ-LV1QN48C6/I5
TOP=control

# Cocotb + Verilator
TOPLEVEL_LANG = verilog
VERILATOR = verilator
TOPLEVEL = control    
MODULE = control_tb      
SIM = verilator
VERILOG_SOURCES = $(shell pwd)/control.sv
EXTRA_ARGS += --trace --trace-structs

sim:
	make -f $(shell cocotb-config --makefiles)/Makefile.sim \
		TOPLEVEL=$(TOPLEVEL) \
		MODULE=$(MODULE) \
		VERILOG_SOURCES="$(VERILOG_SOURCES)" \
		SIM=$(SIM) \
		EXTRA_ARGS="${EXTRA_ARGS}"
	gtkwave dump.vcd

sim_iverilog:
	iverilog -o ${TOP}_tb ${TOP}_tb.sv ${TOP}.sv
	vvp ${TOP}_tb
	gtkwave ${TOP}_tb.vcd

load:
	yosys -p "read_verilog ${TOP}.sv; synth_gowin -json ${TOP}.json"
	nextpnr-himbaechel --json ${TOP}.json --write ${TOP}.json --device ${DEVICE} --vopt cst=../${BOARD}.cst --vopt family=${FAMILY}
	gowin_pack -d ${DEVICE} -o ${TOP}.fs ${TOP}.json
	openFPGALoader -b ${BOARD}${SIZE} -f --verbose ${TOP}.fs

clean:
	rm ${TOP}_tb ${TOP}_tb.vcd *.fs *.json *.vcd