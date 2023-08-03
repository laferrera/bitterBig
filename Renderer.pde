void render(){
  switch(sceneId) {
    case 0:
      renderSceneIdle();
      break;
    case 1: 
      renderScene1();
      break;
    case 4:
    renderSceneWaves();
      break;
    case 5:
    renderScene3dTxt();
  }
  
}



void shaders(){
  scaledPG.beginDraw();
  if(frameCount % 30 < 12){
    glitchAmount = width * noise(frameCount) * glitchAmp * sin(frameCount);
  }
  
  channels.set("rbias", 0.0, 0.0);
  //channels.set("gbias", map(mouseY, 0, height, -0.2, 0.2), 0.0);
  //float gbias = -0.01 + .01 * cos(.005 * float(frameCount)) + 0.008 * noise(frameCount);
  float gbias = -0.001 + .0025 * sin(.052 * float(frameCount))- 0.0013 * noise(frameCount);
  gbias = map(snare, 0, 1, 0, .005);  
  gbias = gbias - (0.02 * lfo3Val);

  channels.set("gbias", gbias, 0.0);
  channels.set("bbias", 0.0, 0.0);
  
  //channels.set("gbias", 0.0, 0.0);
  //channels.set("bbias", 0.0, 0.0);
  

  float rmult = 1.001 + .0035 * sin(.035 * float(frameCount)) - 0.001 * noise(frameCount);
  rmult = rmult + (0.02 * glitchAmp);
  rmult = map(kick,0,1, 0.95,1.05);
  rmult = rmult + (0.02 * lfo3Val);
  
  channels.set("rmult", rmult, 1.0);
  channels.set("gmult", 1.0, 1.0);
  channels.set("bmult", 1.0, 1.0);
  
  //channels.set("rmult", 1.0, 1.0);
  //channels.set("gmult", 1.0, 1.0);
  //channels.set("bmult", 1.0, 1.0);

  
  starglowstreak.set("time", (float) millis()/1000.0);
  float range = 0.2;
  float trio = (kick+snare)/2;
  range = map(trio, 0, 1, 0, .2);
  range = max(range,0,0.2);
  starglowstreak.set("range", range);
  if(starStreakOn) scaledPG.filter(starglowstreak);
  
  //radialStreak.set("time", (float) millis()/1000.0);
  //filter(radialStreak);
  
  if(channelsOn) scaledPG.filter(channels);
  
  ////gaussian.set("time", (float) millis()/1000.0);
  if(gaussianOn) scaledPG.filter(gaussian);
   
  //myBlur2.set("time", (float) millis()/1000.0);
  if(blurOn) scaledPG.filter(myBlur2);
  glitch.set("glitchAmount",glitchAmount); 
  if(glitchOn) scaledPG.filter(glitch);
  grain.set("time", (float) millis()/1000.0);
  grain.set("strength", 16.f);
  if(grainOn) scaledPG.filter(grain);
  
  scaledPG.endDraw();
}
