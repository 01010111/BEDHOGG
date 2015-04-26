package ;  

import flixel.effects.postprocess.PostProcess;
import flixel.FlxState;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import flixel.effects.particles.FlxParticle;
import flixel.tweens.FlxEase;

/**
 * ...
 * @author x01010111
 */
class ZeroOne extends FlxState
{
	private var stageX:Int;
	private var stageY:Int;
	
	private var SPR_you:FlxSprite;
	private var SPR_think:FlxSprite;
	private var SPR_this:FlxSprite;
	private var SPR_is:FlxSprite;
	private var SPR_a:FlxSprite;
	private var SPR_01010111:FlxSprite;
	private var SPR_game:FlxSprite;
	private var SPR_kitty:FlxSprite;
	
	private var PNT_you:FlxPoint;
	private var PNT_think:FlxPoint;
	private var PNT_this:FlxPoint;
	private var PNT_is:FlxPoint;
	private var PNT_a:FlxPoint;
	private var PNT_game:FlxPoint;
	
	private var timer:Int = -1;
	private var timerTime:Int = 3;
	
	private var warbleAmt:Float = 0.02;
	private var warblePoint:FlxPoint;
	
	private var kittyScaler:FlxTween;
	
	public function new() 
	{
		super();
	}
	
	override public function create():Void
	{
		//Reg.input_manager = new NewInputManager();
		
		#if android
		FlxG.drawFramerate = 30;
		#end
		FlxG.mouse.visible = false;
		warblePoint = new FlxPoint(1, 1);
		
		FlxG.camera.bgColor = 0xFF000000;
		
		new FlxTimer().start(0.1, addStuff);
		new FlxTimer().start(2, goToGame);
		
		super.create();
	}
	
	function addStuff(t:FlxTimer):Void
	{
		var circle:FlxSprite = new FlxSprite();
		circle.makeGraphic(FlxG.height, FlxG.height, 0x00FFFFFF);
		FlxSpriteUtil.screenCenter(circle);
		FlxSpriteUtil.drawCircle(circle, -1, -1, 0, 0xFF2040FF);
		circle.scale.set();
		add(circle);
		
		FlxTween.tween(circle.scale, { x:2.5, y:2.5 }, 0.2);
		
		stageX = Math.floor(FlxG.width / 2 - 66);
		stageY = Math.floor(FlxG.height / 2 - 64);
		
		SPR_kitty = new FlxSprite(stageX + 8, stageY + 0, "assets/images/kitty.png");
		SPR_you = new FlxSprite(stageX + 4, stageY + 2, "assets/images/you.png");
		SPR_think = new FlxSprite(stageX + 35, stageY + 0, "assets/images/think.png");
		SPR_this = new FlxSprite(stageX + 78, stageY + 0, "assets/images/this.png");
		SPR_is = new FlxSprite(stageX + 113, stageY + 0, "assets/images/is.png");
		SPR_a = new FlxSprite(stageX + 0, stageY + 114, "assets/images/a.png");
		SPR_01010111 = new FlxSprite(stageX + 12, stageY + 111, "assets/images/01010111.png");
		SPR_game = new FlxSprite(stageX + 93, stageY + 112, "assets/images/game.png");
		
		SPR_kitty.angle = 5;
		SPR_kitty.scale.set();
		SPR_you.scale.set();
		SPR_think.scale.set();
		SPR_this.scale.set();
		SPR_is.scale.set();
		SPR_a.scale.set();
		SPR_01010111.scale.set();
		SPR_game.scale.set();
		
		FlxTween.tween(SPR_kitty, { angle:-5 }, 3, { type:FlxTween.PINGPONG, ease:FlxEase.sineInOut } );
		FlxTween.tween(SPR_you.scale, { x:1, y:1 }, 0.4, { ease:FlxEase.elasticOut } );
		var timerArray:Array<Float> = [for (i in 0...7) i * 0.15 + 0.1];
		new FlxTimer().start(timerArray[0]).onComplete = function(t:FlxTimer){FlxTween.tween(SPR_think.scale, { x:1, y:1 }, 0.4, { ease:FlxEase.elasticOut } );}
		new FlxTimer().start(timerArray[1]).onComplete = function(t:FlxTimer){FlxTween.tween(SPR_this.scale, { x:1, y:1 }, 0.4, { ease:FlxEase.elasticOut } );}
		new FlxTimer().start(timerArray[2]).onComplete = function(t:FlxTimer){FlxTween.tween(SPR_is.scale, { x:1, y:1 }, 0.4, { ease:FlxEase.elasticOut } );}
		new FlxTimer().start(timerArray[3]).onComplete = function(t:FlxTimer){FlxTween.tween(SPR_a.scale, { x:1, y:1 }, 0.4, { ease:FlxEase.elasticOut } );}
		new FlxTimer().start(timerArray[4]).onComplete = function(t:FlxTimer){FlxTween.tween(SPR_01010111.scale, { x:1, y:1 }, 0.4, { ease:FlxEase.elasticOut } );}
		new FlxTimer().start(timerArray[5]).onComplete = function(t:FlxTimer){FlxTween.tween(SPR_game.scale, { x:1, y:1 }, 0.4, { ease:FlxEase.elasticOut } );}
		new FlxTimer().start(timerArray[6]).onComplete = function(t:FlxTimer){kittyScaler = FlxTween.tween(SPR_kitty.scale, { x:1, y:1 }, 0.4, { ease:FlxEase.elasticOut } );}
		
		PNT_you = new FlxPoint(SPR_you.x, SPR_you.y);
		PNT_think = new FlxPoint(SPR_think.x, SPR_think.y);
		PNT_this = new FlxPoint(SPR_this.x, SPR_this.y);
		PNT_is = new FlxPoint(SPR_is.x, SPR_is.y);
		PNT_a = new FlxPoint(SPR_a.x, SPR_a.y);
		PNT_game = new FlxPoint(SPR_game.x, SPR_game.y);
		
		add(SPR_kitty);
		
		add(SPR_you);
		add(SPR_think);
		add(SPR_this);
		add(SPR_is);
		add(SPR_a);
		add(SPR_game);
		
		add(SPR_01010111);
		
		FlxG.sound.play("assets/sounds/bling.mp3", 0.4);
		
		timer = timerTime;
	}
	
	override public function update(e:Float):Void
	{
		super.update(e);
		
		if (timer == 0) {
			jiggle(SPR_you, PNT_you);
			jiggle(SPR_think, PNT_think);
			jiggle(SPR_this, PNT_this);
			jiggle(SPR_is, PNT_is);
			jiggle(SPR_a, PNT_a);
			jiggle(SPR_game, PNT_game);
			
			if (kittyScaler != null && kittyScaler.finished) {
				if (SPR_kitty.scale.x == warblePoint.x) SPR_kitty.scale.x = 1 + Math.random() * warbleAmt;
				else {
					var newX:Float = 1 + Math.random() * 0.1;
					SPR_kitty.scale.x = newX;
					warblePoint.x = newX;
				}
				
				if (SPR_kitty.scale.y == warblePoint.y) SPR_kitty.scale.y = 1 + Math.random() * warbleAmt;
				else {
					var newY:Float = 1 + Math.random() * 0.1;
					SPR_kitty.scale.y = newY;
					warblePoint.y = newY;
				}
			}
			
			warbleAmt += 0.001;
			
			timer = timerTime;
		}
		
		timer -= 1;
	}
	
	public function jiggle(sprite:FlxSprite, point:FlxPoint):Void
	{
		if (sprite.x == point.x) sprite.x += Math.floor(Math.random() * 2) - 1;
		else sprite.x = point.x;
		
		if (sprite.y == point.y) sprite.y += Math.floor(Math.random() * 2) - 1;
		else sprite.y = point.y;
	}
	
	public function goToGame(t:FlxTimer):Void
	{
		timer = -1;
		kittyScaler = FlxTween.tween(SPR_kitty.scale, { x:0, y:0 }, 0.1, { ease:FlxEase.backIn } );
		FlxTween.tween(SPR_you.scale, { x:0, y:0 }, 0.4, { ease:FlxEase.backIn } );
		FlxTween.tween(SPR_think.scale, { x:0, y:0 }, 0.4, { ease:FlxEase.backIn } );
		FlxTween.tween(SPR_this.scale, { x:0, y:0 }, 0.3, { ease:FlxEase.backIn } );
		FlxTween.tween(SPR_is.scale, { x:0, y:0 }, 0.3, { ease:FlxEase.backIn } );
		FlxTween.tween(SPR_a.scale, { x:0, y:0 }, 0.2, { ease:FlxEase.backIn } );
		FlxTween.tween(SPR_01010111.scale, { x:0, y:0 }, 0.2, { ease:FlxEase.backIn } );
		FlxTween.tween(SPR_game.scale, { x:0, y:0 }, 0.2, { ease:FlxEase.backIn } );
		
		new FlxTimer().start(0.5).onComplete = function(t:FlxTimer) { FlxG.switchState(new MenuState()); };
	}
	
}

