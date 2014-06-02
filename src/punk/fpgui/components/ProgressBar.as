package punk.fpgui.components 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	/**
	 * ...
	 * @author Copying
	 */
	public class ProgressBar extends Entity
	{
		
		public function ProgressBar(x:Number = 0, y:Number = 0, graphic:* = null, width:Number = 100, height:Number = 20, defaultValue:Number = 0) 
		{
			_width = width;
			_height = height;
			_buffer = new BitmapData(width, height, true, 0);
			
			if (graphic is Class)
			{
				_graphic = FP.getBitmap(graphic);
			}
			else if(graphic is Graphic || graphic is Function)
			{
				_graphic = graphic;
			}
			else
			{
				throw new ArgumentError("The graphic argument must be an embed class, a Graphic (or subclass) or a function that returns a graphic.");
			}
			
			value = defaultValue;
			
			super(x, y, _graphic);
		}
		
		override public function render():void
		{
			_buffer.fillRect(new Rectangle(0, 0, _width, _height), 0);
			
			var g:Graphic;
			if (_graphic is Function)
			{
				g = _graphic();
			}
			else
			{
				g = _graphic;
			}
			
			g.render(_buffer, new Point, new Point);
			
			renderTarget.copyPixels(_buffer, new Rectangle(0, 0, _width * _value, _height), new Point(x, y));
		}
		
		/** The value of the var (from 0 to 1) */
		public function get value():Number { return _value; }
		public function set value(v:Number):void
		{
			if (v < 0)
			{
				_value = 0;
			}
			else if (v > 1)
			{
				_value = 1;
			}
			else
			{
				_value = v;
			}
		}
		
		private var _graphic:*;
		private var _buffer:BitmapData;
		private var _width:Number;
		private var _height:Number;
		private var _value:Number;
	}

}