package
{
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;
    import starling.utils.RectangleUtil;

    public class TouchSheet extends Sprite
    {
			
			public static const EVENT_UPDATE_POSITION:String = "eventUpdatePosition";
			public static const EVENT_DRAG_START:String = "eventDragStart";
			public static const EVENT_DRAG_STOP:String = "eventDragStop";
		
			private var contents:Image;
		
    	public function TouchSheet()
    	{
      	addEventListener(TouchEvent.TOUCH, onTouch);
        useHandCursor = true;
      }
		
			private function onTouch(event:TouchEvent):void
			{
				var touches:Vector.<Touch> = event.getTouches(this);
			
				if (touches.length == 1)
				{
					// one finger touching -> move
					var delta:Point = touches[0].getMovement(parent);
					x += delta.x;
					y += delta.y;
				
					dispatchEventWith(EVENT_UPDATE_POSITION);
				
				}            
				else if (touches.length == 2)
				{
					// two fingers touching -> rotate and scale
					var touchA:Touch = touches[0];
					var touchB:Touch = touches[1];
					
					var currentPosA:Point  = touchA.getLocation(parent);
					var previousPosA:Point = touchA.getPreviousLocation(parent);
					var currentPosB:Point  = touchB.getLocation(parent);
					var previousPosB:Point = touchB.getPreviousLocation(parent);
				
					var currentVector:Point  = currentPosA.subtract(currentPosB);
					var previousVector:Point = previousPosA.subtract(previousPosB);
				
					var currentAngle:Number  = Math.atan2(currentVector.y, currentVector.x);
					var previousAngle:Number = Math.atan2(previousVector.y, previousVector.x);
					var deltaAngle:Number = currentAngle - previousAngle;
				
					// update pivot point based on previous center
					var previousLocalA:Point  = touchA.getPreviousLocation(this);
					var previousLocalB:Point  = touchB.getPreviousLocation(this);
					pivotX = (previousLocalA.x + previousLocalB.x) * 0.5;
					pivotY = (previousLocalA.y + previousLocalB.y) * 0.5;
				
					// update location based on the current center
					x = (currentPosA.x + currentPosB.x) * 0.5;
					y = (currentPosA.y + currentPosB.y) * 0.5;
				
					// rotate
					rotation += deltaAngle;
				
					// scale
					var sizeDiff:Number = currentVector.length / previousVector.length;
					scaleX *= sizeDiff;
					scaleY *= sizeDiff;
				
					dispatchEventWith(EVENT_UPDATE_POSITION);
				}
			
				var touch:Touch = event.getTouch(this);
			
				if ( touch ) {
					if ( touch.phase == TouchPhase.BEGAN ) 
						dispatchEventWith(EVENT_DRAG_START);
					else if ( touch.phase == TouchPhase.ENDED ) 
						dispatchEventWith(EVENT_DRAG_STOP);
				}
		}
		
		public function updateContents(texture:Texture):void
    {
			if (contents !== null) {
				removeChild(contents);
				contents.texture.dispose();
				contents.dispose();
				contents = null;
			}
			contents = new Image(texture);
			contents.pivotX = contents.width >> 1;
			contents.pivotY = contents.height >> 1;
			
			var port:Rectangle = RectangleUtil.fit( 
				new Rectangle(0,0,texture.width, texture.height),
				new Rectangle(0, 0, 300, 340)
			);
			
			contents.width = port.width;
			contents.height = port.height;
			contents.x = 0;
			contents.y = 0;
			addChild(contents);
			
			scaleX = scaleY = 1;	
		}
        
		public override function dispose():void
  	{
    	removeEventListener(TouchEvent.TOUCH, onTouch);
      super.dispose();
    }
		
		public function disposeContents():void
		{
			contents.dispose();
		}
	}
}