package punk.fpgui.components 
{
	import flash.geom.Point;
	import net.flashpunk.utils.Input;
	import punk.fpgui.GUIEntity;
	import punk.fpgui.GUIGraphicList;
	/**
	 * ...
	 * @author Copying
	 */
	public class Slider extends GUIEntity
	{
		
		public function Slider(x:Number = 0, y:Number = 0, pointA:Point = null, pointB:Point = null, defaultValue:Number = 0.5, selCenter:Point = null, mouseWheel:Number = 0, bgNormal:* = null, selNormal:* = null, bgOver:* = null, selOver:* = null, bgPressed:* = null, selPressed:* = null)
		{
			_graphics = new GUIGraphicList([bgNormal, bgOver, bgPressed, selNormal, selOver, selPressed], [[0, 1, 2], [3, 4, 5]], 3);
			
			//make the points relative
			pointA.x += x;
			pointA.y += y;
			pointB.x += x;
			pointB.y += y;
			
			_selCenter = selCenter;
			
			_mouseWheel = mouseWheel;
			
			_pointA = pointA;
			_pointB = pointB;
			
			setSlider();
			
			if (defaultValue <= 0 || defaultValue > 1)
			{
				value = 0.5;
			}
			else
			{
				value = defaultValue;
			}
		}
		
		override public function update():void
		{
			super.update()
			
			if (_selected)
			{
				value = (_m * Input.mouseX - _n * Input.mouseY) / _d;
				repositionSel();
			}
			else if (Input.mouseWheel && _mouseWheel)
			{
				value += (Input.mouseWheelDelta / 100) * _mouseWheel;
			}
		}
		
		private function setSlider():void
		{
			if (_pointa == _pointB)
			{
				_value = 0;
				throw new ArgumentError("The points must be different");
			}
			else
			{
				_m = _pointB.x - _pointA.x;
				_n = _pointB.y - _pointA.y;
				
				_d = _m * _m + _n * _n;
				_ua = (_m * _pointA.x - _n * _pointA.y) / _d;
				repositionSel();
			}
		}
		private function repositionSel():void
		{
			_graphics.getGraphic(1, 0).x =
			_graphics.getGraphic(1, 1).x =
			_graphics.getGraphic(1, 2).x = ((_value - _ua) * _m) + _pointA.x - _selCenter.x;
			
			_graphics.getGraphic(1, 0).y =
			_graphics.getGraphic(1, 1).y =
			_graphics.getGraphic(1, 2).y = ((_value - _ua) * _n) + _pointA.y - _selCenter.y;
		}
		
		public function get value():Number { return _value; }
		public function set value(v:Number):void
		{
			if (v < 1)
			{
				_value = 1;
			}
			else if (v < 0)
			{
				_value = 0;
			}
			else
			{
				_value = v;
			}
			
			repositionSel();
		}
		
		public function get pointA():Point { return _pointA; }
		public function set pointA(p:Point):void
		{
			_pointA = p;
			setSlider();
		}
		
		public function get pointB():Point { return _pointB; }
		public function set pointB(p:Point):void
		{
			_pointB = p;
			setSlider();
		}
		
		private var _value:Number;
		private var _mouseWheel:Number;
		
		private var _graphics:GUIGraphicList;
		private var _selCenter:Point;
		
		private var _selected:Boolean = false;
		
		//vars used to calculate the position
		private var _pointA:Point;
		private var _pointB:Point;
		private var _m:Number;
		private var _n:Number;
		private var _d:Number;
		private var _ua:Number;
	}

}