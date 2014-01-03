package 
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
    
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class ProgressBar extends Sprite
	{
		
		// Startup image for SD screens
		[Embed(source="/startup/progressbar-x1.png")]
			private static var ProgressBarAtlas1x:Class;
		
		// Startup image for HD screens
		[Embed(source="/startup/progressbar-x2.png")]
			private static var ProgressBarAtlas2x:Class;
		
		private var onHolder:Sprite;
		private var on:Image;

		private var offHolder:Sprite;
		private var off:Image;
        
		private var progress:Number = 0;
		
		private var barWidth:int;
		private var bmp:Bitmap;
		
		public function ProgressBar(scaleFactor:int)
		{
			barWidth = AppConstants.SAFE_WIDTH / 5 * 3;
			
			bmp = scaleFactor == 1 ? new ProgressBarAtlas1x() : new ProgressBarAtlas2x();
			ProgressBarAtlas1x = ProgressBarAtlas2x = null; // no longer needed!
			
			var atlas:Texture = Texture.fromBitmap( bmp );
			
			on = new Image( atlas );
			on.pivotX = on.width / 2;
			on.pivotY = on.height / 4 * 3;

			off = new Image( atlas );
			off.pivotX = off.width / 2;
			off.pivotY = off.height / 4;

			// image aspect ratio is 492 x 60
			on.width = off.width = barWidth;
			on.height = off.height = on.width * 60 / 492;
			
			onHolder = new Sprite();
			addChild(onHolder);
			onHolder.addChild(on);

			onHolder.clipRect = new Rectangle( 
				on.x - on.width / 2, 
					on.y - on.height / 4,
						0, on.height / 2 - 1 );
			
			offHolder = new Sprite();
			addChild(offHolder);
			offHolder.addChild(off);

			offHolder.clipRect = new Rectangle( 
				off.x - off.width / 2, 
				off.y - off.height / 4,
				barWidth, 
				off.height / 2 - 1 
			);
			
		}
        
		public function set ratio(ratio:Number):void 
		{ 
			if ( ratio < .08 ) ratio = .08;
			onHolder.clipRect.width = barWidth * ratio;
			offHolder.clipRect.x = barWidth * ratio - off.x - off.width / 2;
			offHolder.clipRect.width = barWidth * (1 - ratio);
		}
		
		public function destroy():void
		{
			on.removeFromParent(true);
			off.removeFromParent(true);
			on.dispose();
			off.dispose();
			bmp.bitmapData.dispose();
			bmp = null;
			removeFromParent(true);
		}
	}
}