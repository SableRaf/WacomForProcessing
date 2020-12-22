
WacomOscManager wacom;
String netAddress = "127.0.0.1";
int listeningPort = 12000;
int remotePort = 12000;

ArrayList<PVector> stroke;

/********************************************/
/*                   SETUP                  */
/********************************************/

void setup() {
  //size(210, 162); // My Intuos 3 has a drawing area of 210 x 162 mm 
  size(735, 567, P2D);
  frameRate(25);

  stroke = new ArrayList<PVector>();

  wacom = new WacomOscManager(netAddress, listeningPort, remotePort);
  wacom.plugIntuos3();
}

/********************************************/
/*                   DRAW                   */
/********************************************/

void draw() {
  background(0);
  noFill();
  stroke(255);
  strokeWeight(2);
  if (stroke.size()>2) {
    for (int i=1; i<stroke.size(); i++) {
      PVector currentPoint = stroke.get(i);
      PVector previousPoint = stroke.get(i-1);
      float x0 = previousPoint.x * width;
      float y0 = (1.0-previousPoint.y) * height;
      float x1 = currentPoint.x * width;
      float y1 = (1.0-currentPoint.y) * height;
      line(x0, y0, x1, y1);
    }
  }
  strokeWeight(1);
  circle(this.wacom.pen.x*width, (1.0-this.wacom.pen.y)*height, 4);
}


/********************************************/
/*             MOUSE PRESSED                */
/********************************************/

void mousePressed() {
  wacom.sendTestMessage();
}


/********************************************/
/*          WACOM EVENTS HANDLERS           */
/********************************************/

String[] btnNames = {"Void", "L1", "L2", "L3", "L4", "R1", "R2", "R3", "R4", "TIP", "SWITCH BOTTOM", "SWITCH TOP", "ERASER_TIP", "STRIP LEFT", "STRIP RIGHT"};

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
    ERASER_TIP = 12, 
    STRIP_LEFT = 13, 
    STRIP_RIGHT = 14;
}

public void buttonPressed(int btnIndex) {
  println("Button pressed: " + btnNames[btnIndex]);
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
    this.startWriting();
    break;
  case Btn.SWITCH_BOTTOM:
    break;
  case Btn.SWITCH_TOP:
    break;
  case Btn.ERASER_TIP:
    break;
  case Btn.STRIP_LEFT:
    break;
  case Btn.STRIP_RIGHT:
    break;
  default:
    println("invalid button index: " + btnIndex);
  }
}

public void buttonReleased(int btnIndex) {
  println("Button released: " + btnNames[btnIndex]);
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
    this.stopWriting();
    break;
  case Btn.SWITCH_BOTTOM:
    break;
  case Btn.SWITCH_TOP:
    break;
  case Btn.ERASER_TIP:
    break;
  case Btn.STRIP_LEFT:
    break;
  case Btn.STRIP_RIGHT:
    break;
  default:
    println("invalid button index: " + btnIndex);
  }
}

public void penDetected(int state) {
  if (wacom.pen.detected == false) {
    this.wacom.pen.detected(state);
    println("Pen detected: " + this.wacom.pen.getStateName());
  }
}
public void penLost() {
  if (wacom.pen.detected == true) {
    println("Pen lost: " + this.wacom.pen.getStateName());
    this.wacom.pen.lost();
  }
}

public void startWriting() {
  this.wacom.isWriting = true;
  stroke.clear();
}

public void addPoint(float x, float y) {
  PVector newPoint = new PVector(x, y);
  stroke.add(newPoint);
}

public void stopWriting() {
  this.wacom.isWriting = false;
}
