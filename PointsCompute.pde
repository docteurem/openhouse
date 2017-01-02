
//pour chaque point, s'il y en a eu au moins 3 précédemment, 
//il y a intersection possible (puisque deux segments) 
//il faut vérifier que le segment qu'il forme avec le point précédent 
//ne coupe pas un autre segment        
RPoint[][] makeIntersections(RPoint[][] points){

  RPoint[] intersections;
  RPath prevSeg;
  if(currentStep == 60)
      print(points[0].length+" ");
  for(int i = 3; i < points[0].length-1; i++){
     RPath currSeg = new RPath(points[0][i]);
     currSeg.addLineTo(points[0][i-1]);
     //on commence par tester l'intersection du segment courant avec le dernier
     /*if(i < points[0].length-3){
       prevSeg = new RPath(points[0][points[0].length-2]);
       prevSeg.addLineTo(points[0][points[0].length-3]);
       intersections = currSeg.intersectionPoints(prevSeg);
       if(intersections != null){
         print(points[0].length);
         //il y a un point d'intersection!
         points = joinIntersections(i-1, -2, points, intersections[0]);
         stroke(0, 255, 0);
         line(points[0][i].x, points[0][i].y, points[0][i-1].x, points[0][i-1].y); 
         
         stroke(0, 0, 255);
         line(points[0][points[0].length-2].x, points[0][points[0].length-2].y, points[0][points[0].length-3].x, points[0][points[0].length-3].y);
         stroke(255, 0, 0);
         
         ellipse(intersections[0].x, intersections[0].y, 3, 3);
         stroke(0);
       }
     }*/
     //on teste les autres intersections
     for(int j = i-2; j > 0; j--){
       if(i == points[0].length-2 && j == 1) continue;
       prevSeg = new RPath(points[0][j]);
       prevSeg.addLineTo(points[0][j-1]);
       intersections = currSeg.intersectionPoints(prevSeg);
       if(intersections != null){
          //stroke(255, 0, 0);
         
         //ellipse(intersections[0].x, intersections[0].y, 3, 3); 
         
         //il y a un point d'intersection!
         points = joinIntersections(i-1, j, points, intersections[0]);
        
       }
     }
  }
    if(currentStep == 60)
      print(points[0].length);
  return points;
}

//on ramène les points intermédiaires au point d'intersection
RPoint[][] joinIntersections(int start, int end, RPoint[][] points, RPoint intersect){
  
  if(start-end > points[0].length-(start-end)){
    
    /*stroke(255, 0, 0);
    ellipse(points[0][start].x,points[0][start].y, 10, 10);   
    ellipse( intersect.x, intersect.y, 3, 3); 
    
    stroke(0, 255, 0);
    ellipse(points[0][end].x,points[0][end].y, 10, 10);   
    */
    int tmp = start;
    start = end;
    end = points[0].length-tmp;
    end = -end;
    
    stroke(0);
    //return points;

  }
 

  for(int i = start; i >= end; i--){
    
    //print("ok "+i+" aaaa ");
    int ind;
    if(i < 0)
      ind = points[0].length+i;      
    else
      ind = i;
      
    if(points[0][ind].x != intersect.x && points[0][ind].y != intersect.y)
      points[0][ind] = intersect;
    
    nbToClean++;
    
  }
  nbToClean--;
  return points;
}


RPoint[][] removeDuplicate(RPoint[][] points){
  //on va compter le nombre de valeurs différentes 
  //pour pouvoir créer un nouveau tableau à la bonne taille
  int nbIndiv = 1;
  for(int i = 1; i < points[0].length; i++){
    if(dist(points[0][i].x, points[0][i].y, points[0][i-1].x, points[0][i-1].y) > typoTreshold)
      nbIndiv++;
  }
  
  RPoint[][] newPoints = new RPoint[1][nbIndiv];
  int j = 1;
  newPoints[0][0] = points[0][0];
  for(int i = 1; i < points[0].length; i++){
    //print(points[0][i].x+" != "+points[0][i-1].x+" || "+points[0][i-1].y+" != "+points[0][i].y+"\n");
    if(dist(points[0][i].x, points[0][i].y, points[0][i-1].x, points[0][i-1].y) > typoTreshold){
      newPoints[0][j] = points[0][i];
      j++;
    }
  }
  //on s'assure que le premier point est toujours égal au dernier point de la forme
  newPoints[0][nbIndiv-1] = newPoints[0][0];
  return newPoints;
}





boolean isOutside(RPath pa, RPath pb){
  RShape a = pa.toShape();
  RShape b = pb.toShape();
  if(b.contains(a.getTopLeft()) && b.contains(a.getTopRight()) && b.contains(a.getBottomLeft()) && b.contains(a.getBottomRight())){
    return false;
  }
  else return true;
}

RPoint getLastPoint(RPoint[] points, int i){
  RPoint current = points[i];
  int j;
  for(j = i-1; true; j--){
    if(j < 0)
      j = points.length-1;
    
    if(dist(points[j].x,points[j].y, current.x, current.y) > typoTreshold){
      break;
    }
    
    
  }
  
  return points[j];

}

RPoint getNextPoint(RPoint[] points, int i){
  RPoint current = points[i];
  int j;
  for(j = i+1; true; j++){
    if(j > points.length-1)
      j = 0;
    
    if(points[j].x != current.x || points[j].y != current.y){
      break;
    }
    
    
  }
  
  return points[j];

}