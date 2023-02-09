// 
// Pong Game - bar module
//
// Dhiren Jhugroo
// Univesity of Bath
// December 2018 
//


module bar
#(								// default values
	oLeft = 30,				// x position of the bar
	oTop = 225,				// y position of the bar
	oHeight = 150,			// height of the bar
	oWidth = 50,			// width of the bar
	sWidth = 800,			// width of the screen
	sHeight = 600,			// height of the screen
	yDirMove = 1			// bar movement in y direction
)
(
	input PixelClock,					// slow clock to display pixels
	input Reset,						// reset position/movement of the bar
	input  logic [11:0] xPos,		// x position of hCounter
	input  logic [11:0] yPos,		// y position of vCounter
	output logic drawbar,			// activates/deactivates drawing
	output logic [10:0] left,     // left(x) position of the bar
	output logic [10:0] right,    // right(x+width) position of the bar
	output logic [10:0] top,      // top(y) position of the bar
	output logic [10:0] bottom,   // bottom(y+height) position of the bar

	input up,
	input down
);



	logic [10:0] barX = oLeft;
	logic [10:0] barY = oTop;

	
	logic ydir = yDirMove;	

		
	assign left = barX;						// left(x) position of the bar
	assign right = barX + oWidth;		// right(x+width) position of the bar
	assign top = barY;						// top(y) position of the bar
	assign bottom = barY + oHeight;		// bottom(y+height) position of the bar

		
	always_ff @(posedge PixelClock)
	begin
		if( Reset == 1 )						// all values are initialised
			begin									// whenever the reset(SW[9]) is 1
				barY <= oTop;
				ydir <= yDirMove;
			end
		else
			begin
				
				if( ( up == 1 ) && ( top > 1 ) )
					barY <= barY - 1;
					
				if( ( down == 1 ) && ( bottom < sHeight) )
					barY <= barY + 1;

			end
	end


	// drawbar is 1 if the screen counters (hCount and vCount) are in the area of the bar
	// otherwise, drawbar is 0 and the bar is not drawn.
	// drawbar is used by the top module PongGame
	assign drawbar = ((xPos > left) & (yPos > top) & (xPos < right) & (yPos < bottom)) ? 1 : 0;

endmodule