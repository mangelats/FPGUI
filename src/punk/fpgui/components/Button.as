package punk.fpgui.components 
{
	import punk.fpgui.GUIEntity;
	import punk.fpgui.GUIGraphicList;
	import net.flashpunk.graphics.Text;
	import punk.fpgui.GUIText;
	/**
	 * Simple button with three states. It's a component, an UGIEntity and an Entity.
	 * @author Copying
	 */
	public class Button extends GUIEntity
	{
		
		/**
		 * Constructor.
		 * @param	x				X position of the Entity in the World.
		 * @param	y				Y position of the Entity in the World.
		 * @param	normal			The graphic used normally.
		 * @param	over			The graphic used when the mouse is over.
		 * @param	pressed			The graphic used then the mouse is pressed over.
		 * @param	text			Text that shows.
		 * @param	textOffsetX		Offset of the text realtive to the Button.
		 * @param	textOffsetY		Offset of the text relative to the button
		 * @param	textWidth		The width that you want the text to have
		 * @param	textHeight		The height that you want the text to have
		 * @param	textOptions		Text options (the same that Text).
		 */
		public function Button(x:Number = 0, y:Number = 0, normal:* = null, over:* = null, pressed:* = null, text:String = "", textOffsetX:Number = 10, textOffsetY:Number = 10, textWidth:Number = 200, textHeight:Number = 200, textOptions:Object = null) 
		{
			if (!textOptions) textOptions = { size: 16, color: 0x0000000, wordWrap: true, align: "center", resizable: true };
			
			_text = new GUIText(text, textWidth, textHeight, textOptions, textOffsetX, textOffsetY);
			
			_graphics =  new GUIGraphicList([normal, over, pressed, _text], [[0, 1, 2], [3, 3, 3]], 3);
			
			super(x, y, _graphics);
		}
		
		override protected function updateReference():uint
		{
			return state;
		}
		
		/**
		 * The text class.
		 */
		public function get text():GUIText { return _text };
		
		private var _graphics:GUIGraphicList;
		private var _text:GUIText;
	}

}