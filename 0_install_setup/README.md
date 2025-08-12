# Loading our designs onto the FPGA

For this we need specialised softwares: [this installation and build guide](https://learn.lushaylabs.com/os-toolchain-manual-installation/) targets our device - the 'Gow1n' `FPGA (field programmable gate array)` on-board the TangNano. It covers Windows, Mac and Linux in fairly good detail, and is open source.

If TLDR; Try running the following...

## Installs for the FPGA toolchain in Windows

> Open `Powershell` terminal as admin

> > Install tools: `wsl` for linux-like dev environment, and `usbipd` to tunnel your FPGA programmer through Windows to WSL
```
.\installs_windows.exe
```

> > Attach your USB to Linux through Windows
```
usbipd attach --wsl --busid <your_device_BUSID>
```

> Open a `wsl-2` terminal, and run the Ubuntu script...
```
wsl
```

## Installs for the FPGA toolchain in Linux (Ubuntu)

> > Install all FPGA programming tools
```
chmod a+x *.sh
./installs_linux.sh
chmod a+x *.sh
```

## Installs for the FPGA toolchain in Mac

> > Install all FPGA programming tools
```
chmod a+x *.sh
./installs_mac.sh
chmod a+x *.sh
```

## Installs for Simulation Environment (cocotb + verilator) in Windows
> Open `Powershell` terminal as admin

> > Install `wsl` for linux-like dev environment

> > Open `wsl` terminal and install tools:
```
sudo apt update
sudo apt install make gcc g++ git python3 python3-pip python3-venv verilator
```

> > Create and activate python virtual environment
```
python3 -m venv venv
source venv/bin/activate
```

> > Install cocotb in virtual environment
`pip install cocotb`

## Installs for Simulation Environment (cocotb + verilator) in Linux (Ubuntu)
> > Install all tools:
```
sudo apt update
sudo apt install make gcc g++ git python3 python3-pip python3-venv verilator
```

> > Create and activate python virtual environment
```
python3 -m venv venv
source venv/bin/activate
```

> > Install cocotb in virtual environment
`pip install cocotb`

## Installs for Simulation Environment (cocotb + verilator) in mac

> > Install all tools:
brew install verilator python3

> > Create and activate python virtual environment
```
python3 -m venv venv
source venv/bin/activate
```

> > Install cocotb in virtual environment
`pip install cocotb`

