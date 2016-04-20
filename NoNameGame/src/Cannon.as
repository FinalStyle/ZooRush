package
{
	import Engine.Locator;
	
	import flash.display.MovieClip;
	import flash.geom.Point;

	public class Cannon
	{
		public var model:MovieClip;
		public var speed:Number = 30;
		public var degrees:Number;		
		public var radians:Number;
		public var direction:Point = new Point();
		public var distance:Point = new Point();
		public var damage:int;
		
		
		public var timeToShoot:int = 3000;
		public var currentTimeToShoot:Number = timeToShoot;
		
		
		public function Cannon()
		{
			
			
		}
		public function spawn(posX:int, posY:int, parent:MovieClip):void
		{
			model = Locator.assetsManager.getMovieClip("MCCannon");
			parent.addChild(model);
			model.x=posX;
			model.y=posY;
			
			direction.x = Math.cos(radians);
			direction.y = Math.sin(radians);
		}
		public function update(target:Point):void
		{
			distance.x = target.x - model.x;
			distance.y = target.y - model.y;
			radians = Math.atan2(distance.x, distance.y);
			degrees = radians * 180 / Math.PI;
			model.mc_barrel.rotation = degrees;
			
				
		}
		
	}
}