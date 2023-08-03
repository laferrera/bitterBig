final int PARTICLE_NUM = 100000;
color[] prevPixels;

Particle p[];
float sensorAngle = 0.3; // 0.3
float sensorDist = 5; // 5
float moveSpeed = 3.1; // 3.1
float decay = 0.1;


void loadSceneFungi(){
  prevPixels = new color[scaledPG.width*scaledPG.height];
  p = new Particle[PARTICLE_NUM];
  for(int i = 0; i< PARTICLE_NUM; i++){
    p[i]= new Particle(new PVector(random(1)*scaledPG.width, random(1)*scaledPG.height), random(1)*PI*2);
  }
  greyScale = false;
  starStreakOn = false;
  channelsOn = false;
  gaussianOn = false;
  blurOn = false;
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

void renderSceneFungi(){

  //scaledPG.beginDraw();
  //// weird bug,.. https://github.com/processing/processing/issues/6217
  //scaledPG.endDraw();
    
  channelsOn = kickGate;
  starStreakOn = snareGate;
    
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
