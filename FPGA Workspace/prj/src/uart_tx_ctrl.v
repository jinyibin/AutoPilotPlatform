
`timescale 1 ns/10 ps

module uart_tx_ctrl( 
    input   wire        clk                 ,
    input   wire        rst_n               ,
    
    input   wire        channal_sel         ,
    input   wire [7:0]  tx_data             ,
    input   wire        tx_data_en          ,
   
    
    output  wire        uart_tx_status      ,
    output  wire        uart_tx_over        ,
    output  wire [7:0]  uart_tx_data        ,
    output  reg         uart_tx_data_ready 
    );

     
    reg     channal_rdreq;
    wire    channal_full;
    wire    channal_empty;
    fifo256X8 fifo256X8_inst(
    	.aclr   (~rst_n                                 ),
    	.clock  (clk                                    ),
    	.data   (tx_data                                ),
    	.rdreq  (channal_rdreq                          ),
    	.wrreq  (tx_data_en&channal_sel&~channal_full   ), 
    	.empty  (channal_empty                          ),
    	.full   (channal_full                           ),
    	.q      (uart_tx_data                           ),
    	.usedw  (                                       )
    	);
    
    
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)begin
            channal_rdreq   <= 1'b0;    
        end 
        else if(~uart_tx_status&~channal_empty) begin
            channal_rdreq   <= 1'b1;      
        end
        else begin
            channal_rdreq   <= 1'b0;     
        end
    end
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)begin
            uart_tx_data_ready      <= 1'b0;    
        end  
        else begin
            uart_tx_data_ready      <= channal_rdreq;     
        end
    end
    //////*******END  
    
    
endmodule