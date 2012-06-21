/*

Webcam Texure Demo

Demonstrates:

How to create a WebcamTexure and apply it to a mesh

*/

package away3d.demos
{
	import away3d.containers.Scene3D;
	import away3d.core.math.Plane3D;
	import away3d.entities.Mesh;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.WebcamTexture;
	
	import away3d.base.HoverCamera3D;
	import away3d.base.VRBase;
	
	import flash.media.Camera;

	public class WebcamDemo extends VRBase
	{
		
		
		private var _scene			:Scene3D;
		private var _camera			:HoverCamera3D;
		private var _mesh			:Mesh;
		private var _webcamTexture	:WebcamTexture;
		private var _material		:TextureMaterial;
		
		/**
		 * Constructor
		 */
		public function WebcamDemo()
		{
			
		}
		
		/**
		 * Called once the view is initialised
		 */
		override protected function onInit():void
		{
			
			// create our scene
			_scene = new Scene3D();
			
			// create a hover camera and init its parameters
			_camera = new HoverCamera3D( this.stage );
			_camera.panAngle = 0;
			_camera.tiltAngle = 0;
			_camera.minTiltAngle = -30;
			_camera.maxTiltAngle = 30;
			_camera.z = 0;
			_camera.distance = 400;
			_camera.pLens.fieldOfView = 70;
			
			// add scene and camera to view
			view.scene = _scene;
			view.camera = _camera;
			
			// init webcam texture and material
			_webcamTexture = new WebcamTexture();
			_webcamTexture.flipHorizontal();
			_webcamTexture.flipVertical();
			_material = new TextureMaterial( _webcamTexture, true, false, false);
			
			// create mesh
			_mesh = new Mesh( new CubeGeometry(320, 240, 320, 1, 1, 1, false), _material );
			_mesh.rotationY = 180;
			_mesh.bakeTransformations();
			
			// add mesh
			_scene.addChild( _mesh );
			
		}
		
		/**
		 * Called before the view renders
		 */
		override protected function onPreRender():void
		{
			_mesh.rotationY++;
			_camera.hover();	
		}
	}
}