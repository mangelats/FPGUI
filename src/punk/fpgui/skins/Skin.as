package punk.fpgui.skins 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import punk.fpgui.components.Button;
	import punk.fpgui.components.Checkbox;
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
		public static const ENCODE_VESION:uint = 1;
		public static var skinList:Object = new Object;
		
		public function Skin(skinImage:Class, encoded:Boolean = true) 
		{
			_parts = new Array;
			_components = new Array;
			_components[GUIType.BUTTON] = new Array;
			_components[GUIType.TOGGLE_BUTTON] = new Array;
			_components[GUIType.CHECK_BUTTON] = new Array;
			_components[GUIType.RADIO_BUTTON] = new Array;
			_components[GUIType.SLIDER] = new Array;
			_components[GUIType.TEXT_FIELD] = new Array;
			_components[GUIType.PREGRESS_VAR] = new Array;
			_components[GUIType.WORLD_WINDOW] = new Array;
			_components[GUIType.TEXT_DATA] = new Array;
			
			if (encoded)
			{
				_skinEncoded = skinImage;
				decode();
			}
			else
			{
				_skinGraphics = skinImage;
			}
		}
		
		
//-------------------------------------------  Parts handle part ---------------------------------------------------
		public function addPart(part:SkinPart):uint
		{
			if (_parts.indexOf(part) >= 0) return _parts.indexOf(part);
			return _parts.push(part);
			
			_encodeUpdated = false;
		}
		public function attachPart(partPosition:uint, graphicType:int, reference:int = 0):void
		{
			_components[graphicType][reference] = partPosition;
			
			_encodeUpdated = false;
		}
		public function addAttachPart(part:SkinPart, graphicType:int, reference:int = 0):void
		{
			_components[graphicType][reference] = addPart(part);
			
			_encodeUpdated = false;
		}
		
		
//-----------------------------------------   Encode - Decode part  ---------------------------------------------------
		private function encode():void
		{
			encodeTextOptions();
			
			_position = new Point(1);
			_skinData = new BitmapData(_skinGraphics.width, 1);
			setPixel(ENCODE_VESION);
			
			setPixel(_parts.length);
			for each (var part:SkinPart in _parts)
			{
				setPixel(((part.type & 0xFFFF) << 20) + (part.metrics.length & 0xFFFF));
				for each (var value:uint in part.metrics)
				{
					setPixel(value);
				}
			}
			
			setPixel(_components.length);
			for each(var component:Array in _components)
			{
				setPixel(component.length);
				for each (var value:uint in component)
				{
					setPixel(value);
				}
			}
			
			_skinData.setPixel(0, 0, _position.y + 1);
			
			_skinEncoded = new BitmapData(_skinGraphics.width, _skinData.height + _skinGraphics.height);
			_skinEncoded.copyPixels(_skinData, new Rectangle(0, 0, _skinData.width, _skinData.height), new Point);
			_skinEncoded.copyPixels(_skinGraphics, new Rectangle(0, 0, _skinGraphics.width, _skinGraphics.height), new Point(0, _skinData.height));
			
			_encodeUpdated = true;
		}
		
		private function decode():void
		{
			_position = new Point;
			_parts = new Array;
			_components = new Array;
			
			_lines = getPixel();
			_temp = getPixel();
			if ((_temp & 0xFFFF) != ENCODE_VESION) return; //check if was encoded with the same version. If not, stops it.
			
			_num = getPixel();
			var metrics:Array;
			
			while (_num > 0)
			{
				_temp = getPixel();
				_type = ((_temp & 0xFFFF0000) >> 20);
				_num2 = (_temp & 0xFFFF);
				
				metrics = new Array;
				while (_num2 > 0)
				{
					metrics.push(getPixel());
				}
				
				_parts.push(new SkinPart(_skinGraphics, _type, metrics));
				_num--;
			}
			
			_num = getPixel();
			var n:uint = 0;
			while (n < _num)
			{
				_temp = getPixel();
				_type = ((_temp & 0xFFFF0000) >> 20);
				_num2 = (_temp & 0xFFFF);
				
				while (_num2 > 0)
				{
					_components[n].push(getPixel());
				}
				n++;
			}
			
			decodeTextOptions();
			
			_encodeUpdated = true;
		}
		private var _r:uint;
		private function getPixel(jump:uint = 1):uint
		{
			_r = _skinEncoded.getPixel(_position.x, _position.y);
			selectPixel(jump);
			return _r;
		}
		private function setPixel(value:uint, jump:uint = 1):void
		{
			if ((!_skinData) || _position.y > _skinData.height)
			{
				var t:BitmapData = _skinData;
				_skinData = new BitmapData(_skinGraphics.width, _position.y + 1);
				_skinData.copyPixels(t, new Rectangle(0, 0, t.width, t.height), new Point);
			}
			_skinData.setPixel(_position.x, _position.y, value);
			selectPixel(jump);
		}
		private function selectPixel(jump:uint = 1):void
		{
			_position.x += jump;
			while (_position.x > _skinEncoded.width)
			{
				_position.y ++;
				_position.x -= _skinEncoded.width;
			}
		}
		private var _position:Point;
		private var _temp:uint;
		private var _num:uint;
		private var _num2:uint;
		private var _type:uint;
		
		private function encodeTextOptions():void
		{
			var temp:uint = 0;
			if (!_parts[0xFFFF]) _parts[0xFFFF] = new SkinPart(_skinGraphics, 0xFFFF);
			
			if (_textOptions.hasOwnProperty("size")) temp += (_textOptions.size << 15);
			if (_textOptions.hasOwnProperty("align"))
			{
				if (_textOptions.align == "left")
				{
					temp += 0x100;
				}
				else if (_textOptions.align == "center")
				{
					temp += 0x200;
				}
				else if (_textOptions.align == "right")
				{
					temp += 0x300;
				}
			}
			if (_textOptions.hasOwnProperty("wordWrap")) temp += (_textOptions.wordWrap ? 0x20 : 0x10);
			if (_textOptions.hasOwnProperty("resizable")) temp += (_textOptions.resizable ? 2 : 1);
			
			_parts[0xFFFF].metrics[0] = temp;
			
			temp = 0xFFFFFF;
			if (_textOptions.hasOwnProperty("color")) temp = _textOptions.color;
			if (_textOptions.hasOwnProperty("alpha")) temp += (_textOptions.alpha << 30);
			_parts[0xFFFF].metrics[1] = temp;
			
		}
		private function decodeTextOptions():void
		{
			_textOptions = new Object;
			_textOptions.size = (_parts[0xFFFF].metrics[0] & 0xFFFFF) >> 15;
			if ((_parts[0xFFFF].metrics[0] & 0xF00) == 0x100)
			{
				_textOptions.align = "left";
			}
			else if ((_parts[0xFFFF].metrics[0] & 0xF00) == 0x200)
			{
				_textOptions.align = "center";
			}
			else if ((_parts[0xFFFF].metrics[0] & 0xF00) == 0x300)
			{
				_textOptions.align = "right";
			}
			
			if ((_parts[0xFFFF].metrics[0] & 0xF0) == 0x10)
			{
				_textOptions.wordWrap = false;
			}
			else if ((_parts[0xFFFF].metrics[0] & 0xF0) == 0x20)
			{
				_textOptions.wordWrap = true;
			}
			
			if ((_parts[0xFFFF].metrics[0] & 0xF) == 1)
			{
				_textOptions.resizable = false;
			}
			else if ((_parts[0xFFFF].metrics[0] & 0xF) == 2)
			{
				_textOptions.resizable = true;
			}
			
			_textOptions.color = (_parts[0xFFFF].metrics[1] & 0xFFFFFF);
			_textOptions.alpha = ((_parts[0xFFFF].metrics[1] & 0xFF000000) >> 30);
		}
		
//------------------------------------------------ Skin Container --------------------------------------------------
		public static function newSkin(name:String, skinImage:Class, encoded:Boolean = true):Skin
		{
			return addSkin(name, new Skin(skinImage, encoded));
		}
		public static function addSkin(name:String, skin:Skin):Skin
		{
			return (skinList[name] = skin);
		}
		public static function removeSkin(name:String):void
		{
			if (skinList.hasOwnProperty(name)) _skins[name] = null;
		}
		
		public static function getSkin(name:String):Skin
		{
			if (skinList.hasOwnProperty(name) && _skins[name] is Skin) return _skins[name];
			return null;
		}
		
//----------------------------  get components from the skin (welcome to the hell of the big lines)  --------------------------------
		public function getButton(x:Number = 0, y:Number = 0, width:uint = 100, height:uint = 30, text:String = ""):Button
		{
			return new Button(x, y, getPart(GUIType.BUTTON, 0, width, height), getPart(GUIType.BUTTON, 1, width, height), getPart(GUIType.BUTTON, 2, width, height), text, getMetrics(0,3)[0], getMetrics(0,3)[1], getMetrics(0,3)[2], getMetrics(0, 3)[3], _textOptions);
		}
		
		public function getToggleButton(x:Number = 0, y:Number = 0, width:uint = 100, height:uint = 30):ToggleButton
		{
			return new ToggleButton(x, y, getPart(GUIType.TOGGLE_BUTTON, 0, width, height), getPart(GUIType.TOGGLE_BUTTON, 1, width, height), getPart(GUIType.TOGGLE_BUTTON, 2, width, height), getPart(GUIType.TOGGLE_BUTTON, 3, width, height), getPart(GUIType.TOGGLE_BUTTON, 4, width, height), getPart(GUIType.TOGGLE_BUTTON, 5, width, height), text, getMetrics(GUIType.BUTTON, 6)[0], getMetrics(GUIType.BUTTON, 6)[1], getMetrics(GUIType.BUTTON, 6)[2], getMetrics(GUIType.BUTTON, 6)[3], _textOptions);
		}
		
		public function getCheckbox(x:Number = 0, y:Number = 0, width:uint = 100, height:uint = 30, checkWidth:Number = 20, checkHeight:Number = 20):Checkbox
		{
			return new Checkbox(x, y, getPart(GUIType.CHECK_BUTTON, 0, width, height), getPart(GUIType.CHECK_BUTTON, 1, width, height), getPart(GUIType.CHECK_BUTTON, 2, width, height), getPart(GUIType.CHECK_BUTTON, 3, checkWidth, checkHeight), getPart(GUIType.CHECK_BUTTON, 4, checkWidth, checkHeight));
		}
		
		public function getRadioButton(x:Number = 0, y:Number = 0, width:uint = 100, height:uint = 30, group:String = "default", checkWidth:Number = 20, checkHeight:Number = 20):RadioButton
		{
			return new RadioButton(x, y, group, getPart(GUIType.RADIO_BUTTON, 0, width, height), getPart(GUIType.RADIO_BUTTON, 1, width, height), getPart(GUIType.RADIO_BUTTON, 2, width, height), getPart(GUIType.RADIO_BUTTON, 3, width, height), getPart(GUIType.RADIO_BUTTON, 4 , width, height));
		}
		
		public function getSlider(x:Number = 0, y:Number = 0, width:Number = 100, height:Number = 30, selWidth:Number = 20, selHeight:Number = 20, pointA:Point = new Point, pointB:Point = new Point, defaultValue:Number = 0.5, mouseWheel:Number = 0):Slider
		{
			return new Slider(x, y, pointA, pointB, defaultValue, new Point(getMetrics(GUIType.SLIDER, 6)[0], getMetrics(GUIType.SLIDER, 6)[1]), mouseWheel, getPart(GUIType.SLIDER, 0, width, height), getPart(GUIType.SLIDER, 3, selWidth, selWidth), getPart(GUIType.SLIDER, 1, width, height), getPart(GUIType.SLIDER, 4, selWidth, selWidth), getPart(GUIType.SLIDER, 2, width, height), getPart(GUIType.SLIDER, 5, selWidth, selWidth));
		}
		
		public function getTextField(x:Number = 0, y:Number = 0, width:Number = 100, height:Number = 30, defaultText:String = "", textRect:Rectangle = new Rectangle(10, 5, 80, 20), multiline:Boolean = false, editable:Boolean = true):TextField
		{
			return new TextField(x, y, getPart(GUIType.TEXT_FIELD, 0, width, height), getPart(GUIType.TEXT_FIELD, 1, width, height), getPart(GUIType.TEXT_FIELD, 2, width, height), defaultText, multiline, textRect, _textOptions, editable);
		}
		
		
		private function getPart(type:uint, reference:uint = 0, width:Number, height:Number):BitmapData
		{
			return _parts[_components[type][reference]].getPart(width, height);
		}
		private function getMetrics(type:uint, reference:uint = 0):Array
		{
			return _parts[_components[type][reference]].metrics;
		}
		
//----------------------------------------------  var part -------------------------------------------------------------
		private var _skinEncoded:BitmapData;	//Encoded skin (if is updated, you can write this in a file and import directly)
		private var _skinGraphics:BitmapData;	//Graphic part
		private var _skinData:BitmapData;		//Encoded data into Bitmapdata --> only used when encoding
		private var _textOptions:Object = new Object;
		
		private var _encodeUpdated:Boolean = true;//is _skinEncoded updated to be returned?
		
		private var _parts:Array;				//Array of all the parts
		private var _components:Array;			//2D array of uint. Returns the position of a part
	}

}