
/*
  A0 instead of 14
  https://www.baldengineer.com/tips/arduino-pinmode-on-analog-inputs
*/

const byte tamanoTablero = 6;
const int entradas[] = {
  2, 3, 4, 5, 6, 7 ,8, 9, 10, 11, 12, 13,
  22, 23, 24, 25, 26, 27,
  28, 29, 30, 31, 32, 33,
  34, 35, 36, 37, 38, 39,
  40, 41, 42, 43, 44, 45
};
// La RX no pasa nada PERO con la TX se jode por que se intenta
// comunicar

void setup()
{
  Serial.begin(9600);
  for(byte i = 0; i < 36 ; i++){
    pinMode(entradas[i], INPUT);
  }
}

void loop()
{ 
  byte indice = 0;
  byte filaFin = 0;
  for(byte i = 0; i < 6 ; i++){
    for(byte j = 0; j < 6; j++){
      Serial.print("Valor fila ");
      Serial.print(i);
      Serial.print(" columna ");
      Serial.print(j);
      
      Serial.print(" => ");
      Serial.println(digitalRead(entradas[indice]));
      Serial.print("Final de carrera numero ");
      Serial.println(indice);
      indice++;
      
      delay(1000);
    }
  }  
}
