
`timescale 1 ns/10 ps

module uart_rx_ctrl( 
    input   wire        clk                 ,
    input   wire        rst_n               ,
    input   wire        clk_100k            ,
    
    input   wire [7:0]  uart_rx_data        ,
    input   wire        uart_rx_data_ready  ,
    //触发UART接受到的数据上传时间，单位10us，如果该时间内未收到数据，将现有数据组包上传
    input   wire [7:0]  timer_trig          ,
    
    input   wire        rxfifo_rdreq        ,
    output  wire        rxfifo_data_ready   ,
    output  wire [7:0]  rxfifo_usedw        ,
    output  wire [7:0]  rxfifo_q             
    );
    
  
    wire        rxfifo_full;
    wire        rxfifo_empty;
    wire        rxfifo_wrreq; 
    reg  [7:0]  rxfifo_timer;
    fifo256X8 fifo256X8_01inst(
    	.aclr   (~rst_n             ),
    	.clock  (clk                ),
    	.data   (  uart_rx_data     ),
    	.rdreq  (rxfifo_rdreq       ),
    	.wrreq  (rxfifo_wrreq       ), 
    	.empty  (rxfifo_empty       ),
    	.full   (rxfifo_full        ),
    	.q      (rxfifo_q           ),
    	.usedw  (rxfifo_usedw       )
    	);
    assign rxfifo_wrreq       = ~rxfifo_full & uart_rx_data_ready;
    assign rxfifo_data_ready  = (rxfifo_timer > timer_trig)&& ~rxfifo_empty;
    
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)begin
            rxfifo_timer    <= 8'h0;   
        end
        else if(rxfifo_wrreq) begin
            rxfifo_timer    <= 8'h0;      
        end 
        else if(rxfifo_timer == 8'hFF)begin
            rxfifo_timer    <= rxfifo_timer;     
        end
        else if(clk_100k)begin
            rxfifo_timer    <= rxfifo_timer + 1'b1;        
        end
    end
    
endmodule     