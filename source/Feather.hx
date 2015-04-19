package ;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

/**
 * ...
 * @author x01010111
 */
class Feather extends FlxSprite
{
	var t:FlxTween;
	
	public function new(P:FlxPoint) 
	{
		super(P.x, P.y, "assets/images/feather.png");
		velocity.set(new FlxRandom().int( -100, 100), Math.random() * -150);
		t = FlxTween.tween(this.offset, { x:Math.random() * 16 - 8 }, Math.random() * 0.25 + 0.25, { type:FlxTween.PINGPONG } );
		acceleration.y = 100;
		drag.x = 100;
		Reg.state.feathers.add(this);
	}
	
	override public function update(elapsed:Float):Void 
	{
		angle = offset.x * 8;
		
		if (justTouched(FlxObject.FLOOR)) 
		{
			t.cancel();
			new FlxTimer().start(5).onComplete = function(t:FlxTimer):Void 
			{ 
				FlxTween.tween(this, { alpha:0 }, 2).onComplete = function(t:FlxTween):Void
				{
					kill();
				}
			}
			active = false;
		}
		super.update(elapsed);
	}
	
}