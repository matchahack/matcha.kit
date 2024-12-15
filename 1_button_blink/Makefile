BOARD=tangnano9k
FAMILY=GW1N-9C
DEVICE=GW1NR-LV9QN88PC6/I5

all: button_blink.fs

# Synthesis
button_blink.json: button_blink.v
	yosys -p "read_verilog button_blink.v; synth_gowin -top button_blink -json button_blink.json"

# Place and Route
button_blink_pnr.json: button_blink.json
	nextpnr-gowin --json button_blink.json --freq 27 --write button_blink_pnr.json --device ${DEVICE} --family ${FAMILY} --cst ${BOARD}.cst

# Generate Bitstream
button_blink.fs: button_blink_pnr.json
	gowin_pack -d ${FAMILY} -o button_blink.fs button_blink_pnr.json

# Program Board
load: button_blink.fs
	openFPGALoader -b ${BOARD} button_blink.fs -f

.PHONY: load
.INTERMEDIATE: button_blink_pnr.json button_blink.json