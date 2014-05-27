package punk.fpgui.skins 
{
	/**
	 * ...
	 * @author Copying
	 */
	public class UI 
	{
		
		public static function addSkin(skin:Skin):void
		{
			if (_skins.indexOf(skin) >= 0) return;
			_skins.push(skin);
		}
		public static function removeSkin(skin:Skin):void
		{
			if (_skins.indexOf(skin) < 0) return;
			var p:uint = _skins.indexOf(skin);
			var t:Array = _skins.slice(0, p);
			if (_skins.length > (p - 1)) t.concat(_skins.slice(p + 1));
		}
		
		public static function get skins():Array { return UI._skins; }
		
		private static var _skins:Array = new Array;
	}

}