import controlP5.*;
import java.util.*;
import processing.svg.*;
import processing.video.*;
import com.hamoid.*;
import oscP5.*;
import netP5.*;
import processing.sound.*;
import themidibus.*;
import estudiolumen.simplepbr.*;

VideoExport videoExport;
Movie srcVideo;
boolean cheatScreen;
ControlFrame cf;
//pbrApp pbra;
int _frameRate = 30;

boolean exportingSVG = false;
boolean exportingVideo = false;

int numOfLines = 2000;

boolean greyScale = false;
boolean starStreakOn = false;
boolean channelsOn = true;
boolean gaussianOn = false;
boolean blurOn = true;
boolean glitchOn = true;
boolean grainOn = true;
 
PShader starglowstreak;
PShader radialStreak;
PShader tv;
PShader gaussian;
PShader myBlur2;
PShader channels;
PShader saturation;
PShader glitch;
PShader grain;
PShader waves;
PShader dupontSaturation;

boolean kickGate = false;
Envelope kickADSR;
float kick;
float kickVel=0;
boolean snareGate = false;
Envelope snareADSR;
float snare;
float snareVel=0;
boolean env3Gate = false;
Envelope env3ADSR;
float env3;


boolean cymGate = false;
Envelope cymADSR;
float cym;
boolean tomGate = false;
Envelope tomADSR;
float tom;
boolean rideGate = false;
Envelope rideADSR;
float ride;

Oscillator lfo1;
Oscillator lfo2;
Oscillator lfo3;
float lfo1Val;
float lfo2Val;
float lfo3Val;

//boolean trigger = false;

color dark = color(51,51,51);
color backgroundColor = dark;
color cream = color(255,245,245);
color lineColor = cream;
color cyan = color(00,147,211);
color magenta = color(204,01,107);
color yellow = color(255,241,13);
color green = color(01, 134,50);

float glitchAmp;
float amplitudeLFO = 1.f;
float tLFO = 1.f;
float fontSizeLFO = 1.f;
float ySliderLFO = 1.f;
float glitchAmount = 1;

OscP5 oscP5;
NetAddress myRemoteLocation;
MidiBus myBus; 

PFont font;

AudioIn input;
Amplitude loudness;

float volume = 0;
float lastVolume = 0;

float noiseScale = 0.001;
float noiseSpeed = 0.001;
float strokeThick = 0.35;

PGraphics textBox;
PGraphics scaledPG;

PShape bitterGreensText;
PShape charliText;

int sceneId = 0;

void setup() {
  size(960, 540, P3D);
  //size(1920, 1080, P2D);
  frameRate(_frameRate);
  //frameRate(24);
  smooth(0);
  
  dvdImage = loadImage("dvd.png");
  cf = new ControlFrame(this, 300, 500, "Controls");
  
  //starglowstreak = loadShader("myStarglowstreaks.glsl");
  //starglowstreak = loadShader("myRadialStreak.glsl");
  starglowstreak = loadShader("starStreak2.glsl");
  
  //radialStreak = loadShader(".glsl");
  tv = loadShader("tv1.glsl");
  gaussian = loadShader("myGaussian.glsl");
  myBlur2 = loadShader("myBlur2.glsl");
  channels = loadShader("channels.glsl");
  saturation = loadShader("mySaturation.glsl");
  glitch = loadShader("glitch.glsl");
  grain = loadShader("grain.glsl");
  waves = loadShader("waves.glsl");
  dupontSaturation = loadShader("dupontSaturation.glsl");
  
  //oscP5 = new OscP5(this,10201);
  //myRemoteLocation = new NetAddress("127.0.0.1",2727);
  //sendTestOSCMessage();
  
  myBus = new MidiBus(this, "osxVirtualBus", 0);
  
  kickADSR = new Envelope(0.01, .01, 0.75, .2);
  snareADSR = new Envelope(0.01, .25, 0.75, .25);
  env3ADSR = new Envelope(0.01, .01, 0.75, .2);
  
  
  tomADSR = new Envelope(0.01, .25, 0.75, .1);
  cymADSR = new Envelope(0.1, .5, 0.75, 1.5);
  rideADSR = new Envelope(0.1, .25, 0.75, .25);

  lfo1 = new Oscillator(_frameRate);
  lfo1.SetFreq(.1);
  
  lfo2 = new Oscillator(_frameRate);
  lfo2.SetFreq(.05);
  
  lfo3 = new Oscillator(_frameRate);
  lfo3.SetFreq(.025);
  
  textBox = createGraphics(100, 50,P2D);
  scaledPG = createGraphics(960, 540,P3D);
  //scaledPG = createGraphics(480, 270,P3D);
    
  SimplePBR.init(this, "data/textures/cubemap/Zion_Sunsetpeek"); // init PBR setting processed cubemap
  mat = new PBRMat("data/textures/material/Metal10/");
  bitterGreensText = loadShape("data/bittergreens2.obj");
  //bitterGreensText.rotateX(PI);
  charliText = loadShape("data/bittergreens2.obj");
  charliText.rotateX(PI);
  bitterGreensText.scale(0.9);
  setupSceneIdle();  
    
  // Create an Audio input and grab the 1st channel
  //input = new AudioIn(this, 0);
  //input.start();
  //loudness = new Amplitude(this);
  //loudness.input(input);
  
  //videoExport(); 
}



void keyPressed(KeyEvent ke){
  myKeyPressed(ke);
}

void mousePressed(){
   myMousePressed();
}

  

void draw() {

   resetShader();
  render();
  scaledPG.loadPixels();
  shaders();
  //scaledPG.loadPixels();
  if(sceneId!=5){
    image(scaledPG,0,0,width,height);
  }
  if(exportingVideo){videoExport.saveFrame();}
}
