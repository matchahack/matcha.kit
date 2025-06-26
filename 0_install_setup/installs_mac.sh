/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install pyenv
pyenv install 3.9.13
pyenv global 3.9.13

pip install apycula

brew install yosys
brew install cmake
brew install eigen

git clone https://github.com/YosysHQ/nextpnr.git
cd nextpnr
cmake . -DARCH=gowin -DGOWIN_BBA_EXECUTABLE=`which gowin_bba` -DPYTHON_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")  \
-DPYTHON_LIBRARY=$(python3 -c "import distutils.sysconfig as sysconfig;import os;  print(os.path.join(sysconfig.get_config_var('LIBDIR'), [f for f in os.listdir(sysconfig.get_config_var('LIBDIR')) if f.endswith('.dylib') or f.endswith('.a')][0]))")
make
sudo make install
cd ..

brew install openfpgaloader

brew install icarus-verilog

brew install --cask gtkwave

git clone git@github.com:matchahack/.think_like_a_chip.git