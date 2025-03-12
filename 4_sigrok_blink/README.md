# SIGROK Blink

> Here, we want to `press the button` so that you can see a signal on your `logic analyzer`

### Simulate

> Run:
```
apio sim
```

### Burn to flash

> In wsl-2 terminal: 
```
make load
```

### Observe live signals

> In sigrok

> > Config driver and set to 12MHz

> > `run` button in `GUI`

> > Press button on breadboard, then press `run` again to see the changes

> Run the following from your terminal:

```
make load
```