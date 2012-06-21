package away3d.demos
{
	import away3d.base.HoverCamera3D;
	import away3d.base.VRBase;
	import away3d.entities.Mesh;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.CCTVTexture;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	
	public class CCTVDemo extends VRBase
	{
		
		private var _cctvScreen:Mesh;
		private var _cctvScreen2:Mesh;
		private var _cctcMaterial:CCTVTexture;
		private var _cubes:Vector.<Mesh>;
		private var _direction:int;
		private var _center:Vector3D = new Vector3D();
		private var _mainLight:PointLight;
		private var _camera:HoverCamera3D;
		
		
		public function CCTVDemo()
		{
			super();
		}
		
		override protected function onInit():void
		{
			
			// set background color and AA level
			view.backgroundColor = 0x444444;
			view.antiAlias = 4;
			
			// create a hover camera and init its parameters
			_camera = new HoverCamera3D( this.stage );
			_camera.panAngle = 180;
			_camera.tiltAngle = 0;
			_camera.minTiltAngle = -30;
			_camera.maxTiltAngle = 30;
			_camera.z = 0;
			_camera.distance = 600;
			_camera.pLens.fieldOfView = 70;
			
			view.camera = _camera;
			
			// init main light
			_mainLight = new PointLight();
			_mainLight.castsShadows = true;
			_mainLight.shadowMapper.depthMapSize = 1024;
			_mainLight.y = 120;
			_mainLight.color = 0xffffff;
			_mainLight.diffuse = 1;
			_mainLight.specular = 1;
			_mainLight.radius = 400;
			_mainLight.fallOff = 500;
			_mainLight.ambient = 0xa0a0c0;
			_mainLight.ambient = .5;
			addChild3D(_mainLight);
			
			
			// add a bunch of cubes to render something!
			_cubes = new Vector.<Mesh>;
			
			var cube:Mesh;
			var mat:ColorMaterial;
			var cubeGeom:CubeGeometry = new CubeGeometry();
			
			for(var i:int = 0; i < 10; ++i)
			{
				mat = new ColorMaterial( Math.random() * 0xFF0000 );
				mat.lightPicker = new StaticLightPicker([_mainLight]);
				cube = new Mesh( cubeGeom, mat );
				cube.y = random( -200, 200);
				cube.x = 120 * (i-5);
				addChild3D( cube );
				_cubes.push( cube );
				
				TweenMax.to( cube, random(2, 6), { y: cube.y * -1, ease:Back.easeOut, yoyo:true, repeat: -1} );
			}
			
			
			// create a CCTV Material and 2 planes to render on
			_cctcMaterial = new CCTVTexture( view, 320, 240, this, null, 256 );
			_cctcMaterial.camera.x = 600;
			_cctcMaterial.camera.z = -280;
			_cctcMaterial.camera.lookAt( _center );
			_cctcMaterial.greyscale = true;
			_cctcMaterial.cameraTarget = _cubes[4];
			_cctcMaterial.border = 6;
			
			var planeGeom:PlaneGeometry = new PlaneGeometry(160, 120, 1, 1, false);
			var bmMat:TextureMaterial = new TextureMaterial( _cctcMaterial, true, false, false );
			
			_cctvScreen = new Mesh( planeGeom, bmMat );
			_cctvScreen.position = view.camera.position;
			_cctvScreen.y = -40;
			_cctvScreen.x = -100;
			_cctvScreen.z = -180;
			_cctvScreen.rotationY = -30;
			
			_cctvScreen2 = new Mesh( planeGeom, bmMat );
			_cctvScreen2.y = -40;
			_cctvScreen2.x = 100;
			_cctvScreen2.z = -300;
			_cctvScreen2.rotationY = 30;
			
			addChild3D( _cctvScreen );
			addChild3D( _cctvScreen2 );
			
			// animation direction
			_direction = -1;
			
			// show stats
			debug = true;
			
			// add on mouse down
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler, false, 0, true);
			
			_cctcMaterial.start();
			
		}
		
		override protected function onPreRender():void
		{
			_camera.hover();
		}
		
		override protected function onPostRender():void
		{
			
			// update camera position
			_cctcMaterial.camera.x += 4 * _direction;
			if(_cctcMaterial.camera.x < -600) _direction = 1;
			else if( _cctcMaterial.camera.x > 600 )  _direction = -1;
			
		}
		
		private function stageMouseDownHandler(e:MouseEvent):void
		{
			// toggle greyscale
			_cctcMaterial.greyscale = (_cctcMaterial.greyscale)? false : true;
			
			// switch camera target
			_cctcMaterial.cameraTarget = _cubes[ Math.floor(random(0, _cubes.length-1)) ];
		}
	}
}