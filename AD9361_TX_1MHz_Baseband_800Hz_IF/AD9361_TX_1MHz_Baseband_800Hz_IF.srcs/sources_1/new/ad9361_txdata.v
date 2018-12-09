`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Noodle
// 
// Create Date: 2018/07/10 15:13:50
// Design Name: 
// Module Name: ad9361_txdata
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ad9361_txdata(
	input 						sys_rst,		// system reset from FPGA
	input 						fb_clk,			// feedback from DATA_CLK

	input 		signed [11:0] 	bb_i_path,		// baseband i path
	input 		signed [11:0] 	bb_q_path,		// baseband q path
	output reg 	signed [11:0] 	bb_iq,			// merge baseband i and q into individual path
    output reg 					tx_frame		// TX_FRAME
    );


reg 	[11:0] 	bb_q_path_buf;	// use for delay
integer 		swap_cnt;		

/*delay bb_q_path*/
always @(posedge fb_clk) begin
	if (sys_rst) begin
		bb_q_path_buf <= 0;
	end else begin
		bb_q_path_buf <= bb_q_path;
	end
end

/*build SDR timing for iq data transfer to p1_d*/
always @(negedge fb_clk) begin
	if (sys_rst) begin
		swap_cnt <= 0;
		tx_frame <= 0;
		bb_iq <= 0;
	end else begin
		case(swap_cnt) 
			0 : begin
				swap_cnt <= swap_cnt+1;
				tx_frame <= 1;		// indicate data is valid in TX_FRAME raising edge
				bb_iq <= bb_i_path;
			end
			1 : begin
				tx_frame <= 0;
				// bb_iq <= bb_q_path_buf;
				bb_iq <= bb_q_path;
				swap_cnt <= 0;
			end
			default : begin
				swap_cnt <= 0;
			end
		endcase
	end
end



endmodule
