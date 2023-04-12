class Face {
  float rMin;
  Face(float rMin){
    this.rMin = rMin-20;
  }
  
  void dibujarCara(color col1, color col2, color col3){
    //noFill();
    //stroke(0, 255, 0);
    //strokeWeight(4);
    fill(red(col1), green(col2), blue(col3));
    pushMatrix();
    //Cabeza
    ellipse(0, 0, rMin, rMin);
    noStroke();
    
    //Ojos
    fill(255);
    ellipse(-rMin*.2, -rMin*.1, rMin*.25, rMin*.15);
    ellipse(rMin*.2, -rMin*.1, rMin*.25, rMin*.15);
    
    //Pupilas
    fill(0);
    ellipse(-rMin*.2, -rMin*.1, rMin*.12, rMin*.1);
    ellipse(rMin*.2, -rMin*.1, rMin*.12, rMin*.1);
   
    //Boca
    fill(255, 0, 0);
    arc(0, rMin*.17, rMin*.5, rMin*.25, 0, 3.14);
    popMatrix();
  }
}
