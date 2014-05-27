package punk.fpgui.skins 
{
	/**
	 * ...
	 * @author Copying
	 */
	public class PartTypes 
	{
		public static var UNRESIZABLE:int = 0;
		public static var SPLIT_3_HORITZONTAL:int = 1;
		public static var SPLIT_3_VERTICAL:int = 2;
		public static var SPLIT_9:int = 3;
		
		public static function usedBytes(type:int):int
		{
			switch(type)
			{
				case 0: return 2;
				case 1: return 6;
				case 2:
				case 3: return 8;
			}
		}
	}

}