package  
{
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author Agecaf
	 */
	public class Player 
	{
		// Core
		private var ge:GameEngine;
		
		// Kinetic Properties
		public var x:int;
		public var y:int;
		public var vx:Number;
		public var vy:Number;
		public var ax:Number;
		public var ay:Number;
		
		// Static Properties
		public const hw:int = 4;
		public const h:int = 8;
		
		// Boolean Properties
		public var onGround:Boolean = true;	// Change this before update
		public var gliding:Boolean = false;	// Change this before update
		public var wall:Boolean = false;	// Change this before update
		public var iddle:Boolean = false;	// Change this before update
		public var dir:Boolean = false;
		
		// Miscellaneous
		public var m:Matrix = new Matrix();
		public var t:int = 0;
		
		public function Player( game_engine:GameEngine, ix:int, iy:int ) 
		{
			// Sets Core
			ge = game_engine;
			
			// Sets initial Properties
			x = ix; 	y = iy;
			vx = 0; 	vy = 0;
			ax = 0; 	ay = 0;
			
		} // End of constructor
		
		public function update( keys:Object ) : void
		{
			// Conditionals
			wall = ge.checkCollisions("right") || ge.checkCollisions("left");
			if (!ge.checkCollisions("bottom")) onGround = false;
			
			// Acceleration
			// Vertical
			ay = 0.50;
			if (onGround || wall) {
				if (keys.UP) {
					vy = -7;
					onGround = false;
					ge.main.play("jump");
				}
			} else {
				if ( gliding ) {
					ay = -0.05;
					if (!keys.up) {
						gliding = false;
					}
				} else {
					if (keys.UP) {
						gliding = true;
						vy *= 0.2;
						t = 0;
					}
				}
			}
			
			// Horizontal
			if (gliding) {
				if (keys.right) {
					ax = 0.5;
				}
				if (keys.left) {
					ax = -0.5;
				}
			} else { 
				if( onGround ) {
					if (keys.right) {
						ax = 0.9;
					}
					if (keys.left) {
						ax = -0.9;
					} 
				}else {
					if (keys.right) {
						ax = 0.3;
					}
					if (keys.left) {
						ax = -0.3;
					}
				}
			}
			if (!keys.left && !keys.right ) ax = 0;
			
			
			
			// Velocity
			// Vertical
			vy += ay;
			
			// Horizontal
			iddle = vx < 0.5 && vx > -0.5;
			dir = vx > 0 ? true : vx < 0 ? false : dir;
			if ( !gliding ) {
				vx += ax;
				vx = vx > 4 ? 4 : vx < -4 ? -4 : vx;
				
				if (onGround) {
					if (!keys.left && !keys.right ) vx *= 0.4;
				}
			}
			else if (gliding) {
				if (onGround) gliding = false;
				vx += ax;
				vx = vx > 5 ? 5 : vx < -5 ? -5 : vx;
			}
			if (wall && !ge.checkCollisions("bottom") && keys.UP ) {
				if (ge.checkCollisions("right")) {
					vx = -3;
				}if (ge.checkCollisions("left")) {
					vx = 3;
				}
			}
			
			// Displacement
			var i:int = Math.round(vx);
			while ( i != 0 ) {
				if (i > 0) {
					if (ge.checkCollisions("right")) { i = 0; vx = 0;  }
					else { x++; i--;  }
					
				}
				if (i < 0) {
					if (ge.checkCollisions("left")) { i = 0; vx = 0;  }
					else { x--; i++;  }
				}
			}
			
			i = Math.round(vy); 
			while ( i != 0 ) {
				if (i > 0) {
					if (ge.checkCollisions("bottom")) { i = 0; if (vy > 1.5) { ge.main.play("land"); }; vy = 0; onGround = true; }
					else { y++; i--;  }
					
				}
				if (i < 0) {
					if (ge.checkCollisions("top")) { i = 0; vy = 0; }
					else { y--; i++;  }
				}
			}
			
			
			// Frame
			t++;
			if (onGround) {
				if (iddle) {
					makeM( int(t / 10) % 2, dir );
				} else {
					makeM( int(t / 5) % 4 + 2, dir );
				}
			} else {
				if (gliding) {
					if ( t < 12 ) {
						makeM( int(t / 3) % 4 + 10, dir );
					} else {
						makeM( int(t / 6) % 2 + 14, dir );
					}
				} else {
					if (vy > 0) {
						makeM( int(t / 10) % 2 + 8, dir );
					} else {
						makeM( int(t / 10) % 2 + 6, dir );
					}
				}
			}
			if (wall) {
				makeM( 16, dir );
			}
			
		}
		
		private function makeM( n:int, flip:Boolean ):void {
			
			// Flip
			m.a = flip ? 1 : -1;
			
			// Clip
			m.tx =  0;// * (!flip ? -1 : 1);
			m.ty =  - n * h;
			
			// Moves to player position
			m.tx += x - hw;
			m.ty += y - h;
			
		}
		
	} // End of class

}