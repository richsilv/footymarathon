JSONObject sprat;
boolean[] keys = new boolean[526];

int scX = 0, scY = 0;
float plX = 200, plY = 200;
int plD = 0;
float speed = 3.0;
float plA = 0.0;
float pldA = 0.3;
int i, j;
PImage spriteSheet, pitch, tempSpr;

void setup() {
  sprat = loadJSONObject("spriteatlas.json");
  size(500, 400);
  frameRate(60);
  spriteSheet = loadImage("spritesheet.png");
  pitch = loadImage("pitch.png");
  imageMode(CENTER);
}

void draw() {
  for (i=(-scX % 100) - 51; i <= 450; i += 100) {
    for (j=(-scY % 100) - 51; j <= 350; j += 100) {
      image(pitch, i, j, 100, 100);
    }
  }
  stroke(0);
  fill(0);
  checkKeys();
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
  JSONObject sprLoc = sprat.getJSONObject(str(plD)).getJSONObject(str(int(plA)));
  tempSpr = spriteSheet.get(sprLoc.getInt("x")*32, sprLoc.getInt("y")*32, 32, 32);
  image(tempSpr, plX - scX, plY - scY, 32, 32);
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

void checkKeys() {
    if (keyPressed) {
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
    }
    else if (checkKey('w')) {
      plD = 0;
      plY -= speed;
    }
    else if (checkKey('s')) {
      plD = 4;
      plY += speed;
    }
    plA += pldA;
  }
  if ((plA >= 7) || (plA < 0)) {
    pldA = -pldA;
    plA += pldA;
  }
  plA = plA % 7;
}
