package
{
	
	
	import Engine.Locator;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Granade
	{
		public var model:MovieClip;
		public var speed:Number = 30;
		public var degrees:Number;		
		public var radians:Number;
		public var direction:Point = new Point();
		public var distance:Point = new Point();
		public var damage:int;
		
		public var fallSpeed:int = 1;
		public var grav:int = 1;
		
		public var timeToExplode:int=3000;
		public var currentTimeToExplode:Number=timeToExplode;
		
		public var fallen:Boolean=false;
		
		public var thisparent:MovieClip
		public function Granade(posX:Number, posY:Number, parent:MovieClip, rotation:Number, scaleX:int)
		{
			
			model = Locator.assetsManager.getMovieClip("MCGranade");
			parent.addChild(model);
			model.x=posX;
			model.y=posY;
			model.scaleX=scaleX;
			
			radians = rotation * Math.PI / 180;
			degrees = rotation;
			
			direction.x = Math.cos(radians);
			direction.y = Math.sin(radians);
			
			if(model.scaleX>0)
			{
				model.MC_graphic.rotation = -rotation;
			}
			else
			{
				model.MC_graphic.rotation = rotation;
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
				fallen=true;
				fallSpeed=5;
			}
		}
		public function update():void
		{
			
			
			model.x += direction.x * speed*model.scaleX;
			if(!fallen)
			{
				model.y += direction.y * speed*model.scaleX;
			}
			fall();
			
		}
		public function destroy(parent:MovieClip):void
		{
			parent.removeChild(model);
		}
	}
}