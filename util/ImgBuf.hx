package util;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.geom.Matrix;

class ImgBuf 
{
  public var bd:BitmapData;
  public var b:Bitmap;
  
  public var offx:Float;
  public var offy:Float;
  
  public function new(s:DisplayObject, offset=true, x=0.,y=0.) {
    var r = s.getBounds(null);
    
    if(offset) {
      offx = r.left;
      offy = r.top;
    }
    
    offx += x;
    offy += y;
    
    bd = new BitmapData(cast r.width, cast r.height, true,0);
    
    var m = new Matrix();
    m.translate(-r.left,-r.top);
    
    bd.draw(s,m);
    
    b = new Bitmap(bd);
    b.x = offx;
    b.y = offy;
  }
  
  public function get(x:Float,y:Float) {
    return bd.getPixel32(cast x-offx, cast y-offy);
  }
}