package
{
	import away3d.demos.WebcamDemo;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.osflash.signals.natives.NativeSignal;
	
	[SWF(backgroundColor="#000000", frameRate="30", quality="LOW")]

	public class Main extends Sprite
	{
		
		private var _webcamDemo:WebcamDemo;
		
		public function Main()
		{
			new NativeSignal( this, Event.ADDED_TO_STAGE ).addOnce( onAddedToStage );
		}
		
		private function onAddedToStage( e:Event ):void
		{
			runWebDemo();
		}
		
		private function runWebDemo():void
		{
			_webcamDemo = new WebcamDemo();
			addChild( _webcamDemo  );
			
			_webcamDemo.start();
		}
	}
}