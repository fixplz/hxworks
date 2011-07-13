
package util;

class Dispatch
{
	var active:Array<{a:Void->Bool,end:Void->Dynamic}>;
	
	public function new() active = []
	
	public function add(a,?end) active.push({a:a,end:end})
	
	public function update()
	{
		var i=0;
		while(i<active.length)
			if(active[i].a()) i++;
			else
			{
				if(active[i].end!=null) active[i].end();
				active[i] = active[active.length-1];
				active.pop();
			}
	}
	
	public function empty() return active.length==0
}
