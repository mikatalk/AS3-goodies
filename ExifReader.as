package
{
	
	import flash.errors.EOFError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	public class ExifReader extends EventDispatcher
	{ 
		private var m_loadThumbnail:Boolean = false;
		private var m_data:ByteArray = new ByteArray();
		private var m_exif:Object = new Object;
		private var m_exifKeys:Array = new Array();
		
		private var m_intel:Boolean=true;
		private var m_loc:uint=0; 
		
		private var DATASIZES:Object = new Object;
		private var TAGS:Object = new Object;
		
		public function getKeys():Array{
			return m_exifKeys;
		}
		public function hasKey(key:String):Boolean{
			return m_exif[key] != undefined;
		}
		public function getValue(key:String):Object{
			if(m_exif[key] == undefined) return null;
			return m_exif[key];
		}
		
		public function ExifReader(){
			DATASIZES[1] = 1;
			DATASIZES[2] = 1;
			DATASIZES[3] = 2;
			DATASIZES[4] = 4;
			DATASIZES[5] = 8;
			DATASIZES[6] = 1;  
			DATASIZES[7] = 1;
			DATASIZES[8] = 2;
			DATASIZES[9] = 4;
			DATASIZES[10] = 8;
			DATASIZES[11] = 4;
			DATASIZES[12] = 8;
			
			TAGS[0x010e] = 'ImageDescription';
			TAGS[0x010f] = 'Make';
			TAGS[0X0110] = 'Model';
			TAGS[0x0112] = 'Orientation';
			TAGS[0x011a] = 'XResolution';
			TAGS[0x011b] = 'YResolution';
			TAGS[0x0128] = 'ResolutionUnit';
			TAGS[0x0131] = 'Software';
			TAGS[0x0132] = 'DateTime';
			TAGS[0x013e] = 'WhitePoint';
			TAGS[0x013f] = 'PrimaryChromaticities';
			TAGS[0x0221] = 'YCbCrCoefficients';
			TAGS[0x0213] = 'YCbCrPositioning';
			TAGS[0x0214] = 'ReferenceBlackWhite';
			TAGS[0x8298] = 'Copyright';
			
			TAGS[0x829a] = 'ExposureTime';
			TAGS[0x829d] = 'FNumber';
			TAGS[0x8822] = 'ExposureProgram';
			TAGS[0x8827] = 'IsoSpeedRatings';
			TAGS[0x9000] = 'ExifVersion';
			TAGS[0x9003] = 'DateTimeOriginal';
			TAGS[0x9004] = 'DateTimeDigitized';
			TAGS[0x9101] = 'ComponentsConfiguration';
			TAGS[0x9102] = 'CompressedBitsPerPixel';
			TAGS[0x9201] = 'ShutterSpeedValue';
			TAGS[0x9202] = 'ApertureValue';
			TAGS[0x9203] = 'BrightnessValue';
			TAGS[0x9204] = 'ExposureBiasValue';
			TAGS[0x9205] = 'MaxApertureValue';
			TAGS[0x9206] = 'SubjectDistance';
			TAGS[0x9207] = 'MeteringMode';
			TAGS[0x9208] = 'LightSource';
			TAGS[0x9209] = 'Flash';
			TAGS[0x920a] = 'FocalLength';
			TAGS[0x927c] = 'MakerNote';
			TAGS[0x9286] = 'UserComment';
			TAGS[0x9290] = 'SubsecTime';
			TAGS[0x9291] = 'SubsecTimeOriginal';
			TAGS[0x9292] = 'SubsecTimeDigitized';
			TAGS[0xa000] = 'FlashPixVersion';
			TAGS[0xa001] = 'ColorSpace';
			TAGS[0xa002] = 'ExifImageWidth';
			TAGS[0xa003] = 'ExifImageHeight';
			TAGS[0xa004] = 'RelatedSoundFile';
			TAGS[0xa005] = 'ExifInteroperabilityOffset';
			TAGS[0xa20e] = 'FocalPlaneXResolution';
			TAGS[0xa20f] = 'FocalPlaneYResolution';
			TAGS[0xa210] = 'FocalPlaneResolutionUnit';
			TAGS[0xa215] = 'ExposureIndex';
			TAGS[0xa217] = 'SensingMethod';
			TAGS[0xa300] = 'FileSource';
			TAGS[0xa301] = 'SceneType';
			TAGS[0xa302] = 'CFAPattern';
			
			//... add more if you like.
			//See http://park2.wakwak.com/~tsuruzoh/Computer/Digicams/exif-e.html
		}
		
		public function processFromByteArray(bytes:ByteArray):void
		{
			m_data = bytes;
			processData();
		}
		
		
		private function processData():void{
			var iter:int=0;
			
			//confirm JPG type
			if(!(m_data.readUnsignedByte()==0xff && m_data.readUnsignedByte()==0xd8))
				return stop();
			
			//Locate APP1 MARKER
			var ff:uint=0;
			var marker:uint=0;
			for(iter=0;iter<5;++iter){ //cap iterations
				ff = m_data.readUnsignedByte();
				marker = m_data.readUnsignedByte();
				var size:uint = (m_data.readUnsignedByte()<<8) + m_data.readUnsignedByte();
				if(marker == 0x00e1) break;
				else{
					for(var x:int=0;x<size-2;++x) m_data.readUnsignedByte();
				}
			}
			//Confirm APP1 MARKER
			if(!(ff == 0x00ff && marker==0x00e1)) return stop();
			
			//Confirm EXIF header
			var i:uint;
			var exifHeader:Array = [0x45,0x78,0x69,0x66,0x0,0x0];
			for(i=0; i<6;i++) {if(exifHeader[i] != m_data.readByte()) return stop();}
			
			//Read past TIFF header
			m_intel = (m_data.readByte()!=0x4d);
			m_data.readByte(); //redundant
			for(i=0; i<6;i++) {m_data.readByte();} //read rest of TIFF header
			
			//Read IFD data
			m_loc = 8;
			
			try
			{
				readIFD(0);
			}
			catch( e : EOFError )
			{
				trace( e );     // EOFError: Error #2030: End of file was encountered.
			}
			
			stop();
		}
		
		//EXIF data is composed of 'IFD' fields.  You have IFD0, which is the main picture data.
		//IFD1 contains thumbnail data.  There are also sub-IFDs inside IFDs, notably inside IFD0.
		//The sub-IFDs will contain a lot of additional EXIF metadata.
		//readIFD(int) will help read all of these such fields.
		private function readIFD(ifd:int):void{
			var iter:int=0;
			var jumps:Array = new Array();
			var subexifJump:uint=0;
			var thumbnailAddress:uint=0;
			var thumbnailSize:int=0;
			
			// Read number of entries
			var numEntries:uint;
			if(m_intel) numEntries = m_data.readUnsignedByte() + (m_data.readUnsignedByte()<<8);
			else numEntries = (m_data.readUnsignedByte()<<8) + (m_data.readUnsignedByte());
			if(numEntries>100) numEntries=100; //cap entries
			
			m_loc+=2;
			for(iter=0; iter<numEntries;++iter){
				//Read tag
				var tag:uint;
				if(m_intel) tag = (m_data.readUnsignedByte()) + (m_data.readUnsignedByte()<<8);
				else tag = (m_data.readUnsignedByte()<<8) + (m_data.readUnsignedByte());
				
				//read type
				var type:uint;
				if(m_intel) type = (m_data.readUnsignedByte()+(m_data.readUnsignedByte()<<8));
				else type = (m_data.readUnsignedByte()<<8)+(m_data.readUnsignedByte()<<0);
				
				//Read # of components
				var comp:uint;
				if(m_intel) comp = (m_data.readUnsignedByte()+(m_data.readUnsignedByte()<<8) + (m_data.readUnsignedByte()<<16) + (m_data.readUnsignedByte()<<24));
				else comp = (m_data.readUnsignedByte()<<24)+(m_data.readUnsignedByte()<<16) + (m_data.readUnsignedByte()<<8) + (m_data.readUnsignedByte()<<0);
				
				//Read data
				var data:uint;
				if(m_intel) data= m_data.readUnsignedByte()+(m_data.readUnsignedByte()<<8) + (m_data.readUnsignedByte()<<16) + (m_data.readUnsignedByte()<<24);
				else data = (m_data.readUnsignedByte()<<24)+(m_data.readUnsignedByte()<<16) + (m_data.readUnsignedByte()<<8) + (m_data.readUnsignedByte()<<0);
				m_loc+=12;
				
				if(tag==0x0201) thumbnailAddress = data; //thumbnail address
				if(tag==0x0202) thumbnailSize = data;  //thumbnail size (in bytes)
				
				if(TAGS[tag] != undefined){
					//Determine data size
					if(DATASIZES[type] * comp <= 4){
						//data is contained within field
						m_exif[TAGS[tag]] = data;
						m_exifKeys.push(TAGS[tag]);
					}
					else{
						//data is at an offset
						var jumpT:Object = new Object();
						jumpT.name = TAGS[tag];
						jumpT.address=data;
						jumpT.components = comp;
						jumpT.type = type;
						jumps.push(jumpT);
					}
				}   
				
				if(tag==0x8769){ // subexif tag
					subexifJump = data;
				}
			}
			
			var nextIFD:uint;
			if(m_intel) {
				nextIFD= m_data.readUnsignedByte()+(m_data.readUnsignedByte()<<8) + (m_data.readUnsignedByte()<<16) + (m_data.readUnsignedByte()<<24);
			}
			else {
				nextIFD = (m_data.readUnsignedByte()<<24)+(m_data.readUnsignedByte()<<16) + (m_data.readUnsignedByte()<<8) + (m_data.readUnsignedByte()<<0);
			}
			m_loc+=4;
			
			//commenting this out, as suggested in the comments.
			//if(ifd==0) jumps = new Array();
			for each(var jumpTarget:Object in jumps){
				var jumpData:Object = null;
				for(;m_loc<jumpTarget.address;++m_loc)m_data.readByte();
				
				if(jumpTarget.type==5){
					//unsigned rational
					var numerator:uint = m_data.readInt();
					var denominator:uint = m_data.readUnsignedInt();
					m_loc+=8;
					jumpData = numerator / denominator;
				}
				if(jumpTarget.type==2){
					//string
					var field:String='';
					for(var compGather:int=0;compGather<jumpTarget.components;++compGather){
						field += String.fromCharCode(m_data.readByte());
						++m_loc;
					}
					
					if(jumpTarget.name=='DateTime' ||
						jumpTarget.name=='DateTimeOriginal' ||
						jumpTarget.name=='DateTimeDigitized'){
						var array:Array = field.split(/[: ]/);
						if(parseInt(array[0]) > 1990){
							jumpData = new Date(parseInt(array[0]), parseInt(array[1])-1,
								parseInt(array[2]), parseInt(array[3]),
								parseInt(array[4]), parseInt(array[5]));
						}
					}
					else jumpData = field;
				}
				m_exif[jumpTarget.name] = jumpData;
				m_exifKeys.push(jumpTarget.name);
			}
			
			if(ifd==0 && subexifJump){
				//jump to subexif area to obtain meta information
				for(;m_loc<data;++m_loc) m_data.readByte();
				//				readIFD(ifd);
				try
				{
					readIFD(ifd);
				}
				catch( e : EOFError )
				{
					trace( e );     // EOFError: Error #2030: End of file was encountered.
				}
			}
			
			// read the next IFD
			if(nextIFD){
				for(;m_loc<nextIFD;++m_loc) m_data.readUnsignedByte();               
			}
			if(ifd==0 && nextIFD)
			{
				//				readIFD(1);
				try
				{
					readIFD(1);
				}
				catch( e : EOFError )
				{
					trace( e );     // EOFError: Error #2030: End of file was encountered.
				}
			}
		}
		
		// Releases m_data and dispatches COMPLETE signal.
		private function stop():void{
			m_data=null;
			dispatchEvent(new Event(Event.COMPLETE));
			return;
		}
		
	}
}