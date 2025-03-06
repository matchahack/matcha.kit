# matcha.kit

`Welcome!` Here you can find the guide for the builder kit!

![assemble_on](https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExZG03dXprbDFncHR0b283YXhkZHppbDZ2amphNTBnYzI3cTV6MXh3aSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/hNv3CRdwO8kyjTxfh5/giphy.gif)

> By the end of this guide, you will be doing `embedded systems signal generation and manipulation on bare metal`

> Note that although `this whole kit _is_ open source`, you can also buy it in one go [here](https://matchahack.bigcartel.com/product/matcha-kit) for your convenience (or if you want to help the project grow!)
---

## INSTALL DEPENDENCIES

We will try only to use `open-source` tools. The following are the OS software we will use to make our hardware designs go `blinky blinky`.

> Note that you will need some basic `linunx terminal` skills to follow this course! I can recommend [the official linux command line guide](https://ubuntu.com/tutorials/command-line-for-beginners) for anyone wanting to upskill

#### Install the Toolchain

We want to load our designs onto the FPGA.

For this we need specialised softwares: [this installation and build guide](https://learn.lushaylabs.com/os-toolchain-manual-installation/) targets our device - the 'Gow1n' `FPGA (field programmable gate array)` on-board the TangNano. It covers Windows, Mac and Linux in fairly good detail, and is open source.

> The reader must install this tool on their computer

#### Debugging Programs 

From tutorial 3 onward, you will be creating designs on the FPGA that are generating signals off the board! How do you know it's doing what it is supposed to be doing? 

For this, we need to record the signals it generates - and so we will [install another open source tool: sigrok](https://sigrok.org/wiki/Downloads).

> The reader can install this tool on their host computer if they want to build the I2C protocol (reading/writing to OLED display)

---

## RUN THE TUTORIALS

There is a `README.md` to follow in the tutorials. You can follow in order! Or not! Up to you.

In each subdirectory, there is a `Makefile` which builds the hardware design and loads the resulting binary onto the FPGA. They have all been tested, and do work.

> Once you have completed tutorial `0_blink`...Good job. You are now a **_bare-metal programmer_**. Good luck out there, and feel free to drop by the [discord](https://discord.com/channels/1320785628333346836/1321062900311396362) if you have questions!

```
 *           ⭐    ,MMM8&&&.       
                  MMMM88&&&&&    .
                 MMMM88&&&&&&&
     ⭐         MMMM88&&&&&&&&
                 MMM88&&&&&&&&
                 'MMM88&&&&&&'
                   'MMM8&&&'      ⭐
          |\___/|
          )     (             .    
         =\     /=
           )===(       *
          /     \
          |     |
         /       \
         \       /
  _/\_/\_/\__  _/_/\_/\_/\_/\_/\_
  |  |  |  |( (  |  |  |  |  |  |
  |  |  |  | ) ) |  |  |  |  |  |
  |  |  |  |(_(  |  |  |  |  |  |
  |  |  |  |  |  |  |  |  |  |  |
  |  |  |  |  |  |  |  |  |  |  |
```