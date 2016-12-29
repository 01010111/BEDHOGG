package ;
import flixel.FlxG;
import flixel.group.FlxGroup;

/**
 * ...
 * @author x01010111
 */
class Sounds extends FlxGroup
{
	public var pillowHit:Array<String>;
	public var swing:Array<String>;
	public var jump:Array<String>;
	public var throwing:Array<String>;
	public var knockDown:Array<String>;
	
	public function new()
	{
		super();
		pillowHit = ["hit1", "hit2", "hit3", "hit4", "hit5"];
		swing = ["swing1", "swing2", "swing3"];
		jump = ["jump1", "jump2", "jump3"];
		throwing = ["throw"];
		knockDown = ["ko"];
	}
	
	public function play(s:Array<String>, v:Float = 0.5):Void
	{
		FlxG.sound.play(s[Math.floor(Math.random() * s.length)], v);
	}
	
}