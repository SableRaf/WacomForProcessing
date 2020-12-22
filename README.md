# Wacom For Processing

This is an example project showing how to get the data from a Wacom tablet and use it in Processing.

## How it works

We are using Osculator (Mac only) to grab the data from the Wacom driver and send it via OSC to a Processing sketch.

Note: it is possible to use a tablet in Processing directly but this method provides access to the raw data from the driver which is more precise.

## Installing and running

- Clone or download this repository
- Plug your Wacom tablet to your Mac
- Install [Osculator](https://osculator.net/)
- Launch Osculator and open the Intuos3ToProcessing.osc3 configuration file
- Install [Processing](http://processing.org/)
- With Processing, open and run wacomOscReceiverPDE.pde
- Click on the Osculator window and press CAPS-LOCK to lock the mouse and start sending tablet data as osc messages (see the Osculator settings to change the key binding)
- Bring the processing sketch window forward so you can see what you're doing
- Use your pen tablet to draw

![Osculator main window with Intuos3ToProcessing.osc3 loaded](/images/osculatorProcessing.png)

## Limitations

- This has only been tested on a Wacom Intuos 3. OSC message addresses as well as button/slider/ring mappings might be different on other models.
- Osculator only runs on Mac OSX

## TO DO

- Windows support. Possibly via [vvvv](https://betadocs.vvvv.org/topics/io/hardware/graphics-tablets.html) or [WMIDI](http://www.nicolasfournel.com/?page_id=73)