import processing.video.*;
Particle[] particles;

//PImage frog;
Capture frog;

void setup() {
  size(640, 360);
  
  frog = new Capture(this, 640, 480);
  frog.start();
  particles = new Particle [500];
  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle();
  }
  background(0);
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {

  for (int i = 0; i < particles.length; i++) {
    particles[i].display();
    particles[i].move();
  }
}
