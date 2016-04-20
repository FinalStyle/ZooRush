package Engine
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	


	public class Console
	{
		public var model:Mc_Console;
		public var keyopen:int;
		public var isopen:Boolean;
		public var allCommands:Dictionary=new Dictionary();
		public function Console()
		{
			trace ("inicializando conbsola.");
			model=new Mc_Console;
			keyopen=Keyboard.F8;
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_UP, ev_keyup);
			
			
		}
		
		protected function ev_keyup(event:KeyboardEvent):void
		{
			if(event.keyCode==keyopen)
			{
				!isopen ? open() : close();
				 isopen=!isopen ;
			}else if(isopen && event.keyCode == Keyboard.ENTER)
			{
				execComand();
				model.Texto1.text = "";
			}
			
		}
		
		public function registerCommand (name:String, command:Function, description:String, numArgs:int):void  //registra los comandos, se puede hacer esto desde el main del mismo juego.
		{
			var cData:CommandData = new CommandData();
			cData.name=name;
			cData.command=command;
			cData.description=description;
			cData.numArgs=numArgs;
			
			allCommands[name] = cData;
			
		}
		
		public function unregisterCommand(name:String):void
		{
			delete allCommands[name];
		}
		public function write(text:String):void   //dado una accion, esta funcion se utiliza para informar al g=jugador la consecuencia de esa accion.
		{
			model.Text2.text += text;
		}
		
		public function writeLn(text:String):void   
		{
			write(text + "\n");
		}
		
		public function open():void
		{
			
			model.Texto1.text = "";
			Locator.mainStage.addChild(model)
			Locator.mainStage.focus = model.Texto1;
			
			
		}
		protected function close():void
		{
			model.Texto1.text = "";
			Locator.mainStage.removeChild(model);
			Locator.mainStage.focus=Locator.mainStage;
			
		}
		
		public function execComand(): void
		{
			var textParsed:Array=model.Texto1.text.split(" ");
			var commandName:String=textParsed[0];
			var temp:CommandData = allCommands [commandName];
			
			textParsed.splice(0, 1); //Elimino el nombre del comando. //porque lo elimino?
			
			if(temp != null)
			{
				try
				{
					temp.command();
				}catch(e1:ArgumentError)
				{
					try
					{
						temp.command.apply(this, textParsed);
					}catch(e3:Error)
					{
						writeLn("Cantidad de parámetros incorrecta.");
					}
				}catch(e2:Error)
				{
					writeLn("Problemas existenciales al ejecutar la funcion.");
				}
			}else
			{
				writeLn("El comando no existe.");
			}
		}
			
			
		}
	    
	    
	
}