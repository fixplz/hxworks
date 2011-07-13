package nape.geom;
import nape.geom.VecMath;












class AABB {
	
	
	 public var minx:Float; public var miny:Float     ;
	
	 public var maxx:Float; public var maxy:Float     ;
	
	
	
	
	public function new (?min_x:Float=0, ?min_y:Float=0, ?max_x:Float=0, ?max_y:Float=0):Void {
		 { minx = min_x; miny = min_y; } ;
		 { maxx = max_x; maxy = max_y; } ;
	}
	
	
	
	
	public inline function width ():Float return maxx - minx
	
	public inline function height():Float return maxy - miny
	
	
	
	
	public inline function setExtents (centre:Vec2, half_dimensions:Vec2):Void {
		 { minx = centre.px-half_dimensions.px; miny = centre.py-half_dimensions.py;  } ;
		 { maxx = centre.px+half_dimensions.px; maxy = centre.py+half_dimensions.py;  } ;
	}
	
	public inline function setExtents2(centre:Vec2, half_width:Float, half_height:Float):Void {
		minx = centre.px-half_width;
		miny = centre.py-half_height;
		maxx = centre.px+half_width;
		maxy = centre.py+half_height;
	}
	
	public inline function setRange(min:Vec2, max:Vec2):Void {
		 { this.minx = min.px; this.miny = min.py; } ;
		 { this.maxx = max.px; this.maxy = max.py; } ;
	}
	
	
	
	public inline function combine(x:AABB) {
		if(x.minx<minx) minx = x.minx;
		if(x.maxx>maxx) maxx = x.maxx;
		if(x.miny<miny) miny = x.miny;
		if(x.maxy>maxy) maxy = x.maxy;
	}
	
	
	
	
	public inline function intersectH(x:AABB):Bool
		return !(x.minx > maxx || minx > x.maxx)
	
	
	public inline function intersect (x:AABB):Bool
		return !(x.miny > maxy || miny > x.maxy || x.minx > maxx || minx > x.maxx)
		
	
	public inline function contains  (pos:Vec2):Bool
		return !(pos.py < miny || pos.py > maxy || pos.px < minx || pos.px > maxx)

	
	public inline function contains2 (x:Float,y:Float):Bool
		return !(y < miny || y > maxy || x < minx || x > maxx)
	
}
