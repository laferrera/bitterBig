Isohypse iso_up, iso_down, iso_big;
color back, red, black;
  





void loadSceneMap(){
  
  greyScale = false;
  starStreakOn = true;
  channelsOn = false;
  gaussianOn = false;
  blurOn = false;
  glitchOn = true;
  
  kickADSR = new Envelope(0.05, .01, 1., .05);
  snareADSR = new Envelope(0.05, .01, 1., .05);
  env3ADSR = new Envelope(0.05, .01, 1., .05);
  env4ADSR = new Envelope(0.25, .01, 1, .25);
  
  iso_up = new Isohypse(-200, 200, 10, 25, 55, 9, 3, 1);
  iso_down = new Isohypse(scaledPG.width+200, scaledPG.height-200, 10, 35, 65, 12, 3, 1);
  iso_big = new Isohypse(scaledPG.width/2, 3*scaledPG.height/2, 10, 35, 120, 12, 3, 0);
  back = color(0);
  red = color(255, 60, 60);
  black = color(250, 248, 239);  
}

void renderSceneMap(){
  
    kick = kickADSR.Process(kickGate);
  snare = (snareADSR.Process(snareGate));
  env3 = env3ADSR.Process(env3Gate);
  env4 = env4ADSR.Process(env4Gate);
  
  if(snareGate){
    noiseSeed(frameCount);
    iso_up = new Isohypse(-200, 200, 10, 25, 55, 9, 3, 1);
    iso_down = new Isohypse(scaledPG.width+200, scaledPG.height-200, 10, 35, 65, 12, 3, 1);
    iso_big = new Isohypse(scaledPG.width/2, 3*scaledPG.height/2, 10, 35, 120, 12, 3, 0);
  }
  
  if(kickGate){
    //back = color(200);
    red = color(60, 60, 255);
    black = color(250, 248, 239);
  } else {
    back = color(0);
    red = color(255, 60, 60);
    black = color(250, 248, 239);  
  }
  
  if(env3Gate){
    noiseDetail(8);
  } else {
    noiseDetail(4);
  }
  
  scaledPG.beginDraw();  
  scaledPG.background(back);

  scaledPG.strokeWeight(1);
  scaledPG.stroke(black);
  iso_up.display();

  scaledPG.strokeWeight(1);
  scaledPG.stroke(black);
  iso_down.display();

  scaledPG.strokeWeight(3);
  scaledPG.stroke(red);
  iso_big.display();

  scaledPG.fill(back);
  scaledPG.noStroke();
  scaledPG.rect(0, 0, width, 25);
  scaledPG.rect(0, 25, 25, height);
  scaledPG.rect(width-25, 25, 25, height);
  scaledPG.rect(0, height-25, width, 25);

  scaledPG.noFill();
  scaledPG.stroke(black);
  scaledPG.strokeWeight(1);
  scaledPG.rect(25, 25, width-50, height-50);
  scaledPG.rect(20, 20, width-40, height-40);

  //compass();
  //triangles(width/5, 4*height/5);
  //triangles(2*width/3, height/2);
  //triangles(4*width/5, 5*height/6);
  //sc(width/10, 9*height/10);
  
  scaledPG.push();
  scaledPG.strokeWeight(0.25);
  scaledPG.translate(width/20-5, width/20-5);
  for (int a = 5; a < width; a += width/5) {
    for (int b = 5; b < height; b += width/5) {
      scaledPG.line(a - 5, b, a + 5, b);
      scaledPG.line(a, b - 5, a, b + 5);
    }
  }
  scaledPG.pop();
  scaledPG.endDraw();
  
}






class Isohypse {

  float posx, posy;
  int broj_krugova, broj_tacaka, elevacija, shadowx, shadowy, updown;
  PVector[] tcke;
  float x, y, z;

  Isohypse(float posx, float posy, int broj_krugova, int broj_tacaka, int elevacija, int shadowx, int shadowy, int updown) {
    this.posx = posx;
    this.posy = posy;
    this.broj_krugova = broj_krugova;
    this.broj_tacaka = broj_tacaka;
    this.elevacija = elevacija;
    this.shadowx = shadowx;
    this.shadowy = shadowy;
    this.updown = updown;

    tcke = new PVector[broj_krugova * broj_tacaka];

    x = 0;
    y = 3;
    z = 100;
  }

  void display() {
    scaledPG.push();
    scaledPG.translate(posx, posy);

    float x=0;
    float y=0;
    for (int j = 1; j < broj_krugova; j++) {
      y = 3;
      for (int i = 0; i < broj_tacaka; i++) {
        //float rn = map(noise(x, y, z), 0, 1, -20, 20);
        float rn = map(noise(x, y, z), 0, 1, -20, 20);
        tcke[i + j * broj_tacaka] = new PVector(cos(i * TWO_PI / broj_tacaka) * j * (elevacija + rn), sin(i * TWO_PI / broj_tacaka) * j * (elevacija + rn));
        y += 0.5 + map(kick,0,1,0,0.2);
      }
      x += 0.1 + map(kick,0,1,0,0.2);
    }
    z += 0.01;

    for (int j = broj_krugova - 1; j > 0; j--) {
      if (j % 3 != 0 && updown != 0) {
        scaledPG.strokeWeight(1);
      } else {
        scaledPG.strokeWeight(3);
      }

      scaledPG.beginShape();
      for (int i = 0; i < broj_tacaka + 3; i++) {
        scaledPG.curveVertex(tcke[i % broj_tacaka + j * broj_tacaka].x, tcke[i % broj_tacaka + j * broj_tacaka].y);
      }
      scaledPG.endShape();
    }

    if (updown == 0) {
      for (int j = broj_krugova - 1; j > 0; j--) {
        for (int i = 0; i < broj_tacaka + 3; i += 1) {
          scaledPG.noStroke();
          scaledPG.fill(back);

          float t = map(j, broj_krugova - 1, 1, 0.1, 0.25);

          for (float s = 0; s < 1; s += t) {
            x = scaledPG.curvePoint(tcke[i % broj_tacaka + j * broj_tacaka].x, tcke[(i + 1) % broj_tacaka + j * broj_tacaka].x, tcke[(i + 2) % broj_tacaka + j * broj_tacaka].x, tcke[(i + 3) % broj_tacaka + j * broj_tacaka].x, s);
            y = scaledPG.curvePoint(tcke[i % broj_tacaka + j * broj_tacaka].y, tcke[(i + 1) % broj_tacaka + j * broj_tacaka].y, tcke[(i + 2) % broj_tacaka + j * broj_tacaka].y, tcke[(i + 3) % broj_tacaka + j * broj_tacaka].y, s);
            scaledPG.ellipse(x, y, 10, 10);
          }

          if (i % 5 == 0 && (j == 5 || j == 7 || j == 9)) {
            scaledPG.ellipse(x - 20, y, 40, 40);
            scaledPG.fill(red);
            scaledPG.textAlign(CENTER);
            scaledPG.text(floor(x), x - 20, y);
          }

          if (i % 5 == 3 && j == 8) {
            scaledPG.stroke(red);
            scaledPG.strokeWeight(8);
            scaledPG.strokeCap(SQUARE);
            scaledPG.push();
            scaledPG.translate(x - 10, y);
            scaledPG.line(-20, -20, 20, 20);
            scaledPG.line(20, -20, -20, 20);
            scaledPG.pop();
          }
        }
      }
    }
    scaledPG.pop();
  }
}



//void compass() {
//  stroke(black);
//  noFill();
//  strokeCap(SQUARE);
//  push();
//  translate(width-120, 115);

//  strokeWeight(6);
//  stroke(back);
//  rect(-57, -57, 114, 114);
//  strokeWeight(1);
//  stroke(black);
//  rect(-60, -60, 120, 120);
//  rect(-55, -55, 110, 110);

//  stroke(back);
//  strokeWeight(8);
//  line(-30, 0, 30, 0);
//  line(0, -30, 0, 30);
//  strokeWeight(6);
//  line(-15, -15, 15, 15);
//  line(15, -15, -15, 15);

//  stroke(black);
//  strokeWeight(4);
//  line(-30, 0, 30, 0);
//  line(0, -30, 0, 30);
//  strokeWeight(2);
//  line(-15, -15, 15, 15);
//  line(15, -15, -15, 15);

//  noStroke();
//  fill(black);
//  strokeWeight(1);
//  stroke(back);
//  textAlign(CENTER);
//  text("N", 0, -36);
//  text("S", 0, 46);
//  text("E", -40, 4);
//  text("W", 44, 4);
//  pop();
//}

//void triangles(float posx, float posy) {
//  for (int i = 0; i < 3; i++) {
//    strokeWeight(4);
//    push();
//    translate(posx, posy);
//    triangle(0, 0, 30, 0, 15, -26);
//    pop();
//  }
//}

//void sc(float posx, float posy) {
//  strokeWeight(1);
//  stroke(black);
//  push();
//  translate(posx, posy);
//  for (int i = 0; i < 7; i++) {
//    if (i % 2 == 0) {
//      fill(black);
//    } else {
//      fill(back);
//    }
//    rect(i*40, 0, 40, 5);
//    line(i*40, 0, i*40, 10);
//  }
//  line(7*40, 0, 7*40, 10);
//  pop();
//}






//void mouseReleased() {
//  noiseSeed(frameCount);
//  iso_up = new Isohypse(-200, 200, 10, 25, 55, 9, 3, 1);
//  iso_down = new Isohypse(width+200, height-200, 10, 35, 65, 12, 3, 1);
//  iso_big = new Isohypse(width/2, 3*height/2, 10, 35, 120, 12, 3, 0);
//}
