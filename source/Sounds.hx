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
		pillowHit = ["assets/sounds/hit1.mp3", "assets/sounds/hit2.mp3", "assets/sounds/hit3.mp3", "assets/sounds/hit4.mp3", "assets/sounds/hit5.mp3"];
		swing = ["assets/sounds/swing1.mp3", "assets/sounds/swing2.mp3", "assets/sounds/swing3.mp3"];
		jump = ["assets/sounds/jump1.mp3", "assets/sounds/jump2.mp3", "assets/sounds/jump3.mp3"];
		throwing = ["assets/sounds/throw.mp3"];
		knockDown = ["assets/sounds/ko.mp3"];
	}
	
	public function play(s:Array<String>, v:Float = 0.5):Void
	{
		FlxG.sound.play(s[Math.floor(Math.random() * s.length)], v);
	}
	
}