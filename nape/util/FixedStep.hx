package nape.util;
import flash.display.Sprite;
import flash.errors.Error;
import flash.events.Event;
import flash.Lib;












class FixedStep extends Sprite {
	
	private var physicst:Int; 
	
	private var stepSize:Int; 
	private var maxStep :Int; 
	private var timer   :haxe.Timer;
	
	private var interp:Float; 
	inline function interpolate() return interp
	
	function new(step_size_ms:Int, max_step_count:Int) {
		super();
		
		stepSize = step_size_ms;
		maxStep  = max_step_count;
		
		if (stage!=null) init();
		else addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	
	function init(?ev:Event=null) {
		if (ev != null) removeEventListener(Event.ADDED_TO_STAGE, init);
		
		
		timer = new haxe.Timer(stepSize>>1);
		physicst = Lib.getTimer();
		timer.run = enterframe;
	}
	
	
	function enterframe() {
		var ct = Lib.getTimer();
		var dt = ct - physicst;
		
		var cnt = 0;
		while (dt >= stepSize && cnt++ < maxStep) {
			physicst += stepSize;
			dt -= stepSize;
			
			step(stepSize*0.001);
		}
		
		interp = (dt%stepSize) / stepSize;
		
		
		physicst += dt - (dt % stepSize);
		
		stage.invalidate();
	}
	
	
	function step(dt:Float):Void {
		throw(new Error("Method step should be overriden!"));
	}
}
