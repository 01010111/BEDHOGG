package;

import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	var floor:FlxSprite;
	var fighters:FlxGroup;
	public var feathers:FlxGroup;
	public var pillows:FlxSpriteGroup;
	public var flag:FlxSprite;
	public var width:Int = 600;
	public var dolly:FlxSprite;
	public var jewels:FlxSprite;
	
	override public function create():Void
	{
		Reg.state = this;
		Reg.redAdvantage = Reg.blueAdvantage = false;
		Reg.score = 0;
		
		FlxG.mouse.visible = false;
		
		Reg.c1 = new Controller(false);
		Reg.c2 = new Controller(true);
		if (Reg.c1 != null) add(Reg.c1);
		if (Reg.c2 != null) add(Reg.c2);
		
		flag = new FlxSprite();
		flag.loadGraphic("assets/images/flag.png", true, 64, 64);
		flag.animation.add("idle", [2]);
		flag.animation.add("red", [0]);
		flag.animation.add("blue", [1]);
		flag.animation.play("idle");
		FlxSpriteUtil.screenCenter(flag);
		
		fighters = new FlxGroup();
		fighters.add(new PillowFighter(true, FlxPoint.get(Reg.state.width * 0.5 - 16, FlxG.height * 0.75)));
		fighters.add(new PillowFighter(false, FlxPoint.get(Reg.state.width * 0.5 + 16, FlxG.height * 0.75)));
		
		Reg.red.velocity.set( -150, -400);
		Reg.blue.velocity.set( 150, -400);
		
		feathers = new FlxGroup();
		pillows = new FlxSpriteGroup();
		
		floor = new FlxSprite(0, 176, "assets/images/floor.png");
		floor.immovable = true;
		floor.offset.y = 176;
		
		var room:FlxSprite = new FlxSprite(0, 0, "assets/images/room.png");
		
		dolly = new FlxSprite(width * 0.5);
		dolly.makeGraphic(2, 2, 0x00000000);
		
		var cld2:FlxBackdrop = new FlxBackdrop("assets/images/cloud2.png", 0, 1, true, true);
		cld2.velocity.x = 10;
		add(cld2);
		
		var cld1:FlxBackdrop = new FlxBackdrop("assets/images/cloud1.png", 0.5, 1, true, true);
		cld1.velocity.x = 20;
		add(cld1);
		
		add(room);
		//add(flag);
		add(fighters);
		add(pillows);
		add(feathers);
		add(floor);
		add(dolly);
		
		jewels = new FlxSprite(0, 16);
		jewels.loadGraphic("assets/images/jewels.png", true, 48, 16);
		FlxSpriteUtil.screenCenter(jewels, true, false);
		jewels.scrollFactor.set();
		jewels.angle = -10;
		add(jewels);
		FlxTween.tween(jewels, { angle:10 }, 1, { type:FlxTween.PINGPONG } );
		
		FlxG.camera.follow(dolly);
		FlxG.camera.setScrollBoundsRect(0, 0, width, FlxG.height, true);
		FlxG.worldBounds.set(0, 0, width, FlxG.height);
		
		new FlxTimer().start(1).onComplete = function(t:FlxTimer):Void
		{
			Reg.red.canControl = true;
			Reg.blue.canControl = true;
		}
		
		super.create();
		
		new FlxTimer().start(Math.random() * 2 + 1, throwPillow);
	}
	
	public var publicPillows:Int = 2;
	
	function throwPillow(t:FlxTimer):Void
	{
		if (publicPillows > 0) 
		{
			publicPillows--;
			var o:FlxPoint = FlxPoint.get(Reg.state.width * 0.5 + Math.random() * 32 - 16, FlxG.height * 0.55);
			for (i in 0...4) var f:Feather = new Feather(o);
			var p:PillowFlight = new PillowFlight(o, FlxPoint.get(Math.random() * 180 - 90, -200), (Math.random() > 0.5), true);
		}
		new FlxTimer().start(Math.random() * 2 + 1, throwPillow);
	}
	
	override public function update(elapsed:Float):Void 
	{
		var target:FlxPoint;
		if (Reg.redAdvantage) target = Reg.red.getMidpoint();
		else if (Reg.blueAdvantage) target = Reg.blue.getMidpoint();
		else target = ZMath.getMidPoint(Reg.red.x, Reg.red.y, Reg.blue.x, Reg.blue.y);
		
		scoreStuff();
		
		dolly.x += (target.x - dolly.x) * 0.05;
		dolly.y += (target.y - dolly.y) * 0.05;
		
		Reg.c1.getLastActiveJoypad();
		Reg.c2.getLastActiveJoypad();
		super.update(elapsed);
		FlxG.collide(fighters, floor);
		FlxG.collide(pillows, floor);
		FlxG.collide(feathers, floor);
		if (Reg.red.x > Reg.state.width || Reg.blue.x < 0 - Reg.blue.width) FlxG.switchState(new PlayState());
	}
	
	function scoreStuff():Void
	{
		Reg.redAdvantage = Reg.blueAdvantage = false;
		
		if (Reg.score >= 3)
		{
			Reg.score = 3;
			Reg.redAdvantage = true;
		}
		if (Reg.score <= -3)
		{
			Reg.score = -3;
			Reg.blueAdvantage = true;
		}
		
		jewels.animation.frameIndex = Reg.score + 3;
	}
	
}