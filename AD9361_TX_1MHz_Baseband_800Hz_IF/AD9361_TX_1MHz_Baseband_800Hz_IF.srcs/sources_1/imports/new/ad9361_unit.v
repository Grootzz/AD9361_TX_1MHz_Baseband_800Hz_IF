/***************************************************************************
 *
 * @file 		ad9361_unit.v
 * @brief 		AD9361 module, including AD9361 SPI configuration, AD9361 Rx
 * 				data interface.
 * @author 		Tang Tao, DSP Lab.
 * @date 		2017.6.12
 *
 ***************************************************************************/
`timescale 1ns / 1ps

module ad9361_unit(
	// 200MHz LVDS differential clock and high-valid reset signal.
	input 					sys_clk,
	input 					sys_rst,
	
	// AD9361 4-wire SPI interface.
	output 					ad9361_spi_cs,		// SPI_ENB
	output 					ad9361_spi_sclk,	// SPI_CLK
	output 					ad9361_spi_mosi,	// SPI_DI
	input 					ad9361_spi_miso,	// SPI_DO
	
	// AD9361 control signal.
	output 					en_agc,				// EN_AGC
	output 					enable,				// ENABLE
	output 					resetb,				// RESETB
	output 					txnrx,				// TXNRX
	output 					sync_in,			// SYNC_IN
	output 		[3 : 0]  	ctrl_in,			// CTRL_IN
	input  		[7 : 0]		ctrl_out,			// CTRL_OUT
	
	// AD9361 data interface.
	input 					data_clk,			// DATA_CLK		
	input 					rx_frame,			// RX_FRAME
	input signed [11 : 0]	p0_d,				// P1_DATA
	output 					fb_clk,				// FB_CLK
	output 					tx_frame,			// TX_FRAME
	output signed [11 : 0]	p1_d,				// P0_DATA
	
	// LED status signals.
	output 		 [7 : 0]  	led
);

	// AD9361 SPI init module inst.
	ad9361_init uut_ad9361_init (
		.sys_clk(sys_clk),
		.sys_rst(sys_rst),
		.ad9361_spi_cs(ad9361_spi_cs),
		.ad9361_spi_sclk(ad9361_spi_sclk),
		.ad9361_spi_mosi(ad9361_spi_mosi),
		.ad9361_spi_miso(ad9361_spi_miso),
		.en_agc(en_agc),
		.enable(enable),
		.resetb(resetb),
		.txnrx(txnrx),
		.sync_in(sync_in),
		.ctrl_in(ctrl_in),
		.ctrl_out(ctrl_out),
		.led(led)
	); 
	
wire 			m_axis_data_tvalid;
wire [31:0] 	m_axis_data_tdata;
wire			m_axis_phase_tvalid;
wire [15:0] 	m_axis_phase_tdata;

wire [11:0] 	i_path , q_path;

/*baseband iq data generator*/
dds_compiler_0 bb_iq_generator (
  .aclk(fb_clk),                                	// input wire aclk
  .m_axis_data_tvalid(m_axis_data_tvalid),    		// output wire m_axis_data_tvalid
  .m_axis_data_tdata(m_axis_data_tdata),      		// output wire [31 : 0] m_axis_data_tdata
  .m_axis_phase_tvalid(m_axis_phase_tvalid),  		// output wire m_axis_phase_tvalid
  .m_axis_phase_tdata(m_axis_phase_tdata)    		// output wire [15 : 0] m_axis_phase_tdata
);

assign i_path = m_axis_data_tdata[11:0];
assign q_path = m_axis_data_tdata[27:16];

assign fb_clk = data_clk;

/*convert two path data to individual path for p1_d port*/
ad9361_txdata ad9361_txdata_uut(
	.sys_rst(sys_rst),
	.fb_clk(fb_clk),
	.bb_i_path(i_path),
	.bb_q_path(q_path),
	.bb_iq(p1_d),
	.tx_frame(tx_frame)
);


endmodule
