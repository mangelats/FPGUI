package punk.fpgui 
{
	import flash.events.MouseEvent;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	/**
	 * The base calss for the components. It handlesthe GUIGraphic list and events.
	 * @author Copying
	 */
	public class GUIEntity extends Entity
	{
		/**
		 * Called when the mouse is over the Entity (only once).
		 */
		public var onOver:Function = onOv;
		/**
		 * Called when the mouse is no longer over the entity (only called once).
		 */
		public var onOut:Function = onOu;
		/**
		 * Called when the entity is clicked.
		 */
		public var onClick:Function = onC;
		/**
		 * Called when the entity is double-clicked.
		 */
		public var onDClick:Function = onDC;
		/**
		 * Called when the mouse goes down over the entity.
		 */
		public var onMouseDown:Function = onMD;
		/**
		 * Called when the mouse goes up over the entity.
		 */
		public var onMouseUp:Function = onMU;
		
		
		/**
		 * Contructor.
		 * @param	x			X position in the world.
		 * @param	y			Y position in the World.
		 * @param	graphics	Graphics used.
		 */
		public function GUIEntity(x:Number = 0, y:Number = 0, graphics:GUIGraphicList = null) 
		{
			super(x, y);
			
			if (!graphics) throw new ArgumentError ("The graphics are mandatory!");
			graphic = _graphics = graphics; //all are the same class
			
			setHitboxTo(graphic);
		}
		
		/**
		 * Called when the Entity is added to a world. If you override this, be sure to use super.added()
		 */
		override public function added():void
		{
			super.added();
			FP.stage.addEventListener(MouseEvent.CLICK, c);
			FP.stage.addEventListener(MouseEvent.DOUBLE_CLICK, dc);
		}
		/**
		 * Called when the Entity is removed from a world. If you override this, be sure to use super.removed()
		 */
		override public function removed():void
		{
			FP.stage.removeEventListener(MouseEvent.CLICK, c);
			FP.stage.removeEventListener(MouseEvent.DOUBLE_CLICK, dc);
			super.removed();
		}
		
		/**
		 * Called every game tick. If override this, use super.upddate() before do anything else.
		 */
		override public function update():void
		{
			super.update();
			
			
			
			if (_down && !Input.mouseDown)
			{
				mouseUp();
				onMouseUp();
			}
			
			if (collidePoint(x, y, world.mouseX, world.mouseY))
			{
				
				if (!Input.mouseDown || (_state == GUIState.NORMAL && _down))
				{
					_state = GUIState.OVER;
				}
				
				if (Input.mouseDown)
				{
					if (_state == GUIState.OVER && !_down)
					{
						_state = GUIState.MOUSE_DOWN;
						mouseDown();
						onMouseDown();
					}
				}
			}
			else if (_state == GUIState.OVER || _state == GUIState.MOUSE_DOWN)
			{
				_state = GUIState.NORMAL;
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
		
		/**
		 * State of this GUIEntity (see GUIState).
		 */
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
		
		
		private var _graphics:GUIGraphicList;
		private var _state:uint = GUIState.NORMAL;
		
		//the state of the last frame
		private var _down:Boolean = false;
	}
}