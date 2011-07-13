package nape.util;








class Array2<T> implements haxe.rtti.Generic {
	
	
	public var data:Array<T>;
	
	
	public var width:Int;
	
	public var height:Int;
	
	
	
	
	public function new(width:Int,height:Int) {
		#if flash
			data = untyped __new__(Array, width*height);
		#else
			data   = new Array<T>();
		#end
		
		this.width  = width;
		this.height = height;
	}
	
	
	
	
	public inline function index(x:Int,y:Int) return x*height+y
	
	
	
	
	public inline function get(x:Int,y:Int) return data[index(x,y)]
	
	public inline function set(x:Int,y:Int,obj:T)    data[index(x,y)] = obj
	
	
	
	
	public function shift_resize(nwidth:Int, nheight:Int, ?dx:Int=0, ?dy:Int=0) {
		var ndata = 
		#if flash
			untyped __new__(Array, nwidth*nheight);
		#else
			new Array<T>();
		#end
		
		var x0 = -dx;       if(x0<0) x0 = 0; if(x0>=nwidth)  x0 = nwidth;
		var y0 = -dy;       if(y0<0) y0 = 0; if(y0>=nheight) y0 = nheight;
		var x1 = width -dx; if(x1<0) x1 = 0; if(x1>=nwidth)  x1 = nwidth;
		var y1 = height-dy; if(y1<0) y1 = 0; if(y1>=nheight) y1 = nheight;
		
		for(y in y0...y1) {
			for(x in x0...x1)
				ndata[x*nheight+y] = data[index(x+dx,y+dy)];
		}
		
		data   = ndata;
		width  = nwidth;
		height = nheight;
	}
}
