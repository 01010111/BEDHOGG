package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * ...
 * @author x01010111
 */
class PillowFlight extends FlxSprite
{
	var red:Bool;
	
	public function new(P:FlxPoint, V:FlxPoint, RED:Bool, SPAWN:Bool = false) 
	{
		super(0, 0);
		loadGraphic("assets/images/pillowFlight.png", true, 18, 8);
		animation.add("play", [2, 1, 0], 5, false);
		if (SPAWN) animation.play("play");
		setSize(8, 8);
		offset.set(5);
		setPosition(P.x - 4, P.y - 4);
		velocity = V;
		red = RED;
		acceleration.y = 500;
		Reg.state.pillows.add(this);
		Reg.sounds.play(Reg.sounds.throwing, 0.1);
	}
	
	override public function update(elapsed:Float):Void 
	{
		angle = ZMath.angleFromVelocity(velocity.x, velocity.y);
		
		if (justTouched(FlxObject.FLOOR)) hitFloor();
		
		if (red)
		{
			if (Math.abs(velocity.x) > 100 && FlxG.overlap(this, Reg.blue))
			{
				kill();
				Reg.blue.hurt(8);
			}
		}
		else
		{
			if (Math.abs(velocity.x) > 100 && FlxG.overlap(this, Reg.red))
			{
				kill();
				Reg.red.hurt(8);
			}
		}
		
		if (x + width < 0 || x > Reg.state.width || y > FlxG.height * 2) 
		{
			Reg.state.publicPillows++;
			super.kill();
		}
		
		super.update(elapsed);
	}
	
	function superDuperKill():Void
	{
		Reg.pillows++;
		Reg.state.publicPillows++;
		super.kill();
	}
	
	override public function kill():Void 
	{
		for (i in 0...32) var f:Feather = new Feather(getMidpoint());
		superDuperKill();
	}
	
	function hitFloor():Void
	{
		for (i in 0...3) var f:Feather = new Feather(getMidpoint());
		var p:PillowRest = new PillowRest(getMidpoint());
		super.kill();
	}
	
}