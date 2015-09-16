package
{
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	public class Grid extends Sprite
	{
		private var diamondW:Number=0;
		private var diamondH:Number=0;
		
		private var _IsBlock:Boolean;//是否可通过 
		public function Grid(w:Number, h:Number)
		{
			super();
			
			diamondW = w;
			diamondH = h;
			
			draw()
		}
		
		
		public function get IsBlock():Boolean
		{
			return _IsBlock;
		}

		public function set IsBlock(value:Boolean):void
		{
			_IsBlock = value;
			
			if(value)
			{
				setColor(0xffffff);
			}
			else
			{
				setColor(0x00ff00);
			}
		}

		private function setColor(color:uint):void
		{
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = color;
			sp.transform.colorTransform = colorTransform;
		}
		
		private var sp:Sprite;
		private function draw():void
		{
			sp = new Sprite();
			sp.graphics.lineStyle(1, 0x00ffff);
			sp.graphics.beginFill(0x00ff00, 0.5);
			sp.graphics.moveTo(0, diamondH/2);
			sp.graphics.lineTo(diamondW/2, diamondH);
			sp.graphics.lineTo(diamondW, diamondH/2);
			sp.graphics.lineTo(diamondW/2, 0);
			sp.graphics.lineTo(0, diamondH/2);
			
			addChild(sp);
		}
	}
}