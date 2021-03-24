
// data[x][y][z]
PImage img;
boolean[][][] data;
int width = 200;
int height = 200;
int depth = 15;
int[] god;
float godradius = 0;
float godchaos = 0;
float godpotency = 1.0;
float godspread = 100;
float chance = .11;
float stab = .001;
int hueoff = (int)random(360);

void setup() {
  data = new boolean[width][height][depth];
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      for (int z = 0; z < depth; z++) {
        data[x][y][z] = random(1) < 0.5;
      }
    }
  }
  img = createImage(width, height, RGB);
  
  god = new int[3];
  god[0] = 250;//(int)random(width);
  god[1] = 250;//(int)random(height);
  god[2] = (int)random(depth);
  // size(width, height);
  size(200, 200);
  
  //fill(color(255,0,0));
  colorMode(HSB, 255);
}

void draw() {
  img.loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int val = 0;
      int hue1 = 0, hue2 = 0;
      for (int z = 0; z < depth; z++) {
        int x2 = (x+width/2)%width;
        int y2 = (y+height/2)%height;
        int z2 = (z+depth/2)%depth;
        val += data[x][y][z] ? 1 : 0;
        hue1 += data[x][y][z] ? 1 : 0;
        hue2 += data[x2][y2][z2] ? 1 : 0;
      }
      val *= (255/depth);
      hue1 *= (255/depth);
      hue2 *= (255/depth);
      
      int hue = (hue1+hue2)/2;
      
      hue = (hue+hueoff)%360;
      
      //hue = (hue+(int)random(random(180)))%360;
      
      img.pixels[y*width+x] = color(hue, val, val);
    }
  }
  //img.pixels[god[1]*width+god[0]] = color(255, 0, 255);
  img.updatePixels();
  image(img, 0, 0);
  
  int max = width*height*depth;
  int half = max/2;
  
  int total = 0;
  
  boolean[][][] newData = new boolean[width][height][depth];
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      for (int z = 0; z < depth; z++) {
        if (random(1) < chance)
          newData[x][y][z] = interact(x, y, z);
        else
          newData[x][y][z] = data[x][y][z];
        if (newData[x][y][z]) total++;
      }
    }
  }
  
  //stab *= .9;
  
  if (total < half)
    chance -= stab;
  else
    chance += stab;
  
  
  god[0] += (int)(random(godchaos)-godchaos/2);
  god[1] += (int)(random(godchaos)-godchaos/2);
  if (god[0] >= width) god[0] = 0;
  if (god[1] >= height) god[1] = 0;
  if (god[0] < 0) god[0] = width-1;
  if (god[1] < 0) god[1] = height-1;
  
  data = newData;
  
  //text(chance, 10, 30);
}

boolean interact(int x, int y, int z) {
  
  boolean current = data[x][y][z];
  boolean above, below, toTheLeftOf, toTheRightOf;
  
  if (y == 0) {
    above = data[x][height-1][z];
  } else {
    above = data[x][y-1][z];
  }
  
  if (y == height-1) {
    below = data[x][0][z];
  } else {
    below = data[x][y+1][z];
  }
  
  if (x == 0) {
    toTheLeftOf = data[width-1][y][z];
  } else {
    toTheLeftOf = data[x-1][y][z];
  }
  
  if (x == width-1) {
    toTheRightOf = data[0][y][z];
  } else {
    toTheRightOf = data[x+1][y][z];
  }
  
  int sum = (above ? 1 : 0) +
            (toTheRightOf ? 1 : 0) +
            (below ? 1 : 0) +
            (toTheLeftOf ? 1 : 0);
  
  //return ((above && toTheRightOf || 
  //        toTheRightOf && below || 
  //        below && toTheLeftOf || 
  //        toTheLeftOf && above) );
          //(dist(x, y, god[0], god[1]) < godradius);
          //(x == god[0] && y == god[1] );
          return (above && toTheRightOf || toTheRightOf && below || below && toTheLeftOf || toTheLeftOf && above) && random(1) > chance;
          //return   above && below || toTheLeftOf && toTheRightOf || random(1) > chance; //7.95/9.0;
                 // || (dist(x,y,god[0],god[1]) < random(width*.1));
}

float distance(float x1, float y1, float x2, float y2) {
  return sqrt(pow(x2-x1,2) + pow(y2-y1,2));
}

void keyPressed() {
  godspread ++;
}

void mouseMoved() {
  god[0] = mouseX;
  god[1] = mouseY;
}
