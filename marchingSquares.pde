float[][] noiseField;
int gridSize = 2;
int cols, rows;
float inc = 0.01;
float zoff = 0.0; //used to animate

void setup(){
  size(800, 800);

  cols = 1 + width/gridSize;
  rows = 1 + height/gridSize;
  noiseField = new float[cols][rows];

  /* noLoop(); */
  strokeWeight(1);
  /* frameRate(10); */
}

void draw(){
  //create noiseField
  /* background(147, 233, 190); */
  background(255);
  setField();
  /* seeField(); //visualize what the field look like */

  //when interplated, this isn't working anymore
  for(float i = 0; i < 1; i+=0.02){
    /* stroke(0, 0, 0); */
    stroke(0);
    march(i);
  }

  /* march(0.1); */
  /* march(0.2); */
  /* march(0.3); */
  /* march(0.4); */
  /* march(0.5); */
  /* march(0.6); */

  zoff += 0.001; //for animating
}

void setField(){
  float xoff = 0;
  for(int i = 0; i < cols; i++){
    xoff += inc;
    float yoff = 0;
    for(int j = 0; j < rows; j++){
      noiseField[i][j] = noise(xoff, yoff, zoff);
      /* noiseField[i][j] = random(1); */
      yoff += inc;
    }
  }
}

void seeField(){
  noStroke();
  for(int i = 0; i < cols; i++){
    for(int j = 0; j < rows; j++){
      fill(noiseField[i][j] * 255);
      noStroke();
      rect(i * gridSize, j * gridSize, gridSize, gridSize);

      /* fill(0, 255, 0); */
      /* ellipse(i * gridSize + gridSize / 2, j * gridSize, 20, 20); //A */
      /* ellipse(i * gridSize + gridSize, j * gridSize + gridSize/2, 20, 20); //B */
      /* ellipse(i * gridSize + gridSize / 2, j * gridSize + gridSize, 20, 20); //C */
      /* ellipse(i * gridSize, j * gridSize + gridSize/2, 20, 20); //B */
    }
  }

}

void march(float threshold){

  for (int i = 0; i < cols-1; i++) {
    for (int j = 0; j < rows-1; j++) {
      float x = i * gridSize;
      float y = j * gridSize;

      int tl = noiseField[i][j] > threshold ? 1 : 0;
      int tr = noiseField[i+1][j] > threshold ? 1 : 0;
      int br = noiseField[i+1][j+1] > threshold ? 1 : 0;
      int bl = noiseField[i][j+1] > threshold ? 1 : 0;

      int state = getState(tl, tr, br, bl);

      //original used simplex
      //you are converting to perlin
      //your mapping becasue perlin noise is 0 to 1 and simplex is -1 to 1
      /* float a_val = map(noiseField[i][j], 0, 1,  -threshold, threshold) + threshold; //top left */
      /* float b_val = map(noiseField[i+1][j], 0, 1,  -threshold, threshold) + threshold; //top right */
      /* float c_val = map(noiseField[i+1][j+1], 0, 1, -threshold, threshold) + threshold; //bottom right */
      /* float d_val = map(noiseField[i][j+1], 0, 1, -threshold, threshold) + threshold; //bottom left */

      float a_val = noiseField[i][j];
      float b_val = noiseField[i+1][j];
      float c_val = noiseField[i+1][j+1];
      float d_val = noiseField[i][j+1];

      /* if(state != 15 && state != 0){ */
      /*   println(state); */
      /*   println(a_val + " " + b_val + " " + c_val + " " + d_val); */
      /* } */

      
      PVector a = new PVector();
      /* float amt = a_val + (b_val - a_val) * 0.5; */
      /* float amt = 0.5 + (b_val - a_val) * 0.5; */
      /* float amt = (a_val) / (b_val - a_val); */
      /* (threshold - a) / (b - a) */
      /* float amt = a_val / (b_val + a_val); */
      float amt = (threshold - a_val) / (b_val - a_val);
      a.x = lerp(x, x + gridSize, amt);
      a.y = y;

      PVector b = new PVector();
      /* amt = b_val + (c_val - b_val) * 0.5; */
      /* amt = 0.5 + (c_val - b_val) * 0.5; */
      /* amt = (b_val) / (c_val - b_val); */

      /* amt = b_val / (c_val + b_val); */
      amt = (threshold - b_val) / (c_val - b_val);
      b.x = x + gridSize;
      b.y = lerp(y, y+gridSize, amt);

      PVector c = new PVector();
      /* amt = c_val + (c_val - d_val) * 0.5; */
      /* amt = 0.5 + (c_val - d_val) * 0.5; */

      /* amt = (d_val) / (c_val - d_val); */
      /* amt = c_val / (d_val + c_val); */
      amt = (threshold - d_val) / (c_val - d_val);
      c.x = lerp(x, x + gridSize, amt);
      c.y = y + gridSize;

      PVector d = new PVector();
      /* amt = d_val + (d_val - a_val) * 0.5; */
      /* amt = 0.5 + (d_val - a_val) * 0.5; */
      /* amt = (a_val) / (d_val - a_val); */
      /* amt = d_val / (a_val + d_val); */


      amt = (threshold - a_val) / (d_val - a_val);
      d.x = x;
      d.y = lerp(y, y + gridSize, amt);

      //no linear interpolation
      /* PVector a = new PVector(x + gridSize * 0.5, y); */
      /* PVector b = new PVector(x + gridSize, y + gridSize * 0.5); */
      /* PVector c = new PVector(x + gridSize * 0.5, y + gridSize); */
      /* PVector d = new PVector(x, y + gridSize* 0.5); */
      stroke(0);
      switch (state) {
        case 1:
          /* println("case 1"); */
          line(c, d);
          break;
        case 2:
          /* println("case 2"); */
          line(b, c);
          break;
        case 3:
          /* println("case 3"); */
          line(b, d);
          break;
        case 4:
          /* println("case 4"); */
          line(a, b);
          break;
        case 5:
          /* println("case 5"); */
          line(a, d);
          line(b, c);
          break;
        case 6:
          /* println("case 6"); */
          line(a, c);
          break;
        case 7:
          /* println("case 7"); */
          line(a, d);
          break;
        case 8:
          /* println("case 8"); */
          line(a, d);
          break;
        case 9:
          /* println("case 9"); */
          line(a, c);
          break;
        case 10:
          /* println("case 10"); */
          line(a, b);
          line(c, d);
          break;
        case 11:
          /* println("case 11"); */
          line(a, b);
          break;
        case 12:
          /* println("case 12"); */
          line(b, d);
          break;
        case 13:
          /* println("case 13"); */
          line(b, c);
          break;
        case 14:
          /* println("case 14"); */
          line(c, d);
          break;
      }
    }
  }
}

int getState(int a, int b, int c, int d) {
  return a * 8 + b * 4  + c * 2 + d * 1;
}

//overloaded line function
void line(PVector v1, PVector v2) {
  line(v1.x, v1.y, v2.x, v2.y);
}

