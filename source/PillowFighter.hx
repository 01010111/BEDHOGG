package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.input.FlxPointer;
import flixel.input.keyboard.FlxKeyboard;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author x01010111
 */
class PillowFighter extends FlxSprite
{
	public var hasPillow = true;
	
	var red:Bool;
	var pillowHealth = 50;
	var maxHealth:Int = 20;
	var controller:Controller;
	var pillowBox:FlxSprite;
	var healthMeter:FlxBar;
	var chargeMeter:FlxBar;
	
	public function new(RED:Bool, P:FlxPoint) 
	{
		super(P.x, P.y);
		
		red = RED;
		
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
		
		animation.add("idle", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]);
		animation.add("run", [0, 2, 0, 3], 8);
		animation.add("jump", [2]);
		animation.add("charge", [for (i in 0...256) i == 0? 4: 5 ], 24, false);
		animation.add("smallSwing", [2, 5, 6, 7, 8, 8, 8], 30, false);
		animation.add("bigSwing", [9, 10, 11, 11, 11], 30, false);
		animation.add("throw", [12], 30, false);
		animation.add("down", [18, 19, 18, 19, 18, 19, 18, 19], 10, false);
		animation.add("noPillowIdle", [14, 15], 12);
		animation.add("noPillowRun", [14, 16, 14, 17], 8);
		animation.add("noPillowJump", [16]);
		animation.callback = animCallback;
		
		setSize(8, 24);
		offset.set(20, 8);
		setPosition(x - width * 0.5, y - height);
		acceleration.y = 1200;
		maxVelocity.set(200, 800);
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		health = maxHealth;
		
		healthMeter = new FlxBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 16, 2, this, "health", 0, 10);
		healthMeter.createFilledBar(0x90ff0000, 0xff0080ff);
		
		chargeMeter = new FlxBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 16, 2, this, "chargeAmt", 0, 10);
		chargeMeter.createFilledBar(0x90ff0000, 0xff0080ff);
		
		pillowBox = new FlxSprite();
#if debug
		var color:Int = 0x80ff0000;
		FlxG.state.add(healthMeter);
		FlxG.state.add(chargeMeter);
#else
		var color:Int = 0x00000000;
#end
		pillowBox.makeGraphic(24, 12, color);
		FlxG.state.add(pillowBox);
		
		if (!RED) facing = FlxObject.LEFT;
	}
	
	public var canControl:Bool = false;
	var speed:Float = 200;
	var accelerate:Float = 500;
	var jumpTimer:Int = 0;
	var chargeAmt:Float = 0;
	public var cantMoveTimer:Int = 0;
	
	override public function update(elapsed:Float):Void 
	{
		healthMeter.setPosition(getMidpoint().x - 8, y - 8);
		chargeMeter.setPosition(getMidpoint().x - 8, y - 12);
		
		//if (health < 10) health += 0.05;
		
		acceleration.x = 0;
		
		if (isTouching(FlxObject.FLOOR))
		{
			drag.x = 1000;
		}
		else
		{
			drag.x = 100;
		}
		
		if (cantMoveTimer > 0 || !canControl) controller.canControl = false;
		else controller.canControl = true;
		
		if (cantMoveTimer > 0) cantMoveTimer--;
		
		if (controller.charge && hasPillow) 
		{
			chargeAmt += (20 - chargeAmt) * 0.075;
			pillowBox.width += (35 - pillowBox.width) * 0.1;
			if (red)
			{
				if (Reg.blue.x < x) facing = FlxObject.LEFT;
				else facing = FlxObject.RIGHT;
			}
			else
			{
				if (Reg.red.x < x) facing = FlxObject.LEFT;
				else facing = FlxObject.RIGHT;
			}
		}
		else 
		{
			chargeAmt += (0 - chargeAmt) * 0.1;
			pillowBox.width += (30 - pillowBox.width) * 0.1;
		}
		
		if (controller.jump) jumpTimer = 10;
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
			if (isTouching(FlxObject.FLOOR) && jumpTimer > 0) jump();
			if (!controller.left && !controller.right && controller.canControl) acceleration.x = 0;
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
			
			if (controller.charge)
			{
				if (red)
				{
					if (Reg.red.x < Reg.blue.x) facing = FlxObject.RIGHT;
					else facing = FlxObject.LEFT;
				}
				else 
				{
					if (Reg.blue.x < Reg.red.x) facing = FlxObject.RIGHT;
					else facing = FlxObject.LEFT;
				}
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
		
		if (isTouching(FlxObject.FLOOR)) acceleration.y = 1200;
		
		if (red)
		{
			if (x < 0) velocity.set(300, 200);
			if (x > Reg.state.width - width && !Reg.redAdvantage) velocity.set(-300, 200);
		}
		else 
		{
			if (x < 0 && !Reg.blueAdvantage) velocity.set(300, 200);
			if (x > Reg.state.width - width) velocity.set(-300, 200);
		}
		
		if (!red && Reg.c2.isAI && !Reg.c2.right && !Reg.c2.left)
		{
			Reg.red.x < Reg.blue.x? facing = FlxObject.LEFT: facing = FlxObject.RIGHT;
		}
		
		super.update(elapsed);
		
		facing == FlxObject.RIGHT? pillowBox.setPosition(getMidpoint().x, y + 2): pillowBox.setPosition(getMidpoint().x - pillowBox.width, y + 2);
		if (jumpTimer > 0) jumpTimer--;
		if (acceleration.y < 1200) acceleration.y++;
	}
	
	function smallSwing():Void
	{
		animation.play("smallSwing");
		velocity.y = 0;
		acceleration.y = 500;
		Reg.sounds.play(Reg.sounds.swing, 0.1);
	}
	
	function bigSwing():Void
	{
		animation.play("bigSwing");
		velocity.y = 0;
		acceleration.y = 500;
		Reg.sounds.play(Reg.sounds.swing, 0.25);
	}
	
	function throwing():Void
	{
		animation.play("throw");
		hasPillow = false;
		velocity.y = 0;
		acceleration.y = 250;
		var v:FlxPoint = FlxPoint.get(0, -25);
		facing == FlxObject.LEFT? v.x = -500: v.x = 500;
		var p:PillowFlight = new PillowFlight(pillowBox.getMidpoint(), v, red);
	}
	
	function jump():Void
	{
		velocity.y = -350;
		Reg.sounds.play(Reg.sounds.jump, 0.25);
	}
	
	function animCallback(s:String, i:Int, f:Int):Void
	{
		if (f == 6) 
		{
			hit(4);
		}
		else if (f == 9) 
		{
			hit(chargeAmt);
		}
		if (s == "down" || s == "bigSwing") velocity.x = 0;
	}
	
	function hit(Damage:Float):Void
	{
		var d = Damage;
		if (red)
		{
			if (Reg.c2.charge) d = 10;
			if (FlxG.overlap(pillowBox, Reg.blue)) 
			{
				Reg.blue.hurt(d);
				for (i in 0...Math.floor(Damage))
				{
					var f:Feather = new Feather(pillowBox.getMidpoint());
				}
			}
		}
		else 
		{
			if (Reg.c1.charge) d = 10;
			if (FlxG.overlap(pillowBox, Reg.red)) 
			{
				Reg.red.hurt(d);
				for (i in 0...Math.floor(Damage))
				{
					var f:Feather = new Feather(pillowBox.getMidpoint());
				}
			}
		}
	}
	
	override public function hurt(Damage:Float):Void 
	{
		if (!FlxSpriteUtil.isFlickering(this))
		{
			FlxG.camera.shake(0.002 * Damage, 0.2);
			health -= Damage;
			if (health <= 0)
			{
				Reg.sounds.play(Reg.sounds.knockDown);
				var vx:Float;
				Math.random() < 0.5? vx = -60: vx = 60;
				if (hasPillow) 
				{
					hasPillow = false;
					var p:PillowFlight = new PillowFlight(getMidpoint(), FlxPoint.get(vx, -200), red);
				}
				FlxSpriteUtil.flicker(this, 1.2);
				cantMoveTimer = 45;
				animation.play("down", true);
				
				Reg.state.jewels.scale.set();
				FlxTween.tween(Reg.state.jewels.scale, { x:1, y:1 }, 1, { ease:FlxEase.elasticOut } );
				
				if (red) 
				{
					Reg.score -= 1;
					Reg.blueKO++;
				}
				else
				{
					Reg.score += 1;
					Reg.redKO++;
				}
				health = maxHealth;
			}
			else 
			{
				Reg.sounds.play(Reg.sounds.pillowHit, ZMath.clamp(Damage / 10 * 0.5, 0.1, 0.4));
				FlxSpriteUtil.flicker(this, 0.25);
				if (red)
				{
					velocity.set(ZMath.clamp((Reg.blue.x - x) * -50, -250, 250), -200);
				}
				else
				{
					velocity.set(ZMath.clamp((Reg.red.x - x) * -50, -250, 250), -200);
				}
			}
		}
	}
	
}