`timescale 1 ns/10 ps

module MainTxctrl( 
    input   wire        clk  ,
    input   wire        rst_n,
    
    input   wire [7:0]  uartM_rx_data       ,        
    input   wire        uartM_rx_data_ready , 
    
    output  wire        uart01_tx_status     ,
    output  wire        uart01_tx_over       ,
    output  wire [7:0]  uart01_tx_data       ,
    output  wire        uart01_tx_data_ready ,
    
    output  wire        uart02_tx_status     ,
    output  wire        uart02_tx_over       ,
    output  wire [7:0]  uart02_tx_data       ,
    output  wire        uart02_tx_data_ready ,
    
    output  wire        uart03_tx_status     ,
    output  wire        uart03_tx_over       ,
    output  wire [7:0]  uart03_tx_data       ,
    output  wire        uart03_tx_data_ready ,
    
    output  wire        uart04_tx_status     ,
    output  wire        uart04_tx_over       ,
    output  wire [7:0]  uart04_tx_data       ,
    output  wire        uart04_tx_data_ready ,
    
    output  wire        uart05_tx_status     ,
    output  wire        uart05_tx_over       ,
    output  wire [7:0]  uart05_tx_data       ,
    output  wire        uart05_tx_data_ready ,
    
    output  wire        uart06_tx_status     ,
    output  wire        uart06_tx_over       ,
    output  wire [7:0]  uart06_tx_data       ,
    output  wire        uart06_tx_data_ready ,
    
    output  wire        uart07_tx_status     ,
    output  wire        uart07_tx_over       ,
    output  wire [7:0]  uart07_tx_data       ,
    output  wire        uart07_tx_data_ready ,
    
    output  wire        uart08_tx_status     ,
    output  wire        uart08_tx_over       ,
    output  wire [7:0]  uart08_tx_data       ,
    output  wire        uart08_tx_data_ready ,
    
    output  wire        uart09_tx_status     ,
    output  wire        uart09_tx_over       ,
    output  wire [7:0]  uart09_tx_data       ,
    output  wire        uart09_tx_data_ready ,
    
    output  wire        uart10_tx_status     ,
    output  wire        uart10_tx_over       ,
    output  wire [7:0]  uart10_tx_data       ,
    output  wire        uart10_tx_data_ready ,
    
    output  wire        uart11_tx_status     ,
    output  wire        uart11_tx_over       ,
    output  wire [7:0]  uart11_tx_data       ,
    output  wire        uart11_tx_data_ready ,
    
    output  wire        uart12_tx_status     ,
    output  wire        uart12_tx_over       ,
    output  wire [7:0]  uart12_tx_data       ,
    output  wire        uart12_tx_data_ready ,
    
    output  wire        uart13_tx_status     ,
    output  wire        uart13_tx_over       ,
    output  wire [7:0]  uart13_tx_data       ,
    output  wire        uart13_tx_data_ready ,
    
    output  wire        uart14_tx_status     ,
    output  wire        uart14_tx_over       ,
    output  wire [7:0]  uart14_tx_data       ,
    output  wire        uart14_tx_data_ready ,
                            
    output  wire        uart15_tx_status     ,
    output  wire        uart15_tx_over       ,
    output  wire [7:0]  uart15_tx_data       ,
    output  wire        uart15_tx_data_ready ,
                             
    output  wire        uart16_tx_status     ,
    output  wire        uart16_tx_over       ,
    output  wire [7:0]  uart16_tx_data       ,
    output  wire        uart16_tx_data_ready ,
                            
    output  wire        uart17_tx_status     ,
    output  wire        uart17_tx_over       ,
    output  wire [7:0]  uart17_tx_data       ,
    output  wire        uart17_tx_data_ready ,
                            
    output  wire        uart18_tx_status     ,
    output  wire        uart18_tx_over       ,
    output  wire [7:0]  uart18_tx_data       ,
    output  wire        uart18_tx_data_ready ,
                            
    output  wire        uart19_tx_status     ,
    output  wire        uart19_tx_over       ,
    output  wire [7:0]  uart19_tx_data       ,
    output  wire        uart19_tx_data_ready ,
    
    output  wire        uart20_tx_status     ,
    output  wire        uart20_tx_over       ,
    output  wire [7:0]  uart20_tx_data       ,
    output  wire        uart20_tx_data_ready    

);



    wire [7:0]  maintxdata;
    wire        mainfifoempty; 
    reg         fifo_rdreq;
    fifo256X8 fifo256X8_main(
	        .aclr   (~rst_n             ),
	        .clock  (clk                ),
	        .data   (uartM_rx_data      ),
	        .rdreq  (fifo_rdreq         ),
	        .wrreq  (uartM_rx_data_ready),
	        .empty  (mainfifoempty      ),
	        .full   (),
	        .q      (maintxdata         ),
	        .usedw  ()
	        );
    
    reg [3:0]   state;
    reg [1:0]   cnt;
    reg         fifo_rdreq_d1;
    reg [7:0]   data_len;
    reg [7:0]   channal_no;
    reg [7:0]   data_cnt;
    reg [7:0]   tx_data;
    reg         tx_data_en;
    reg [15:0]  crc_data;
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)begin
            state               <=  4'h0; 
            fifo_rdreq          <=  1'b0;
            cnt                 <=  2'b0; 
            fifo_rdreq_d1       <=  1'b0;
            data_len            <=  8'h0; 
            channal_no          <=  8'h0;
            data_cnt            <=  8'h0;
            tx_data             <=  8'h0;
            tx_data_en          <=  1'b0;
            crc_data            <= 16'h0;
        end
        else begin
            fifo_rdreq_d1       <=  fifo_rdreq; 
            case(state)
            4'h0:begin
                if(~mainfifoempty) begin
                    fifo_rdreq  <=  1'b1; 
                    state       <=  4'h1;              
                end 
                else begin
                    state       <=  4'h0;
                    fifo_rdreq  <=  1'b0;      
                end
                cnt             <=  2'b0;
                data_len        <=  8'h0; 
                data_cnt        <=  8'h0;
                tx_data         <=  8'h0;
                tx_data_en      <=  1'b0;   
            end
            4'h1:begin  
                if(~mainfifoempty && cnt == 2'b11) begin
                    fifo_rdreq  <=  1'b1; 
                    state       <=  4'h2;         
                end 
                else if(fifo_rdreq_d1 && maintxdata!=8'h24)begin//帧头0x24
                    state       <=  4'h0;   
                end
                else begin
                    state       <=  state;
                    fifo_rdreq  <=  1'b0;      
                end
                cnt             <= cnt + 1'b1;               
            end
            4'h2:begin
                if(~mainfifoempty && cnt == 2'b11) begin
                    fifo_rdreq  <=  1'b1; 
                    state       <=  4'h3;         
                end 
                else if(fifo_rdreq_d1 && maintxdata!=8'h43)begin//帧头0x43
                    state       <=  4'h0;   
                end
                else begin
                    state       <=  state;
                    fifo_rdreq  <=  1'b0;      
                end 
                cnt             <= cnt + 1'b1;                          
            end
            4'h3:begin
                if(~mainfifoempty && cnt == 2'b11) begin
                    fifo_rdreq  <=  1'b1; 
                    state       <=  4'h4;         
                end 
                else if(fifo_rdreq_d1 && maintxdata!=8'h54)begin//帧头0x54
                    state       <=  4'h0;   
                end
                else begin
                    state       <=  state;
                    fifo_rdreq  <=  1'b0;      
                end
                cnt             <= cnt + 1'b1;                           
            end
            4'h4:begin
                if(~mainfifoempty && cnt == 2'b11) begin
                    fifo_rdreq  <=  1'b1; 
                    state       <=  4'h5;         
                end 
                else if(fifo_rdreq_d1 && maintxdata!=8'h46)begin//帧头0x46
                    state       <=  4'h0;   
                end
                else begin
                    state       <=  state;
                    fifo_rdreq  <=  1'b0;      
                end
                cnt             <= cnt + 1'b1;                           
            end 
            4'h5:begin
                if(~mainfifoempty && cnt == 2'b11) begin
                    fifo_rdreq  <=  1'b1; 
                    state       <=  4'h6;         
                end 
                else begin
                    state       <=  state;
                    fifo_rdreq  <=  1'b0;      
                end
                cnt             <= cnt + 1'b1; 
                    
                if(fifo_rdreq_d1 )begin 
                    data_len    <=  maintxdata;//获取数据段长度    
                end                        
            end
            4'h6:begin //通道号
                if(~mainfifoempty && cnt == 2'b11) begin
                    fifo_rdreq  <=  1'b1; 
                    state       <=  4'h7;         
                end 
                else begin
                    state       <=  state;
                    fifo_rdreq  <=  1'b0;      
                end
                cnt             <= cnt + 1'b1; 
                    
                if(fifo_rdreq_d1 )begin 
                    channal_no  <=  maintxdata;// 
                end                        
            end
            4'h7:begin //data
                if(~mainfifoempty && cnt == 2'b11) begin
                    fifo_rdreq  <=  1'b1; 
                    cnt         <=  2'b00;  
                    if(data_cnt == data_len)begin
                        state       <=  4'h8;   
                    end
                    else begin
                        state       <=  state;   
                    end 
                end 
                else begin 
                    fifo_rdreq  <=  1'b0; 
                    cnt         <=  cnt + 1'b1;      
                end
                
               
                    
                if(fifo_rdreq_d1 )begin 
                    tx_data         <=  maintxdata;
                    tx_data_en      <=  1'b1;
                    data_cnt        <=  data_cnt + 1'b1;        
                end 
                else begin
                    tx_data         <=  maintxdata;
                    tx_data_en      <=  1'b0;
                end                       
            end
            4'h8:begin //CRC
                if(~mainfifoempty && cnt == 2'b11) begin
                    fifo_rdreq  <=  1'b1; 
                    state       <=  4'h9;         
                end 
                else begin
                    state       <=  state;
                    fifo_rdreq  <=  1'b0;      
                end
                cnt             <= cnt + 1'b1; 
                    
                if(fifo_rdreq_d1 )begin 
                    crc_data[7:0]<=  maintxdata;// 
                end                        
            end
            4'h9:begin //CRC
                if(~mainfifoempty && cnt == 2'b11) begin
                    fifo_rdreq  <=  1'b1; 
                    state       <=  4'hA; 
                    cnt         <=  2'b00;          
                end 
                else begin
                    state       <=  state;
                    fifo_rdreq  <=  1'b0;   
                    cnt         <= cnt + 1'b1;    
                end
                
                    
                if(fifo_rdreq_d1 )begin 
                    crc_data[15:8]  <=  maintxdata;// 
                end                        
            end
            4'hA:begin //Frame_end
                if(cnt == 2'b11) begin 
                    state       <=  4'h0;         
                end 
                else begin
                    state       <=  state;
                    fifo_rdreq  <=  1'b0;      
                end
                cnt             <= cnt + 1'b1; 
                    
                                      
            end
            default:begin
                state           <=  4'h0; 
                fifo_rdreq      <=  1'b0;         
            end
            endcase   
        end   
    end



endmodule
