package
{
	import Engine.Locator;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Camera
	{
		public var view:Sprite;
		public var currentTarget:Number = 1;
		public var delayZoom:Number = 20;
		
		
		public function Camera()
		{
			view = new Sprite();
		}
		
		public function on():void
		{
			Locator.mainStage.addChild(view);
		}
		
		public function off():void
		{
			Locator.mainStage.removeChild(view);
		}
		
		public function addToView(obj:Sprite):void
		{
			view.addChild(obj);
		}
		
		public function removeToView(obj:Sprite):void
		{
			view.removeChild(obj);
		}
		
		public function set zoom(value:Number):void
		{
			if(value > 0)
			{
				view.scaleX = view.scaleY = value;
			}else{
				throw new Error("El zoom no puede ser 0 o menos.");
			}
		}
		
		public function get zoom():Number
		{
			return view.scaleX;
		}
		
		public function set smoothZoom(value:Number):void
		{
			currentTarget = value;
			Locator.mainStage.addEventListener(Event.ENTER_FRAME, evRefreshCameraZoom);
		}
		
		protected function evRefreshCameraZoom(event:Event):void
		{
			zoom += (currentTarget - zoom) / delayZoom;
			if(Math.abs( (currentTarget - zoom) ) < 0.0002)
			{
				zoom = currentTarget;
				Locator.mainStage.removeEventListener(Event.ENTER_FRAME, evRefreshCameraZoom);
			}
			
		}
		
		public function set x(value:Number):void
		{
			view.x = -value;
		}
		
		public function get x():Number
		{
			return -view.x;
		}
		
		public function set y(value:Number):void
		{
			view.y = -value;
		}
		
		public function get y():Number
		{
			return -view.y;
		}
		
		public function lookAt(obj:Sprite):void
		{
			var pLocal:Point = new Point(obj.x, obj.y);
			var pGlobal:Point = obj.parent.localToGlobal(pLocal);
			var pCamera:Point = view.globalToLocal(pGlobal);
			
			
			x = pCamera.x * zoom - Locator.mainStage.stageWidth/2;
			y = pCamera.y * zoom - Locator.mainStage.stageHeight/2;
		}
	}
}