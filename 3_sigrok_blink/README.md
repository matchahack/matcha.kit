# SIGROK Blink

> Here, we want to `press the button` so that you can see a signal on your `logic analyzer`

### windows

> install wsl2

> install vscode

> install apio

> install sigrok

> open vscode wsl2 terminal

> > in wsl2 terminal, open directory

> open powershell

> > `usbipd list`

> > `usbipd attach --wsl --busid <your_device_BUSID>`

> in wsl2 terminal: `make load`

> in sigrok

> > config driver and set to 12MHz

> > `run`

> > press button on breadboard, then press `run` again to see the changes


Then run the following from your terminal:

```
make load
```