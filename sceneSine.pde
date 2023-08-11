String letterOrder = "  .`-_':/;▁▂▃░⋰_◜◠+*`=?!¬░█▄▀▀▁▂▃▄▅▆▇█▖▗▘▙▚▛▜▝▞▟═║╒╓╔╕╖╗╘╙╚╛╜╝╞╟╠╡╢╣╤╥╦╧╨╩╪╫╬▩▪▫▬▭▮▯▰▱◖◗◜◝◞◟◠◡◸◹◺◿░▒▓";

char[] letters;
float[] bright;
char[] chars;
//float fontSize = 18.0;
float fontSize = 20.0;
float brightDamp = 0.1;
float pixelOffset = 1.0;
float letterIndexScale = 0.5;

float xSlider = 1.2f;
float ySlider = 1;
int amplitudeSlider = 75;
float tSlider = 8;


void loadSceneSine(){
  
  greyScale = false;
  starStreakOn = true;
  channelsOn = true;
  gaussianOn = true;
  blurOn = true;
  glitchOn = true;
  
  kickADSR = new Envelope(0.05, .01, 1., .05);
  snareADSR = new Envelope(0.05, .01, 1., .05);
  env3ADSR = new Envelope(0.05, .01, 1., .05);
  env4ADSR = new Envelope(0.25, .01, 1, .25);
  lfo1.SetAmp(1.0);
  lfo1.SetFreq(0.320825);
  lfo2.SetAmp(1);
  lfo2.SetFreq(0.08020625045);
  lfo3.SetAmp(1);
  lfo3.SetFreq(0.1604125);
}

void renderSceneSine(){
  glitchAmp = millis()%10000 < 3200 ? 1.5 * noise(millis()) : 0.3 * noise(millis());
  amplitudeLFO = sin(.035 * float(frameCount)) * noise(frameCount);
  amplitudeLFO = map(amplitudeLFO, 0, 1, .75, 1.25);
  //amplitudeLFO = map(amplitudeLFO, 0, 1, .05, 1.25);
  
  tLFO = 1.f;
  //tLFO = sin(.015 * float(frameCount)) * noise(frameCount);
  //tLFO = map(tLFO,0,1, 1.1, .9);
  
  fontSizeLFO = sin(.025 * float(frameCount)) * noise(frameCount);
  fontSizeLFO = map(fontSizeLFO,0,1, 1.f, 2.f);
  //fontSizeLFO = 1.f;
  
  ySliderLFO = sin(.031 * float(frameCount)) * noise(frameCount);
  ySliderLFO = map(ySliderLFO,0,1, 1.f, 2.f);
  ySliderLFO = 1.f;
  
  
  kick = (kickADSR.Process(kickGate) + .5 );
  snare = (snareADSR.Process(snareGate) + .5 );
  env3 = (cymADSR.Process(env3Gate) + .5 );
  float _fontSize = fontSize * kick * fontSizeLFO;
  
  
  scaledPG.beginDraw();
  
  float bgColorFloat = map(env3, 0, 1, 0, 51); 
  scaledPG.background(bgColorFloat,bgColorFloat,bgColorFloat);
  scaledPG.fill(255);
  scaledPG.textSize(6.0);
  scaledPG.text("kick: " + kick, 10,height-30);
  scaledPG.text("snare: " + snare, 10,height-20);
  scaledPG.text("cym: " + cym, 10,height-10);
  
  //textFont(font, fontSize);
  scaledPG.textFont(font, _fontSize);

  scaledPG.strokeWeight(10);
  scaledPG.stroke(cream);
  
  float t = frameCount / tSlider;
  //for (int x = 0; x < width; x += xSlider) {
  for (int y = 0; y < scaledPG.height; y += fontSize*(ySlider * ySliderLFO)) {    
    float x = (scaledPG.width / 2) 
              + fontSize * xSlider * (snare + 1)   
              * int( amplitudeLFO * amplitudeSlider/fontSize 
              * sin(y / 30 + (t * tLFO)));
    scaledPG.push();
      int letterIndex= int((frameCount+x+y)) % (letters.length-1);
      letterIndex = Math.max(0, Math.min(int(letterIndex * letterIndexScale), (letters.length - 1))); 
      char curLetter = letters[letterIndex];      
      scaledPG.stroke(cream * (cym + 1));      
      scaledPG.translate(x,y);
      scaledPG.text(curLetter, 0, 0);
      scaledPG.translate(-scaledPG.width*0.33,0);      
      scaledPG.text(curLetter, 0, 0);
      scaledPG.translate(scaledPG.width*0.66,0);      
      //scaledPG.translate(x+(scaledPG.width*0.75),0);      
      scaledPG.text(curLetter, 0, 0);
    scaledPG.pop();
  }
  scaledPG.endDraw();
}
