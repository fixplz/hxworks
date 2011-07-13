
package util;

import flash.Vector;

class DiffMap 
{
  public static inline var void = -100;
  
  public var width:Int;
  public var height:Int;
  
  public var map:Vector<Vector<Float>>;
  
  var out:Vector<Vector<Float>>;
  
  public function new(w,h) {
    width = w; height = h;
    
    map = cons(w,h);
    out = cons(w,h);
  }
  
  function cons(w,h) {
    var arr = new Vector(w + 2, true);
    
    for (i in 0 ... w + 2)
      arr[i] = new Vector<Float>(h + 2, true);
    
    for(i in 0 ... w+2) arr[i][0]   = void;
    for(i in 0 ... w+2) arr[i][h+1] = void;
    for(i in 0 ... h+2) arr[0][i]   = void;
    for(i in 0 ... h+2) arr[w+1][i] = void;
    
    return arr;
  }
  
  public function step() {
    for (x in 1 ... width + 1)
    for (y in 1 ... height + 1) {
      var v = map[x][y];
      if(v==void) { out[x][y]=v; continue; }
      
      var v2 = 0., z;
      
      z=map[x+1][y]; if(z > void) v2 += z-v;
      z=map[x-1][y]; if(z > void) v2 += z-v;
      z=map[x][y+1]; if(z > void) v2 += z-v;
      z=map[x][y-1]; if(z > void) v2 += z-v;
      
      var av = v>0 ? .2*v:-.2*v;
      v2 = v2>0 ? v2>av ? v2 : av : v2>-av ? v2 : -av;
      
      z = v + .4 * v2;
      
      out[x][y] = z*.9;
    }
    
    var t = map;
    map = out; out = t;
  }
  
  public function get(x,y) {
    return try { map[x+1][y+1]; } catch (e:Dynamic) 0.;
  }
  public function set(x,y, v) {
    x++; y++;
    if(x>0 && x<width && y>0 && y<height)
      map[x][y] = v;
  }
  
  public function getSlope(x,y) {
    x++; y++;
    
    try {
      var x1 = map[x+1][y];
      var x2 = map[x-1][y];
      var dx = adj2(x1) - adj2(x2);
      //var dx = (x1>0 ? adj2(x1) : map[x][y]) - (x2>0 ? adj2(x2) : map[x][y]);
      var y1 = map[x][y+1];
      var y2 = map[x][y-1];
      var dy = adj2(y1) - adj2(y2);
      //var dy = (y1>0 ? adj2(y1) : map[x][y]) - (y2>0 ? adj2(y2) : map[x][y]);
      
      if(x1==void && dx<0) dx=0;
      if(x2==void && dx>0) dx=0;
      if(y1==void && dy<0) dy=0;
      if(y2==void && dy>0) dy=0;
      
      return new Vec(dx,dy);
    }
    catch (e:Dynamic) return new Vec(0,0);
  }
  
  inline function adj2(x:Float):Float {
    return x>0 ? Math.sqrt(x) : x; // omg
  }
}
