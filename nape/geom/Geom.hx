package nape.geom;
import cx.MixList;
import cx.Algorithm;
import cx.FastList;
import nape.geom.VecMath;
import nape.geom.GeomPoly;
import nape.util.Array2;
import nape.Const;

//'newfile' define generated imports
import cx.CxFastList_GeomPoly;

















class GeomPolyVal {
	
	public var p:GeomPoly;
	
	public var key:Int;
	
	public function new(P:GeomPoly,K:Int) {
		p = P;
		key = K;
	}
}


class Geom {
	
	
	static public inline function lineSegmentsIntersect(a0:Vec2,a1:Vec2,b0:Vec2,b1:Vec2) {
		   var sx:Float;  var sy:Float      ;  { sx = a0.px-b0.px; sy = a0.py-b0.py;  } ;
		   var vx:Float;  var vy:Float      ;  { vx = a1.px-a0.px; vy = a1.py-a0.py;  } ;
		   var qx:Float;  var qy:Float      ;  { qx = b1.px-b0.px; qy = b1.py-b0.py;  } ;
		
		var den =  (qx*vy - qy*vx) ;
		if(den*den < Const.EPSILON) return false;
		else {
			den = 1.0 / den;
			
			var t =  (sx*qy - sy*qx) *den;
			if(t<Const.EPSILON||t>1-Const.EPSILON) return false;
			else {
				var s =  (sx*vy - sy*vx) *den;
				if(s<Const.EPSILON||s>1-Const.EPSILON) return false;
				else return true;
			}
		}
	}
	
	

	
	static public inline function lerp(x0:Float,x1:Float,v0:Float,v1:Float) {
		var dv = v0-v1;
		var t = if(dv*dv<Const.EPSILON) 0.5 else v0/dv;
		return x0 + t*(x1-x0);
	}
	
	
	
	
	static private function xlerp(x0:Float,x1:Float,y:Float,v0:Float,v1:Float,f:Float->Float->Float,c:Int) {
		var xm = lerp(x0,x1,v0,v1); 
		if(c==0) return xm;
		else {
			var vm = f(xm,y);
			if(v0*vm<0) return xlerp(x0,xm,y,v0,vm,f,c-1);
			else        return xlerp(xm,x1,y,vm,v1,f,c-1);
		}
	}
	
	static private function ylerp(y0:Float,y1:Float,x:Float,v0:Float,v1:Float,f:Float->Float->Float,c:Int) {
		var ym = lerp(y0,y1,v0,v1); 
		if(c==0) return ym;
		else {
			var vm = f(x,ym);
			if(v0*vm<0) return ylerp(y0,ym,x,v0,vm,f,c-1);
			else        return ylerp(ym,y1,x,vm,v1,f,c-1);
		}
	}
	
	
	static inline private function square(x:Float) return x*x
	
	
	
	
	static public function marchingMesh(domain:AABB,cell_width:Float,cell_height:Float,subcell_width:Float,subcell_height:Float,f:Float->Float->Float,?lerp_count:Int=0) {
		var ret = new CxFastList_GeomPoly();
		
		var xn = Std.int(domain.width ()/cell_width);  var xp = xn == (domain.width ()/cell_width);
		var yn = Std.int(domain.height()/cell_height); var yp = yn == (domain.height()/cell_height);
		if(!xp) xn++;
		if(!yp) yn++;
		
		var sdomain = new AABB(0,0,0,0);
		
		for(x in 0...(xn)) {
			sdomain.minx = x*cell_width+domain.minx;
			sdomain.maxx = if(x==xn-1) domain.maxx else sdomain.minx+cell_width;
			for(y in 0...(yn)) {
				sdomain.miny = y*cell_height+domain.miny; 
				sdomain.maxy = if(y==yn-1) domain.maxy else sdomain.miny+cell_height;
				
				var tri = marchingSquares(sdomain,subcell_width,subcell_height,f,lerp_count);
				ret.addAll(tri);
			}
		}
		
		return ret;
	}
	
	
	
	
	static public function marchingSquares(domain:AABB,cell_width:Float,cell_height:Float,f:Float->Float->Float,?lerp_count:Int=0,?combine:Bool=true) {
		var ret = new CxFastList_GeomPoly();
		
		var xn = Std.int(domain.width ()/cell_width); var xp = xn == (domain.width ()/cell_width);
		var yn = Std.int(domain.height()/cell_height); var yp = yn == (domain.height()/cell_height);
		if(!xp) xn++;
		if(!yp) yn++;
		
		var fs = new Array2<Float>(xn+1,yn+1);
		var ps = new Array2<GeomPolyVal>(xn+1,yn+1);
		
		for(x in 0...(xn+1)) {
			var x0 = if(x==xn) domain.maxx else x*cell_width+domain.minx;
			for(y in 0...(yn+1)) {
				var y0 = if(y==yn) domain.maxy else y*cell_height+domain.miny;
				fs.set(x,y,f(x0,y0));
			}
		}
		
		
		for(y in 0...yn) {
			var y0 = y*cell_height+domain.miny; var y1 = if(y==yn-1) domain.maxy else y0+cell_height;
			var pre = null;
			for(x in 0...xn) {
				var x0 = x*cell_width+domain.minx; var x1 = if(x==xn-1) domain.maxx else x0+cell_width;
				
				var p:GeomPoly = new GeomPoly();
				var key = marchSquare(f,fs,p, x,y, x0,y0,x1,y1, lerp_count);
				if(p.length!=0) {
					if(combine && pre!=null && (key&9)!=0) {
						combLeft(pre,p);
						p = pre;
					}else
						ret.add(p);
					ps.set(x,y,new GeomPolyVal(p,key));
				}else
					p = null;
				pre = p;
			}
		}
		if(!combine)
			return ret;

		
		for(y in 1...yn) {
			var x = 0;
			while(x<xn) {
				var p = ps.get(x,y);
				
				
				if(p==null) {x++; continue; }

				
				if((p.key&12)==0) { x++; continue; }
				
				
				var u = ps.get(x,y-1);
				if(u==null) { x++; continue; }
				
				
				if((u.key&3)==0) { x++; continue; }
				
				var ax = x*cell_width +domain.minx;
				var ay = y*cell_height+domain.miny;
				
				var bp = p.p.points;
				var ap = u.p.points;
				
				
				if(u.p == p.p) { x++; continue; }

				
				var bi = bp.begin();
				while(square(bi.elem().p.py-ay)>Const.EPSILON || bi.elem().p.px<ax) bi = bi.next;
				
				var b0 = bi.elem().p;
				var b1 = bi.next.elem().p;
				if(square(b1.py-ay)>Const.EPSILON) { x++; continue; }
				
				var brk = true;
				var ai = ap.begin();
				while(ai!=ap.end()) {
					if( ({
	   var dx:Float;  var dy:Float      ;  { dx = ai.elem().p.px-b1.px; dy = ai.elem().p.py-b1.py;  } ;  (dx*dx + dy*dy)   ;
})<Const.EPSILON) {
						brk = false;
						break;
					}
					ai = ai.next;
				}
				if(brk) { x++; continue; }
				
				var bj = bi.next.next; if(bj==bp.end()) bj = bp.begin();
				while(bj!=bi) {
					ai = ap.insert(ai,bj.elem().clone());
					bj = bj.next; if(bj==bp.end()) bj = bp.begin();
					u.p.length++;
				} 
				u.p.simplify(Const.EPSILON,Const.EPSILON);
				
				var ax = x+1;
				while(ax<xn) {
					var p2 = ps.get(ax,y);
					if(p2==null || p2.p!=p.p) {ax++; continue;}
					p2.p = u.p;
					ax++;
				}
				ax = x-1;
				while(ax>=0) {
					var p2 = ps.get(ax,y);
					if(p2==null || p2.p!=p.p) {ax--;continue;}
					p2.p = u.p;
					ax--;
				}
				ret.remove(p.p);
				p.p = u.p;
				
				x = Std.int((bi.next.elem().p.px-domain.minx)/cell_width)+1;
				
			}
		}
		
		
		  {
	var cxiterator = ret.begin();
	while(cxiterator != ret.end()) {
		var tri = cxiterator.elem();
		{
			
			{
			var ps = tri.points;
			  {
	var cxiterator = ps.begin();
	while(cxiterator != ps.end()) {
		var p = cxiterator.elem();
		{
			
			{
				if(square(p.p.px-domain.minx)<Const.EPSILON
				|| square(p.p.px-domain.maxx)<Const.EPSILON
				|| square(p.p.py-domain.miny)<Const.EPSILON
				|| square(p.p.py-domain.maxy)<Const.EPSILON)
					p.strict = true;
				
				var pit = cxiterator;
				if(pit.next==ps.end()) break;
				
				 {
	var cxiterator = cxiterator.next;
	while(cxiterator != ps.end()) {
		var q = cxiterator.elem();
		{
			
			{
					if( ({
	   var dx:Float;  var dy:Float      ;  { dx = p.p.px-q.p.px; dy = p.p.py-q.p.py;  } ;  (dx*dx + dy*dy)   ;
})<Const.EPSILON) {
						var p2 = pit.next.elem();
						var fnd = false;
						var qi2:GeomVert = null;
						 {
	var cxiterator = pit.next.next;
	while(cxiterator != ps.end()) {
		var q2 = cxiterator.elem();
		{
			
			{
							if( ({
	   var dx:Float;  var dy:Float      ;  { dx = p2.p.px-q2.p.px; dy = p2.p.py-q2.p.py;  } ;  (dx*dx + dy*dy)   ;
})<Const.EPSILON) {
								qi2 = q2;
								fnd = true;
								break;
							}
						};
		}
		cxiterator = cxiterator.next;
	}
};
						if(fnd) {
							p.strict = q.strict = p2.elem().strict = qi2.strict = true;
							cxiterator = cxiterator.next;
						}
					}
				};
		}
		cxiterator = cxiterator.next;
	}
};
			};
		}
		cxiterator = cxiterator.next;
	}
};
		};
		}
		cxiterator = cxiterator.next;
	}
};
		
		return ret;
	}
	
	
	static private var look_march = [0x00,0xE0,0x38,0xD8,0x0E,0xEE,0x36,0xD6,0x83,0x63,0xBB,0x5B,0x8D,0x6D,0xB5,0x55];
	
	static private inline function marchSquare(f:Float->Float->Float, fs:Array2<Float>,poly:GeomPoly,ax:Int,ay:Int,x0:Float,y0:Float,x1:Float,y1:Float, bin:Int) {
		
		var key = 0;
		var v0 = fs.get(ax,  ay);   if(v0<0) key |= 8;
		var v1 = fs.get(ax+1,ay);   if(v1<0) key |= 4;
		var v2 = fs.get(ax+1,ay+1); if(v2<0) key |= 2;
		var v3 = fs.get(ax,  ay+1); if(v3<0) key |= 1;
		
		var val = look_march[key];
		if(val!=0) {
			var pi = null;
			for(i in 0...8) {
				var p;
				if((val&(1<<i)) != 0) {
					if(i==7 && (val&1)==0)
						poly.points.add(p=new GeomVert(new Vec2(x0,ylerp(y0,y1,x0,v0,v3,f,bin))));
					else {
						pi = poly.points.insert(pi,p=new GeomVert(
							if     (i==0) new Vec2(x0,y0)
							else if(i==2) new Vec2(x1,y0)
							else if(i==4) new Vec2(x1,y1)
							else if(i==6) new Vec2(x0,y1)
							
							else if(i==1) new Vec2(xlerp(x0,x1,y0,v0,v1,f,bin),y0)
							else if(i==5) new Vec2(xlerp(x0,x1,y1,v3,v2,f,bin),y1)
							
							else if(i==3) new Vec2(x1,ylerp(y0,y1,x1,v1,v2,f,bin))
							else          new Vec2(x0,ylerp(y0,y1,x0,v0,v3,f,bin))
						));
					}
					poly.length++;
				}
			}
			poly.simplify(Const.EPSILON,Const.EPSILON);
		}
		return key;
	}
	
	
	static private function combLeft(polya:GeomPoly,polyb:GeomPoly) {
		var ap = polya.points;
		var bp = polyb.points;
		var ai = ap.begin();
		var bi = bp.begin();
		
		var b = bi.elem();
		var prea: GeomVert = null;
		while(ai!=ap.end()) {
			var a = ai.elem();
			if( ({
	   var dx:Float;  var dy:Float      ;  { dx = a.p.px-b.p.px; dy = a.p.py-b.p.py;  } ;  (dx*dx + dy*dy)   ;
})<Const.EPSILON) {
				
				if(prea!=null) {
					var a0 = prea.elem();
					b = bi.next.elem();
					   var ux:Float;  var uy:Float      ;  { ux = a.p.px-a0.p.px; uy = a.p.py-a0.p.py;  } ;
					   var vx:Float;  var vy:Float      ;  { vx = b.p.px-a.p.px; vy = b.p.py-a.p.py;  } ;
					var dot =  (ux*vy - uy*vx) ;
					if(dot*dot<Const.EPSILON) {
						ap.erase(prea,ai);
						polya.length--;
						ai = prea;
					}
				}
				
				
				var fst = true;
				var preb = null;
				while(!bp.empty()) {
					var b = bp.front();
					bp.pop();
					if(!fst && !bp.empty()) {
						ai = ap.insert(ai,b);
						polya.length++;
						preb = ai;
					}
					fst = false;
				}
				
				
				ai = ai.next;
				var a1 = ai.elem().p;
				ai = ai.next; if(ai==ap.end()) ai = ap.begin();
				var a2 = ai.elem().p;
				var a0 = preb.elem().p;
				   var ux:Float;  var uy:Float      ;  { ux = a1.px-a0.px; uy = a1.py-a0.py;  } ;
				   var vx:Float;  var vy:Float      ;  { vx = a2.px-a1.px; vy = a2.py-a1.py;  } ;
				var dot =  (ux*vy - uy*vx) ;
				if(dot*dot<Const.EPSILON) {
					ap.erase(preb,preb.next);
					polya.length--;
				}
				
				return;
			}
			prea = ai;
			ai = ai.next;
		}
	}
}

