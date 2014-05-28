package punk.fpgui.components 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import punk.fpgui.GUIEntity;
	import punk.fpgui.GUIGraphicList;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Copying
	 */
	public class WorldWindow extends GUIEntity
	{
		
		private static var _usedWorlds:Array = new Array;
		
		public var buffer:BitmapData;
		
		public function WorldWindow(x:uint = 0, y:uint = 0, width:uint = 275, height:uint = 200, world:World = null, normal:* = null, over:* = null) 
		{
			if (!world) return;
			if (_usedWorlds.indexOf(world) >= 0) throw new ArgumentError("You can only use the same world once (you can use the same class)");
			addWorld(world);
			_world = world;
			
			_graphic = new GUIGraphicList([normal, over], [0, 1, 1], 3);
			
			super(x, y, _graphic); //with a null graphic
			_width = width;
			_height = height;
			clearBuffer();
			
		}
		
		override public function update():void
		{
			_world.update();
		}
		
		override public function render():void
		{
			_realBuffer = FP.buffer;
			erraseBuffer();
			FP.buffer = buffer;
			
			//pre-renders the world
			_world.render();
			
			buffer = FP.buffer;
			FP.buffer = _realBuffer;
			
			//render the background
			super.render();
			
			//render everything that's inside the world
			FP.buffer.copyPixels(buffer, bufferRect, new Point(x, y));
		}
		
		protected function clearBuffer():void
		{
			buffer = new BitmapData(_width, _height);
		}
		
		protected function erraseBuffer():void
		{
			buffer.fillRect(bufferRect, 0);//#00 00 00 00 -> transparent
		}
		
		
		protected static function addWorld(world:World):void
		{
			if(_usedWorlds.indexOf(world < 0) _usedWorlds.push(world);
		}
		protected static function removeWorld(world:World):Boolean
		{
			var x:uint = _usedWorlds.indexOf(world);
			if (!x) return false;
			var temp:Array = _usedWorlds.slice(0, x);
			temp.concat(_usedWorlds.slice(x + 1));
			_usedWorlds = temp;
			return true;
		}
		
		override protected function updateReference():uint
		{
			return state;
		}
		
		public function get width():uint { return _width; }
		public function set width(w:uint):void
		{
			_width = w;
			clearBuffer();
		}
		public function get height():uint { return _height; }
		public function set height(h:uint):void
		{
			_height = h;
			clearBuffer();
		}
		public function get bufferRect():Rectangle { return new Rectangle(0, 0, _width, _height); }
		
		private var _realBuffer:BitmapData;
		private var _world:World;
		
		private var _width:uint;
		private var _height:uint;
		
		private var _graphic:GUIGraphicList;
	}

}