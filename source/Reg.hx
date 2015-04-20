package;

import flixel.util.FlxSave;

class Reg
{
	public static var red:PillowFighter;
	public static var blue:PillowFighter;
	public static var c1:Controller;
	public static var c2:Controller;
	public static var state:PlayState;
	public static var redAdvantage:Bool;
	public static var blueAdvantage:Bool;
	public static var sounds:Sounds;
	public static var score:Int = 0;
	public static var timer:Int = 0;
	public static var pillows:Int = 0;
	public static var redKO:Int = 0;
	public static var blueKO:Int = 0;
}