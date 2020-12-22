import oscP5.*;
import netP5.*;

class WacomOscManager {

  OscP5 oscP5;
  NetAddress myRemoteLocation;

  String oscPlugMethodName = "test";
  String oscAddress = "/test";

  final int TABLET_INDEX = 1;

  int penCount = 3; // there is only one pen but osculator switches the index from 0 to 2 sometimes
  int keyCount = 8;

  float strip1Value, strip2Value;

  boolean isWriting = false;

  Pen pen;

  Object parent;

  WacomOscManager(String theAddress, int theInPort, int theOutPort) {
    parent = this;
    initOsc(parent, theAddress, theInPort, theOutPort);
    pen = new Pen();
    pen.x = width/2;
    pen.y = height/2;
  }

  void initOsc(Object theParent, String theAddress, int theInPort, int theOutPort) {
    /* start oscP5, listening for incoming messages at port 12000 */
    this.oscP5 = new OscP5(theParent, theInPort);

    /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
     * an ip address and a port number. myRemoteLocation is used as parameter in
     * oscP5.send() when sending osc packets to another computer, device, 
     * application. usage see below. for testing purposes the listening port
     * and the port of the remote location address are the same, hence you will
     * send messages back to this sketch.
     */
    myRemoteLocation = new NetAddress(theAddress, theOutPort);
  }
  
  
  

  /********************************************/
  /*             PLUG INTUOS 3                */
  /********************************************/

  void plugIntuos3() {
    println("Entered plugIntuos3()");

    /* TEST */
    this.oscPlugMethodName = "test";
    this.oscAddress = "/test";
    this.oscP5.plug(parent, oscPlugMethodName, oscAddress);

    println("");

    String oscTabletAddr = "wacom";
    String oscPenAddr = "pen";
    String oscEraserAddr = "eraser";
    String oscButtonAddr = "button";
    String oscProximityAddr = "proximity";
    String oscStripAddr = "strip";

    for (int i=0; i<penCount; i++) { // there is only one pen but osculator switches the index from 0 to 2 sometimes

      /* PEN */
      oscPlugMethodName = "pen";
      oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscPenAddr + "/" + i; // for example: "/wacom/1/pen/0"
      oscP5.plug(parent, oscPlugMethodName, oscAddress);

      /* PEN PROXIMITY */
      oscPlugMethodName = "penProximity";
      oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscPenAddr + "/" + i + "/" + oscProximityAddr; // "/wacom/1/pen/0/proximity"
      oscP5.plug(parent, oscPlugMethodName, oscAddress);

      /*  TIP */
      oscPlugMethodName = "penButton1";
      oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscPenAddr + "/" + i + "/" + oscButtonAddr + "/" + 1; // "/wacom/1/pen/0/button/1"
      oscP5.plug(parent, oscPlugMethodName, oscAddress);

      /*  DUOSWITCH */      // pen buttons 2 and 3 are the grip buttons (aka DuoSwitch)
      oscPlugMethodName = "penButton2";
      oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscPenAddr + "/" + i + "/" + oscButtonAddr + "/" + 2; // "/wacom/1/pen/0/button/2"
      oscP5.plug(parent, oscPlugMethodName, oscAddress);
      oscPlugMethodName = "penButton3";
      oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscPenAddr + "/" + i + "/" + oscButtonAddr + "/" + 3; // "/wacom/1/pen/0/button/2"
      oscP5.plug(parent, oscPlugMethodName, oscAddress);

      /* ERASER */
      oscPlugMethodName = "eraser";
      oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscEraserAddr + "/" + i; // for example: "wacom/1/eraser/0"
      oscP5.plug(parent, oscPlugMethodName, oscAddress);

      /* ERASER TIP */
      oscPlugMethodName = "eraserButton1";
      oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscEraserAddr + "/" + i + "/" + oscButtonAddr + "/" + 1; // "wacom/1/eraser/0/button/1"
      oscP5.plug(parent, oscPlugMethodName, oscAddress);

      /* ERASER PROXIMITY */
      oscPlugMethodName = "eraserProximity";
      oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscEraserAddr + "/" + i + "/" + oscProximityAddr; // For example "/wacom/1/eraser/0/proximity"
      oscP5.plug(parent, oscPlugMethodName, oscAddress);

      for (int j=0; j<5; j++) {
        oscPlugMethodName = "doNothing";

        oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscPenAddr + "/" + i + "/" + j; // For example "/wacom/1/pen/0/2"
        oscP5.plug(parent, oscPlugMethodName, oscAddress);

        oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscEraserAddr + "/" + i + "/" + j; // For example "/wacom/1/eraser/0/2"
        oscP5.plug(parent, oscPlugMethodName, oscAddress);
      }

      println("");
    }

    /* EXPRESS KEYS */
    for (int i=1; i<=keyCount; i++) {
      oscPlugMethodName = "key"+i;
      String oscKeyAddr = "key" + "/" + i;
      oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscKeyAddr; // for example: "/wacom/1/key/8"
      oscP5.plug(parent, oscPlugMethodName, oscAddress);
    }

    /*  TOUCH STRIPS */
    oscPlugMethodName = "strip1";
    oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscStripAddr + "/" + 1; // "/wacom/1/strip/1"
    oscP5.plug(parent, oscPlugMethodName, oscAddress);
    oscPlugMethodName = "strip2";
    oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscStripAddr + "/" + 2; // "/wacom/1/strip/2"
    oscP5.plug(parent, oscPlugMethodName, oscAddress);
  }

  void sendTestMessage() {
    /* createan osc message with address pattern /test */
    OscMessage myMessage = new OscMessage("/test");
    myMessage.add(mouseX); /* add an int to the osc message */
    myMessage.add(mouseY); /* add a second int to the osc message */

    /* send the message */
    oscP5.send(myMessage, myRemoteLocation);
  }

  /********************************************/
  /*             PLUG METHODS                 */
  /********************************************/
  // Catch events from OscP5

  /* DISCARD */  // explicitely capture unused osc messages
  public void doNothing() {
    println("doing nothing");
  }

  /* TEST */
  public void test(int theA, int theB) {
    print("plug event method test()");
    println(" | 2 ints received: "+theA+", "+theB);
  }

  /* PEN */
  public void pen(float x, float y, float tiltX, float tiltY, float pressure) {
    if (this.isWriting) {
      addPoint(x, y);
    }
    this.pen.x = x;
    this.pen.y = y;
    this.pen.tiltX = tiltX;
    this.pen.tiltY = tiltY;
    this.pen.pressure = pressure;
    //println("plug event method pen()");
    //println("x: "+x+", y: "+y+", tiltX: "+tiltX+", tiltY: "+tiltY+", pressure: "+pressure);
  }

  /* PEN PROXIMITY */
  public void penProximity(float proximity) {
    //println("plug event method penProximity() | " + "proximity: "+ proximity);
    if (proximity == 1.0) penDetected(PenSide.TIP);
    else if (proximity == 0.0) penLost();
  }

  /* TIP */
  public void penButton1(float btn) {
    int k = 9;
    if (btn == 1.0) buttonPressed(k);
    else if (btn == 0.0) buttonReleased(k);
  }

  /* DUOSWITCH */
  public void penButton2(float btn) {
    int k = 10;
    if (btn == 1.0) buttonPressed(k);
    else if (btn == 0.0) buttonReleased(k);
  }
  public void penButton3(float btn) {
    int k = 11;
    if (btn == 1.0) buttonPressed(k);
    else if (btn == 0.0) buttonReleased(k);
  }

  /* ERASER */
  public void eraser(float x, float y, float tiltX, float tiltY, float pressure) {
    //println("plug event method eraser()");
    //println("x: "+x+", y: "+y+", tiltX: "+tiltX+", tiltY: "+tiltY+", pressure: "+pressure);
  }

  public void eraserButton1(float btn) {
    int k = 12;
    if (btn == 1.0) buttonPressed(k);
    else if (btn == 0.0) buttonReleased(k);
  }

  /* ERASER PROXIMITY */
  public void eraserProximity(float proximity) {
    //println("plug event method eraserProximity() | " + "proximity: "+ proximity);
    if (proximity == 1.0) penDetected(PenSide.ERASER);
    else if (proximity == 0.0) penLost();
  }

  /* EXPRESS KEYS */
  public void key1(float btn) {
    int k = 1;
    if (btn == 1.0) buttonPressed(k);
    else if (btn == 0.0) buttonReleased(k);
  }
  public void key2(float btn) {
    int k = 2;
    if (btn == 1.0) buttonPressed(k);
    else if (btn == 0.0) buttonReleased(k);
  }
  public void key3(float btn) {
    int k = 3;
    if (btn == 1.0) buttonPressed(k);
    else if (btn == 0.0) buttonReleased(k);
  }
  public void key4(float btn) {
    int k = 4;
    if (btn == 1.0) buttonPressed(k);
    else if (btn == 0.0) buttonReleased(k);
  }
  public void key5(float btn) {
    int k = 5;
    if (btn == 1.0) buttonPressed(k);
    else if (btn == 0.0) buttonReleased(k);
  }
  public void key6(float btn) {
    int k = 6;
    if (btn == 1.0) buttonPressed(k);
    else if (btn == 0.0) buttonReleased(k);
  }
  public void key7(float btn) {
    int k = 7;
    if (btn == 1.0) buttonPressed(k);
    else if (btn == 0.0) buttonReleased(k);
  }
  public void key8(float btn) {
    int k = 8;
    if (btn == 1.0) buttonPressed(k);
    else if (btn == 0.0) buttonReleased(k);
  }

  public void strip1(float value, float btn) {
    this.strip1Value = value;
    int k = 13;
    if (btn == 1.0) buttonPressed(k);
    else if (btn == 0.0) buttonReleased(k);
  }

  public void strip2(float value, float btn) {
    this.strip2Value = value;
    int k = 14;
    if (btn == 1.0) buttonPressed(k);
    else if (btn == 0.0) buttonReleased(k);
  }
}


/********************************************/
/*               OSC EVENT                  */
/********************************************/

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* with theOscMessage.isPlugged() you check if the osc message has already been
   * forwarded to a plugged method. if theOscMessage.isPlugged()==true, it has already 
   * been forwared to another method in your sketch. theOscMessage.isPlugged() can 
   * be used for double posting but is not required.
   */
  if (theOscMessage.isPlugged()==false) {
    /* print the address pattern and the typetag of the received OscMessage */
    //println("### received an osc message.");
    //println("### addrpattern\t"+theOscMessage.addrPattern());
    //println("### typetag\t"+theOscMessage.typetag());
  }
}
