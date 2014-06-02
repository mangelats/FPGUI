package punk.fpgui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	/**
	 * Class that can contain multiple Entities.
	 * @author Copying
	 */
	public class GUIEntityList extends Entity
	{
		
		/**
		 * Constructor.
		 * @param	x			X position in the world
		 * @param	y			Y position in the world
		 * @param	background	A background graphic (can be null).
		 */
		public function GUIEntityList(x:Number = 0, y:Number = 0, background:* = null) 
		{
			super(x, y, (background ? background : new Graphic))
			setHitboxTo(graphic);
		}
		
		/**
		 * Adds an entity to the List.
		 * @param	e	The added entity.
		 */
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
		
		/**
		 * Remove an entity from the list.
		 * @param	e	The removed entity.
		 * @return		Returns true if was removed. Returns false if it don't exist or something failed.
		 */
		public function remove(e:Entity):Boolean
		{
			var pos:uint = _entities.indexOf(e);
			if (pos < 0) return false;
			
			e.removed();
			_entities = _entities.slice(0, pos).concat(_entities.slice(pos + 1));
			return true;
		}
		
		/**
		 * Returns a selected entity.
		 * @param	position	The position of the entity.
		 * @return				Returns the entity (with the class that it was added).
		 */
		public function getEntity(position:uint):*
		{
			return _entities[position];
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