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

void setup() {
  size(210, 162);
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

  println("");

  for (int i=0; i<penCount; i++) {
    oscPlugMethodName = "pen";
    oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscPenAddr + "/" + i; // for example: "/wacom/1/pen/0"
    oscP5.plug(this, oscPlugMethodName, oscAddress); 

    oscPlugMethodName = "eraser";
    oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscEraserAddr + "/" + i; // for example: "wacom/1/eraser/0"
    oscP5.plug(this, oscPlugMethodName, oscAddress);

    println("");
  }

  for (int i=1; i<=keyCount; i++) {
    oscPlugMethodName = "key"+i;
    String oscKeyAddr = "key" + "/" + i;
    oscAddress = "/" + oscTabletAddr + "/" + TABLET_INDEX + "/" + oscKeyAddr; // for example: "/wacom/1/key/8"
    oscP5.plug(this, oscPlugMethodName, oscAddress);
  }
}

public void buttonPressed(int btnIndex) {
  println("button " + btnIndex + " pressed");
  switch (btnIndex) {
    case 1:
      break;
    case 2:
      break;
    case 3:
      break;
    case 4:
      break;
    case 5:
      break;
    case 6:
      break;
    case 7:
      break;
    case 8:
      break;
    default:
  }
}

public void buttonReleased(int btnIndex) {
  println("button " + btnIndex + " released");
  switch (btnIndex) {
    case 1:
      break;
    case 2:
      break;
    case 3:
      break;
    case 4:
      break;
    case 5:
      break;
    case 6:
      break;
    case 7:
      break;
    case 8:
      break;
    default:
  }
}

/* TEST */
public void test(int theA, int theB) {
  println("plug event method test()");
  println(" 2 ints received: "+theA+", "+theB);
}

/* PEN */
public void pen(float x, float y, float tiltX, float tiltY, float pressure) {
  println("plug event method pen()");
  println("x: "+x+", y: "+y+", tiltX: "+tiltX+", tiltY: "+tiltY+", pressure: "+pressure);
}

/* ERASER */
public void eraser(float x, float y, float tiltX, float tiltY, float pressure) {
  println("plug event method eraser()");
  println("x: "+x+", y: "+y+", tiltX: "+tiltX+", tiltY: "+tiltY+", pressure: "+pressure);
}

/* KEYS */
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


void draw() {
  background(0);
}


void mousePressed() {
  /* createan osc message with address pattern /test */
  OscMessage myMessage = new OscMessage("/test");
  myMessage.add(123); /* add an int to the osc message */
  myMessage.add(1.1); /* add a second int to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* with theOscMessage.isPlugged() you check if the osc message has already been
   * forwarded to a plugged method. if theOscMessage.isPlugged()==true, it has already 
   * been forwared to another method in your sketch. theOscMessage.isPlugged() can 
   * be used for double posting but is not required.
   */
  if (theOscMessage.isPlugged()==false) {
    /* print the address pattern and the typetag of the received OscMessage */
    println("### received an osc message.");
    println("### addrpattern\t"+theOscMessage.addrPattern());
    println("### typetag\t"+theOscMessage.typetag());
  }
}
