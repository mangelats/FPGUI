package punk.fpgui.components 
{
	import flash.geom.Point;
	import punk.fpgui.GUIEntityList;
	/**
	 * ...
	 * @author Copying
	 */
	public class Window 
	{
		
		public static function alert(x:Number = 0, y:Number = 0, background:* = null, message:TextField = null, messageOffset:Point = new Point, accept:Button = null, acceptOffset:Point = new Point):GUIEntityList
		{
			var entityList:GUIEntityList = new GUIEntityList(x, y, background);
			
			var m:TextField = message;
			m.x += x;
			m.y += y;
			entityList.add(m);
			
			var b:Button = button;
			b.x += x;
			b.y += y;
			entityList.add(b);
			
			return entityList
		}
	}

}