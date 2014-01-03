package
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class CarouselBox extends Sprite
	{
		public static var BOX_WIDTH:int = 146;
		public static var BOX_HEIGHT:int = 110;
		
		public var image:Image;
		public var hotSpot:Quad;		
		public var thumbIndex:int;
		
		public const THUMBS:Array = 
		[
			{
				title: "title",
				link: ""
			},
			{
				title: "title",
				link: ""
			},
			{
				title: "title",
				link: ""
			},
			{
				title: "title",
				link: ""
			}
		];
			
		public function CarouselBox(thumbIndex:int, imageTexture:Texture)
		{
			super();
			
			this.thumbIndex = thumbIndex;
			
			var bg:Quad = new Quad( BOX_WIDTH, BOX_HEIGHT, 0xC3C3C3, false );
			bg.pivotX = bg.width >> 1;
			bg.pivotY = bg.height >> 1;
			addChild( bg );
			
			image = new Image( imageTexture );
			image.pivotX = image.width >> 1;
			image.pivotY = image.height >> 1;
			addChild(image);
			
			hotSpot = new Quad( BOX_WIDTH + 20, BOX_HEIGHT + 80, 0x00FF00);
			hotSpot.pivotX = hotSpot.width >> 1;
			hotSpot.pivotY = hotSpot.height >> 1;
			hotSpot.alpha = 0;
			addChild(hotSpot);
		}
		
		public function getLink():void
		{
			navigateToURL( new URLRequest( THUMBS[thumbIndex].link ) )
		}
	}
}