package
{
	import Engine.Locator;
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class Pause
	{
		public var pause:Boolean;
		public var reset:Boolean=false;
		public var continuar:Boolean=false;
		public var reset:Boolean=false;
		public function Pause()
		{
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown)
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_UP, keyUp)		
		}
		
		protected function keyUp(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.ENTER:
				{
					up=false;
					canJump=true;
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
					up=true;
					break;
				}
				
			}
		}		
		
		public function pauseon():void
		{
			
		}
		
		public function pausedoff():void
		{
			
		}
	}
}