import geomerative.*;
import processing.pdf.*;



//le fichier source svg
String srcFile = "poster2.svg";

//nombre d'itérations
int steps = 200;

//simplification des formes (permet de corriger les points superposés ou les défauts de typo)
float typoTreshold = 0.01;

//distance entre chaque trait
float distStroke = 1.1;

float minDist = 1.1;
float maxDist = 3;

boolean progressiveDist = true;

//le plan qui devra être traité
RShape src;

//une copie du plan initial
RShape initSrc;

RPoint[] points;

ArrayList modules = new ArrayList();

boolean record = true;

int nbToClean = 0;
int currentStep = 0;
void setup(){
  size(1200, 1200);
  if(record)
  beginRecord(PDF, "export.pdf");
  smooth();
  RG.init(this);
  RG.setPolygonizer(RG.ADAPTATIVE);
  //RCommand.setSegmentLength(5);

  src = RG.loadShape(srcFile);
  initSrc = RG.loadShape(srcFile);
  
  //on stocke chaque forme dans un module et on le met dans l'arrayList
  for(int i = 0; i < src.children.length; i++){
   
   
   if(src.children[i].paths != null)
     modules.add(new Module(src.children[i]));
 
 
  }
  print("###################################"+"\n");
  
  //src.centerIn(g);
  //initSrc.centerIn(g);
  
  //src.scale(0.9);
  //initSrc.scale(0.9);
  
  

}

void draw(){
  //background(255);
  // Set the origin to draw in the middle of the sketch
  //translate(width/2, height/2);
  noFill();
  
  RG.setPolygonizer(RG.UNIFORMLENGTH);
  RG.setPolygonizerLength(2);
  

  stroke(0);
  //initSrc.draw();
 
  
  //pour chaque itération
  for(int i = 1; i < steps+1; i++){
    print("\n#################################\n"+i+"\n");
    currentStep = i;
    for(int j = 0; j < modules.size(); j++){
      //print(j+" ");
      
      Module mod = (Module) modules.get(j);
      
      if(mod.completed) continue;
      
      mod.addStep(true);
      print("step"+j);
      
    }
    
    //on vérifie s'il faut joindre deux nouveaux tracés
    joinModules();
    
  }
  
  for(int i = 0; i < modules.size(); i++){
    Module mod = (Module) modules.get(i);
    mod.draw();
  }
  

 

 if(record)
 endRecord();
    
  
}

void joinModules(){
  ArrayList newModules = modules;
  
  for(int i = 1; i < modules.size(); i++){
    Module a = (Module) modules.get(i);
    RPoint[] aPoints = a.getLastPoints();
    RPath aPath = new RPath(aPoints);  
    for(int j = 0; j < i; j++){
      Module b = (Module) modules.get(j);
      RPoint[] bPoints = b.getLastPoints();
    
      RPath bPath = new RPath(bPoints);
      RPoint[] intersections = aPath.intersectionPoints(bPath);
      if(intersections != null){
        
  
        RShape aShape = a.getLastShape();
        RShape bShape = b.getLastShape();
        Module mod = new Module(aShape.union(bShape));
        a.shapes.children = (RShape[]) shorten(a.shapes.children);
        b.shapes.children = (RShape[]) shorten(b.shapes.children);
        mod.addSubModule(a);
        mod.addSubModule(b);
        
        newModules.set(i, mod);
        newModules.remove(j);
        modules = newModules;
        joinModules();
        return;
      }
    }
  }
  
}