package nape.geom;
import cx.MixList;
import cx.Algorithm;
import nape.geom.VecMath;
import nape.util.FastMath;















class Vec2 {
	
	
	 public var px:Float; public var py:Float     ;
	
	
	 
	public var next:Vec2;
	
	
	
	
	public inline function add(o:Vec2) {
		var temp = _new(o);
		temp.next = begin();
		_setbeg(temp);
	}
	public inline function addAll(list: Vec2) {
		   {
	var cxiterator = list.begin();
	while(cxiterator != list.end()) {
		var i = cxiterator.elem();
		{
			
			add(i);
		}
		cxiterator = cxiterator.next;
	}
};
	}
	public inline function pop():Void {
		var ret = begin();
		_setbeg(ret.next);
		_delelt(ret.elem());
		_delete(ret);
	}
	public inline function remove(obj:Vec2):Bool {
		var pre = null;
		var cur = begin();
		var ret = false;
		while(cur!=end()) {
			if(cur.elem()==obj) {
				cur = erase(pre,cur);
				ret = true;
				break;
			}
			pre = cur;
			cur = cur.next;
		}
		return ret;
	}
	public inline function erase(pre:Vec2,cur:Vec2):Vec2 {
		var old = cur; cur = cur.next;
		if(pre==null) _setbeg   (cur);
		else          pre.next = cur;
		_delelt(old.elem());
		_delete(old);
		return cur;
	}
	public inline function splice(pre:Vec2,cur:Vec2,n:Int):Vec2 {
		while(n-->0 && cur!=end())
			cur = erase(pre,cur);
		return cur;
	}
	public inline function clear() {
		if(_clear()) {
			while(!empty()) {
				var old = begin();
				_setbeg(old.next);
				_delelt(old.elem());
				_delete(old);
			}
		}else _setbeg(end());
	}
	public inline function reverse() {
		if(!empty()) {
			var ui = begin().next;
			begin().next = end();
			while(ui!=end()) {
				var next = ui.next;
				ui.next = begin();
				_setbeg(ui);
				ui = next;
			}
		}
	}
	
	public inline function empty():Bool return begin()==end()
	public inline function size():Int {
		var cnt = 0;
		var cur = begin();
		while(cur!=end()) { cnt++; cur=cur.next; }
		return cnt;
	}
	public inline function has(obj:Vec2) return  ({
	var ret = false;
	  {
	var cxiterator = this.begin();
	while(cxiterator != this.end()) {
		var cxite = cxiterator.elem();
		{
			
			{
		if(cxite==obj) {
			ret = true;
			break;
		}
	};
		}
		cxiterator = cxiterator.next;
	}
};
	ret;
})
	
	public inline function front() return begin().elem()
	
	public inline function back() {
		var ret = begin();
		var cur = ret;
		while(cur!=end()) { ret = cur; cur = cur.next; }
		return ret.elem();
	}
	
	public inline function at(ind:Int) return iterator_at(ind).elem()
	public inline function iterator_at(ind:Int) {
		var ret = begin();
		while(ind-->0) ret = ret.next;
		return ret;
	}
	
	public inline function insert(cur:Vec2,o:Vec2) {
		if(cur==null) { add(o); return begin(); }
		else {
			var temp = _new(o);
			temp.next = cur.next;
			cur.next = temp;
			return temp;
		}
	}
	
	public inline function free(o:Vec2) {}

	
	
	
	public inline function begin():Vec2 return next
	public inline function end  ():Vec2 return null
	
	
	public inline function _setbeg(ite:Vec2) next = ite
	public inline function _new   (obj:Vec2):Vec2  return obj
	public inline function _delete(ite:Vec2)    {}
	public inline function _delelt(obj:Vec2)    {}
	public inline function _clear () return false

	public inline function elem():Vec2 return this

	
	
	
	
	public        function new   (?x:Float=0, ?y:Float=0) {  { px = x;   py = y;   } ; }
	
	public inline function set   (x:Float,     y:Float)   {  { px = x;   py = y;   } ; }
	
	public inline function setvec(v:Vec2)                 {  { px = v.px; py = v.py; } ; }
	
	
	
	
	public inline function clone ():Vec2 return new Vec2(px,py)
	
	
	
	
	public inline function dot   (v:Vec2):Float return  (px*v.px + py*v.py) 
	
	public inline function cross (v:Vec2):Float return  (px*v.py - py*v.px) 
	
	
	
	
	public inline function lsq   ():Float return  (px*px + py*py)   
	
	public inline function length():Float return  FastMath.sqrt( (px*px + py*py)   ) 
	
}
