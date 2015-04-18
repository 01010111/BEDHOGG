package ;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.XboxButtonID;
import flixel.input.keyboard.FlxKey;

/**
 * ...
 * @author x01010111
 */
class Controller extends FlxGroup
{
	
	var pad:FlxGamepad;
	var isAI:Bool;
	
	public function new(AI:Bool = false, ?PAD:FlxGamepad) 
	{
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
		
		if (isAI)
		{
			AI();
		}
		else if (pad != null)
		{
			if (pad.pressed(XboxButtonID.DPAD_LEFT) || pad.getXAxis(XboxButtonID.LEFT_ANALOG_STICK) < -0.25) left = true;
			if (pad.pressed(XboxButtonID.DPAD_RIGHT) || pad.getXAxis(XboxButtonID.LEFT_ANALOG_STICK) > 0.25) right = true;
			if (pad.justPressed(XboxButtonID.X)) jump = true;
			if (pad.anyPressed([XboxButtonID.A, XboxButtonID.B, XboxButtonID.Y])) charge = true;
			if (pad.justReleased(XboxButtonID.A)) smallSwing = true;
			if (pad.justReleased(XboxButtonID.B)) bigSwing = true;
			if (pad.justReleased(XboxButtonID.Y)) throwing = true;
		}
		else 
		{
			if (FlxG.keys.pressed.LEFT && !FlxG.keys.pressed.RIGHT) left = true;
			if (FlxG.keys.pressed.RIGHT && !FlxG.keys.pressed.LEFT) right = true;
			if (FlxG.keys.justPressed.SPACE) jump = true;
			if (FlxG.keys.anyPressed([FlxKey.SHIFT, FlxKey.Z, FlxKey.X])) charge = true;
			if (FlxG.keys.justReleased.Z) smallSwing = true;
			if (FlxG.keys.justReleased.X) bigSwing = true;
			if (FlxG.keys.justReleased.SHIFT) throwing = true;
		}
	}
	
	function AI():Void
	{
		
	}
	
}