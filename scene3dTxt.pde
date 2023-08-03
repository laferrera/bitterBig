PBRMat mat;
PBRMat starMat;
float txtShapeXRot = 0;
float txtRandomAmount = 20;
PVector[] colors = {new PVector(255,50,50), new PVector(0,255,255)};
PVector[] lightPositions = new PVector[8]; // Processing support 8 lights

Star[] stars = new Star[2000];
float txt3dz = (height/2.0) / tan(PI*30.0 / 180.0);

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
    
    kickADSR = new Envelope(0.01, .01, 1.0, .125);
    snareADSR = new Envelope(0.01, .01, 1, 0.0625);
    env3ADSR = new Envelope(0.01, .01, 0.75, .2);
    lfo1.SetAmp(.2);
    lfo1.SetFreq(.12);
    //lfo1.SetFreq(.006);
    //lfo1.SetFreq(0.003);
    lfo2.SetAmp(0.25);
    lfo2.SetFreq(0.045);
}

void renderScene3dTxt(){

    background(0);
    //translate(width/2, height/2,0);
    resetShader();
    fill(255);
    noLights();

    kick = kickADSR.Process(kickGate);
    snare = (snareADSR.Process(snareGate));
    env3 = (env3ADSR.Process(env3Gate) + 1.f );
    lfo1Val = lfo1.Process();
    lfo2Val = lfo2.Process();

    float bright = lfo1Val + 0.5 + 2*snare;
  
    SimplePBR.drawCubemap(this.g, 800);
    //rotates 
    //rotateY(txt3dz);
    //txt3dz = txt3dz + 0.2;
    //float txt3dmX = map(mouseX, 0, width, 100, width*2); 
    //txt3dz += 0.2;
    txt3dz += 8*kick;
    camera(0, 0, txt3dz, 0, 0, 0, 0, 1, 0);
    starMat.setMetallic(14.5);    
    starMat.bind();

     for(int i=0; i<stars.length; i++) {
      stars[i].fly(0); 
     }
  

    //float bright = lfo1Val;

    float ySpeed = (frameCount % 1500)/1500.f;
    float xSpeed = (frameCount % 1300)/1300.f;
    
    mat.setMetallic(1.5);
    mat.bind();
    SimplePBR.setExposure(bright*.5f);

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
      PVector lightColor = colors[i%2];
      //pointLight(lightColor.x,lightColor.y, lightColor.z, lightPositions[i].x, lightPositions[i].y, lightPositions[i].z);
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
    txtShapeXRot += 0.02;
    tes.rotateX(txtShapeXRot);
    
    
    
    //mat.bind();
    shape(tes);
}



class Star {
 float x;
 float y;
 float z;
 float s = random(2, 10);
 
 Star(float starX, float starY, float starZ) {
 x = starX;
 y = starY;
 z = starZ; 
 }
 
 void fly(int speed) {
   x = x - speed;
   y = y - speed;
     
   pushMatrix();
   translate(x, y , z);
   noSmooth();
   
   fill(255);
   
   noStroke();
   
     // BOX //
   box(5);
   box(s);

     
   popMatrix();
 }
}
