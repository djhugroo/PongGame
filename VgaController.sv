// Tutorial session 10
// VGA controller


module VgaController
(
	input	logic 			Clock,
	input	logic			Reset,
	output	logic			blank_n,
	output	logic			sync_n,
	output	logic			hSync_n,
	output	logic 			vSync_n,
	output	logic	[11:0]	nextX,
	output	logic	[11:0]	nextY
);

	// use this signal as counter for the horizontal axis 
	logic [11:0] hCount;

	// use this signal as counter for the vertical axis
	logic [11:0] vCount;
	
	always_ff @(posedge Clock)
	begin
	
	if (Reset)
	begin
		hCount <= 1;
		vCount <= 1;
	end
	else
	begin
		if (hCount < 1040)
			hCount <= hCount + 1;
		else
		begin
			if (vCount < 666)
			begin
				hCount <= 1;
				vCount <= vCount + 1;
			end
			else
			begin
				hCount <= 1;
				vCount <= 1;
			end
		end
	end
		
			
	end
	
	assign nextX = (hCount < 800) ? hCount : nextX;
	
	assign nextY = (vCount < 600) ? vCount : nextY;
	
	assign blank_n = ( (hCount >= 800) || (vCount >= 600) ) ? 0 : 1;
	
	assign hSync_n = ( (hCount >= 856) && (hCount < 976) ) ? 0 : 1;
	
	assign vSync_n = ( (vCount >= 637) && (vCount < 643) ) ? 0 : 1;
	
	assign sync_n = ( ( (hCount >= 856) && (hCount < 976) ) || ((vCount >= 637) && (vCount < 643)) ) ? 0 : 1;

endmodule