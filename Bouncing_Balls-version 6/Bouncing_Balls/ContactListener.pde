// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// PBox2D example

// ContactListener to listen for collisions!



import org.jbox2d.callbacks.ContactImpulse;
import org.jbox2d.callbacks.ContactListener;
import org.jbox2d.collision.Manifold;
import org.jbox2d.dynamics.contacts.Contact;

class CustomListener implements ContactListener {
  CustomListener() {
  }

  // This function is called when a new collision occurs
  void beginContact(Contact cp) {
    // Get both fixtures
    Fixture f1 = cp.getFixtureA();
    Fixture f2 = cp.getFixtureB();

    // Get both bodies
    Body b1 = f1.getBody();
    Body b2 = f2.getBody();

    // Get our objects that reference these bodies
    Object o1 = b1.getUserData();
    Object o2 = b2.getUserData();

    // If object 1 is a Box, then object 2 must be a particle
    // Note we are ignoring particle on particle collisions
    if (o1.getClass() == Box.class) {
      Particle p = (Particle) o2;
      //p.change();

      p.trigger1();
      int step = int(random(5));
      //      println(step);
      switch(step)
      {
      case 0:
        p.changeImage1();
        break;
      case 1:
        p.changeImage2();
        break;
      case 2:
        p.changeImage3();
        break;
      case 3:
        p.changeImage4();
        break;
      case 4:
        p.changeImage5();
        break;
      }
    } 
    // If object 2 is a Box, then object 1 must be a particle
    else if (o2.getClass() == Box.class) {
      Particle p = (Particle) o1;
      //p.change();
      p.trigger1();

      //      int step = int(random(5));
      //
      //      switch(step)
      //      {
      //      case 0:
      //        p.changeImage1();
      //      case 1:
      //        p.changeImage2();
      //      case 2:
      //        p.changeImage3();
      //      case 3:
      //        p.changeImage4();
      //      case 4:
      //        p.changeImage5();
      //      }
    }

    //    else if (o1.getClass() == Box.class)
    //    {
    //      Particle p = (Particle) o2;
    //      p.change();
    //      int step = int(random(3));
    //      switch(step)
    //      {
    //      case 0:
    //        p.trigger1();
    //      case 1:
    //        p.trigger2();
    //      case 2:
    //        p.trigger3();
    //      }
    //    }
  }

  void endContact(Contact contact) {
    // TODO Auto-generated method stub
  }

  void preSolve(Contact contact, Manifold oldManifold) {
    // TODO Auto-generated method stub
  }

  void postSolve(Contact contact, ContactImpulse impulse) {
    // TODO Auto-generated method stub
  }
}

