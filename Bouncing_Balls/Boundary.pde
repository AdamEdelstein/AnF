// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2012
// PBox2D example

// A rectangular box

class Boundary {

  // We need to keep track of a Body and a width and height
  Body body;
  float w;
  float h;

  // Constructor
  Boundary(float x_, float y_, float w_, float a_) {
    float x = x_;
    float y = y_;
    float a = a_;
    w = w_;
    h = 2;
    // Add the box to the box2d world

    makeBody(new Vec2(x, y), w, h, a);
    body.setUserData(this);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  boolean contains(float x, float y) {
    Vec2 worldPoint = box2d.coordPixelsToWorld(x, y);
    Fixture f = body.getFixtureList();
    boolean inside = f.testPoint(worldPoint);
    return inside;
  }

  // Drawing the box
  void display(int x, int y) {
    // We look at each body and get its screen position
    //    Vec2 pos = box2d.getBodyPixelCoord(body);


    //    // Get its angle of rotation
    //    float a = body.getAngle();
    float a = body.getAngle();
    rectMode(CENTER);
    pushMatrix();
    translate(x, y);
    rotate(-a);
    fill(215);
    stroke(0);
    rect(0, 0, w, h);
    popMatrix();
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float w_, float h_, float a) {
    // Define and create the body
    BodyDef bd = new BodyDef();

    bd.type = BodyType.STATIC;
    bd.angle = a;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.1;
    fd.restitution = 0.00001;

    body.createFixture(fd);
    //body.setMassFromShapes();

    // Give it some initial random velocity
    //body.setLinearVelocity(new Vec2(random(-2, 2), random(1, 2)));
    // body.setAngularVelocity(random(-2, 2));
  }
}

