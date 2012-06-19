package away3d.base
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class VRBase extends MovieClip
	{
		
		public var view:View3D;
		
		private var _debug:Boolean;
		
		protected var _stats:AwayStats;
		
		protected var started:Boolean = false;
		
		public function VRBase()
		{
			
			addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true );
			
		}
		
		
		//-------------------------------------------------------------------------------
		// protected methods for override
		//-------------------------------------------------------------------------------
		
		protected function onInit():void{};
		protected function onStageResize():void{};
		protected function onPreRender():void{};
		protected function onPostRender():void{};
		
		
		
		//-------------------------------------------------------------------------------
		// public methods for convinience
		//-------------------------------------------------------------------------------
		
		public function start():void
		{
			if(started) return;
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
			started = true;
		}
		
		override public function stop():void
		{
			stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			started = false;
			super.stop();
		}
		
		
		public function addChild3D( child:ObjectContainer3D ):void
		{
			
			if(!view)
			{
				trace("Make sure this sprite is added to the stage.");
				return;
			}
			
			view.scene.addChild( child );
		}
		
		public function removeChild3D( child:ObjectContainer3D ):void
		{
			
			if(!view)
			{
				trace("Make sure this sprite is added to the stage.");
				return;
			}
			
			if( view.scene.contains( child ) ) view.scene.removeChild( child );
		}
		
		
		public function random(min:Number,max:Number=NaN):int 
		{
			if (isNaN(max)) 
			{ 
				max = min; 
				min = 0;
			}
			return Math.floor( Math.random() * (max - min) + min );
		}
		
		
		
		//-------------------------------------------------------------------------------
		// Event Handlers
		//-------------------------------------------------------------------------------
		
		
		protected function addedToStageHandler( e:Event ):void
		{
			
			view = new View3D();
			addChild( view );
			
			stage.addEventListener(Event.RESIZE, stageResizeHandler, false, 0, true);
			removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );

			
			onInit();

		}
		
		
		
		protected function stageResizeHandler( e:Event ):void
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
			onStageResize();
		}
		
		protected function enterFrameHandler( e:Event ):void
		{
			onPreRender();
			view.render();
			onPostRender();
		}
		
		
		
		public function get debug():Boolean
		{
			return _debug;
		}
		
		public function set debug(value:Boolean):void
		{
			_debug = value;
			
			if(!view) return;
			
			if(value)
			{
				
				if(!_stats){
					_stats = new AwayStats( view );
					addChild( _stats );
				}
				
				_stats.visible = true;
				
			}
			else
			{
				if(_stats) _stats.visible = false;
			}
		}
		
	}
}