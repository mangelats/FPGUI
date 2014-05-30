package punk.fpgui.skins
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import punk.fpgui.components.Button;
	import punk.fpgui.components.CheckBox;
	import punk.fpgui.components.RadioButton;
	import punk.fpgui.components.Slider;
	import punk.fpgui.components.TextField;
	import punk.fpgui.components.ToggleButton;
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
//-----------------------------------------------------------------------------------------------------------------------
		
		public function getButton(x:Number, y:Number, width:Number, height:Number, text:String):Button
		{
			if (!(_partsList[0] && _partsList[0] is Array && _partsList[0].length > 4)) return null;
			return new Button(x, y, _partsList[0][0].getPart(width, height), _partsList[0][1].getPart(width, height), _partsList[0][2].getPart(width, height), text, _partsList[0][3][0], _partsList[0][3][1], width - _partsList[0][3].metrics[0] - _partsList[0][3].metrics[2], height - _partsList[0][3].metrics[1] - _partsList[0][3].metrics[3], getTextOptions());
		}
		public function getToggleButton(x:Number, y:Number, width:Number, height:Number, text:String):ToggleButton
		{
			if (!(_partsList[1] && _partsList[1] is Array && _partsList[1].length > 7)) return null;
			return new ToggleButton(x, y, _partsList[1][0].getPart(width, height), _partsList[1][1].getPart(width, height), _partsList[1][2].getPart(width, height), _partsList[1][3].getPart(width, height), _partsList[1][4].getPart(width, height), _partsList[1][5].getPart(width, height), text, _partsList[1][6].metrics[0], _partsList[1][6].metrics[1], width - _partsList[1][6].metrics[0] - _partsList[1][6].metrics[2], height - _partsList[1][6].metrics[1] - _partsList[1][6].metrics[3], getTextOptions());
		}
		public function getCheckButton(x:Number, y:Number, width:Number, height:Number)
		{
			if (!(_partsList[2] && _partsList[2] is Array && _partsList[2].length > 5)) return null;
			return new CheckBox(x, y, _partsList[2][0].getPart(width, length), _partsList[2][1].getPart(width, length), _partsList[2][2].getPart(width, length), _partsList[2][3].getPart(width, length), _partsList[2][4].getPart(width, length));
		}
		public function getRadioButton(x:Number, y:Number, width:Number, height:Number, group:String = "default")
		{
			if (!(_partsList[3] && _partsList[3] is Array && _partsList[3].length > 5)) return null;
			return new RadioButton(x, y, group, _partsList[3][0].getPart(width, length), _partsList[3][1].getPart(width, length), _partsList[3][2].getPart(width, length), _partsList[3][3].getPart(width, length), _partsList[3][4].getPart(width, length));
		}
		public function getSlider(x:Number, y:Number, width:Number, height:Number, selectorWidth:Number, selectorHeight:Number, defaultValue:Number = 0.5, mouseWheel:Number = 0):Slider
		{
			if (!(_partsList[4] && _partsList[4] is Array && _partsList[4].length > 7)) return null;
			return new Slider(x, y, new Point(_partsList[4][6].metrics[0], _partsList[4][6].metrics[1]), new Point(_partsList[4][6].metrics[2], _partsList[4][6].metrics[3]), defaultValue, new Point(selectorWidth / 2, selectorHeight / 2), mouseWheel, _partsList[4][0].getPart(width, height), _partsList[4][3].getPart(selectorWidth, selectorHeight), _partsList[4][1].getPart(width, height), _partsList[4][4].getPart(selectorWidth, selectorHeight), _partsList[4][2].getPart(width, height), _partsList[4][5].getPart(selectorWidth, selectorHeight));
		}
		public function getTextField(x:Number, y:Number, width:Number, height:Number, defaultText:String = "", multiline:Boolean = false, editable:Boolean = true);
		{
			if (!(_partsList[5] && _partsList[5] is Array && _partsList[5].length > 4)) return null;
			return new TextField(x, y, _partsList[5][0].getPart(width, length), _partsList[5][1].getPart(width, length), _partsList[5][2].getPart(width, length), defaultText, multiline, new Rectangle(_partsList[5][3].metrics[0], _partsList[5][3].metrics[1], width - _partsList[5][3].metrics[0] - _partsList[5][3].metrics[2], height - _partsList[5][3].metrics[1] - _partsList[5][3].metrics[3]), getTextOptions(), editable);
		}
		
		public function getTextOptions():Object
		{
			var r:Object = new Object;
			
			if (!(_partsList[0xFFFF] && _partsList[0xFFFF] is Array)) return null;
			
			if (_partsList[0xFFFF][0]) r.size = _partsList[0xFFFF][0];
			if (_partsList[0xFFFF][1]) r.align = _partsList[0xFFFF][1];
			if (_partsList[0xFFFF][2]) r.wordWarp = _partsList[0xFFFF][2];
			if (_partsList[0xFFFF][3]) r.resizable = _partsList[0xFFFF][3];
			if (_partsList[0xFFFF][4]) r.width = _partsList[0xFFFF][4];
			if (_partsList[0xFFFF][5]) r.height = _partsList[0xFFFF][5];
			
			return r;
		}
//-----------------------------------------------------------------------------------------------------------------------
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
				_partsList[temp2] = new Array;
				if (temp2 == GUITypes.TEXT_DATA) //if it's the TextData
				{
					_partsList[temp2][0] = getNextPixel(); //text size (uint); pixel 1
					temp = getNextPixel();					//pixel2
					switch(temp & 0x000000FF) //text align (String)
					{
						case 0:
							_partsList[temp2][1] = null;
							break;
						case 1:
							_partsList[temp2][1] = "left";
							break;
						case 2:
							_partsList[temp2][1] = "center";
							break;
						case 3:
							_partsList[temp2][1] = "right";
					}
					_partsList[temp2][2] = new Boolean((temp & 0x00000F00) >>> 2); //text wordWrap (Boolean)
					_partsList[temp2][3] = new Boolean((temp & 0x0000F000) >>> 3); //text wordWrap (Boolean)
					
					_partsList[temp2][4] = getNextPixel(); //width (uint) (pretty much unused); pixel 3
					if (_partsList[temp2][4] == 0) _partsList[temp2][4] = null;
					
					_partsList[temp2][5] = getNextPixel(); //height (uint) (pretty much unused); pixel 4
					if (_partsList[temp2][5] == 0) _partsList[temp2][5] = null;
				}
				else
				{
					for (var n:int = (temp & 0xFFFF) - 1; n >= 0; n--)
					{
						_partsList[temp2][n] = getNextPart();
					}
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
					_skinData.setPixel(_selectedPixel.x, _selectedPixel.y, ((part.type & 0xFFFF) << 4) + (part.metrics.length & 0xFFFF));
					selectNextPixel();
					for (var y:int = 0; y < part.metrics.length; y++)
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
		
		//-----
		
		public static function addSkin(name:String, skin:Skin):void
		{
			_skins[name] = skin;
		}
		public static function removeSkin(name:String):void
		{
			if (_skins.hasOwnProperty(name)) _skins[name] = null;
		}
		
		public static function getSkin(name:String):Skin
		{
			if (_skins.hasOwnProperty(name) && _skins[name] is Skin) return _skins[name];
			return null;
		}
		
		//-----
		
		public function get encodedSkin():BitmapData
		{
			if (!_skinEncodedUpdated) encode();
			return _skinEncoded;
		}
		
		
		private static var _skins:Object = new Object;
		
		private var _skinEncoded:BitmapData;
		private var _skinEncodedUpdated:Boolean = true;
		private var _skinImage:BitmapData;
		private var _skinData:BitmapData;
		private var _partsList:Array;
		
		private var _selectedPixel:Point;
		private var _numberLength:int;
	}

}