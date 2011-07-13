
package phx.joint;


import phx.Body;
import phx.Vector;


using VecExts;

class DistanceJoint
	extends Joint
{
	public var anchordist : Float;
	
	var r1 : Vector;
	var r2 : Vector;
	var n  : Vector;
	
	var nMass : Float;
	var bias  : Float;
	var jnAcc : Float;
	
	public function new (b1,b2, anchor1 : Vector, anchor2 : Vector)
	{
		super (b1,b2,
			anchor1.minus (b1.getPos ()),
			anchor2.minus (b2.getPos ()));
		anchordist = anchor1.minus (anchor2).length ();
		jnAcc = 0;
	}
	
	override function preStep (invDt : Float)
	{
		r1 = b1.rotate (anchr1);
		r2 = b2.rotate (anchr2);
		
		var d =   b1.getPos ().plus (r1)
		  .minus (b2.getPos ().plus (r2));
		var dist = d.length ();
		
		n = if (dist == 0) new Vector (0,0) else d.mult (1/dist);
		
		var r1cn = r1.x * n.y - r1.y * n.x;
		var r2cn = r2.x * n.y - r2.y * n.x;
		nMass = 1 / (b1.invMass+b2.invMass
			+ (b1.invInertia * r1cn * r1cn) + (b2.invInertia * r2cn * r2cn));
		
		bias = invDt * (dist - anchordist) * 0.2;
			//Math.max (b1.properties.biasCoef,b2.properties.biasCoef);
		
		bodyImpulse (n.mult (-jnAcc));
	}
	
	override function applyImpuse ()
	{
		var vbn =
			((-r2.y * b2.w_bias + b2.v_bias.x) - (-r1.y * b1.w_bias + b1.v_bias.x)) * n.x +
			(( r2.x * b2.w_bias + b2.v_bias.y) - ( r1.x * b1.w_bias + b1.v_bias.y)) * n.y;
		
		var vrn =
			((-r2.y * b2.w + b2.v.x) - (-r1.y * b1.w + b1.v.x)) * n.x +
			(( r2.x * b2.w + b2.v.y) - ( r1.x * b1.w + b1.v.y)) * n.y;
		                             
		var jb = nMass * (vbn - bias), jn = nMass * vrn;
		jnAcc += jn;
		
		bodyBias    (n.mult (-jb));
		bodyImpulse (n.mult (-jn));
	}
	
	inline function bodyBias (j : Vector)
	{
		b1.v_bias.x -= j.x * b1.invMass;
		b1.v_bias.y -= j.y * b1.invMass; 
		b1.w_bias   -= b1.invInertia * (r1.x * j.y - r1.y * j.x);
		b2.v_bias.x += j.x * b2.invMass;
		b2.v_bias.y += j.y * b2.invMass;
		b2.w_bias   += b2.invInertia * (r2.x * j.y - r2.y * j.x);
	}

	
	inline function bodyImpulse (j : Vector)
	{
		b1.v.x -= j.x * b1.invMass;
		b1.v.y -= j.y * b1.invMass;
		b1.w   -= b1.invInertia * (r1.x * j.y - r1.y * j.x);
		b2.v.x += j.x * b2.invMass;
		b2.v.y += j.y * b2.invMass;
		b2.w   += b2.invInertia * (r2.x * j.y - r2.y * j.x);
	}            

}
