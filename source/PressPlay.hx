package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * ...
 * @author x01010111
 */
class PressPlay extends FlxState
{
	var play:FlxSprite;
	var pvp:FlxSprite;
	var pvc:FlxSprite;
	var controls:FlxSprite;
	var circleSpeed:Float = 1.5;
	var itch:FlxSprite;
	var twitter:FlxSprite;
	
	override public function create():Void 
	{
		var b:FlxSprite = new FlxSprite();
		b.makeGraphic(FlxG.width, FlxG.height, 0xff0a0053);
		add(b);
		
		var blk:FlxSprite = new FlxSprite();
		blk.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
		add(blk);
		
		var circles:FlxGroup = new FlxGroup();
		add(circles);
		
		var amtCircles = 12;
		for (i in 0...amtCircles) new FlxTimer().start(circleSpeed * i / amtCircles).onComplete = function(t:FlxTimer):Void { addCircle(i * 360 / amtCircles, circles); } 
		
		new FlxTimer().start(circleSpeed).onComplete = function(t:FlxTimer):Void { FlxTween.tween(blk, { alpha:0 }, 4); }
		
		play = new FlxSprite(0, FlxG.height * 0.375, "assets/images/pressPlay.png");
		FlxSpriteUtil.screenCenter(play, true, false);
		play.scale.set();
		add(play);
		
		pvp = new FlxSprite(FlxG.width * 0.3, FlxG.height * 0.2);
		pvp.loadGraphic("assets/images/playModes.png", true, 82, 44);
		pvp.offset.set(pvp.width * 0.5, pvp.height * 0.5);
		pvp.animation.frameIndex = 0;
		pvp.scale.set();
		add(pvp);
		
		pvc = new FlxSprite(FlxG.width * 0.7, FlxG.height * 0.2);
		pvc.loadGraphic("assets/images/playModes.png", true, 82, 44);
		pvc.offset.set(pvc.width * 0.5, pvc.height * 0.5);
		pvc.animation.frameIndex = 1;
		pvc.scale.set();
		add(pvc);
		
		controls = new FlxSprite(FlxG.width * 0.5, FlxG.height * 0.8, "assets/images/controls.png");
		controls.offset.set(controls.width * 0.5, controls.height * 0.5);
		controls.scale.set();
		add(controls);
		
		new FlxTimer().start(0.5).onComplete = function(t:FlxTimer):Void { FlxTween.tween(pvp.scale, { x:1, y:1 }, 0.3, { ease:FlxEase.backOut } ); }
		new FlxTimer().start(0.75).onComplete = function(t:FlxTimer):Void { FlxTween.tween(pvc.scale, { x:1, y:1 }, 0.3, { ease:FlxEase.backOut } ); }
		new FlxTimer().start(1).onComplete = function(t:FlxTimer):Void { FlxTween.tween(controls.scale, { x:1, y:1 }, 0.3, { ease:FlxEase.backOut } ); }
		new FlxTimer().start(1.25).onComplete = function(t:FlxTimer):Void { FlxTween.tween(play.scale, { x:1, y:1 }, 0.3, { ease:FlxEase.backOut } ); }
		new FlxTimer().start(1.5).onComplete = function(t:FlxTimer):Void { 
			itch = new FlxSprite(16, FlxG.height, "assets/images/itch.png");
			add(itch);
			twitter = new FlxSprite(0, FlxG.height, "assets/images/twitter.png");
			twitter.x = FlxG.width - twitter.width - 16;
			add(twitter);
			FlxTween.tween(itch, { y:FlxG.height - 24 }, 0.6, { ease:FlxEase.backOut } );
			FlxTween.tween(twitter, { y:FlxG.height - 24 }, 0.6, { ease:FlxEase.backOut } );
		}
	}
	
	function addCircle(A:Float, G:FlxGroup):Void
	{
		var circle:FlxSprite = new FlxSprite(0, 0, "assets/images/bigCircle.png");
		FlxSpriteUtil.screenCenter(circle);
		circle.scale.set();
		circle.alpha = ZMath.randomRange(0.3, 0.5);
		G.add(circle);
		
		var off = ZMath.velocityFromAngle(A, 48);
		
		circle.setPosition(circle.x + off.x, circle.y + off.y);
		FlxTween.tween(circle.scale, { x:3, y:3 }, circleSpeed, { type:FlxTween.LOOPING } );
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (play.scale.x > 0.9)
		{
			if (FlxMath.mouseInFlxRect(true, new FlxRect(play.x, play.y, play.width, play.height)) && play.scale.x == 1)
			{
				FlxTween.tween(play.scale, { x:1.2, y:1.2 }, 0.4, { ease:FlxEase.backOut } );
			}
			else if (play.scale.x == 1.2)
			{
				FlxTween.tween(play.scale, { x:1, y:1 }, 0.4, { ease:FlxEase.backOut } );
			}
			if (FlxG.mouse.visible && FlxMath.mouseInFlxRect(true, new FlxRect(play.x, play.y, play.width, play.height)) && FlxG.mouse.justPressed)
			{
				FlxG.mouse.visible = false;
				FlxG.camera.fade(0xff000000, 0.4);
				new FlxTimer().start(0.4).onComplete = function(t:FlxTimer):Void { FlxG.switchState(new ZeroOne()); }
			}
			
			if (itch != null && FlxMath.mouseInFlxRect(true, itch.toRect()) && itch.scale.x == 1)
			{
				FlxTween.tween(itch.scale, { x:1.2, y:1.2 }, 0.4, { ease:FlxEase.backOut } );
			}
			else if (itch != null && itch.scale.x == 1.2)
			{
				FlxTween.tween(itch.scale, { x:1, y:1 }, 0.4, { ease:FlxEase.backOut } );
			}
			if (itch != null && FlxG.mouse.visible && FlxMath.mouseInFlxRect(true, itch.toRect()) && FlxG.mouse.justPressed)
			{
				//FlxG.mouse.visible = false;
				//FlxG.camera.fade(0xff000000, 0.4);
				FlxG.openURL("http://01010111.itch.io");
			}
			
			if (twitter != null && FlxMath.mouseInFlxRect(true, twitter.toRect()) && twitter.scale.x == 1)
			{
				FlxTween.tween(twitter.scale, { x:1.2, y:1.2 }, 0.4, { ease:FlxEase.backOut } );
			}
			else if (twitter != null && twitter.scale.x == 1.2)
			{
				FlxTween.tween(twitter.scale, { x:1, y:1 }, 0.4, { ease:FlxEase.backOut } );
			}
			if (twitter != null && FlxG.mouse.visible && FlxMath.mouseInFlxRect(true, twitter.toRect()) && FlxG.mouse.justPressed)
			{
				//FlxG.mouse.visible = false;
				//FlxG.camera.fade(0xff000000, 0.4);
				FlxG.openURL("http://twitter.com/x01010111");
			}
		}
	}
	
}