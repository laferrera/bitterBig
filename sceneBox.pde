Tesseract tesseract;
float boxStrokeWeight = 3;


void loadSceneBox(){
  tesseract = new Tesseract();
  scaledPG.stroke(255);
  scaledPG.strokeWeight(2);
  
  
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

void renderSceneBox(){

  kick = kickADSR.Process(kickGate);
  snare = (snareADSR.Process(snareGate));
  env3 = env3ADSR.Process(env3Gate);
  env4 = env4ADSR.Process(env4Gate); 
  lfo1Val = lfo1.Process();
  lfo2Val = lfo2.Process();
  lfo3Val = lfo3.Process();
  
  kick = map(kick,0,1, 0.85, 1.15);
  snare = map(snare,0,1, 2, 4);
  
  boxStrokeWeight = snare;
  tesseract.size =  scaledPG.width/24 * kick;
  
  
  if(kickGate){
    tesseract.turn(0,1,.01);
  }
  
  if(snareGate){
    tesseract.turn(0,2,.01);
  }
  
  if(env3Gate){
    tesseract.turn(1,2,.01);
  }
  
  if(env4Gate){
    tesseract.turn(0,3,.01);
  }
  
  tesseract.turn(1,3,.01);
  tesseract.turn(2,3,.01);
  
  glitchAmp = (lfo3Val+1 )/2 * (env4/2);
  
  
  scaledPG.beginDraw();
    scaledPG.background (0);
    scaledPG.pushMatrix();
    scaledPG.strokeWeight(boxStrokeWeight);
    
    scaledPG.translate(scaledPG.width/2, scaledPG.height/2);
    
    tesseract.display();
    scaledPG.popMatrix();
  scaledPG.endDraw();
}






class Tesseract{
  float[][][] lines;
  float x, y, z, w, perspZ, perspW, size;
  
  Tesseract(){
    //size=width/24;
    size=scaledPG.width/24;
    z=5;
    w=1;
    perspZ=4;
    perspW=1;
    
    float[][][] temp={
    {{1,1,1,1},{-1, 1, 1, 1}},
    {{1,1,1,1},{ 1,-1, 1, 1}},
    {{1,1,1,1},{ 1, 1,-1, 1}},
    {{1,1,1,1},{ 1, 1, 1,-1}},
    
    {{-1,-1,1,1},{ 1,-1, 1, 1}},
    {{-1,-1,1,1},{-1, 1, 1, 1}},
    {{-1,-1,1,1},{-1,-1,-1, 1}},
    {{-1,-1,1,1},{-1,-1, 1,-1}},
    
    {{-1,1,-1,1},{ 1, 1,-1, 1}},
    {{-1,1,-1,1},{-1,-1,-1, 1}},
    {{-1,1,-1,1},{-1, 1, 1, 1}},
    {{-1,1,-1,1},{-1, 1,-1,-1}},
    
    {{-1,1,1,-1},{ 1, 1, 1,-1}},
    {{-1,1,1,-1},{-1,-1, 1,-1}},
    {{-1,1,1,-1},{-1, 1,-1,-1}},
    {{-1,1,1,-1},{-1, 1, 1, 1}},
    
    {{1,-1,-1,1},{-1,-1,-1, 1}},
    {{1,-1,-1,1},{ 1, 1,-1, 1}},
    {{1,-1,-1,1},{ 1,-1, 1, 1}},
    {{1,-1,-1,1},{ 1,-1,-1,-1}},
    
    {{1,-1,1,-1},{-1,-1, 1,-1}},
    {{1,-1,1,-1},{ 1, 1, 1,-1}},
    {{1,-1,1,-1},{ 1,-1,-1,-1}},
    {{1,-1,1,-1},{ 1,-1, 1, 1}},
    
    {{1,1,-1,-1},{-1, 1,-1,-1}},
    {{1,1,-1,-1},{ 1,-1,-1,-1}},
    {{1,1,-1,-1},{ 1, 1, 1,-1}},
    {{1,1,-1,-1},{ 1, 1,-1, 1}},
    
    {{-1,-1,-1,-1},{ 1,-1,-1,-1}},
    {{-1,-1,-1,-1},{-1, 1,-1,-1}},
    {{-1,-1,-1,-1},{-1,-1, 1,-1}},
    {{-1,-1,-1,-1},{-1,-1,-1, 1}}};
    
    lines=temp;
  }
  
  void turn(int a, int b, float deg){
    float[] temp;
    for (int j=0; j<2; j++)
      for (int i=0; i<32; i++){
        temp=lines[i][j];
        lines[i][j][a]=temp[a]*cos(deg)+temp[b]*sin(deg);
        lines[i][j][b]=temp[b]*cos(deg)-temp[a]*sin(deg);
      }
  }
  
  void persp(float[][][] arr){
    for (int j=0; j<2; j++)
      for (int i=0; i<32; i++){
        arr[i][j][0]=arr[i][j][0]+(arr[i][j][0]+x)*((arr[i][j][2]+z)/perspZ+(arr[i][j][3]+w)/perspW);
        arr[i][j][1]=arr[i][j][1]+(arr[i][j][1]+y)*((arr[i][j][2]+z)/perspZ+(arr[i][j][3]+w)/perspW);
      }
  }
  
  void myResize(float[][][] arr){
    for (int i=0; i<32; i++)
      for (int j=0; j<2; j++)
        for (int k=0; k<4; k++)
          arr[i][j][k]*=size;
  }
  
    
  void display(){
    float[][][] temp = new float[32][2][4];
    for (int i=0; i<32; i++)
      for (int j=0; j<2; j++)
        for (int k=0; k<4; k++)
          temp[i][j][k]=lines[i][j][k];
    persp(temp);
    myResize(temp);
    for (int i=0; i<32; i++){
      scaledPG.line(temp[i][0][0],temp[i][0][1],temp[i][1][0],temp[i][1][1]);
      if(env4Gate){ 
        scaledPG.strokeWeight(1);
        scaledPG.line(temp[i][0][0]-6*size,temp[i][0][1],temp[i][1][0]-6*size,temp[i][1][1]);
      }
      if(env3Gate){
        scaledPG.strokeWeight(1);
        scaledPG.line(temp[i][0][0]+6*size,temp[i][0][1],temp[i][1][0]+6*size,temp[i][1][1]);
      }
    }
  }
}
