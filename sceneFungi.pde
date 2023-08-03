final int PARTICLE_NUM = 100000;
color[] prevPixels;

Particle p[];
float sensorAngle = 0.3; // 0.3, 0 makes it grow a lot, 0.1
float sensorDist = 5; // 5, 0 makes it grow a lot, 0.1
float moveSpeed = 3.1; // 3.1
float decay = 0.08; // 0.1


void loadSceneFungi(){
  prevPixels = new color[scaledPG.width*scaledPG.height];
  p = new Particle[PARTICLE_NUM];
  for(int i = 0; i< PARTICLE_NUM; i++){
    p[i]= new Particle(new PVector(random(1)*scaledPG.width, random(1)*scaledPG.height), random(1)*PI*2);
  }
  //greyScale = false;
  //starStreakOn = false;
  //channelsOn = false;
  //gaussianOn = false;
  //blurOn = false;
  //glitchOn = false;
  //grainOn = false;
  
  greyScale = false;
  starStreakOn = true;
  channelsOn = false;
  gaussianOn = false;
  blurOn = false;
  glitchOn = false;
  
  kickADSR = new Envelope(0.1, .01, 1., .2);
  snareADSR = new Envelope(0.1, .01, 1, .2);
  env3ADSR = new Envelope(0.25, .01, 1, .25);
  env4ADSR = new Envelope(0.25, .01, 1, .25);
  lfo1.SetAmp(1.0);
  lfo1.SetFreq(0.320825);
  lfo2.SetAmp(1);
  lfo2.SetFreq(0.08020625045);
  lfo3.SetAmp(1);
  lfo3.SetFreq(0.1604125);
}

void renderSceneFungi(){

  kick = kickADSR.Process(kickGate);
  snare = (snareADSR.Process(snareGate));
  env3 = env3ADSR.Process(env3Gate);
  env4 = env4ADSR.Process(env4Gate);
  txt3dToDisplay = env3 < 1 ? 0 : 1; 
  lfo1Val = lfo1.Process();
  lfo2Val = lfo2.Process();
  lfo3Val = lfo3.Process();
    
  channelsOn = kickGate;
  starStreakOn = snareGate;
  
  sensorDist = map(lfo1Val,-1,1,5,0);
  sensorAngle = map(lfo2Val,-1,1,0,0.3);
  decay = map(env4,0,1,.1,0.06); 
  //decay = map(env4,0,1,.06,0.03); // better for blurOn
   
    
  scaledPG.beginDraw();
    physarum.set("_Tex", scaledPG.get());
    physarum.set("_Decay", decay);
    scaledPG.shader(physarum);
    scaledPG.rect(0, 0, scaledPG.width, scaledPG.height);
    scaledPG.resetShader();

    scaledPG.loadPixels();
    arrayCopy(scaledPG.pixels, prevPixels);
    for(int i = 0; i< PARTICLE_NUM; i++){
      p[i].move(prevPixels, sensorAngle, sensorDist);
      p[i].draw(scaledPG.pixels);
    }
    scaledPG.updatePixels();
  scaledPG.endDraw();
    
}





class Particle{
  PVector pos;
  float angle;
  
  Particle(PVector _pos, float _angle){
    pos = _pos;
    angle = _angle;
  }
  
  PVector get_sense_pos(float theta, float dist){
    return PVector.add(pos, new PVector(sin(angle+theta), cos(angle+theta)).mult(dist));
  }
  
  void sense(color[] prev_pixels, float theta, float dist){
    
    PVector front = get_sense_pos(0, dist);
    PVector left = get_sense_pos(theta, dist);
    PVector right = get_sense_pos(-theta, dist);
    color fcol = prev_pixels[X((int)front.x, (int)front.y)];
    color lcol = prev_pixels[X((int)left.x, (int)left.y)];
    color rcol = prev_pixels[X((int)right.x, (int)right.y)];
    int fred = fcol >> 16 & 0xFF;
    int lred = lcol >> 16 & 0xFF;
    int rred = rcol >> 16 & 0xFF;
    if(lred > fred && fred < rred){
        angle += ceil(random(2)-1)*theta;
    }else if(lred < fred && fred < rred){
        angle -= theta;
    }else if(lred > fred && fred > rred){
        angle += theta;
    }
  }
  
  
  void move(color[] prev_pixels, float theta,  float dist){
    sense(prev_pixels, theta, dist);
    pos = PVector.add(pos, new PVector(sin(angle), cos(angle)).mult(moveSpeed));
  }
  
  void draw(color[] pixels){
    int px = X((int)pos.x, (int)pos.y);
    int red = pixels[px] >> 16 & 0xFF;
    pixels[px] = color(min(red + 100, 255));
  }
}

int X(int x, int y){
  return (((x % scaledPG.width) + scaledPG.width) % scaledPG.width)+scaledPG.width*(((y % scaledPG.height) + scaledPG.height) % scaledPG.height);
}
