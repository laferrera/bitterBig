float SEA_FREQ = .05; // zoom , .05 to .2
float SEA_SPEED = 0.2; // 0.2 to 0.8
float SEA_CHOPPY = 4.; // doesnt do much 4 to.18
float SEA_HEIGHT = 0.6; // 0.5 to.6
float xDistance = 0; //
float yDistance = 0; //
float heightDistance = 0; //

float lastSnareVel;
float lastKickVel;


void loadSceneWaves(){
  greyScale = false;
  starStreakOn = false;
  channelsOn = false;
  gaussianOn = false;
  blurOn = true;
  glitchOn = false;
  grainOn = false;
  kickADSR = new Envelope(0.1, .1, .9, .2);
  snareADSR = new Envelope(0.1, .1, .9, .2);
  env3ADSR = new Envelope(0.5, .01, 1, .5);
  env4ADSR = new Envelope(0.5, .01, 1, .5);
  lfo1.SetAmp(0.5);
  lfo1.SetFreq(.06);
  lfo2.SetAmp(0.12);
  lfo2.SetFreq(0.045);
  lfo3.SetFreq(.012);
  lfo3.SetAmp(0.5);
}


void renderSceneWaves(){
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  kick = (kickADSR.Process(kickGate) + 0.f ) * map(kickVel,0,128,0,2);
  lastSnareVel = lerp(lastSnareVel, snareVel, 0.25);
  snare = (snareADSR.Process(snareGate) + 0.f );;
  env3 = env3ADSR.Process(env3Gate);
  env4 = env3ADSR.Process(env4Gate);
  lfo1Val = lfo1.Process();
  lfo2Val = lfo2.Process();
  lfo3Val = lfo2.Process();
  
  float time = (float) millis()/1000.0;
  waves.set("time", time);
  
  //SEA_FREQ = sin(0.001 * millis());
  SEA_FREQ = lfo1Val;
  SEA_FREQ = map(SEA_FREQ, -1,1, 0.05,.1);
  waves.set("SEA_FREQ", SEA_FREQ); //.1 to .16
  
  //SEA_SPEED = sin(0.001 * millis());
  SEA_SPEED = lfo2Val;
  SEA_SPEED = map(SEA_SPEED, -1,1, 0.02, 1.8);
  waves.set("SEA_SPEED", SEA_SPEED);
  
  SEA_CHOPPY = sin(0.0005 * millis()) + 0.8 * env4;
  SEA_CHOPPY = map(SEA_CHOPPY, -1,1, 8.0, 18.0);
  waves.set("SEA_CHOPPY", SEA_CHOPPY);
  

  SEA_HEIGHT = snare * map(lastSnareVel,0,128,0,3) + 0.4 * sin(0.001 * millis());
  SEA_HEIGHT = map(SEA_HEIGHT, 0,1, 0.55, 0.8);
  waves.set("SEA_HEIGHT", SEA_HEIGHT);
  

  xDistance = xDistance + .02 + 0.05*env3;
  //yDistance = yDistance + .02 + 0.05*env4;
  yDistance = yDistance + .02;
  
  waves.set("xDistance", xDistance);
  waves.set("yDistance", yDistance);
  
  //heightDistance = 2 * sin(0.0001 * millis());
  
  heightDistance = 0.5*kick;
  waves.set("heightDistance", heightDistance);
  
  
  scaledPG.beginDraw();
    scaledPG.filter(waves);
    scaledPG.filter(dupontSaturation);
  scaledPG.endDraw();
}
