package ;  

import flixel.FlxState;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
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
	
	private var timer:Int;
	private var timerTime:Int = 3;
	
	private var warbleAmt:Float = 0.02;
	private var warblePoint:FlxPoint;
	
	private var bG:FlxSprite;
	private var bgColors:FlxGroup;
	private var emitter:FlxEmitter;
	
	public function new() 
	{
		super();
	}
	
	override public function create():Void
	{
		FlxG.mouse.visible = false;
		warblePoint = new FlxPoint(1, 1);
		
		FlxG.camera.flash(0xFF000000, 1);
		
		FlxG.sound.play("assets/sounds/bling.mp3", 0.4);
		
		bG = new FlxSprite(0, 0);
		bG.makeGraphic(FlxG.width, FlxG.height, 0xFF2040FF);
		add(bG);
		
		bgColors = new FlxGroup();
		add(bgColors);
		
		emitter = new FlxEmitter( -FlxG.width, FlxG.height);
		
		for (i in 0...80) {
			var particle:FlxParticle = new FlxParticle();
			var size:Int = Math.floor(Math.random() * 64) + 32;
			particle.makeGraphic(Math.floor(size / 16) , size * 4, 0xFFFFFFFF);
			particle.alpha = Math.random() * 0.5 + 0.5;
			particle.angle = 45;
			particle.exists = false;
			emitter.add(particle);
		}
		
		var speed:Int = 2000;
		
		/*emitter.setXSpeed(speed, speed);
		emitter.setYSpeed(-speed, -speed);
		emitter.setRotation(0, 0);
		emitter.width = FlxG.width * 2;
		add(emitter);
		emitter.start(false, 0.5, 0.5);*/
		
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
		
		timer = timerTime;
		
		new FlxTimer().start(3, goToGame);
		//TweenLite.delayedCall(3, goToGame);
		
		super.create();
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
			
			warbleAmt += 0.001;
			
			timer = timerTime;
		}
		
		timer -= 1;
		
		if (emitter.frequency > 0.05) emitter.frequency -= 0.0050;
		
		//if (FlxG.mouse.justPressed) FlxU.openURL("http://x01010111.com");
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
		FlxG.camera.fade(0xff10112c, 0.5, false, switchState);
		//FlxG.switchState(new PlaySetup);
	}
	
	public function switchState():Void
	{
		FlxG.switchState(new MenuState());
	}
	
}