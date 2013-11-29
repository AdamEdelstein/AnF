// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// PBox2D example

// Basic example of controlling an object with our own motion (by attaching a MouseJoint)
// Also demonstrates how to know which object was hit

// Add audio
import ddf.minim.*;
Minim minim;
AudioSample bouncing1;
//AudioSample bouncing2;
//AudioSample bouncing3;

//image
PImage img1;
PImage img2;
PImage img3;
PImage img4;
PImage img5;

int vAdjust = 0;
int hAdjust = 220;

import pbox2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

//import openkinect
import org.openkinect.*;
import org.openkinect.processing.*;

// Showing how we can farm all the kinect stuff out to a separate class
KinectTracker tracker;
// Kinect Library object
Kinect kinect;

//// A list we'll use to track fixed objects
//ArrayList<Boundary> boundaries;

// A reference to our box2d world
PBox2D box2d;

// Just a single box this time
Box box;
Boundary boundary1;
Boundary boundary2;
Boundary boundary3;
Boundary boundary4;
Boundary boundary5;
Boundary boundary6;
Boundary boundary7;
Boundary boundary8;
Boundary boundary9;

//
Score score1;

//Font
PFont font;

// An ArrayList of particles that will fall on the surface
ArrayList<Particle> particles;

// The Spring that will attach to the box from the mouse
Spring spring;

// Perlin noise values
float xoff = 0;
float yoff = 1000;
float m = 100;
float i = 10;

////animation
//int numFrames = 3;
//int frame = 0;
//PImage[] images = new PImage[numFrames];

void setup() {
  size(860, 480);
  smooth();
  //frameRate(20);

  //font
  font =loadFont("ARBONNIE-48.vlw");

  //loadImage
  img1 = loadImage("test 2.png");
  img2 = loadImage("test 3.png");
  img3 = loadImage("test 4.png");
  img4 = loadImage("test 5.png");
  img5 = loadImage("test 6.png");

  // Initialize box2d physics and create the world
  box2d = new PBox2D(this);
  box2d.createWorld();

  // Add audio
  minim = new Minim(this);

  bouncing1 = minim.loadSample("1.mp3");
  //  bouncing2 = minim.loadSample("2.wav");
  //  bouncing3 = minim.loadSample("3.wav");

  // Add a listener to listen for collisions!
  box2d.world.setContactListener(new CustomListener());

  // Make the box
  box = new Box(width/2, height/2);

  // Make the boundary
  boundary1 = new Boundary(525 + hAdjust, 460 + vAdjust, 90, 0);
  boundary2 = new Boundary(465 + hAdjust, 410 + vAdjust, 100, -PI/2.4);
  boundary3 = new Boundary(585 + hAdjust, 410 + vAdjust, 100, PI/2.4);
  boundary4 = new Boundary(525 + hAdjust, 310 + vAdjust, 90, 0);
  boundary5 = new Boundary(465 + hAdjust, 260 + vAdjust, 100, -PI/2.4);
  boundary6 = new Boundary(585 + hAdjust, 260 + vAdjust, 100, PI/2.4);
  boundary7 = new Boundary(525 + hAdjust, 160 + vAdjust, 90, 0);
  boundary8 = new Boundary(465 + hAdjust, 110 + vAdjust, 100, -PI/2.4);
  boundary9 = new Boundary(585 + hAdjust, 110 + vAdjust, 100, PI/2.4);


  //Make the Score
  score1 = new Score(0);

  // Make the spring (it doesn't really get initialized until the mouse is clicked)
  spring = new Spring();
  spring.bind(width/2, height/2, box);

  // Create the empty list
  particles = new ArrayList<Particle>();
  
   // Add a new Kinect tracker
  kinect = new Kinect(this);
  tracker = new KinectTracker();
}

void draw() {
  background(255);
  basket();

  //Font
  textFont(font);
  textSize(45);
  fill(0);
  text("20", 855, 270); 
  text("10", 855, 520); 
  text("5", 865, 770);  


  score1.display();
  // We must always step through time!
  box2d.step();
  //  //animated  character
  //  frame = (frame+1) % numFrames;
  //  image(images[frame], m, 0);

  // Display all the boundaries
  //  for (Boundary wall: boundaries) {
  //    wall.display();
  //  }

  if (random(1) < 0.08) {
    float sz = random(10, 15);

    m = m + i;
    particles.add(new Particle(m, -20, sz));

    i+=random(-1, 1);

    if (m<50||m>380)
    {
      i = i*-1;
      //      i+=random(-5, 5);
    }
  }

    // Kinect Tracking  
  // Run the tracking analysis
    tracker.track();
    // Show the image
    tracker.display();
  
    // Let's draw the raw location
    PVector v1 = tracker.getPos();
    fill(50,100,250,0);
    noStroke();
    rect(v1.x,v1.y,20,20);
  
    // Let's draw the "lerped" location
    PVector v2 = tracker.getLerpedPos();
    fill(100,250,50,0);
    noStroke();
    rect(v2.x,v2.y,20,20);
  
    // Display some info
    int t = tracker.getThreshold();
    textSize(14);
    fill(0);
    text("threshold: " + t + "    " +  "framerate: " + (int)frameRate + "    " + "UP increase threshold, DOWN decrease threshold",10,500);

  // Make an x,y coordinate out of perlin noise
  float x = noise(xoff)*width;
  float y = noise(yoff)*height;
  xoff += 0.01;
  yoff += 0.01;


  // Instead update the spring which pulls the mouse along

  spring.update(mouseX, mouseY);

  //box.body.setAngularVelocity(0);

  // Look at all particles
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.display();

    // Particles that leave the screen, we delete them
    // (note they have to be deleted from both the box2d world and our list
    if (p.done()) {
      particles.remove(i);
    }

    if (p.passing(450 + hAdjust, 363 + vAdjust) && p.k == true) {
      score1.addScore(5);
      p.k = false;

      fill(255, 0, 0);
      quad(450 + hAdjust, 360 + vAdjust, 600 + hAdjust, 360 + vAdjust, 570 + hAdjust, 460 + vAdjust, 480 + hAdjust, 460 + vAdjust);
    }

    if (p.passing(450 + hAdjust, 213 + vAdjust) && p.k == true) {
      score1.addScore(10);
      p.k = false;

      fill(255, 0, 0);
      quad(450 + hAdjust, 210 + vAdjust, 600 + hAdjust, 210 + vAdjust, 570 + hAdjust, 310 + vAdjust, 480 + hAdjust, 310 + vAdjust);
    }

    if (p.passing(450 + hAdjust, 63 + vAdjust) && p.k == true) {
      score1.addScore(20);
      p.k = false;

      fill(255, 0, 0);
      quad(450 + hAdjust, 60 + vAdjust, 600 + hAdjust, 60 + vAdjust, 570 + hAdjust, 160 + vAdjust, 480 + hAdjust, 160 + vAdjust);
    }
  }

  // Draw the box
  box.display();

  // Draw the Boundary
  boundary1.display(525 + hAdjust, 460 + vAdjust);
  boundary2.display(465 + hAdjust, 410 + vAdjust);
  boundary3.display(585 + hAdjust, 410 + vAdjust);
  boundary1.display(525 + hAdjust, 310 + vAdjust);
  boundary2.display(465 + hAdjust, 260 + vAdjust);
  boundary3.display(585 + hAdjust, 260 + vAdjust);
  boundary1.display(525 + hAdjust, 160 + vAdjust);
  boundary2.display(465 + hAdjust, 110 + vAdjust);
  boundary3.display(585 + hAdjust, 110 + vAdjust);
  
    // Connect the Box to the Average Point Tracker
  //translate(v1.x, v1.y);
  mouseX = int(v1.x);
  mouseY = int(v1.y);
    //  box.display();
  rectMode(CENTER);
  translate(v1.x, v1.y);
  //   rotate(-a);
    fill(215);
    stroke(0);
    //rect(0, 0, 50, 50);

}

void basket()
{
  noStroke();
      quad(450 + hAdjust, 360 + vAdjust, 600 + hAdjust, 360 + vAdjust, 570 + hAdjust, 460 + vAdjust, 480 + hAdjust, 460 + vAdjust);

  fill(255, 0, 0, 100);
      quad(450 + hAdjust, 210 + vAdjust, 600 + hAdjust, 210 + vAdjust, 570 + hAdjust, 310 + vAdjust, 480 + hAdjust, 310 + vAdjust);

  fill(0, 250, 0, 100);
      quad(450 + hAdjust, 60 + vAdjust, 600 + hAdjust, 60 + vAdjust, 570 + hAdjust, 160 + vAdjust, 480 + hAdjust, 160 + vAdjust);
}

void keyPressed() {
  int t = tracker.getThreshold();
  if (key == CODED) {
    if (keyCode == UP) {
      t+=5;
      tracker.setThreshold(t);
    } 
    else if (keyCode == DOWN) {
      t-=5;
      tracker.setThreshold(t);
    }
  }
}

void stop() {
  tracker.quit();
  super.stop();
}

