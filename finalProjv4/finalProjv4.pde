import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

float si, sj; // for gradient colors
float idirection, jdirection;
float Rthreshold, Wthreshold, Bthreshold; // thresholds for reacting to volume
float wiggleFactor;
float blobFactor;
float radiusFactor;

Minim myMinim;

AudioPlayer music;

class Circle{
  PShape circle;
  float x, y;



  
  void move(float mx, float my){
    circle.translate(mx,my);
    x = x+mx;
    y = y+mx;
  }
}

float masterClock;
ArrayList<Circle> circles = new ArrayList<Circle>();

void setup(){
  size(400,400);
  //background(0,0,204);
  background(0);
  si = 100;
  sj = 50;
  idirection = 1;
  jdirection = 1;
  
  myMinim = new Minim(this);
  music = myMinim.loadFile("Clouds.mp3");
  music.loop();

  wiggleFactor = 1;
  radiusFactor = 1;
  blobFactor = 1;
  
  Wthreshold = 0.6;
  Rthreshold = 0.3;
  Bthreshold = 0.7;
}

void draw(){

  
  
  //background(0,0,204);
  background(0);
  //blendMode(BLEND);
  pushMatrix();
  translate(150,200);
  if(music.right.level() > Wthreshold){
    if(wiggleFactor < 1){
      wiggleFactor +=0.1;
    }
    else{
      wiggleFactor = 3;
    }
  }
  
  if(music.right.level() > Rthreshold){
    if(radiusFactor < 1){
      radiusFactor += 0.2;
    }
    else{
      radiusFactor = 1.5;
    }
  }
  
  if(music.right.level() > Bthreshold){
    if(blobFactor < 1){
      blobFactor += 0.1;
    }
    else{
      blobFactor = 1.5;
    }
  }
  
  for(int i = 0; i < circles.size(); i++){
    Circle temp = circles.get(i);

    temp.move(5,sin(masterClock*TWO_PI*wiggleFactor*2)*5 + sin(masterClock*TWO_PI)*music.right.level()*10);
    beginShape();
    if(temp.x > width + 50){
      circles.remove(temp);
    }
    
    shape(temp.circle);
  }
  popMatrix();
  //background(0);
  
  //noFill();
  // stroke color
  color s = color(si + 100*cos(masterClock*TWO_PI), sj+ 100*sin(masterClock*TWO_PI), 150);
  color f = color(si + 100*cos(masterClock*TWO_PI), sj+ 100*sin(masterClock*TWO_PI), 250);
  //radius
  float r = 90 + radiusFactor*(music.right.level()*50);

  PShape c = createShape();
  float myClock;

  
  translate(150,200);

  c.beginShape();
  
  // set fill 
  c.fill(f,255);
  noStroke();
  //c.stroke(s);

  // hardcode the vertices
  for(int i = 0; i<360; i++){
    
    myClock = masterClock; 
    myClock = myClock * TWO_PI;
    
    float vx = (cos(radians(i+masterClock*360) + myClock))*r + cos(radians(i))*10;
    float vy = (sin(-radians(i+masterClock*360) + myClock))*r + sin(radians(i))*10;
  

    // make circle
    c.vertex(vx,vy);
   
  }

  
  c.endShape(CLOSE);
  shape(c);
  Circle temp = new Circle();
  temp.circle = c;
  temp.x = 150;
  temp.y = 200;



  circles.add(temp);

  masterClock = masterClock + 0.01;
  si = si + 0.25*idirection;
  sj = sj + 0.5*jdirection;
  if(si > 255 || si < 100){
    idirection = idirection * -1;
  }
  
  if(sj > 120 || sj < 50){
    jdirection = jdirection * -1;
  }
  
  if(masterClock > 1){
    masterClock = 0;
  }
  
  wiggleFactor *= 0.9;
  radiusFactor *= 0.9;
  blobFactor *= 0.9;
}
