package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;

class PlayState extends FlxState
{
	var floor:FlxSprite;
	
	override public function create():Void
	{
		Reg.c1 = new Controller(false);
		Reg.c2 = new Controller(true);
		if (Reg.c1 != null) add(Reg.c1);
		if (Reg.c2 != null) add(Reg.c2);
		add(new PillowFighter(true, FlxPoint.get(FlxG.width * 0.5, FlxG.height * 0.5)));
		
		floor = new FlxSprite(0, FlxG.height * 0.75);
		floor.makeGraphic(FlxG.width, Math.ceil(FlxG.height * 0.25), 0xff808090);
		floor.immovable = true;
		add(floor);
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		FlxG.collide(Reg.red, floor);
	}
}