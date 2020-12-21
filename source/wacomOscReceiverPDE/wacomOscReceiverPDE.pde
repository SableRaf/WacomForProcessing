/**
 * oscP5plug by andreas schlegel
 * example shows how to use the plug service with oscP5.
 * the concept of the plug service is, that you can
 * register methods in your sketch to which incoming 
 * osc messages will be forwareded automatically without 
 * having to parse them in the oscEvent method.
 * that a look at the example below to get an understanding
 * of how plug works.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

final int TABLET_INDEX = 1;

int penCount = 3; // there is only one pen but osculator switches the index from 0 to 2 sometimes
int keyCount = 8;

String oscPlugMethodName = "test";
String oscAddress = "/test";

float penX, penY, penTiltX, penTiltY, penPressure;
float prevPenX, prevPenY;

boolean isWriting = false;

interface Btn {
  int
  L1 = 1,
  L2 = 2,
  L3 = 3,
  L4 = 4,
  R1 = 5,
  R2 = 6,
  R3 = 7,
  R4 = 8,
  TIP = 9,
  SWITCH_BOTTOM = 10,
  SWITCH_TOP = 11,
  ERASER_TIP = 12;
}

/********************************************/
/*                   SETUP                  */
/********************************************/

void setup() {
  //size(210, 162); // My Intuos 3 has a drawing area of 210 x 162 mm 
  size(735,567);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1",12000);


  penX = width/2;
  penY = height/2;
  prevPenX = penX;
  prevPenY = penY;

  /* osc plug service
   * osc messages with a specific address pattern can be automatically
   * forwarded to a specific method of an object. in this example 
   * a message with address pattern /test will be forwarded to a method
   * test(). below the method test takes 2 arguments - 2 ints. therefore each
   * message with address pattern /test and typetag ii will be forwarded to
   * the method test(int theA, int theB)
   */
  println("");

  oscP5.plug(this, oscPlugMethodName, "/test");

  String oscTabletAddr = "wacom";
  String oscPenAddr = "pen";
  String oscEraserAddr = "eraser";
  String oscButtonAddr = "button";
  String oscProximityAddr = "proximity";

  println("");

  for (int i=0; i<penCount; i++) { // there is only one pen but osculator switches the index from 0 to 2 sometimes
    
    /* PEN */
    oscPlugMethodName = "pen";
    oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscPenAddr + "/" + i; // for example: "/wacom/1/pen/0"
    oscP5.plug(this, oscPlugMethodName, oscAddress);
    
    /* PEN PROXIMITY */
    oscPlugMethodName = "penProximity";
    oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscPenAddr + "/" + i + "/" + oscProximityAddr; // "/wacom/1/pen/0/proximity"
    oscP5.plug(this, oscPlugMethodName, oscAddress);
    
    /*  TIP */
    oscPlugMethodName = "penButton1";
    oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscPenAddr + "/" + i + "/" + oscButtonAddr + "/" + 1; // "/wacom/1/pen/0/button/1"
    oscP5.plug(this, oscPlugMethodName, oscAddress);
    
    /*  DUOSWITCH */ // pen buttons 2 and 3 are the grip buttons (aka DuoSwitch)
    oscPlugMethodName = "penButton2";
    oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscPenAddr + "/" + i + "/" + oscButtonAddr + "/" + 2; // "/wacom/1/pen/0/button/2"
    oscP5.plug(this, oscPlugMethodName, oscAddress);
    oscPlugMethodName = "penButton3";
    oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscPenAddr + "/" + i + "/" + oscButtonAddr + "/" + 3; // "/wacom/1/pen/0/button/2"
    oscP5.plug(this, oscPlugMethodName, oscAddress);

    /* ERASER */
    oscPlugMethodName = "eraser";
    oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscEraserAddr + "/" + i; // for example: "wacom/1/eraser/0"
    oscP5.plug(this, oscPlugMethodName, oscAddress);
    
    /* ERASER TIP */
    oscPlugMethodName = "eraserButton1";
    oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscEraserAddr + "/" + i + "/" + oscButtonAddr + "/" + 1; // "wacom/1/eraser/0/button/1"
    oscP5.plug(this, oscPlugMethodName, oscAddress);
    
    /* ERASER PROXIMITY */
    oscPlugMethodName = "eraserProximity";
    oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscEraserAddr + "/" + i + "/" + oscProximityAddr; // For example "/wacom/1/eraser/0/proximity"
    oscP5.plug(this, oscPlugMethodName, oscAddress);
    
    for(int j=0; j<5; j++) {
      oscPlugMethodName = "doNothing";
      
      oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscPenAddr + "/" + i + "/" + j; // "/wacom/1/pen/0/2"
      oscP5.plug(this, oscPlugMethodName, oscAddress);
      
      oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscEraserAddr + "/" + i + "/" + j; // "/wacom/1/eraser/0/2"
      oscP5.plug(this, oscPlugMethodName, oscAddress);
    }

    println("");
  }

  /* EXPRESS KEYS */
  for (int i=1; i<=keyCount; i++) {
    oscPlugMethodName = "key"+i;
    String oscKeyAddr = "key" + "/" + i;
    oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscKeyAddr; // for example: "/wacom/1/key/8"
    oscP5.plug(this, oscPlugMethodName, oscAddress);
  }  
}

/********************************************/
/*                   DRAW                   */
/********************************************/

void draw() {
  if(!isWriting) background(0);
  stroke(255);
  strokeWeight(2);
  line(prevPenX*width, (1.0-prevPenY)*height, penX*width, (1.0-penY)*height);
  prevPenX = penX;
  prevPenY = penY;
}


/********************************************/
/*             EVENT HANDLERS               */
/********************************************/

public void buttonPressed(int btnIndex) {
  println("button " + btnIndex + " pressed");
  switch (btnIndex) {
    case Btn.L1:
      break;
    case Btn.L2:
      break;
    case Btn.L3:
      break;
    case Btn.L4:
      break;
    case Btn.R1:
      break;
    case Btn.R2:
      break;
    case Btn.R3:
      break;
    case Btn.R4:
      break;
    case Btn.TIP: 
      isWriting = true;
      break;
    case Btn.SWITCH_BOTTOM:
      break;
    case Btn.SWITCH_TOP:
      break;
    case Btn.ERASER_TIP:
      break;
    default:
      println("invalid button index: " + btnIndex);
  }
}

public void buttonReleased(int btnIndex) {
  println("button " + btnIndex + " released");
  switch (btnIndex) {
    case Btn.L1:
      break;
    case Btn.L2:
      break;
    case Btn.L3:
      break;
    case Btn.L4:
      break;
    case Btn.R1:
      break;
    case Btn.R2:
      break;
    case Btn.R3:
      break;
    case Btn.R4:
      break;
    case Btn.TIP:
      isWriting = false;
      break;
    case Btn.SWITCH_BOTTOM:
      break;
    case Btn.SWITCH_TOP:
      break;
    case Btn.ERASER_TIP:
      break;
    default:
      println("invalid button index: " + btnIndex);
  }
}

public void penDetected() {
  println("penDetected()");
}
public void penLost() {
  println("penLost()");
}

public void eraserDetected() {
  println("eraserDetected()");
}
public void eraserLost() {
  println("eraserLost()");
}


/********************************************/
/*             PLUG METHODS                 */
/********************************************/

/* DISCARD */ // explicitely capture unused osc messages
public void doNothing() {
  println("doing nothing");
}

/* TEST */
public void test(int theA, int theB) {
  println("plug event method test()");
  println(" 2 ints received: "+theA+", "+theB);
}

/* PEN */
public void pen(float x, float y, float tiltX, float tiltY, float pressure) {
  this.penX = x;
  this.penY = y;
  this.penTiltX = tiltX;
  this.penTiltY = tiltY;
  this.penPressure = pressure;
  //println("plug event method pen()");
  //println("x: "+x+", y: "+y+", tiltX: "+tiltX+", tiltY: "+tiltY+", pressure: "+pressure);
}

/* PEN PROXIMITY */
public void penProximity(float proximity){
  //println("plug event method penProximity() | " + "proximity: "+ proximity);
  if (proximity == 1.0) penDetected();
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
public void eraserProximity(float proximity){
  //println("plug event method eraserProximity() | " + "proximity: "+ proximity);
  if (proximity == 1.0) eraserDetected();
  else if (proximity == 0.0) eraserLost();
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


/********************************************/
/*             MOUSE PRESSED                */
/********************************************/

void mousePressed() {
  /* createan osc message with address pattern /test */
  OscMessage myMessage = new OscMessage("/test");
  myMessage.add(123); /* add an int to the osc message */
  myMessage.add(1.1); /* add a second int to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
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
