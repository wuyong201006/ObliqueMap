package
{
	import fl.controls.Button;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import org.osmf.events.TimeEvent;
	
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
		private var gridMap:Array;
		private var astar:AStar;
		private var bMove:Boolean;
		
		private var aPath:Array;
		private var pathpoint:int;
		private var timer:Timer;
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
			timer.start();
			
			if(IsPause && !aPath && aPath[pathpoint])
			{
				IsPause = false;
				astar.ndStart = new ANode([aPath[pathpoint][0], aPath[pathpoint][1]], aPath[pathpoint][1]*20+aPath[pathpoint][0]);
			}
			astar.ndEnd = new ANode([19, 19], 399);
			if(astar.DoSearch())
			{
				bMove = true;
				aPath = astar.aPath;
				pathpoint = aPath.length-1;
			}
		}
		
		private var IsPause:Boolean=false;
		private function clickPause(event:MouseEvent):void
		{
			bMove = false;
			IsPause = true;
		}
		
		private function clickReset(event:MouseEvent):void
		{
			for(var i:int=0;i<aNodeMap.length;i++)
			{
				for(var j:int=0;j<aNodeMap[0].length;j++)
				{
					var grid:Grid = gridMap[i][j];
					grid.IsBlock = false;
					
					aNodeMap[i][j] = 0;
					astar.nodeMap = aNodeMap;
				}
			}
			player.x = 0;
			player.y = /*DIAMONDH/2*/0;
			astar.ndStart = new ANode([0,0], 0);
			astar.ndCurrent = new ANode([0, 0], 0);
		}
		
		private function setFlag(event:MouseEvent):void
		{
			if(event.target is Grid)
			{
				var grid:Grid = event.target as Grid;
				grid.IsBlock = true;
				
				aNodeMap[grid.indexI][grid.indexJ] = 1;
				astar.nodeMap = aNodeMap;
			}
		}
		
		private function move(event:TimerEvent):void
		{
			if(bMove)
			{
				if(!aPath || aPath.length <= 0)return;
				if(pathpoint >= 0)
				{
					player.x = (aPath[pathpoint][1] -aPath[pathpoint][0])*DIAMONDW/2;
					player.y = (aPath[pathpoint][1]+aPath[pathpoint][0])*DIAMONDH/2;
					pathpoint--;
				}
				else
				{
					bMove = false;
					timer.stop();
				}
			}
		}
		
		private function init():void
		{
			bMove = false;
			aNodeMap = new Array();
			gridMap = new Array();
			aPath = new Array();
			pathpoint = 0;
			
			start = createBtn("开始", new Point(150, 15), this);
			start.addEventListener(MouseEvent.CLICK, clickStart);
			
			pause = createBtn("暂停", new Point(250, 15), this);
			pause.addEventListener(MouseEvent.CLICK, clickPause);
			
			reset = createBtn("重置", new Point(350, 15), this);
			reset.addEventListener(MouseEvent.CLICK, clickReset);
			
			initMap();
			createPlayer();
			
			timer = new Timer(100);
			timer.addEventListener(TimerEvent.TIMER, move);
//			player.addEventListener(Event.ENTER_FRAME, move);
		}
		
		private function initMap():void
		{
			for(var i:int=0;i<MAPWIDTH;i++)
			{
				aNodeMap[i] = new Array();
				gridMap[i] = new Array();
				for(var j:int=0;j<MAPHEIGHT;j++)
				{
					var dia:Grid = new Grid(DIAMONDW, DIAMONDH, i, j);
					dia.x = (j-i)*DIAMONDW/2;
					dia.y = (i+j)*DIAMONDH/2;
					addChild(dia);
					dia.IsBlock = mapData[i][j];
					
					aNodeMap[i][j] = dia.IsBlock;
					dia.addEventListener(MouseEvent.MOUSE_DOWN, setFlag);
					gridMap[i][j] = dia;
					
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
//				astar.ndEnd = new ANode([19, 19], 399);
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