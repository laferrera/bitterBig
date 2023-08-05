void myKeyPressed(KeyEvent ke){
  key = ke.getKey();
  switch (key) {
    case 'e': videoExport(); break;
    case 'g': saveFrame(); break;
    case 'p': printInfo(); break;
    case 'q': { videoExport.endMovie(); exit();}
    case '0': { sceneId = 0;setupSceneIdle();} break;
    case '1': { sceneId = 1;loadSceneNoise();} break;
    case '2': { sceneId = 2;loadSceneBox();} break;
    case '3': { sceneId = 3;loadSceneFungi();} break;
    case '4': { sceneId = 4;loadSceneWaves();} break;
    case '5': { sceneId = 5;loadScene3dTxt();} break;
    case '6': { sceneId = 6;loadSceneSine();} break;
    case '7': { sceneId = 7;loadSceneAnchovy();} break;
    case '8': { sceneId = 8;loadSceneMap();} break;    
    //case 't': {trigger = !trigger; break;}
  }
   
}

void myMousePressed(){
  //noiseOctaves = int(map(mouseX, 0, width,1,12));
  //noiseFallOff = map(mouseY, 0, height,0,0.5);
}
