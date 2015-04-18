package ;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.input.FlxPointer;
import flixel.input.keyboard.FlxKeyboard;
import flixel.math.FlxPoint;

/**
 * ...
 * @author x01010111
 */
class PillowFighter extends FlxSprite
{
	var hasPillow = true;
	var pillowHealth = 50;
	var controller:Controller;
	
	public function new(RED:Bool, P:FlxPoint) 
	{
		super(P.x, P.y);
		
		if (RED)
		{
			loadGraphic("assets/images/red.png", true, 48, 32);
			controller = Reg.c1;
			Reg.red = this;
		}
		else
		{
			loadGraphic("assets/images/blue.png", true, 48, 32);
			controller = Reg.c2;
			Reg.blue = this;
		}
		
		animation.add("idle", [0]);
		animation.add("run", [0, 1], 8);
		animation.add("jump", [0]);
		animation.add("charge", [2]);
		animation.add("smallSwing", [3, 4, 4, 4, 4], 30, false);
		animation.add("bigSwing", [5, 6, 6, 6, 6], 30, false);
		animation.add("throw", [7], 30, false);
		animation.add("down", [10, 10, 10, 11, 10, 10, 10, 11], 20, false);
		animation.add("noPillowIdle", [8]);
		animation.add("noPillowRun", [8, 9], 8);
		animation.add("noPillowJump", [8]);
		
		setSize(8, 24);
		offset.set(20, 8);
		setPosition(x - width * 0.5, y - height);
		acceleration.y = 1200;
		maxVelocity.y = 800;
		drag.x = 1000;
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
	}
	
	var speed:Float = 200;
	var accelerate:Float = 500;
	
	override public function update(elapsed:Float):Void 
	{
		hasPillow? maxVelocity.x = speed: maxVelocity.x = speed * 1.1;
		
		acceleration.x = 0;
		
		if (
			!animation.finished && animation.curAnim.name == "down" || 
			!animation.finished && animation.curAnim.name == "smallSwing" || 
			!animation.finished && animation.curAnim.name == "bigSwing" || 
			!animation.finished && animation.curAnim.name == "throw" 
		)
		{
			//Do nothin
		}
		else if (hasPillow && controller.charge) 
		{
			animation.play("charge");
			offset.set(20 + Math.random() - 0.5, 8 + Math.random() * 0.5);
		}
		else if (hasPillow && controller.smallSwing) smallSwing();
		else if (hasPillow && controller.bigSwing) bigSwing();
		else if (hasPillow && controller.throwing) throwing();
		else 
		{
			if (isTouching(FlxObject.FLOOR) && controller.jump) jump();
			if (!controller.left && !controller.right) velocity.x = acceleration.x = 0;
			else if (controller.left) 
			{
				facing = FlxObject.LEFT;
				if (velocity.x > 0) velocity.x = 0;
				acceleration.x = -accelerate;
			}
			else if (controller.right)
			{
				facing = FlxObject.RIGHT;
				if (velocity.x < 0) velocity.x = 0;
				acceleration.x = accelerate;
			}
			
			if (!isTouching(FlxObject.FLOOR)) 
			{
				hasPillow? animation.play("jump"): animation.play("noPillowJump");
			}
			else if (velocity.x != 0)
			{
				hasPillow? animation.play("run"): animation.play("noPillowRun");
			}
			else
			{
				hasPillow? animation.play("idle"): animation.play("noPillowIdle");
			}
		}
		
		
		super.update(elapsed);
	}
	
	function smallSwing():Void
	{
		animation.play("smallSwing");
		velocity.y = 0;
	}
	
	function bigSwing():Void
	{
		animation.play("bigSwing");
		velocity.y = 0;
	}
	
	function throwing():Void
	{
		animation.play("throw");
		hasPillow = false;
		velocity.y = 0;
	}
	
	function jump():Void
	{
		velocity.y = -350;
	}
	
}