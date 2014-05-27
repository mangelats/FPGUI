package punk.fpgui.components 
{
	import punk.fpgui.UIEntity;
	import punk.fpgui.UIGraphicList;
	/**
	 * ...
	 * @author Copying
	 */
	public class RadioButton extends UIEntity
	{
		private static var groups:Object = new Object;
		
		public var selected:Boolean = false;
		
		public function RadioButton(x:Number = 0, y:Number = 0, group:String = "default", noramal:* = null, over:* = null, pressed:* = null, unchecked:* = null, checked:* = null)
		{
			_group = group;
			_graphics = new UIGraphicList([normal, over, pressed, unchecked, checked], [[0, 1, 2, 0, 1, 2], [3, 3, 3, 4, 4, 4]], 6);
			
			super(x, y, _graphics);
			
			add(this, group);
		} 
		
		override protected function updateReference():uint
		{
			return state + (selected ? 3 : 0);
		}
		
		override protected function click():void
		{
			for each (var rb:RadioButton in groups[_group])
			{
				rb.selected = false;
			}
			selected = true;
		}
		
		private static function add(rb:RadioButton, g:String):void
		{
			if (!groups.hasOwnProperty(g))
			{
				groups[g] = new Array;
			}
			
			if (groups[g].indexOf(rb) < 0)
			{
				groups[g].push(rb);
			}
		}
		
		private var _group:String;
		private var _graphics:UIGraphicList;
	}

}