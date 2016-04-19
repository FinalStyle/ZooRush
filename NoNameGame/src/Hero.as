package
{
	import Engine.Locator;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class Hero
	{
		public var hp:int = 10;
		public var model:MovieClip;
		public var speed:int = 5;
		
		public var fallSpeed:int = 1;
		public var grav:int = 1;
		
		public var currentlvl:MovieClip;
		//////////Teclas/////////
		public var up:Boolean;
		public var down:Boolean;
		public var left:Boolean;
		public var right:Boolean;
		public var space:Boolean;
		public var atk1:Boolean;
		/////////////////////////
		public var upKey:int;
		public var downKey:int;
		public var leftKey:int;
		public var rightKey:int;
		public var shootKey:int;
		public var atk1Key:int;
		/////////////////////////
		public var canmove:Boolean = true;
		public var canJump:Boolean = true;
		///////////////////////////Balas/////////////////////////////
		public var bullet:Vector.<MovieClip> = new Vector.<MovieClip>();
		public var granades:Vector.<Granade> = new Vector.<Granade>();
		
		public var pointingArrow:pointArrow;
		public var holding:Boolean=false;
		
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
			checkKeys();
			fall();
			moveBullets();
			for (var i:int = 0; i < granades.length; i++) 
			{
				granades[i].update();
			}
			uptdateGranadeCounters();
			
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
		public function spawn(PosX:int, parent:MovieClip):void
		{
			model = Locator.assetsManager.getMovieClip("MCPlayer");
			//Locator.mainStage.addChild(model)
			parent.addChild(model);
			model.x=PosX;
			model.y=Locator.mainStage.stageHeight/2;
			currentlvl = parent;
			
		}
		public function move(direction:int):void
		{
			if(canmove)
			{
				model.x+=speed*direction;
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
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////
		public function destroy():void
		{
			
			
			
			
			
		}
		
		public function checkKeys():void
		{
			if (up && canJump) 
			{
				fallSpeed=-15;
				canJump = false;
			}
			if (down) 
			{
				
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
					break;
				}
				case rightKey:
				{
					right=false;
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