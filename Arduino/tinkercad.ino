/*
	Vim Stuff: https://linuxhandbook.com/basic-vim-commands/
	4X4 SIMLATION ON TINKERCAD: https://www.tinkercad.com/things/6dSU9mU8tI3-proyectov4/editel
	A0 instead of 14
	https://www.baldengineer.com/tips/arduino-pinmode-on-analog-inputs
*/
String jugadoresLetras = "ABCD";
const byte tamanoTablero = 4;
const int entradas[tamanoTablero][tamanoTablero] = {
                                                   {0, 2, 3, 4},
                                                   {5, 6, 7, 8},
                                                   {9, 10, 11, 12},
                                                   {13, 14, 15, 16}
                                                 };

// La RX no pasa nada PERO con la TX se jode por que se intenta
// comunicar

/*
  Para 2 jugadores seran jugador A y B, Para 4 seran jugador A,B,C Y D.
  
*/

String tablero[tamanoTablero][tamanoTablero];
byte cantidadJugadores = 0;
boolean enJuego = false;


byte partidaI;
byte partidaJ;
byte finI;
byte finJ;

void setup()
{
  Serial.begin(9600);
  for(byte i = 0; i < tamanoTablero; i++){
    for(byte j = 0; j < tamanoTablero; j++){
      pinMode(entradas[i][j], INPUT);
    }
  }
}

void loop()
{	
  Serial.println(cantidadJugadores);
  if(cantidadJugadores == 0){
       cantidadJugadores = identificarJugadores();
       if(cantidadJugadores == 2){
         // Configurar para dos
         configurarTablero(2);
         enJuego = true;
       }else if(cantidadJugadores == 4){
         // Configurar para 4
         configurarTablero(4);
         enJuego = true;
       }
    
  }
  if(enJuego){
    // Se comenzo/esta juegando
    Serial.println("Se inicia ya que se ocuparon los puestos");
    
    for(byte i = 0; i < cantidadJugadores; i++){
      // Tomar turno para el jugador 
      Serial.print("El jugador ");
      Serial.println(jugadoresLetras[i]);
      
      // Registrar movimiento
      registroMovimiento();
      delay(1000);
      identificarLlegada();
      
      partidaI = 10;
      partidaJ = 10;
      delay(3000);
    }
      
  }
   
   imprimirTablero();
   
   //imprimirValores();
}

/*
  Detectar el movimiento del huevo, comparando los valores en las posiciones dependiendo del turno
  del jugador
  
*/
void registroMovimiento(){
  // Conocer partida
  for(byte i = 0; i < tamanoTablero; i++){
    for(byte j = 0; j < tamanoTablero; j++){
      // En la posicion electronica se pasa a cero entonces veo lo que habia antes
      if(tablero[i][j].length() > 0  && digitalRead(entradas[i][j]) == LOW){
        // De donde se partio
        partidaI = i;
        partidaJ = j;
        break;
      }
    }
  }
}

/*
  Identificacion de a donde se movio el huevo
  
*/
void identificarLlegada(){
  if(partidaI != 10){
      // Identificar fin
    for(int i = 0; i < tamanoTablero; i++){
      for(int j = 0; j < tamanoTablero; j++){
        if( tablero[i][j].length() < 1 && digitalRead(entradas[i][j]) == HIGH){ 
          // A donde llego
          String nuevaP = tablero[partidaI][partidaJ] ;
          Serial.println("Valor de partida");
          Serial.println(nuevaP);
          
          
          String iN = String(i);
          String jN = String(j);
          nuevaP.setCharAt(4, iN[0]);
          Serial.print("Reemplazar el 4 ->");
          Serial.println(nuevaP);
          nuevaP.setCharAt(6, jN[0]);
          Serial.print("Reemplazar el 6 ->");
          Serial.println(nuevaP);
          tablero[i][j] = nuevaP;
          Serial.println("Valor de llegada cambiado");
          Serial.println(nuevaP);
          tablero[partidaI][partidaJ] = "";
          finI = i;
          finJ = j;
          
          Serial.print("Partida i ");
          Serial.print(partidaI);
          Serial.print(", j ");
          Serial.print(partidaJ);
          Serial.println("------");
          
          Serial.print("fin i ");
          Serial.print(finI);
          Serial.print(", j ");
          Serial.print(finJ);
          Serial.println("------");
                
        
          break;
      }
    }
  }
  
  
  }
  
}


/*Inicializa el tablero de acuerdo a la cantidad de jugadores detectados al inicio*/
void configurarTablero(byte jugadores){
  if(jugadores == 2){
    String strA = "A:I:0,";
    String strB = "B:I:3,";
    for(byte j = 0; j < tamanoTablero; j++){
      tablero[0][j] = strA + j;
      tablero[tamanoTablero-1][j] = strB + j;
    }
  }else{
    String strA = "A:I:0,0";
    String strB = "B:I:0,3";
    String strC = "C:I:3,0";
    String strD = "D:I:3,3";

    tablero[0][0] = strA;

    tablero[0][tamanoTablero-1] = strB;

    tablero[tamanoTablero-1][0] = strC;

    tablero[tamanoTablero-1][tamanoTablero-1] = strD;

  }
}

/*
  Funcion para identificar la cantidad de jugadores, viendo si en ciertas areas del tablero al iniciar se encuentran 
  posicionandos los huevos.
*/
byte identificarJugadores(){
  byte num = 0;
  // Observar si solo son dos jugadores
  int suma = 0;
  
  for(byte j  = 0; j < tamanoTablero; j++ ){
      suma += digitalRead(entradas[0][j]);  // Primeros 6 botones, entradas es un multiarray
      suma += digitalRead(entradas[tamanoTablero-1][j]);  // Ultimos 6 botones, entradas es un multiarray 
  }
  if(suma == tamanoTablero*2){
    num = 2; // Solo son 2 jugadores
  }else{
    // Chequear los 4 
    num = 0;
    if(digitalRead(entradas[0][0]) == HIGH && digitalRead(entradas[0][tamanoTablero-1]) == HIGH
      && digitalRead(entradas[tamanoTablero-1][0]) == HIGH && digitalRead(entradas[tamanoTablero-1][tamanoTablero-1]) == HIGH
      ){
      num = 4;
    }
  }
    
  return num;
}



void imprimirValores(){
  for(byte i = 0; i < tamanoTablero ; i++){
    for(byte j = 0; j < tamanoTablero; j++){
      Serial.print("Valor fila ");
      Serial.print(i);
      Serial.print(" columna ");
      Serial.print(j);
      
      Serial.print(" => ");
      Serial.println(digitalRead(entradas[i][j]));
      Serial.print("Final de carrera numero ");
      
      delay(100);
    }
  } 
}

void imprimirTablero(){
  for(byte i = 0; i < tamanoTablero; i++){
    for(byte j = 0; j < tamanoTablero; j++){
      Serial.print("Tablero Valor fila ");
      Serial.print(i);
      Serial.print(" columna ");
      Serial.print(j);
      
      Serial.print(" => ");
      Serial.println(tablero[i][j]);
      delay(100);
    }
  }
}
