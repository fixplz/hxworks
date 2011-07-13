package nape.util;









class IdRef {
	
	public static inline function _pair(lower:Int,upper:Int) return (lower<<16)|upper
	
	
	public static inline function  pair(a:Int,b:Int):Int {
		return if(a<b) _pair(a,b) else _pair(b,a);
	}
	
	
	
	
	public static inline function fst(id:Int):Int return id>>>16
	
	
	public static inline function snd(id:Int):Int return id&0xffff
	
	
	
	public static inline function contains(pairid:Int,id:Int):Bool return fst(pairid)==id || snd(pairid)==id
}
