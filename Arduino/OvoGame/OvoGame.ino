/*
  A0 instead of 14
  https://www.baldengineer.com/tips/arduino-pinmode-on-analog-inputs
*/


/*
  Variables de configuracion del juego:
  El arreglo de entradas me dice los pines digitales que se desean leer.
  El arreglo de bytes llamado tablero me dice las posiciones en las cuales se tiene un 1, lo cual me indica que en esa posicion se encuentra un huevo.
  Las variables de cantidad de jugadores me indica la cantidad de jugadores detectados
  Las variables de partidoX me dicen la posicion de partida, es decir de donde se movio cierta ficha y asi las de finX me dicen a donde se movio.
*/
const byte tamanoTablero = 6;
const int entradas[tamanoTablero][tamanoTablero] = {
  {2, 3, 4, 5, 6, 7},
  {8, 9, 10, 11, 12, 13},
  {22, 23, 24, 25, 26, 27},
  {28, 29, 30, 31, 32, 33},
  {34, 35, 36, 37, 38, 39},
  {40, 41, 42, 43, 44, 45}
};

byte tablero[tamanoTablero][tamanoTablero];
byte cantidadJugadores = 0;
boolean enJuego = false;

byte partidaI = 10;
byte partidaJ = 10;
byte finI;
byte finJ;

String inBuffer = "";

void setup()
{
  // Se configura la comunicacion Serial a una tasa de baudios (bits per second) de 9600 ya que esta es la que se utiliza en las demas.
  Serial.begin(9600);
  // Se define el modo de los pines de entrada, los cuales son todos digitales y como INPUT
  for (byte i = 0; i < tamanoTablero; i++) {
    for (byte j = 0; j < tamanoTablero; j++) {
      pinMode(entradas[i][j], INPUT);
    }
  }
}

void loop()
{
  /*
    Este es el loop principal en donde se pregunta si llegan datos al puerto serial, si la cantidad de jugadores al inicio es la correcta
    y tambien se detectan los movimientos realizados
  */
  if (Serial.available() > 0) {
    inBuffer = Serial.readStringUntil('\n');
    //inBuffer = Serial.readStringUntil('\n');
    if (inBuffer.length() > 0 && inBuffer[0] == 'R') {
      cantidadJugadores = 0;
    }
  }


  if (cantidadJugadores == 0) {
    // Me puede regresar solo 2 o 4  0 para cuando no se halla seteado el juego
    cantidadJugadores = identificarJugadores();

    //enJuego = cantidadJugadores != 0 ? true : false;
    if (cantidadJugadores != 0) {
      enJuego = true;
      configurarTablero(cantidadJugadores);
    }

    String mensajeInicio = "I:";
    mensajeInicio.concat(cantidadJugadores);
    Serial.println(mensajeInicio);
    delay(500);

  }
  if (enJuego) {
    // Se comenzo/esta juegando
    //Serial.println(" Se inicia ya que se ocuparon los puestos");

    // Registrar movimiento
    registroMovimiento();
    delay(100);
    identificarLlegada();

    delay(100);

  }

  //imprimirTablero();
  //imprimirValores();
}

/*
  Detectar el movimiento del huevo, comparando los valores en las posiciones dependiendo del turno
  del jugador y retorna los indices de partida del huevo
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
  Identificacion de a donde se movio el huevo, para esto se usan las variables/indices de partida y luego se envia
  por comunicacion serial una cadena de texto la cual tiene el formato M:00F:11 para indicar que se movio una huevo
  que se encontraba en fila 0 y columna 0 y llego a fila 1 columna1.

*/
void identificarLlegada() {
  if (partidaI != 10) {
    // Identificar fin
    for (int i = 0; i < tamanoTablero; i++) {
      for (int j = 0; j < tamanoTablero; j++) {
        if ( tablero[i][j] == 0 && digitalRead(entradas[i][j]) == HIGH) {
          // A donde llego

          // Actualizar tablero
          tablero[i][j] = 1;
          tablero[partidaI][partidaJ] = 0;

          finI = i;
          finJ = j;

          String mensajeMovimiento = "M:";
          mensajeMovimiento.concat(partidaI);
          mensajeMovimiento.concat(partidaJ);

          mensajeMovimiento.concat("F:");
          mensajeMovimiento.concat(finI);
          mensajeMovimiento.concat(finJ);


          Serial.println(mensajeMovimiento);  // Como es con println \n esos son otros 2 caracteres
          delay(500);
          break;
        }
      }
    }
  }

}


/*
  Funcion para identificar la cantidad de jugadores, viendo si en ciertas areas del tablero al iniciar se encuentran
  posicionados los huevos.
  Retorna la cantidad de jugadores detectados.
*/
byte identificarJugadores() {
  byte num = 0;
  // Observar si solo son dos jugadores
  int suma = 0;

  for (byte j  = 0; j < tamanoTablero; j++ ) {
    suma += digitalRead(entradas[0][j]);  // Primeros 6 botones, entradas es un multiarray
    suma += digitalRead(entradas[tamanoTablero - 1][j]); // Ultimos 6 botones, entradas es un multiarray
  }
  //  Serial.print("Valor de la suma ");
  //  Serial.println( suma );
  //suma = 8;
  //delay(6000);
  if (suma == tamanoTablero * 2) {
    num = 2; // Solo son 2 jugadores

  } else {
    suma = 0;
    // Chequear los 4
    boolean sj0 = (digitalRead(entradas[0][0]) && digitalRead(entradas[0][1]) && digitalRead(entradas[1][0]) && digitalRead(entradas[1][1]));
    //    Serial.print("SJ0->");
    //    Serial.println(sj0);
    delay(10);

    boolean sj1 = (digitalRead(entradas[0][4]) && digitalRead(entradas[0][5]) && digitalRead(entradas[1][4]) && digitalRead(entradas[1][5]));
    //    Serial.print("SJ1->");
    //    Serial.println(sj1);
    delay(10);

    boolean sj2 = (digitalRead(entradas[4][0]) && digitalRead(entradas[4][1]) && digitalRead(entradas[5][0]) && digitalRead(entradas[5][1]));
    //    Serial.print("SJ2->");
    //    Serial.println(sj2);
    delay(10);

    boolean sj3 = (digitalRead(entradas[4][4]) && digitalRead(entradas[4][5]) && digitalRead(entradas[5][4]) && digitalRead(entradas[5][5]));
    //    Serial.print("SJ3->");
    //    Serial.println(sj3);
    delay(10);
    num = (sj0 && sj1 && sj2 && sj3) ? 4 : 0;
    delay(3000);
  }

  return num;
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


/*
  Funcion para inicializar todo en el tablero para que luego se puedan detectar los cambios. En esta funcion se
  dependiendo de la cantidad de jugadores se setea el tablero para tener 1 en ciertas posicione

*/
void configurarTablero(byte jugadores) {

  // Poner todos a cero
  for (byte i = 0; i < tamanoTablero; i++) {
    for (byte j = 0; j < tamanoTablero; j++) {
      tablero[i][j] =  0;
    }
  }

  if (jugadores == 2) {
    for (byte j = 0; j < tamanoTablero; j++) {
      tablero[0][j] = 1;
      tablero[tamanoTablero - 1][j] = 1;
    }
  } else if (jugadores == 4) {

    tablero[0][0] = 1;
    tablero[0][1] = 1;
    tablero[1][0] = 1;
    tablero[1][1] = 1;

    tablero[0][4] = 1;
    tablero[0][5] = 1;
    tablero[1][4] = 1;
    tablero[1][5] = 1;

    tablero[4][0] = 1;
    tablero[4][1] = 1;
    tablero[5][0] = 1;
    tablero[5][1] = 1;

    tablero[4][4] = 1;
    tablero[4][5] = 1;
    tablero[5][4] = 1;
    tablero[5][5] = 1;

  }

}
