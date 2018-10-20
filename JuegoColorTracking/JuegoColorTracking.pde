
import processing.video.*;

Capture video;

color trackColor; 
float threshold = 50;
float distThreshold = 75;

ArrayList<Blob> blobs = new ArrayList<Blob>();


int rows = 5; //Number of bricks per row
int columns = 5; //Number of columns
int total = rows * columns; //Total number of bricks
int score = 0; //How many bricks have been hit by the player
int gameScore = 0; //The player's score which displays on the screen.
int streak = 0;  //How many bricks in a row the player has hit without the ball touching the paddle or using a missile.
int maxStreak = 0; //Max streak in any given round
int lives = 5; //lives
float paddlePosition=width/2;

Paddle paddle2 = new Paddle(); //initialize paddle (it is called paddle2, b/c paddlle1 looks weird when it's typed)
Ball ball2 = new Ball(); //initialize ball (named ball2 for the same reason as above)
Brick[] box = new Brick[total]; //Initialize the array that will hold all the bricks
Missile missile2 = new Missile(); //Initialize missile


void setup() {
  size(640, 360);
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, cameras[0]);
  video.start();
  trackColor = color(0, 255, 0);//definir el color a buscar(ROJO)
  
  //Setup array of all bricks on screen
  for (int i = 0; i < rows; i++){
    for (int j = 0; j< columns; j++){
      box[i*rows + j] = new Brick((i+1) *width/(rows + 2), (j+1) * 50); //places all the bricks into the array, properly labelled.
    }
  }
  
  
 
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  background(0);
  video.loadPixels();
  blobs.clear();
  threshold = 80;

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d < threshold*threshold) {

        boolean found = false;
        for (Blob b : blobs) {
          if (b.isNear(x, y)) {
            b.add(x, y);
            found = true;
            break;
          }
        }

        if (!found) {
          Blob b = new Blob(x, y);
          blobs.add(b);
        }
      }
    }
  }

  for (Blob b : blobs) {
    if (b.size() > 500) {
      b.show();
      paddlePosition = b.minx;
    }
  }
  
  
  //Draw bricks from the array of bricks
  for (int i = 0; i<total; i++)
  {
    box[i].update();
  }

  //Draw paddle, ball
  paddle2.update(paddlePosition);
  //paddle2.update();
  ball2.update();


  //BALL AND PADDLE/WALL INTERACTIONS

  //If the ball hits the paddle, it goes the other direction
  //If the ball hits the left of the paddle, it goes to the left
  //If the ball hits the right of the paddle, it goes to the right

  //Ball hits left side of paddle
  if (ball2.y == paddle2.y && ball2.x > paddle2.x && ball2.x <= paddle2.x + (paddle2.w/2) )
  {
    ball2.goLeft();
    ball2.changeY();
    streak = 0; //Streak ends
  }

  //Ball hits right side of paddle
  if (ball2.y == paddle2.y && ball2.x > paddle2.x + (paddle2.w/2) && ball2.x <= paddle2.x + paddle2.w )
  {
    ball2.goRight();
    ball2.changeY();
    streak = 0; //streak ends
  }

  //If the ball hits the RIGHT wall, go in same y direction, but go left  
  if (ball2.x + ball2.D / 2 >= width)
  {
    ball2.goLeft();
  }

  //If the ball hits the LEFT wall, go in same y direction, but go right
  if (ball2.x - ball2.D / 2 <= 0)
  {
    ball2.goRight();
  }

  //If the ball hits the ceiling, go down in a different direction
  if (ball2.y - ball2.D / 2 <= 0)
  {
    ball2.changeY();
  }


  //BALL,  BRICK, and MISSILE INTERACTIONS

  for (int i = 0; i < total; i ++)
  {
    //If ball hits bottom of brick, ball moves down, increment score
    if (ball2.y - ball2. D / 2 <= box[i].y + box[i].h &&  ball2.y - ball2.D/2 >= box[i].y && ball2.x >= box[i].x && ball2.x <= box[i].x + box[i].w  && box[i].hit == false )
    {
      ball2.changeY();
      box[i].gotHit();
      score += 1;
      gameScore += 10;
      streak += 1;

      //Calculate the maximum streak to display final score at end.
      if (streak>maxStreak)
      {
        maxStreak = streak;
      }
    } 

    //If ball hits top of brick ball moves up, increment score
    if (ball2.y + ball2.D / 2 >= box[i].y && ball2.y - ball2.D /2 <= box[i].y + box[i].h/2 && ball2.x >= box[i].x && ball2.x <= box[i].x + box[i].w && box[i].hit == false ) 
    {
      ball2.changeY();
      box[i].gotHit();
      score += 1;
      gameScore += 10;
      streak += 1;

      //Calculate the maximum streak to display final score at end.
      if (streak>maxStreak)
      {
        maxStreak = streak;
      }
    }

    //if ball hits the left of the brick, ball switches to the right, and moves in same direction, increment score
    if (ball2.x + ball2.D / 2 >= box[i].x && ball2.x + ball2.D / 2 <= box[i].x + box[i].w / 2 && ball2.y >= box[i].y && ball2.y <= box[i].y + box[i].h  && box[i].hit == false)
    {
      ball2.goLeft();
      box[i].gotHit();
      score += 1;
      gameScore += 10;
      streak += 1;

      //Calculate the maximum streak to display final score at end.
      if (streak>maxStreak)
      {
        maxStreak = streak;
      }
    }

    //if ball hits the right of the brick, ball switches to the left, and moves in same direction, increment score
    if (ball2.x - ball2.D/2 <= box[i].x + box[i].w && ball2.x +ball2.D / 2 >= box[i].x + box[i].w / 2 && ball2.y >= box[i].y && ball2.y <= box[i].y + box[i].h  && box[i].hit == false)
    {
      ball2.goRight();
      box[i].gotHit();
      score += 1;
      gameScore += 10;
      streak += 1;

      //Calculate the maximum streak to display final score at end.
      if (streak>maxStreak)
      {
        maxStreak = streak;
      }
    }

    //ball2.y + ball2.D / 2 >= box[i].y && ball2.y - ball2.D /2 <= box[i].y + box[i].h/2 && ball2.x >= box[i].x && ball2.x <= box[i].x + box[i].w && box[i].hit == false 

    //If the missile hits the top of a brick...
    if (missile2.y >=box[i].y && missile2.y <= box[i].y + box[i].h/2 && missile2.x >= box[i].x  && missile2.x <= box[i].x + box[i].w && box[i].hit == false)
    {
      box[i].gotHit();
      score += 1;
      gameScore += 10;
      streak += 1;
      missile2.reload();
    }
  }
  

  //MISSILE and PADDLE interactions
  
  //If the missile hits the paddle
  if (missile2.x >= paddle2.x && missile2.x <= paddle2.x + paddle2.w && missile2.y >= paddle2.y && missile2.y <= paddle2.y + paddle2.h)
  {
    paddle2.g = 0;
    paddle2.b = 0;
    lives -= 1;
  }
  

  //MISSILE and BRICK interactions
  
  //Every frame, draw the missile
  missile2.update();

  //If the missile travels a certain distance down in the y direction, it gets reloaded to the top, and fired again.
  if (missile2.y > missile2.maxDist)
  {
    missile2.reload();
    
    //paddle's g and b values turn back to 255 (making the paddle white again).
    paddle2.g = 255; 
    paddle2.b = 255;
  }

  //If there is only 1 brick left, missiles appear more frequently
  if (score == total - 1)
  {
    //This is achieved by decreasing the distance the missile has to travel before it resets.
    missile2.maxDist = 700;
  }

  //If ball goes off the screen, reset the ball, and lose a life.
  if (ball2.y > height)
  {
    ball2.reset();
    lives -= 1;
  }


  //Displays score in top left corner!
  textSize(32);
  text(gameScore, 10, 30);

  //Displays lives in bottom left corner
  textSize(18);
  text("LIVES: ", 10, height-20);
  text(lives, 70, height-20); 

  //If the player wins/loses, he/she can click the mouse to restart the game.
  if (score == total || lives <= 0)
  {
    resetGame();
  } 


  //Once the score is equal to the total, bring up the "game over" screen.
  if (score == total)
  {
    gameWin();
  }

  //If no more lives are left, game ends
  if (lives <= 0)
  {
    gameLose();
  }
}


float distSq(float x1, float y1, float x2, float y2) {//distancia entre pixeles del mismo color
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}


float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

void resetGame()
{

  //Setup array of all bricks on screen
  for (int i = 0; i < rows; i++)
  {
    for (int j = 0; j< columns; j++)
    {
      box[i*rows + j] = new Brick((i+1) *width/(rows + 2), (j+1) * 50);
    }

    //Reset all the score values
    score = 0;
    gameScore = 0;
    streak = 0;
    maxStreak = 0;
    lives = 5;

    //Reset the missile's maximum distance
    missile2.maxDist = 10000;
  }

  //Reset the ball as well
  ball2.reset();
}

//Function that displays the gameOver screen
void gameWin()
{ 

  //Says "You win!", displays score, max streak, and allows user to click screen to play again. 
  background(0);
  textSize(32);
  text("YOU WIN!", 100, 200);
  text("Score: ", 100, 300);
  text(gameScore, 300, 300);
  text("Max Streak: ", 100, 400); 
  text(maxStreak, 300, 400);
  text("Click mouse to play again!", 100, 500);
  
  //The game is still technically playing when this screen is brought up, 
  //so these steps help to isolate the ball and missiles.
  ball2.x = -10;
  ball2.y = -10;
  ball2.vx = 0;
  ball2.vy = 0;

  missile2.x = -20;
  missile2.y = -20;
}


void gameLose()
{
  //Says "Game over", displays score, max streak, and allows user to click screen to play again. 
  background(0);
  textSize(32);
  text("GAME OVER", 100, 200);
  text("Score: ", 100, 300);
  text(gameScore, 300, 300);
  text("Max Streak: ", 100, 400); 
  text(maxStreak, 300, 400);
  text("Click mouse to play again!", 100, 500);

  //The game is still technically playing when this screen is brought up, 
  //so these steps help to isolate the ball and missiles.
  ball2.x = -10;
  ball2.y = -10;
  ball2.vx = 0;
  ball2.vy = 0;

  missile2.x = -20;
  missile2.y = -20;
}
