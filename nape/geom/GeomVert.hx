package nape.geom;
import cx.MixList;
import cx.Algorithm;











class GeomVert {
	
	
	public var p:Vec2;
	
	public var strict:Bool;
	
	
	 
	public var next:GeomVert;
	
	
	
	
	public inline function add(o:GeomVert) {
		var temp = _new(o);
		temp.next = begin();
		_setbeg(temp);
	}
	public inline function addAll(list: GeomVert) {
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
	public inline function remove(obj:GeomVert):Bool {
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
	public inline function erase(pre:GeomVert,cur:GeomVert):GeomVert {
		var old = cur; cur = cur.next;
		if(pre==null) _setbeg   (cur);
		else          pre.next = cur;
		_delelt(old.elem());
		_delete(old);
		return cur;
	}
	public inline function splice(pre:GeomVert,cur:GeomVert,n:Int):GeomVert {
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
	public inline function has(obj:GeomVert) return  ({
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
	
	public inline function insert(cur:GeomVert,o:GeomVert) {
		if(cur==null) { add(o); return begin(); }
		else {
			var temp = _new(o);
			temp.next = cur.next;
			cur.next = temp;
			return temp;
		}
	}
	
	public inline function free(o:GeomVert) {}

	
	
	
	public inline function begin():GeomVert return next
	public inline function end  ():GeomVert return null
	
	
	public inline function _setbeg(ite:GeomVert) next = ite
	public inline function _new   (obj:GeomVert):GeomVert  return obj
	public inline function _delete(ite:GeomVert)    {}
	public inline function _delelt(obj:GeomVert)    {}
	public inline function _clear () return false

	public inline function elem():GeomVert return this

	
	
	public function new(?p:Vec2=null, ?str:Bool = false) {
		this.p = p;
		strict = str;
	}
	
	
	public inline function clone() {
		return new GeomVert(p.clone(),strict);
	}
}
