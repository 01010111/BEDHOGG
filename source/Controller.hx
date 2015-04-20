package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.input.FlxPointer;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.XboxButtonID;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author x01010111
 */
class Controller extends FlxGroup
{
	
	public var isAI:Bool;
	public var canControl:Bool = true;
	public var pad:FlxGamepad;
	
	public function new(AI:Bool = false, ?PAD:FlxGamepad) 
	{
		isAI = AI;
		if (PAD != null)
		{
			pad = PAD;
		}
		super();
	}
	
	public var left:Bool = false;
	public var right:Bool = false;
	public var jump:Bool = false;
	public var charge:Bool = false;
	public var smallSwing:Bool = false;
	public var bigSwing:Bool = false;
	public var throwing:Bool = false;
	
	override public function update(elapsed:Float):Void 
	{
		left = right = jump = charge = smallSwing = bigSwing = throwing = false;
		
		if (canControl)
		{
			if (isAI)
			{
				AI();
			}
			else if (pad != null)
			{
				if (pad.pressed(XboxButtonID.DPAD_LEFT) || pad.getXAxis(XboxButtonID.LEFT_ANALOG_STICK) < -0.25) left = true;
				if (pad.pressed(XboxButtonID.DPAD_RIGHT) || pad.getXAxis(XboxButtonID.LEFT_ANALOG_STICK) > 0.25) right = true;
				if (pad.justPressed(XboxButtonID.A)) jump = true;
				if (pad.anyPressed([XboxButtonID.B, XboxButtonID.Y])) charge = true;
				if (pad.justPressed(XboxButtonID.X)) smallSwing = true;
				if (pad.justReleased(XboxButtonID.B)) bigSwing = true;
				if (pad.justReleased(XboxButtonID.Y)) throwing = true;
			}
			else 
			{
				if (FlxG.keys.pressed.LEFT && !FlxG.keys.pressed.RIGHT) left = true;
				if (FlxG.keys.pressed.RIGHT && !FlxG.keys.pressed.LEFT) right = true;
				if (FlxG.keys.justPressed.SPACE) jump = true;
				if (FlxG.keys.anyPressed([FlxKey.A, FlxKey.W])) charge = true;
				if (FlxG.keys.justPressed.D) smallSwing = true;
				if (FlxG.keys.justReleased.W) bigSwing = true;
				if (FlxG.keys.justReleased.A) throwing = true;
			}
		}
	}
	
	public function getLastActiveJoypad():Void
	{
		if (Reg.c1 == this && pad == null) pad = FlxG.gamepads.firstActive;
		if (Reg.c2 == this && pad == null) pad = FlxG.gamepads.lastActive;
	}
	
	var swingWindup:Int = 0;
	var throwWindup:Int = 0;
	var proximityFar:Int = 48;
	var proximityClose:Int = 24;
	var boldness:Float = 100;
	
	function AI():Void
	{
		var r:FlxPoint = Reg.red.getMidpoint();
		var b:FlxPoint = Reg.blue.getMidpoint();
		
		var rV:FlxPoint = Reg.red.velocity;
		var bV:FlxPoint = Reg.blue.velocity;
		
		//Check windups
		if (swingWindup > 0)
		{
			charge = true;
			swingWindup--;
			if (swingWindup == 0) 
			{
				charge = false;
				bigSwing = true;
			}
		}
		else if (throwWindup > 0)
		{
			charge = true;
			throwWindup--;
			if (throwWindup == 0) 
			{
				charge = false;
				throwing = true;
			}
		}
		//Main AI loop
		else {
			//If player Y is within range less than AI, chance to jump
			if (r.y < b.y - 32 && r.y > b.y - 48 && Math.random() > 0.95) 
			{
				jump = true;
			}
			//If player is hurt
			if (FlxSpriteUtil.isFlickering(Reg.red)) 
			{
				if (Reg.blueAdvantage) left = true;
				else if (Math.random() > 0.9) jump = true;
				else if (r.x < b.x) right = true;
				else left = true;
			}
			//If AI has no pillow
			else if (!Reg.blue.hasPillow)
			{
				if (Reg.blueAdvantage) boldness += Math.random();
				else boldness += Math.random() * 10;
				//If player has no pillow run for exit
				if (!Reg.red.hasPillow || boldness > 100) 
				{
					if (Reg.blueAdvantage) left = true;
					else 
					{
						var pT:FlxSprite = null;
						for (pillow in Reg.state.pillows)
						{
							if (pillow.alive)
							{
								if (pT == null) pT = pillow;
								else if (Math.abs(b.x - pillow.getMidpoint().x) < Math.abs(b.x - pT.getMidpoint().x)) pT = pillow;
							}
						}
						if (pT != null)
						{
							if (pT.getMidpoint().x < b.x) left = true;
							else right = true;
						}
					}
				}
				//If player throws chance for jump
				else if (Reg.c1.throwing && Math.random() > 0.4) jump = true;
				//If player is on left and far keep distance
				else if (r.x - b.x <= -proximityFar && b.x < Reg.state.width * 0.95) right = true;
				//If player is on left and close try to jump over
				else if (r.x - b.x > -proximityFar && r.x - b.x < 0)
				{
					left = true;
					if (Math.random() > 0.9) jump = true;
				}
				//If player is on right run left
				else if (r.x > b.x) 
				{
					if (Reg.blueAdvantage) left = true;
				}
			}
			//Else AI has pillow
			else 
			{
				boldness = 0;
				//If player throws chance for jump
				if (Reg.c1.throwing && Math.random() > 0.3) jump = true;
				//If player is far and on right side of screen and retreating charge for throw
				if (r.x - b.x > proximityFar && r.x - b.x < 0 && rV.x > 0 || r.x > Reg.state.width * 0.95 && rV.x > 0) throwWindup = new FlxRandom().int(10, 30);
				//If player is on left and retreating enclose
				else if (r.x - b.x < -proximityClose && rV.x < 0) left = true;
				//If player is on left and idle random movement
				else if (r.x - b.x < -proximityClose && b.x < Reg.state.width * 0.95 && rV.x == 0)
				{
					if (Math.random() > 0.999) throwWindup = new FlxRandom().int(10, 30);
					else if (Math.random() > 0.25) left = true;
				}
				//If player is on right
				else if (r.x > b.x)
				{
					//If distance from player to exit is greater than distance from AI to exit, try to exit
					if (Reg.state.width - r.x > b.x) 
					{
						if (Reg.blueAdvantage) left = true;
						else throwWindup = new FlxRandom().int(10, 20);
					}
					//Else if distance from player to blue is greater than close run towards player and throw
					else if (r.x - b.x > proximityClose * 2) 
					{
						right = true;
						if (Math.random() > 0.98) throwWindup = new FlxRandom().int(10, 30);
					}
					//Else run toward player and big swing
					else 
					{
						right = true;
						if (Math.random() > 0.95) swingWindup = new FlxRandom().int(5, 10);
					}
				}
				//If player is close chance for small swing, small chance for big swing
				if (Math.abs(r.x - b.x) <= proximityClose)
				{
					if (Math.random() > 0.975) swingWindup = new FlxRandom().int(10, 30);
					else if (Math.random() > 0.8) smallSwing = true;
				}
				//If player is semi-close and enclosing charge for random range for big swing
				if (Math.abs(r.x - b.x) > proximityClose && Math.abs(r.x - b.x) < proximityFar)
				{
					if (r.x - b.x < 0 && rV.x > 0 || r.x - b.x > 0 && rV.x < 0)
					{
						if (Math.random() > 0.98) swingWindup = new FlxRandom().int(10, 30);
					}
				}
			}
		}
		
	}
	
	override public function destroy():Void 
	{
		
	}
	
	public function superDestroy():Void
	{
		super.destroy();
	}
	
}