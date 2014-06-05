package punk.fpgui.skins 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import punk.fpgui.GraphicalUtils;
	/**
	 * Apart of the Skin. Every part becomes Graphic or data. It allows to compress the Skin image.
	 * @author Copying
	 */
	public class SkinPart 
	{
		
		/**
		 * Constructor.
		 * @param	source			The bitmap that contains the data of the part (an instance of the image of the skin).
		 * @param	skinPartType	The type of part (see PartTypes).
		 * @param	metrics			Metrics of the part. It contains all the numbers to get the data.
		 */
		public function SkinPart(source:BitmapData, skinPartType:int = 0, metrics:Array = new Array) 
		{
			_source = source;
			type = skinPartType;
			metrics = metrics
		}
		
		/**
		 * Used to get the Graphic.
		 * @param	width	Width of the part.
		 * @param	height	Height of the part.
		 * @return			Returns the BitmapData of the graphical part. If its type is data, returns null.
		 */
		public function getPart(width:Number, height:Number):BitmapData
		{
			if (type == PartType.EXTRA_DATA) return null;
			
			if (type == PartType.UNRESIZABLE)
			{
				var r:BitmapData = new BitmapData(width, height, true, 0);
				r.copyPixels(_source, new Rectangle(metrics[0], metrics[1], metrics[2], metrics[3]), new Point);
				return r;
			}
			else if (type == PartType.SPLIT_3_HORITZONTAL)
			{
				return GraphicalUtils.slice3H(_source, new Rectangle(metrics[0], metrics[1], metrics[2], metrics[3]), metrics[4], metrics[5], width, height);
			}
			else if (type == PartType.SPLIT_3_VERTICAL)
			{
				return GraphicalUtils.slice3V(_source, new Rectangle(metrics[0], metrics[1], metrics[2], metrics[3]), metrics[6], metrics[7], width, height);
			}
			else if (type == PartType.SPLIT_9)
			{
				return GraphicalUtils.slice9(_source, new Rectangle(metrics[0], metrics[1], metrics[2], metrics[3]), metrics[4], metrics[5], metrics[6], metrics[7], width, height);
			}
		}
		
		/** An instance of the source BitmapData of the skin. */
		private var _source:BitmapData;
		/** The type of this part */
		public var type:int;
		/** Array that saves all the used points to create the part */
		public var metrics:Array;
	}

}