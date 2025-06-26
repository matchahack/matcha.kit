sudo apt-get update
sudo apt-get install make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
libffi-dev liblzma-dev git cmake libboost-all-dev libeigen3-dev \
libftdi1-2 libftdi1-dev libhidapi-hidraw0 libhidapi-dev \
libudev-dev zlib1g-dev pkg-config g++ clang bison flex \
gawk tcl-dev graphviz xdot pkg-config zlib1g-dev --y

curl https://pyenv.run | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init -)"\nfi' >> ~/.bashrc

pyenv install 3.9.13
pyenv global 3.9.13

pip install apycula

git clone https://github.com/YosysHQ/yosys.git
cd yosys
make
sudo make install
cd ..

git clone https://github.com/YosysHQ/nextpnr.git
cd nextpnr
cmake . -DARCH=gowin -DGOWIN_BBA_EXECUTABLE=`which gowin_bba`
make
sudo make install
cd ..

git clone https://github.com/trabucayre/openFPGALoader.git
cd openFPGALoader
mkdir build
cd build
cmake ../ 
cmake --build .
sudo make install
cd ..

sudo apt-get install iverilog

sudo apt-get install gtkwave

git clone git@github.com:matchahack/.think_like_a_chip.git