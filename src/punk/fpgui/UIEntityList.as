package punk.fpgui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	/**
	 * ...
	 * @author Copying
	 */
	public class UIEntityList extends Entity
	{
		
		public function UIEntityList(x:Number = 0, y:Number = 0, background:Graphic = null) 
		{
			super(x, y, (background ? background : new Graphic))
			setHitboxTo(graphic);
		}
		
		public function add(e:Entity):void
		{
			if (_entities.indexOf(e) < 0)
			{
				_entities.push(e);
				e.world = world;
				e.layer = layer;
				e.added();
			}
		}
		
		public function remove(e:Entity):Boolean
		{
			var pos:uint = _entities.indexOf(e);
			if (pos < 0) return false;
			
			e.removed();
			_entities = _entities.slice(0, pos).concat(_entities.slice(pos + 1));
			return true;
		}
		
		override public function deleted():void
		{
			for each (var e:Entity in _entities)
			{
				e.removed();
			}
		}
		
		override public function update():void
		{
			for each (var e:Entity in _entities)
			{
				e.update();
			}
		}
		
		override public function render():void
		{
			super.render();
			
			var oldX:Number;
			var oldY:Number;
			for each (var e:Entity in _entities)
			{
				oldX = e.x;
				oldY = e.y;
				
				e.x += x;
				e.y += y;
				
				e.render();
				
				e.x = oldX;
				e.y = oldY;
			}
		}
		
		private var _entities:Array;
	}

}