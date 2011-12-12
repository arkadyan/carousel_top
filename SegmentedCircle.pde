import toxi.geom.*;
import toxi.processing.*;

class SegmentedCircle extends Mover {
  
  private static final int OUTER_DIAMETER = 200;
  private static final int INNER_DIAMETER = 25;
  private static final color INNER_CIRCLE_FILL = #ffffff;
  
  private static final int NUM_SEGMENTS = 12;
  private static final float SEGMENT_ARC_LENGTH = 2*PI / NUM_SEGMENTS;
  
  private static final float ROTATION_SPEED = 0.01;
  
  private float rotation;
  private color[] colors;
  
  
  public SegmentedCircle(Vec2D pos) {
    position = pos;
    velocity = new Vec2D(0, 0);
    acceleration = new Vec2D(0, 0);
    maxSpeed = 3;
    maxForce = 0.05;
    
    rotation = 0;
    
    colors = new color[NUM_SEGMENTS];
    pick_segment_colors();
  }
  
  
  public void run() {
    spin();
    randomWalk();
    constrainToEdges();
    update();
  }
  
  /**
   * Draw our SegmentedCircle at its current position.
   *
   * @param gfx  A ToxiclibsSupport object to use for drawing.
   * @param debug  Whether on not to draw debugging visuals.
   */
  public void draw(ToxiclibsSupport gfx, boolean debug) {
    pushMatrix();
    translate(position.x, position.y);
    rotate(rotation);
    
    // Draw each of the colored segments.
    for (int i=0; i < NUM_SEGMENTS; i++) {
      noStroke();
      fill( colors[i] );
      arc(0, 0, OUTER_DIAMETER, OUTER_DIAMETER, i*SEGMENT_ARC_LENGTH, i*SEGMENT_ARC_LENGTH+SEGMENT_ARC_LENGTH);
    }
    
    // Draw the inner circle.
    noStroke();
    fill(INNER_CIRCLE_FILL);
    ellipse(0, 0, INNER_DIAMETER, INNER_DIAMETER);
    
    popMatrix();
    
    if (debug) drawDebugVisuals(gfx);
  }
  

  private void pick_segment_colors() {
    for (int i=0; i < NUM_SEGMENTS; i++) {
      colors[i] = color(random(256), random(256), random(256));
    }
  }
  
  private void spin() {
    rotation += ROTATION_SPEED;
  }
  
  private void randomWalk() {
    applyForce(new Vec2D(random(-maxForce, +maxForce), random(-maxForce, +maxForce)));
  }
  
  /**
   * Make all borders wrap-around so we return to the other side of the canvas.
   */
  private void constrainToEdges() {
    if (position.x <= 0.5*OUTER_DIAMETER && velocity.x < 0) velocity.x = 0;
    if (position.y <= 0.5*OUTER_DIAMETER && velocity.y < 0) velocity.y = 0;
    if (position.x >= (width-0.5*OUTER_DIAMETER) && velocity.x > 0) velocity.x = 0;
    if (position.y >= (height-0.5*OUTER_DIAMETER) && velocity.y > 0) velocity.y = 0;
  }
  
  /**
   * Draw extra visuals useful for debugging purposes.
   */
  private void drawDebugVisuals(ToxiclibsSupport gfx) {
    // Draw the circle's velocity
    stroke(#ff00ff);
    strokeWeight(1);
    fill(#ff00ff);
    Arrow.draw(gfx, position, position.add(velocity.scale(100)), 4);
  }
  
}
