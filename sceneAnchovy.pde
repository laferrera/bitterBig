float radiusScaler = 0.5;
int color1Index = 0;
int color2Index = 2;
PImage frame;
boolean inverseLetters = false; 

void loadSceneAnchovy(){
  //renderSceneSine();
  fontSize = 25.0;
  brightDamp = 0.05;
  pixelOffset = 1.0;
  letterIndexScale = 0.2;
  letterOrder = "  .`-_':/;▁▂▃░⋰_◜◠+*`=?!¬░█▄▀▀▁▂▃▄▅▆▇█▖▗▘▙▚▛▜▝▞▟═║╒╓╔╕╖╗╘╙╚╛╜╝╞╟╠╡╢╣╤╥╦╧╨╩╪╫╬▩▪▫▬▭▮▯▰▱◖◗◜◝◞◟◠◡◸◹◺◿░▒▓";
  
  greyScale = false;
  starStreakOn = true;
  channelsOn = true;
  gaussianOn = true;
  blurOn = true;
  glitchOn = false;
  
  kickADSR = new Envelope(0.05, .01, 1., .1);
  snareADSR = new Envelope(0.05, .01, 1., .1);
  env3ADSR = new Envelope(0.05, .01, 1., .05);
  env4ADSR = new Envelope(0.25, .01, 1, .25);
  lfo1.SetAmp(1.1);
  lfo1.SetFreq(0.4);
  lfo2.SetAmp(1.1);
  lfo2.SetFreq(0.1);
  lfo3.SetAmp(1);
  lfo3.SetFreq(0.1604125);
   
}

void renderSceneAnchovy(){
  kick = kickADSR.Process(kickGate);
  snare = (snareADSR.Process(snareGate));
  env3 = env3ADSR.Process(env3Gate);
  env4 = env4ADSR.Process(env4Gate); 
  lfo1Val = lfo1.Process();
  lfo2Val = lfo2.Process();
  lfo3Val = lfo3.Process();
  
  radiusScaler = map(kick,0,1, 0.1, 2.0);;
  fontSize = floor(map(kickVel,0,127,2,8)) * 5.0;
  scaledPG.textSize = fontSize; 
  
  inverseLetters = snareGate;

  int index = int(map(lfo2Val,-1,1,0,3));
  color1Index = index;
  //color1Index = 0;
  
  int index2 = int(map(lfo1Val,-1,1,0,3));
  color2Index = index2;
  //color2Index = 2;
  

  
  mySDF();
  renderTxt();
}


void renderTxt(){
  scaledPG.beginDraw();
  scaledPG.background(0);
  scaledPG.noStroke();
  int pixelIndex = 0;
  for (int y = 1; y < frame.height; y++) {
    // Move down for next line
    scaledPG.translate(0, fontSize);
    scaledPG.pushMatrix();
    for (int x = 0; x < frame.width; x++) {
      if(frame.pixels.length == 0){ break;} //guard rails   
      
      int pixelColor = frame.pixels[pixelIndex];
      // Faster method of calculating r, g, b than red(), green(), blue() 
      int r = (pixelColor >> 16) & 0xff;
      int g = (pixelColor >> 8) & 0xff;
      int b = pixelColor & 0xff;

      // Another option would be to properly calculate brightness as luminance:
      int pixelBright = int(0.3*r + 0.59*g + 0.11*b);
      // Or you could instead red + green + blue, and make the the values[] array
      // 256*3 elements long instead of just 256.
      //int pixelBright = max(r, g, b);

      // The 0.1 value is used to damp the changes so that letters flicker less
      // initially brightDamp was 0.1;
      float diff = pixelBright - bright[pixelIndex];
      bright[pixelIndex] += diff * brightDamp;

      if(greyScale){pixelColor = color(pixelBright,pixelBright,pixelBright); }
      
      scaledPG.fill(int(pixelColor*pixelOffset));
      int letterIndex = int(bright[pixelIndex]);
      letterIndex = Math.max(0, Math.min(int(letterIndex * letterIndexScale), (letters.length - 1))); 
      
 
      char curLetter = letters[letterIndex];
      //println("current letter: ", curLetter);
      
      
      if(inverseLetters){
        //if(letterIndex > 128){
          // draw a box with the current pixel color
          scaledPG.rect(0,0,10,10);
          //change the fill color to black for the text
          scaledPG.fill(0);
        //}
      }
      
      scaledPG.text(curLetter, 0, 0);
      //stroke(int(pixelColor*pixelOffset));
      //point(0,0,0);
      // Move to the next pixel
      pixelIndex++;
      // Move over for next character
      scaledPG.translate(fontSize, 0);
    }
    scaledPG.popMatrix();
    scaledPG.beginDraw();    
  }
}

void mySDF(){
  float t = millis()/1000.0;
  sdfCircle.set("time", t);
  //vec3(0.8,0.01,0.419) : vec3(0.00,0.576,0.827);
  //float r = 0.5+0.5*sin(t);
  //float r = radiusScaler + radiusScaler *sin(t);
  float r = radiusScaler;
  sdfCircle.set("radius", r);
  if(color1Index == 0){sdfCircle.set("color1", 0.8,0.01,0.419); }
  if(color1Index == 1){sdfCircle.set("color1", 0.00,0.576,0.827);}
  if(color1Index == 2){sdfCircle.set("color1", 1, 0.984, 0.0509);}
  if(color1Index == 3){sdfCircle.set("color1", 1.0, 0.9607, 0.9607);}
    
  if(color2Index == 0){sdfCircle.set("color2", 0.8,0.01,0.419); }
  if(color2Index == 1){sdfCircle.set("color2", 0.00,0.576,0.827);}
  if(color2Index == 2){sdfCircle.set("color2", 1, 0.984, 0.0509);}
  if(color2Index == 3){sdfCircle.set("color2", 1.0, 0.9607, 0.9607);}
    
  //pg = createGraphics(width, height,P2D););
  //pg = createGraphics(int(width * 1/fontSize), int(height * 1/fontSize), P2D);
  
  scaledPG.beginDraw();
  // weird bug,.. https://github.com/processing/processing/issues/6217
  scaledPG.endDraw();
  
  scaledPG.beginDraw();
  scaledPG.background(0);
  scaledPG.filter(sdfCircle);
  scaledPG.endDraw();
  frame = scaledPG.get();
  //frame.resize(int(scaledPG.width * 1/fontSize), int(scaledPG.height * 1/fontSize));
  frame.resize(int(scaledPG.width * 1/fontSize), int(scaledPG.height * 1/fontSize));
}
