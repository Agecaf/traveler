package  
{
	/**
	 * ...
	 * @author Agecaf
	 */
	public class World 
	{
		
		// Core
		private var ge:GameEngine;
		public var data:Vector.<Vector.<int>>;
		
		// Fractures
		public var fracturesX:Vector.<int>;
		public var fracturesY:Vector.<int>;
		public var fracturesW:Vector.<int>;
		public var fracturesI:Vector.<int>;
		
		// blocKeys
		public var blockeysX:Vector.<int>;
		public var blockeysY:Vector.<int>;
		public var blockeysT:Vector.<Boolean>;
		
		// Color
		public var cg:int = 0;
		public var cs:int = 0;
		
		
		public function World( _ge:GameEngine, ctr:Object ) 
		{
			// Sets Core
			ge = _ge;
			
			// Sets data
			var i:int = 0;
			var j:int = 0;
			data = new Vector.<Vector.<int>>();
			for ( i = 0; i < ctr.data.length; i++ ) {
				data.push( new Vector.<int>() )
				for (j = 0; j < ctr.data[0].length; j++ ) {
					data[i].push(ctr.data[i][j]);
				}
			}
			
			// Sets fractures
			fracturesI = new Vector.<int>();
			fracturesW = new Vector.<int>();
			fracturesX = new Vector.<int>();
			fracturesY = new Vector.<int>();
			for ( i = 0; i < ctr.fractures.length; i++ ) {
				fracturesI.push( -1 );
				fracturesW.push( -1 );
				fracturesX.push( ctr.fractures[i][0] );
				fracturesY.push( ctr.fractures[i][1] );
			}
			
			// Sets blockeys
			blockeysT = new Vector.<Boolean>();
			blockeysX = new Vector.<int>();
			blockeysY = new Vector.<int>();
			for ( i = 0; i < ctr.blockeys.length; i++ ) {
				blockeysT.push( false );
				blockeysX.push( ctr.blockeys[i][0] );
				blockeysY.push( ctr.blockeys[i][1] );
				
			}
			
			// Colos
			cg = ctr.cg;
			
			switch(ctr.cs) {
				case 0: cs = 0xAAFFAA; break;
				case 1: cs = 0xAAAAFF; break;
				case 2: cs = 0xEEEE88; break;
				case 3: cs = 0x88EEEE; break;
				case 4: cs = 0xEE88EE; break;
				default: cs = 0xFFAAAA;
			}
			
		} // End of constructor
		
		public function at( x:int, y:int ):int { 
			if ( x < 0 || y < 0 || x >= data[0].length || y >= data.length ) return 0;
			return data[y][x];
		}
		
		public function reset():void 
		{
			trace(14)
			var i:int = 0;
			for (i = 0; i < fracturesX.length; i++ ) {
				fracturesI[i] = -1;
				fracturesW[i] = -1;
			}
		}
		
		public function restart():void 
		{
			for (var i:int = 0; i < blockeysT.length; i++ ) blockeysT[i] = false;
		}
		
		public function get w ( ):int { return data[0].length; }
		public function get h ( ):int { return data.length; }
		
	} // End of class

}