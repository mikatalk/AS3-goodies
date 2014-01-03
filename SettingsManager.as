package 
{
	import flash.utils.ByteArray;

	public class SettingsManager
	{
		public  static const SETTING_EXAMPLE_1 : String = "example1"; 
		public  static const SETTING_EXAMPLE_2 : String = "example2"; 
		
		private  static const DELIMITER : String = "%";
		
		private static const SETTING_FILE_NAME : String = "app-settings";
		
		public static function saveSetting(key:String, value:String):void
		{
			var obj:Object = ( CacheManager.hasCache( SETTING_FILE_NAME )  ) ? CacheManager.getFromCache( SETTING_FILE_NAME ).readObject() : {};
			obj[key] = value;
			var ba:ByteArray = new ByteArray();
			ba.writeObject(obj);
			CacheManager.putInCache( SETTING_FILE_NAME, ba );
		}
		
		public static function getSetting(key:String):String
		{
			if ( ! CacheManager.hasCache( SETTING_FILE_NAME ) ) return "";
			var obj:Object = CacheManager.getFromCache( SETTING_FILE_NAME ).readObject();
			return ( obj.hasOwnProperty(key) ) ? obj[key] : "";
		}
		
	}
}