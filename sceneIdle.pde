PImage dvdImage;

float dvdR = 100;
float dvdG = 100;
float dvdB = 250;

float dvdX = 0;
float dvdY = 0;
float dvdXSpeed = 4;
float dvdYSpeed = 4;
float dvdWidth;
float dvdHeight;

void setupSceneIdle(){
  dvdWidth = dvdImage.width/16;
  dvdHeight = dvdImage.height/16;
  greyScale = false;
  starStreakOn = false;
  channelsOn = false;
  gaussianOn = false;
  blurOn = false;
  glitchOn = false;
  grainOn = false;
}

void dvdPickColor(){
  dvdR = random(100, 256);
  dvdG = random(100, 256);
  dvdB = random(100, 256);
}

void dvdMoveLogo(){
  if(dvdX < 0){
    dvdXSpeed = dvdXSpeed * -1;
    dvdPickColor();
  }
  
  if(dvdX + dvdWidth > scaledPG.width){
    dvdXSpeed = dvdXSpeed * -1;
    dvdPickColor();
  }
  
  if(dvdY < 0){
    dvdYSpeed = dvdYSpeed * -1;
    dvdPickColor();
  }
  
  if(dvdY + dvdHeight > scaledPG.height){
    dvdYSpeed = dvdYSpeed * -1;
    dvdPickColor();
  }
  
  dvdX += dvdXSpeed;
  dvdY += dvdYSpeed;
}

void renderSceneIdle(){
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  dvdMoveLogo();
  

  scaledPG.fill(255);
  scaledPG.stroke(255);
  scaledPG.beginDraw();
    scaledPG.background(0);
    scaledPG.image(dvdImage, dvdX, dvdY, dvdWidth, dvdHeight);
    scaledPG.tint(dvdR,dvdG,dvdB);
  scaledPG.endDraw();
  

}
