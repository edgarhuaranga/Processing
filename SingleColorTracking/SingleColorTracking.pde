import processing.video.*;

Capture video;

color trackColor; 

void setup() {
  size(640, 360);
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, cameras[0]);
  video.start();
  trackColor = color(255, 0, 0);
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  video.loadPixels();
  image(video, 0, 0);
  float worldRecord = 500; 

  int closestX = 0;
  int closestY = 0;

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      print(x + "," + y);
      //int loc = x + y * video.width;
      
      
      // Using euclidean distance to compare colors

    }
  }


  delay(5000);
}

void mousePressed() {

  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
}
