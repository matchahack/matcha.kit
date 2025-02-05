BOARD=tangnano
FAMILY=GW1NZ-1
DEVICE=GW1NZ-LV1QN48C6/I5

all: control.fs

# Synthesis
control.json: control.v
	yosys -p "read_verilog control.v; synth_gowin -top control -json control.json"

# Place and Route
control_pnr.json: control.json
	nextpnr-gowin --json control.json --freq 27 --write control_pnr.json --device ${DEVICE} --family ${FAMILY} --cst "../${BOARD}.cst"

# Generate Bitstream
control.fs: control_pnr.json
	gowin_pack -d ${FAMILY} -o control.fs control_pnr.json

# Program Board
load: control.fs
	openFPGALoader -b ${BOARD} control.fs -f

clean:
	rm control.fs

.PHONY: load
.INTERMEDIATE: control_pnr.json control.json