package cx;
import nape.Config;
import nape.Const;
import nape.geom.AABB;
import nape.geom.Axis;
import nape.geom.Geom;
import nape.geom.GeomPoly;
import nape.geom.GeomVert;
import nape.geom.Vec2;
import nape.geom.VecMath;
import nape.util.Array2;
import nape.util.FastMath;
import nape.util.FixedStep;
import nape.util.IdRef;
import cx.Algorithm;
import cx.FastList;
import cx.MixList;
import cx.CxFastNode_GeomPoly;
import cx.CxFastList_GeomPoly;








class Allocator {
	
	static public var GLOBAL:Allocator = new Allocator();
	
	
	
	private var pool_CxFastNode_GeomPoly:CxFastNode_GeomPoly;
  private var pool_Vec2:Vec2;

	
	
	public function new() {}

	
	
	public inline function CxAlloc_CxFastNode_GeomPoly(){
		if(pool_CxFastNode_GeomPoly==null) {
			return new CxFastNode_GeomPoly();
		}
		else {
			var ret = pool_CxFastNode_GeomPoly;
			pool_CxFastNode_GeomPoly = ret.next;
			return ret;
		}
	}public inline function CxAlloc_Vec2(){
		if(pool_Vec2==null) {
			return new Vec2();
		}
		else {
			var ret = pool_Vec2;
			pool_Vec2 = ret.next;
			return ret;
		}
	}
	
	

	public inline function CxFree_CxFastNode_GeomPoly(obj:CxFastNode_GeomPoly) {
		obj.next = pool_CxFastNode_GeomPoly;
		pool_CxFastNode_GeomPoly = obj;
	}
	
	
	
	
}
