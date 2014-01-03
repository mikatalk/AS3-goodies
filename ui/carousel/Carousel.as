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
	
	public class Carousel extends Sprite
	{
		
		private const NUM_BOXES:int = 4;
		private const LEFT_OFFSET:Number = - 213.1;
		private const RIGHT_OFFSET:Number = 211.4;
		private const RECT_WIDTH:Number =  RIGHT_OFFSET - LEFT_OFFSET - 2;
		
		private var boxes:Vector.<CarouselBox> = new Vector.<CarouselBox>(NUM_BOXES);
		
		private var quadLeft:Quad;
		private var quadRight:Quad;

		private const MAX_SPEED:Number = 900;
		private const FRICTION:Number = 250;
		private var velocity:Number = 0;
		private var previousMovement:int;
		private var touchDown:Boolean;
		
		private var stationaryReference:Point = new Point();// is set on touch down and checked on touch up to detect stationary click
		
		public function Carousel()
		{
			super();

			clipRect = new Rectangle(LEFT_OFFSET+1, -60, RECT_WIDTH, 160);
			
			for ( var i:int = 0; i < NUM_BOXES; i++ ) {
				boxes[i] = new CarouselBox(i, MastersHandler.getRandomUserHead());
				addChild(boxes[i]);
				boxes[i].x = -170 + 165 * i;
			}
			
			quadLeft = new Quad(30, CarouselBox.BOX_HEIGHT + 60, 0xFFFFFF, true);
			quadLeft.setVertexAlpha( 1, 0 );
			quadLeft.setVertexAlpha( 3, 0 );
			quadLeft.pivotX = 0;
			quadLeft.pivotY = CarouselBox.BOX_HEIGHT / 2 + 10;
			quadLeft.x = LEFT_OFFSET;
			addChild(quadLeft);
			
			quadRight = new Quad(30, CarouselBox.BOX_HEIGHT + 60, 0xFFFFFF, true);
			quadRight.setVertexAlpha( 0, 0 );
			quadRight.setVertexAlpha( 2, 0 );
			quadRight.pivotX = quadRight.width;
			quadRight.pivotY = CarouselBox.BOX_HEIGHT / 2 + 10;
			quadRight.x = RIGHT_OFFSET;
			addChild(quadRight);
			
		}
		
		public function start():void
		{
			for ( var i:int = 0; i < NUM_BOXES; i++ ) 
				boxes[i].cast( MastersHandler.getRandomUserHead() );
			touchDown = false;
			velocity = -350;
			addEventListener( EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function stop():void
		{
			for ( var i:int = 0; i < NUM_BOXES; i++ ) 
				boxes[i].cast( CommonObjects.getEmptyTexture() );
			removeEventListener( EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			removeEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var i:int;
			var touch:Touch = event.getTouch(this);
			if ( touch ) {
				if ( touch.phase == TouchPhase.MOVED ) {
					
					var movement:Point = touch.getMovement(this, movement);

					for ( i = 0; i < NUM_BOXES; i++ ) {
						
						boxes[i].x += movement.x;
						
						velocity += movement.x;
						
						if ( previousMovement >= 0 && movement.x < 0 ) velocity = 0;
						else if ( previousMovement <= 0 && movement.x > 0 ) velocity = 0;
						
						if ( velocity > MAX_SPEED ) {
							velocity = MAX_SPEED;
						}
						if ( velocity < -MAX_SPEED ) {
							velocity = -MAX_SPEED;
						}
						
						previousMovement = movement.x;
						
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
						
						for ( i= 0; i < NUM_BOXES; i++ ) {
							if ( event.getTouch(boxes[i]) !== null ) 
								boxes[i].getLink();
						}
					}
				}
			}
		}
		
		private function onEnterFrame(event:EnterFrameEvent):void
		{
			
			if ( velocity > 0 ) {
				velocity -= FRICTION * event.passedTime; 
				if ( velocity < 0 ) velocity = 0; 
			}
			if ( velocity < 0 ) {
				velocity += FRICTION * event.passedTime; 
				if ( velocity > 0 ) velocity = 0; 
			}
			
			const totalWidth:int = 165 * boxes.length;
			for ( var i:int = 0; i < NUM_BOXES; i++ ) {
				if ( !touchDown ) boxes[i].x += velocity * event.passedTime;
				if ( boxes[i].x < -totalWidth / 2 ) {
					boxes[i].x += totalWidth;
				} else if ( boxes[i].x > totalWidth / 2 ) {
					boxes[i].x -= totalWidth;
				}
			}
		}
	}
}