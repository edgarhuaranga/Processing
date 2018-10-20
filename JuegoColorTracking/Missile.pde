class Missile
{
  float x; //missile x
  float y; //missile y
  float vy; //missile vy
  float g; //gravity
  float maxDist; //How far in the y-direction the missile travels before it is called up again.


  //Missile constructor
  Missile()
  {
    //Missile will be at top of screen halfway between the paddle
    x = random(10, width-10); //missile starts in random position at top of screen
    y = 0; //missile starts at y
    vy = 2; //missile y velocity
    g = 0.4; //gravity

    maxDist = 10000;
  }

  void update()
  {
    //Draw the missile
    noStroke();
    fill(255, 0, 0); //missile is red    
    beginShape();
    vertex(x, y);
    vertex(x-5, y-10);
    vertex(x-5, y-50);
    vertex(x, y-25);
    vertex(x+5, y-50);
    vertex(x+5, y-10);
    endShape(CLOSE);

    y += vy; //increment in y direction
    vy += g; //GRAVITY
  }


  //Reloads the missile (puts it at the top of the screen).
  //Also, resets the vy 
  void reload()
  {
    x = random(10, width-10); 
    y = 0;
    vy = 2;

    //Redraw the missile.
    noStroke();
    fill(255, 0, 0);
    beginShape();
    vertex(x, y);
    vertex(x-5, y-10);
    vertex(x-5, y-50);
    vertex(x, y-25);
    vertex(x+5, y-50);
    vertex(x+5, y-10);
    endShape(CLOSE);
  }
}