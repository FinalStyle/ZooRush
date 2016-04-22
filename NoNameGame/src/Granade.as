package
{
	
	
	import Engine.Locator;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Granade
	{
		public var model:MovieClip;
		public var speed:Number = 20;
		public var degrees:Number;		
		public var radians:Number;
		public var direction:Point = new Point();
		public var distance:Point = new Point();
		public var force:int=10;
		
		public var fallSpeed:Number = 1;
		public var grav:int = 1;
		
		public var timeToExplode:int=1000;
		public var currentTimeToExplode:Number=timeToExplode;
		
		public var coldownToApplyForceOnPlayer:int = 3000;
		public var currentColdownToApplyForceOnPlayer:Number = 0;
		
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
			model.y+=fallSpeed;
			fallSpeed+=grav;
		}
		public function update():void
		{
			fall();
			model.x += direction.x * speed *model.scaleX;
			if(!fallen)
			{
				model.y += direction.y * speed * model.scaleX;
			}
			currentColdownToApplyForceOnPlayer-=1000/60;
			if(currentColdownToApplyForceOnPlayer<=0)
			{
				force=50;
			}
			else
			{
				force=0;
			}
				
		}
		public function destroy(parent:MovieClip):void
		{
			parent.removeChild(model);
		}
	}
}