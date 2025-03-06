# INSTALL

## DEPENDENCIES

We will try only to use `open-source` tools. The following are the OS software we will use to make our hardware designs go `blinky blinky`.

> Note that you will need some basic `linunx terminal` skills to follow this course! I can recommend [the official linux command line guide](https://ubuntu.com/tutorials/command-line-for-beginners) for anyone wanting to upskill

## FPGA Toolchain

We want to load our designs onto the FPGA.

For this we need specialised softwares: [this installation and build guide](https://learn.lushaylabs.com/os-toolchain-manual-installation/) targets our device - the 'Gow1n' `FPGA (field programmable gate array)` on-board the TangNano. It covers Windows, Mac and Linux in fairly good detail, and is open source.

> The reader must install this tool on their computer

## Debugging 

From tutorial 3 onward, you will be creating designs on the FPGA that are generating signals off the board! How do you know it's doing what it is supposed to be doing? 

For this, we need to record the signals it generates - and so we will [install another open source tool: sigrok](https://sigrok.org/wiki/Downloads).

> The reader can install this tool on their host computer if they want to build the I2C protocol (reading/writing to OLED display)
