package
{
	public class BarCode
	{
		private var numBits:int = 12;
		
		public function BarCode()
		{
			
		}
		
		public function setNumBits(numBits:int):void
		{
			this.numBits = numBits;
		}
		
		public function toBits(num:Number):Array
		{
			var bits:Array = getEmptyCode()
			var array:Array = num.toString(2).split('');
			for ( var i:int = 0; i < array.length; i++ )
				bits[bits.length - 1 - i] = array[array.length - 1 - i];
			
			return bits;
		}
		
		public function toNum(bits:Array):int
		{
			var num:int = 0;
			
			for (var i:int = 0; i < bits.length; i++ )
				num += bits[i] * Math.pow(2, bits.length - 1 - i);	
			
			return num;
		}
		
		public function getEmptyCode(bits:Array = null):Array
		{
			if ( bits === null ) bits = [];
			for ( var i:int = 0; i < numBits; i++ )
				bits.push(0);
			return bits;
		}
	}
}