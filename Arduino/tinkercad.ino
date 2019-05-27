/*
  A0 instead of 14
  https://www.baldengineer.com/tips/arduino-pinmode-on-analog-inputs
*/

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

byte tablero[tamanoTablero][tamanoTablero];
byte cantidadJugadores = 0;
boolean enJuego = false;
byte areaBusqueda = 2;

byte partidaI = 10;
byte partidaJ = 10;
byte finI;
byte finJ;

void setup()
{
  Serial.begin(9600);
  for (byte i = 0; i < tamanoTablero; i++) {
    for (byte j = 0; j < tamanoTablero; j++) {
      pinMode(entradas[i][j], INPUT);
    }
  }
}

void loop()
{
  Serial.println(cantidadJugadores);
  if (cantidadJugadores == 0) {
    // Me puede regresar solo 2 o 4  0 para cuando no se halla seteado el juego
    cantidadJugadores = identificarJugadores();
    Serial.print("La cantidad de jugadores es: ");
    Serial.println(cantidadJugadores);

    //enJuego = cantidadJugadores != 0 ? true : false;
    if (cantidadJugadores != 0) {
      enJuego = true;
      configurarTablero(cantidadJugadores);
    }

  }
  if (enJuego) {
    // Se comenzo/esta juegando
    Serial.println(" Se inicia ya que se ocuparon los puestos");

    // Registrar movimiento
    registroMovimiento();
    delay(1000);
    identificarLlegada();

    delay(3000);

  }

  imprimirTablero();

  //imprimirValores();
}

/*
  Detectar el movimiento del huevo, comparando los valores en las posiciones dependiendo del turno
  del jugador

*/
void registroMovimiento() {
  // Conocer partida
  for (byte i = 0; i < tamanoTablero; i++) {
    for (byte j = 0; j < tamanoTablero; j++) {
      // En la posicion electronica se pasa a cero entonces veo lo que habia antes
      if (tablero[i][j] == 1  && digitalRead(entradas[i][j]) == LOW) {
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
void identificarLlegada() {
  if (partidaI != 10) {
    // Identificar fin
    for (int i = 0; i < tamanoTablero; i++) {
      for (int j = 0; j < tamanoTablero; j++) {
        if ( tablero[i][j] == 0 && digitalRead(entradas[i][j]) == HIGH) {
          // A donde llego

          tablero[i][j] = 1;

          tablero[partidaI][partidaJ] = 0;
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


/*
  Funcion para identificar la cantidad de jugadores, viendo si en ciertas areas del tablero al iniciar se encuentran
  posicionandos los huevos.
*/
byte identificarJugadores() {
  byte num = 0;
  // Observar si solo son dos jugadores
  int suma = 0;

  for (byte j  = 0; j < tamanoTablero; j++ ) {
    suma += digitalRead(entradas[0][j]);  // Primeros 6 botones, entradas es un multiarray
    suma += digitalRead(entradas[tamanoTablero - 1][j]); // Ultimos 6 botones, entradas es un multiarray
  }
  Serial.print("Valor de la suma ");
  Serial.println( suma );
  //suma = 8;
  //delay(6000);
  if (suma == tamanoTablero * 2) {
    num = 2; // Solo son 2 jugadores
   
  } else {
    suma = 0;
    // Chequear los 4
    byte sj0 = posJugadores(0, 0);
    byte sj1 = posJugadores(0, tamanoTablero-areaBusqueda);
    byte sj2 = posJugadores(tamanoTablero-areaBusqueda, 0);
    byte sj3 = posJugadores(tamanoTablero-areaBusqueda, tamanoTablero-areaBusqueda);
    suma = sj0 + sj1 + sj2 + sj3;
    num = (suma == 16)? 4 : 0;
  }

  return num;
}

byte posJugadores(byte idxI, byte idxJ) {
  byte suma = 0;
  for (byte i = idxI; i < idxI + areaBusqueda; i++ ) {
    for (byte j = idxJ; j < idxJ + areaBusqueda; j++) {
      suma += digitalRead(entradas[i][j]);
    }
  }
  return suma;
}

void imprimirValores() {
  for (byte i = 0; i < tamanoTablero ; i++) {
    for (byte j = 0; j < tamanoTablero; j++) {
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

void imprimirTablero() {
  for (byte i = 0; i < tamanoTablero; i++) {
    for (byte j = 0; j < tamanoTablero; j++) {
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

void configurarTablero(byte jugadores) {
  if (jugadores == 2) {
    for (byte j = 0; j < tamanoTablero; j++) {
      tablero[0][j] = 1;
      tablero[tamanoTablero - 1][j] = 1;
    }
  } else {

    tablero[0][0] = 1;

    tablero[0][tamanoTablero - 1] = 1;

    tablero[tamanoTablero - 1][0] = 1;

    tablero[tamanoTablero - 1][tamanoTablero - 1] = 1;

  }

}