package phx;

class Ray 
{
  public var origin:Vector;
  public var dir:Vector;
  
  public var dist:Float;
  public var shape:Shape;
  public var normal:Vector;
  
  public function new(origin,target) {
    this.origin = origin;
    this.dir = target.minus(origin).unit();
    dist = 10000;
  }
  
  public function report(s, dist, n) {
    if(dist<this.dist) {
      this.dist = dist;
      shape = s;
      normal = n;
    }
  }
  
  public function scan(w:World) {
    for(s in w.staticBody.shapes)
      s.intersectRay(this);
    
    for(b in w.bodies)
    for(s in b.shapes)
      s.intersectRay(this);
  }
}