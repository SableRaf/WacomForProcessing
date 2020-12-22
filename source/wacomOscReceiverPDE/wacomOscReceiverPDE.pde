


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
  size(735,567,P2D);
  frameRate(25);

  stroke = new ArrayList<PVector>();

  wacom = new WacomOscManager(netAddress, listeningPort, remotePort);
  wacom.plugIntuos3();

  pen = new Pen();
  
  pen.x = width/2;
  pen.y = height/2;

}

/********************************************/
/*                   DRAW                   */
/********************************************/

void draw() {
  background(0);
  noFill();
  stroke(255);
  strokeWeight(2);
  if(stroke.size()>2) {
    for(int i=1; i<stroke.size(); i++) {
      PVector currentPoint = stroke.get(i);
      PVector previousPoint = stroke.get(i-1);
      float x0 = previousPoint.x * width;
      float y0 = (1.0-previousPoint.y) * height;
      float x1 = currentPoint.x * width;
      float y1 = (1.0-currentPoint.y) * height;
      line(x0,y0,x1,y1);
    }
  }
  strokeWeight(1);
  circle(pen.x*width, (1.0-pen.y)*height, 4);
}


/********************************************/
/*             MOUSE PRESSED                */
/********************************************/

void mousePressed() {
  wacom.sendTestMessage();
}
