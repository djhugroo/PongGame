// 
// Pong Game - top module
//
// Uriel Martinez-Hernandez
// Univesity of Bath
// November 2018 
//


module PongGame
(
	input CLOCK_50,
	input [3:0] KEY,
	input [9:0] SW,
	output logic VGA_CLK,
	output logic VGA_BLANK_N,
	output logic VGA_SYNC_N,
	output logic VGA_HS,
	output logic VGA_VS,
	output logic [ 7:0] VGA_R,
	output logic [ 7:0] VGA_G,
	output logic [ 7:0] VGA_B
);

	assign VGA_CLK = ~CLOCK_50;


	logic [11:0] xPos;			// current x position of hCount from the VGA controller
	logic [11:0] yPos;			// current y position of vCount from tge VGA controller

	
	logic [10:0] drawBall;
	logic [10:0] drawleftBar;
	logic [10:0] drawrightBar;
	logic [10:0] leftBarTop;
	logic [10:0] leftBarBottom;
	logic [10:0] leftBarLeft;
	logic [10:0] leftBarRight;
	logic [10:0] rightBarTop;
	logic [10:0] rightBarBottom;
	logic [10:0] rightBarLeft;
	logic [10:0] rightBarRight;
	
	
	
	// instantiation of the VGA controller
	VgaController vgaDisplay
	(
		.Clock(CLOCK_50),
		.Reset(SW[9]),
		.blank_n(VGA_BLANK_N),
		.sync_n(VGA_SYNC_N),
		.hSync_n(VGA_HS),
		.vSync_n(VGA_VS),
		.nextX(xPos),
		.nextY(yPos)
	);
	

	// instantiation of the slowClock module
	slowClock #(17) tick(CLOCK_50, SW[9], pix_stb);
	
	
	// instantiation of the ball module
	// oLeft and oTop define the x,y initial position of the object
	ball #(.oLeft(390), .oTop(290)) BallObj
	(
		.PixelClock(pix_stb),
		.Reset(SW[9]),
		.xPos(xPos),
		.yPos(yPos),
		.drawBall(drawBall),
		.leftBarLeft(leftBarLeft),
		.leftBarRight(leftBarRight),
		.leftBarTop(leftBarTop),
		.leftBarBottom(leftBarBottom),
		.rightBarLeft(rightBarLeft),
		.rightBarRight(rightBarRight),
		.rightBarTop(rightBarTop),
		.rightBarBottom(rightBarBottom)
	);
	
	// instantiation of the bar module
	// oLeft and oTop define the x,y initial position of the object
	bar #(.oLeft(30), .oTop(225)) leftbarObj
	(
		.PixelClock(pix_stb),
		.Reset(SW[9]),
		.xPos(xPos),
		.yPos(yPos),
		.drawbar(drawleftBar),
		.left(leftBarLeft),
		.right(leftBarRight),
		.top(leftBarTop),
		.bottom(leftBarBottom),
		.up(~KEY[3]),
		.down(~KEY[2])
	);
	
	// instantiation of the bar module
	// oLeft and oTop define the x,y initial position of the object
	bar #(.oLeft(720), .oTop(225)) rightbarObj
	(
		.PixelClock(pix_stb),
		.Reset(SW[9]),
		.xPos(xPos),
		.yPos(yPos),
		.drawbar(drawrightBar),
		.left(rightBarLeft),
		.right(rightBarRight),
		.top(rightBarTop),
		.bottom(rightBarBottom),
		.up(~KEY[1]),
		.down(~KEY[0])
	);

	
	// this block is used to draw all the objects on the screen
	// you can add more objects and their corresponding colour
	always_comb
	begin
		if( drawBall )														// if true from the ball module
			{VGA_R, VGA_G, VGA_B} = {8'hDC, 8'h14, 8'h3C};		// then draws the ball using crimson colour
		else
		begin		
		if( drawleftBar )													// if true from the bar module
			{VGA_R, VGA_G, VGA_B} = {8'hFF, 8'hD7, 8'h00};		// then draws the left bar using gold colour
		else
		begin
		if( drawrightBar)													// if true from the bar module
			{VGA_R, VGA_G, VGA_B} = {8'h00, 8'hBF, 8'hFF};		// then draws the right bar using deep sky blue colour
		else
			{VGA_R, VGA_G, VGA_B} = {8'h00, 8'h00, 8'h00};		// else draws the background using black colour
		end
		end
	end
	
endmodule