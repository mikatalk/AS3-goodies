package
{
	public class ImageOrientation
	{
		
		public static const UNKNOWN        :int = 0;
		public static const NORMAL         :int = 0;
		public static const UPSIDE_DOWN    :int = 180;
		public static const ROTATED_LEFT   :int = 90;
		public static const ROTATED_RIGHT  :int = -90;
		
		/** this flag allows to send the rotation offset of the images loaded from camera roll */
		public static var latestLoaded     :int = UNKNOWN;
		
	}
}