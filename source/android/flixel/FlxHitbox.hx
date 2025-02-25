package android.flixel;

import android.flixel.FlxButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.group.FlxSpriteGroup;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;

/**
 * A hitbox.
 * It's easy to set the callbacks and to customize the layout.
 *
 * @author: Saw (M.A. Jigsaw)
 */
class FlxHitbox extends FlxSpriteGroup
{
	public var buttonLeft:FlxButton;
	public var buttonDown:FlxButton;
	public var buttonUp:FlxButton;
	public var buttonRight:FlxButton;

	/**
	 * Group of the hint buttons.
	 */
	public var hitbox:FlxSpriteGroup;

	/**
	 * Create a hitbox.
	 */
	public function new()
	{
		super();

		scrollFactor.set();

		hitbox = new FlxSpriteGroup();
		hitbox.scrollFactor.set();

		hitbox.add(add(buttonLeft = createHitbox(0, 0, 'left', 0xFF876DB0)));
		hitbox.add(add(buttonDown = createHitbox(FlxG.width / 4, 0, 'down', 0xFF488DB0)));
		hitbox.add(add(buttonUp = createHitbox(FlxG.width / 2, 0, 'up', 0xFF5F9C4C)));
		hitbox.add(add(buttonRight = createHitbox((FlxG.width / 2) + (FlxG.width / 4), 0, 'right', 0xFF946B99)));
	}

	override function destroy()
	{
		super.destroy();

		if (hitbox != null)
		{
			hitbox = FlxDestroyUtil.destroy(hitbox);
			hitbox = null;
		}

		if (buttonLeft != null)
			buttonLeft = null;

		if (buttonDown != null)
			buttonDown = null;

		if (buttonUp != null)
			buttonUp = null;

		if (buttonRight != null)
			buttonRight = null;
	}

	/**
	 * @param   X          The x-position of the button.
	 * @param   Y          The y-position of the button.
	 * @param   Color      The color of the button.
	 * @param   Callback   The callback for the button.
	 * @return  The button
	 */
	public function createHitbox(X:Float, Y:Float, Graphic:String, ?Color:Int, ?OnClick:Void->Void):FlxButton
	{
		var button:FlxButton = new FlxButton(X, Y);
		button.loadGraphic(FlxGraphic.fromFrame(FlxAtlasFrames.fromSparrow('assets/android/hitbox.png', 'assets/android/hitbox.xml').getByName(Graphic)));
		button.setGraphicSize(Std.int(FlxG.width / 4), FlxG.height);
		button.updateHitbox();
		button.alpha = 0.00001;

		var tween:FlxTween = null;

		button.onDown.callback = function()
		{
			if (tween != null)
				tween.cancel();

			tween = FlxTween.num(button.alpha, 0.6, 0.06, {ease: FlxEase.circInOut}, function(value:Float)
			{
				button.alpha = value;
			});
		}

		button.onUp.callback = function()
		{
			if (tween != null)
				tween.cancel();

			tween = FlxTween.num(button.alpha, 0.00001, 0.15, {ease: FlxEase.circInOut}, function(value:Float)
			{
				button.alpha = value;
			});
		}

		button.onOut.callback = function()
		{
			if (tween != null)
				tween.cancel();

			tween = FlxTween.num(button.alpha, 0.00001, 0.15, {ease: FlxEase.circInOut}, function(value:Float)
			{
				button.alpha = value;
			});
		}

		if (Color != null)
			button.color = Color;

		#if FLX_DEBUG
		button.ignoreDrawDebug = true;
		#end

		if (OnClick != null)
			button.onDown.callback = OnClick;

		return button;
	}
}
