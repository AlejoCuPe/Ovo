//Clase que representa a cada ficha
class Ficha extends Boton {
  
  //Corresponde al id de la casilla donde se encuentra ubicada
  String posicion;
  
  //Permite saber si la ficha esta puesta o levantada
  boolean isSet = true;
  
  //Permite saber si la ficha esta oculta
  boolean isHidden = false;
  
  //Permite colorear degradado
  int s;
  
  //Tablero al que corresponde
  Tablero t;
  
  //Numero de jugador al que corresponde la ficha
  int playerId;
  
  //Imagen para identificar fichas
  PImage img;
  
  //Indica las casillas objetivo segun el jugador
  String[] objective;
  
  //Indica las casillas objetivo del contrincante
  String[] objectiveF;
  
  Ficha(float x,float y, float h, float w, String posicion, Tablero t, int playerId){ 
    super(x, y, h, w);
    this.posicion = posicion;
    this.t = t;
    this.playerId = playerId;
    setParameters();
  }
  
  //Funcion para dibujar circulo con degradado 
  void mostrar() {
    s = this.hovered()? 30 : 0;
    for (int r = (int)h; r > 0; --r) {
      fill(200+s, 190+s, 200+s);
      ellipse(x, y, r, r);
      if(r%1==0){   s+=1; }
    }  
    if(!isHidden) image(this.img, x - w/10, y - h/8, w/6, h/4);
  }
  
  //Funcion que asigna la imagen y el objetivo segun el jugador
  void setParameters(){
    switch(playerId){
      case 1:
        this.img = id1;
        if(twoPlayers){ objective = new String[]{"50","51","52","53","54","55"}; objectiveF = new String[]{"00","01","02","03","04","05"}; }
        if(!twoPlayers){ objective = new String[]{"40", "41", "50", "51"}; objectiveF = new String[]{"00","01","10","11"}; }
        break;
      case 2:
        this.img = id2;
        if(twoPlayers){ objective = new String[]{"00","01","02","03","04","05"}; objectiveF = new String[]{"50","51","52","53","54","55"}; }
        if(!twoPlayers){ objective = new String[]{"44", "45", "54", "55"}; objectiveF = new String[]{"04","05","14","15"}; }
        break;
      case 3:
        this.img = id3;
        if(!twoPlayers){ objective = new String[]{"04","05","14","15"}; objectiveF = new String[]{"44", "45", "54", "55"}; }
        break;
      case 4:
        this.img = id4;
        if(!twoPlayers){ objective = new String[]{"00","01","10","11"}; objectiveF = new String[]{"40", "41", "50", "51"}; }
        break;
    }
      
  }
  
  //Funcion que asigna nueva posicion a la ficha
  void mover(Casilla c) {
    this.posicion = c.id;
    this.x = c.x + c.size/12;
    this.y = c.y + c.size/12;
  }
  
   //Funcion para configurar estado oculto/visible de la ficha
  void setHidden(boolean tof){
    this.isHidden = tof;
  }
  
  //Funcion para verificar si el mouse esta encima
  boolean hovered(){
    float disX = x - mouseX;
    float disY = y - mouseY;
    if(sqrt(sq(disX) + sq(disY)) < w/2 ) {
      return true;
    } else {
      return false;
    }
  }
   
}
