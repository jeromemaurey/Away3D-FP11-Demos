package away3d.base
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.LensBase;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.core.base.Object3D;
	
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import org.osflash.signals.natives.NativeSignal;
	
	public class HoverCamera3D extends Camera3D
	{
		public static const toRADIANS:Number = Math.PI/180;
		
		
		public var panAngle:Number = 0;
		public var tiltAngle:Number = 90;
		public var distance:Number = 1;
		public var minTiltAngle:Number = -90;
		public var maxTiltAngle:Number = 90;
		public var minPanAngle:Number = -Infinity;
		public var maxPanAngle:Number = Infinity;
		public var steps:Number = 10;
		public var yfactor:Number = 2;
		public var wrapPanAngle:Boolean = false;
		public var target:Vector3D = new Vector3D();
		public var pLens:PerspectiveLens = new PerspectiveLens();
		public var enabled:Boolean = true;
		
		private var _currentPanAngle:Number = 0;
		private var _currentTiltAngle:Number = 90;
		
		private var _cameraSpeed:Number = 0.2;
		private var _lastMouseX:Number;
		private var _lastMouseY:Number;
		private var _lastPanAngle:Number;
		private var _lastTiltAngle:Number;
		private var _move:Boolean = false;
		
		private var _mouseDown	:NativeSignal;
		private var _mouseUp	:NativeSignal;
		private var _mouseMove	:NativeSignal;
		
		private var _stage:Stage;
		
		
		public function HoverCamera3D( stage:Stage )
		{
			super(pLens);
			
			_stage = stage;
			
			_mouseDown = new NativeSignal( stage, MouseEvent.MOUSE_DOWN );
			_mouseMove = new NativeSignal( stage, MouseEvent.MOUSE_MOVE );
			_mouseUp = new NativeSignal( stage, MouseEvent.MOUSE_UP );
			
			_mouseDown.add( onMouseDown );
		}
		
		public function hover(jumpTo:Boolean = false):Boolean
		{
			if (tiltAngle != _currentTiltAngle || panAngle != _currentPanAngle) {
				
				tiltAngle = Math.max(minTiltAngle, Math.min(maxTiltAngle, tiltAngle));
				
				panAngle = Math.max(minPanAngle, Math.min(maxPanAngle, panAngle));
				
				if (wrapPanAngle) {
					if (panAngle < 0)
						panAngle = (panAngle % 360) + 360;
					else
						panAngle = panAngle % 360;
					
					if (panAngle - _currentPanAngle < -180)
						panAngle += 360;
					else if (panAngle - _currentPanAngle > 180)
						panAngle -= 360;
				}
				
				if (jumpTo) {
					_currentTiltAngle = tiltAngle;
					_currentPanAngle = panAngle;
				} else {
					_currentTiltAngle += (tiltAngle - _currentTiltAngle)/(steps + 1);
					_currentPanAngle += (panAngle - _currentPanAngle)/(steps + 1);
				}
				
				//snap coords if angle differences are close
				if ((Math.abs(tiltAngle - _currentTiltAngle) < 0.01) && (Math.abs(panAngle - _currentPanAngle) < 0.01)) {
					_currentTiltAngle = tiltAngle;
					_currentPanAngle = panAngle;
				}
				
			}
			
			var gx:Number = target.x + distance*Math.sin(_currentPanAngle*toRADIANS)*Math.cos(_currentTiltAngle*toRADIANS);
			var gz:Number = target.z + distance*Math.cos(_currentPanAngle*toRADIANS)*Math.cos(_currentTiltAngle*toRADIANS);
			var gy:Number = target.y + distance*Math.sin(_currentTiltAngle*toRADIANS)*yfactor;
			
			if ((x == gx) && (y == gy) && (z == gz))
				return false;
			
			x = gx;
			y = gy;
			z = gz;
			
			lookAt( target );
			
			return true;
		}
		
		
		
		
		private function onMouseDown( e:MouseEvent ):void
		{
			
			if(!enabled) return;
			
			_lastPanAngle = panAngle;
			_lastTiltAngle = tiltAngle;
			_lastMouseX = _stage.mouseX;
			_lastMouseY = _stage.mouseY;
			_move = true;
			
			_mouseUp.add( onMouseUp );
			_mouseMove.add( onMouseMove );
		}
		
		private function onMouseUp( e:MouseEvent ):void
		{
			if(!enabled) return;
			
			_move = false;
			
			_mouseUp.remove( onMouseUp );
			_mouseMove.remove( onMouseMove );
			
		}
		
		private function onMouseMove( e:MouseEvent ):void
		{
			if(!enabled) return;
			
			if (_move) {
				panAngle = _cameraSpeed*(_lastMouseX - _stage.mouseX) + _lastPanAngle;
				tiltAngle = _cameraSpeed*(_lastMouseY - _stage.mouseY) + _lastTiltAngle;
			}
		}
	}
}