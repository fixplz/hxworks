import phx.Body;
import phx.Shape;
import phx.Vector;

class PhysTools 
{
  public static function getCts(b:Body) {
    var arr = [];
    for(a in b.arbiters) if(a.contacts!=null) {
      var order = a.s1.body==b;
      
      var n = new Vector(a.contacts.nx, a.contacts.ny);
      
      arr.push(order ? { b:a.s2.body, n:n } : { b:a.s1.body, n:n.mult(-1) });
    }
    
    return arr;
  }
  
  public static function bodyWith(s:Shape) {
    var b = new Body(0,0);
    b.addShape(s);
    return b;
  }
  
  public static function group(b:Body,group) {
    for(s in b.shapes) s.groups = group;
    return b;
  }
}