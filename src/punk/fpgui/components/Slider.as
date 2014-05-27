package punk.fpgui.components 
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import punk.fpgui.UIEntity;
	import punk.fpgui.UIGraphicList;
	import punk.fpgui.UIState;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.utils.Input;
	/**
	 * ...
	 * @author Copying
	 */
	public class Slider extends UIEntity
	{
		
		public function Slider(x:Number = 0, y:Number = 0, slideWidth:Number = 0, slideOffsetX:Number = 0, bgNormal:* = null, selNormal:* = null, selCenterX:Number = 0, bgOver:* = null, selOver:* = null, bgPressed:* = null, selPressed:* = null, defaultValue:Number = 0) 
		{
			_graphics = new UIGraphicList([bgNormal, bgOver, bgPressed, selNormal, selOver, selPressed], [[0, 1, 2], [3, 4, 5]], 3);
			
			_slideWidth = slideWidth;
			_slideOffset = slideOffsetX;
			_slideCenter = selCenterX;
			
			value = (defaultValue < 0 || defaultValue > 1) ? 0.5 : defaultValue;
			
			super(x, y, _graphics);
			setHitboxTo(_graphics);
		}
		
		override protected function updateReference():uint
		{
			return state;
		}
		override public function update():void
		{
			super.update();
			if (!_selected) return;
			if (Input.mouseDown)
			{
				_posX = Input.mouseX - this.x - world.camera.x - _slideOffset;
				if (_posX < 0) _posX = 0;
				if (_posX > _slideWidth) _posX = _slideWidth;
				reposSel();
			}
			else
			{
				_selected = false;
			}
		}
		
		override protected function mouseDown():void
		{
			_selected = true;
		}
		
		
		private function reposSel():void
		{
			_graphics.getGraphic(1, 0).x =
			_graphics.getGraphic(1, 1).x =
			_graphics.getGraphic(1, 2).x = _posX - _slideCenter + _slideOffset;
		}
		
		public function get value():Number { return _posX / _slideWidth; }
		public function set value(v:Number):void
		{
			_posX = v * _slideWidth;
			reposSel();
		}
		
		private var _graphics:UIGraphicList;
		
		private var _selected:Boolean = false;
		
		private var _slideWidth:Number;
		private var _slideOffset:Number;
		private var _slideCenter:Number;
		private var _posX:Number;
	}

}