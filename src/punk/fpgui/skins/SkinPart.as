package punk.fpgui.skins 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Copying
	 */
	public class SkinPart 
	{
		
		public function SkinPart(source:BitmapData, skinPartType:int = 0, metrics:Array = new Array) 
		{
			_source = source;
			type = skinPartType;
			metrics = metrics
		}
		
		public function getPart(width:Number, height:Number):BitmapData
		{
			if (type == PartType.EXTRA_DATA) return null;
			
			var r:BitmapData = new BitmapData(width, height, true, 0);
			if (type == PartType.UNRESIZABLE)
			{
				r.copyPixels(_source, new Rectangle(metrics[0], metrics[1], metrics[2], metrics[3]), new Point);
			}
			else if (type == PartType.SPLIT_3_HORITZONTAL)
			{
				r.copyPixels(_source, new Rectangle(metrics[0], metrics[1], metrics[4], metrics[3]), new Point);
				var p:Number = metrics[4];
				while (p < width + metrics[5] - metrics[2])
				{
					r.copyPixels(_source, new Rectangle(metrics[4], metrics[1], metrics[5], metrics[3]), new Point(p, 0));
					p += metrics[5] - metrics[4];
				}
				r.copyPixels(_source, new Rectangle(metrics[5], metrics[1], metrics[2], metrics[3]), new Point(width + metrics[5] - metrics[2], 0));
			}
			else if (type == PartType.SPLIT_3_VERTICAL)
			{
				r.copyPixels(_source, new Rectangle(metrics[0], metrics[1], metrics[2], metrics[6]), new Point);
				var p:Number = metrics[6];
				while (p < height +  metrics[7] - metrics[3])
				{
					r.copyPixels(_source, new Rectangle(metrics[0], metrics[6], metrics[2], metrics[7]), new Point(p, 0));
					p += metrics[7] - metrics[6];
				}
				r.copyPixels(_source, new Rectangle(metrics[0], metrics[7], metrics[2], metrics[3]), new Point(height +  metrics[7] - metrics[3], 0));
			}
			else if (type == PartType.SPLIT_9)
			{
				//row 1
				//1-1
				r.copyPixels(_source, new Rectangle(metrics[0], metrics[1], metrics[4], metrics[6]), new Point);
				//1-1 done
				//1-2
				var px:Number = metrics[4];
				var py:Number = metrics[6];
				while (px < width + metrics[5] - metrics[2])
				{
					r.copyPixels(_source, new Rectangle(metrics[4], metrics[1], metrics[5], metrics[6]), new Point(px, 0));
					p += metrics[5] - metrics[4];
				}
				//1-2 done
				//1-3
				r.copyPixels(_source, new Rectangle(metrics[5], metrics[1], metrics[2], metrics[6]), new Point(width + metrics[5] - metrics[2], 0));
				px = metrics[4];
				//1-3 done
				//row 1 done
				
				//row 2
				//2-1
				while (py < height +  metrics[7] - metrics[3])
				{
					r.copyPixels(_source, new Rectangle(metrics[0], metrics[6], metrics[4], metrics[7]), new Point(py, 0));
					py += metrics[7] - metrics[6];
				}
				py = metrics[6];
				//2-1 done
				//2-2
				var temp:BitmapData = new BitmapData(width + metrics[4] + metrics[5] - metrics[0] - metrics[2],  metrics[7] - metrics[6], true, 0);
				while (px < width + metrics[5] - metrics[2])
				{
					temp.copyPixels(_source, new Rectangle(metrics[4], metrics[1], metrics[5], metrics[6]), new Point(px, 0));
					p += metrics[5] - metrics[4];
				}
				px = metrics[4];
				while (py < height +  metrics[7] - metrics[3])
				{
					r.copyPixels(temp, temp.rect, new Point(py, 0));
					py += metrics[7] - metrics[6];
				}
				//2-2 done
				//2-3
				r.copyPixels(_source, new Rectangle(metrics[5], metrics[6], metrics[2], metrics[7]), new Point(width + metrics[2] - metrics[5], metrics[6]));
				//2-3 done
				//row 2 done
				
				//row 3
				//3-1
				r.copyPixels(_source, new Rectangle(metrics[0], metrics[7], metrics[4], metrics[3]), new Point(0, height + metrics[3] - metrics[7]));
				//3-1 done
				//3-2
				while (px < width + metrics[5] - metrics[2])
				{
					r.copyPixels(_source, new Rectangle(metrics[4], metrics[3], metrics[5], metrics[3]), new Point(px, 0));
					p += metrics[5] - metrics[4];
				}
				//3-2 done
				//3-3
				r.copyPixels(_source, new Rectangle(metrics[5], metrics[7], metrics[2], metrics[3]), new Point(width + metrics[2] - metrics[5], height + metrics[3] - metrics[7]));
				//3-3 done
				//row 3 done
			}
			return r;
		}
		
		/** An instance of the source BitmapData of the skin. */
		private var _source:BitmapData;
		public var type:int;
		/** Array that saves all the used points to create the part */
		public var metrics:Array;
	}

}