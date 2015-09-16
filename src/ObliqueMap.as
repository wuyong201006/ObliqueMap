package
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import fl.controls.Button;
	
	[SWF(width="1600", height="950", frameRate="45", backgroundColor="#000000")]
	public class ObliqueMap extends Sprite
	{
		private const DIAMONDW:Number = 80;
		private const DIAMONDH:Number = 40;
		
		private const MAPWIDTH:Number = 20;
		private const MAPHEIGHT:Number = 20;
		
		private var player:Shape;
		
		private var start:Button;
		private var pause:Button;
		private var reset:Button;
		
		private var aNodeMap:Array;
		private var astar:AStar;
		private var bMove:Boolean;
		
		private var aPath:Array;
		private var pathpoint:int;
		private var mapData:Array=[
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
		];
		public function ObliqueMap()
		{
			super();
			
			init();
		}
		
		private function clickStart(event:MouseEvent):void 
		{
			if(astar.DoSearch())
			{
				bMove = true;
				aPath = astar.aPath;
				pathpoint = aPath.length-1;
			}
		}
		
		private function clickPause(event:MouseEvent):void
		{
			
		}
		
		private function setFlag(event:MouseEvent):void
		{
			
		}
		
		private function move(event:Event):void
		{
			if(bMove)
			{
				if(!aPath || aPath.length <= 0)return;
				if(pathpoint >= 0)
				{
					player.x = (aPath[pathpoint][1] -aPath[pathpoint][0])*DIAMONDW/2;
					player.y = (aPath[pathpoint][1]+aPath[pathpoint][0])*DIAMONDH/2;
					trace("x:"+player.x+":"+"y:"+player.y);
				}
				else
				{
					bMove = false;
				}
			}
		}
		
		private function init():void
		{
			bMove = false;
			aNodeMap = new Array();
			aPath = new Array();
			pathpoint = 0;
			
			start = createBtn("开始", new Point(150, 15), this);
			start.addEventListener(MouseEvent.CLICK, clickStart);
			
			pause = createBtn("暂停", new Point(250, 15), this);
			pause.addEventListener(MouseEvent.CLICK, clickPause);
			
			reset = createBtn("重置", new Point(350, 15), this);
			
			initMap();
			createPlayer();
			
			addEventListener(MouseEvent.MOUSE_DOWN, setFlag);
			player.addEventListener(Event.ENTER_FRAME, move);
		}
		
		private function initMap():void
		{
			for(var i:int=0;i<MAPWIDTH;i++)
			{
				aNodeMap[i] = new Array();
				for(var j:int=0;j<MAPHEIGHT;j++)
				{
					var dia:Grid = new Grid(DIAMONDW, DIAMONDH);
					dia.x = (j-i)*DIAMONDW/2;
					dia.y = (i+j)*DIAMONDH/2;
					addChild(dia);
					dia.IsBlock = mapData[i][j];
					
					aNodeMap[i][j] = dia.IsBlock;
					
					//					var txt:TextField = new TextField();
					//					txt.text = "("+dia.x+","+dia.y+")";
					//					txt.x = dia.x;
					//					txt.y = dia.y;
					//					addChild(txt);
				}
				
				astar = new AStar(aNodeMap);
				//				apos[1] * mapwidth + apos[0];
				astar.ndStart = new ANode([0,0], 0);
				astar.ndCurrent = new ANode([0, 0], 0);
				astar.ndEnd = new ANode([19, 19], 399);
			}
		}
		
		private function createBtn(label:String, position:Point, parent:DisplayObjectContainer):Button
		{
			var btn:Button = new Button();
			btn.x = position.x;
			btn.y = position.y;
			btn.label = label;
			parent.addChild(btn);
			btn.height = 25;
			btn.buttonMode = true;
			
			return btn;
		}
		
		private function createPlayer():void
		{
			player = new Shape();
			player.graphics.beginFill(0x00ffff);
			player.graphics.drawCircle(DIAMONDW/2, DIAMONDH/2, 5);
			player.graphics.endFill();
			this.addChild(player);
		}
	}
}