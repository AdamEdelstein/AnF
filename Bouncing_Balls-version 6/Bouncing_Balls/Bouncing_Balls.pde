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
PImage gameover;
PImage score;

import pbox2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

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

//Score system
Score score1;

//Font
PFont font;
PFont font2;
PFont font3;

//countdown system
float n;
int c;
String time = "010";
//int t;


//int interval = 10;

// An ArrayList of particles that will fall on the surface
ArrayList<Particle> particles;

// The Spring that will attach to the box from the mouse
Spring spring;

// Perlin noise values
float xoff = 0;
float yoff = 1000;
float m;
float i;
//int tm;
int last = 0;
int countdown = 0;



////animation
//int numFrames = 3;
//int frame = 0;
//PImage[] images = new PImage[numFrames];

void setup() {
  size(1000, 800);
  smooth();
  //frameRate(20);

  //
  n=-400;
  m = 100;
  i = 10;
  c = 0;

  //font
  font =loadFont("ARBONNIE-48.vlw");
  font2 = createFont("Arial", 30);
  font3 = loadFont("ARCHRISTY-48.vlw");

  //loadImage
  img1 = loadImage("test 2.png");
  img2 = loadImage("test 3.png");
  img3 = loadImage("test 4.png");
  img4 = loadImage("test 5.png");
  img5 = loadImage("test 6.png");
  gameover = loadImage("gameover.png");
  score = loadImage("score.png");

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
  boundary1 = new Boundary(875, 780, 90, 0);
  boundary2 = new Boundary(815, 715, 130, -PI/2.4);
  boundary3 = new Boundary(935, 715, 130, PI/2.4);
  boundary4 = new Boundary(875, 530, 90, 0);
  boundary5 = new Boundary(815, 465, 130, -PI/2.4);
  boundary6 = new Boundary(935, 465, 130, PI/2.4);
  boundary7 = new Boundary(875, 280, 90, 0);
  boundary8 = new Boundary(815, 215, 130, -PI/2.4);
  boundary9 = new Boundary(935, 215, 130, PI/2.4);


  //Make the Score
  score1 = new Score(0);

  // Make the spring (it doesn't really get initialized until the mouse is clicked)
  spring = new Spring();
  spring.bind(width/2, height/2, box);

  // Create the empty list
  particles = new ArrayList<Particle>();
}

void draw() {
  background(255);
  basket();

//  //
//  tm = millis();

  //display score image
  image(score, 780, 70);

  //Font
  textFont(font);
  textSize(45);
  fill(0);
  text("20", 855, 270); 
  text("10", 855, 520); 
  text("5", 865, 770);  

  //countdown system display
  rectangle1();
  textFont(font2);
  n+=1;
  c+=1;
  textSize(45);

  //game over or not?
  judge();


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

    if (m<50||m>700)
    {
      i = i*-1;
      //      i+=random(-5, 5);
    }
  }



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

    if (p.passing(800, 653) && p.k == true) {
      score1.addScore(5);
      p.k = false;

      fill(255, 0, 0);
      quad(800, 650, 950, 650, 920, 780, 830, 780);
    }

    if (p.passing(800, 403) && p.k == true) {
      score1.addScore(10);
      p.k = false;

      fill(255, 0, 0);
      quad(800, 400, 950, 400, 920, 530, 830, 530);
    }

    if (p.passing(800, 153) && p.k == true) {
      score1.addScore(20);
      p.k = false;

      fill(255, 0, 0);
      quad(800, 150, 950, 150, 920, 280, 830, 280);
    }
  }

  // Draw the box
  box.display();

  // Draw the Boundary
  boundary1.display(875, 780);
  boundary2.display(815, 715);
  boundary3.display(935, 715);
  boundary1.display(875, 530);
  boundary2.display(815, 465);
  boundary3.display(935, 465);
  boundary1.display(875, 280);
  boundary2.display(815, 215);
  boundary3.display(935, 215);
}

void basket()
{
  noStroke();
  quad(800, 650, 950, 650, 920, 780, 830, 780);


  fill(255, 0, 0, 100);
  quad(800, 400, 950, 400, 920, 530, 830, 530);

  fill(0, 250, 0, 100);
  quad(800, 150, 950, 150, 920, 280, 830, 280);
}

//countdown system  - rectangle
void rectangle1()
{
  rectMode(CORNER);
  noStroke();
  fill(c, 0, 0);
  if (n<=0)
  {
    rect(40, 730, 15, n);
  }
}

void gameover()
{
  imageMode(CENTER);
  image(gameover, width/2, height/2, width*2/3, height*2/3);
  //  textSize(45);
  //  text("GAME OVER", width/2-150, height/2-20);
  //  textSize(30);
  //  text("Tap SPACE To Restart", width/2-165, height/2+30);
}

void keyPressed()
{
  if (key == ' ')
  {
    setup();
    loop();
    background(255);
    last = millis();
  }
}

void judge()
{
//
//  t = interval-tm/1000;
//  countdown = tm - last;

  if (n>=0)
  {
    gameover();
    noLoop();
  }


}

