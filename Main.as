package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import org.as3yaml.YAML;

	/**
	 * ...
	 * @author Agecaf
	 */
	[Frame(factoryClass = "Preloader")]
	
	
	
	
	public class Main extends Sprite 
	{
		// Core
		private var ge:GameEngine;
		private var menu:Sprite;
		public var mode:Boolean;
		
		// World Data
		[Embed(source = "../lib/worlds.txt",mimeType="application/octet-stream")]
		private const WorldData:Class;
		private var universeData:Object;
		
		// Menu
		private var title_t:TextField = new TextField();
		private var stitle_t:TextField = new TextField();
		private var level1_b:TextField = new TextField();
		private var level2_b:TextField = new TextField();
		private var level3_b:TextField = new TextField();
		private var level4_b:TextField = new TextField();
		private var level5_b:TextField = new TextField();
		private var level6_b:TextField = new TextField();
		private var tutorial_t:TextField = new TextField();
		
		// Control
		private var keys:Object;
		
		// Music & SFX
		[Embed(source = "../lib/connected worlds.mp3")]
		private var main_m:Class;
		[Embed(source = "../lib/connected worlds block.mp3")]
		private var block_m:Class;
		[Embed(source = "../lib/connected worlds jump.mp3")]
		private var jump_m:Class;
		[Embed(source = "../lib/connected worlds land.mp3")]
		private var land_m:Class;
		[Embed(source = "../lib/connected worlds lose.mp3")]
		private var lose_m:Class;
		[Embed(source = "../lib/connected worlds menu.mp3")]
		private var menu_m:Class;
		[Embed(source = "../lib/connected worlds portal.mp3")]
		private var portal_m:Class;
		[Embed(source = "../lib/connected worlds win.mp3")]
		private var win_m:Class;
		
		
		private var music:SoundChannel;
		private var music2:SoundChannel;
		private var player_sfx:SoundChannel;
		private var worlds_sfx:SoundChannel;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			// Interprets worldData
			universeData = YAML.decode( (new WorldData).toString() );
			
			// Creates GE
			ge = new GameEngine( this );
			addChild( ge );
			ge.init( universeData[0] );
			ge.visible = false;
			
			// Creates Menu
			menu = new Sprite();
			addChild( menu );
			menu.graphics.beginFill(0xf0dc82);
			menu.graphics.drawRect( 0, 0, 640, 480);
			menu.graphics.endFill();
			ge.font.size = 48;
			makeText( title_t, ge.font, 50, 20, "Traveler", 300, 80 );
			ge.font.size = 24;
			makeText( stitle_t, ge.font, 100, 100, "(( a game by Agecaf ))", 500, 40 );
			makeText( level1_b, ge.font, 50, 200, "Level One", 200, 40 );
			makeText( level2_b, ge.font, 250, 200, "Level Two", 200, 40 );
			makeText( level3_b, ge.font, 450, 200, "Level Three", 200, 40 );
			makeText( level4_b, ge.font, 50, 300, "Level Four", 200, 40 );
			makeText( level5_b, ge.font, 250, 300, "Level Five", 200, 40 );
			makeText( level6_b, ge.font, 450, 300, "Level Six", 200, 40 );
			makeText( tutorial_t, ge.font, 100, 400, "WASD / Arrow Keys to move,\nClick + Drag to connect worlds.", 500, 80 );
			level1_b.addEventListener(MouseEvent.CLICK, function (e : MouseEvent) : void { startLevel(0) } );
			level2_b.addEventListener(MouseEvent.CLICK, function (e : MouseEvent) : void { startLevel(1) } );
			level3_b.addEventListener(MouseEvent.CLICK, function (e : MouseEvent) : void { startLevel(2) } );
			level4_b.addEventListener(MouseEvent.CLICK, function (e : MouseEvent) : void { startLevel(3) } );
			level5_b.addEventListener(MouseEvent.CLICK, function (e : MouseEvent) : void { startLevel(4) } );
			level6_b.addEventListener(MouseEvent.CLICK, function (e : MouseEvent) : void { startLevel(5) } );
			menu.addChild( title_t );
			menu.addChild( stitle_t );
			menu.addChild( level1_b );
			menu.addChild( level2_b );
			menu.addChild( level3_b );
			menu.addChild( level4_b );
			menu.addChild( level5_b );
			menu.addChild( level6_b );
			menu.addChild( tutorial_t );
			
			// Adds event Listeners
			
			keys = new Object();
			keys.up = false; 		keys.UP = false;
			keys.down = false; 		keys.DOWN = false;
			keys.left = false;		keys.LEFT = false;
			keys.right = false;		keys.RIGHT = false;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown );
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp );
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			stage.quality = "LOW";
			
		} // End of function init
		
		private function startLevel(number:int):void 
		{
			ge.init( universeData[number] );
			mode = true;
			ge.visible = true;
			menu.visible = false;
		}
		
		public function returnToMenu ():void {
			mode = false;
			ge.visible = false;
			menu.visible = true;
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (mode) {
				ge.update( keys );
				keys.UP = false;
				keys.DOWN = false;
				keys.LEFT = false;
				keys.RIGHT = false;
			} else {
				
			}
			
		}
		
		private function onKeyUp(e:KeyboardEvent):void 
		{
			switch( e.keyCode ) {
				case Keyboard.W:
				case Keyboard.UP: 		keys.UP 	= false; 	keys.up 	= false; break;
				case Keyboard.S:
				case Keyboard.DOWN: 	keys.DOWN 	= false; 	keys.down 	= false; break;
				case Keyboard.A:
				case Keyboard.LEFT: 	keys.LEFT 	= false; 	keys.left 	= false; break;
				case Keyboard.D:
				case Keyboard.RIGHT: 	keys.RIGHT 	= false; 	keys.right 	= false; break;
				default: //pass
			}
			
		} // End of function onKeyUp
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			switch( e.keyCode ) {
				case Keyboard.W:
				case Keyboard.UP: 		keys.UP 	= keys.up 	 ? false : true; 	keys.up 	= true; break;
				case Keyboard.S:
				case Keyboard.DOWN: 	keys.DOWN 	= keys.down  ? false : true; 	keys.down 	= true; break;
				case Keyboard.A:
				case Keyboard.LEFT: 	keys.LEFT 	= keys.left  ? false : true; 	keys.left 	= true; break;
				case Keyboard.D:
				case Keyboard.RIGHT: 	keys.RIGHT 	= keys.right ? false : true; 	keys.right 	= true; break;
				case Keyboard.R:	ge.die();
				default: //pass
			}
		} // End of function onKeyDown

		private function makeText( tfd:TextField, tfm:TextFormat, _x:int, _y:int, _text:String, _width:int, _height:int  ):void {
			//tfd = new TextField();
			tfd.embedFonts = true;
			tfd.defaultTextFormat = tfm;
			tfd.selectable = false;
			tfd.x = _x;
			tfd.y = _y;
			tfd.width = _width;
			tfd.height = _height;
			tfd.text = _text;
		}
		
		public function play(mus:String) : void {
			switch( mus ) {
				case "main" : if(music ) { music.stop() }; music = (new main_m()).play(0, 1000, new SoundTransform(1, 0)); break;
				case "menu" : if(music ) { music.stop() }; music = (new menu_m()).play(0, 1000, new SoundTransform(0.8, 0)); break;
				case "lose" : if(music2) { music2.stop() }; music2 = (new lose_m()).play(0, 1, new SoundTransform(1, 0)); break;
				case "win" : if(music2) { music2.stop() }; music2 = (new win_m()).play(0, 1, new SoundTransform(1, 0)); break;
				case "jump" : if(player_sfx) { player_sfx.stop() }; player_sfx = (new jump_m()).play(0, 1, new SoundTransform(0.4, 0)); break;
				case "land" : if(player_sfx) { player_sfx.stop() }; player_sfx = (new land_m()).play(0, 1, new SoundTransform(0.4, 0)); break;
				case "frac" : if(worlds_sfx) { worlds_sfx.stop() }; worlds_sfx = (new portal_m()).play(0, 1, new SoundTransform(0.3, 0)); break;
				case "bloc" : if(worlds_sfx) { worlds_sfx.stop() }; worlds_sfx = (new block_m()).play(0, 1, new SoundTransform(0.3, 0)); break;
			}
		}
		
	} // End of class Main

	
} // End of package