
package util;

import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

class Key
{
	
	public static var st : Array <Bool>;
	
	static var stage : Stage;
	
	public static function init (stage : Stage)
	{
		Key.stage = stage;
		
		stage.addEventListener (KeyboardEvent.KEY_DOWN, keydown);
		stage.addEventListener (KeyboardEvent.KEY_UP, keyup);
		stage.addEventListener (MouseEvent.MOUSE_DOWN, mousedown);
		stage.addEventListener (MouseEvent.MOUSE_UP, mouseup);
		
		clear ();
	}
	
  public static function get(key) { return st[key]; }
  
	public static function uninit ()
	{
		stage.removeEventListener (KeyboardEvent.KEY_DOWN, keydown);
		stage.removeEventListener (KeyboardEvent.KEY_UP, keyup);
		stage.removeEventListener (MouseEvent.MOUSE_DOWN, mousedown);
		stage.removeEventListener (MouseEvent.MOUSE_UP, mouseup);
		
		clear ();
	}
	
	public static function clear (?e)
	{
		st = [];
		for (i in 0 ... 223) st.push (false);
	}
	
	static var t=0;
	public static function tick() return (t++%8)==0
	
	static function keydown (k) st[k.keyCode] = true
	static function keyup (k) { st[k.keyCode] = false; t=0; }
	static function mousedown (k) keydown ({ keyCode : 223 })
	static function mouseup (k) keyup ({ keyCode : 223 })
	
	
public static var id =
{
BACKSPACE : Keyboard.BACKSPACE,
TAB : Keyboard.TAB,
MIDDLE : 12,
ENTER : Keyboard.ENTER,
SHIFT : Keyboard.SHIFT,
CONTROL : Keyboard.CONTROL,
PAUSE : 19,
BREAK : 19,
CAPS_LOCK : Keyboard.CAPS_LOCK,
ESCAPE : Keyboard.ESCAPE,
SPACEBAR : Keyboard.SPACE,
PAGE_UP : Keyboard.PAGE_UP,
PAGE_DOWN : Keyboard.PAGE_DOWN,
END : Keyboard.END,
HOME : Keyboard.HOME,
LEFT_ARROW : Keyboard.LEFT,
UP_ARROW : Keyboard.UP,
RIGHT_ARROW : Keyboard.RIGHT,
DOWN_ARROW : Keyboard.DOWN,
INSERT : Keyboard.INSERT,
DELETE : Keyboard.DELETE,
NUM_0 : 48,
NUM_1 : 49,
NUM_2 : 50,
NUM_3 : 51,
NUM_4 : 52,
NUM_5 : 53,
NUM_6 : 54,
NUM_7 : 55,
NUM_8 : 56,
NUM_9 : 57,
A : 65,
B : 66,
C : 67,
D : 68,
E : 69,
F : 70,
G : 71,
H : 72,
I : 73,
J : 74,
K : 75,
L : 76,
M : 77,
N : 78,
O : 79,
P : 80,
Q : 81,
R : 82,
S : 83,
T : 84,
U : 85,
V : 86,
W : 87,
X : 88,
Y : 89,
Z : 90,
LEFT_WINDOWS : 91,
RIGHT_WINDOWS : 92,
MENU : 93,
NUMPAD_0 : Keyboard.NUMPAD_0,
NUMPAD_1 : Keyboard.NUMPAD_1,
NUMPAD_2 : Keyboard.NUMPAD_2,
NUMPAD_3 : Keyboard.NUMPAD_3,
NUMPAD_4 : Keyboard.NUMPAD_4,
NUMPAD_5 : Keyboard.NUMPAD_5,
NUMPAD_6 : Keyboard.NUMPAD_6,
NUMPAD_7 : Keyboard.NUMPAD_7,
NUMPAD_8 : Keyboard.NUMPAD_8,
NUMPAD_9 : Keyboard.NUMPAD_9,
NUMPAD_MULTIPLY : Keyboard.NUMPAD_MULTIPLY,
NUMPAD_ADD : Keyboard.NUMPAD_ADD,
NUMPAD_SUBTRACT : Keyboard.NUMPAD_SUBTRACT,
NUMPAD_DECIMAL : Keyboard.NUMPAD_DECIMAL,
NUMPAD_DIVIDE : Keyboard.NUMPAD_DIVIDE,
F1 : Keyboard.F1,
F2 : Keyboard.F2,
F3 : Keyboard.F3,
F4 : Keyboard.F4,
F5 : Keyboard.F5,
F6 : Keyboard.F6,
F7 : Keyboard.F7,
F8 : Keyboard.F8,
F9 : Keyboard.F9,
F10 : Keyboard.F10,
F11 : Keyboard.F11,
F12 : Keyboard.F12,
F13 : Keyboard.F13,
F14 : Keyboard.F14,
F15 : Keyboard.F15,
NUM_LOCK : 144,
SCROLL_LOCK : 145,
SEMICOLON : 186,
COLON : 186,
EQUALS : 187,
PLUS : 187,
COMMA : 188,
LEFT_ANGLE : 188,
MINUS : 189,
UNDERSCORE : 189,
PERIOD : 190,
RIGHT_ANGLE : 190,
FORWARD_SLASH : 191,
QUESTION_MARK : 191,
BACKQUOTE : 192,
TILDE : 192,
LEFT_BRACKET : 219,
BACKSLASH : 220,
BAR : 220,
RIGHT_BRACKET : 221,
QUOTE : 222,
MOUSE : 223
}
	
}
