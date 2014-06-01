package punk.fpgui.skins 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import punk.fpgui.components.Button;
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
			_components[GUITypes.BUTTON] = new Array;
			_components[GUITypes.TOGGLE_BUTTON] = new Array;
			_components[GUITypes.CHECK_BUTTON] = new Array;
			_components[GUITypes.RADIO_BUTTON] = new Array;
			_components[GUITypes.SLIDER] = new Array;
			_components[GUITypes.TEXT_FIELD] = new Array;
			_components[GUITypes.PREGRESS_VAR] = new Array;
			_components[GUITypes.WORLD_WINDOW] = new Array;
			_components[GUITypes.TEXT_DATA] = new Array;
			
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
			_position = new Point(1);
			_skinData = new BitmapData(_skinGraphics.width, 1);
			setPixel(ENCODE_VESION);
			
			setPixel(_parts.length);
			for each (var part:SkinPart in _parts)
			{
				setPixel(((part.type & 0xFFFF) << 4) + (part.metrics.length & 0xFFFF));
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
				_type = ((_temp & 0xFFFF0000) >> 4);
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
				_type = ((_temp & 0xFFFF0000) >> 4);
				_num2 = (_temp & 0xFFFF);
				
				while (_num2 > 0)
				{
					_components[n].push(getPixel());
				}
				n++;
			}
			
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
		
//----------------------------------------------  var part -------------------------------------------------------------
		private var _skinEncoded:BitmapData;	//Encoded skin (if is updated, you can write this in a file and import directly)
		private var _skinGraphics:BitmapData;	//Graphic part
		private var _skinData:BitmapData;		//Encoded data into Bitmapdata --> only used when encoding
		
		private var _encodeUpdated:Boolean = true;//is _skinEncoded updated to be returned?
		
		private var _parts:Array;				//Array of all the parts
		private var _components:Array;			//2D array of uint. Returns the position of a part
	}

}