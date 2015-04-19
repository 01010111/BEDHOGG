package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * ...
 * @author x01010111
 */
class PillowRest extends FlxSprite
{

	public function new(P:FlxPoint) 
	{
		super();
		loadGraphic("assets/images/PillowRest.png", true, 18, 8);
		animation.add("bounce", [3, 2, 0, 1, 0], 12, false);
		setSize(8, 8);
		offset.set(5, 0);
		setPosition(P.x - 4, P.y - 4);
		acceleration.y = 1200;
		Reg.state.pillows.add(this);
		animation.play("bounce");
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (FlxG.overlap(Reg.red, this))
		{
			if (Reg.red.hasPillow)
			{
				if (Reg.red.velocity.x != 0) animation.play("bounce");
			}
			else 
			{
				Reg.red.hasPillow = true;
				kill();
			}
		}
		if (FlxG.overlap(Reg.blue, this))
		{
			if (Reg.blue.hasPillow)
			{
				if (Reg.blue.velocity.x != 0) animation.play("bounce");
			}
			else 
			{
				Reg.blue.hasPillow = true;
				kill();
			}
		}
		super.update(elapsed);
	}
	
}