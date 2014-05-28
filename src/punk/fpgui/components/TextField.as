package punk.fpgui.components 
{
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.text.TextLineMetrics;
	import punk.fpgui.GUIEntity;
	import punk.fpgui.GUIGraphicList;
	import punk.fpgui.GUIText;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	/**
	 * ...
	 * @author Copying
	 */
	public class TextField extends GUIEntity
	{
		public static var selected:TextField = null;
		
		public function TextField(x:Number = 0, y:Number = 0, normal:* = null, over:* = null, pressed:* = null, text:String = "", multiline:Boolean = false, textRect:Rectangle = null, textOptions:Object = null, editable:Boolean = true) 
		{
			_editable = editable;
			_multiline = multiline;
			
			if (!textOptions) textOptions = { size: 16, wordWrap: false, align: "left" };
			
			_textRect = textRect || new Rectangle;
			
			_tempText = (multiline ? text : text.split("\n")[0]);
			_text = new GUIText(_tempText, _textRect.width, _textRect.height, textOptions, 0, 0, _textRect.x, _textRect.y);
			
			_graphics = new GUIGraphicList([normal, over, pressed, _text], [[0, 1, 2], [3, 3, 3]], 3);
			
			super(x, y, _graphics);
			
			_changed = true;
		}
		
		
		override public function update():void
		{
			if (Input.keyString != "" && _selected && _editable)
			{
				_tempText += Input.keyString;
				Input.keyString = "";
				_changed = true;
			}
			
			if (_changed)
			{
				_text.text = _tempText;
				_tlm = _text.lastLineMetrics;
				if (_tlm.width > _textRect.width)
				{
					_text.textScrollX = _tlm.width - _textRect.width;
				}
				else
				{
					_text.textScrollX = 0;
				}
				if (_text.textHeight > _textRect.height)
				{
					_text.textScrollY = _text.textHeight - _textRect.height;
				}
				else
				{
					_text.textScrollY = 0;
				}
				
				_changed = false;
			}
			super.update();
		}
		
		
		override protected function updateReference():uint
		{
			return state;
		}
		
		override protected function click():void
		{
			if (selected != this)
			{
				Input.keyString = "";
				if(selected) selected._selected = false;
				selected = this;
				_selected = true;
			}
		}
		
		override public function added():void
		{
			super.added();
			if(_editable) FP.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		}
		
		override public function removed():void
		{
			if(_editable) FP.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			super.removed();
		}
		
		public function keyDown(e:KeyboardEvent):void
		{
			if (FP.world != world || !_selected || !_editable) return;
			
			if (e.keyCode == Key.BACKSPACE)
			{
				_tempText = _tempText.substr(0, -1);
				_changed = true;
			}
			else if (e.keyCode == Key.SPACE)
			{
				_tempText += " ";
				_changed = true;
			}
			else if (e.keyCode == Key.ENTER && _multiline)
			{
				_tempText += "\n";
				_changed = true;
			}
		}
		//----------------------------
		
		
		public function get text():String { return _text.text; }
		public function set text(t:String):void
		{
			_tempText = t;
			_changed = true;
		}
		
		private var _selected:Boolean = false;
		
		private var _editable:Boolean;
		private var _multiline:Boolean;
		
		private var _text:GUIText;
		private var _tempText:String;
		private var _graphics:GUIGraphicList;
		private var _tlm:TextLineMetrics;
		
		private var _textRect:Rectangle;
		
		private var _changed:Boolean = false;
	}

}