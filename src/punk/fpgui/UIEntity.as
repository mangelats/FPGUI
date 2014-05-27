package punk.fpgui 
{
	import flash.events.MouseEvent;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	/**
	 * ...
	 * @author Copying
	 */
	public class UIEntity extends Entity
	{
		
		//functions that handle differents events
		public var onOver:Function = onOv;
		public var onOut:Function = onOu;
		public var onClick:Function = onC;
		public var onDClick:Function = onDC;
		public var onMouseDown:Function = onMD;
		public var onMouseUp:Function = onMU;
		
		public function UIEntity(x:Number = 0, y:Number = 0, graphics:UIGraphicList = null) 
		{
			super(x, y);
			
			if (!graphics) throw new ArgumentError ("The graphics are mandatory!");
			graphic = _graphics = graphics; //all are the same class
			
			setHitboxTo(graphic);
		}
		
		override public function added():void
		{
			super.added();
			FP.stage.addEventListener(MouseEvent.CLICK, c);
			FP.stage.addEventListener(MouseEvent.DOUBLE_CLICK, dc);
		}
		override public function removed():void
		{
			FP.stage.removeEventListener(MouseEvent.CLICK, c);
			FP.stage.removeEventListener(MouseEvent.DOUBLE_CLICK, dc);
			super.removed();
		}
		
		override public function update():void //have to be called BEFORE adding new things in the subclasse (when overrided)
		{
			super.update();
			
			
			if (collidePoint(x, y, world.mouseX, world.mouseY))
			{
				
				if (!Input.mouseDown || (_state == UIState.NORMAL && _down))
				{
					_state = UIState.OVER;
					
					if (_state == UIState.MOUSE_DOWN)
					{
						mouseUp();
						onMouseUp();
					}
				}
				
				if (Input.mouseDown)
				{
					if (_state == UIState.OVER && !_down)
					{
						_state = UIState.MOUSE_DOWN;
						mouseDown();
						onMouseDown();
					}
				}
			}
			else if (_state == UIState.OVER || _state == UIState.MOUSE_DOWN)
			{
				_state = UIState.NORMAL;
				over();
				onOver();
			}
			
			_graphics.reference = updateReference();
			
			_down = Input.mouseDown;
		}
		
		protected function updateReference():uint
		{
			return 0;
		}
		
		public function get state():uint { return _state; }
		
		
		private function c(e:MouseEvent):void
		{
			if (collidePoint(x, y, world.mouseX, world.mouseY))
			{
				click();
				onClick();
			}
		}
		private function dc(e:MouseEvent):void
		{
			if (collidePoint(x, y, world.mouseX, world.mouseY))
			{
				dClick();
				onDClick();
			}
		}
		//function called by the childs to make the magic happens
		protected function over():void { }
		protected function out():void { }
		protected function click():void { }
		protected function dClick():void { }
		protected function mouseDown():void { }
		protected function mouseUp():void { }
		
		//Default functions that handles events (default values of the public vars)
		private function onOv():void { }
		private function onOu():void { }
		private function onC():void { }
		private function onDC():void { }
		private function onMD():void { }
		private function onMU():void { }
		
		
		private var _graphics:UIGraphicList;
		private var _state:uint = UIState.NORMAL;
		
		//the state of the last frame
		private var _down:Boolean = false;
	}
}