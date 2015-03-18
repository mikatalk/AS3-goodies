package utils
{
	import flash.display.LoaderInfo;

	public class FlashVarsHelper
	{
		private static var params:Object = null;
		
		public static function initialize( parameters:Object ) : void
		{
			if ( params != null )
				throw ( new Error("Params Already initialized. Please use method overrideParams instead."));
			params = parameters;
		}
		
		public static function getValueByName( name:String, fallBack:String = "" ) : String
		{
			var lowerCasedName:String  = name.toLowerCase();
			for (var keyStr:String in params) 
			{
				if ( keyStr.toLowerCase() == lowerCasedName ) 
					return String(params[keyStr]);
			}
			return fallBack;
		}
		
		public static function getParams():Object
		{
			return params;
		}
		
		public static function overrideParams(parameters:Object):void
		{
			for (var keyStr:String in parameters) 
				params[keyStr.toLowerCase()] = String(parameters[keyStr]);
		}
	}
}
