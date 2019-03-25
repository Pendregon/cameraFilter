import java.lang.*;
import processing.video.*;
import cvimage.*;
import org.opencv.core.*;

Capture cam;
CVImage img,auximg;
int iter;

void setup(){
  size(640,480);
  cam=new Capture(this,width,height);
  cam.start();
  
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  
  img = new CVImage(cam.width,cam.height);
  auximg = new CVImage(cam.width,cam.height);
  iter=0;
}

void draw(){
  if(cam.available()){
    background(0);
    cam.read();
    img.copy(cam,0,0,cam.width,cam.height,0,0,img.width,img.height);
    img.copyTo();
    
    Mat gris = img.getGrey();
    if(iter==0){
      image(img,0,0);
      iter++;
    }else if(iter==1){
      cpMat2CVImage("red",gris,auximg);
      image(auximg,0,0);
      iter++;
    }else if(iter==2){
      cpMat2CVImage("green",gris,auximg);
      image(auximg,0,0);
      iter++;
    }else if(iter==3){
      cpMat2CVImage("blue",gris,auximg);
      image(auximg,0,0);
      iter=0; 
    }
    gris.release();
  }
}

void cpMat2CVImage(String col,Mat in_mat,CVImage out_img){
  byte[] data8 = new byte[cam.width*cam.height];
  out_img.loadPixels();
  in_mat.get(0,0,data8);
  int valR=0,valG=0,valB=0;
  for(int x=0;x<cam.width;x++){
    for(int y=0;y<cam.height;y++){
      int loc = x+y*cam.width;
      int val = data8[loc] & 0xFF;
      if(col=="red"){
        valR = val;
      }else if(col=="green"){
        valG = val;
      }else if(col=="blue"){
        valB = val;
      }
      out_img.pixels[loc] = color(valR,valG,valB);
    }
  }
  out_img.updatePixels();  
}

