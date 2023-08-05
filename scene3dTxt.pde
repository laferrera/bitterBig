PBRMat mat;
PBRMat starMat;
float txtShapeXRot = 0;
float txtRandomAmount = 20;
PVector[] colors1 = {new PVector(64,255,64), new PVector(0,255,255)};
PVector[] colors2 = {new PVector(255,0,255), new PVector(255,128,0)};
PVector[] lightPositions = new PVector[8]; // Processing support 8 lights

Star[] stars = new Star[2000];
float txt3dz = (height/2.0) / tan(PI*30.0 / 180.0);
float txt3dzDir = 1;
int txt3dToDisplay = 0;
int cubemapPos = int(width);
float cubemapDir = 1;

void loadScene3dTxt(){
    for(int i=0; i<stars.length; i++) {
     
      stars[i] = new Star(random(-width, width), random(-width, width), random(-width, width)); 
    }
    
    SimplePBR.setExposure(0.05f);
    mat.setMetallic(1.5);
       
    noStroke();
    txt3dz = (height/2.0) / tan(PI*30.0 / 180.0);
    
    for(int i=0;i <8;i++){
      lightPositions[i] = new PVector();
    }
    
    kickADSR = new Envelope(0.03125, .01, 1.0, .0625);
    //snareADSR = new Envelope(0.01, .01, 1, 0.125);
    //snareADSR = new Envelope(0.01, .01, 1, 0.25);
    snareADSR = new Envelope(0.01, .25, 0.75, 0.25);
    env3ADSR = new Envelope(0.0, .00, 1, 0);
    env4ADSR = new Envelope(0.01, .01, 1, 0.25);  
    lfo1.SetAmp(.2);
    lfo1.SetFreq(.12);
    lfo2.SetAmp(0.2);
    lfo2.SetFreq(0.125);
    lfo3.SetAmp(0.2);
    lfo3.SetFreq(0.083333333);
}

void renderScene3dTxt(){
    kick = kickADSR.Process(kickGate);
    snare = (snareADSR.Process(snareGate));
    env3 = env3ADSR.Process(env3Gate);
    env4 = env3ADSR.Process(env3Gate);
    txt3dToDisplay = env3 < 1 ? 0 : 1; 
    lfo1Val = lfo1.Process();
    lfo2Val = lfo2.Process();
    lfo3Val = lfo3.Process();

    float bgColor = map(snare,0,1,0,64);
    background(0);
  
    background(0);
    //translate(width/2, height/2,0);
    resetShader();
    fill(255);
    noLights();
    lightFalloff(0f, 0.0001f, 0.00001f);

    float bright = lfo1Val + 0.8 + 2*snare;

    if((cubemapPos > width && cubemapDir == 1) || (cubemapPos < -width && cubemapDir == -1)){
      cubemapDir = -cubemapDir; 
    }

    cubemapPos += int((lfo3Val+1) * cubemapDir*5);
  
    //SimplePBR.drawCubemap(this.g, 800);
    SimplePBR.drawCubemap(this.g, cubemapPos);
    txt3dz += abs(12*kick*(2+lfo1Val)) * txt3dzDir;
    //if(txt3dz > width || txt3dz < -width/8.f){
    //  txt3dzDir = -txt3dzDir;
    //}    
    if(txt3dz > width){txt3dz = width; txt3dzDir = -1;}
    if(txt3dz < -width/8){txt3dz = -width/8; txt3dzDir = 1;}
    //camera(0, 0, txt3dz, 0, 0, 0, 0, 1, 0);
    float cameraX = lfo2Val * 500;
    float cameraY = lfo3Val * 500;
    camera(cameraX, cameraY, txt3dz, 0, 0, 0, 0, 1, 0); 

    starMat.setMetallic(14.5);    
    starMat.bind();
    for(int i=0; i<stars.length; i++) {
      float speed = 10*lfo1Val;
      if(i%3 == 1){
        speed = 10*lfo2Val;
      }
      if(i%3 == 2){
        speed = 10*lfo3Val;
      }
      stars[i].fly(speed); 
     }
  

    //float bright = lfo1Val;

    float ySpeed = (frameCount % 1500)/1500.f;
    float xSpeed = (frameCount % 1300)/1300.f;
    
    mat.setMetallic(1.5);
    mat.bind();
    SimplePBR.setExposure(bright*.75f);

    //lightFalloff(0f, 0.0001f, 0.00001f);
    //lightFalloff(0f, 0.001f, 0.0001f);
    
    //Draw lights positions as spheres
    for(int i=0;i <8;i++) {
      float angle =TWO_PI/8f *i;
      lightPositions[i].x = height * sin(angle);
      lightPositions[i].y = height/6*sin(angle + frameCount*0.05f * ySpeed);      
      lightPositions[i].z = height/6*cos(angle + frameCount*0.05f * xSpeed);

      //pushMatrix();
      //  translate(lightPositions[i].x, lightPositions[i].y, lightPositions[i].z);
      //  sphere(4);
      //popMatrix();
    }
    
    for(int i=0;i <8;i++) {
      PVector lightColor = colors1[0];
      if(env4Gate){
         lightColor = colors2[0];
      }
      pointLight(lightColor.x * bright,lightColor.y * bright, lightColor.z * bright, lightPositions[i].x, lightPositions[i].y, lightPositions[i].z);
    }
    
    
    PShape tes = bitterGreensText.getTessellation();
    int total = tes.getVertexCount();
    //println("total tesselation vertices", total);
    //ArrayList<PVector> vertices = new ArrayList<PVector>();
    //PVector firstV = tes.getVertex(0);
    //vertices.add(firstV);
    //for (int i = 1; i < total; i+=5) {
    //  PVector v = tes.getVertex(i);
    //  v.x += random(-txtRandomAmount, txtRandomAmount);
    //  v.y += random(-txtRandomAmount, txtRandomAmount);
    //  v.z += random(-txtRandomAmount, txtRandomAmount);
    //  tes.setVertex(i, v);
    //}
    
    
    //bitterGreensText.rotateX(.02);
    //shape(bitterGreensText);
    txtShapeXRot = 0.02;
    //txtShapeXRot = map(lfo1Val,-.2,.2,0.1,0.3);
    txtShapeXRot = (abs(lfo1Val) / 10.f)+0.01;
    tes.rotateX(txtShapeXRot);
    bitterGreensText.rotateX(txtShapeXRot);
    charliText.rotateX(txtShapeXRot);


    mat.bind();
    if(env3Gate){
      shape(charliText);
    } else {
      //shape(tes);
      shape(bitterGreensText);
    }
    

}



class Star {
 float x;
 float y;
 float z;
 float s = random(4, 8);
 
 Star(float starX, float starY, float starZ) {
 x = starX;
 y = starY;
 z = starZ; 
 }
 
 void fly(float speed) {
   x = x - speed;
   y = y - speed;
     
   pushMatrix();
   translate(x, y , z);
   noSmooth();
   
   fill(255);
   
   noStroke();
   
     // BOX //     
   box(s);

     
   popMatrix();
 }
}
