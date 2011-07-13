package cx;

import nape.geom.GeomPoly;

//'newfile' define generated imports
import cx.CxFastNode_GeomPoly;
import cx.CxFastList_GeomPoly;

class CxFastList_GeomPoly {
	
	private var head:CxFastNode_GeomPoly;
	private var alloc:Allocator;
	
	
	
	public function new(?a:Allocator) {
		alloc = if(a==null) Allocator.GLOBAL else a;
	}
	
	
	
	
	public inline function add(o:GeomPoly) {
		var temp =  {
		var ret = alloc.CxAlloc_CxFastNode_GeomPoly();
		ret.elt = o;
		ret;
	};
		temp.next = begin();
		 head=temp;
	}
	public inline function addAll(list:CxFastList_GeomPoly) {
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
		 head=ret.next;
		 {};
		 alloc.CxFree_CxFastNode_GeomPoly(ret);
	}
	public inline function remove(obj:GeomPoly):Bool {
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
	public inline function erase(pre:CxFastNode_GeomPoly,cur:CxFastNode_GeomPoly):CxFastNode_GeomPoly {
		var old = cur; cur = cur.next;
		if(pre==null)  head=cur;
		else          pre.next = cur;
		 {};
		 alloc.CxFree_CxFastNode_GeomPoly(old);
		return cur;
	}
	public inline function splice(pre:CxFastNode_GeomPoly,cur:CxFastNode_GeomPoly,n:Int):CxFastNode_GeomPoly {
		while(n-->0 && cur!=end())
			cur = erase(pre,cur);
		return cur;
	}
	public inline function clear() {
		if(true) {
			while(!empty()) {
				var old = begin();
				 head=old.next;
				 {};
				 alloc.CxFree_CxFastNode_GeomPoly(old);
			}
		}else  head=end();
	}
	public inline function reverse() {
		if(!empty()) {
			var ui = begin().next;
			begin().next = end();
			while(ui!=end()) {
				var next = ui.next;
				ui.next = begin();
				 head=ui;
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
	public inline function has(obj:GeomPoly) return  ({
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
	
	public inline function insert(cur:CxFastNode_GeomPoly,o:GeomPoly) {
		if(cur==null) { add(o); return begin(); }
		else {
			var temp =  {
		var ret = alloc.CxAlloc_CxFastNode_GeomPoly();
		ret.elt = o;
		ret;
	};
			temp.next = cur.next;
			cur.next = temp;
			return temp;
		}
	}
	
	public inline function free(o:GeomPoly) {}

	
	
	
	public inline function begin() return head
	public inline function end  () return null
	
	
	
	
	
}