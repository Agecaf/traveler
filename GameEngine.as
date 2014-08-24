package  
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Agecaf
	 */
	public class GameEngine extends Sprite
	{
		// Core
		public var main:Main;
		public var mode:Boolean = false;
		
		// Worlds
		public var worlds:Vector.<World>;
		public var currentWorld:int = 0;
		public const tw:int = 16;
		private var map:Vector.<Vector.<int>>;
		
		// Player
		public var p:Player;
		
		// Graphics
		public var masterSprite:Sprite;
		public var connectSprite:Sprite;
		
		// Connect sprite
		public var go_b:TextField = new TextField();
		public var reset_b:TextField = new TextField();
		public var back_b:TextField = new TextField();
		public const cw:int = 40;
		public var selectedWorld:int = -1;
		public var selectedFracture:int = -1;
		
		// Embedded graphics
		[Embed(source = "../lib/player.png")]
		public var player_s:Class;
		public var player_bd:BitmapData;
		
		[Embed(source = "../lib/tiles.png")]
		public var tiles_s:Class;
		public var tiles_bd:BitmapData;
		
		// Control
		public var tf:int = 0;
		public var tlimit:int = 1000;
		public var trem:int = 1000;
		public var btot:int = 10;
		public var bcur:int = 0;
		public var time_t:TextField = new TextField();
		public var blocks_t:TextField = new TextField();
		private var pix:int = 0;
		private var piy:int = 0;
		
		// Miscellaneous
		public var mat:Matrix = new Matrix();
		
		// Font
		[Embed(source="../lib/uni0553-webfont.ttf", embedAsCFF = "false", fontFamily = "Munro")]
		
		private const Munro:Class;
		public var font:TextFormat;
		
		public function GameEngine( parent:Main ) 
		{
			// Sets Core
			main = parent
			
			// Sets up font
			font = new TextFormat("Munro", 24, 0xB53441, {align:"center"});
			
			// Sets Worlds
			worlds = new Vector.<World>();
			
			// Sets mastersprite
			masterSprite = new Sprite();
			masterSprite.scaleX = masterSprite.scaleY = 2;
			makeText( time_t, font, 500, 10, "12 : 30", 200, 100 );
			makeText( blocks_t, font, 50, 10, "0 / 10", 100, 100 );
			addChild( masterSprite );
			addChild(time_t);
			addChild(blocks_t);
			masterSprite.mouseChildren = false;
			masterSprite.mouseEnabled = false;
			
			// Sets connectSprite
			connectSprite = new Sprite();
			addChild( connectSprite );
			makeText( go_b, font, 180, 150, "Start!", 200, 100 );
			makeText( reset_b, font, 80, 150, "Reset", 100, 100 );
			makeText( back_b, font, -10, 150, "Back", 100, 100 );
			connectSprite.addChild( go_b );
			connectSprite.addChild( reset_b );
			connectSprite.addChild( back_b );
			reset_b.addEventListener(MouseEvent.CLICK, reset_click);
			go_b.addEventListener(MouseEvent.CLICK, go_click);
			back_b.addEventListener(MouseEvent.CLICK, go_back);
			connectSprite.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			connectSprite.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			connectSprite.scaleX = connectSprite.scaleY = 2;
			connectSprite.x = 70;
			connectSprite.y = 40;
			
			
			// SEts embedded graphics
			player_bd = (new player_s()).bitmapData;
			tiles_bd = (new tiles_s()).bitmapData;
			
		}
		
		private function go_back(e:MouseEvent):void 
		{
			
			main.returnToMenu();
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			var nw:int = int(connectSprite.mouseX / ( cw * 2 )) + 3 * int(connectSprite.mouseY / ( cw * 2 ))  ;
			var ni:int = int(connectSprite.mouseX / cw ) % 2 + ( int(connectSprite.mouseY / cw) % 2 ) * 2;
			
			if (selectedWorld == -1) return;
			
			if (nw < 0 || nw >= worlds.length) {
				nw = -1;
				ni = -1;
				selectedWorld = -1;
				selectedFracture = -1;
				return;
			}
			
			if (ni < 0 || ni >= worlds[nw].fracturesW.length) {
				nw = -1;
				ni = -1;
				selectedWorld = -1;
				selectedFracture = -1;
				return;
			}
			
			if ( worlds[ nw ].fracturesW[ ni ] != -1 ) {
				var ww:int = worlds[ nw ].fracturesW[ ni ];
				var ii:int = worlds[ nw ].fracturesI[ ni ];
				worlds[ nw ].fracturesW[ ni ] = -1;
				worlds[ nw ].fracturesI[ ni ] = -1;
				worlds[ ww ].fracturesW[ ii ] = -1;
				worlds[ ww ].fracturesI[ ii ] = -1;
			}
			
			// connects selected and next
			worlds[ selectedWorld ].fracturesW[selectedFracture] = nw;
			worlds[ selectedWorld ].fracturesI[selectedFracture] = ni;
			worlds[ nw ].fracturesW[ ni ] = selectedWorld;
			worlds[ nw ].fracturesI[ ni ] = selectedFracture;
			
			
			selectedWorld = -1;
			selectedFracture = -1;
			
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			selectedWorld = int(connectSprite.mouseX / ( cw * 2 )) + 3 * int(connectSprite.mouseY / ( cw * 2 ))  ;
			selectedFracture = int(connectSprite.mouseX / cw ) % 2 + ( int(connectSprite.mouseY / cw) % 2 ) * 2;
			
			if (selectedWorld < 0 || selectedWorld >= worlds.length) {
				selectedWorld = -1;
				selectedFracture = -1;
				return;
			}
			
			if (selectedFracture < 0 || selectedFracture >= worlds[selectedWorld].fracturesW.length) {
				selectedWorld = -1;
				selectedFracture = -1;
				return;
			}
			
			if ( worlds[ selectedWorld ].fracturesW[ selectedFracture ] != -1 ) {
				var ww:int = worlds[ selectedWorld ].fracturesW[ selectedFracture ];
				var ii:int = worlds[ selectedWorld ].fracturesI[ selectedFracture ];
				worlds[ selectedWorld ].fracturesW[ selectedFracture ] = -1;
				worlds[ selectedWorld ].fracturesI[ selectedFracture ] = -1;
				worlds[ ww ].fracturesW[ ii ] = -1;
				worlds[ ww ].fracturesI[ ii ] = -1;
			}
			
			//trace(selectedWorld,selectedFracture)
		}
		
		private function go_click(e:MouseEvent):void 
		{
			restart();
		}
		
		private function reset_click(e:MouseEvent):void 
		{
			reset();
		}
		
		public function init( ctr:Object ):void
		{
			// Sets Worlds
			worlds.length = 0;
			var i:int = 0;
			btot = 0;
			for ( i = 0; i < ctr.worlds.length ; i++ ) {
				worlds.push( new World( this, ctr.worlds[i] ));
				btot += worlds[i].blockeysX.length;
			}
			currentWorld = 0;
			
			map = worlds[currentWorld].data;
			
			// Sets player
			pix = ctr.start[0];
			piy = ctr.start[1];
			p = new Player( this, pix * tw, piy * tw );
			
			// Sets mastersprite
			masterSprite.graphics.clear();
			
			// Control
			tlimit = ctr.time;
			bcur = 0;
			trem = tlimit;
			mode = false;
			
		}
		
		public function restart():void
		{
			p = new Player(this, pix * tw, piy * tw);
			currentWorld = 0;
			map = worlds[currentWorld].data;
			mode = true;
			masterSprite.visible = true;
			connectSprite.visible = false;
			for (var i:int = 0; i < worlds.length; i++ ) worlds[i].restart();
			main.play("main");
		}
		
		public function reset():void 
		{
			var i:int = 0;
			for (i = 0; i < worlds.length; i++ ) worlds[i].reset()
		}
		
		public function die():void {
			
			masterSprite.visible = false;
			connectSprite.visible = true;
			graphics.clear();
			mode = false;
			
			if ( btot > bcur ) {
				main.play("lose");
			} else {
				main.play("win");
			}
			
			bcur = 0;
			trem = tlimit;
			
			main.play("menu");
			
			
		}
		
		public function update( keys:Object ):void
		{
			if( mode ) {
			
				p.update( keys );
				
				draw();
				
				masterSprite.x = -p.x * 2 + 320; 
				masterSprite.y = -p.y * 2 + 220; 
				
				if ( p.y > tw * worlds[currentWorld].h) die();
				
				if( tf > 0 ) tf--;
				
				var i:int = 0;
				for ( i = 0; i < worlds[ currentWorld ].fracturesW.length; i++ ) {
					
					if (p.x - worlds[ currentWorld ].fracturesX[i] * tw < p.hw + tw
					&& p.x - worlds[ currentWorld ].fracturesX[i] * tw > -p.hw
					&& p.y - worlds[ currentWorld ].fracturesY[i] * tw < p.hw + tw
					&& p.y - worlds[ currentWorld ].fracturesY[i] * tw > -p.hw) {
						if ( worlds[ currentWorld ].fracturesW[i] == -1 || tf != 0 ) continue ;
						var ni:int = worlds[ currentWorld ].fracturesI[i]
						currentWorld = worlds[ currentWorld ].fracturesW[i]
						p.x = worlds[ currentWorld ].fracturesX[ni] * tw + tw *0.5;
						p.y = worlds[ currentWorld ].fracturesY[ni] * tw + tw - 1;
						tf = 20;
						main.play("frac");
						map = worlds[currentWorld].data;
					}
			
				}
				for ( i = 0; i < worlds[ currentWorld ].blockeysX.length; i++ ) {
					if (worlds[ currentWorld ].blockeysT[i]) continue;
					if (p.x - worlds[ currentWorld ].blockeysX[i] * tw < p.hw + tw
					&& p.x - worlds[ currentWorld ].blockeysX[i] * tw > -p.hw
					&& p.y - worlds[ currentWorld ].blockeysY[i] * tw < p.hw + tw
					&& p.y - worlds[ currentWorld ].blockeysY[i] * tw > -p.hw) {
						worlds[ currentWorld ].blockeysT[i] = true;
						bcur++;
						main.play("bloc");
						trem += 64;
						if (bcur == btot) win();
					}
				}
				
				// Control
				trem--;
				time_t.text = Math.floor(trem / 32).toString() + " : " + ( trem % 32 ).toString();
				blocks_t.text =  bcur.toString() + " / " + btot.toString();
				if (trem <= 0) die();
				
			}
			
			else {
				drawConnect();
			}
			
			
		} // End of public function update
		
		public function draw():void
		{
			// Sky
			masterSprite.graphics.clear();
			this.graphics.beginFill( worlds[currentWorld].cs );
			this.graphics.drawRect( 0, 0, 640, 480);
			this.graphics.endFill();
			
			// World
			var i:int = 0;
			var j:int = 0;
			var i2:int = worlds[ currentWorld ].w;
			var j2:int = worlds[ currentWorld ].h;
			for (		i = 0; i < i2; i++ ) {
				for (	j = 0; j < j2; j++ ) {
					switch( at(i, j) ) {
						
						case 0: 
							break;
						case 1: 
							mat.tx = i * tw;
							mat.ty = j * tw - worlds[ currentWorld ].cg * tw;
							if (at(i, j - 1) == 0) mat.tx -= tw;
							masterSprite.graphics.beginBitmapFill( tiles_bd, mat );
							masterSprite.graphics.drawRect(i * tw, j * tw, tw, tw);
							masterSprite.graphics.endFill();
							break;
					}
				}
			}
			
			
			// Player
			masterSprite.graphics.beginBitmapFill( player_bd, p.m );
			masterSprite.graphics.drawRect(p.x - p.hw, p.y - p.h, 2 * p.hw, p.h);
			masterSprite.graphics.endFill();
			
			// Fractures
			for ( i = 0; i < worlds[ currentWorld ].fracturesW.length; i++ ) {
				mat.tx = worlds[ currentWorld ].fracturesX[i] * tw;
				mat.ty = worlds[ currentWorld ].fracturesY[i] * tw - 7 * tw;
				masterSprite.graphics.beginBitmapFill( tiles_bd, mat );
				masterSprite.graphics.drawRect(worlds[ currentWorld ].fracturesX[i] * tw, worlds[ currentWorld ].fracturesY[i] * tw,tw, tw);
				masterSprite.graphics.endFill();
			
			}
			
			
			// Blockeys
			for ( i = 0; i < worlds[ currentWorld ].blockeysX.length; i++ ) {
				if (worlds[ currentWorld ].blockeysT[i]) continue;
				mat.tx = worlds[ currentWorld ].blockeysX[i] * tw;
				mat.ty = worlds[ currentWorld ].blockeysY[i] * tw - 8 * tw;
				masterSprite.graphics.beginBitmapFill( tiles_bd, mat );
				masterSprite.graphics.drawRect(worlds[ currentWorld ].blockeysX[i] * tw, worlds[ currentWorld ].blockeysY[i] * tw,tw, tw);
				masterSprite.graphics.endFill();
				
			}
			
		} // End of public function draw
		
		public function drawConnect():void {
			
			connectSprite.graphics.clear();
			connectSprite.graphics.beginFill(0xf0dc82);
			connectSprite.graphics.drawRect( -100, -100, 600, 600);
			connectSprite.graphics.endFill();
			
			// Worlds
			var i:int = 0;
			var j:int = 0;
			for ( i = 0; i < worlds.length; i++ ) {
				
				mat.tx = 2 * cw * ( i % 3 ) + cw - tw * 0.5 - tw;
				mat.ty = cw - tw * 0.5 + ( i > 2 ? 2 * cw : 0 ) - worlds[ i ].cg * tw;
				connectSprite.graphics.beginBitmapFill(tiles_bd, mat );
				connectSprite.graphics.drawRect(2 * cw * ( i % 3 ) + cw - tw * 0.5, cw - tw * 0.5 + ( i > 2 ? 2 * cw : 0 ), tw, tw);
				connectSprite.graphics.endFill();
				
				// Fractures
				
				for (j = 0; j < worlds[i].fracturesX.length; j++ ) {
					connectSprite.graphics.beginFill(0x000000 );
					connectSprite.graphics.drawCircle(2 * cw * ( i % 3 ) + cw * 0.5 + (j % 2) * cw , cw * 0.5 + ( i > 2 ? 2 * cw : 0 ) + int(j / 2) * cw, cw * 0.1);
					connectSprite.graphics.endFill();
					
					// Connections
					if ( worlds[i].fracturesW[j] != -1 ) {
						//trace("Woooo")
						connectSprite.graphics.lineStyle(2, 0xB53441);
						connectSprite.graphics.moveTo(2 * cw * ( i % 3 ) + cw * 0.5 + (j % 2) * cw , cw * 0.5 + ( i > 2 ? 2 * cw : 0 ) + int(j / 2) * cw);
						connectSprite.graphics.lineTo(2 * cw * ( worlds[i].fracturesW[j] % 3 ) + cw * 0.5 + (worlds[i].fracturesI[j] % 2) * cw ,
														cw * 0.5 + ( worlds[i].fracturesW[j] > 2 ? 2 * cw : 0 ) + int(worlds[i].fracturesI[j] / 2) * cw);
						connectSprite.graphics.lineStyle(0,0,0);
					}
				}
				
				
			}
			
			// Dragged line
			if (selectedWorld != -1) {
				connectSprite.graphics.lineStyle(2, 0xB53441);
						connectSprite.graphics.moveTo(2 * cw * ( selectedWorld % 3 ) + cw * 0.5 + (selectedFracture % 2) * cw ,
						cw * 0.5 + ( selectedWorld > 2 ? 2 * cw : 0 ) + int(selectedFracture / 2) * cw);
						connectSprite.graphics.lineTo(connectSprite.mouseX,	connectSprite.mouseY);
						connectSprite.graphics.lineStyle(0,0,0);
			}
			
			// Special fractures...
			var sw:int = int(connectSprite.mouseX / ( cw * 2 )) + 3 * int(connectSprite.mouseY / ( cw * 2 ))  ;
			var si:int = int(connectSprite.mouseX / cw ) % 2 + ( int(connectSprite.mouseY / cw) % 2 ) * 2;
			
			if (sw < 0 || sw >= worlds.length) {
				sw = -1;
				si = -1;
				return;
			}
			
			if (si < 0 || si >= worlds[sw].fracturesW.length) {
				sw = -1;
				si = -1;
				return;
			}
			
			connectSprite.graphics.beginFill(0x000000 );
			connectSprite.graphics.drawCircle(2 * cw * ( sw % 3 ) + cw * 0.5 + (si % 2) * cw , cw * 0.5 + ( sw > 2 ? 2 * cw : 0 ) + int(si / 2) * cw, cw * 0.2);
			connectSprite.graphics.endFill();
			
			var nw:int = worlds[ sw ].fracturesW[ si ];
			var ni:int = worlds[ sw ].fracturesI[ si ];
			
			if (nw != -1) {
				connectSprite.graphics.beginFill(0x000000 );
				connectSprite.graphics.drawCircle(2 * cw * ( nw % 3 ) + cw * 0.5 + (ni % 2) * cw , cw * 0.5 + ( nw > 2 ? 2 * cw : 0 ) + int(ni / 2) * cw, cw * 0.2);
				connectSprite.graphics.endFill();
			}
			
		}
		
		public function isSolid(xx:int, yy:int):Boolean { return at( Math.floor(xx / tw), Math.floor(yy / tw) ) == 1; }
		
		public function checkCollisions( type:String ):Boolean {
			switch( type ) {
				case "top": 	return isSolid( p.x - p.hw, p.y - p.h - 1 ) || isSolid( p.x + p.hw - 1, p.y - p.h - 1 ); break;
				case "bottom": 	return isSolid( p.x - p.hw, p.y ) || isSolid( p.x + p.hw - 1, p.y ); break;
				case "left":	return isSolid( p.x - p.hw - 1, p.y - 1) || isSolid( p.x - p.hw - 1, p.y - p.h); break;
				case "right": 	return isSolid( p.x + p.hw , p.y - 1) || isSolid( p.x + p.hw , p.y - p.h); break;
			}
			return false;
		} // End of function checkcollisions
		
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
		
		public function win ():void {
			die();
			main.returnToMenu();
		}
		
		public function at( x:int, y:int ):int { 
			if ( x < 0 || y < 0 || x >= map[0].length || y >= map.length ) return 0;
			return map[y][x];
		}
		
	}

}