package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author x01010111
 */
class GameOver extends FlxSubState
{
	var shade:FlxSprite;
	
	public function new () 
	{
		super();
		
		Reg.c1.canControl = true;
		Reg.c2.canControl = true;
		
		FlxG.sound.music.fadeOut(0.2, 0.2);
		
		var b:FlxSprite = new FlxSprite();
		b.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		b.scrollFactor.set();
		b.alpha = 0;
		FlxTween.tween(b, { alpha:0.8 }, 2 );
		add(b);
		
		var winner:FlxSprite = new FlxSprite(FlxG.width * 0.5 - 32, 48);
		winner.loadGraphic("assets/images/Wins.png", true, 64, 22);
		winner.angle = -5;
		winner.scrollFactor.set();
		winner.scale.set();
		if (Reg.score < 0) winner.animation.frameIndex = 1;
		add(winner);
		FlxTween.tween(winner.scale, { x:4, y:4 }, 0.75, { ease:FlxEase.backOut } );
		FlxTween.tween(winner, { angle:5 }, 2, { ease:FlxEase.sineInOut, type:FlxTween.PINGPONG } );
		
		var time = Math.floor(Reg.timer / 60);
		var m = Math.floor(time / 60);
		var s = Math.floor(time % 60);
		var min:String = "";
		m == 0? min = "0": min = "" + m;
		var sec:String = "";
		if (s == 0) sec = "00";
		else if (s < 10) sec = "0" + s;
		else sec = "" + s;
		
		var timerText:FlxText = new FlxText(0, winner.y + 50, FlxG.width, "PLAY TIME: " + min + ":" + sec);
		timerText.setFormat(null, 16, 0xFFEEDD, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
		timerText.borderSize = 3;
		timerText.scrollFactor.set();
		timerText.angle = Math.random() * 1 + 1;
		timerText.scale.set();
		add(timerText);
		FlxTween.tween(timerText.scale, { x:1, y:1 }, Math.random() * 0.25 + 0.5, { ease:FlxEase.backOut } );
		FlxTween.tween(timerText, { angle: -timerText.angle }, Math.random() * 0.5 + 1, { ease:FlxEase.sineInOut, type:FlxTween.PINGPONG } );
		
		var pillowText:FlxText = new FlxText(0, timerText.y + 20, FlxG.width, "PILLOWS DESTROYED: " + Reg.pillows);
		pillowText.setFormat(null, 16, 0xFFEEDD, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
		pillowText.borderSize = 3;
		pillowText.scrollFactor.set();
		pillowText.angle = Math.random() * 1 + 1;
		pillowText.scale.set();
		add(pillowText);
		FlxTween.tween(pillowText.scale, { x:1, y:1 }, Math.random() * 0.25 + 0.5, { ease:FlxEase.backOut } );
		FlxTween.tween(pillowText, { angle: -pillowText.angle }, Math.random() * 0.5 + 1, { ease:FlxEase.sineInOut, type:FlxTween.PINGPONG } );
		
		var redKOText:FlxText = new FlxText(0, pillowText.y + 20, FlxG.width, "RED KNOCKOUTS: " + Reg.redKO);
		redKOText.setFormat(null, 16, 0xffddbf, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFFf33939);
		redKOText.borderSize = 3;
		redKOText.scrollFactor.set();
		redKOText.angle = Math.random() * 1 + 1;
		redKOText.scale.set();
		add(redKOText);
		FlxTween.tween(redKOText.scale, { x:1, y:1 }, Math.random() * 0.25 + 0.5, { ease:FlxEase.backOut } );
		FlxTween.tween(redKOText, { angle: -redKOText.angle }, Math.random() * 0.5 + 1, { ease:FlxEase.sineInOut, type:FlxTween.PINGPONG } );
		
		var blueKOText:FlxText = new FlxText(0, redKOText.y + 20, FlxG.width, "BLUE KNOCKOUTS: " + Reg.blueKO);
		blueKOText.setFormat(null, 16, 0xc5ffc0, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF1787e5);
		blueKOText.borderSize = 3;
		blueKOText.scrollFactor.set();
		blueKOText.angle = Math.random() * 1 + 1;
		blueKOText.scale.set();
		add(blueKOText);
		FlxTween.tween(blueKOText.scale, { x:1, y:1 }, Math.random() * 0.25 + 0.5, { ease:FlxEase.backOut } );
		FlxTween.tween(blueKOText, { angle: -blueKOText.angle }, Math.random() * 0.5 + 1, { ease:FlxEase.sineInOut, type:FlxTween.PINGPONG } );
		
		var continueText:FlxText = new FlxText(0, blueKOText.y + 32, FlxG.width, 'PRESS "JUMP" TO PLAY AGAIN!\nPRESS "THROW" TO QUIT');
		continueText.setFormat(null, 8, 0xFFEEDD, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
		continueText.borderSize = 2;
		continueText.scrollFactor.set();
		continueText.angle = Math.random() * 1 + 1;
		continueText.scale.set();
		add(continueText);
		FlxTween.tween(continueText.scale, { x:1, y:1 }, Math.random() * 0.25 + 0.5, { ease:FlxEase.backOut } );
		FlxTween.tween(continueText, { angle: -continueText.angle }, Math.random() * 0.5 + 1, { ease:FlxEase.sineInOut, type:FlxTween.PINGPONG } );
		
		shade = new FlxSprite();
		shade.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		shade.scrollFactor.set();
		shade.alpha = 0;
		add(shade);
		
		add(Reg.c1);
		if (!Reg.c2.isAI) add(Reg.c2);
	}
	
	var replay:Bool = true;
	
	override public function update(elapsed:Float):Void 
	{
		if (Reg.c1.jump || Reg.c2.jump) close();
		if (Reg.c1.throwing || Reg.c2.throwing)
		{
			replay = false;
			close();
		}
		super.update(elapsed);
	}
	
	override public function close():Void 
	{
		FlxTween.tween(shade, { alpha:1 }, 1 ).onComplete = function(t:FlxTween):Void
		{
			if (replay) 
			{
				FlxG.switchState(new PlayState());
			}
			else 
			{
				FlxG.sound.music.stop();
				FlxG.switchState(new MenuState());
			}
		}
	}
	
}