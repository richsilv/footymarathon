JSONObject sprat;
boolean[] keys = new boolean[526];

int scX = 0, scY = 0;
float plX = 200, plY = 200;
int plD = 0;
float speed = 3.0;
float plA = 0.0;
int i, j;
PImage spriteSheet, pitch, tempSpr;

void setup() {
  sprat = loadJSONObject("spriteatlas.json");
  size(500, 400);
  frameRate(60);
  spriteSheet = loadImage("spritesheet.png");
  pitch = loadImage("pitch.png");
}

void draw() {
  for (i=((scX+1) % 100) - 101; i < 500; i += 100) {
    for (j=((scY+1) % 100) - 101; j < 400; j += 100) {
      image(pitch, i, j, 100, 100);
    }
  }
  stroke(0);
  fill(0);
  if (keyPressed) {
    if (checkKey("a")) {
      if (checkKey("w")) {
        plD = 7;
        plX -= sqrt(2) * speed;
        plY -= sqrt(2) * speed;
      }
      else if (checkKey("s")) {
        plD = 5;
        plX -= sqrt(2) * speed;
        plY += sqrt(2) * speed;
      }
      else {
        plD = 6;
        plX -= speed;
      }
    }
    else if (checkKey("d")) {
      if (checkKey("w")) {
        plD = 1;
        plX += sqrt(2) * speed;
        plY -= sqrt(2) * speed;
      }
      else if (checkKey("s")) {
        plD = 3;
        plX += sqrt(2) * speed;
        plY += sqrt(2) * speed;
      }
      else {
        plD = 2;
        plX += speed;
      }
    }
    else if (checkKey("w")) {
      plD = 0;
      plY -= speed;
    }
    else if (checkKey("s")) {
      plD = 4;
      plY += speed;
    }
    plA += 0.3;
  }
  plA = plA % 7;
  JSONObject sprLoc = sprat.getJSONObject(str(plD)).getJSONObject(str(int(plA)));
  tempSpr = spriteSheet.get(sprLoc.getInt("x")*32, sprLoc.getInt("y")*32, 32, 32);
  image(tempSpr, plX-8, plY-8, 32, 32);
}

boolean checkKey(String k)
{
  if (keys.length >= int(k)) {
    return keys[int(k)];  
  }
  return false;
}
 
void keyPressed()
{ 
  keys[keyCode] = true;
}
 
void keyReleased()
{ 
  keys[keyCode] = false; 
}
