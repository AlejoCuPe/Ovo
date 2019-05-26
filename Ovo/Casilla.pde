//Clase que representa cada casilla
class Casilla {
  
  //Booleano que permite saber si esa casilla esta ocupada  
  boolean ocuppied;
  //Booleano que permite resalta una casilla
  boolean coloured;
  //Size de la casilla (cada casilla es un rectangulo con un circulo adentro)
  int size;
  //Punto en x donde estara la esquina superior izquierda de la casilla
  int x;
  //Punto en y donde estara la esquina superior izquierda de la casilla
  int y;
  //Color de la casilla
  color pColor;
  //Identificador es fila+columna
  String id;
  //Permite colorear degradado
  int s;
  //Tablero al que pertenece
  Tablero t;
  
  //Constructor de la casilla
  Casilla (int size, color pColor, int x, int y, String id, Tablero t) {
    this.size = size;
    this.pColor = pColor;
    this.x = x;
    this.y = y;
    this.id = id;
    this.t = t;
  }
  
  //Dibujar casilla en el canvas
  void mostrar() { 
    //Sin borde
    noStroke();
    //Colorear
    fill(pColor);
    //Dibujar rectangulo de la casilla
    rect(x, y, size/6, size/6);
    
    //Sin borde
    noStroke();
    //Llamar funcion para dibujar elipse 
    circle(x, y);  
  }
  
  void setX (int x){
    this.x = x;
  }
  
  //Funcion para dibujar circulo con degradado 
  void circle(float x, float y) {
      s = this.hovered() && this.coloured? 20 : 0;
      for (int r = size/7; r > 0; --r) {
        if(this.coloured){ fill(192+s, 224+s, 192+s); } else { fill(120+s); }
        ellipse(x + size/12, y + size/12, r, r);
        if(this.coloured){ s+=1; } else { s+=4; }
      }
  }
  
  //Determinar si la casilla esta ocupada
  void setOcuppied(boolean tof){
    this.ocuppied = tof;
  }
  
  //Determinar si se resalta la casilla
  void setColoured(boolean tof){
    this.coloured = tof;
    this.mostrar();
  }
  
  //Funcion a ejecutar cuando se clickea
  void onClickListener(){
    if(this.clicked()){
      t.moverFicha(t.selectedF, this);
    }
  }
  
  //Metodo que verifica si se ha clickeado, solo se puede clickear si esta resaltada
  boolean clicked(){
    if(coloured){
      if(this.hovered() && mousePressed){
        return true;
      }
      return false;
    }
    return false;
  }
  
  //Funcion para verificar si el mouse esta encima
  boolean hovered(){
    float disX = x + size/12 - mouseX;
    float disY = y + size/12 - mouseY;
    if(sqrt(sq(disX) + sq(disY)) < size/14 ) {
      return true;
    } else {
      return false;
    }
  }
  
}
