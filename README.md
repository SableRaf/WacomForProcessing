# wacomOscReceiver

Get Wacom data from via Osculator (Mac Only) into Processing.

This has only been tested on a Wacom Intuos 3. OSC message addresses as well as button/slider/ring mappings might be different on other models.

## Setup

- Plug your Wacom tablet in your Mac
- Install [Osculator](https://osculator.net/)
- Launch Osculator and open the Intuos3ToProcessing.osc3 configuration file
- Install [Processing](http://processing.org/)
- Open and run wacomOscReceiverPDE.pde
- Click on the Osculator window and press CAPS-LOCK to lock the mouse and start sending tablet data as osc messages

![Settings > Devices > Wacom Tablet](/images/osculatorMouseLock.png)

![Osculator main window with Intuos3ToProcessing.osc3 loaded](/images/osculatorProcessing.png)

## TO DO

- Touch strips support
- Windows support. Possibly via [vvvv](https://betadocs.vvvv.org/topics/io/hardware/graphics-tablets.html) or [WMIDI](http://www.nicolasfournel.com/?page_id=73)