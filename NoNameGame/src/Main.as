package
{
	import Characters.RedPanda;
	
	import Engine.Locator;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	import flash.text.engine.Kerning;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	
	[SWF(height="720", width="1280", frameRate="60")]
	public class Main extends Locator
	{		
		public var player:Hero;
		public var player2:Hero;
		public var level:MovieClip;
		public var camLookAt:MovieClip;
		
		
		
		public var allPlatformsOfLevel1:Array;
		public var allWallsOfLevel1:Array;
		
		public var allPlayers:Vector.<Hero>;
		
		//////////////////////////////////////CameraSet////////////////////////////////////////////
		public var midPointScreen:Point;
		public var mid2Players:Point;
		public var playersGlobalPositions:Vector.<Point>;
		public var playersLocalPositions:Vector.<Point>;
		public var playersLastLocalsPositions:Vector.<Point>;
		public var canZoom:Boolean;
		public var cam:Camera;
		public var sideLimitsX:Number;
		public var w:Boolean;
		public var s:Boolean;
		public var menu1:MovieClip;
		public var menu2:MovieClip;
		///////////////////////////////////////////////////////////////////////////////////////////
		
		public function Main()
		{
			Locator.assetsManager.loadLinks("linksleveltry.txt");
			Locator.assetsManager.addEventListener(Event.COMPLETE, evMainMenu);
			
		}
		
		
		public function evMainMenu(event:Event):void
		{
			
			menu1=Locator.assetsManager.getMovieClip("MC_Menu1");
			menu2=Locator.assetsManager.getMovieClip("MC_Menu2");
			Locator.mainStage.addChild(menu1)
			menu1.MC_creditos.alpha=0
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_UP, keyUp)
		}
		
		
		
		protected function keyUp(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.W:
				{
					if (Locator.mainStage.contains(menu1))
					{
						menu1.MC_creditos.alpha=0	
					}
					else
					{
						menu2.MC_level2.alpha=0	
					}
					w=true;
					s=false;
					
				}
				case Keyboard.S:
				{
					s=true;
					w=false;
				}
				case Keyboard.ENTER:
				{
					if (w=true&&Locator.mainStage.contains(menu1))
					{
						Locator.mainStage.removeChild(menu1)
						Locator.mainStage.addChild(menu2)
					}
					else if (w=true&&Locator.mainStage.contains(menu2))
					{
						Locator.mainStage.removeChild(menu2)
						evStartGame("level1");
					}
					
				}
			}
			
		}
		public function evStartGame(level:String):void
		{
			
			allPlatformsOfLevel1 = new Array();
			allWallsOfLevel1= new Array();
			
			allPlayers= new Vector.<Hero>;
			
			//////////////////////////////////////CameraSet////////////////////////////////////////////
			midPointScreen = new Point(0, 0);
			mid2Players = new Point(0, 0);
			playersGlobalPositions = new Vector.<Point>;
			playersLocalPositions = new Vector.<Point>;
			playersLastLocalsPositions = new Vector.<Point>;
			canZoom = true;
			
			sideLimitsX=100;
			///////////////////////////////////////////////////////////////////////////////////////////
			
			cam = new Camera();
			cam.on();
			
			
			
			this.level=Locator.assetsManager.getMovieClip("MCLevel1");
			
			camLookAt= Locator.assetsManager.getMovieClip("MCBackGround");
			camLookAt.scaleX = camLookAt.scaleY = 0.05;
			camLookAt.alpha=0;
			this.level.addChild(camLookAt);
			
			
			
			cam.addToView(this.level);
			cam.lookAt(camLookAt)
			
			allPlatformsToArrayLevel1();
			allWallsToArrayLevel1();
			
			
			
			player = new RedPanda(Keyboard.W, Keyboard.S, Keyboard.D, Keyboard.A,Keyboard.SPACE, Keyboard.G);
			player2 = new RedPanda(Keyboard.UP, Keyboard.DOWN, Keyboard.RIGHT, Keyboard.LEFT, Keyboard.COMMA, Keyboard.M);
			
			
			
			
			
			player.spawn(200, this.level);
			player2.spawn(Locator.mainStage.stageWidth-200, this.level);
			
			mid2Players.x = (player.model.x + player2.model.x)/2
			mid2Players.y = (player.model.y + player2.model.y)/2
			allPlayers.push(player)
			allPlayers.push(player2)
			getPlayerPositionFromLocalToGlobal(player);
			getPlayerPositionFromLocalToGlobal(player2);
			
			Locator.mainStage.addEventListener(Event.ENTER_FRAME, update)
			Locator.mainStage.addEventListener(MouseEvent.CLICK, offCamera);
			
		}
		
		protected function offCamera(event:MouseEvent):void
		{
		}
		//////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////Zoom////////////////////////////////////////
		protected function zoomIn():void
		{
			cam.smoothZoom = cam.zoom * 1.05;
			
		}
		
		protected function zoomOut():void
		{
			cam.smoothZoom = cam.zoom / 1.1;
		}		
		///////////////////////////////////////////////////////////////////////////////
		public function update(e:Event):void
		{	
			granadeCollitions()
			
			for (var i:int = 0; i < allPlayers.length; i++) 
			{
				allPlayers[i].Update();
			}
			
			cam.lookAt(camLookAt)
			/////////////////actualizo posiciones guardadas////////////////////
			checkCamera();
			updatePlayerGlobalPosition();
			///////////////////////////////////////////////////////////////////
			checkColitions(player);
			checkColitions(player2);
			if(cam.zoom>=1.4 || cam.zoom<=0.2)
			{
				canZoom=false
			}
			trace(cam.zoom);
			
			
		}
		public function getPlayerPositionFromLocalToGlobal(player:Hero):void
		{
			var pLocal:Point = new Point(0, 0);
			var pGlobal:Point;
			
			
			pLocal= new Point(player.model.x, player.model.y);
			pGlobal = player.model.parent.localToGlobal(pLocal);
			playersLocalPositions.push(pLocal);
			playersGlobalPositions.push(pGlobal);
			playersLastLocalsPositions.push(pLocal)
		}
		public function updatePlayerGlobalPosition():void
		{
			var tempPLocal:Point;
			var tempPGlobal:Point;
			
			for (var i:int = 0; i < allPlayers.length; i++) 
			{
				playersLastLocalsPositions[i]=playersLocalPositions[i];
				tempPLocal= new Point(allPlayers[i].model.x, allPlayers[i].model.y);
				tempPGlobal = allPlayers[i].model.parent.localToGlobal(tempPLocal);
				playersLocalPositions[i]=tempPLocal;
				playersGlobalPositions[i]=tempPGlobal;
			}
		}
		
		public function checkCamera():void
		{
			mid2Players.x = (player.model.x + player2.model.x)/2;
			mid2Players.y = (player.model.y + player2.model.y)/2;
			camLookAt.x= mid2Players.x;
			camLookAt.y= mid2Players.y;
			
			for (var i:int = 0; i < allPlayers.length; i++) 
			{
				var aquienresto:int;
				
				if(i==0)
				{
					aquienresto=1
				}
				else
				{
					aquienresto=0
				}
				
				if(playersGlobalPositions[i].x<sideLimitsX)
				{
					zoomOut()
					canZoom=true
				}
				else if(playersGlobalPositions[i].x>stage.stageWidth-sideLimitsX)
				{
					zoomOut()
					canZoom=true
				}
				else if(playersGlobalPositions[i].y<100 && canZoom)
				{
					zoomOut()
					canZoom=true
				}
				else if(playersGlobalPositions[i].y>stage.stageHeight-100 && canZoom)
				{
					zoomOut()
					canZoom=true
				}
				else if(playersLastLocalsPositions[i].x<playersLocalPositions[i].x && allPlayers[i].model.x - allPlayers[aquienresto].model.x<0 && canZoom)
				{
					//trace("playerlastlocal- " + playersLastLocalsPositions[i].x, "currentlocal- ",  playersLocalPositions[i].x, " i: ", i);
					zoomIn()
					canZoom=true
				}
				else if(playersLastLocalsPositions[i].x>playersLocalPositions[i].x && allPlayers[i].model.x - allPlayers[aquienresto].model.x>0 && canZoom)
				{
					//trace("playerlastlocal- " + playersLastLocalsPositions[i].x, "currentlocal- ",  playersLocalPositions[i].x, " i: ", i);
					zoomIn()
					canZoom=true
				}
			}			
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//****************************************** Colition Checks ***********************************************************//
		public function checkColitions(player:Hero):void
		{
			if(player.model.MC_botHitBox.hitTestObject(level.mc_floor))
			{
				player.fallSpeed=0;
				player.model.y=level.mc_floor.y-level.mc_floor.height;
				player.canJump=true;
			}
			for (var i:int = 0; i < allPlatformsOfLevel1.length; i++) 
			{
				if(player.model.MC_botHitBox.hitTestObject(allPlatformsOfLevel1[i]))
				{
					player.fallSpeed=0;
					player.model.y=allPlatformsOfLevel1[i].y-allPlatformsOfLevel1[i].height;
					player.canJump=true;
				}				
			}
			for (var j:int = 0; j < allWallsOfLevel1.length; j++) 
			{
				if(player.model.MC_sideHitBox.hitTestObject(allWallsOfLevel1[j]))
				{
					player.canmove=false;
					
				}
			}
		}
		public function allPlatformsToArrayLevel1():void
		{
			for (var i:int = 0; i < level.numChildren; i++) 
			{
				if(level.getChildAt(i).name=="mc_platform")
				{
					allPlatformsOfLevel1.push(level.getChildAt(i));
				}
			}
		}
		public function allWallsToArrayLevel1():void
		{
			for (var i:int = 0; i < level.numChildren; i++) 
			{
				if(level.getChildAt(i).name=="mc_wall")
				{
					allWallsOfLevel1.push(level.getChildAt(i));
				}
			}
		}	
		public function granadeCollitions():void
		{
			for (var j:int = 0; j < allPlayers.length; j++) 
			{
				for (var i:int = 0; i < allPlayers[j].granades.length; i++) 
				{
					for (var k:int = 0; k < allPlatformsOfLevel1.length; k++) 
					{
						if(allPlayers[j].granades[i].model.MC_botHitBox.hitTestObject(allPlatformsOfLevel1[k]) && allPlayers[j].granades[i].fallSpeed>0)
						{
							allPlayers[j].granades[i].model.y=allPlatformsOfLevel1[k].y-allPlatformsOfLevel1[k].height;
							allPlayers[j].granades[i].fallSpeed=allPlayers[j].granades[i].fallSpeed/-8;
							allPlayers[j].granades[i].speed=allPlayers[j].granades[i].speed/1.1;
						}      
					}
					if(allPlayers[j].granades[i].model.hitTestObject(level.mc_floor) && allPlayers[j].granades[i].fallSpeed>0)
					{
						allPlayers[j].granades[i].model.y=level.mc_floor.y-level.mc_floor.height;
						allPlayers[j].granades[i].fallSpeed=allPlayers[j].granades[i].fallSpeed/-8;
						allPlayers[j].granades[i].speed=allPlayers[j].granades[i].speed/1.1;
					}
				}
			}
		}
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	}
	
}