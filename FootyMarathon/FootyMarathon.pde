JSONObject sprat;
boolean[] keys = new boolean[526];
float[] rots = new float[3];

int scX = 0, scY = 0;
float plX = 200, plY = 200;
int piX = 800, piY = 1000, margin = 5;
int plD = 0;
float speed = 3.0;
float plA = 0.0;
float pldA = 0.3;
float airRes = 0.0008;
float groundRes = 0.003;
int i, j;
float ballX = 400, ballY = 300, ballH=0, ballA=0;
float balldX = 0, balldY = 0, balldH = 0, spdSq = 0;
PImage spriteSheet, pitch, tempSpr, ball;
boolean possession = false;
float kickTimer = 0;
float frameC = 0;

void setup() {
  rots[0] = 0;
  rots[1] = PI/2;
  rots[2] = PI/2;  
  
  sprat = loadJSONObject("spriteatlas.json");
  size(500, 400);
  frameRate(60);
  spriteSheet = loadImage("spritesheet.png");
  pitch = loadImage("pitch.png");
  ball = loadImage("football.png");
  imageMode(CENTER);
}

void draw() {

  checkKeys();
  checkArea();

  if ((dist(plX, plY, ballX, ballY) < 20) && (kickTimer <= 0)) {
    possession = true;
  }
  
  if (possession) {
    float angle = plD * PI / 4;
    ballH = 0;
    balldX = 0;
    balldY = 0;
    spdSq = 0;
    ballX = plX + sin(angle) * 16;
    ballY = plY - cos(angle) * 16;
  }
  else {
    ballX += balldX;
    ballY += balldY;
    ballH += balldH;
    if (ballH < 0) {
      ballH = 0;
      balldH *= -0.7;
    }
    balldH -= 0.05;
    ballA = atan2(balldY, balldX) + PI/2;
    spdSq = sq(balldX) + sq(balldY);
    balldX -= sin(ballA) * spdSq * airRes;
    balldY += cos(ballA) * spdSq * airRes;
    if (ballH <= 0.005) {
      balldX -= sin(ballA) * spdSq * groundRes;
      balldY += cos(ballA) * spdSq * groundRes;
    }     
  }

  if ((ballX < -25) || (ballX > piX+25)) {
    ballX -= balldX;
    balldX = -balldX * 0.7;
  }
  if ((ballY < -25) || (ballY > piY+25)) {
    ballY -= balldY;
    balldY = -balldY * 0.7;
  }

  if (kickTimer > 0) {kickTimer -= 1;}
  if (kickTimer < 0) {kickTimer = 0;}

  for (i=(-scX % 100) - 51; i <= 550; i += 100) {
    for (j=(-scY % 100) - 51; j <= 450; j += 100) {
      image(pitch, i, j, 100, 100);
    }
  }

  noStroke();
  fill(255, 80);
  rect(-scX, -scY, piX, 5);
  rect(-scX, -scY, 5, piY);
  rect(piX - 5 - scX, -scY, 5, piY);
  rect(-scX, piY - 5 - scY, piX, 5);

  JSONObject sprLoc = sprat.getJSONObject(str(plD)).getJSONObject(str(int(plA)));
  tempSpr = spriteSheet.get(sprLoc.getInt("x")*32, sprLoc.getInt("y")*32, 32, 32);
  
  if (plY < ballY) {
    image(tempSpr, plX - scX, plY - scY, 32, 32);
    pushMatrix();
    translate(ballX - scX, ballY - scY);
    rotate(rots[int(frameC)]);
    image(ball, 0, 0, ballH + 16, ballH + 16);
    popMatrix();
  }
  else {
    pushMatrix();
    translate(ballX - scX, ballY - scY);
    rotate(rots[int(frameC)]);
    image(ball, 0, 0, ballH + 16, ballH + 16);
    popMatrix();
    image(tempSpr, plX - scX, plY - scY, 32, 32);
  }
  
  frameC = (frameC + (sqrt(spdSq)/8)) % 3;
}

boolean checkKey(char k)
{
//  println("Request: " + int(k));
  return keys[int(k)]; 
}
 
void keyPressed()
{
  keys[int(key)] = true;
}
 
void keyReleased()
{ 
  keys[int(key)] = false; 
}

void checkArea() {
  if (plX < scX + 100) {
    scX -= speed*1.5;
  }
  else if (plX > scX + 400) {
    scX += speed*1.5;
  }
  if (plY < scY + 100) {
    scY -= speed*1.5;
  }
  else if (plY > scY + 300) {
    scY += speed*1.5;
  }
  if (plX < 0) {plX = 0;}
  if (plX > piX) {plX = piX;}
  if (plY < 0) {plY = 0;}
  if (plY > piY) {plY = piY;}
}

void checkKeys() {
    if (keyPressed) {
      if (checkKey(' ') && (possession)) {
        float angle = plD * PI / 4;
        balldH = 1.5;
        balldX = sin(angle) * 12;
        balldY = -cos(angle) * 12;
        possession = false;
        kickTimer = 7;      
      }
      if (checkKey('a')) {
        if (checkKey('w')) {
          plD = 7;
          plX -= sqrt(2) * speed;
          plY -= sqrt(2) * speed;
        }
        else if (checkKey('s')) {
          plD = 5;
          plX -= sqrt(2) * speed;
          plY += sqrt(2) * speed;
        }
        else {
          plD = 6;
          plX -= speed;
        }
        plA += pldA;
      }
      else if (checkKey('d')) {
        if (checkKey('w')) {
          plD = 1;
          plX += sqrt(2) * speed;
          plY -= sqrt(2) * speed;
        }
        else if (checkKey('s')) {
          plD = 3;
          plX += sqrt(2) * speed;
          plY += sqrt(2) * speed;
        }
        else {
          plD = 2;
          plX += speed;
        }
        plA += pldA;
      }
      else if (checkKey('w')) {
        plD = 0;
        plY -= speed;
        plA += pldA;
      }
      else if (checkKey('s')) {
        plD = 4;
        plY += speed;
        plA += pldA;
      }
    }
    if ((plA >= 7) || (plA < 0)) {
      pldA = -pldA;
      plA += pldA;
    }
  plA = plA % 7;
}
