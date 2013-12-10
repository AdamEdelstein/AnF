// Add audio
import ddf.minim.*;
Minim minim;
AudioSample bouncing1;
AudioSample lose;
AudioSample winsound;


//image
PImage img1;
PImage img2;
PImage img3;
PImage img4;
PImage img5;
PImage gameover;
PImage score;
PImage bar;
PImage win;
PImage bg;
PImage treeTop;
PImage basketTop;
PImage basketBottom;

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
//int c;
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
  size(1000, 800, P2D);
  smooth();
  //frameRate(20);

  //
  n=-460;
  m = 100;
  i = 10;
  //  c = 0;

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
  bar = loadImage("bar.png");
  win = loadImage("win2.png");
  bg = loadImage("bg3.png");
  treeTop = loadImage("tree top.png");
  basketTop = loadImage("basket top.png");
  basketBottom = loadImage("basket bottom.png");

  // Initialize box2d physics and create the world
  box2d = new PBox2D(this);
  box2d.createWorld();

  // Add audio
  minim = new Minim(this);

  bouncing1 = minim.loadSample("1.mp3");
  lose = minim.loadSample("lose.mp3");
  winsound = minim.loadSample("win.mp3");
  //  bouncing2 = minim.loadSample("2.wav");
  //  bouncing3 = minim.loadSample("3.wav");

  // Add a listener to listen for collisions!
  box2d.world.setContactListener(new CustomListener());

  // Make the box
  box = new Box(width/2, height/2);

  // Make the boundary
  boundary1 = new Boundary(875, 780, 90, 0);
  boundary2 = new Boundary(805, 735, 120, -PI/2.6);
  boundary3 = new Boundary(945, 735, 120, PI/2.6);
  boundary4 = new Boundary(875, 530, 90, 0);
  boundary5 = new Boundary(805, 475, 120, -PI/2.6);
  boundary6 = new Boundary(945, 475, 120, PI/2.6);
  boundary7 = new Boundary(875, 280, 90, 0);
  boundary8 = new Boundary(805, 225, 120, -PI/2.6);
  boundary9 = new Boundary(945, 225, 120, PI/2.6);


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
  imageMode(CENTER);
  image(bg, width/2, height/2, width, height);
  basket();

  //  //
  //  tm = millis();

  //display countdown bar
  image(bar, 47, 400);


  //countdown system display
  rectangle1();
  textFont(font2);
  n+=0.2;
  //  c+=1;
  textSize(45);

  //game over or not?
  judge();



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
    imageMode(CORNER);
    image(treeTop, 0, 0, width, height);
    // Particles that leave the screen, we delete them
    // (note they have to be deleted from both the box2d world and our list
    if (p.done()) {
      particles.remove(i);
    }

    //passing 3 invisiable lines, then you gain points
    if (p.passing(800, 653) && p.k == true) {
      score1.addScore(5);
      p.k = false;
      p.trigger1();

//      //change color of score into red when passing
//      score1.col = color(255, 0, 0);
//      score1.display();
//      score1.col =color(6, 198, 197);
      //red blink when passing the invisible line
      //      fill(255, 0, 0);
      //      quad(800, 650, 950, 650, 920, 780, 830, 780);
    }

    if (p.passing(800, 403) && p.k == true) {
      score1.addScore(10);
      p.k = false;
      p.trigger1();
//      score1.col = color(255, 0, 0);
//      score1.display();
//      score1.col =color(6, 198, 197);
      //      fill(255, 0, 0);
      //      quad(800, 400, 950, 400, 920, 530, 830, 530);
    }

    if (p.passing(800, 153) && p.k == true) {
      score1.addScore(20);
      p.k = false;
      p.trigger1();
//      score1.col = color(255, 0, 0);
//      score1.display();
//      score1.col =color(6, 198, 197);
      //      fill(255, 0, 0);
      //      quad(800, 150, 950, 150, 920, 280, 830, 280);
    }
  }

  //display score image
  image(score, 730, 50);

  //display the bottom of the basket
  imageMode(CENTER);
  image(basketBottom, 875, 690);
  image(basketBottom, 875, 440);
  image(basketBottom, 875, 190);

  //display the "20""10""5" score
  textFont(font3);
  textSize(45);
  fill(0);
  text("20", 855, 280); 
  text("10", 855, 530); 
  text("5", 865, 780); 

  //winning conditional statament & displaying scores
  if (score1.a >= 300)
  {
    score1.display();
    winning();
  }

  else
  {
    score1.display();
  }

  // Draw the box
  box.display();

  // Draw the Boundary
  //  boundary1.display(875, 780);
  //  boundary2.display(805, 725);
  //  boundary3.display(945, 725);
  //  boundary1.display(875, 530);
  //  boundary2.display(805, 475);
  //  boundary3.display(945, 475);
  //  boundary1.display(875, 280);
  //  boundary2.display(805, 225);
  //  boundary3.display(945, 225);
}

void basket()
{
  //  noStroke();
  //  quad(800, 650, 950, 650, 920, 780, 830, 780);
  imageMode(CENTER);
  image(basketTop, 875, 690);
  image(basketTop, 875, 440);
  image(basketTop, 875, 190);

  //  fill(255, 0, 0, 100);
  //  quad(800, 400, 950, 400, 920, 530, 830, 530);
  //
  //  fill(0, 250, 0, 100);
  //  quad(800, 150, 950, 150, 920, 280, 830, 280);
}

//countdown system  - rectangle
void rectangle1()
{
  rectMode(CORNER);
  noStroke();

  if (n<=0 && n<=-300)
  {
    fill(0, 160, 233);
  }
  else if (n>-300 && n<=-100)
  {
    fill(247, 124, 0);
  }
  else if (n>-100 && n<0)
  {
    fill(255, 0, 0);
  }

  rect(40, 631, 15, n, 20, 20, 20, 20);
}

void winning()
{
  imageMode(CENTER);
  image(win, width/2, height/2, width*2/3, height*2/3);
 winsound.trigger();
  textFont(font3);
  textSize(45);
  fill(0);
  text("press   'Spacebar'   to restart", width/2-220, height/2+200); 
  noLoop();
}
void gameover()
{
  imageMode(CENTER);
  image(gameover, width/2, height/2, width*2/3, height*2/3);
  textFont(font3);
  textSize(45);
  fill(0);
  text("press   'Spacebar'   to restart", width/2-220, height/2+200); 
 lose.trigger();
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

