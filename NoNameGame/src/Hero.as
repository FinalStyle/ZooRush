package
{
	import Engine.Locator;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	public class Hero
	{
		public var hp:int = 100;
		public var model:MovieClip;
		public var speed:int = 10;
		
		public var fallSpeed:int = 1;
		public var grav:int = 1;
		
		/** Necesito el nivel en el que estoy */ 
		public var currentlvl:MovieClip;
		//////////Teclas/////////
		public var up:Boolean;
		public var down:Boolean;
		public var left:Boolean;
		public var right:Boolean;
		public var space:Boolean;
		public var atk1:Boolean;
		public var moviendoce:Boolean;
		/////////////////////////
		public var upKey:int;
		public var downKey:int;
		public var leftKey:int;
		public var rightKey:int;
		public var shootKey:int;
		public var atk1Key:int;
		/////////////////////////
		/** Variable para controlar si puede moverse o no */
		public var canmove:Boolean = true;
		/** Variable para controlar si puede saltar o no */
		public var canJump:Boolean = true;
		public var JumpContador:int=0
		///////////////////////////Armas y ataques/////////////////////////////
		public var bullet:Vector.<MovieClip> = new Vector.<MovieClip>();
		public var granades:Vector.<Granade> = new Vector.<Granade>();
		/** pointingArrow es una flecha que apunta hacia donde se lanza la granada */ 
		public var pointingArrow:pointArrow;
		/** Holding se utiliza para que la funcion del eventlistener de teclado no se repita cuando se mantiene apretado */
		public var holding:Boolean=false;
		public var segundero:int=2;
		public var framecontador:int=60;
		///////////////////////////////////////////////////////////////////////
		public var gotHitByGranade:Boolean=false;
		public var directionToFlyByGranade:Point = new Point;
		public var forceAppliedByGranade:int = 20;
		
		public function Hero(up:int, down:int, right:int, left:int, shoot:int, atk1:int)
		{
			upKey=up;
			downKey=down;
			leftKey=left;
			rightKey=right;
			shootKey=shoot;
			atk1Key=atk1;
			
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown)
			Locator.mainStage.addEventListener(KeyboardEvent.KEY_UP, keyUp)			
		}
		public function Update():void
		{
			framecontador++;
			
			checkKeys();
			fall();
			moveBullets();
			for (var i:int = 0; i < granades.length; i++) 
			{
				granades[i].update();
			}
			uptdateGranadeCounters();
			if(gotHitByGranade)
			{
				flyByGranadeHit(directionToFlyByGranade, forceAppliedByGranade);
				forceAppliedByGranade--;
				if(forceAppliedByGranade<=5)
				{
					gotHitByGranade=false;
					forceAppliedByGranade=20;
				}
			}
			
		}
		public function fall():void
		{
			if(fallSpeed!=0)
			{
				model.y += fallSpeed;
				fallSpeed+=grav;
			}
			else
			{
				fallSpeed=5;
			}
			
		}
		public function shoot():void
		{
			var bulletModel:MovieClip = Locator.assetsManager.getMovieClip("MCBullet");
			Locator.mainStage.addChild(bulletModel);
			bulletModel.x = model.x+20
			bulletModel.y = model.y-model.height/2+bulletModel.height/2
			bullet.push(bulletModel);
		}
		public function moveBullets():void
		{
			for (var i:int = bullet.length-1; i >= 0; i--) 
			{
				bullet[i].x+=15
			}
			
		}
		public function spawn(PosX:int, PosY:int, parent:MovieClip):void
		{
			model = Locator.assetsManager.getMovieClip("MCPlayer");
			//Locator.mainStage.addChild(model)
			parent.addChild(model);
			model.x=PosX;
			model.y=PosY;
			currentlvl = parent;
			model.MC_sideHitBox.alpha=0;
			model.MC_botHitBox.alpha=0;
			model.MC_HitBox.alpha=0;
			model.MC_topHitBox.alpha=0;
		}
		public function move(direction:int):void
		{
			if(canmove)
			{
				if(!moviendoce)
				{
					model.MC_model.gotoAndPlay("Run");
				}
				model.x+=speed*direction;
				moviendoce=true;
				
			}
			model.scaleX=1*direction;
			canmove=true;
		}
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////Granade and Arrow Functions///////////////////////////////////////////////
		public function throwGranade():void
		{
			var granade:Granade;
			granade = new Granade(model.x, model.y-10, currentlvl, pointingArrow.rotation, model.scaleX)
			granades.push(granade);
		}
		public function arrowForThrowingGranade():void
		{
			pointingArrow = new pointArrow(model.x+10, model.y-model.height/2, currentlvl);
			currentlvl.addEventListener(Event.ENTER_FRAME, updateArrowForThrowingGranade);
			
		}		
		public function deleteArrowForThrowingGranade():void
		{
			currentlvl.removeEventListener(Event.ENTER_FRAME, updateArrowForThrowingGranade);
			pointingArrow.destroy(currentlvl)
		}
		protected function updateArrowForThrowingGranade(event:Event):void
		{
			pointingArrow.update(model.x+10*model.scaleX, model.y-model.height/2, model.scaleX);
		}
		public function uptdateGranadeCounters():void
		{
			for (var i:int = granades.length-1; i >= 0; i--) 
			{
				granades[i].currentTimeToExplode-=1000/60;
				if (granades[i].currentTimeToExplode<=0) 
				{
					granades[i].destroy(currentlvl);
					granades.splice(i, 1);
				}
			}
		}
		public function flyByGranadeHit(direction:Point, force:int):void
		{
			model.x += direction.x * force;
			model.y += direction.y * force;
		}
		///////////////////////////////////////////////////////////////////////////////////////////////////////
		public function destroy():void
		{
			currentlvl.removeChild(model);	
			Locator.mainStage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown)
			Locator.mainStage.removeEventListener(KeyboardEvent.KEY_UP, keyUp)		
		}
		
		public function pause (numero:int):void
		{
			if (numero<0)
			{
				Locator.mainStage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown)
				Locator.mainStage.removeEventListener(KeyboardEvent.KEY_UP, keyUp)	
			}
			
			else
			{
				Locator.mainStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown)
				Locator.mainStage.addEventListener(KeyboardEvent.KEY_UP, keyUp)	
			}
		}
		
		public function checkKeys():void
		{
			if (up&&canJump&&JumpContador<2) 
			{
				fallSpeed=-18;
				canJump = false;
				JumpContador++
			}
			if (down&&canmove) 
			{
				framecontador=0;
			}
			if (left) 
			{
				move(-1)
			}
			if (right) 
			{
				move(1)
			}
		}
		protected function keyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case upKey:
				{
					up=true;
					break;
				}
				case downKey:
				{
					down=true;
					break;
				}
				case leftKey:
				{
					left=true;
					break;
				}
				case rightKey:
				{
					right=true;
					break;
				}
				case shootKey:
				{
					shoot();
					break;
				}
				case atk1Key:
				{
					if(!holding)
					{
						holding=true;
						arrowForThrowingGranade();
					}
					break;
				}
			}
		}
		protected function keyUp(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case upKey:
				{
					up=false;
					canJump=true;
					break;
				}
				case downKey:
				{
					down=false;
					break;
				}
				case leftKey:
				{
					left=false;
					moviendoce=false;
					model.MC_model.gotoAndPlay("Idle");
					break;
				}
				case rightKey:
				{
					right=false;
					moviendoce=false;
					model.MC_model.gotoAndPlay("Idle");
					break;
				}
				case atk1Key:
				{
					throwGranade();
					deleteArrowForThrowingGranade();
					holding=false;
					break;
				}
			}
		}
	}
}