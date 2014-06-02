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
			
			super(x, y, _graphics);
			
			_selCenter = selCenter;
			
			_mouseWheel = mouseWheel;
			
			_pointA = pointA;
			_pointB = pointB;
			
			setSlider();
			
			value = defaultValue;
		}
		
		override public function update():void
		{
			super.update()
			
			if (_selected)
			{
				if (_vertical && _horitzontal)
				{
					return;
				}
				else if (_horitzontal)
				{
					value = (Input.mouseX - x) / _m;
				}
				else if (_vertical)
				{
					value = (Input.mouseY - y) / _n;
				}
				else
				{
					value = ((_m * (Input.mouseX - x) - _n * (Input.mouseY - y))) / _d;
				}
			}
			else if (Input.mouseWheel && _mouseWheel)
			{
				value += (Input.mouseWheelDelta / 100) * _mouseWheel;
			}
		}
		
		override protected function updateReference():uint
		{
			return state;
		}
		override protected function mouseDown():void
		{
			_selected = true;
		}
		override protected function mouseUp():void
		{
			_selected = false;
		}
		
		private function setSlider():void
		{
			_horitzontal = (_pointA.y == _pointB.y);
			_vertical = (_pointA.x == _pointB.x);
			
			_m = _pointB.x - _pointA.x;
			_n = _pointB.y - _pointA.y;
			
			if(!(_vertical || _horitzontal))
			{
				_d = _m * _m + _n * _n;
				_ua = (_m * _pointA.x - _n * _pointA.y) / _d;
				repositionSel();
			}
		}
		private function repositionSel():void
		{
			if (_horitzontal && _vertical) return;
			if (_horitzontal)
			{
				_graphics.getGraphic(1, 0).x =
				_graphics.getGraphic(1, 1).x =
				_graphics.getGraphic(1, 2).x = _value * _m + _pointA.x - _selCenter.x;
				
				_graphics.getGraphic(1, 0).y =
				_graphics.getGraphic(1, 1).y =
				_graphics.getGraphic(1, 2).y = _pointA.y - _selCenter.y ;
			}
			else if (_vertical)
			{
				_graphics.getGraphic(1, 0).x =
				_graphics.getGraphic(1, 1).x =
				_graphics.getGraphic(1, 2).x = _pointA.x - _selCenter.x ;
				
				_graphics.getGraphic(1, 0).y =
				_graphics.getGraphic(1, 1).y =
				_graphics.getGraphic(1, 2).y = _value * _n + _pointA.y - _selCenter.y ;
			}
			else
			{
				_graphics.getGraphic(1, 0).x =
				_graphics.getGraphic(1, 1).x =
				_graphics.getGraphic(1, 2).x = _value * _m + _pointA.x - _selCenter.x;
				
				
				_graphics.getGraphic(1, 0).y =
				_graphics.getGraphic(1, 1).y =
				_graphics.getGraphic(1, 2).y = _value * _n + _pointA.y - _selCenter.y;
			}
			
		}
		
		public function get value():Number { return _value; }
		public function set value(v:Number):void
		{
			if (v > 1)
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
			
			if (!(_vertical && _horitzontal)) repositionSel();
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
		
		private var _vertical:Boolean = false;
		private var _horitzontal:Boolean = false;
		
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