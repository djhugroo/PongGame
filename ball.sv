// 
// Pong Game - ball module
//
// Uriel Martinez-Hernandez
// Univesity of Bath
// November 2018 
//


module ball
#(								// default values
	oLeft = 10,				// x position of the ball
	oTop = 10,				// y position of the ball
	oHeight = 20,			// height of the ball
	oWidth = 20,			// width of the ball
	sWidth = 800,			// width of the screen
	sHeight = 600,			// height of the screen
	xDirMove = 1,			// ball movement in x direction
	yDirMove = 1			// ball movement in y direction
)
(
	input PixelClock,					// slow clock to display pixels
	input Reset,						// reset position/movement of the ball
	input  logic [11:0] xPos,		// x position of hCounter
	input  logic [11:0] yPos,		// y position of vCounter
	output logic drawBall,			// activates/deactivates drawing
	input [10:0] leftBarLeft,
	input [10:0] leftBarRight,
	input [10:0] leftBarTop,
	input [10:0] leftBarBottom,
	input [10:0] rightBarLeft,
	input [10:0] rightBarRight,
	input [10:0] rightBarTop,
	input [10:0] rightBarBottom
);

	logic [10:0] left;						
	logic [10:0] right;						
	logic [10:0] top;
	logic [10:0] bottom;

	logic [10:0] ballX = oLeft;
	logic [10:0] ballY = oTop;

	logic xdir = xDirMove;
	logic ydir = yDirMove;	

		
	assign left = ballX;						// left(x) position of the ball
	assign right = ballX + oWidth;		// right(x+width) position of the ball
	assign top = ballY;						// top(y) position of the ball
	assign bottom = ballY + oHeight;		// bottom(y+height) position of the ball

		
	always_ff @(posedge PixelClock)
	begin
		if( Reset == 1 )						// all values are initialised
			begin									// whenever the reset(SW[9]) is 1
				ballX <= oLeft;
				ballY <= oTop;
				xdir <= xDirMove;
				ydir <= yDirMove;
			end
		else
			begin
				ballX <= (xdir == 1) ? ballX + 1 : ballX - 1;	// changes movement of the ball in x direction
				ballY <= (ydir == 1) ? ballY + 1 : ballY - 1;	// changes movement of the ball in y direction
				
				// these lines determine the direction of movement
				// based on the correct position of the ball wrt the screen OR the left bar OR the right bar
				if( top  <= 1 )
					ydir <= 1;

				if( bottom >= sHeight )
					ydir <= 0;

				if( left <= 1 )
				begin
					ballX <= oLeft;
				   ballY <= oTop;
				   xdir <= xDirMove;
				   ydir <= yDirMove;
				end

				if( right >= sWidth )
				begin
					ballX <= oLeft;
				   ballY <= oTop;
				   xdir <= xDirMove;
				   ydir <= yDirMove;
				end
					
					
				if( ( top == leftBarBottom ) || ( top == rightBarBottom ) )
					begin
					if( ( (top <= leftBarBottom)&&(bottom >= leftBarTop)&&(left <= leftBarRight)&&(right >= leftBarLeft) ) || ( (top <= rightBarBottom)&&(bottom >= rightBarTop)&&(left <= rightBarRight)&&(right >= rightBarLeft) ) )
						ydir <= 1;
					end
				
				if( ( bottom == leftBarTop ) || ( bottom == rightBarTop ) )
					begin
					if( ( (top <= leftBarBottom)&&(bottom >= leftBarTop)&&(left <= leftBarRight)&&(right >= leftBarLeft) ) || ( (top <= rightBarBottom)&&(bottom >= rightBarTop)&&(left <= rightBarRight)&&(right >= rightBarLeft) ) )
						ydir <= 0;
					end
						
				if( ( left == leftBarRight ) || ( left == rightBarRight ) )
					begin
					if( ( (top <= leftBarBottom)&&(bottom >= leftBarTop)&&(left <= leftBarRight)&&(right >= leftBarLeft) ) || ( (top <= rightBarBottom)&&(bottom >= rightBarTop)&&(left <= rightBarRight)&&(right >= rightBarLeft) ) )
						xdir <= 1;
					end
						
				if( ( right == leftBarLeft ) || ( right == rightBarLeft ) )
					begin
					if( ( (top <= leftBarBottom)&&(bottom >= leftBarTop)&&(left <= leftBarRight)&&(right >= leftBarLeft) ) || ( (top <= rightBarBottom)&&(bottom >= rightBarTop)&&(left <= rightBarRight)&&(right >= rightBarLeft) ) )
						xdir <= 0;
					end
					
			end
	end


	// drawBall is 1 if the screen counters (hCount and vCount) are in the area of the ball
	// otherwise, drawBall is 0 and the ball is not drawn.
	// drawBall is used by the top module PongGame
	assign drawBall = ((xPos > left) & (yPos > top) & (xPos < right) & (yPos < bottom)) ? 1 : 0;

endmodule