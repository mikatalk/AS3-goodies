package
{
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.utils.deg2rad;
	
	public class Spinner extends Sprite
	{
		private var cw:Image;
		private var cwTween:Tween;

		private var ccw:Image;
		private var ccwTween:Tween;
				
		public function Spinner(startSpinning:Boolean = true)
		{
			super();
			
			cw = new Image(Root.assets.getTexture("spinner"));
			addChild(cw);
			cw.pivotX = cw.width / 2;
			cw.pivotY = cw.height / 2;
			cwTween = new Tween(cw, .8, Transitions.LINEAR);
			cwTween.repeatCount = int.MAX_VALUE;
			cwTween.animate("rotation", deg2rad(360));
			
			ccw = new Image(Root.assets.getTexture("spinner"));
			addChild(ccw);
			ccw.alpha = .8;
			ccw.pivotX = ccw.width / 2;
			ccw.pivotY = ccw.height / 2;
			ccwTween = new Tween(ccw, 1.2, Transitions.LINEAR);
			ccwTween.repeatCount = int.MAX_VALUE;
			ccwTween.animate("rotation", deg2rad(-360));
			
			spin(startSpinning);
		}
		
		public function spin(oui:Boolean):void
		{
			if ( oui ) {
				Starling.juggler.add(cwTween);
				Starling.juggler.add(ccwTween);
			} else {
				Starling.juggler.remove(cwTween);
				Starling.juggler.remove(ccwTween);
			}
			cw.visible = ccw.visible = oui;
		}
		
	}
}