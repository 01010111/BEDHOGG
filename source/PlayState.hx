package;

import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
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
	
	var redHand:FlxSprite;
	var blueHand:FlxSprite;
	var redMove:FlxSprite;
	var blueMove:FlxSprite;
	
	override public function create():Void
	{
		Reg.state = this;
		Reg.redAdvantage = Reg.blueAdvantage = false;
		Reg.score = 0;
		Reg.timer = 0;
		Reg.pillows = 0;
		Reg.redKO = 0;
		Reg.blueKO = 0;
		Reg.c1.canControl = false;
		Reg.c2.canControl = false;
		
		FlxG.mouse.visible = false;
		
		if (Reg.c1 != null) add(Reg.c1);
		if (Reg.c2 != null) add(Reg.c2);
		
		fighters = new FlxGroup();
		
		var instructions:FlxText = new FlxText(0,0,0,"GET 3 POINTS & EXIT TO WIN!");
		instructions.setFormat(null, 16, 0xffeedd, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, 0xff000000);
		instructions.borderSize = 3;
		instructions.scale.set();
		instructions.angle = 5;
		FlxSpriteUtil.screenCenter(instructions);
		instructions.scrollFactor.set();
		FlxTween.tween(instructions, { angle: -5 }, 1, { ease:FlxEase.sineInOut, type:FlxTween.PINGPONG } );
		FlxTween.tween(instructions.scale, { x:1, y:1 }, 0.5, { ease:FlxEase.backOut } ).onComplete = function(t:FlxTween):Void
		{
			new FlxTimer().start(1.5).onComplete = function(t:FlxTimer):Void
			{
				FlxTween.tween(instructions.scale, { x:0, y:0 }, 0.5, { ease:FlxEase.backIn } );
			}
		}
		
		new FlxTimer().start(2.5).onComplete = function(t:FlxTimer):Void
		{
			fighters.add(new PillowFighter(true, FlxPoint.get(Reg.state.width * 0.5 - 16, FlxG.height * 0.75)));
			fighters.add(new PillowFighter(false, FlxPoint.get(Reg.state.width * 0.5 + 16, FlxG.height * 0.75)));
			
			Reg.red.velocity.set( -150, -400);
			Reg.blue.velocity.set( 150, -400);
			
			new FlxTimer().start(1).onComplete = function(t:FlxTimer):Void
			{
				Reg.red.canControl = true;
				Reg.blue.canControl = true;
			}
		}
		
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
		
		redHand = new FlxSprite(FlxG.width - 96, FlxG.height * 0.35, "assets/images/redHand.png");
		redHand.scrollFactor.set();
		redHand.scale.set(1, 0);
		handShake(redHand, -15);
		
		blueHand = new FlxSprite(32, FlxG.height * 0.35, "assets/images/blueHand.png");
		blueHand.scrollFactor.set();
		blueHand.scale.set(1, 0);
		handShake(blueHand, 15);
		
		redMove = new FlxSprite(FlxG.width - 96, FlxG.height * 0.25, "assets/images/getMovinRed.png");
		redMove.scrollFactor.set();
		redMove.scale.set();
		redMove.angle = -10;
		FlxTween.tween(redMove, { angle:10 }, 0.8, { type:FlxTween.PINGPONG } );
		
		blueMove = new FlxSprite(32, FlxG.height * 0.25, "assets/images/getMovinBlue.png");
		blueMove.scrollFactor.set();
		blueMove.scale.set();
		blueMove.angle = -10;
		FlxTween.tween(blueMove, { angle:10 }, 0.8, { type:FlxTween.PINGPONG } );
		
		add(room);
		//add(flag);
		add(redHand);
		add(blueHand);
		add(fighters);
		add(pillows);
		add(feathers);
		add(floor);
		add(dolly);
		add(redMove);
		add(blueMove);
		add(instructions);
		
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
		
		super.create();
		
		new FlxTimer().start(Math.random() * 2 + 4, throwPillow);
	}
	
	function handShake(S:FlxSprite, A:Float):Void
	{
		FlxTween.tween(S.scale, { x:0.75 }, 1);
		FlxTween.tween(S, { angle:A }, 1 ).onComplete = function(t:FlxTween):Void
		{
			FlxTween.tween(S.scale, { x:1 }, 0.5, { ease:FlxEase.elasticOut } );
			FlxTween.tween(S, { angle:0 }, 0.5, { ease:FlxEase.elasticOut } ).onComplete = function(t:FlxTween):Void
			{
				handShake(S, A);
			}
		}
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
		var target:FlxPoint = FlxPoint.get(width * 0.5, 0);
		if (Reg.timer > 180 && Reg.red != null && Reg.blue != null)
		{
			if (Reg.redAdvantage) target = Reg.red.getMidpoint();
			else if (Reg.blueAdvantage) target = Reg.blue.getMidpoint();
			else target = ZMath.getMidPoint(Reg.red.x, Reg.red.y, Reg.blue.x, Reg.blue.y);
			if (Reg.red.x > Reg.state.width || Reg.blue.x < 0 - Reg.blue.width) openSubState(new GameOver());
		}
		
		dolly.x += (target.x - dolly.x) * 0.05;
		dolly.y += (target.y - dolly.y) * 0.05;
		
		scoreStuff();
		
		//Reg.c1.getLastActiveJoypad();
		//Reg.c2.getLastActiveJoypad();
		super.update(elapsed);
		FlxG.collide(fighters, floor);
		FlxG.collide(pillows, floor);
		FlxG.collide(feathers, floor);
		
		if (Reg.redAdvantage && redHand.scale.y == 0) 
		{
			FlxTween.tween(redHand.scale, { y:1 }, 0.4, { ease:FlxEase.backOut } );
			FlxTween.tween(redMove.scale, { x:1, y:1 }, 0.4, { ease:FlxEase.backOut } );
		}
		else if (!Reg.redAdvantage && redHand.scale.y == 1) 
		{
			FlxTween.tween(redHand.scale, { y:0 }, 0.4, { ease:FlxEase.backIn } );
			FlxTween.tween(redMove.scale, { x:0, y:0 }, 0.4, { ease:FlxEase.backOut } );
		}
		if (Reg.blueAdvantage && blueHand.scale.y == 0) 
		{
			FlxTween.tween(blueHand.scale, { y:1 }, 0.4, { ease:FlxEase.backOut } );
			FlxTween.tween(blueMove.scale, { x:1, y:1 }, 0.4, { ease:FlxEase.backOut } );
		}
		else if (!Reg.blueAdvantage && blueHand.scale.y == 1) 
		{
			FlxTween.tween(blueHand.scale, { y:0 }, 0.4, { ease:FlxEase.backIn } );
			FlxTween.tween(blueMove.scale, { x:0, y:0 }, 0.4, { ease:FlxEase.backOut } );
		}
		Reg.timer++;
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