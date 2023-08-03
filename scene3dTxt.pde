PBRMat mat;
float txtShapeXRot = 0;
float txtRandomAmount = 20;
PVector[] colors = {new PVector(255,50,50), new PVector(0,255,255)};
PVector[] lightPositions = new PVector[8]; // Processing support 8 lights

Star[] stars = new Star[2000];
float z = 0;

void loadScene3dTxt(){
    for(int i=0; i<stars.length; i++) {
     
      stars[i] = new Star(random(-width, width), random(-width, width), random(-width, width)); 
    }
    
    SimplePBR.setExposure(0.05f);
    mat.setMetallic(1.5);
       
    noStroke();
    
    
    for(int i=0;i <8;i++){
      lightPositions[i] = new PVector();
    }
}

void renderScene3dTxt(){

    float bright = (frameCount % 480)/960.f + 0.5;
    float ySpeed = (frameCount % 1500)/1500.f;
    float xSpeed = (frameCount % 1300)/1300.f;
    SimplePBR.setExposure(bright*.5f);
    background(0);
    translate(width/2, height/2,0);
    resetShader();
    fill(255);
    noLights();
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
    
    
    draw3dTxtBackground();
    mat.bind();
    shape(tes);
}

void draw3dTxtBackground(){
    scaledPG.beginDraw();
      scaledPG.fill(255);
      scaledPG.stroke(255);
      scaledPG.background(0);
      scaledPG.image(dvdImage, dvdX, dvdY, dvdWidth, dvdHeight);
      scaledPG.tint(dvdR,dvdG,dvdB);
      
      scaledPG.background(20); // DARK GREY

 
     // CAMERA //
  float mX = map(mouseX, 0, width, 100, width*2);
  camera(0, 0, mX, 0, 0, 0, 0, 1, 0);
 
   // SCENE CENTER TEST //
   /*pushMatrix();
   translate(0, 0, 0);
   fill(#FFFFFF);
   sphere(40);
   sphereDetail(10);
   popMatrix();*/
  
   
   // ROTATE //
   //float Y = map(mouseY, 0, height, -0.5, 0.5);
   //float X = map(mouseX, 0, width, -0.5, 0.5);
   //rotateX(Y);
   rotateY(z);
   scaledPG.rotateZ(z);
   z = z + 0.001;
   
   // TRANSLATE //
   //translate(mouseX, mouseY); // HORIZONTAL & VERTICAL
   //translate(mouseX, 0); // HORIZONTAL ONLY
     for(int i=0; i<stars.length; i++) {
      stars[i].fly(0); 
     }
      
      
    scaledPG.endDraw();
    image(scaledPG,0,0,width,height);
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
   //box(10);
   box(s);
   
     // SPHERE //
   //sphereDetail(10);
   //sphere(4);
   
   
   popMatrix();
 }
}
