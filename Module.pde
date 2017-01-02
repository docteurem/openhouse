class Module{
  RShape shapes = new RShape();
  ArrayList subModules = new ArrayList();
  boolean completed = false;
  
  Module(RShape sh){
  
    sh = externalPaths(sh);
    //sh = checkDirection(sh);
    shapes.addChild(sh); 
  }
  
  void draw(){
    
    for(int i = 1; i < shapes.children.length; i++){
      shapes.children[i].draw();
    }
    
  //shapes.draw();
   
    for(int i = 0; i < subModules.size(); i++){
      Module subM = (Module) subModules.get(i);
      subM.draw();
    }
  }
  
  
  void addSubModule(Module m){
    subModules.add(m);
  }
  
  RShape externalPaths(RShape src){
    RShape newSrc = new RShape();
   
    //on va comparer chaque path avec tous les autres pour décider si il est contenu dans un autre.
    //si pas, on l'ajoute à newSrc  
    for(int i = 0; i < src.paths.length; i++){
        RPath currentPath = src.paths[i];
        boolean external = true;
        
        for(int j = 0; j < src.paths.length && external; j++){
          if(i==j) continue;
          external = isOutside(currentPath, src.paths[j]);
        }
        if(external)
          newSrc.addPath(currentPath);
  
    }
    return newSrc;

  }
  
  //vérifier le sens de dessin de la lettre et corriger si besoin
  RShape checkDirection(RShape src){
    /*
    points = src.getPoints();
    RPoint currPoint = points[0];
    RPoint lastPoint = getLastPoint(points, 0);
    RPoint nextPoint = getNextPoint(points, 0);
    
    float angle = atan2(lastPoint.y-currPoint.y, lastPoint.x-currPoint.y) - atan2(currPoint.y-nextPoint.y, currPoint.x-nextPoint.y);
    if(angle > TWO_PI)
      angle -= TWO_PI;
    
    
    if(angle > PI && angle < TWO_PI){
      points = (RPoint[]) reverse(points);
      RPoint newPoints[][] = new RPoint[1][];
      newPoints[0] = points;
      
      print(degrees(angle)+"\n");
      return new RShape(newPoints);
    }
    
    //if(atan2(firstPoint.y-secondPoint.y, firstPoint.x-secondPoints.y)
    */
    return src;
    
  }
  
  void addStep(boolean direction){
     int dir = 1;
     
     if(!direction)
       dir = -1;
     
     //on initialise le tracé de base (lastShape)
      RShape lastShape = new RShape(shapes.children[shapes.children.length-1]);
      
     
      
      //on crée un nouveau tracé à partir du tracé précédent contenu dans lastShape
      points = lastShape.getPoints();
      if(points == null) return;
      if(points.length < 4) {
        completed = true;
      return;}
      
      RPoint[][] newPoints = new RPoint[1][points.length];
      RPoint last;
      RPoint next;
      
      //print(" "+points.length+" ");
      //pour chaque point du tracé
      for(int i=0; i<points.length; i++){
        
        if(progressiveDist)
          distStroke = map(currentStep, 1, steps, minDist, maxDist);
        
        last = getLastPoint(points, i);
        next = getNextPoint(points, i);
        float angleprev = (atan2(last.y-points[i].y, last.x-points[i].x)+dir*PI/2);
        float anglenext = (atan2(points[i].y-next.y, points[i].x-next.x)+dir*PI/2);
        
        
        //la différence entre cet angle et un angle de 90°
        float angleDiff = abs(degrees(angleprev-anglenext))%90;
        
        //on map cette différence sur la distance entre les traits
        float currDist = map(angleDiff, 90, 0, 0, -distStroke/2)+distStroke;
        
        //print(map(angleDiff, 90, 0, 0, 10)+" ");
        
       
        RPoint curr = new RPoint(points[i].x+cos(angleprev)*currDist, points[i].y+sin(angleprev)*currDist);
        curr.x = curr.x+cos(anglenext)*currDist;
        curr.y = curr.y+sin(anglenext)*currDist;
        
        
        
        //float angle = atan2(points[k].y-curr.y, points[k].x-curr.x);
        //curr = new RPoint(points[k].x-cos(angle)*distStroke, points[k].y-sin(angle)*distStroke);
        
        newPoints[0][i] = curr;
        
        
        
      
      }
      
      newPoints = makeIntersections(newPoints);
      newPoints = removeDuplicate(newPoints);
      RShape newShape = new RShape(newPoints);
      
      
      
      
      if(newShape.getArea() < 10 || (lastShape.getArea() <= newShape.getArea() && !direction)||(lastShape.getArea() >= newShape.getArea() && direction))
        completed = true;
      else
        shapes.addChild(newShape);
       
     
  }
  RPoint[] getLastPoints(){
    RShape last = shapes.children[shapes.children.length-1];
    return last.getPoints();
  }
  RShape getLastShape(){
    return shapes.children[shapes.children.length-1];
  }
  
  
  
}