package;

import flixel.addons.display.FlxBackdrop;
import flixel.addons.effects.FlxWaveSprite.FlxWaveMode;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.FlxInput.FlxInputState;
import flixel.input.gamepad.XboxButtonID;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;

class MenuState extends FlxState
{
	var p1Text:FlxText;
	var p2Text:FlxText;
	
	override public function create():Void
	{
		Reg.sounds = new Sounds();
		FlxG.sound.playMusic("assets/music/title.mp3", 0.75);
		
		if (Reg.c1 != null) Reg.c1.superDestroy();
		if (Reg.c2 != null) Reg.c2.superDestroy();
		var cld1:FlxBackdrop = new FlxBackdrop("assets/images/titcld1.png");
		cld1.velocity.x = -20;
		add(cld1);
		
		var cld2:FlxBackdrop = new FlxBackdrop("assets/images/titcld2.png");
		cld2.velocity.x = -60;
		add(cld2);
		
		var cld3:FlxBackdrop = new FlxBackdrop("assets/images/titcld3.png");
		cld3.velocity.x = -180;
		add(cld3);
		
		var title:FlxSprite = new FlxSprite(0, 0, "assets/images/title.png");
		title.scale.set();
		FlxSpriteUtil.screenCenter(title);
		title.angle = 5;
		add(title);
		FlxTween.tween(title, { angle: -5 }, 1.5, { type:FlxTween.PINGPONG } );
		FlxTween.tween(title.scale, { x:4, y:4 }, 0.5, { ease:FlxEase.backOut } ).onComplete = function(t:FlxTween):Void
		{
			FlxTween.tween(title.scale, { x:3.5, y:3.5 }, 2, { type:FlxTween.PINGPONG } );
		}
		
		p1Text = new FlxText(16, FlxG.height - 20, FlxG.width - 16);
		p1Text.setFormat(null, 8, 0xFFEEDD, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, 0xFFf33939);
		p1Text.borderSize = 2;
		p1Text.alpha = 0;
		FlxTween.tween(p1Text, { alpha:1 }, 2);
		FlxTween.tween(p1Text, { y:FlxG.height - 16.5 }, 1.5, { ease:FlxEase.sineInOut, type:FlxTween.PINGPONG } );
		add(p1Text);
		
		p2Text = new FlxText(0, FlxG.height - 20, FlxG.width - 16);
		p2Text.setFormat(null, 8, 0xFFEEDD, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, 0xFF1787e5);
		p2Text.borderSize = 2;
		p2Text.alpha = 0;
		FlxTween.tween(p2Text, { alpha:1 }, 2);
		FlxTween.tween(p2Text, { y:FlxG.height - 16.5 }, 1.5, { ease:FlxEase.sineInOut, type:FlxTween.PINGPONG } );
		add(p2Text);
		
		FlxG.camera.flash(0xffffffff, 0.4);
	}
	
	var state = -1;
	
	override public function update(elapsed:Float):Void 
	{
		if (state == 0) askP1Input();
		else if (state == 1) askP2Input();
		else if (state == 2) 
		{
			goAhead();
			state = 3;
		}
		
		super.update(elapsed);
		
		if (state < 0) state++;
	}
	
	function askP1Input():Void
	{
		p1Text.text = "[   PLAYER 1 PRESS JUMP   ]";
		p2Text.text = "[  PLAYER 2 PLEASE WAIT!  ]";
		if (FlxG.keys.justReleased.SPACE)
		{
			Reg.c1 = new Controller(false);
			state++;
		}
		else if (FlxG.gamepads.firstActive != null && FlxG.gamepads.firstActive.justReleased(XboxButtonID.A))
		{
			Reg.c1 = new Controller(false, FlxG.gamepads.firstActive);
			state++;
		}
		else if (FlxG.gamepads.lastActive != null && FlxG.gamepads.lastActive.justReleased(XboxButtonID.A))
		{
			Reg.c1 = new Controller(false, FlxG.gamepads.lastActive);
			state++;
		}
		if (state == 1)
		{
			FlxG.camera.flash(0xffffffff, 0.4);
			add(Reg.c1);
		}
	}
	
	var i = 0;
	
	function askP2Input():Void
	{
		if (i > 0)
		{
			p1Text.text = "[   JUMP TO PLAY VS CPU   ]";
			p2Text.text = "[   PLAYER 2 PRESS JUMP   ]";
			if (Reg.c1.jump)
			{
				Reg.c2 = new Controller(true);
				state++;
			}
			else if (FlxG.keys.justReleased.SPACE)
			{
				Reg.c2 = new Controller(false);
				state++;
			}
			else if (FlxG.gamepads.firstActive != null && FlxG.gamepads.firstActive.justReleased(XboxButtonID.A))
			{
				Reg.c2 = new Controller(false, FlxG.gamepads.firstActive);
				state++;
			}
			else if (FlxG.gamepads.lastActive != null && FlxG.gamepads.lastActive.justReleased(XboxButtonID.A))
			{
				Reg.c2 = new Controller(false, FlxG.gamepads.lastActive);
				state++;
			}
			if (state == 2)
			{
				FlxG.camera.flash(0xffffffff, 0.4);
			}
		}
		else i++;
	}
	
	function goAhead():Void
	{
		p1Text.text = "[           O K           ]";
		p2Text.text = "[           O K           ]";
		
		var s:FlxSprite = new FlxSprite();
		s.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		s.alpha = 0;
		add(s);
		FlxG.sound.music.fadeOut(1);
		FlxTween.tween(s, { alpha:1 }, 1).onComplete = function(t:FlxTween):Void
		{
			FlxG.sound.playMusic("assets/music/play.mp3", 0.3);
			FlxG.switchState(new PlayState());
		}
	}
	
}