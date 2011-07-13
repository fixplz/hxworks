package nape.geom;
import cx.MixList;
import cx.Algorithm;
import nape.geom.VecMath;













class Axis {
	
	
	 public var nx:Float; public var ny:Float     ;
	
	public var d:Float;
	
	
	 
	public var next:Axis;
	
	
	
	
	public inline function add(o:Axis) {
		var temp = _new(o);
		temp.next = begin();
		_setbeg(temp);
	}
	public inline function addAll(list: Axis) {
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
	public inline function remove(obj:Axis):Bool {
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
	public inline function erase(pre:Axis,cur:Axis):Axis {
		var old = cur; cur = cur.next;
		if(pre==null) _setbeg   (cur);
		else          pre.next = cur;
		_delelt(old.elem());
		_delete(old);
		return cur;
	}
	public inline function splice(pre:Axis,cur:Axis,n:Int):Axis {
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
	public inline function has(obj:Axis) return  ({
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
	
	public inline function insert(cur:Axis,o:Axis) {
		if(cur==null) { add(o); return begin(); }
		else {
			var temp = _new(o);
			temp.next = cur.next;
			cur.next = temp;
			return temp;
		}
	}
	
	public inline function free(o:Axis) {}

	
	
	
	public inline function begin():Axis return next
	public inline function end  ():Axis return null
	
	
	public inline function _setbeg(ite:Axis) next = ite
	public inline function _new   (obj:Axis):Axis  return obj
	public inline function _delete(ite:Axis)    {}
	public inline function _delelt(obj:Axis)    {}
	public inline function _clear () return false

	public inline function elem():Axis return this

	
	
	
	
	public function new (?Nx:Float=0, ?Ny:Float=0, ?D:Float=0) {  { nx = Nx; ny = Ny; } ; d = D; }
	
	
	
	
	public inline function clone():Axis return new Axis(nx,ny,d)
	
}
