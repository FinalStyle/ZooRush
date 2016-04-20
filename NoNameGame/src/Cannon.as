package
{
	import Engine.Locator;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Cannon
	{
		public var model:MovieClip;
		public var degrees:Number;		
		public var radians:Number;
		public var direction:Point = new Point();
		public var distance:Point = new Point();
		public var damage:int;
		
		//*******************************Misil************************************//
		public var missileModel:MovieClip;
		public var speed:Number = 5;
		public var shot:Boolean=false;
		public var missileRadians:Number;
		//***********************************************************************//
		
		public var timeToShoot:int = 3000;
		public var currentTimeToShoot:Number = timeToShoot;
		
		public var timeToReload:int = 1000;
		public var currentTimeToReload:Number = timeToShoot;
		
		
		public function Cannon()
		{
			missileModel= Locator.assetsManager.getMovieClip("MCMissile");
			
		}
		public function spawn(posX:int, posY:int, parent:MovieClip):void
		{
			model = Locator.assetsManager.getMovieClip("MCCannon");
			parent.addChild(missileModel);
			parent.addChild(model);
			model.x=posX;
			model.y=posY;
			missileModel.scaleX = missileModel.scaleY= 0.5;
			missileModel.x=model.x
			missileModel.y=model.y
			
		}
		public function update(target:Point):void
		{
			
			
			distance.x = target.x - model.x;
			distance.y = target.y - model.y;
			radians = Math.atan2(distance.x, distance.y)*-1;
			degrees = radians * 180 / Math.PI;
			
			if(!shot)
			{
				if(model.mc_barrel.rotation != degrees && model.mc_barrel.rotation > degrees)
				{
					model.mc_barrel.rotation -= 3;
					missileModel.rotation -= 3;
				}
				if(model.mc_barrel.rotation != degrees && model.mc_barrel.rotation < degrees)
				{
					model.mc_barrel.rotation += 3;
					missileModel.rotation += 3;
				}
				currentTimeToShoot-=1000/60;
				if(currentTimeToShoot<=0)
				{
					missileRadians=Math.atan2(distance.y, distance.x)
					direction.x =Math.cos(missileRadians)
					direction.y =Math.sin(missileRadians)
					shot=true
					currentTimeToShoot = timeToShoot;
				}
			}
			else
			{
				if(model.mc_barrel.rotation != degrees && model.mc_barrel.rotation > degrees)
				{
					model.mc_barrel.rotation -= 3;
				}
				if(model.mc_barrel.rotation != degrees && model.mc_barrel.rotation < degrees)
				{
					model.mc_barrel.rotation += 3;
				}
				
				missileModel.x+=direction.x*speed;
				missileModel.y+=direction.y*speed;
				currentTimeToReload-=1000/60;
				if(currentTimeToReload<=0)
				{
					shot=false;	
					currentTimeToReload=timeToReload
				}
			}
			
		}
		
	}
}