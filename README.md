# matcha.kit

`Welcome!` Here you can find the guide for the builder kit!

```
 *           *     ,MMM8&&&.       
                  MMMM88&&&&&    .
                 MMMM88&&&&&&&
     *           MMM88&&&&&&&&
                 MMM88&&&&&&&&
                 'MMM88&&&&&&'
                   'MMM8&&&'      *
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

> By the end of this guide, you will be doing `embedded systems signal generation and manipulation on bare metal`

---

## TOOLS

We will try only to use `open-source` tools. The following are OS software we will use to make our hardware designs go `blinky blinky`.

### Binary Building: Install the Toolchain

The installation and build guide [here](https://learn.lushaylabs.com/os-toolchain-manual-installation/) targets our device - the 'Gowin' `FPGA (field programmable gate array)` on-board the TangNano9K. It covers Windows, Mac and Linux in fairly good detail.

Once the reader has installed this successfully, they will be able to design hardware that runs on the FPGA!

> The reader must install this tool on their host computer

### Recording Live Signals: Debugging your Design 

So you have created a binary and it is generating signals on the FPGA to peripheral components! How do you know it's doing what it is supposed to be doing? We need to record the signals - for this we will us the open-source tool [SIGROK](https://sigrok.org/).

Why can't we see the sigals on our laptop monitor without SIGROK? Or debug an issue with an LED on the PCB? Because the signals are between two black boxes! Therefore we must probe the wires between these boxes read the data bus.

> The reader can install this tool on their host computer if they want to build the I2C protocol (reading/writing to OLED display)

---

## INSTRUCTIONS

Follow the tutorials in order! Or don't!

In each subdirectory, there is a `Makefile` which builds the hardware design and loads the resulting binary onto the FPGA. They have all been tested, and do work.

> Once you have completed tutorial `0_blink`...Good job. You are now a **_bare-metal programmer_**. Good luck out there!