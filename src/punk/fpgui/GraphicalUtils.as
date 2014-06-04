package punk.fpgui 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * A class that have different graphical utils
	 * @author Copying
	 */
	public class GraphicalUtils 
	{
		public static function slice3H(source:BitmapData, sourceRect:Rectangle, cut1:Number, cut2:Number, width:Number):BitmapData
		{
			var r:BitmapData = new BitmapData(width, sourceRect.height, true, 0);
			r.copyPixels(source, new Rectangle(sourceRect.x, sourceRect.y, cut1, sourceRect.height), new Point);
			
			var x:Number = cut1;
			while (x < (width + cut2 - sourceRect.width))
			{
				r.copyPixels(source, new Rectangle(sourceRect.x + cut1, sourceRect.y, cut2 - cut1, sourceRect.height), new Point(x, 0));
				
				x += cut2 - cut1;
			}
			
			r.copyPixels(source, new Rectangle(sourceRect.x + cut2, sourceRect.y, sourceRect.width, sourceRect.height), new Point(width - cut2, 0));
		
			return r;
		}
		public static function slice3V(source:BitmapData, sourceRect:Rectangle, cut1:Number, cut2:Number, height:Number):BitmapData
		{
			var r:BitmapData = new BitmapData(sourceRect.width, height, true, 0);
			r.copyPixels(source, new Rectangle(sourceRect.x, sourceRect.y, sourceRect.width, cut1), new Point);
			
			var y:Number = cut1;
			while (y < (height + cut2 - sourceRect.height))
			{
				r.copyPixels(source, new Rectangle(sourceRect.x, sourceRect.y + cut1, sourceRect.width, cut2 - cut1), new Point(0, y));
				
				y += cut2 - cut1;
			}
			
			r.copyPixels(source, new Rectangle(sourceRect.x, sourceRect.y + cut2, sourceRect.width, sourceRect.height), new Point(0, height - cut2));
			
			return r;
		}
		public static function slice9(source:BitmapData, sourceRect:Rectangle, cutVertical1:Number, cutVertical2:Number, cutHoritzontal1:Number, cutHoritzontal2:Number, width:Number, height:Number):BitmapData
		{
			var r:BitmapData = new BitmapData(width, height, true, 0);
			var x:Number;
			var y:Number;
			var tempRect:Rectangle;
			var temp:BitmapData;
		
			
			r.copyPixels(source, new Rectangle(sourceRect.x, sourceRect.y, cutVertical1, cutHoritzontal1), new Point);
			
			x = cutVertical1;
			tempRect = new Rectangle(sourceRect. x + cutVertical1, sourceRect.y, cutVertical2 - cutVertical1, cutHoritzontal1);
			while (x < (width + cutVertical2 - sourceRect.width))
			{
				r.copyPixels(source, tempRect, new Point(x));
				x += cutVertical2 - cutVertical1;
			}
			
			r.copyPixels(source, new Rectangle(sourceRect.x + cutVertical2, sourceRect.y, sourceRect.width - cutVertical2, cutHoritzontal1), new Point(width + cutVertical2 - sourceRect.width, 0));
			
			//first row done
			
			temp = new BitmapData(width, cutHoritzontal2 - cutHoritzontal1, true, 0);
			temp.copyPixels(source, new Rectangle(sourceRect.x, sourceRect.y + cutHoritzontal1, cutVertical1, cutHoritzontal2 - cutHoritzontal1), new Point);
			
			x = cutVertical1;
			tempRect = new Rectangle(sourceRect.x + cutVertical1, sourceRect.y + cutHoritzontal1, cutVertical2 - cutVertical1, cutHoritzontal2 - cutHoritzontal1);
			while (x < (width + cutVertical2 - sourceRect.width))
			{
				temp.copyPixels(source, tempRect, new Point(x));
				x += cutVertical2 - cutVertical1;
			}
			
			temp.copyPixels(source, new Rectangle(sourceRect.x + cutVertical2, sourceRect.y + cutHoritzontal1, sourceRect.width - cutVertical2, cutHoritzontal2 - cutHoritzontal1), new Point(width + cutVertical2 - sourceRect.width, 0));
			
			y = cutHoritzontal1;
			while (y < (height + cutHoritzontal2 - sourceRect.height))
			{
				r.copyPixels(temp, temp.rect, new Point(0, y));
				y += temp.height;
			}
			
			//segond row done
			y = height + cutHoritzontal2 - sourceRect.height;
			r.copyPixels(source, new Rectangle(sourceRect.x, sourceRect.y + cutHoritzontal2, cutVertical1, sourceRect.height - cutHoritzontal2), new Point(0, y));
			
			x = cutVertical1;
			tempRect = new Rectangle(sourceRect. x + cutVertical1, sourceRect.y + cutHoritzontal2, cutVertical2 - cutVertical1, sourceRect.height - cutHoritzontal2);
			while (x < (width + cutVertical2 - sourceRect.width))
			{
				r.copyPixels(source, tempRect, new Point(x, y));
				x += cutVertical2 - cutVertical1;
			}
			
			r.copyPixels(source, new Rectangle(sourceRect.x + cutVertical2, sourceRect.y + cutHoritzontal2, sourceRect.width - cutVertical2, sourceRect.height - cutHoritzontal2), new Point(width + cutVertical2 - sourceRect.width, y));
			
			//last row done
			
			return r;
		}
	}

}