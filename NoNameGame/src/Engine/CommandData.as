package Engine
{
	public class CommandData         //tanto nombre como detalles de comandos son guardadas en instancias de esta clase, las mismas reciven los parametros anteriormente nombrados al instanciarse.
	{
		public var name:String;
		public var command:Function;
		public var description:String;
		public var numArgs:int;
	}
}