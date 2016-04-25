package
{
	import Characters.RedPanda;
	
	import Engine.Locator;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.sampler.NewObjectSample;
	import flash.text.engine.Kerning;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	
	import flashx.textLayout.formats.BackgroundColor;
	import flashx.textLayout.operations.MoveChildrenOperation;
	
	[SWF(height="720", width="1280", frameRate="60")]
	public class Main extends Locator
	{		
		public var player:Hero;
		public var player2:Hero;
		public var player3:Hero;
		public var player4:Hero;
		public var level:MovieClip;
		
		public var gameEnded:Boolean = false;
		
		public var allPlatformsOfLevel1:Array;
		public var allWallsOfLevel1:Array;
		
		public var allPlayers:Vector.<Hero>;
		//////////////////////////////////////CameraSet////////////////////////////////////////////
		public var camLookAt:MovieClip;
		public var mid2Players:Point;
		public var playersGlobalPositions:Vector.<Point>;
		public var playersLocalPositions:Vector.<Point>;
		public var playersGlobalPositionNearestToEdges:Vector.<Point>;
		public var playersLocalPositionNearestToEdges:Vector.<Point>;
		public static var canZoomIn:Boolean=true;
		public var cam:Camera;
		public var sideLimitsX:Number;
		
		public var stop:Boolean=false;
		/////////////////////////////////////////Menu//////////////////////////////////////////////////
		public var w:Boolean;
		public var s:Boolean;
		public var menu1:MovieClip;
		public var menu2:MovieClip;
		public var creditos:MovieClip;
		/////////////////////////////////////////Audio//////////////////////////////////////////////////
		public var audio:SoundController
		//////////////////////////////////////////Cannon///////////////////////////////////////////////
		public var cannon1:Cannon;
		public var cannon2:Cannon;
		public var allCannons:Vector.<Cannon>;
		
		
		
		
		public function Main()
		{
			Locator.assetsManager.loadLinks("linksleveltry.txt");
			Locator.assetsManager.addEventListener(Event.COMPLETE, evMainMenu);
			
		}
		
		public function evMainMenu(event:Event):void
		{
			menu1=Locator.assetsManager.getMovieClip("MC_Menu1");
			menu2=Locator.assetsManager.getMovieClip("MC_Menu2");
			creditos=Locator.assetsManager.getMovieClip("MC_Creditos");
			Locator.mainStage.addChild(menu1)
			menu1.MC_creditos.alpha=0
			w=true;
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown)
			
			var song:Sound=	Locator.assetsManager.getSound("song1");
			audio = new SoundController(song);
			audio.play(0)
			audio.volume=0.1;
		}
		
		
		
		protected function keyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.W:
				{
					if (Locator.mainStage.contains(menu1))
					{
						menu1.MC_jugar.alpha=1;
						menu1.MC_creditos.alpha=0;
					}
					else
					{
						menu2.MC_level2.alpha=0;
						menu2.MC_level1.alpha=1;
					}
					w=true;
					s=false;
					break;
				}
				case Keyboard.S:
				{
					if (Locator.mainStage.contains(menu1))
					{
						menu1.MC_jugar.alpha=0;
						menu1.MC_creditos.alpha=1;
					}
					else
					{
						menu2.MC_level1.alpha=0;
						menu2.MC_level2.alpha=1;
					}
					s=true;
					w=false;
					break;
				}
				case Keyboard.ENTER:
				{
					if (w==true&&Locator.mainStage.contains(menu1))
					{
						Locator.mainStage.removeChild(menu1);
						Locator.mainStage.addChild(menu2);
						menu2.MC_level1.alpha=1;
						menu2.MC_level2.alpha=0;
						w=true;
						
					}
					else if (w==false&&Locator.mainStage.contains(menu1))
					{
						Locator.mainStage.removeChild(menu1);
						Locator.mainStage.addChild(creditos);
					}
					else if (Locator.mainStage.contains(creditos))
					{
						Locator.mainStage.removeChild(creditos);
						Locator.mainStage.addChild(menu1);
						menu1.MC_jugar.alpha=1;
						menu1.MC_creditos.alpha=0;
						w=true;
					}
					else if (w==false&&Locator.mainStage.contains(menu2))
					{
						Locator.mainStage.removeChild(menu2);
						evStartGame("MCLevel2");
					}
					else if (w==true&&Locator.mainStage.contains(menu2))
					{
						Locator.mainStage.removeChild(menu2);
						evStartGame("MCLevel1");
					}
					break;
				}
			}
			
		}
		public function evStartGame(level:String):void
		{
			
			allPlatformsOfLevel1 = new Array();
			allWallsOfLevel1= new Array();
			
			allPlayers= new Vector.<Hero>;
			
			//////////////////////////////////////CameraSet////////////////////////////////////////////
			mid2Players = new Point(0, 0);
			playersGlobalPositions = new Vector.<Point>;
			playersLocalPositions = new Vector.<Point>;
			
			sideLimitsX=100;
			///////////////////////////////////////////////////////////////////////////////////////////
			
			cam = new Camera();
			cam.on();
			
			
			
			this.level=Locator.assetsManager.getMovieClip(level);
			
			camLookAt=Locator.assetsManager.getMovieClip("MCBackGround");
			camLookAt.scaleX = camLookAt.scaleY = 0.05;
			camLookAt.alpha=0;
			camLookAt.x=stage.stageWidth/2;
			camLookAt.y=stage.stageHeight/2;
			this.level.addChild(camLookAt);
			
			
			
			cam.addToView(this.level);
			cam.lookAt(camLookAt)
			
			allPlatformsToArrayLevel1();
			allWallsToArrayLevel1();
			
			
			player = new RedPanda(Keyboard.W, Keyboard.S, Keyboard.D, Keyboard.A,Keyboard.SPACE, Keyboard.Q);
			player2 = new RedPanda(Keyboard.UP, Keyboard.DOWN, Keyboard.RIGHT, Keyboard.LEFT, Keyboard.COMMA, Keyboard.M);
			player3 = new RedPanda(Keyboard.Y, Keyboard.H, Keyboard.J, Keyboard.G, Keyboard.K, Keyboard.L);
			player4 = new RedPanda(Keyboard.NUMPAD_8, Keyboard.NUMPAD_5, Keyboard.NUMPAD_6, Keyboard.NUMPAD_4, Keyboard.NUMPAD_7, Keyboard.NUMPAD_9);
			
			player.spawn(this.level.MC_spawn.x, this.level.MC_spawn.y, this.level);
			player2.spawn(this.level.MC_spawn2.x, this.level.MC_spawn2.y, this.level);
			player3.spawn(this.level.MC_spawn.x+500, this.level.MC_spawn.y, this.level);
			player4.spawn(this.level.MC_spawn2.x-500, this.level.MC_spawn2.y, this.level);
			player2.model.scaleX*=-1;
			player4.model.scaleX*=-1;
			
			allPlayers.push(player);
			allPlayers.push(player2);
			allPlayers.push(player3);
			allPlayers.push(player4);
			getPlayerPositionFromLocalToGlobal(player);
			getPlayerPositionFromLocalToGlobal(player2);
			getPlayerPositionFromLocalToGlobal(player4);
			playersGlobalPositionNearestToEdges= new Vector.<Point>;
			playersLocalPositionNearestToEdges= new Vector.<Point>;
			
			
			//*********************************Cannon Set*******************************//
			allCannons= new Vector.<Cannon>;
			cannon1 = new Cannon;
			cannon2 = new Cannon;
			cannon1.spawn(2*stage.stageWidth/5, 0, this.level);
			cannon2.spawn(4*stage.stageWidth/5, 0, this.level);
			
			allCannons.push(cannon1);
			allCannons.push(cannon2);
			
			Locator.mainStage.addEventListener(Event.ENTER_FRAME, update)
			Locator.mainStage.addEventListener(MouseEvent.CLICK, offCamera);
			
		}
		
		protected function offCamera(event:MouseEvent):void
		{
			zoomIn();
		}
		//////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////Zoom////////////////////////////////////////
		protected function zoomIn():void
		{
			if(canZoomIn)
			{
				cam.smoothZoom = cam.zoom * 1.1;
			}
		}
		
		protected function zoomOut():void
		{
			canZoomIn=false;
			cam.smoothZoom = cam.zoom / 1.3;
			
		}		
		///////////////////////////////////////////////////////////////////////////////
		public function update(e:Event):void
		{	
			for (var i:int = 0; i < allPlayers.length; i++) 
			{
				allPlayers[i].Update();
			}
			cam.lookAt(camLookAt)
			if(!gameEnded)
			{
				/////////////////actualizo posiciones guardadas////////////////////
				updatePlayerGlobalAndLocalPositions();
				GetNearestPlayersToSides();
				GetNearestPlayersToSidesLocal();
				checkCamera();
				///////////////////////////Collitions//////////////////////////////
				granadeCollitions()
				if(cam.zoom>=1.4 || cam.zoom<=0.3)
				{
					canZoomIn=false
				}
			}
			//trace(cam.zoom)
			//*****checkPlayersColitions esta fuera del if porque necesito seguir comprobando colisiones del jugador que gana*****//
			checkPlayersColitions();
			
			if(allPlayers.length==1)
			{
				gameEnded=true;
				if(camLookAt.x>allPlayers[0].model.x+5)
				{
					camLookAt.x-=3;
					zoomIn();
				}
				else if(camLookAt.x<allPlayers[0].model.x-5)
				{
					camLookAt.x+=3;
					zoomIn();
				}
				if(camLookAt.y>allPlayers[0].model.y+5)
				{
					camLookAt.y-=3;
				}
				else if(camLookAt.y<allPlayers[0].model.y-5)
				{
					camLookAt.y+=3;
				}
			}
			/*else
			{
			for (var j:int = 0; j < allCannons.length; j++) 
			{
			allCannons[j].update(GetNearestPlayerToCannon(allCannons[j].model));
			}
			}*/
		}
		
		public function GetNearestPlayerToCannon(cannon:MovieClip):Point 
		{
			var pLocal:Point = new Point(0, 0);
			var pGlobal:Point;
			pLocal= new Point(cannon.x, cannon.y);
			pGlobal = cannon.parent.localToGlobal(pLocal);
			var nearestLeftPosition:Point = new Point(-10000);
			var nearestRightPosition:Point = new Point (10000);
			var nearestPlayerPosition:Point = new Point;
			
			for (var j:int = 0; j < playersLocalPositions.length; j++) 
			{
				if(playersLocalPositions[j].x<=pLocal.x && playersLocalPositions[j].x>nearestLeftPosition.x)
				{
					nearestLeftPosition.x=playersLocalPositions[j].x;
					nearestLeftPosition.y=playersLocalPositions[j].y;
				}
				if(playersLocalPositions[j].x>=pLocal.x && playersLocalPositions[j].x<nearestRightPosition.x)
				{
					nearestRightPosition.x=playersLocalPositions[j].x;
					nearestRightPosition.y=playersLocalPositions[j].y;
				}
			}
			if(pLocal.x - nearestLeftPosition.x < nearestRightPosition.x - pLocal.x)
			{
				nearestPlayerPosition = nearestLeftPosition
			}
			if(pLocal.x - nearestLeftPosition.x > nearestRightPosition.x - pLocal.x)
			{
				nearestPlayerPosition = nearestRightPosition
			}
			return nearestPlayerPosition;
		}
		
		public function GetNearestPlayersToSidesLocal():void 
		{
			var lowestValues:Point = new Point(10000, 10000);
			var highestValues:Point = new Point;
			
			var tempPlayer:Vector.<Point> = new Vector.<Point>();
			var tempPlayerY:Vector.<Point> = new Vector.<Point>();
			for (var i:int = 0; i < playersLocalPositions.length; i++) 
			{
				if(playersLocalPositions[i].x<lowestValues.x)
				{
					lowestValues.x=playersLocalPositions[i].x;
				}
				if(playersLocalPositions[i].x>highestValues.x)
				{
					highestValues.x=playersLocalPositions[i].x;
				}
				if(playersLocalPositions[i].y<lowestValues.y)
				{
					lowestValues.y=playersLocalPositions[i].y;
				}
				if(playersLocalPositions[i].y>highestValues.y)
				{
					highestValues.y=playersLocalPositions[i].y;
				}
			}
			//trace("Low", lowestValues, "High", highestValues)
			tempPlayer.push(lowestValues);
			tempPlayer.push(highestValues);
			playersLocalPositionNearestToEdges=tempPlayer;
		}
		public function GetNearestPlayersToSides():void 
		{
			var lowestValues:Point = new Point(10000, 10000);
			var highestValues:Point = new Point;
			
			var tempPlayer:Vector.<Point> = new Vector.<Point>();
			var tempPlayerY:Vector.<Point> = new Vector.<Point>();
			for (var i:int = 0; i < playersLocalPositions.length; i++) 
			{
				if(playersGlobalPositions[i].x<lowestValues.x)
				{
					lowestValues.x=playersGlobalPositions[i].x;
				}
				if(playersGlobalPositions[i].x>highestValues.x)
				{
					highestValues.x=playersGlobalPositions[i].x;
				}
				if(playersGlobalPositions[i].y<lowestValues.y)
				{
					lowestValues.y=playersGlobalPositions[i].y;
				}
				if(playersGlobalPositions[i].y>highestValues.y)
				{
					highestValues.y=playersGlobalPositions[i].y;
				}
			}
			//trace("Low", lowestValues, "High", highestValues)
			tempPlayer.push(lowestValues);
			tempPlayer.push(highestValues);
			playersGlobalPositionNearestToEdges=tempPlayer;
			
			
			
		}
		public function getPlayerPositionFromLocalToGlobal(player:Hero):void
		{
			var pLocal:Point = new Point(0, 0);
			var pGlobal:Point;
			
			pLocal= new Point(player.model.x, player.model.y);
			pGlobal = player.model.parent.localToGlobal(pLocal);
			playersLocalPositions.push(pLocal);
			playersGlobalPositions.push(pGlobal);
		}
		public function updatePlayerGlobalAndLocalPositions():void
		{
			var tempPLocal:Point;
			var tempPGlobal:Point;
			
			for (var i:int = 0; i < allPlayers.length; i++) 
			{
				tempPLocal= new Point(allPlayers[i].model.x, allPlayers[i].model.y);
				tempPGlobal = allPlayers[i].model.parent.localToGlobal(tempPLocal);
				playersLocalPositions[i]=tempPLocal;
				playersGlobalPositions[i]=tempPGlobal;
				//trace("Local", playersLocalPositions[i], "Global", playersGlobalPositions[i])
			}
			
		}
		
		public function checkCamera():void
		{
			mid2Players.x = (playersLocalPositionNearestToEdges[0].x + playersLocalPositionNearestToEdges[1].x)/2;
			mid2Players.y = (playersLocalPositionNearestToEdges[0].y + playersLocalPositionNearestToEdges[1].y)/2;
			if(playersGlobalPositionNearestToEdges[0].x<sideLimitsX)
			{
				zoomOut()
			}
			else if(playersGlobalPositionNearestToEdges[1].x>stage.stageWidth-sideLimitsX)
			{
				zoomOut()
			}
			if(playersGlobalPositionNearestToEdges[0].x>sideLimitsX+150 && playersGlobalPositionNearestToEdges[1].x<stage.stageWidth-sideLimitsX-150)
			{
				zoomIn()
			}
			
			camLookAt.x=mid2Players.x
			camLookAt.y=mid2Players.y
			
			if(playersGlobalPositionNearestToEdges[0].y<50)
			{
				zoomOut()
			}
			else if(playersGlobalPositionNearestToEdges[1].y>stage.stageHeight-50)
			{
				zoomOut()
			}
			
			/*if(camLookAt.x>mid2Players.x+10)
			{
			camLookAt.x-=5;
			}
			else if(camLookAt.x<mid2Players.x-10)
			{
			camLookAt.x+=5;
			}
			if(camLookAt.y>mid2Players.y+10)
			{
			camLookAt.y-=5;
			}
			else if(camLookAt.y<mid2Players.y-10)
			{
			camLookAt.y+=5;
			}*/
			/*
			if(playersLastLocalsPositions[i].x<playersLocalPositions[i].x && allPlayers[i].model.x - allPlayers[aquienresto].model.x<0 && canZoom)
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
			}	*/
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//****************************************** Colition Checks ***********************************************************//
		
		public function checkDeaths():void
		{
			for (var k:int = allPlayers.length-1; k >= 0; k--) 
			{
				for (var i:int = 0; i < allCannons.length; i++) 
				{
					if(allPlayers[k].model.MC_botHitBox.hitTestObject(allCannons[i].missileModel))
					{
						allPlayers[k].destroy();
						allPlayers.splice(k, 1);
					}
				}
			}
		}
		public function checkPlayersColitions():void
		{
			for (var k:int =  allPlayers.length-1; k >= 0; k--) 
			{
				for (var i:int = 0; i < allPlatformsOfLevel1.length; i++) 
				{
					if(allPlayers[k].model.MC_botHitBox.hitTestObject(allPlatformsOfLevel1[i])&&allPlayers[k].framecontador>=6)
					{
						allPlayers[k].fallSpeed=0;
						allPlayers[k].model.y=allPlatformsOfLevel1[i].y-allPlatformsOfLevel1[i].height;
						allPlayers[k].JumpContador=0;
					}				
				}
				for (var j:int = 0; j < allWallsOfLevel1.length; j++) 
				{
					if(allPlayers[k].model.MC_sideHitBox.hitTestObject(allWallsOfLevel1[j]))
					{
						allPlayers[k].canmove=false;
						
					}
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
					level.getChildAt(i).alpha=0;
					
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
					level.getChildAt(i).alpha=0;
				}
			}
		}	
		
		public function granadeCollitions():void
		{
			for (var j:int = allPlayers.length-1; j >= 0; j--) 
			{
				for (var i:int = allPlayers[j].granades.length-1; i >= 0; i--) 
				{
					for (var l:int = 0; l < allPlatformsOfLevel1.length; l++) 
					{
						if(allPlayers[j].granades[i].model.MC_botHitBox.hitTestObject(allPlatformsOfLevel1[l]) && allPlayers[j].granades[i].fallSpeed>10)
						{
							trace(allPlayers[j].granades[i].fallSpeed)
							allPlayers[j].granades[i].fallen=true;
							allPlayers[j].granades[i].model.y=allPlatformsOfLevel1[l].y-allPlatformsOfLevel1[l].height;
							allPlayers[j].granades[i].fallSpeed=allPlayers[j].granades[i].fallSpeed/-2;
							allPlayers[j].granades[i].speed=allPlayers[j].granades[i].speed/1.5;
							trace("colisiona")
							

						}      
					}
					for (var k:int= allPlayers.length-1; k >= 0; k--) 
					{
						if(k!=j && allPlayers[j].granades[i].model.hitTestObject(allPlayers[k].model) && allPlayers[j].granades[i].currentColdownToApplyForceOnPlayer<=0)
						{
							var direction:Point = new Point;
							var distance:Point = new Point;
							var radians:Number;
							var degrees:Number;
							
							distance.x = allPlayers[k].model.x- allPlayers[j].granades[i].model.x;
							distance.y = allPlayers[k].model.y- allPlayers[j].granades[i].model.y;
							radians = Math.atan2(distance.y, distance.x);
							
							direction.x = Math.cos(radians);
							direction.y = Math.sin(radians);
							//trace(direction)
							allPlayers[k].gotHitByGranade=true;
							allPlayers[k].directionToFlyByGranade=direction;
							//allPlayers[j].granades[i].currentColdownToApplyForceOnPlayer=allPlayers[j].granades[i].coldownToApplyForceOnPlayer;
							allPlayers[j].granades[i].destroy(level);
							allPlayers[j].granades.splice(i, 1);
							break;
						}    
					}
					
				}
			}
		}
		public function missileCollitions():void
		{
			for (var i:int = 0; i < allCannons.length; i++) 
			{
				for (var k:int = 0; k < allPlatformsOfLevel1.length; k++) 
				{
					if(allCannons[i].missileModel.hitTestObject(allPlatformsOfLevel1[k]))
					{
						allCannons[i].destroyMissile();
						allCannons[i].shot=false;
					} 
				}
			}
		}
	}
}