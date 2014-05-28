package punk.fpgui.components 
{
	import punk.fpgui.GUIEntity;
	import punk.fpgui.GUIGraphicList;
	/**
	 * ...
	 * @author Copying
	 */
	public class Checkbox extends GUIEntity
	{
		
		public var checked:Boolean = false;
		
		public function Checkbox(x:Number = 0, y:Number = 0, normal:* = null, over:* = null, pressed:* = null, unchecked:* = null, checked:* = null) 
		{
			_graphics = new GUIGraphicList([normal, over, pressed, unchecked, checked], [[0, 1, 2, 0, 1, 2], [3, 3, 3, 4, 4, 4]], 6);
			super(x, y, _graphics);
		}
		
		override protected function updateReference():uint
		{
			return state + (checked ? 3 : 0);
		}
		
		override protected function click():void
		{
			checked = !checked;
		}
		
		private var _graphics:GUIGraphicList;
	}

}