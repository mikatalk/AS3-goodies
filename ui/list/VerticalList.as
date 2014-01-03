package
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class VerticalList extends Sprite
	{
		
		private var cells:Vector.<ListCell> = new Vector.<ListCell>();
		
		private var quadLeft:Quad;
		private var quadRight:Quad;
		
		private const MAX_SPEED:Number = 600;
		private const FRICTION:Number = 600;
		private var velocity:Number = 0;
		private var previousMovement:int;
		private var touchDown:Boolean;
		
		private var stationaryReference:Point = new Point();// is set on touch down and checked on touch up to detect stationary click
		public static var CELL_SELECTED:String = "eventFontSelected";
		
		
		public function VerticalList(w:int, h:int, data:Vector.<ListCellVO>)
		{
			super();
			
			var debug:Quad = new Quad(w, h, 0xc3c3c3);
			addChild(debug);
			
			clipRect = new Rectangle(0, 0, w, h);
			
			for ( var i:int = 0; i < data.length; i++ ) {
				trace(i);
				cells[i] = new ListCell();
				cells[i].setCell(data[i].id, data[i].title, data[i].price, data[i].purchased);
				addChild(cells[i]);
				cells[i].y = ListCell.HEIGHT * i;
			}
			
		}
		
		public function update(event:EnterFrameEvent):void
		{
			if ( velocity > 0 ) {
				velocity -= FRICTION * event.passedTime; 
				if ( velocity < 0 ) velocity = 0; 
			}
			if ( velocity < 0 ) {
				velocity += FRICTION * event.passedTime; 
				if ( velocity > 0 ) velocity = 0; 
			}
			
			const totalHeight:int = ListCell.HEIGHT * cells.length;
			for ( var i:int = 0; i < cells.length; i++ ) {
				if ( !touchDown ) cells[i].y += velocity * event.passedTime;
				if ( cells[i].y < -totalHeight / 2 ) {
					cells[i].y += totalHeight;
				} else if ( cells[i].y > totalHeight / 2 ) {
					cells[i].y -= totalHeight;
				}
			}
		}
		
		public function onTouch(event:TouchEvent):void
		{
			var i:int;
			var touch:Touch = event.getTouch(this);
			if ( touch ) {
				if ( touch.phase == TouchPhase.MOVED ) {
					
					var movement:Point = touch.getMovement(this, movement);
					
					for ( i = 0; i < cells.length; i++ ) {
						
						cells[i].y += movement.y;
						
						velocity += movement.y;
						
						if ( previousMovement >= 0 && movement.y < 0 ) velocity = 0;
						else if ( previousMovement <= 0 && movement.y > 0 ) velocity = 0;
						
						if ( velocity > MAX_SPEED ) {
							velocity = MAX_SPEED;
						}
						if ( velocity < -MAX_SPEED ) {
							velocity = -MAX_SPEED;
						}
						
						previousMovement = movement.y;
						
					}
					
				} else if ( touch.phase == TouchPhase.BEGAN ) {
					touchDown = true;
					previousMovement = 0;
					stationaryReference.x = touch.globalX;
					stationaryReference.y = touch.globalY;
				} else if ( touch.phase == TouchPhase.ENDED ) {
					touchDown = false;
					previousMovement = 0;
					if ( stationaryReference.x <= touch.globalX + 10 && stationaryReference.x >= touch.globalX - 10 
						&& stationaryReference.y <= touch.globalY + 10 && stationaryReference.y >= touch.globalY - 10 ) {
						
						for ( i= 0; i < cells.length; i++ ) {
							if ( event.getTouch(cells[i]) !== null ) 
								dispatchEventWith(CELL_SELECTED, true, i);
						}
					}
				}
			}
		}
		
		public function reset():void
		{
			touchDown = false;
		}
		
		public function impulse():void
		{
			velocity = MAX_SPEED;
		}
	}
}