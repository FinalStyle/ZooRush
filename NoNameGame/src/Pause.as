package
{
	import Engine.Locator;
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class Pause
	{
		public var model:MovieClip;
		public var black:MovieClip;
		public var pause:Boolean;
		public var reset:Boolean=false;
		public var continuar:Boolean=false;
		public var resetgame:Boolean=false;
	
		public function Pause()
		{
				
		}
		
		protected function keyUp(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.ENTER:
				{
					
					break;
				}
				
			}
			
		}
		
		protected function keyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.ENTER:
				{
					
					break;
				}
				
			}
		}		
		
		public function pauseon(x:Number, y:Number):void
		{
			model=Locator.assetsManager.getMovieClip("MC_Pause");
			black=Locator.assetsManager.getMovieClip("MC_Black");
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			Locator.mainStage.addChild(black);
			black.alpha=0.4;
			Locator.mainStage.addChild(model);
			model.x=x;
			model.y=y;
		}
		
		public function pausedoff():void
		{
			Locator.mainStage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			Locator.mainStage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
			Locator.mainStage.removeChild(black);
				Locator.mainStage.removeChild(model);
		}
	}
}