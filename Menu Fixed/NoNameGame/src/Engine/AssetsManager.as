package Engine
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.LocationChangeEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	[Event(name="complete", type="flash.events.Event", backgroundColor="000000")]
	public class AssetsManager extends EventDispatcher
	{
		public var allAssets:Dictionary = new Dictionary();
		public var loaderLinks:URLLoader;
		public var allSWFs:Vector.<Loader> = new Vector.<Loader>();
		public var allURLsOfTexts:Vector.<String> = new Vector.<String>();
		public var linksForLoad:Array=new Array();
		public var linksForLoadName:Array = new Array();
		
		public var preload:MCPreload = new MCPreload();
		public var assetsTotal:int;
		public var assetsLoaded:int;
		
		
		public function AssetsManager()
		{
			trace("Inicializando AssetsManager...");
		}
		
		public function loadLinks(url:String):void
		{
			Locator.mainStage.addChild(preload);
			
			
			preload.mc_current.gotoAndStop(1);
			preload.mc_global.gotoAndStop(1);
			
			loaderLinks = new URLLoader();
			loaderLinks.dataFormat = URLLoaderDataFormat.VARIABLES;
			loaderLinks.load(new URLRequest(url));
			loaderLinks.addEventListener(Event.COMPLETE, evFileWithLinksComplete);
			
			
		}
		
		protected function evFileWithLinksComplete(event:Event):void
		{
			
			for(var varName:String in loaderLinks.data)
			{
				/*trace (escape(loaderLinks.data[varName]))*/ //muestr LOS ESPACIOS
				linksForLoad.push(escape(loaderLinks.data[varName]).split("%0D%0A")[0]);
				
				linksForLoadName.push(varName);
				/*trace (escape(loaderLinks.data[varName]))*/ //muestr LOS ESPACIOS
			}
			
			//Seteamos la cantidad de assets a cargar.
			assetsTotal = linksForLoad.length;
			
			trace(linksForLoad);
			
			/*		trace(loaderLinks.data.redpanda);*/
			
			loadAsset(linksForLoad[0], linksForLoadName[0]);
		}
		
		public function loadAsset(link:String, name:String):void
		{
			
			var realLink:String = "engine/" + link;
			var folder:String = link.split("/")[0];
			trace (folder)
			trace (realLink, "reallink")
			switch(folder)
			{
				case "images":
				
					var loaderImage:Loader = new Loader();
					loaderImage.load(new URLRequest(realLink));
					loaderImage.contentLoaderInfo.addEventListener(Event.COMPLETE, evAssetComplete);
					loaderImage.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, evError);
					loaderImage.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, evProgress);
					allAssets[name] = loaderImage;
					break;
				
				case "sounds":
				
					var loaderSound:Sound = new Sound();
					loaderSound.load(new URLRequest(realLink));
					loaderSound.addEventListener(Event.COMPLETE, evAssetComplete);
					loaderSound.addEventListener(IOErrorEvent.IO_ERROR, evError);
					loaderSound.addEventListener(ProgressEvent.PROGRESS, evProgress);
					allAssets[name] = loaderSound;
					break;
				
				case "texts":
					trace("entro a texts")
					var loaderText:URLLoader = new URLLoader();
					loaderText.load(new URLRequest(realLink));
					loaderText.addEventListener(Event.COMPLETE, evAssetComplete);
					loaderText.addEventListener(IOErrorEvent.IO_ERROR, evError);
					loaderText.addEventListener(ProgressEvent.PROGRESS, evProgress);
					allAssets[name] = loaderText;
					allURLsOfTexts.push(link);
					break;
				
				case "swfs":
					
					var loaderSWF:Loader = new Loader();
					loaderSWF.load(new URLRequest(realLink));
					loaderSWF.contentLoaderInfo.addEventListener(Event.COMPLETE, evAssetComplete);
					loaderSWF.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, evError);
					loaderSWF.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, evProgress);
					allSWFs.push(loaderSWF);
					break;
			}
		}
		
		protected function evAssetComplete(event:Event):void   //una vez terminada la carga se llama a la funcion de start game
		{
		
			event.currentTarget.removeEventListener(Event.COMPLETE, evAssetComplete);
			event.currentTarget.removeEventListener(ProgressEvent.PROGRESS, evProgress);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, evError);
			
			//Sumamos un asset cargado.
			assetsLoaded++;
			
			//Actualizamos el valor de carga global.
			var percentage:int = assetsLoaded * 100 / assetsTotal;
			preload.mc_global.gotoAndStop(percentage);
			trace(percentage)
			trace("1 Asset Cargado...");
			
			//Borro el link que ya se cargó.
			linksForLoad.splice(0, 1);
			linksForLoadName.splice(0, 1);
			
			//Hay más links para cargar?
			if(linksForLoad.length > 0)
			{
				loadAsset(linksForLoad[0], linksForLoadName[0]);
			}else
			{
				//trace("CARGA COMPLETA");
				Locator.mainStage.removeChild(preload);
				dispatchEvent(new Event(Event.COMPLETE));
				trace("Carga Completa")
				//START GAME
			}
		}
		protected function evProgress(event:ProgressEvent):void
		{
			//trace(event.bytesLoaded, event.bytesTotal);
			var percentage:int = event.bytesLoaded * 100 / event.bytesTotal;
			preload.mc_current.gotoAndStop(percentage);
		}
		
		protected function evError(event:IOErrorEvent):void
		{
			trace("Error")
			Locator.console.open();
			Locator.console.writeLn("Hubo un error en la carga");
		}
		public function getImage(name:String):Bitmap   //Estas funciones se utilizan para crear isntancias de los archivos cargados, 
		                                               //se necesitan cada vez que creemos una var de un movieclip o otro archivo
		{
			var myLoader:Loader = allAssets[name];
			if(myLoader != null) //Existe?
			{
				var bmpTemp:Bitmap;
				var bmpDataTemp:BitmapData;
				
				bmpDataTemp = new BitmapData(myLoader.width, myLoader.height, true, 0x000000);
				bmpDataTemp.draw(myLoader);
				
				bmpTemp = new Bitmap(bmpDataTemp);
				
				return bmpTemp;
			}
			
			return null;
		}
		public function getSound(name:String):Sound
		{
			var mySound:Sound = allAssets[name];
			if(mySound != null)
			{
				return mySound;
			}
			
			return null;
		}
		
		public function getText(name:String):String
		{
			var myText:URLLoader = allAssets[name];
			if(myText != null)
			{
				return myText.data;
			}
			
			return null;
		}
		
		public function getMovieClip(name:String):MovieClip
		{
			for (var i:int = 0; i < allSWFs.length; i++) 
			{
				//Esto es porque si getDefinition no encuentra el nombre, CRASHEA directamente.
				try
				{
					//Obtengo LA CLASE (no la instancia), del objeto guardado en el SWF.
					var myClass:Class = allSWFs[i].contentLoaderInfo.applicationDomain.getDefinition(name) as Class;
					return new myClass(); //Genero una instancia de la clase obtenida.
				}catch(e1:ReferenceError)
				{
					
				}
			}
			
			
			return null;
		}
		
	}
}