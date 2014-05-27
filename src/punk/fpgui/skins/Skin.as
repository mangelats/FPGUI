package punk.fpgui.skins
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Copying
	 */
	public class Skin
	{
		public static const ENCODE_VERSION:int = 1;
		
		public function Skin(skinImage:Class, encoded:Boolean = false)
		{
			_partsList = new Array;
			
			if (encoded)
			{
				_skinEncoded = FP.getBitmap(skinImage);
				decode();
			}
			else
			{
				_skinImage = FP.getBitmap(skinImage);
			}
		}
		
		/**
		 * 
		 * @param	UIType
		 * @param	metricsType
		 * @param	metrics			Array with all the values to create the different
		 */
		public function add(UIType:int, refernce:int, metricsType:int, metrics:Array)
		{
			_partsList[UIType][refernce] = new SkinPart(_skinImage, metricsType, metrics);
			_skinEncodedUpdated = false;
		}
		public function getParts(uiType:int):Array
		{
			return _partsList[uiType];
		}
		public function getGraphic(uiType:int, width:Number = 0, height:Number = 0):Array
		{
			var r:Array = new Array;
			for (var p:uint in _partsList[uiType])
			{
				r[p] = _partsList[uiType][p].getPart(width, height);
			}
			return r;
		}
		
		private function decode():void
		{
			_partsList = new Array;
			_selectedPixel = new Point;
			var finished:Boolean = false;
			var y:uint = 0;
			var maxLines = nextPixel();
			if (maxLines > _skinEncoded.height) return;
			
			_numberLength = nextPixel();
			if ((_numberLength & 0x0000FFFF) != ENCODE_VERSION) return; //Not the same version
			_numberLength = (_numberLength & 0xFFFF0000) >>> 4;
			
			var temp:Number = 0;
			var temp2:Number = 0;
			while (!finished && y <= maxLines)
			{
				temp = getNextPixel();
				temp2 = (temp & 0xFFFF0000) >>> 4;
				for (var n:int = (temp & 0xFFFF) - 1; n >= 0; n--)
				{
					_partsList[temp2][n] = getNextPart();
				}
			}
			_skinEncodedUpdated = true;
		}
		private var _lines:uint;
		private function encode():void
		{
			_lines = 1;
			_skinData = new BitmapData(_skinImage.width, 1);
			var n:int = 1;
			while (n * 0xFFFFFFFF < _skinImage.width)
			{
				n++
			}
			while (n * 0xFFFFFFFF < _skinImage.height)
			{
				n++
			}
			_skinData.setPixel(1, 0, ((n & 0xFFFF) << 4) + Skin.ENCODE_VERSION);
			_selectedPixel = new Point(3);
			for (var p:uint in _partsList)
			{
				if (!_partsList[p] || !(_partsList[p] is Array)) continue;
				var ref:int = _partsList[p].length & 0xFFFF;
				//sets the info
				_skinData.setPixel(_selectedPixel.x, _selectedPixel.y, ((p & 0xFFFF) << 4) + ref);
				selectNextPixel();
				//sets all the parts
				for (var x:int = 0; x < ref; x++)
				{
					var part:SkinPart = _partsList[p][x];
					_skinData.setPixel(_selectedPixel.x, _selectedPixel.y, ((part.type & 0xFFFF) << 4) + (PartTypes.usedBytes(part.type) & 0xFFFF));
					selectNextPixel();
					for (var y:int = 0; y < PartTypes.usedBytes(part.type); y++)
					{
						var value:Number = part.metrics[y];
						for (var y:int = n - 1; y >= 0; y--)
						{
							_skinData.setPixel(_selectedPixel.x, _selectedPixel.y, (value & 0xFFFFFFFF));
							selectNextPixel();
							value = value >>> 8;
						}
					}
				}
			}
			
			_skinData.setPixel(0, 0, _lines);
			
			_skinEncoded = new BitmapData(_skinImage.width, _skinImage.height + _skinData.height);
			_skinEncoded.copyPixels(_skinData, _skinData.rect, new Point);
			_skinEncoded.copyPixels(_skinImage, _skinImage.rect, new Point(0, _skinData.height));
			
			_skinEncodedUpdated = true;
		}
		private function selectNextPixel():void
		{
			_selectedPixel.x++;
			if (_selectedPixel.x >= _skinEncoded.width)
			{
				_selectedPixel.x = 0;
				_selectedPixel.y++;
				_lines++;
				
				//creates 1 more line
				var t:BitmapData = new BitmapData(_skinImage.width, _lines);
				t.copyPixels(_skinData, _skinData.rect, new Point);
				_skinData = t;
			}
		}
		private function getNextPixel():uint
		{
			var r:uint = _skinEncoded.getPixel(_selectedPixel.x, _selectedPixel.y);
			_selectedPixel.x++;
			if (_selectedPixel.x >= _skinEncoded.width)
			{
				_selectedPixel.x = 0;
				_selectedPixel.y++;
			}
			return r;
		}
		private function getNextNumber():Number
		{
			var x:Number = 0;
			for (var y:int = 0; y < _numberLength; y++)
			{
				x <<= 8;
				x += getNextPixel();
			}
			return x;
		}
		private function getNextPart():SkinPart
		{
			var temp:uint = getNextPixel();
			var numBytesUsed:int = temp & 0xFFFF;
			var partType:int = (temp & 0xFFFF0000) >>> 4;
			
			var a:Array = new Array;
			for (var x:int = 0; x < numBytesUsed; x++)
			{
				a[x] = getNextNumber();
			}
			return new SkinPart(_skinImage, partType, a);
		}
		
		
		public function get encodedSkin():BitmapData
		{
			if (!_skinEncodedUpdated) encode();
			return _skinEncoded;
		}
		
		private var _skinEncoded:BitmapData;
		private var _skinEncodedUpdated:Boolean = true;
		private var _skinImage:BitmapData;
		private var _skinData:BitmapData;
		private var _partsList:Array;
		
		private var _selectedPixel:Point;
		private var _numberLength:int;
	}

}