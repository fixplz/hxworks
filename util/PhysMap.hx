package util;

import nape.geom.AABB;
import nape.geom.Geom;
import nape.geom.GeomPoly;
import nape.geom.GeomVert;
import nape.geom.Vec2;
import phx.Body;
import phx.Polygon;
import phx.Vector;
import phx.World;

class PhysMap 
{
  var size:Int;
  
  var map:Array<Array<TerrainTile>>;
  
  var world:World;
  var f:Dynamic;
  
  public function new(w,h,s, world,f) {
    size = s;
    map = [];
    
    this.world = world;
    this.f = f;
    
    for(c in 0 ... cast w/size+1) map[c] = [];
    
    for(x in 0 ... cast w/size+1)
    for(y in 0 ... cast h/size+1) {
      var px = x*size, py = y*size;
      map[x][y] = new TerrainTile(new AABB(px-1,py-1, px+size,py+size));
      
      map[x][y].rebuild(world,f);
    }
  }
  
  public function rebuild(area:AABB) {
    for(x in cast(area.minx/size) ... cast area.maxx/size+1)
    for(y in cast(area.miny/size) ... cast area.maxy/size+1) {
      map[x][y].rebuild(world,f);
    }
  }
}

class TerrainTile {
  var shards:Array<Polygon>;
  var box:AABB;
  
  public function new(b) {
    box = b;
  }
  
  public function rebuild(w:World, map:Float->Float->Float) {
    if(shards!=null) for(s in shards) w.removeStaticShape(s);
    shards = [];
    
    var shards = shards;
    
    var geom = Geom.marchingSquares(box, 5,5, map, 2);
    
    iter(geom, function(g:GeomPoly) {
      var sgeom = { g.simplify(300,2); g.decompose(); }
      
      iter(sgeom, function(sg:GeomPoly) {
        var vs = [];
        iter(sg.points, function(v:GeomVert) vs.push(new Vector(v.p.px,v.p.py)));
        vs.reverse();
        
        var s = new Polygon(vs, new Vector(0,0));
        w.addStaticShape(s);
        shards.push(s);
      });
    });
  }
  
  inline static function iter<T>(x:Dynamic,f:T->Void) {
    var n = untyped x.begin();
    while(n != untyped x.end()) {
      f(n.elem());
      n = untyped n.next;
    }
  }
}
