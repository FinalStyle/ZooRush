package
{
	import Engine.Locator;
	
	import flash.display.MovieClip;
	import flash.events.Event;
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
		public var optionnumber:int=1;
		public var currentlevel:String;
		
		public function Pause()
		{
			
		}
		
		protected function keyUp(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				
				
				case Keyboard.W:
					
					if (optionnumber>1)
					{
						optionnumber--
						Main.instance.audioselection = new SoundController(Main.instance.selectionsound);
						Main.instance.audioselection.play(0);
					}
					
					break;
				
				
				case Keyboard.S:
					
					if (optionnumber<3)
					{
						optionnumber++
						Main.instance.audioselection = new SoundController(Main.instance.selectionsound);
						Main.instance.audioselection.play(0);
					}
					break;
				
				
				case Keyboard.ENTER:
					if (optionnumber==1)
					{
						pausedoff()
						Main.instance.audioselection = new SoundController(Main.instance.aceptarsounds);
						Main.instance.audioselection.play(0);
					}
					else if(optionnumber==2)
					{
						
						pausedoff()						
						Main.instance.destroyall()
						Main.instance.evStartGame(currentlevel)
						Main.instance.audioselection = new SoundController(Main.instance.aceptarsounds);
						Main.instance.audioselection.play(0);
					}
					else
					{
						pausedoff()
						Main.instance.destroyall()
						Locator.resetassets()
						Main.instance.mainfunction();
						Main.instance.audioselection = new SoundController(Main.instance.aceptarsounds);
						Main.instance.audioselection.play(0);
					}
					
					break;
				
				
			}
			
		}
		public function getlevel(level:String):void
		{
			currentlevel=level;
		}
		
		protected function keyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.W:
					
					break;
				
				
				case Keyboard.S:
					
					
					break;
				
				
				case Keyboard.ENTER:
					
					
					break;
				
			}
		}		
		
		public function pauseon(x:Number, y:Number):void
		{
			model=Locator.assetsManager.getMovieClip("MC_Pause");
			black=Locator.assetsManager.getMovieClip("MC_Black");
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			Locator.mainStage.addEventListener(Event.ENTER_FRAME, update)
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			Locator.mainStage.addChild(black);
			black.alpha=0.4;
			Locator.mainStage.addChild(model);
			model.x=x;
			model.y=y;
			Main.instance.pauseboolean=true;
			model.MC_restart.alpha=0;
			model.MC_exit.alpha=0;
			
		}
		
		protected function update(event:Event):void
		{
			switch(optionnumber)
			{
				case 1:
				{
					model.MC_continue.alpha=1;
					model.MC_restart.alpha=0;
					model.MC_exit.alpha=0;
					break;
				}
				case 2:
				{
					model.MC_continue.alpha=0;
					model.MC_restart.alpha=1;
					model.MC_exit.alpha=0;
					break;
				}
				case 3:
				{
					model.MC_continue.alpha=0;
					model.MC_restart.alpha=0;
					model.MC_exit.alpha=1;
					break;
				}
					
			}
		}
		
		public function pausedoff():void
		{
			Locator.mainStage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			Locator.mainStage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
			Locator.mainStage.removeChild(black);
			Locator.mainStage.removeChild(model);
			Main.instance.pauseboolean=false;
		}
	}
}