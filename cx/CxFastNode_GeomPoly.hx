package cx;
import nape.geom.GeomPoly;

//'newfile' define generated imports
import cx.CxFastNode_GeomPoly;

class CxFastNode_GeomPoly {
	public var elt:GeomPoly;
	public var next:CxFastNode_GeomPoly;
	
	public function new() {}
	
	public inline function elem ():GeomPoly return elt
}