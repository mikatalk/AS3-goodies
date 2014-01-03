package 
{
	
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import starling.errors.AbstractClassError;

	public class CacheManager
	{
		/** @private */
		public function CacheManager() { throw new AbstractClassError(); }
		
		public static function hasCache(CacheKey:String):Boolean {
			var f:File = new File("app-storage:/settings/" + CacheKey);
			return f.exists;
			
			f = null;
		}
		
		public static function putInCache(CacheKey:String, data:ByteArray):void {
			var f:File = new File("app-storage:/settings/" + CacheKey);
			var fs:FileStream = new FileStream();
			fs.open(f, FileMode.WRITE);
			fs.writeBytes(data, 0, data.bytesAvailable);
			fs.close();
			
			f = null;
			fs = null;
		}
		
		public static function putInCacheUTF(CacheKey:String, data:String):void {
			var f:File = new File("app-storage:/settings/" + CacheKey);
			var fs:FileStream = new FileStream();
			fs.open(f, FileMode.WRITE);
			fs.writeUTFBytes(data);
			fs.close();
			
			f = null;
			fs = null;
		}
		
		public static function putInCacheEncodedImage(CacheKey:String, bitmapData:BitmapData):void {
			var bytearray:ByteArray = bitmapData.getPixels(new Rectangle(0, 0, 400, 600));
			var f:File = new File("app-storage:/settings/" + CacheKey);
			var fs:FileStream = new FileStream();
			fs.open(f, FileMode.WRITE);
			fs.writeBytes(bytearray, 0, bytearray.bytesAvailable);
			fs.close();
			
			bytearray = null;
			f = null;
			fs = null;
		}
		
		public static function getFromCache(CacheKey:String):ByteArray {
			var data:ByteArray = new ByteArray();
			var f:File = new File("app-storage:/settings/" + CacheKey);
			trace("Getting from cache: " + f.nativePath);
			var fs:FileStream = new FileStream();
			fs.open(f, FileMode.READ);
			fs.readBytes(data, 0, fs.bytesAvailable);
			fs.close();
			
			f = null;
			fs = null;
			
			return data;
		}
		
		public static function getFromCacheUTF(CacheKey:String):String {
			var data:String = "";
			var f:File = new File("app-storage:/settings/" + CacheKey);
			trace("Getting from cache: " + f.url);
			var fs:FileStream = new FileStream();
			fs.open(f, FileMode.READ);
			data = fs.readUTFBytes(fs.bytesAvailable);
			fs.close();
			
			f = null;
			fs = null;
			
			return data;
		}
		
		public static function deleteCache(CacheKey:String):void
		{
			var f:File = new File("app-storage:/settings/" + CacheKey);
			f.deleteFile();
		}
	}
}