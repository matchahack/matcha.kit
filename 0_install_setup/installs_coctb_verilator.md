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