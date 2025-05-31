BOARD=tangnano
FAMILY=GW1NZ-1
DEVICE=GW1NZ-LV1QN48C6/I5
TOP=control

sim:
	iverilog -o ${TOP}_tb ${TOP}_tb.sv ${TOP}.sv
	vvp ${TOP}_tb.sv
	gtkwave ${TOP}_tb.vcd

load:
	yosys -p "read_verilog ${TOP}.sv; synth_gowin -json ${TOP}.json"
	nextpnr-himbaechel --json ${TOP}.json --write ${TOP}.json --device ${DEVICE} --vopt cst=../${BOARD}.cst --vopt family=${FAMILY}
	gowin_pack -d ${DEVICE} -o ${TOP}.fs ${TOP}.json
	openFPGALoader -b ${BOARD}${SIZE} -f --verbose ${TOP}.fs

clean:
	rm ${TOP}_tb ${TOP}_tb.vcd *.fs *.json