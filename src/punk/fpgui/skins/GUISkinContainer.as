package punk.fpgui.skins 
{
	/**
	 * ...
	 * @author Copying
	 */
	public class GUISkinContainer 
	{
		
		
		
		public static function addSkin(name:String, skin:Skin):void
		{
			_skins[name] = skin;
		}
		public static function removeSkin(name:String):void
		{
			if (_skins.hasOwnProperty(name)) _skins[name] = null;
		}
		
		public static function getSkin(name:String):Skin
		{
			if (_skins.hasOwnProperty(name) && _skins[name] is Skin) return _skins[name];
			return null;
		}
		private static var _skins:Object = new Object;
	}

}