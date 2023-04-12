import netP5.*;
import oscP5.*;
import java.util.Map;

HashMap<Integer,color[]> colors = new HashMap<Integer,color[]>();

int colArrayCounter;
int paletaColor;
float rMin = 0;
float anchoElipses = 13;
int ruidoDefault = floor(noise(1) * 13);
int ruido = 0;
boolean sentidoAncho = true;
boolean sentidoRadio = true;
Face caraFeliz;
boolean face = false;
PImage img;

color[] colArray1 = {
  color (25, 165, 190),
  color (95, 170, 200), 
  color (120, 190, 210), 
  color (170, 210, 230),
  color (205, 225, 245),
  color (220, 240, 250)
};

color[] colArray2 = {
  color (135, 61, 122),
  color (166, 84, 139), 
  color (190, 111, 155), 
  color (210, 141, 171),
  color (225, 172, 189),
  color (237, 205, 211)
};

color[] colArray3 = {
  color (221, 112, 84),
  color (229, 138, 102), 
  color (234, 161, 122), 
  color (239, 183, 145),
  color (243, 204, 171),
  color (249, 225, 200)
};

color[] colArray4 = {
  color (124, 109, 177),
  color (154, 133, 201), 
  color (180, 155, 216), 
  color (204, 177, 228),
  color (223, 201, 238),
  color (240, 225, 245)
};



void setup(){
  size(400,400);
  OscP5 oscP5 = new OscP5(this, 11111);
  size (1000, 1000);
  //noLoop();
  //stroke();
  noStroke();
  frameRate(20);
}

void oscEvent(OscMessage oscMessage) {
  
  if (oscMessage.checkAddrPattern("/metro250")){
    if (sentidoRadio){
      rMin += 10;
      if(rMin > 50){
        caraFeliz = new Face(rMin);
      }
      if (rMin == 280){
        sentidoRadio = false;
      }
    } else if (!sentidoRadio){
      rMin -= 10;
      caraFeliz = new Face(rMin);
      if (rMin == 0){
        sentidoRadio = true;
      }
    }
    
  }else if (oscMessage.checkAddrPattern("/metro500")){
    
     ruido = ruido == ruidoDefault ? 0 : ruidoDefault;
    
  }else if (oscMessage.checkAddrPattern("/metro1000")){
    if (sentidoAncho){
      anchoElipses += 1;
      if (anchoElipses == 20){
        sentidoAncho = false;
      }
    } else if (!sentidoAncho){
      anchoElipses -= 1;
      if (anchoElipses == 14){
        sentidoAncho = true;
      }
    }

  }else if (oscMessage.checkAddrPattern("/metro2000")){
    int nuevoColor;
    
    if(rMin > 220 && sentidoRadio){
      face = true;
    }
    
    while (true){
      nuevoColor = int(random(0,4));
      if (nuevoColor != paletaColor){
        paletaColor = nuevoColor;
        break;
      }
    }  
    
  }
}

void draw(){
  colors.put(0, colArray1);
  colors.put(1, colArray2);
  colors.put(2, colArray3);
  colors.put(3, colArray4);
  
  background (#282828);
  translate(width/2, height/2);
  
  float rStep = 20;
  float rMax = 450;

  for (float r=rMin; r<rMax; r+=rStep) {
    float c = 2*PI*r; // circumference
    float cSegment = map(r, r, rMax, rStep*3/4, rStep/2*r);
    float aSegment = floor(c/cSegment);
    float ellipseSize = map(r,r, rMax, anchoElipses, rStep/4*r);

    for (float a=0; a<360; a+=360/aSegment) {
      colArrayCounter++;
      if(colArrayCounter>5) colArrayCounter = 0;
      // Set the fill color and transparency
      fill(red(colors.get(paletaColor)[colArrayCounter]), green(colors.get(paletaColor)[colArrayCounter]), blue(colors.get(paletaColor)[colArrayCounter]), 255);
      // Set the blend mode to ADD
      blendMode(ADD);
      pushMatrix();
      rotate(radians(a));
      // Draw a small ellipse as a shadow
      ellipse(r+10, 10, ellipseSize, ellipseSize);
      // Draw the main ellipse
      ellipse(r + ruido , 0 + ruido , ellipseSize, ellipseSize);
      popMatrix();
      // Reset the blend mode to NORMAL
      blendMode(NORMAL);
    }
    rotate(radians(noise(r, ruido * frameRate, r*ruido))); // add rotation
  }
  
  if(face){
      pushMatrix();
      caraFeliz.dibujarCara(colors.get(paletaColor)[colArrayCounter], colors.get(paletaColor)[colArrayCounter], colors.get(paletaColor)[colArrayCounter]);
      face = false;
      popMatrix();
    }
  
}
