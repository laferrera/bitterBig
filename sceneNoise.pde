float noiseScale = 0.001;
float noiseSpeed = 0.001;
float strokeThick = 0.25;
color colour = color(255, 255, 255);
color darkColour = color(64,64,64);
color darkerColour = color(128,128,128);


float cellSize = 6.0;

float sWeight;
float noiseScale_;
float noiseSpeed_;

void loadSceneNoise(){
  dvdWidth = dvdImage.width/16;
  dvdHeight = dvdImage.height/16;
  greyScale = false;
  starStreakOn = false;
  channelsOn = true;
  gaussianOn = false;
  blurOn = true;
  glitchOn = true;
  grainOn = false;
  kickADSR = new Envelope(0.01, .01, 0.75, .2);
  snareADSR = new Envelope(0.01, .25, 0.75, .25);
  env3ADSR = new Envelope(0.01, .01, 0.75, .2);
  env4ADSR = new Envelope(0.01, .01, 0.75, .2);
  lfo1.SetFreq(.1);
  lfo1.SetAmp(0.5);
  lfo2.SetFreq(.05);
  lfo2.SetAmp(0.5);
  lfo3.SetFreq(.025);
  lfo3.SetAmp(0.5);
}

void renderSceneNoise(){  
  //glitchAmp = (lfo3Val+1 )/2 + (kick/4) + (snare/2);
  //glitchAmp = (lfo3Val+1 )/2 * ((kick/4) + (snare/2));
  glitchAmp = (lfo3Val+1 )/2 * (env4/2);
  amplitudeLFO = sin(.035 * float(frameCount)) * noise(frameCount);
  amplitudeLFO = map(amplitudeLFO, 0, 1, .75, 1.25);
  
  scaledPG.beginDraw();
  kick = (kickADSR.Process(kickGate) + 1.f );
  snare = (snareADSR.Process(snareGate) + 1.f );
  env3 = (env3ADSR.Process(env3Gate) + 1.f );
  env4 = (env4ADSR.Process(env4Gate) + 1.f );
  
  cym = (cymADSR.Process(cymGate) + 1.f );
  //tom = (tomADSR.Process(tomGate) + 1.f );
  ride = (rideADSR.Process(rideGate) + 1.f );
  lfo1Val = lfo1.Process();
  lfo2Val = lfo2.Process();
  lfo3Val = lfo3.Process();
  
  
  float cymColorFloat = map(cym, 1, 2, 255, 200);
  color cymColor = color(cymColorFloat,cymColorFloat,cymColorFloat); 
  //background(bgColorFloat,bgColorFloat,bgColorFloat);
  float snareColorFloat = map(snare, 1, 2, 0, 51);
  color snareColor = color(snareColorFloat,snareColorFloat,snareColorFloat);
  scaledPG.background(snareColor);
  
  starStreakOn = env3Gate;
  
  sWeight = (strokeThick + abs(lfo2Val)/8) * 4*snare;
  //sWeight = max(sWeight,strokeThick);
  scaledPG.strokeWeight(sWeight);

  scaledPG.stroke(cymColor);
  //stroke(255);
  
  noiseScale_ = map(cym, 0, 1, noiseScale/2, noiseScale*2);
  if(ride > 1){
    noiseScale_ = noiseScale_ * .25;
    sWeight += strokeThick;
  }  
  noiseSpeed_ = noiseSpeed + (lfo1Val+2) * noiseSpeed/2;    

  scaledPG.strokeWeight(sWeight);
  
  createNoiseGrid(colour);
  
  
  scaledPG.push();
    float kCellSize = cellSize * kick;
    //translate(kCellSize * 2,kCellSize);
    scaledPG.translate(kCellSize,kCellSize);
    createNoiseGrid(colour);
    
    float sCellSize = cellSize * snare;
    //translate(sCellSize* 2,sCellSize);
    scaledPG.translate(sCellSize,sCellSize);
    createNoiseGrid(darkColour);
    
    //float cymCellSize = cellSize * cym;
    //translate(cymCellSize* 2,cymCellSize);
    //createNoiseGrid(darkerColour, 100);
  scaledPG.pop();
  scaledPG.endDraw();
}


void createNoiseGrid(color colour){
  
  scaledPG.stroke(colour);
  
  for (int x = 0; x < scaledPG.width; x += cellSize){
    for (int y = 0; y < scaledPG.height; y += cellSize){
      float len = calculateNoiseAtXY(x,y) * 7;
      scaledPG.push();
        scaledPG.translate(x, y);
        scaledPG.rotate(calculateNoiseAngle(x,y));
        //strokeWeight(sWeight + 0.25*len);
        scaledPG.strokeWeight(sWeight * len);
        scaledPG.line(0,0, len, len);
      scaledPG.pop();
    }
  }
}

float calculateNoiseAtXY(int x,int y){
  return noise(x * noiseScale_, y * noiseScale_, noiseSpeed_*frameCount);
  //return noise(x * noiseScale, y * noiseScale, 0.001*frameCount);
}

float calculateNoiseAngle(int x,int y){
  return calculateNoiseAtXY(x,y) * TWO_PI * 8;
}
