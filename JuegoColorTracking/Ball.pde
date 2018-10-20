class Ball
{

  float x;  //ball x
  float y; //ball y
  float vx; //ball velocity in x
  float vy; //ball velocity in y 
  float D; //ball diameter

  //Ball constructor
  Ball()
  {
    x = width/2;
    y = 200;
    vx = 0; //Initially, ball just falls straight down
    vy = 4; 
    D = 10;
  }

  //Update the ball
  void update()
  {
    noStroke();
    fill(255);
    ellipse(x, y, D, D);

    y += vy; //increment y
    x += vx; //increment x
  }

  //Ball goes left
  void goLeft()
  {
    vx = -4; //decrement x
  }

  //Ball goes right
  void goRight()
  {
    vx = 4; //increment x
  }

  //Ball changes in y direction
  void changeY()
  {
    vy *= -1; 
  }

  //If ball goes below paddle, reset
  void reset()
  {
    x = width/2;
    y = 200;
    vx = 0;
    vy = 4;
  }
}