package
{
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class Slider extends Sprite
	{
		
		private var hotSpot:Quad;
		public var bar:Quad;
		public var grab:Quad;
		
		public function Slider(w:int, h:int)
		{
			super();
			
			bar = new Quad ( w - 20, h- 30, 0xFF00FF );
			bar.x = 10;
			bar.y = h/2;
			bar.pivotY = bar.height/2;
			addChild(bar);
			
			grab = new Quad( 10, 10, 0xFFFFFF );
			grab.pivotX = grab.pivotY = 5;
			grab.x = bar.x;
			grab.y = h/2;
			grab.pivotY = grab.height/2;
			addChild(grab);

			hotSpot = new Quad( w, h, 0x00FFFF );
			addChild(hotSpot);
			hotSpot.alpha = .4;
			
			update(1);
		}
		
		public function update(ratio:Number):void
		{
			grab.x = grab.width/2 + bar.x + ratio * (bar.width-grab.width);
		}
		
	}
}