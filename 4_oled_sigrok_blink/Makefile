BOARD=tangnano9k
FAMILY=GW1N-9C
DEVICE=GW1NR-LV9QN88PC6/I5

all: control.fs

# Synthesis
control.json: control.v
	yosys -p "read_verilog control.v; synth_gowin -top control -json control.json"

# Place and Route
control_pnr.json: control.json
	nextpnr-gowin --json control.json --freq 27 --write control_pnr.json --device ${DEVICE} --family ${FAMILY} --cst ${BOARD}.cst

# Generate Bitstream
control.fs: control_pnr.json
	gowin_pack -d ${FAMILY} -o control.fs control_pnr.json

# Program Board
load: control.fs
	openFPGALoader -b ${BOARD} control.fs -f

verify:
	apio verify
	make clean

sim:
	apio sim
	make clean

clean:
	rm .sconsign.dblite *.out *.vcd *.history *.json *.gtkw *.asc *.bin control.fs

.PHONY: load
.INTERMEDIATE: control_pnr.json control.json