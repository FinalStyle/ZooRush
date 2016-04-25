package Engine
{
	import flash.display.Sprite;
	import flash.display.Stage;
	
	
	
	public class Locator extends Sprite
	{
		
		public static var mainStage:Stage;
		public static var console:Console;
		public static var assetsManager:AssetsManager;
		
		public function Locator()
		{
			mainStage = stage;
			console = new Console();
			assetsManager = new AssetsManager();
			trace("*** Engine Inicializado ***");
		}
		
	}
}