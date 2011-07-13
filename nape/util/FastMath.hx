package nape.util;
import flash.utils.ByteArray;
import nape.Const;





#if flash10
	import flash.Memory;
	
#else
	import nape.Config;
	
#end




class FastMath 
{
	
	public static inline function init():Void {
		#if flash10
			var b = new ByteArray();
			b.length = 1024;
			Memory.select(b);
		#end
	}
	
	
	
	
	public static inline function sqrt(x:Float):Float {
		#if flash10
			Memory.setFloat(0, x);
			Memory.setI32(0, 0x1fbb4000 + (Memory.getI32(0) >> 1));
			var x2 = Memory.getFloat(0);
			return 0.5 * (x2 + x / x2);
		#else
			return Math.sqrt(x);
		#end
	}
	
	
	public static inline function invsqrt(x:Float):Float {
		#if flash10
			Memory.setFloat(0, x);
			Memory.setI32(0, 0x5f3759df - (Memory.getI32(0) >> 1));
			var x2 = Memory.getFloat(0);
			return x2 * (1.5 - 0.5 * x * x2 * x2);
		#else
			return if(x<Const.EPSILON) Const.FMAX else 1.0/sqrt(x);
		#end
	}
}
