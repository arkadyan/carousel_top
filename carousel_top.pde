import processing.video.*;
import toxi.processing.*;


private static final color BACKGROUND_COLOR = #000000;

// Whether or not to display extra visuals for debugging.
private boolean debug = false;

ToxiclibsSupport gfx;

// Whether or not to record a movie with this run.
// NOTE: Be sure to quit the running sketch by pressing ESC.
private boolean makingMovie = false;
// MovieMake object to write a movie file.
private MovieMaker mm;

// A representation of the carousel seen from above.
SegmentedCircle carousel;


void setup() {
  size(680, 480);
/*  size(1920, 1355);*/
  smooth();
  noCursor();
  
  gfx = new ToxiclibsSupport(this);
  
  // Create MovieMaker object with size, filename,
  // compression codec and quality, framerate
  if (makingMovie) {
    mm = new MovieMaker(this, width, height, "carousel_top.mov", 30, MovieMaker.H263, MovieMaker.HIGH);
  }

  carousel = new SegmentedCircle(new Vec2D(width*0.5, height*0.5));
}

void draw() {
  background(BACKGROUND_COLOR);
  
  carousel.run();
  carousel.draw(gfx, debug);

  if (makingMovie) {
    mm.addFrame();
  }
}


/**
 * Toggle the debug display by hitting the spacebar.
 */
void keyPressed() {
  if (key == ' ') debug = ! debug;
  
  // Finish the movie if the Escape key is pressed.
  if (key == ESC) {
    if (makingMovie) {
      mm.finish();
    }
    exit();
  }
}
