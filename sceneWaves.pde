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
  kickADSR = new Envelope(0.1, .01, 1., .2);
  snareADSR = new Envelope(0.1, .01, 1, .2);
  env3ADSR = new Envelope(0.01, .01, 0.75, .2);
  //lfo1.SetAmp(1.0);
  lfo1.SetAmp(.2);
  lfo1.SetFreq(.12);
  //lfo1.SetFreq(.006);
  //lfo1.SetFreq(0.003);
  lfo2.SetAmp(0.25);
  lfo2.SetFreq(0.045);
}


void renderSceneWaves(){
  kick = (kickADSR.Process(kickGate) + 0.f ) * map(kickVel,0,128,0,2);
  lastSnareVel = lerp(lastSnareVel, snareVel, 0.25);
  snare = (snareADSR.Process(snareGate) + 0.f );;
  env3 = (env3ADSR.Process(env3Gate) + 1.f );
  lfo1Val = lfo1.Process();
  lfo2Val = lfo2.Process();
  
  float time = (float) millis()/1000.0;
  waves.set("time", time);
  
  //SEA_FREQ = sin(0.001 * millis());
  SEA_FREQ = lfo1Val;
  SEA_FREQ = map(SEA_FREQ, -1,1, 0.05,.2);
  waves.set("SEA_FREQ", SEA_FREQ); //.1 to .16
  
  //SEA_SPEED = sin(0.001 * millis());
  SEA_SPEED = lfo2Val;
  SEA_SPEED = map(SEA_SPEED, -1,1, 0.02, 1.8);
  waves.set("SEA_SPEED", SEA_SPEED);
  
  SEA_CHOPPY = sin(0.0005 * millis());
  SEA_CHOPPY = map(SEA_CHOPPY, -1,1, 4.0, 18.0);
  waves.set("SEA_CHOPPY", SEA_CHOPPY);
  
  //SEA_HEIGHT = sin(0.001 * millis());
  //SEA_HEIGHT = map(SEA_CHOPPY, -1,1, 0.5, 0.6);
  SEA_HEIGHT = snare * map(lastSnareVel,0,128,0,3) + 0.2 * sin(0.001 * millis());
  SEA_HEIGHT = map(SEA_HEIGHT, 0,1, 0.45, 0.7);
  waves.set("SEA_HEIGHT", SEA_HEIGHT);
  

  xDistance = 2*time;
  yDistance = 3*time;
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
