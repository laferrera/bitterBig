class Envelope{
  // adr are in Seconds
  // s is 0,1.0
  float a;
  float d;
  float s;
  float r;
  float aCoeff;
  float dCoeff;
  float rCoeff;
  float aTarget = 0.0;
  float M_E = 2.71828182845904523536028747135266250;
  
  boolean gate = false;
  float curOut = 0;
  int mode = 0; 
  // 0 is idle
  // 1 is attack
  // 2 is decay
  // 3 is sustain
  // 4 is release
  
  Envelope(float _a, float _d, float _s, float _r){
    a = _a;
    d = _d;
    s = _s;
    r = _r;
    SetCoefficients();
    Print();
  }
  
  void SetCoefficients(){
    // attack
    if(a > 0){
      float x = a;
      float shape = 0;
      float target = 9.f * pow(x, 10.f) + 0.3 * x + 1.01f;
      aTarget = target;
      float logTarget = log(1.f - (1.f / target)); // -1 for decay
      aCoeff = 1.f - exp(logTarget / (a * _frameRate)); // *1.f - exp(logTarget / (timeInS * sample_rate_))
      
    } else{
      //instant change
      aCoeff = 1.f;
    }
    
    // decay
    if(d > 0.f){
      float target = log(1. / M_E);
      dCoeff = 1.f - exp(target / (d * _frameRate));
    } else {
      //instant change
      dCoeff = 1.f;
    }
    
    // release 
    if( r > 0.f){
      float target = log(1. / M_E);
      rCoeff = 1.f - exp(target / (r * _frameRate));
    } else {
      //instant change
      rCoeff = 1.f;
    }
    
  }
  
  void Print(){
    println("a: ", a);
    println("d: ", d);
    println("s: ", s);
    println("r: ", r);
    println("aCoeff: ", aCoeff);
    println("dCoeff: ", dCoeff);
    println("rCoeff: ", rCoeff);
    println("aTarget: ", aTarget);
  }
    
  void Retrigger(boolean hard){
    mode = 1;
    if(hard) curOut = 0;
  }
  
  
  float Process(boolean _g){
    float out = 0;
    if(_g && !gate){ // rising edge , attack
      mode = 1;
    } 
    //else if (!_g && gate) { // falling edge, release
    //  mode = 4;
    //} 
    gate = _g;
    if(mode > 1 && !gate){ 
      mode = 4;
    }
    
    
    // if decay, target is sus level
    // else release target is below zero
    float target = (mode == 2) ? s : -0.01f;
    
    // set coeff here so we can do same logic for 
    // decay and release
    float coeff = aCoeff;
    if(mode == 2){
      coeff = dCoeff;
    } else if(mode == 4){
      coeff = rCoeff;
    }
    
    switch(mode){
      // idle
      case(0):
        out = 0;
        break;
      // attack
      case(1):
        curOut += coeff * (aTarget - curOut);
        if(curOut > 1.0){
          curOut = 1.0; 
          mode = 2; // switch to decay
        }
        out = curOut;
        break;
      //decay & release
      case(2):
      case(4):
        curOut += coeff * (target - curOut);
        //curOut -= coeff * (target - coeff);
        out = curOut;
        if(curOut < 0.0){
          curOut = 0.0;
          out = 0.0;
          mode = 0;
        }
        break; //<>// //<>//
      default:
        break;
    }
    
    return out;
  }
  
}
