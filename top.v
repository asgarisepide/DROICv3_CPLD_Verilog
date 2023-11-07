module top(
	PhaseA1, PhaseA2, PhaseA4, 
	Rst,
	//Rst1,
	//Rst2, 
	DebugP2, DebugP3, 
	PhaseC1, PhaseC2, PhaseC3, PhaseC4, 
	Sin1, Sin2, Sin3, Sin4, Sin5, Sin6, Sin7, Sin8, Sin9, Sin10, Sin11, Sin12, Sin14, Sin15, Sin16,
	Clk1, Clk2, Clk3, Clk4, 
	RS1, RS2, RS3, RS4, RS5, RS6, RS7, RS8,
	ADMode_1, ADMode_2, ADMode_3,  ADMode1_1, ADMode1_2, ADMode1_3, 
	ADRst1, ADRst2, ADRst3, 
	ADClk1, ADClk2, ADClk3, 
	ADSout1, ADSout2, ADSout3, ADSout4, ADSout5, ADSout6, ADSout7, ADSout8, ADSout15,
	//AD0, AD1,
	Sout1,Sout2, Sout3,Sout4,
	ClkOut, 
	DataOut, 
	ResCS3, ResCS4, ResCS5, ResCS6, ResCS7, ResCS9, 
	ResClk, 
	ResSDI1, ResSDI2,
	OSC_in
);
	output reg  PhaseA1, Rst, DebugP2, DebugP3, PhaseC1;
	output wire PhaseC4, PhaseC2, PhaseC3;
	//output wire Rst1, Rst2; 
	output reg  Sin3; 
	output reg  Sin6;
	output      Sin5,Sin4,Sin2,Sin1, Sin7, Sin8, Sin9, Sin10, Sin11, Sin12, Sin14, Sin15, Sin16;
	output wire PhaseA2, PhaseA4;
	output reg  RS1=0, RS2=0, RS3=0, RS4=0, RS5=0, RS6=0, RS7=0, RS8=0;
	output wire ADRst1, ADRst2, ADRst3;
	output wire ADMode_1, ADMode_2, ADMode_3, ADMode1_1, ADMode1_2, ADMode1_3;
	output wire ADClk1, ADClk2, ADClk3;
	output wire Sout1, Sout2, Sout3,Sout4;
	input       ADSout1, ADSout2, ADSout3, ADSout4, ADSout5, ADSout6, ADSout7, ADSout8,ADSout15;
	input       OSC_in;
	//output reg  AD0,AD1;
	reg         ADMode, ADMode1;
	reg         ADRst;
	reg         ADClk;
	output reg  ClkOut, DataOut;
	
	
	
	output      ResCS3, ResCS4, ResCS5, ResCS6, ResCS7, ResCS9;
	output      ResClk; 
	output reg  ResSDI1, ResSDI2;
	reg         ResClkE;
	

	//assign Sout2 = DataOut;
	
	
	reg         Clk ;
	output wire Clk1, Clk2, Clk3, Clk4;
	
	wire        fpga_clock;

	//OSCH #(.NOM_FREQ("2.08")) rc_osc(.STDBY(1'b0), .OSC(fpga_clock));
	//pll pll(OSC_in, fpga_clock);
	//slow_counter counter(.clock(fpga_clock),.slow_clock(leds));
	
	localparam INIT=0, LOAD=1, INITR=2, LOADAR=3, LOADR=4, RST=5, INTG=6, PHASEC=7, DELAY=8, RS=9, SMPL=10, CNVRT=11, TRNSFR=12, STOP=13; 
	reg [4:0]   state=0;   // state register
	reg [4:0]   state_n;   // state register

	reg [31:0]  count=0;
	reg [4:0]   read_count =0 ;
//                          G2   G1 Fltr   Chnl 	
	reg [15:0]  confg = 16'b111_111_010_11_0000_1;
//                              G2   G1  Fltr   PR 	
	reg [15:0]  confg_exp = 16'b000_010_111_00_0000_0;
	
	wire [47:0] channel[0:3];
	
	//reg [ResDIV+1:0] ResStep;
	reg [3:0]   Resbitcount=0;
	reg [3:0]   ResCScount=0;
	reg [2:0]   CSnmbr=0;
	reg         ResCS=0;
	//reg [9:0] temp= 10'b0011001110;
	//                       17  27  25
	
	assign channel[0]=48'hFF00CD200000;
	assign channel[1]=48'h000000000000;
	
	
	reg [12:0]  countcur=0;
	localparam ResDIV=4;
	reg         ResStep=0;
	
	//assign Rst1 = Rst;
	//assign Rst2 = Rst;
	assign PhaseA2 = PhaseA1;
	assign PhaseA4 = PhaseA1;
	
	
	assign PhaseC2 = PhaseC1;
	assign PhaseC3 = PhaseC1;
	assign PhaseC4 = PhaseC1;
		
	// assign all the connection for programming inputs
	assign Sin1 = Sin3;
	assign Sin2 = Sin3;
	assign Sin4 = Sin3;
	assign Sin5 = Sin6;
	assign Sin9 = Sin3;
	assign Sin10 = Sin3;
	assign Sin11 = Sin3;
	assign Sin12 = Sin3;
	assign Sin14 = Sin3;
	assign Sin15 = Sin3;
	assign Sin16 = Sin3;
	
	assign Sin7 = Sin6;
	assign Sin8 = Sin6;
	
	
	
	//assign Clk1= Clk;
	//assign Clk2=  Clk;
	//assign Clk3=  Clk;
	//assign Clk4=  Clk;
	
	assign ADMode_1=ADMode;
	assign ADMode_2=ADMode;
	assign ADMode_3=ADMode;
	
	assign ADMode1_1=ADMode1;
	assign ADMode1_2=ADMode1;
	assign ADMode1_3=ADMode1;
	
	
	assign ADClk1=ADClk;
	assign ADClk2=ADClk;
	assign ADClk3=ADClk;
	
	
	assign ADRst1=ADRst;
	assign ADRst2=ADRst;
	assign ADRst3=ADRst;

	
	wire clk_out1;
	assign Clk1= (Clk)? clk_out1:1'b0;
	assign Clk2=  (Clk)? clk_out1:1'b0;
	assign Clk3=  (Clk)? clk_out1:1'b0;
	assign Clk4=  (Clk)? clk_out1:1'b0;
	
	assign ResClk = (ResClkE)? clk_out1:1'b0;
	// This CS will turn on DAC 7
	assign ResCS6= ResCS;
	assign ResCS7= ResCS;
	//assign ResCS5= ResCS;
	//assign ResCS4= ResCS;
	//assign ResCS3= ResCS;
	assign ResCS9 = ResCS;
	
	//(CSnmbr==0)? ResCS:1'b1;
   /*assign ResCS2=(CSnmbr==1)? ResCS:1'b1;
   assign ResCS3=(CSnmbr==2)? ResCS:1'b1;
   assign ResCS4=(CSnmbr==3)? ResCS:1'b1;*/
	
	assign Sout2 = (state==TRNSFR)? ADSout7:DataOut;
	assign Sout4 = (state==TRNSFR)? ADSout8:DataOut;
	//assign Sout2 = DataOut;
	assign Sout1 = ClkOut;
	assign Sout3 = (state==SMPL)?1:0;
	
	//pll1 p(OSC_in, clk_out1);
	
	
always @(negedge OSC_in) begin
	 PhaseA1 <= 0;
	 Rst <= 1;
	 Clk <= 0;
	 PhaseC1 <= 0;
	 DebugP2 <= 1;
	 DebugP3 <= 1;
	 Sin3<=0;
	 Sin6<=0;
	 RS1<=RS1;
	 RS2<=RS2;
	 RS3<=RS3;
	 RS4<=RS4;
	 RS5<=RS5;
	 RS6<=RS6;
	 RS7<=RS7;
	 RS8<=RS8;
	 ADRst<=0;
	 ADClk<=0;
	 ADClk<=0;
	 ADMode<=0;
	 ADMode1<=0;
	 //AD0<=0;
	 //AD1<=0;
	 ClkOut <=0;
	 DataOut<=0;
	 count <= count;
	 read_count <= read_count;
	 countcur <= countcur;
	 ResStep <= ResStep;
	 ResCScount <= ResCScount;
	 ResCS <= 1;
	 ResClkE <= 0;
	 ResSDI1 <= 0;
	 ResSDI2 <= 0;
	 //count<=0;
	case (state)
	INITR: begin
		//count<=count+1'b1;
		state<=LOADAR;
		ResCS <= 1;
		//if(countcur[2]==1)
		ResStep <= ~ResStep;
		Resbitcount<=0;
		if (ResCScount==6) begin
			ResCScount<=1'b0;
		    //CSnmbr<=CSnmbr+1'b1;
			count<=0;
			state<=RST;
		end
	end
	//load the address bits into digital potentiometer
   LOADAR: begin
	   Resbitcount<=Resbitcount+1'b1;
	   ResCS <= 0;
		ResClkE<=1;
		ResSDI1<=ResCScount[2-Resbitcount];
		ResSDI2<=ResCScount[2-Resbitcount];
		
		if (Resbitcount==2) begin
		   state<=LOADR;
		   Resbitcount<=0;
		end
	end
	//load data bits into digital potentiometer
	LOADR: begin
	   Resbitcount<=Resbitcount+1'b1;
		count<=count+1'b1;
		ResClkE<=1;
		ResCS <= 0;
		
		ResSDI1<= channel[ResStep][(((ResCScount+1)*8)-1-count)];
		ResSDI2<= channel[ResStep][(((ResCScount+1)*8)-1-count)];
		
		
		if (Resbitcount==7) begin
			Resbitcount<=0;
			ResCScount<=ResCScount+1'b1;
			count<=0;
			state<=INITR;
		end
	end
	INIT: begin
		count<=count+1'b1;
		Rst<=0;		
		
		PhaseA1<=1;
		state<=INIT;
		if (count[9]) begin
		   Rst<=1;
           state<=LOAD;
		   count<=0;
		end
	end
	LOAD: begin
		count<=count+1'b1;
		Sin3<= confg[(count[3:0])];
		Sin6<= confg_exp[(count[3:0])];
		//confg_exp[(count[3:0])];
		Rst<=1;		
		PhaseA1<=1;
		Clk<= 1;
		state<=LOAD;
		if (count==(16*5)-1) begin
			//count<=0;
			state<=RST;
		end
	end
	RST: begin
			
		count<=count+1'b1;
		PhaseA1<=1;
		Rst<=1;
		//state<=RST;
		//ClkOut<=1;
		if (count[6]) begin
           state<=INTG;
			//state<= SMPL;
		   count<=0;
		end
	end
	INTG: begin
		count<=count+1'b1;
		//change this to 1 to keep the opamp reset
		PhaseA1<=0;
		//for analog measurement
		Rst<=1;
		PhaseC1 <= 0;
		//for adc
		state<=INTG;
		if (count[10]) begin
			state<=PHASEC;
		    count<=0;
			//for analog measurement
			//ClkOut<=1;
		end
	end
	
	PHASEC: begin
		count<=count+1'b1;
		PhaseC1 <= 1;
		state<=PHASEC;
		Rst<=1;
		//RS3<=1;
		//RS7<=1;
		//DebugP2 <= 0;
		if (count[3]) begin
           //state<=SMPL;
		   state<=DELAY;
		   count<=0;
		end
	end
	DELAY: begin
		count<=count+1'b1;
		PhaseC1 <= 0;
		state<=DELAY;
		DebugP2 <= 1; 
		
		Rst<=1;
		if (count[3]) begin
            state<=SMPL;
			count<=0;
		  if(read_count==0) begin
			 RS1<=1; 
			 RS5<=1;
			 RS2<=0;
			 RS6<=0;
			 RS3<=0;
			 RS7<=1;
			 RS4<=0;			 
			 RS8<=0;
		  end else if(read_count==1) begin
			 RS1<=0; 
			 RS5<=0;
			 RS2<=1;
			 RS6<=1;
			 RS3<=0;
			 RS7<=0;
			 RS4<=0;			 
			 RS8<=0;
		  end else if(read_count==2) begin
			 RS1<=0; 
			 RS5<=0;
			 RS2<=0;
			 RS6<=0;
			 RS3<=1;
			 RS7<=1;
			 RS4<=0;			 
			 RS8<=0;
		  end else begin
			 RS1<=0; 
			 RS5<=0;
			 RS2<=0;
			 RS6<=0;
			 RS3<=0;
			 RS7<=0;
			 RS4<=0;			 
			 RS8<=0;
		  end 
		end
	end
	SMPL: begin
		state<=SMPL;
		//OutE<=0;
		count<=count+1'b1;
		ADRst<=0;
		ADMode<=1;
		Rst<=1;
		
		
		//ClkOut<=1;
		if (count[5]) begin
			state<=CNVRT;
			count<=0;
			
		end
		
		//if (count[3]) begin
           //state<=SMPL;
			//count<=0;
		//if(read_count==0) begin
		//you change these to some other rows to read other pickel
		//RS2<=1;
		//RS6<=1;
			//RS3<=1;
			//RS7<=1;
		//end
		//end
	end
	CNVRT: begin
		state<=CNVRT;
	    ADRst<=1;
		//OutE<=1;
	    count<=count+1'b1;
        ADClk<=count[0];
		ADMode<=1;		
		ADMode1<=0;
		Rst<=1;
		
		//RS3<=1;
		//RS7<=1;
		
		//if(read_count==0) begin
			ClkOut<=count[0];
			DataOut <= 1;
		//end else
		//	ClkOut<=0;
		
		//ClkOut<=count[0];
		//ClkOut<=0;
		if (count==9*2) begin
			state<=TRNSFR;
			count<=0;
			//countcur <=0;
		end
	end
	TRNSFR: begin 
		state<=TRNSFR;
		count<=count+1'b1;
		ADMode<=0;
		ADMode1<=1;
		ADRst<=1;
		Rst<=1;
		ClkOut<=count[0];
		
		//if(read_count >0)
			DataOut <= ADSout8;
		//else
		//	DataOut <= 0;
			
		if (count>2) begin
			ADClk<=count[0];		
		end	
		
		if (count==10*2) begin
			//if(read_count == 4) begin
			state<=STOP;
			//read_count <= 0;
			//end
			//else begin				
			//	read_count <= read_count + 1;
			//	state<=SMPL;
			//end
		   //countcur <=countcur+1'b1;
			count<=0;
			//countcur <=0;
		end
		
	end
	STOP: begin
		DataOut <= 0;
		/* FOR ADC */
		count<=count+1'b1;
		 
		ClkOut<=count[0];	
		state<=STOP;
		if (count==3*2) begin
           //state<=SMPL;
		   //state<=SMPL;
		   
		   if(read_count >= 2) begin
				
				//state<=INITR;
				//read_count <= 0;
				read_count <= 0;
				if(countcur[6]==1) begin
				state<=INITR;
				countcur <= 0;
				//read_count <= 0;
				end
				else begin
				countcur <= countcur +1;
				state<=RST;
				end
			end else begin				
				read_count <= read_count + 1;
				state<=DELAY;
			end
			
			//if(countcur[2])
			
			//else
			//state<=RST;
			count<=0;	
		end	
			
				//state<=RST;
		//end
		 
		 //state<=INITR;
		 //ClkOut<=0;
	end
	default : begin
		end
	endcase

	end
	

endmodule
/*
module slow_counter( clock, slow_clock);
		
		input wire clock;
		output reg slow_clock;
		
		reg [31:0] counter;
		
		initial
		begin
				slow_clock = 0;
				counter = 32'b0;
		end
		
		
		always @(posedge clock)
		begin
			if(counter[7])
			begin
			counter <= 0;
			slow_clock <= ~slow_clock;
			end
			else
			begin
						counter <= counter + 1 ;
				slow_clock <= slow_clock;
			end
		end
endmodule*/