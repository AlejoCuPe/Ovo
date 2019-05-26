//Clase que representa cualquier boton hecho con una imagen
class Boton {
  
  //Parametros que indican: coordenadas (x, y), size (w * h) y la imagen que representa al boton (img)
  float x;
  float y;
  float w;
  float h;
  PImage img;
  boolean enabled = true;
  
  //Constructora sin imagen
  Boton (PImage img, float x, float y, float w, float h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.img = img;
  }
  
  //Constructora sin imagen
  Boton (float x, float y, float w, float h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  //Metodo que permite cambiar la imagen
  void setImg(PImage img){
    this.img = img;
  }
  
  //Metodo para desactivar boton
  void setEnabled(boolean tof){
    this.enabled = tof;
  }
  
  //Metodo que dibuja el boton
  void mostrar(){
    image(this.img, this.x, this.y, this.w, this.h);
  }
  
  //Metodo que verifica si el mouse esta encima del boton
  boolean hovered(){
    if(enabled){
      if (mouseX >= x && mouseX <= x+w && 
        mouseY >= y && mouseY <= y+h) {
      return true;
      } else {
        return false;
      }
    }
    return false;
  }
  
  //Metodo que verifica si se ha clickeado
  boolean clicked(){
    if(enabled){
      if(this.hovered() && mousePressed){
        return true;
      }
      return false;
    }
    return false;
  }
  
  //Metodo para modificar la imagen cuando el mouse esta encima 
  void onHover(PImage img){
    if(this.hovered()) this.setImg(img);
  }
  
  //Metodo para modificar la imagen cuando se hace clic
  void onClic(PImage img){
    if(this.clicked()) this.setImg(img);
  }
  
}
