package punk.fpgui 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Stamp;
	/**
	 * ...
	 * @author Copying
	 */
	public class UIGraphicList extends Graphic
	{
		
		public var updateAll:Boolean = false;
		public var reference:uint = 0;
		
		public var width:Number;
		public var height:Number;
		
		public function UIGraphicList(graphics:Array = null, layers:Array = null, referencesNumber:uint = 1) //references ia a 2D array
		{
			_usedBases = new Array;
			_usedObjects = new Array;
			
			_graphics = new Array;
			var tempArray:Array;
			for (var x:uint = 0; x < layers.length; x++)
			{
				if (!(layers[x] is Array)) continue;		//if is not an array, ignores it and tries with the next one
				
				tempArray = new Array;
				for (var y:uint = 0; y < referencesNumber; y++)
				{
					var g:*;
					if (layers[x][y] != null)
					{
						g = graphics[layers[x][y]];
					}
					else
					{
						g = graphics[0];
					}
					var p:uint = tempArray.push(getGraphicObject(g)) - 1;
					
					//sets the width and heigh to the biggest from the graphics. width and height can be manually modificated
					if (tempArray[p].gGraphic.hasOwnProperty("width"))
					{
						if (!width || width < tempArray[p].gGraphic.width) width = tempArray[p].gGraphic.width;
					}
					if (tempArray[p].gGraphic.hasOwnProperty("height"))
					{
						if (!height || height < tempArray[p].gGraphic.height) height = tempArray[p].gGraphic.height;
					}
				}
				_graphics.push(tempArray);
			}
			if (!width) width = 0;
			if (!height) height = 0;
		}
		
		override public function update():void
		{
			for (var x:uint = 0; x < _graphics.length; x++)
			{
				if (updateAll)
				{
					for (var y:uint = 0; y < _graphics[x].length; y++)
					{
						if (!_graphics[x][y].gGraphic.active) continue;		//if it's not active, don't update it.
						setGraphicObjectFunction(_graphics[x][y]);
						_graphics[x][y].gGraphic.update();
					}
				}
				else
				{
					if (_graphics[x][reference].gGraphic.active)
					{
						setGraphicObjectFunction(_graphics[x][reference]);
						_graphics[x][reference].gGraphic.update();
					}
				}
			}
		}
		
		override public function render(target:BitmapData, point:Point, camera:Point):void
		{
			point.x += x;
			point.y += y;
			camera.x *= scrollX;
			camera.y *= scrollY;
			
			var g:Graphic;
			for (var x:uint = 0; x < _graphics.length; x++)
			{
				g = (_graphics[x][reference].gGraphic as Graphic);
				if (g.visible)
				{
					if (g.relative)
					{
						_point.x = point.x
						_point.y = point.y
					}
					else _point.x = point.y = 0;
					g.render(target, _point, camera);
				}
			}
		}
		
		public function getGraphic(pos:uint, ref:uint):Graphic
		{
			return _graphics[pos][ref].gGraphic;
		}
		
		private function setGraphicObjectFunction(gObject:Object = null):void
		{
			if (!gObject) return;
			if (gObject.gFunction)
			{
				var t:* = gObject.gFucntion();
				if (t is Graphic) gObject.gGraphic = t;
			}
		}
		private function getGraphicObject(graphic:* = null):Object
		{
			if (!graphic)
			{
				if (_usedObjects.length > 0)
				{
					return _usedObjects[0];
				}
				else
				{
					return nullGraphic;
				}
			}
			
			if (_usedBases.indexOf(graphic) >= 0)
			{
				return _usedObjects[_usedBases.indexOf(graphic)];
			}
			
			var o:Object = new Object();
			if (graphic is Function)
			{
				o.gFunction = graphic;
				o.gGraphic = graphic();
				o.gClass = null;
			}
			else if (graphic is Graphic)
			{
				o.gGraphic = graphic;
				o.gFunction = null;
				o.gClass = null;
			}
			else if (graphic is Class)
			{
				o.gClass = graphic;
				o.gGraphic = new Stamp(graphic);
				o.gFunction = null;
			}
			else
			{
				return nullGraphic;
			}
			
			_usedObjects[_usedBases.push(graphic) - 1] = o; // adds the base and the final object
			
			return o;
		}
		
		private static var nullGraphic:Object = { gGrahic: new Graphic, gFunction:null, gClass:null };
		
		
		private var _graphics:Array;
		
		//Array refering the differents objects and elements to allow to have the same class (only need to modify 1)
		private var _usedBases:Array;
		private var _usedObjects:Array;
	}

}