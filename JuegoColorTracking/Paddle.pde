class Paddle{
  float x; //paddle x
  float y; //padlle y
  float w; //paddle width
  float h; //paddle height
  float r; //paddle red val
  float g; //paddle green val
  float b; //paddle blue val

  //Paddle constructor
  Paddle()
  {
    x = width/2;
    y = 300;
    w = 100;
    h = 10;
    r=255;
    g=255;
    b=255;
  }

  void update(float xCamera)
  {
    //Paddle follows the mouse
    //x = mouseX;    

    //Draw paddle
    x = width - xCamera;
    fill(r, g, b);
    rect(x, y, w, h);
  }
  
  void update()
  {
    //Paddle follows the mouse
    x = mouseX;    

    //Draw paddle
    fill(r, g, b);
    rect(x, y, w, h);
  }
}