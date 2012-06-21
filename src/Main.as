package
{
	import away3d.demos.CCTVDemo;
	import away3d.demos.WebcamDemo;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import org.osflash.signals.natives.NativeSignal;
	
	[SWF(backgroundColor="#000000", frameRate="30", quality="LOW")]

	public class Main extends Sprite
	{
		
		private var _webcamDemo:WebcamDemo;
		private var _cctvDemo:CCTVDemo;
		
		public function Main()
		{
			new NativeSignal( this, Event.ADDED_TO_STAGE ).addOnce( onAddedToStage );
		}
		
		private function onAddedToStage( e:Event ):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//runWebDemo();
			runCCTVDemo();
		}
		
		private function runCCTVDemo():void
		{
			_cctvDemo = new CCTVDemo();
			addChild( _cctvDemo );
			
			_cctvDemo.start();
		}
		
		private function runWebDemo():void
		{
			_webcamDemo = new WebcamDemo();
			addChild( _webcamDemo  );
			
			_webcamDemo.start();
		}
	}
}