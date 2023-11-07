`timescale 1ns/10ps
`include "top.v"

module toptest;

  // DUT signals
  reg   clk_out1, OSC_in;
  reg   ADSout1, ADSout2, ADSout3, ADSout4, ADSout5, ADSout6, ADSout7, ADSout8, ADSout15;
  reg   pushbutton;  

  wire  PhaseA1, PhaseA2, PhaseA4;
  wire  PhaseC1, PhaseC2, PhaseC3, PhaseC4;
  wire  Sin1, Sin2, Sin3, Sin4, Sin5, Sin6, Sin7, Sin8, Sin9, Sin10, Sin11, Sin12, Sin14, Sin15, Sin16;
  wire  Rst, Rst1, Rst2;
  wire  DebugP2, DebugP3;
  wire  RS1, RS2, RS3, RS4, RS5, RS6, RS7, RS8;  //Row Select
  wire  ADRst1, ADRst2, ADRst3;
  wire  ADMode_1, ADMode_2, ADMode_3, ADMode1_1, ADMode1_2, ADMode1_3;
  wire  ADClk1, ADClk2, ADClk3;
  wire  Sout1, Sout2, Sout3, Sout4;
  wire  Clk1, Clk2, Clk3, Clk4;
  wire  ClkOut;
  wire  DataOut;
  wire  ResCS1, ResCS2, ResCS3, ResCS4, ResCS5, ResCS6, ResCS7, ResCS9; 
  wire  ResClk;
  wire  ResSDI1, ResSDI2;
  



    // Instantiate the Controller module
    top DUT (
        .PhaseA1(PhaseA1),
	.PhaseA2(PhaseA2),
	.PhaseA4(PhaseA4), 
	.Rst(Rst),
	.DebugP2(DebugP2), 
	.DebugP3(DebugP3), 
	.PhaseC1(PhaseC1), 
	.PhaseC2(PhaseC2), 
	.PhaseC3(PhaseC3), 
	.PhaseC4(PhaseC4),   
	.Sin3(Sin3),
    .Sin6(Sin6),
    .Sin5(Sin5),
    .Sin4(Sin4),
    .Sin2(Sin2),
    .Sin1(Sin1),
    .Sin7(Sin7),
   	.Sin8(Sin8),
    .Sin9(Sin9),
    .Sin10(Sin10),
    .Sin11(Sin11),
    .Sin12(Sin12),
    .Sin14(Sin14),
   	.Sin15(Sin15),
   	.Sin16(Sin16),
	.Clk1(Clk1),
	.Clk2(Clk2),
	.Clk3(Clk3),
	.Clk4(Clk4), 
  	.RS1(RS1),
    .RS2(RS2),
    .RS3(RS3),
    .RS4(RS4),
   	.RS5(RS5),
    .RS6(RS6),
    .RS7(RS7),
    .RS8(RS8),
    .ADMode_1(ADMode_1),
    .ADMode_2(ADMode_2),
    .ADMode_3(ADMode_3),
    .ADMode1_1(ADMode1_1),
    .ADMode1_2(ADMode1_2),
    .ADMode1_3(ADMode1_3),
    .ADRst1(ADRst1),
    .ADRst2(ADRst2),
    .ADRst3(ADRst3),
    .ADClk1(ADClk1),
    .ADClk2(ADClk2),
    .ADClk3(ADClk3),
    .ADSout1(ADSout1),
    .ADSout2(ADSout2),
    .ADSout3(ADSout3),
    .ADSout4(ADSout4),
    .ADSout5(ADSout5),
    .ADSout6(ADSout6),
    .ADSout7(ADSout7),
    .ADSout8(ADSout8),
	.ADSout15(ADSout15), 
    .Sout1(Sout1),
    .Sout2(Sout2),
    .Sout3(Sout3),
    .Sout4(Sout4),
	.ClkOut(ClkOut), 
	.DataOut(DataOut), 
	.ResCS3(ResCS3),
	.ResCS4(ResCS4),
	.ResCS5(ResCS5),
	.ResCS6(ResCS6),
	.ResCS7(ResCS7),
	.ResCS9(ResCS9),
	.ResClk(ResClk), 
	.OSC_in(OSC_in),
	.ResSDI1(ResSDI1), 
	.ResSDI2(ResSDI2)
);

    // Clock generation
    always begin
	//#1000 clk_out1 = ~clk_out1;
	#1000 OSC_in = ~OSC_in;
	//#0.0001 ResStep = ~ResStep;
    end

    // Testbench stimuli
    initial begin
     $dumpfile("cpld.vcd");
     $dumpvars;
        // Initialize signals

	 OSC_in = 0;
	 clk_out1= 0; 
	 ADSout1 = 0;
	 ADSout2 = 0;
	 ADSout3 = 0;
	 ADSout4 = 0;
	 ADSout5 = 0;
	 ADSout6 = 0;
	 ADSout7 = 0;
	 ADSout8 = 0;
	 ADSout15 = 0;

	 pushbutton = 0;
	 #1000
	 pushbutton = 1;
	 #1000000000
		
	 pushbutton = 0;
	 #8000
        $finish;  // End the simulation
    end

endmodule
