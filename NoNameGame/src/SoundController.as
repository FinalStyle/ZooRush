package
{
	import Engine.Locator;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class SoundController
	{
		public var sound:Sound;
		public var config:SoundTransform;
		public var channel:SoundChannel;
		public var currentPosition:Number;
		
		public function SoundController(snd:Sound)
		{
			sound=snd;
		}
		
		public function play (loop:int):void
		{
			config = new SoundTransform(1,0);
			channel = sound.play(0, loop, config);
			if(channel != null)
			{

				channel.addEventListener(Event.SOUND_COMPLETE, evSoundComplete);
			}else
			{
				throw new Error("No hay dispositivo de audio...");
			}
		}
		protected function evSoundComplete(event:Event):void
		{
			
		}
		
		
		public function stop():void
		{
			channel.stop();
		}
		
		public function pause():void
		{
			currentPosition = channel.position;
			channel.stop();
		}
		
		public function resume():void
		{
			channel = sound.play(currentPosition, 0, config);
		}
		
		public function set volume(value:Number):void
		{
			config.volume = value;
			channel.soundTransform = config;
		}
		
		public function get volume():Number
		{
			return config.volume;
		}
		
		public function set pan(value:Number):void
		{
			config.pan = value;
			channel.soundTransform = config;
		}
		
		public function get pan():Number
		{
			return config.pan;
		}
		
		
		public function set x(value:Number):void
		{
		
			pan = value * 2 / Locator.mainStage.stageWidth - 1;
		}
	}
}