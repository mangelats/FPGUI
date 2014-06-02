package punk.fpgui.components 
{
	import punk.fpgui.GUIEntity;
	import punk.fpgui.GUIGraphicList;
	import net.flashpunk.graphics.Text;
	import punk.fpgui.GUIText;
	/**
	 * ...
	 * @author Copying
	 */
	public class Button extends GUIEntity
	{
		
		public function Button(x:Number = 0, y:Number = 0, normal:* = null, over:* = null, pressed:* = null, text:String = "", textLeftOffset:Number = 0, textTopOffset:Number = 0, textWidth:Number = 0, textHeight:Number = 0, textOptions:Object = null) 
		{
			if (!textOptions) textOptions = { size: 16, color: 0x0000000, wordWrap: true, align: "center", resizable: true };
			
			_text = new GUIText(text, textWidth, textHeight, textOptions, textLeftOffset, textTopOffset);
			
			_graphics =  new GUIGraphicList([normal, over, pressed, _text], [[0, 1, 2], [3, 3, 3]], 3);
			
			super(x, y, _graphics);
		}
		
		override protected function updateReference():uint
		{
			return state;
		}
		
		public function get text():Text { return _text };
		
		private var _graphics:GUIGraphicList;
		private var _text:GUIText;
	}

}