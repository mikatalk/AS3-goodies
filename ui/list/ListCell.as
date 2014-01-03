package 
{
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class ListCell extends Sprite
	{
		
		public static var WIDTH:int = 300;
		public static var HEIGHT:int = 60;
		
		public var hotSpot:Quad;
		public var title:TextField;
		public var id:int;
		public var price:int;
		public var purchased:Boolean;
		
		
		public function ListCell()
		{
			super();
			hotSpot = new Quad(WIDTH, HEIGHT-4, 0xFFFFFF);
			hotSpot.y = 2;
			addChild(hotSpot);
			
			title = new TextField(WIDTH/3*2, HEIGHT-4, "", "", 20, 0);
			title.pivotX = title.width / 2;
			title.pivotY = title.height / 2;
			title.hAlign = "left";
			title.x = hotSpot.x + title.width/2;
			title.y = hotSpot.y + title.height/2;
			addChild(title);
		}
		
		public function setCell(id:int, title:String, price:int, purchased:Boolean):void
		{
			this.id = id;
			this.title.text = title;
			this.price = price;
			this.purchased = purchased;
		}
	}
}