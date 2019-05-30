import processing.serial.Serial;

Serial myPort;  // The serial port
int nl = 10;
// String desde el arduino
String inBuffer = "";


//Se crea instancia de clase Tablero
Tablero tablero;

//Se crean las imagenes
PImage v;
PImage play;
PImage play2;
PImage play3;
PImage playOH;
PImage playP;
PImage sombra;
PImage stars;
PImage stars2;
PImage close;
PImage closeOH;
PImage verifyC;
PImage verifyOHC;
PImage verifyE;
PImage verifyOHE;
PImage fPlayers;
PImage text4players;
PImage tPlayers;
PImage text2players;
PImage errorFichas;
PImage textError;
PImage id1;
PImage id2;
PImage id3;
PImage id4;
PImage turno1;
PImage turno2;
PImage turno3;
PImage turno4;
PImage victory1;
PImage victory2;
PImage victory3;
PImage victory4;
PImage celeb1;
PImage celeb2;
PImage celeb3;
PImage continuar;
PImage continuarOH;
PImage loading;

//String que representa el estado del juego
String state;

//Se crean los botones a usarse
Boton playB;
Boton closeB;
Boton verifyB;
Boton check;
Boton finish;

//Variables de comunicacion con Arduino
boolean playable;
boolean twoPlayers;

//Codigo que se ejecuta una vez
void setup() {
  // List all the available serial ports:
  printArray(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[0], 9600);  // COM6
  delay(200);
  //Se determina el size del canvas (donde se dibuja todo)
  fullScreen();
  
  //Carga de imagenes
  v = loadImage("v.png");
  play = loadImage("play.png");
  play2 = loadImage("play2.png");
  play3 = loadImage("play3.png");
  playOH = loadImage("playOH.png");
  playP = loadImage("playP.png");
  sombra = loadImage("sombra.png");
  stars = loadImage("stars.png");
  stars2 = loadImage("stars2.png");
  close = loadImage("close.png");
  closeOH = loadImage("closeOH.png");
  verifyC = loadImage("comenzar.png");
  verifyOHC = loadImage("comenzarOH.png");
  verifyE = loadImage("entendido.png");
  verifyOHE = loadImage("entendidoOH.png");
  fPlayers = loadImage("4players.png");
  text4players = loadImage("text4players.png");
  tPlayers = loadImage("2players.png");
  text2players = loadImage("text2players.png");
  errorFichas = loadImage("errorFichas.png");
  textError = loadImage("textError.png");
  id1 = loadImage("id1.png");
  id2 = loadImage("id2.png");
  id3 = loadImage("id3.png");
  id4 = loadImage("id4.png");
  turno1 = loadImage("turno1.png");
  turno2 = loadImage("turno2.png");
  turno3 = loadImage("turno3.png");
  turno4 = loadImage("turno4.png");
  victory1 = loadImage("victory1.png");
  victory2 = loadImage("victory2.png");
  victory3 = loadImage("victory3.png");
  victory4 = loadImage("victory4.png");
  celeb1 = loadImage("celeb1.png");
  celeb2 = loadImage("celeb2.png");
  celeb3 = loadImage("celeb3.png");
  continuar = loadImage("continuar.png");
  continuarOH = loadImage("continuarOH.png");
  loading = loadImage("Loading.png");
  
  state = "mainmenu";
  
  tablero = new Tablero(width/2, color(242, 234, 227));
  
  //Descomentar si se va a probar la aplicacion desde el estado "game"
  //tablero.setTablero();
  
  
}

//Funcion para simular diferentes escenarios sin Arduino
//void functionSimuladora(){
//  int rndPlayable = (int)random(0, 2);
//  playable = rndPlayable == 0 ? true : false;
  
//  if(playable){
//    int rndPlayers = (int)random(0, 2);
//    twoPlayers = rndPlayers == 0 ? true : false;
//  }
  
//}


//Codigo que se ejecuta en loop
void draw() {

  while (myPort.available() > 0) {
    inBuffer = myPort.readStringUntil(nl);  // Leer string hasta el \n
    if (inBuffer != null) {
      println("Buffer de entrada tamaño " + inBuffer.length());
      println(inBuffer);
      if(inBuffer.length() == 6){
        
        if(Character.toString(inBuffer.charAt(0)).equals("M")){
          tablero.selectedF = tablero.getFicha(Character.toString(inBuffer.charAt(2))+Character.toString(inBuffer.charAt(3)));
          println(Character.toString(inBuffer.charAt(2))+Character.toString(inBuffer.charAt(3)));    
      }
      
      if(Character.toString(inBuffer.charAt(0)).equals("F")){
          tablero.moverFicha(tablero.selectedF, tablero.getCasilla(Character.toString(inBuffer.charAt(2))+Character.toString(inBuffer.charAt(3))));
          tablero.selectedF = null;
          println("F: "+Character.toString(inBuffer.charAt(2))+Character.toString(inBuffer.charAt(3)));    
      }
        
      }
      
    }
  }

  
  playB = new Boton(play, 7*width/18, 3.5*height/6, width/4.5, width/4.5);
  
  switch(state){
    case "mainmenu":
      //Habilitar boton de play y dibujar menu
      playB.setEnabled(true);
      background(255);
      drawMenu();
    break;
    case "verification":
      //Deshabilitar boton de play, crear botones y dibujar verificacion sobre el menu
      playB.setEnabled(false);
      closeB = new Boton(close, 3*width/4, 3*height/50, width/12, height/10);
      verifyB = new Boton(verifyC, 3*width/8, 3.1*height/4, width/4, height/8);
      drawMenu();
      verify();
    break;
    case "game":
      //Mostrar fondo del juego
      //Sin borde
      noStroke();
      //Colorear
      fill(123, 166, 190);
      //Dibujar rectangulo exterior
      rect(0, 0, width, height);
      
      //Check simula boton para teminar juego
      check = new Boton(play, 0, 500, 100, 100);
      
      //Boton para volver a menu principal
      finish = new Boton(continuar, 1.01*width/3, 12.5*height/15, width/3, height/8);
      
      //Mostrar el tablero
      game();
    break;
    default:
    break;
  }
  
}



//Tiempo de referencia para animacion del boton play
int timeAnimationPlayB = 0;
//Contador animaciones boton play
int aPlayBCounter = 0;

//Tiempo de referencia para animacion estrellas
int timeAnimationStars = 0;
//Contador animaciones estrellas
int aStarsCounter = 0;

//Contador animaciones parpadeo
int aBlinkCounter = 0;

//Tiempo de referencia para animacion de victoria
int timeAnimationWin = 0;
//Contador animaciones victoria
int aWinCounter;

//Parte que dibuja la verificacion
void verify(){
  
  //Verificar datos de numero de jugadores solicitado al Arduino
  if(inBuffer.length() == 5){
        int cantidad = 0;
        cantidad = Integer.parseInt(Character.toString(inBuffer.charAt(2)));
        if(cantidad == 2){
          println("ENTROO");
          twoPlayers = true;
          playable = true;
        }else if(cantidad == 4){
          twoPlayers = false;
          playable = true;
        }else if(cantidad == 0){
          playable = false;
        }
      }
  
  
  //Rectangulo que oscurece fondo
  noStroke();
  fill(50, 50, 50, 100);
  rect(0, 0, width, height);
  
  //Rectangulo de interfaz
  noStroke();
  fill(240);
  rect(width/5, height/10, 0.6*width, 0.55*width, 100);
  
  println(playable);

  //No dibujar hasta que se haya recibido numero de jugadores
  if(inBuffer.length() == 5){
    
    //Mostrar y agregar imagen al hover del boton de cerrar
    closeB.onHover(closeOH);
    closeB.mostrar();
    
    //Cambiar state a menu principal
    if(closeB.clicked()){
      state = "mainmenu";
      inBuffer = "";
    }
    
     //Muestra texto segun si es jugable y cuantos jugadores son
    if(playable){
      
      //Mostrar y agregar imagen al hover del boton de verificacion y mostrar Comenzar/Entendido segun sea el caso
      verifyB.setImg(verifyC);
      verifyB.onHover(verifyOHC);
      verifyB.mostrar();
      //
      if(twoPlayers){
        image(tPlayers, 9*width/40, 2*height/10, 0.55*width, 0.15*height);
        image(text2players, 9*width/40, 4*height/10, 0.55*width, 0.35*height);
      }else{
        image(fPlayers, 9*width/40, 2*height/10, 0.55*width, 0.15*height);
        image(text4players, 9*width/40, 4*height/10, 0.55*width, 0.35*height);
      }
      
      //Cambiar state a game
        if(verifyB.clicked()){
          state = "game";
          tablero.setTablero();
          myPort.write('C');
        }
      
    }else{
        image(errorFichas, 9*width/40, 1.5*height/10, 0.55*width, 0.13*height);
        image(textError, 9*width/40, 3*height/10, 0.55*width, 0.46*height);
        
        verifyB.setImg(verifyE);
        verifyB.onHover(verifyOHE);
        verifyB.mostrar();
        
        //Cambiar state a menu principal
        if(verifyB.clicked()){
          state = "mainmenu";
        }
    }
    
  }else{
    
    //Rectangulo que oscurece fondo
    noStroke();
    fill(50, 50, 50, 100);
    rect(0, 0, width, height);
    
    //Rectangulo de interfaz
    noStroke();
    fill(240);
    rect(width/5, height/10, 0.6*width, 0.55*width, 100);
    
     //Mostrar pantalla de carga
    image(loading ,9*width/40, 3*height/20, 0.55*width, 0.50*width);
   
    
  }
  
}


//Parte que dibuja el menu principal
void drawMenu(){
  
  //FONDO
  
  if(aStarsCounter == 0){
    image(stars, 0, 0, width, height);
  }else{
    image(stars2, 0, 0, width, height);
  }
  if (millis() - timeAnimationStars >= 1000)
  {
    aStarsCounter = aStarsCounter == 0 ? 1 : 0; 
    timeAnimationStars = millis();
  }
   
  //LOGO
  
  //Posicion relativa de los componentes del logo
  final float POSICION = width/6;
  //Size relativo de los componentes del logo
  final float SIZE = width/6;
  
    //Dibujar sombra de logo
  image(sombra, width/3, 3.5*height/10, width/3, height/10);
  
  //O izquierda
  stroke(255);
  fill(0);
  ellipse(width/2 - SIZE*0.8, POSICION, SIZE, SIZE);
  
  //O interior izquierda
  if(playB.hovered()){
    stroke(255);
    strokeWeight(7);
    noFill();
    arc(width/2 - SIZE*0.8, POSICION + SIZE/4, SIZE*0.45, SIZE*0.45, -PI, 0);
  }else{
    stroke(255);
    fill(255);
    ellipse(constrain(mouseX/1.2, width/2 - SIZE*0.8 - SIZE/4, width/2 - SIZE*0.8 + SIZE/4), constrain(mouseY/1.5, POSICION - SIZE/4, POSICION + SIZE/4), SIZE*0.45, SIZE*0.45);
  }
  
  //v 
  image(v, 17*width/40, POSICION - SIZE/2, SIZE*0.9, SIZE*0.9);
  
  //O derecha
  stroke(255);
  fill(0);
  ellipse(width/2 + SIZE*0.8, POSICION, SIZE, SIZE);
  
  //O interior derecha
  if(playB.hovered()){
    stroke(255);
    strokeWeight(7);
    noFill();
    arc(width/2 + SIZE*0.8, POSICION + SIZE/4, SIZE*0.45, SIZE*0.45, -PI, 0);
  }else{
    stroke(255);
    strokeWeight(5);
    fill(255);
    ellipse(constrain(mouseX/1.2, width/2 + SIZE*0.8 - SIZE/4, width/2 + SIZE*0.8 + SIZE/4), constrain(mouseY/1.5, POSICION- SIZE/4, POSICION + SIZE/4), SIZE*0.45, SIZE*0.45);
  }
    
  //BOTON
  
  //Dibujar imagen del boton, mostrar cada imagen en secuencia cada segundo
  if(!playB.hovered()){
    if(aBlinkCounter == 0){
      playB.setImg(play2);
    }else if(aBlinkCounter == 1){
      playB.setImg(play);
    }else{
      playB.setImg(play3);
    }
    if (millis() - timeAnimationPlayB >= 1000)
    {
      aBlinkCounter++;
      aBlinkCounter = aBlinkCounter == 3 ? 0 : aBlinkCounter; 
      timeAnimationPlayB = millis();
    }
  //Mostrar otra imagen si el mouse esta encima o hace clic
  }else{
    if(!playB.clicked()){
      playB.onHover(playOH);
    }else{
      playB.onClic(playP);
      
      //Se solicita al Arduino el numero de jugadores
      myPort.write("P"); 
      println("Se manda a pedir la cantidad de jugadores");    
      
          
      state = "verification";
    } 
  }
  
  playB.mostrar();
    
}


//Funcion que representa funcionalidad del juego
void game(){
 // check.mostrar();
  println(inBuffer.length());
      if(inBuffer.length() == 5){
        println("Buffer"+inBuffer.toString());
        println("Turno"+tablero.playerId);
        if(Character.toString(inBuffer.charAt(2)).equals("N")){
          tablero.checkWinner(tablero.playerId);
            
        } 
      }
 tablero.mostrar();
 if(tablero.ended){
   myPort.write("R");
 }
}
