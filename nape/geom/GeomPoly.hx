package nape.geom;
import cx.MixList;
import cx.FastList;
import cx.Algorithm;
import nape.geom.VecMath;
import nape.geom.GeomVert;
import nape.Const;
import nape.util.FastMath;

//'newfile' define generated imports
import cx.CxFastList_GeomPoly;

















class GeomPoly {
	
	
	public var points: GeomVert;
	
	public var length:Int;

	
	
	
	public var degenerate_edge  :Bool;
	
	public var degenerate       :Bool;
	
	public var ccw_winding      :Bool;
	
	public var concave          :Bool;
	
	public var self_intersecting:Bool;
	
	
	public function verify() {
		degenerate_edge = degenerateEdges();
		var val = area(); ccw_winding = val<0;
		if(val*val<Const.EPSILON) degenerate = true;
		concave = !convex();
		self_intersecting = selfIntersecting();
		
		return !( degenerate_edge
		       || degenerate
			   || ccw_winding
			   || concave
			   || self_intersecting );
	}
	
	
	public function toString() {
		var ret = "";
		if(degenerate_edge)   ret += "Degenerate edge. ";
		if(ccw_winding)       ret += "CCW winding. ";
		if(self_intersecting) ret += "Self-intersecting. ";
		else if(concave)      ret += "Concave. ";
		else if(degenerate)   ret += "Degenerate. ";
		
		if(ret=="") ret = "Okay/Not-Verified";
		
		return ret;
	}
	
	
	
	
	public function new(?vertices:Array<Vec2>=null) {
		var vl = vertices;
		points = new  GeomVert();
		if(vl==null) length = 0;
		else {
			length = vl.length;
			for(i in 0...length) points.add(new GeomVert(vl[length-1-i].clone(),false));
		}
	}
	
	

	
	public function area() {
		var ret = 0.0;
		var beg = points.begin();
		var end = points.end();
		var ui = beg;
		while(ui!=end) {
			var next = ui.next;
			var vi = if(next   ==end) beg else next;
			var wi = if(vi.next==end) beg else vi.next;
			
			var u = ui.elem().p;
			var v = vi.elem().p;
			var w = wi.elem().p;
			
			ret += v.px*(w.py-u.py);
			
			ui = next;
		}
		
		return ret*0.5;
	}
	
	
	
	
	public inline function cw() return area() > 0
	
	
	
	
	public function convex() {
		var neg = false;
		var pos = false;
		
		var beg = points.begin();
		var end = points.end();
		var ui = beg;
		while(ui!=end) {
			var next = ui.next;
			var vi = if(next   ==end) beg else next;
			var wi = if(vi.next==end) beg else vi.next;
			
			var u = ui.elem().p;
			var v = vi.elem().p;
			var w = wi.elem().p;
			
			   var ax:Float;  var ay:Float      ;  { ax = w.px-v.px; ay = w.py-v.py;  } ;
			   var bx:Float;  var by:Float      ;  { bx = v.px-u.px; by = v.py-u.py;  } ;
			var dot =  (ax*by - ay*bx) ;
			
			if(dot> Const.EPSILON) pos = true;
			if(dot<-Const.EPSILON) neg = true;
			
			if(pos&&neg) return false;
			
			ui = next;
		}
		
		return true;
	}
	
	
	
	
	public function degenerateEdges() {
		var beg = points.begin();
		var end = points.end();
		var ui = beg;
		while(ui!=end) {
			var next = ui.next;
			var vi = if(next==end) beg else next;
			
			var u = ui.elem().p;
			var v = vi.elem().p;
			
			   var dx:Float;  var dy:Float      ;  { dx = v.px-u.px; dy = v.py-u.py;  } ;
			if( (dx*dx + dy*dy)    < Const.EPSILON) return true;
			
			ui = next;
		}
		
		return false;
	}
	
	
	
	
	public function selfIntersecting() {
		var beg = points.begin();
		var end = points.end();
		var ui = beg;
		while(ui!=end) {
			var next = ui.next;
			var vi = if(next==end) beg else next;
			
			var u = ui.elem().p;
			var v = vi.elem().p;
			
			var ai = beg;
			while(ai!=end) {
				var nexta = ai.next;
				var bi = if(nexta==end) beg else nexta;
				
				if(!(ai==ui||ai==vi||bi==ui||bi==vi)) {
					var a = ai.elem().p;
					var b = bi.elem().p;
					
					if(Geom.lineSegmentsIntersect(u,v,a,b))
						return true;
				}
				
				ai = nexta;
			}
			
			ui = next;
		}
		
		return false;
	}
	
	
	
	
	public inline function contains(x:Float,y:Float) {
		var odd = false;
		
		var beg = points.begin();
		var end = points.end();
		var ui = beg;
		while(ui!=end) {
			var next = ui.next;
			var vi = if(next==end) beg else next;
			
			var u = ui.elem().p;
			var v = vi.elem().p;
			
			   var dx:Float;  var dy:Float      ;  { dx = v.px-u.px; dy = v.py-u.py;  } ;
			   var cx:Float;  var cy:Float      ;  { cx = x-u.px; cy = y-u.py;  } ;
			var dot =  (dx*cy - dy*cx) ;
			if(dot*dot<Const.EPSILON) {
				dot =  (dx*cx + dy*cy) ;
				if(dot>Const.EPSILON && dot< FastMath.sqrt( (dx*dx + dy*dy)   ) -Const.EPSILON) {
					odd = true;
					break;
				}
			}
			
			if ((v.py<y && u.py>=y)
			 || (u.py<y && v.py>=y)) {
				 if(v.px + (y-v.py)/(u.py-v.py)*(u.px-v.px) < x)
					odd = !odd;
			}
			
			ui = next;
		}
		
		return odd;
	}
	
	
	
	
	public function simplify(?angle_threshold:Float=400,?distance_threshold:Float=10) {
		if(length<=3) return;
		
		var cont = true;
		while(cont && length>3) {
			cont = false;
			
			var beg = points.begin();
			var end = points.end();
			var ui = beg;
			var pi = null;
			while(ui!=end) {
				var next = ui.next;
				
				var vi = if(next   ==end) beg else next;
				var wi = if(vi.next==end) beg else vi.next;
				
				var u = ui.elem().p;
				var v = vi.elem().p;
				var w = wi.elem().p;
				
				   var dx:Float;  var dy:Float      ;  { dx = v.px-u.px; dy = v.py-u.py;  } ;
				if(!ui.elem().strict &&  (dx*dx + dy*dy)   <distance_threshold) {
					points.erase(pi,ui);
					length--;
					cont = true;
					break;
				}
				
				   var sx:Float;  var sy:Float      ;  { sx = v.px-w.px; sy = v.py-w.py;  } ;
				var dot =  (sx*dy - sy*dx) ;
				if(!vi.elem().strict && dot*dot < angle_threshold) {
					if(vi==beg) points.erase(null,vi);
					else        points.erase(ui,  vi);
					length--;
					cont = true;
					break;
				}
				
				pi = ui;
				ui = next;
			}
		}
	}
	
	
	
	
	public function diagonal(p0: GeomVert,p1: GeomVert) {
		var beg = points.begin();
		var end = points.end();
		
		if (p0==p1
		|| (if(p0.next==end) beg; else p0.next) == p1
		|| (if(p1.next==end) beg; else p1.next) == p0)
			return false;
			
		var v0 = p0.elem();
		var v1 = p1.elem();
		   var vx:Float;  var vy:Float      ;  { vx = v1.p.px-v0.p.px; vy = v1.p.py-v0.p.py;  } ;
		
		if(!contains(v0.p.px+vx*0.02,v0.p.py+vy*0.02)) return false;
		if(!contains(v0.p.px+vx*0.04,v0.p.py+vy*0.04)) return false;
		
		var ui = beg;
		while(ui!=end) {
			var next = ui.next;
			var vi = if(next==end) beg else next;
			
			if(!(ui==p0||ui==p1||vi==p0||vi==p1)) {
				var u = ui.elem();
				var v = vi.elem();
				
				if(Geom.lineSegmentsIntersect(v0.p,v1.p,u.p,v.p))
					return false;
			}
			
			ui = next;
		}
		
		return true;
	}
	
	
	
	
	public inline function notch(pi: GeomVert,ui: GeomVert) {
		var vi = if(ui.next==points.end()) points.begin(); else ui.next;
		
		var u = pi.elem().p;
		var v = ui.elem().p;
		var w = vi.elem().p;
		
		   var ax:Float;  var ay:Float      ;  { ax = w.px-v.px; ay = w.py-v.py;  } ;
		   var bx:Float;  var by:Float      ;  { bx = u.px-v.px; by = u.py-v.py;  } ;
		
		return  (ax*by - ay*bx)  < 0;
	}
	
	
	
	
	public inline function clone() {
		var ret = new GeomPoly(); ret.length = length;
		var rp = ret.points;
		var ri = null;
		  {
	var cxiterator = points.begin();
	while(cxiterator != points.end()) {
		var p = cxiterator.elem();
		{
			
			ri=rp.insert(ri,p.clone());
		}
		cxiterator = cxiterator.next;
	}
};
		return ret;
	}
	
	

	
	public function count() {
		var beg = points.begin();
		var end = points.end();
		var ui = beg;
		var sum = 0.0;
		
		while(ui!=end) {
			var next = ui.next;
			var vi = if(next   ==end) beg else next;
			var wi = if(vi.next==end) beg else vi.next;
			
			var u = ui.elem().p;
			var v = vi.elem().p;
			var w = wi.elem().p;
			
			   var ax:Float;  var ay:Float      ;  { ax = w.px-v.px; ay = w.py-v.py;  } ;
			   var bx:Float;  var by:Float      ;  { bx = v.px-u.px; by = v.py-u.py;  } ;
			var sc = FastMath.invsqrt( (ax*ax + ay*ay)   * (bx*bx + by*by)   );
			var dot =  (ax*bx + ay*by) *sc;
			dot = 2-dot;
			sum += dot*dot;
			
			ui = next;
		}
		
		return sum;
	}
	
	
	public function convexEar(ret:CxFastList_GeomPoly) {
		
		while(true) {
			if(length==3) {
				ret.add(this);
				return;
			}
			
			var cancel = true;
			var pi = null;
			  {
	var cxiterator = points.begin();
	while(cxiterator != points.end()) {
		var u = cxiterator.elem();
		{
			
			{
				if(pi!=null) {
					var notche = notch(pi,cxiterator);
					if(notche) cancel = false;
				}
				pi = cxiterator;
			};
		}
		cxiterator = cxiterator.next;
	}
};
			{
				var notche = notch(pi,points.begin());
				if(notche) cancel = false;
			}
			if(cancel) {
				ret.add(this);
				return;
			}
			
			var polymin:GeomPoly = null;
			var imin: GeomVert = null;
			var imin_ind:Int = 0;
			var lmax = Const.FMAX;
			
			var beg = points.begin();
			var end = points.end();
			var ui = beg; var u_ind = 0;
			while(ui!=end) {
				var next = ui.next;
				
				var ni =  if(next   ==end) beg else next;
				var ni2 = if(ni.next==end) beg else ni.next;
				
				if(!diagonal(ui,ni2)) {
					ui = next;
					u_ind++;
					continue;
				}
				
				
				var poly = new GeomPoly(); poly.length = 3;
				poly.points.add(ni2.elem().clone());
				poly.points.add(ni.elem().clone());
				poly.points.add(ui.elem().clone());
				var pi = null;
				while(true) {
					if(ni2==ui) break;
					ni2 = ni2.next; if(ni2==end) ni2 = beg;
					if(diagonal(ui,ni2)) {
						var pri = pi;
						pi = poly.points.insert(pi,ni2.elem().clone());
						
						if(!poly.convex()) {
							poly.points.erase(pri,pi);
							pi = pri;
							
							break;
						}else
							poly.length++;
					}else break;
				}
				
				var npoly = clone();
				
				var ni3 = poly.length-2;
				var nui = npoly.points.iterator_at(u_ind);
				npoly.length -= ni3;
				var nvi = nui.next;
				while(ni3-->0) {
					if(nvi==npoly.points.end()) {
						nvi = npoly.points.begin();
						nui = null;
					}
					nvi = npoly.points.erase(nui,nvi);
				}
				
				var ap = poly.count()+npoly.count();
				
				
				if(ap < lmax) {
					lmax = ap;
					imin = ui;
					imin_ind = u_ind;
					polymin = poly;
				}
				
				ui = next;
				u_ind++;
			}
			if(polymin == null)
				break;
			
			
			ret.add(polymin);
			
			var ni2 = polymin.length-2;
			var ui = points.iterator_at(imin_ind);
			var vi = ui.next;
			length -= ni2;
			while(ni2-->0) {
				if(vi==points.end()) { vi = points.begin(); ui = null; }
				vi = points.erase(ui,vi);
			}
		}
		
		return;
	}
	
	
	
	
	public function decompose() {
		var ret  = new CxFastList_GeomPoly();
		var proc = new CxFastList_GeomPoly();
		proc.add(this);
		
		while(!proc.empty()) {
			var p = proc.front();
			if(p.convex()) ret.add(p);
			else
				p.convexEar(proc);
			proc.pop();
		}
		
		return ret;
	}
}
