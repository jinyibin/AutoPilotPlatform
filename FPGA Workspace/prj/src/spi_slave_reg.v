/***************************************************************************************************************
--Module Name:  spi_slave_reg
--Author     :  Jin
--Description:  
                polarity = 0     : idle state of spi clock is low level 
					 phase    = 0     : sample data at the rising edge，send data out at the falling edge
					 16 bits frame    : MSB first
					 data frame format: 2 * 16bits frame-- {address[15:14], address[13:0], data[15:0]}
					                    address[15:14]: 2'b00   write
										                     2'b11   read
             
--History    :  2015-04-13  Created by Jin.                      
***************************************************************************************************************/

`timescale 1ns/100ps
`define  ADDR_NUM 14

module spi_slave_reg
(
    input   wire        clk  ,
    input   wire        rst_n,
            
    input   wire        rx_data_ready,
    input   wire[15:0]  rx_data, 
    output  wire        tx_data_ready,
    output  reg [15:0]  tx_data,
            
    
    input   wire        spi_clk_error,        
    input   wire[31:0]  version    ,// version of this project 
    
	  		 	  
    output  reg [15:0]  reg_baudrate_main,
    output  reg [15:0]  reg_baudrate_01  ,
    output  reg [15:0]  reg_baudrate_02  ,
    output  reg [15:0]  reg_baudrate_03  ,
    output  reg [15:0]  reg_baudrate_04  ,
    output  reg [15:0]  reg_baudrate_05  ,
    output  reg [15:0]  reg_baudrate_06  ,
    output  reg [15:0]  reg_baudrate_07  ,
    output  reg [15:0]  reg_baudrate_08  ,
    output  reg [15:0]  reg_baudrate_09  ,
    output  reg [15:0]  reg_baudrate_10  ,
    output  reg [15:0]  reg_baudrate_11  ,
    output  reg [15:0]  reg_baudrate_12  ,
    output  reg [15:0]  reg_baudrate_13  ,
    output  reg [15:0]  reg_baudrate_14  ,
    output  reg [15:0]  reg_baudrate_15  ,
    output  reg [15:0]  reg_baudrate_16  ,
    output  reg [15:0]  reg_baudrate_17  ,
    output  reg [15:0]  reg_baudrate_18  ,
    output  reg [15:0]  reg_baudrate_19  ,
    output  reg [15:0]  reg_baudrate_20  ,
    
    output  reg [ 7:0]  reg_timer_trig01 ,
    output  reg [ 7:0]  reg_timer_trig02 ,
    output  reg [ 7:0]  reg_timer_trig03 ,
    output  reg [ 7:0]  reg_timer_trig04 ,
    output  reg [ 7:0]  reg_timer_trig05 ,
    output  reg [ 7:0]  reg_timer_trig06 ,
    output  reg [ 7:0]  reg_timer_trig07 ,
    output  reg [ 7:0]  reg_timer_trig08 ,
    output  reg [ 7:0]  reg_timer_trig09 ,
    output  reg [ 7:0]  reg_timer_trig10 ,
    output  reg [ 7:0]  reg_timer_trig11 ,
    output  reg [ 7:0]  reg_timer_trig12 ,
    output  reg [ 7:0]  reg_timer_trig13 ,
    output  reg [ 7:0]  reg_timer_trig14 ,
    output  reg [ 7:0]  reg_timer_trig15 ,
    output  reg [ 7:0]  reg_timer_trig16 ,
    output  reg [ 7:0]  reg_timer_trig17 ,
    output  reg [ 7:0]  reg_timer_trig18 ,
    output  reg [ 7:0]  reg_timer_trig19 ,
    output  reg [ 7:0]  reg_timer_trig20 ,
      
    output  reg         frame_lost_error 

);
//---------------------------------------------------------------------------------------------------------------
    parameter   IDLE   =   2'b00 ,
                READ   =   2'b01 ,
		        WRITE  =   2'b10 ;
    //--------------------------------------------------------------------------------------------------------------- 
    parameter   READ_FRAME      =   2'b11 ,
			    WRITE_FRAME     =   2'b00 ,
			    FRAME_LOST_TIME = 12'd2400 ; 
    //--------------------------------------------------------------------------------------------------------------- 
               /*   register table   */
    parameter   VERSION_ADDR0           =   'h0001 , 
                VERSION_ADDR1           =   'h0002 , 
                BAUDRATE_MAIN_ADDR      =   'h0003 , 
                BAUDRATE_01_ADDR        =   'h0004 ,       
    		    BAUDRATE_02_ADDR        =   'h0005 ,
    		    BAUDRATE_03_ADDR        =   'h0006 , 
			    BAUDRATE_04_ADDR        =   'h0007 , 
			    BAUDRATE_05_ADDR        =   'h0008 , 
			    BAUDRATE_06_ADDR        =   'h0009 , 
			    BAUDRATE_07_ADDR        =   'h000A , 
			    BAUDRATE_08_ADDR        =   'h000B , 
			    BAUDRATE_09_ADDR        =   'h000C ,  
			    BAUDRATE_10_ADDR        =   'h000D , 
			    BAUDRATE_11_ADDR        =   'h000E , 
			    BAUDRATE_12_ADDR        =   'h000F , 
			    BAUDRATE_13_ADDR        =   'h0010 , 
			    BAUDRATE_14_ADDR        =   'h0011 , 
			    BAUDRATE_15_ADDR        =   'h0012 , 
			    BAUDRATE_16_ADDR        =   'h0013 , 
			    BAUDRATE_17_ADDR        =   'h0014 , 
			    BAUDRATE_18_ADDR        =   'h0015 , 
			    BAUDRATE_19_ADDR        =   'h0016 , 
			    BAUDRATE_20_ADDR        =   'h0017 ,
			    FPGA_STATUS_ADDR        =   'h0018 ,  
			    REG_TIMER_TRIG01_ADDR   =   'h0019 ,
			    REG_TIMER_TRIG02_ADDR   =   'h001A ,
			    REG_TIMER_TRIG03_ADDR   =   'h001B ,
			    REG_TIMER_TRIG04_ADDR   =   'h001C ,
			    REG_TIMER_TRIG05_ADDR   =   'h001D ,
			    REG_TIMER_TRIG06_ADDR   =   'h001E ,
			    REG_TIMER_TRIG07_ADDR   =   'h001F ,
			    REG_TIMER_TRIG08_ADDR   =   'h0020 ,
			    REG_TIMER_TRIG09_ADDR   =   'h0021 ,
			    REG_TIMER_TRIG10_ADDR   =   'h0022 ,
			    REG_TIMER_TRIG11_ADDR   =   'h0023 ,
			    REG_TIMER_TRIG12_ADDR   =   'h0024 ,
			    REG_TIMER_TRIG13_ADDR   =   'h0025 ,
			    REG_TIMER_TRIG14_ADDR   =   'h0026 ,
			    REG_TIMER_TRIG15_ADDR   =   'h0027 ,
			    REG_TIMER_TRIG16_ADDR   =   'h0028 ,
			    REG_TIMER_TRIG17_ADDR   =   'h0029 ,
			    REG_TIMER_TRIG18_ADDR   =   'h002A ,
			    REG_TIMER_TRIG19_ADDR   =   'h002B ,
			    REG_TIMER_TRIG20_ADDR   =   'h002C ;
			                                       
			                                       
			                                       
			    
			                         
 			                        
			   
//---------------------------------------------------------------------------------------------------------------
    reg [1:0]   state     ;
    reg [1:0]   next_state;
    always @ (posedge clk or negedge rst_n)  begin
	    if(!rst_n)
		    state <= IDLE;
	    else
		    state <= next_state; 
    end
//---------------------------------------------------------------------------------------------------------------	
     /* count the time between address frame and data frame  */
    reg [11:0]  frame_interval_counter;
    always @ (posedge clk or negedge rst_n)begin
        if(!rst_n )
	        frame_interval_counter <= 12'd0;
	    else if(state == IDLE)
	        frame_interval_counter <= 12'd0;
	    else if(state == READ)
	        frame_interval_counter <= frame_interval_counter + 12'd1;
	    else if(state == WRITE)
	        frame_interval_counter <= frame_interval_counter + 12'd1;
    end

    //--------------------------------------------------------------------------------------------------------------- 
    /*  signify an error if data frame did not show up FRAME_LOST_TIME after address frame  */
	
	always @ (posedge clk or negedge rst_n)begin
	    if(!rst_n)
	        frame_lost_error <= 1'b0;
	    else if(frame_interval_counter == FRAME_LOST_TIME)
	        frame_lost_error <= 1'b1;
	    else
	        frame_lost_error <= 1'b0;
    end
    //---------------------------------------------------------------------------------------------------------------
     /*  tx_data_ready ,active for one clk cycle   */
    reg [1:0]  tx_data_ready_d;
    always @ (posedge clk or negedge rst_n)begin
        if(!rst_n)
	        tx_data_ready_d <= 2'b00;
	    else begin
	        if(state == READ)   begin
	            tx_data_ready_d[0] <= 1'b1;
			    tx_data_ready_d[1] <= tx_data_ready_d[0];
		    end
	        else   begin
	            tx_data_ready_d[0] <= 1'b0;
			    tx_data_ready_d[1] <= 1'b0;
		    end
	    end
	end
	assign tx_data_ready = tx_data_ready_d[0] &(~tx_data_ready_d[1]);
//---------------------------------------------------------------------------------------------------------------	
       /*  latch R/W address  */
	reg [`ADDR_NUM-1:0]    reg_address;
	
	always @ (posedge clk or negedge rst_n) begin
	    if(!rst_n)
		    reg_address <= `ADDR_NUM'd0;
	    else if(state == IDLE) begin 
    	    if(rx_data_ready)
		        reg_address <= rx_data[`ADDR_NUM-1:0];
		    else
		        reg_address <= `ADDR_NUM'd0;
	    end
	    else
		    reg_address <= reg_address;	
    end 
//---------------------------------------------------------------------------------------------------------------	  
    reg [7:0]  error1;
    reg [7:0]  error2;
    reg        spi_clk_error_buf;
    wire       spi_clk_error_edge;
    always @ (posedge clk or negedge rst_n)begin
        if(!rst_n)
            spi_clk_error_buf <= 1'b0;
        else begin
            spi_clk_error_buf <= spi_clk_error;
        end	
    end
    assign spi_clk_error_edge=spi_clk_error & (~spi_clk_error_buf);

    always @ (posedge clk or negedge rst_n)begin
        if(!rst_n)
    	    error1 <= 8'd0;
        else if(spi_clk_error_edge)
            error1 <= error1 + 1'b1;
    end


    always @ (posedge clk or negedge rst_n)begin
        if(!rst_n)
    	    error2 <= 8'd0;
        else if(frame_lost_error)
            error2 <= error2 + 1'b1;
    end   			 
//---------------------------------------------------------------------------------------------------------------	
       /*  write register  */
    always @ (posedge clk or negedge rst_n)   begin
	    if(!rst_n)   begin
            reg_baudrate_main  <= 16'd217;
            reg_baudrate_01    <= 16'd217;
            reg_baudrate_02    <= 16'd217;
            reg_baudrate_03    <= 16'd217;
            reg_baudrate_04    <= 16'd217;
            reg_baudrate_05    <= 16'd217;
            reg_baudrate_06    <= 16'd217;
            reg_baudrate_07    <= 16'd217;
            reg_baudrate_08    <= 16'd217;
            reg_baudrate_09    <= 16'd217;
            reg_baudrate_10    <= 16'd217;
            reg_baudrate_11    <= 16'd217;
            reg_baudrate_12    <= 16'd217;
            reg_baudrate_13    <= 16'd217;
            reg_baudrate_14    <= 16'd217;
            reg_baudrate_15    <= 16'd217;
            reg_baudrate_16    <= 16'd217;
            reg_baudrate_17    <= 16'd217;
            reg_baudrate_18    <= 16'd217;
            reg_baudrate_19    <= 16'd217;
            reg_baudrate_20    <= 16'd217; 
            reg_timer_trig01   <=  8'd20 ;
            reg_timer_trig02   <=  8'd20 ;
            reg_timer_trig03   <=  8'd20 ;
            reg_timer_trig04   <=  8'd20 ;
            reg_timer_trig05   <=  8'd20 ;
            reg_timer_trig06   <=  8'd20 ;
            reg_timer_trig07   <=  8'd20 ;
            reg_timer_trig08   <=  8'd20 ;
            reg_timer_trig09   <=  8'd20 ;
            reg_timer_trig10   <=  8'd20 ;
            reg_timer_trig11   <=  8'd20 ;
            reg_timer_trig12   <=  8'd20 ;
            reg_timer_trig13   <=  8'd20 ;
            reg_timer_trig14   <=  8'd20 ;
            reg_timer_trig15   <=  8'd20 ;
            reg_timer_trig16   <=  8'd20 ;
            reg_timer_trig17   <=  8'd20 ;
            reg_timer_trig18   <=  8'd20 ;
            reg_timer_trig19   <=  8'd20 ;
            reg_timer_trig20   <=  8'd20 ;

	    end
	    else if((state == WRITE) && rx_data_ready) begin
            if     (reg_address==BAUDRATE_MAIN_ADDR    )      reg_baudrate_main  <= rx_data; 
            else if(reg_address==BAUDRATE_01_ADDR      )      reg_baudrate_01    <= rx_data;
            else if(reg_address==BAUDRATE_02_ADDR      )      reg_baudrate_02    <= rx_data;
            else if(reg_address==BAUDRATE_03_ADDR      )      reg_baudrate_03    <= rx_data;
            else if(reg_address==BAUDRATE_04_ADDR      )      reg_baudrate_04    <= rx_data;
            else if(reg_address==BAUDRATE_05_ADDR      )      reg_baudrate_05    <= rx_data;
            else if(reg_address==BAUDRATE_06_ADDR      )      reg_baudrate_06    <= rx_data;
            else if(reg_address==BAUDRATE_07_ADDR      )      reg_baudrate_07    <= rx_data;
            else if(reg_address==BAUDRATE_08_ADDR      )      reg_baudrate_08    <= rx_data;		 
            else if(reg_address==BAUDRATE_09_ADDR      )      reg_baudrate_09    <= rx_data;
            else if(reg_address==BAUDRATE_10_ADDR      )      reg_baudrate_10    <= rx_data;
            else if(reg_address==BAUDRATE_11_ADDR      )      reg_baudrate_11    <= rx_data;
            else if(reg_address==BAUDRATE_12_ADDR      )      reg_baudrate_12    <= rx_data;
            else if(reg_address==BAUDRATE_13_ADDR      )      reg_baudrate_13    <= rx_data;   
            else if(reg_address==BAUDRATE_14_ADDR      )      reg_baudrate_14    <= rx_data;   
            else if(reg_address==BAUDRATE_15_ADDR      )      reg_baudrate_15    <= rx_data;   
            else if(reg_address==BAUDRATE_16_ADDR      )      reg_baudrate_16    <= rx_data;   
            else if(reg_address==BAUDRATE_17_ADDR      )      reg_baudrate_17    <= rx_data;	
            else if(reg_address==BAUDRATE_18_ADDR      )      reg_baudrate_18    <= rx_data;   
            else if(reg_address==BAUDRATE_19_ADDR      )      reg_baudrate_19    <= rx_data;   
            else if(reg_address==BAUDRATE_20_ADDR      )      reg_baudrate_20    <= rx_data;
            else if(reg_address==REG_TIMER_TRIG01_ADDR )      reg_timer_trig01   <= rx_data[7:0];    
            else if(reg_address==REG_TIMER_TRIG02_ADDR )      reg_timer_trig02   <= rx_data[7:0];
            else if(reg_address==REG_TIMER_TRIG03_ADDR )      reg_timer_trig03   <= rx_data[7:0];
            else if(reg_address==REG_TIMER_TRIG04_ADDR )      reg_timer_trig04   <= rx_data[7:0];
            else if(reg_address==REG_TIMER_TRIG05_ADDR )      reg_timer_trig05   <= rx_data[7:0];
            else if(reg_address==REG_TIMER_TRIG06_ADDR )      reg_timer_trig06   <= rx_data[7:0];
            else if(reg_address==REG_TIMER_TRIG07_ADDR )      reg_timer_trig07   <= rx_data[7:0];
            else if(reg_address==REG_TIMER_TRIG08_ADDR )      reg_timer_trig08   <= rx_data[7:0];
            else if(reg_address==REG_TIMER_TRIG09_ADDR )      reg_timer_trig09   <= rx_data[7:0];
            else if(reg_address==REG_TIMER_TRIG10_ADDR )      reg_timer_trig10   <= rx_data[7:0];
            else if(reg_address==REG_TIMER_TRIG11_ADDR )      reg_timer_trig11   <= rx_data[7:0];
            else if(reg_address==REG_TIMER_TRIG12_ADDR )      reg_timer_trig12   <= rx_data[7:0];
            else if(reg_address==REG_TIMER_TRIG13_ADDR )      reg_timer_trig13   <= rx_data[7:0];
            else if(reg_address==REG_TIMER_TRIG14_ADDR )      reg_timer_trig14   <= rx_data[7:0];
            else if(reg_address==REG_TIMER_TRIG15_ADDR )      reg_timer_trig15   <= rx_data[7:0];
            else if(reg_address==REG_TIMER_TRIG16_ADDR )      reg_timer_trig16   <= rx_data[7:0];
            else if(reg_address==REG_TIMER_TRIG17_ADDR )      reg_timer_trig17   <= rx_data[7:0];
            else if(reg_address==REG_TIMER_TRIG18_ADDR )      reg_timer_trig18   <= rx_data[7:0];
            else if(reg_address==REG_TIMER_TRIG19_ADDR )      reg_timer_trig19   <= rx_data[7:0];
            else if(reg_address==REG_TIMER_TRIG20_ADDR )      reg_timer_trig20   <= rx_data[7:0];
               
        end
    end
//---------------------------------------------------------------------------------------------------------------	
       /*  read register  */
    always @ (posedge clk)   begin
	    if(state == READ)   begin
            if     (reg_address==VERSION_ADDR0      )       tx_data <= version[15: 0];
	        else if(reg_address==VERSION_ADDR1      )       tx_data <= version[31:16];                                                 
		    else if(reg_address==BAUDRATE_MAIN_ADDR )       tx_data <= reg_baudrate_main;                                                
		    else if(reg_address==BAUDRATE_01_ADDR   )       tx_data <= reg_baudrate_01  ;
		    else if(reg_address==BAUDRATE_02_ADDR   )       tx_data <= reg_baudrate_02  ;
		    else if(reg_address==BAUDRATE_03_ADDR   )       tx_data <= reg_baudrate_03  ;
		    else if(reg_address==BAUDRATE_04_ADDR   )       tx_data <= reg_baudrate_04  ;
		    else if(reg_address==BAUDRATE_05_ADDR   )       tx_data <= reg_baudrate_05  ;
		    else if(reg_address==BAUDRATE_06_ADDR   )       tx_data <= reg_baudrate_06  ;
		    else if(reg_address==BAUDRATE_07_ADDR   )       tx_data <= reg_baudrate_07  ;                                       
		    else if(reg_address==BAUDRATE_08_ADDR   )       tx_data <= reg_baudrate_08  ;
		    else if(reg_address==BAUDRATE_09_ADDR   )       tx_data <= reg_baudrate_09  ;
		    else if(reg_address==BAUDRATE_10_ADDR   )       tx_data <= reg_baudrate_10  ;
		    else if(reg_address==BAUDRATE_11_ADDR   )       tx_data <= reg_baudrate_11  ;
		    else if(reg_address==BAUDRATE_12_ADDR   )       tx_data <= reg_baudrate_12  ;
		    else if(reg_address==BAUDRATE_13_ADDR   )       tx_data <= reg_baudrate_13  ;
		    else if(reg_address==BAUDRATE_14_ADDR   )       tx_data <= reg_baudrate_14  ;                                    
		    else if(reg_address==BAUDRATE_15_ADDR   )       tx_data <= reg_baudrate_15  ;
		    else if(reg_address==BAUDRATE_16_ADDR   )       tx_data <= reg_baudrate_16  ;
			else if(reg_address==BAUDRATE_17_ADDR   )       tx_data <= reg_baudrate_17  ;
			else if(reg_address==BAUDRATE_18_ADDR   )       tx_data <= reg_baudrate_18  ;                                              
			else if(reg_address==BAUDRATE_19_ADDR   )       tx_data <= reg_baudrate_19  ;
		    else if(reg_address==BAUDRATE_20_ADDR   )       tx_data <= reg_baudrate_20  ;	
		    else if(reg_address==FPGA_STATUS_ADDR   )       tx_data <= {error2,error1}  ;                                                               
        end
	    else 
	        tx_data <= 16'd0;
    end
  
     
    //--------------------------------------------------------------------------------------------------------------- 

    always@(*)  begin
        next_state = IDLE;
        case(state)
	        IDLE   : if(rx_data_ready && (rx_data[15:14]==WRITE_FRAME))
			            next_state = WRITE ;
				    else if(rx_data_ready && (rx_data[15:14]==READ_FRAME))
						  next_state = READ;	
						else
				        next_state = IDLE;		
			READ   : if(rx_data_ready || (frame_interval_counter == FRAME_LOST_TIME))
			           next_state = IDLE ;
						else 
		              next_state = READ;
			WRITE  : if(rx_data_ready || (frame_interval_counter == FRAME_LOST_TIME))
			           next_state = IDLE ;
						else 
		              next_state = WRITE;
			default: next_state = IDLE;
	    endcase
    end
endmodule