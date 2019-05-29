//Clase que representa el tablero y el juego
class Tablero {
   
  //Size de la parte interior del tablero, donde iran las plazas
  int size;
  //Size de la parte exterior del tablero, meramente decorativa
  int padding;
  //Color del tablero
  color tColor;
  //Punto x donde estara ubicada la esquina superior izquierda del tablero
  int x;
  //Punto y donde estara ubicada la esquina superior izquierda del tablero
  int y;
  //Arreglo bidimensional de plazas en el tablero, el cual es 6x6
  Casilla[][] casillas = new Casilla[6][6];
  //Arreglo de fichas
  Ficha[] fichas = new Ficha[0];
  //Identificador del jugador que va a mover
  int playerId = 1;
  //Ficha elegida para mover
  Ficha selectedF = null;
  //Identificador del jugador que gana
  int winner = 0;
  //Permite saber si el juego ha acabado
  boolean ended = false;
    
  //Constructor con posicion centrada en el canvas
  Tablero (int size, color tColor) {
     this.padding = size;
     this.size = size - 50;
     this.tColor = tColor;
     x = width/8;
     y = (height - size)/2;
     
  }
  
  //Constructor con posicion determinada en el canvas
  Tablero (int size, color tColor, int x, int y) {
     this.padding = size;
     this.size = size - 100;
     this.tColor = tColor;
     this.x = x;
     this.y = y;
  }
  
  //Devuelve todas las casillas
  Casilla[][] getCasillas(){
    return this.casillas;
  }
  
  //Devuelve casilla segun id
  Casilla getCasilla(String id){
    for(Casilla[] c: casillas){
      //por cada plaza en cada fila...
      for(Casilla cl: c){
        if(id.equals(cl.id)){
          return cl;
        }
      }
    }
    return null;
  }
  
  //Dibujar tablero en el canvas
  void setTablero() {
    
    //Determinar numero de fichas segun numero de jugadores
     this.fichas = twoPlayers? new Ficha[12] : new Ficha[16];
      
    //Reiniciar ganador y turnos
    this.winner = 0;
    this.playerId = 1;
    
    //Crear coordenadas para rectangulo interior (el que contiene las casillas)
    int xp = x + 25;
    int yp = y + 25;
    
    //Sin borde    
    noStroke();
    //Colorear
    fill(tColor);
    //Dibujar rectangulo interior
    rect(xp, yp, size, size);
    
    //Crear las 36 plazas en el arreglo del tablero
    //Filas
    for(int i = 0; i < 6; i++){
      //Columnas
      for(int j = 0; j < 6; j++){
        //Se pasa el size, color y coordenadas el rectangulo interior
        casillas[i][j] = new Casilla(size, tColor, xp, yp, i+""+j, this);
        //Desplazar hacia la izquiera 1/6 del size del rectangulo interior 
        xp += size/6;
      }
      //Al completar fila reiniciar posicion en x
      xp = x + 25;
      //Desplazar hacia abajo 1/6 del size del rectangulo interior
      yp += size/6;
    }
    
    //Crear las fichas para el juego y asignarlas a casillas (2 JUGADORES)
    if(twoPlayers){
      for(int i = 0; i < fichas.length; i++){
        String num1 = i < 6 ? "0" : "5";
        int num2 = i < 6 ? i : i - 6;
        int player = i < 6 ? 1 : 2;
        Casilla c = getCasilla(num1+num2); 
        fichas[i] = new Ficha(c.x + c.size/12, c.y + c.size/12, c.size/7, c.size/7, num1+num2, this, player);
        
      }
      //4 JUGADORES
    }else{
      String[][] positions = {{"00","01","10","11"},
                            {"04","05","14","15"},
                            {"44","45","54","55"},
                            {"40","41","50","51"}};
      
      int contF = 0;
      for(int i = 0; i < positions.length; i++){
        for(int j = 0; j < 4; j++){
          Casilla c = getCasilla(positions[i][j]);
          fichas[contF] = new Ficha(c.x + c.size/12, c.y + c.size/12, c.size/7, c.size/7, positions[i][j], this, i+1);
          contF++;
        }
      }
      
    }
    
    
   // mostrar();
    
    
  }
  
  //Muestra y actualiza constantemente el tablero con sus casillas y fichas
  void mostrar(){
    
    if(this.winner == 0){
      //Mostrar turno
      switch(this.playerId){
      case 1:
        image(turno1, 2*width/3, height/3, width/3.3, width/3.2);
        
        break;
      case 2:
        image(turno2, 2*width/3, height/3, width/3.3, width/3.2);
        break;
      case 3:
        image(turno3, 2*width/3, height/3, width/3.3, width/3.2);
        break;
      case 4:
        image(turno4, 2*width/3, height/3, width/3.3, width/3.2);
        break;
      }
       
    }else{
      background(255);
    }
    
    //Sin borde
    noStroke();
    //Colorear
    fill(tColor);
    //Dibujar rectangulo exterior
    rect(x, y, padding, padding, 50);
    
    
    //Revisar estado de casillas
    asignarFichas(); 
    
    //Mostrar casillas
    for(Casilla[] c: casillas){
      //por cada plaza en cada fila...
      for(Casilla cl: c){
        cl.mostrar();
        if(cl.clicked()){ 
          moverFicha(selectedF, cl);
          selectedF.setEnabled(false);
        }
      }
    }
   
    //Mostrar fichas
    for(Ficha f: fichas){
      f.mostrar();
      if(f.playerId == playerId || f.isHidden){
        if(selectedF != null){ 
          checkMoves(selectedF.posicion); }
      }
    }
    
    if(this.winner != 0){
      terminar(this.winner);
    }
    
    
  }
  
  //Asignar estado (ocupado) a las casillas segun posicion de las fichas
  void asignarFichas(){
    for(Casilla[] c: casillas){
      //por cada casilla en cada fila...
      for(Casilla cl: c){
        //llamar metodo para dibujar la casilla
         cl.setOcuppied(false);
      }
    }
    //Por cada ficha buscar la casilla en la que estan y ponerlas como ocupadas
    for(Ficha f: fichas){
      getCasilla(f.posicion).setOcuppied(true);
    }
  }
  
  //Mover ficha
  void moverFicha(Ficha f, Casilla ca){
      for(String o : f.objective){
        if(o.equals(ca.id)) { 
          f.setHidden(true); 
          f.objective = f.objectiveF;
          break; 
        }
      }
      f.mover(ca); 
      restart();
      asignarFichas();
      //imprimirLayout();
      playerId++;
      if(twoPlayers) if(playerId == 3) { playerId = 1; };
      if(!twoPlayers) if(playerId == 5) { playerId = 1; };
  } 
  
  //Reinicia estado de fichas y casillas
  void restart(){
    for(Ficha fi: fichas){
        fi.setEnabled(true);
    }
    for(Casilla[] c: casillas){
      //por cada casilla en cada fila...
      for(Casilla cl: c){
        //llamar metodo para dibujar la casilla
         cl.setColoured(false);
      }
    }
  }
  
  //Funcion para verificar ganador
  void checkWinner(int playerId){
    
    
        this.winner = playerId;
    
    //Verificar si todas las fichas estan volteadas
    boolean allHidden = true;
    
    //Buscar si alguna ficha del jugador no esta escondida
    for(Ficha f : fichas){
      if(f.playerId == playerId){
        if(!f.isHidden){
          allHidden = false;
          break;
        }
      }
    }
    
    //Contador escondidos
    int counterH = 0;
    //Contador casillas ocupadas
    int counterC = 0;


    if(twoPlayers){
      
      int row = playerId == 1 ? 0 : 5;
      
      for(int i = 0; i < 6; i++){
        if(casillas[row][i].ocuppied){ 
          for(Ficha f : fichas){
            if(f.posicion.equals(""+row+i) && f.isHidden && f.playerId == playerId){       
              counterH++;
            }
          }
          counterC++;
        }
      }
      
    }else{
      
      String[][] positions = {{"00","01","10","11"},{"04","05","14","15"},{"44","45","54","55"},{"40","41","50","51"}};
      
      int row = playerId - 1;
      
      //En este iterador se cuentan cuantas casillas del jugador estan ocupadas (counterC) y cuantas de las fichas ocultas que las ocupan son del jugador (counterH)
      for(int i = 0; i < 4; i++){
        if(getCasilla(positions[row][i]).ocuppied){ 
           for(Ficha f : fichas){
             if(f.posicion.equals(""+row+i) && f.isHidden && f.playerId == playerId){       
               counterH++;
             }
           }
           counterC++;
        }
      }   
      
    }
    
    //Asignar un que indique las fichas por jugador segun el numero de jugadores
    int fichasPPlayer = twoPlayers? 6 : 4;
    
    //Si todas las fichas estan escondidos se puede hacer la verificacion de si las casillas del jugador estan todas ocupadas
    if(allHidden){
        //Si todas las casillas del jugador estan ocupadas se puede hacer la verificacion de si todas las fichas escondidas son del jugador 
        if(counterC == fichasPPlayer){
          //Si todas las fichas escondidas son del jugador, gana
          if(counterH == fichasPPlayer){
            println("GANA EL JUGADOR "+playerId);
          //Si hay al menos una ficha escondida del jugador en las casillas del jugador y verifica la victoria, pierde.
          }else{
            println("PIERDE EL JUGADOR "+playerId);
          }
        //Si no todas las fichas estan escondidas no se puede hacer la verificacion de victoria
        }else{
          println("AUN NO SE PUEDE TERMINAR EL JUEGO");
        }
    //Si no todas las fichas estan escondidas aun no se puede terminar el juego
    }else{
      println("AUN NO SE PUEDE TERMINAR EL JUEGO");
    }
      println("AUN NO SE PUEDE TERMINAR EL JUEGO");
      
  }
  
  
  void terminar(int winner){
    
    ended = true;
    
    for(Casilla[] c: casillas){
      //por cada casilla en cada fila...
      for(Casilla cl: c){
        //llamar metodo para dibujar la casilla
         cl.setColoured(false);
      }
    }
    
    //Animacion victoria
    if(aWinCounter == 0){
      image(celeb1, 0, 0, width, height);
    }else if(aWinCounter == 1){
      image(celeb2, 0, 0, width, height);
    }else{
      image(celeb3, 0, 0, width, height);
    }
    if (millis() - timeAnimationWin >= 1)
    {
      aWinCounter++;
      aWinCounter = aWinCounter == 3 ? 0 : aWinCounter; 
      timeAnimationWin = millis();
    }
      
    //Fondo oscuro
    noStroke();
    fill(0, 0, 0, 30);
    rect(0, 0, width, height);
   
     //Mostrar boton de continuar 
      finish.mostrar();
    
    //Pantalla de ganador
    switch(winner){
      case 1:
        image(victory1, 3*width/25, 4*height/25, 5*width/7, 5*height/9);
        break;
      case 2:
        image(victory2, 3*width/25, 4*height/25, 5*width/7, 5*height/9);
        break;
      case 3:
        image(victory3, 3*width/25, 4*height/25, 5*width/7, 5*height/9);
        break;
      case 4:
        image(victory4, 3*width/25, 4*height/25, 5*width/7, 5*height/9);
        break;
      }    
      
     finish.onHover(continuarOH);   
     if(finish.clicked()){
       state = "mainmenu";
       twoPlayers = !twoPlayers;
       tablero.setTablero();
     }
    
  }
  
  //Resetear valores del tablero
  Ficha getFicha(String id){
    for(Ficha f : fichas){    
      if(id.equals(f.posicion)){
         return f;     
      } 
    }   
    return null;
  }
 
  
  //Verificar movimientos validos
  void checkMoves(String posicion){
    
    restart();
    
    String[] fc = posicion.split("");
    int f = Integer.parseInt(fc[0]);
    int c = Integer.parseInt(fc[1]);
    int sf = f;
    int sc = c;
    int countV = 0;
    int countO = 0;
    
    getCasilla(posicion).setColoured(true);
    
    //Revisar columna superior
    for(int i = f - 1; i >= 0; i --){
       if(getCasilla(i+""+c).ocuppied){
        countO++;
        countV = 0;
        if(countO > 1) { break; }
      } else {
        countO = 0;
        countV++;
        if(i == f - 1) { getCasilla(i+""+c).setColoured(true); break; }
        if(countV > 1) { break; } 
        getCasilla(i+""+c).setColoured(true);
      } 
    }
    
    f =  sf;
    c = sc;
    countV = 0;
    countO = 0;
    
    //Recorrer diagonal superior derecha
    do{
      f--;
      c++;
      if(getCasilla(f+""+c) == null) { break; }
      if(getCasilla(f+""+c).ocuppied){
        countO++;
        countV = 0;
        if(countO > 1) { break; }
      } else {
        countO = 0;
        countV++;
        if(f == sf - 1 && c == sc + 1) { getCasilla(f+""+c).setColoured(true); break; }
        if(countV > 1) { break; } 
        getCasilla(f+""+c).setColoured(true);
      } 
    }while(f > 0 && c < 5);
    
    f =  sf;
    c = sc;
    countV = 0;
    countO = 0;

    //Recorrer fila derecha
    do{
      c++;
      if(getCasilla(f+""+c) == null) { break; }
      if(getCasilla(f+""+c).ocuppied){
        countO++;
        countV = 0;
        if(countO > 1) { break; }
      } else {
        countO = 0;
        countV++;
        if(c == sc + 1) { getCasilla(f+""+c).setColoured(true); break; }
        if(countV > 1) { break; } 
        getCasilla(f+""+c).setColoured(true);
      }  
    }while(c < 5);
    
    f =  sf;
    c = sc;
    countV = 0;
    countO = 0;
    
    
    //Recorrer diagonal inferior derecha
    do{
      f++;
      c++;
      if(getCasilla(f+""+c) == null) { break; }
      if(getCasilla(f+""+c).ocuppied){
        countO++;
        countV = 0;
        if(countO > 1) { break; }
      } else {
        countO = 0;
        countV++;
        if(c == sc + 1 && f == sf + 1) { getCasilla(f+""+c).setColoured(true); break; }
        if(countV > 1) { break; } 
        getCasilla(f+""+c).setColoured(true);
      }
    }while(f < 5 && c < 5);
    
    f =  sf;
    c = sc;
    countV = 0;
    countO = 0;
    
    //Recorrer columna inferior
    do{
      f++;
      if(getCasilla(f+""+c) == null) { break; }
      if(getCasilla(f+""+c).ocuppied){
        countO++;
        countV = 0;
        if(countO > 1) { break; }
      } else {
        countO = 0;
        countV++;
        if(f == sf + 1) { getCasilla(f+""+c).setColoured(true); break; }
        if(countV > 1) { break; } 
        getCasilla(f+""+c).setColoured(true);
      }  
    }while(f < 5);
    
    f =  sf;
    c = sc;
    countV = 0;
    countO = 0;
    
    //Recorrer diagonal inferior izquierda
    do{
      f++;
      c--;
      if(getCasilla(f+""+c) == null) { break; }
      if(getCasilla(f+""+c).ocuppied){
        countO++;
        countV = 0;
        if(countO > 1) { break; }
      } else {
        countO = 0;
        countV++;
        if(f == sf + 1 && c == sc - 1) { getCasilla(f+""+c).setColoured(true); break; }
        if(countV > 1) { break; } 
        getCasilla(f+""+c).setColoured(true);
      } 
    }while(f < 5 && f > 0);
    
    f =  sf;
    c = sc;
    countV = 0;
    countO = 0;
    
    //Recorrer fila izquierda
    do{
      c--;
      if(getCasilla(f+""+c) == null) { break; }
      if(getCasilla(f+""+c).ocuppied){
        countO++;
        countV = 0;
        if(countO > 1) { break; }
      } else {
        countO = 0;
        countV++;
        if(c == sc - 1) { getCasilla(f+""+c).setColoured(true); break; }
        if(countV > 1) { break; } 
        getCasilla(f+""+c).setColoured(true);
      }   
    }while(c > 0);
    
    f =  sf;
    c = sc;
    countV = 0;
    countO = 0;
    
    //Recorrer diagonal superior izquierda
    do{
      c--;
      f--;
      if(getCasilla(f+""+c) == null) { break; }
      if(getCasilla(f+""+c).ocuppied){
        countO++;
        countV = 0;
        if(countO > 1) { break; }
      } else {
        countO = 0;
        countV++;
        if(c == sc - 1 || f == sf - 1) { getCasilla(f+""+c).setColoured(true); break; }
        if(countV > 1) { break; } 
        getCasilla(f+""+c).setColoured(true);
      }  
    }while(c > 0 && f > 0);
    
   
    for(Ficha fi: fichas){ fi.mostrar(); }
    
    
  }
  
}
