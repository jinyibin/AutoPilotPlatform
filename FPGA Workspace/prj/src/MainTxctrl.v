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
 
    
    reg [3:0]   state; 
    reg [7:0]   data_len;
    reg [7:0]   channal_no;
    reg [7:0]   data_cnt;
    reg [7:0]   tx_data;
    reg         tx_data_en;
    reg [15:0]  crc_data;
    reg [7:0]   frame_end;
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)begin
            state               <=  4'h0; 
            data_len            <=  8'h0; 
            channal_no          <=  8'h0;
            data_cnt            <=  8'h0;
            tx_data             <=  8'h0;
            tx_data_en          <=  1'b0;
            crc_data            <= 16'h0;
            frame_end           <=  8'h0;
        end
        else begin
            case(state)
            4'h0:begin
                if(uartM_rx_data_ready&&uartM_rx_data===8'h24) begin//帧头0x24
                    state       <=  4'h1;              
                end 
                else begin
                    state       <=  4'h0; 
                end
                data_len        <=  8'h0; 
                data_cnt        <=  8'h0;
                tx_data         <=  8'h0;
                tx_data_en      <=  1'b0; 
                
            end
            4'h1:begin  
                if(uartM_rx_data_ready&&uartM_rx_data===8'h43)begin//帧头0x43
                    state       <=  4'h2;   
                end
                else begin
                    state       <=  state;     
                end 
                frame_end       <=  8'h0;        
            end
            4'h2:begin
                if(uartM_rx_data_ready&&uartM_rx_data===8'h54)begin//帧头0x54
                    state       <=  4'h3;   
                end
                else begin
                    state       <=  state;     
                end                 
            end
            4'h3:begin
                if(uartM_rx_data_ready&&uartM_rx_data===8'h46)begin//帧头0x46
                    state       <=  4'h4;   
                end
                else begin
                    state       <=  state;    
                end                 
            end
            4'h4:begin
                if(uartM_rx_data_ready)begin// 获取数据段长度    
                    state       <=  4'h5;
                    data_len    <=  uartM_rx_data - 1'b1;//提前减1   
                end
                else begin
                    state       <=  state;    
                end                     
            end  
            4'h5:begin //通道号
                if(uartM_rx_data_ready)begin// 获取数据段长度    
                    state       <=  4'h6;
                    channal_no  <=  uartM_rx_data;   
                end
                else begin
                    state       <=  state;    
                end                    
            end
            4'h6:begin //data 
                if(uartM_rx_data_ready)begin// 获取数据 
                    state       <=  4'h5;
                    data_cnt    <=  data_cnt + 1'b1; 
                    if(data_cnt == data_len)begin
                        state       <=  4'h7;   
                    end
                    else begin
                        state   <=  state;   
                    end
                    tx_data     <=  uartM_rx_data;
                    tx_data_en  <=  1'b1;    
                end
                else begin
                    state       <=  state;
                    tx_data_en  <=  1'b0;        
                end 
                                  
            end
            4'h7:begin //CRC 
                tx_data_en  <=  1'b0;   
                if(uartM_rx_data_ready )begin 
                    crc_data[7:0]   <=  uartM_rx_data;// 
                    state           <=  4'h8;       
                end 
                else begin
                    state       <=  state;     
                end                       
            end
            4'h8:begin //CRC
                if(uartM_rx_data_ready )begin 
                    crc_data[15:8]  <=  uartM_rx_data;// 
                    state           <=  4'h9;       
                end 
                else begin
                    state       <=  state;     
                end                  
            end
            4'h9:begin //Frame_end
                if(uartM_rx_data_ready )begin  
                    state       <=  4'h0;
                    frame_end   <= uartM_rx_data;       
                end 
                else begin
                    state       <=  state;     
                end                    
            end
            default:begin
                state           <=  4'h0;         
            end
            endcase   
        end   
    end
    wire    channal01_sel;
    assign  channal01_sel =  (channal_no == 8'h1)? 1'b1:1'b0; 
    uart_tx_ctrl uart01_tx_ctrl( 
        .clk                 (clk                   ),
        .rst_n               (rst_n                 ),
        
        .channal_sel         (channal01_sel         ),
        .tx_data             (tx_data               ),
        .tx_data_en          (tx_data_en            ),
       
        .uart_tx_status      (uart01_tx_status      ),
        .uart_tx_over        (uart01_tx_over        ),
        .uart_tx_data        (uart01_tx_data        ),
        .uart_tx_data_ready  (uart01_tx_data_ready  )
        );
    
    wire    channal02_sel;                                       
    assign  channal02_sel =  (channal_no == 8'h2)? 1'b1:1'b0;    
    uart_tx_ctrl uart02_tx_ctrl(                                 
        .clk                 (clk                   ),           
        .rst_n               (rst_n                 ),           
                                                                 
        .channal_sel         (channal02_sel         ),           
        .tx_data             (tx_data               ),           
        .tx_data_en          (tx_data_en            ),           
                                                                 
        .uart_tx_status      (uart02_tx_status      ),           
        .uart_tx_over        (uart02_tx_over        ),           
        .uart_tx_data        (uart02_tx_data        ),           
        .uart_tx_data_ready  (uart02_tx_data_ready  )            
        );                                                       

    wire    channal03_sel;                                       
    assign  channal03_sel =  (channal_no == 8'h3)? 1'b1:1'b0;    
    uart_tx_ctrl uart03_tx_ctrl(                                 
        .clk                 (clk                   ),           
        .rst_n               (rst_n                 ),           
                                                                 
        .channal_sel         (channal03_sel         ),           
        .tx_data             (tx_data               ),           
        .tx_data_en          (tx_data_en            ),           
                                                                 
        .uart_tx_status      (uart03_tx_status      ),           
        .uart_tx_over        (uart03_tx_over        ),           
        .uart_tx_data        (uart03_tx_data        ),           
        .uart_tx_data_ready  (uart03_tx_data_ready  )            
        );                                                     
    wire    channal04_sel;                                       
    assign  channal04_sel =  (channal_no == 8'h4)? 1'b1:1'b0;    
    uart_tx_ctrl uart04_tx_ctrl(                                 
        .clk                 (clk                   ),           
        .rst_n               (rst_n                 ),           
                                                                 
        .channal_sel         (channal04_sel         ),           
        .tx_data             (tx_data               ),           
        .tx_data_en          (tx_data_en            ),           
                                                                 
        .uart_tx_status      (uart04_tx_status      ),           
        .uart_tx_over        (uart04_tx_over        ),           
        .uart_tx_data        (uart04_tx_data        ),           
        .uart_tx_data_ready  (uart04_tx_data_ready  )            
        );                                                  
    
    wire    channal05_sel;
    assign  channal05_sel =  (channal_no == 8'h5)? 1'b1:1'b0; 
    uart_tx_ctrl uart05_tx_ctrl( 
        .clk                 (clk                   ),
        .rst_n               (rst_n                 ),
        
        .channal_sel         (channal05_sel         ),
        .tx_data             (tx_data               ),
        .tx_data_en          (tx_data_en            ),
       
        .uart_tx_status      (uart05_tx_status      ),
        .uart_tx_over        (uart05_tx_over        ),
        .uart_tx_data        (uart05_tx_data        ),
        .uart_tx_data_ready  (uart05_tx_data_ready  )
        );
    
    wire    channal06_sel;                                       
    assign  channal06_sel =  (channal_no == 8'h6)? 1'b1:1'b0;    
    uart_tx_ctrl uart06_tx_ctrl(                                 
        .clk                 (clk                   ),           
        .rst_n               (rst_n                 ),           
                                                                 
        .channal_sel         (channal06_sel         ),           
        .tx_data             (tx_data               ),           
        .tx_data_en          (tx_data_en            ),           
                                                                 
        .uart_tx_status      (uart06_tx_status      ),           
        .uart_tx_over        (uart06_tx_over        ),           
        .uart_tx_data        (uart06_tx_data        ),           
        .uart_tx_data_ready  (uart06_tx_data_ready  )            
        );                                                       

    wire    channal07_sel;                                       
    assign  channal07_sel =  (channal_no == 8'h7)? 1'b1:1'b0;    
    uart_tx_ctrl uart07_tx_ctrl(                                 
        .clk                 (clk                   ),           
        .rst_n               (rst_n                 ),           
                                                                 
        .channal_sel         (channal07_sel         ),           
        .tx_data             (tx_data               ),           
        .tx_data_en          (tx_data_en            ),           
                                                                 
        .uart_tx_status      (uart07_tx_status      ),           
        .uart_tx_over        (uart07_tx_over        ),           
        .uart_tx_data        (uart07_tx_data        ),           
        .uart_tx_data_ready  (uart07_tx_data_ready  )            
        );                                                     
    wire    channal08_sel;                                       
    assign  channal08_sel =  (channal_no == 8'h8)? 1'b1:1'b0;    
    uart_tx_ctrl uart08_tx_ctrl(                                 
        .clk                 (clk                   ),           
        .rst_n               (rst_n                 ),           
                                                                 
        .channal_sel         (channal08_sel         ),           
        .tx_data             (tx_data               ),           
        .tx_data_en          (tx_data_en            ),           
                                                                 
        .uart_tx_status      (uart08_tx_status      ),           
        .uart_tx_over        (uart08_tx_over        ),           
        .uart_tx_data        (uart08_tx_data        ),           
        .uart_tx_data_ready  (uart08_tx_data_ready  )            
        );                                                  
    wire    channal09_sel;                                       
    assign  channal09_sel =  (channal_no == 8'h9)? 1'b1:1'b0;    
    uart_tx_ctrl uart09_tx_ctrl(                                 
        .clk                 (clk                   ),           
        .rst_n               (rst_n                 ),           
                                                                 
        .channal_sel         (channal09_sel         ),           
        .tx_data             (tx_data               ),           
        .tx_data_en          (tx_data_en            ),           
                                                                 
        .uart_tx_status      (uart09_tx_status      ),           
        .uart_tx_over        (uart09_tx_over        ),           
        .uart_tx_data        (uart09_tx_data        ),           
        .uart_tx_data_ready  (uart09_tx_data_ready  )            
        );                                                     
    wire    channal10_sel;                                       
    assign  channal10_sel =  (channal_no == 8'hA)? 1'b1:1'b0;    
    uart_tx_ctrl uart10_tx_ctrl(                                 
        .clk                 (clk                   ),           
        .rst_n               (rst_n                 ),           
                                                                 
        .channal_sel         (channal10_sel         ),           
        .tx_data             (tx_data               ),           
        .tx_data_en          (tx_data_en            ),           
                                                                 
        .uart_tx_status      (uart10_tx_status      ),           
        .uart_tx_over        (uart10_tx_over        ),           
        .uart_tx_data        (uart10_tx_data        ),           
        .uart_tx_data_ready  (uart10_tx_data_ready  )            
        );                                                  
    
    wire    channal11_sel;
    assign  channal11_sel =  (channal_no == 8'hB)? 1'b1:1'b0; 
    uart_tx_ctrl uart11_tx_ctrl( 
        .clk                 (clk                   ),
        .rst_n               (rst_n                 ),
        
        .channal_sel         (channal11_sel         ),
        .tx_data             (tx_data               ),
        .tx_data_en          (tx_data_en            ),
       
        .uart_tx_status      (uart11_tx_status      ),
        .uart_tx_over        (uart11_tx_over        ),
        .uart_tx_data        (uart11_tx_data        ),
        .uart_tx_data_ready  (uart11_tx_data_ready  )
        );
    
    wire    channal12_sel;                                       
    assign  channal12_sel =  (channal_no == 8'hC)? 1'b1:1'b0;    
    uart_tx_ctrl uart12_tx_ctrl(                                 
        .clk                 (clk                   ),           
        .rst_n               (rst_n                 ),           
                                                                 
        .channal_sel         (channal12_sel         ),           
        .tx_data             (tx_data               ),           
        .tx_data_en          (tx_data_en            ),           
                                                                 
        .uart_tx_status      (uart12_tx_status      ),           
        .uart_tx_over        (uart12_tx_over        ),           
        .uart_tx_data        (uart12_tx_data        ),           
        .uart_tx_data_ready  (uart12_tx_data_ready  )            
        );                                                       

    wire    channal13_sel;                                       
    assign  channal13_sel =  (channal_no == 8'hD)? 1'b1:1'b0;    
    uart_tx_ctrl uart13_tx_ctrl(                                 
        .clk                 (clk                   ),           
        .rst_n               (rst_n                 ),           
                                                                 
        .channal_sel         (channal13_sel         ),           
        .tx_data             (tx_data               ),           
        .tx_data_en          (tx_data_en            ),           
                                                                 
        .uart_tx_status      (uart13_tx_status      ),           
        .uart_tx_over        (uart13_tx_over        ),           
        .uart_tx_data        (uart13_tx_data        ),           
        .uart_tx_data_ready  (uart13_tx_data_ready  )            
        );                                                     
    wire    channal14_sel;                                       
    assign  channal14_sel =  (channal_no == 8'hE)? 1'b1:1'b0;    
    uart_tx_ctrl uart14_tx_ctrl(                                 
        .clk                 (clk                   ),           
        .rst_n               (rst_n                 ),           
                                                                 
        .channal_sel         (channal14_sel         ),           
        .tx_data             (tx_data               ),           
        .tx_data_en          (tx_data_en            ),           
                                                                 
        .uart_tx_status      (uart14_tx_status      ),           
        .uart_tx_over        (uart14_tx_over        ),           
        .uart_tx_data        (uart14_tx_data        ),           
        .uart_tx_data_ready  (uart14_tx_data_ready  )            
        );                                                  
    
    wire    channal15_sel;
    assign  channal15_sel =  (channal_no == 8'hF)? 1'b1:1'b0; 
    uart_tx_ctrl uart15_tx_ctrl( 
        .clk                 (clk                   ),
        .rst_n               (rst_n                 ),
        
        .channal_sel         (channal15_sel         ),
        .tx_data             (tx_data               ),
        .tx_data_en          (tx_data_en            ),
       
        .uart_tx_status      (uart15_tx_status      ),
        .uart_tx_over        (uart15_tx_over        ),
        .uart_tx_data        (uart15_tx_data        ),
        .uart_tx_data_ready  (uart15_tx_data_ready  )
        );
    
    wire    channal16_sel;                                       
    assign  channal16_sel =  (channal_no == 8'h10)? 1'b1:1'b0;    
    uart_tx_ctrl uart16_tx_ctrl(                                 
        .clk                 (clk                   ),           
        .rst_n               (rst_n                 ),           
                                                                 
        .channal_sel         (channal16_sel         ),           
        .tx_data             (tx_data               ),           
        .tx_data_en          (tx_data_en            ),           
                                                                 
        .uart_tx_status      (uart16_tx_status      ),           
        .uart_tx_over        (uart16_tx_over        ),           
        .uart_tx_data        (uart16_tx_data        ),           
        .uart_tx_data_ready  (uart16_tx_data_ready  )            
        );                                                       

    wire    channal17_sel;                                       
    assign  channal17_sel =  (channal_no == 8'h11)? 1'b1:1'b0;    
    uart_tx_ctrl uart17_tx_ctrl(                                 
        .clk                 (clk                   ),           
        .rst_n               (rst_n                 ),           
                                                                 
        .channal_sel         (channal17_sel         ),           
        .tx_data             (tx_data               ),           
        .tx_data_en          (tx_data_en            ),           
                                                                 
        .uart_tx_status      (uart17_tx_status      ),           
        .uart_tx_over        (uart17_tx_over        ),           
        .uart_tx_data        (uart17_tx_data        ),           
        .uart_tx_data_ready  (uart17_tx_data_ready  )            
        );                                                     
    wire    channal18_sel;                                       
    assign  channal18_sel =  (channal_no == 8'h12)? 1'b1:1'b0;    
    uart_tx_ctrl uart18_tx_ctrl(                                 
        .clk                 (clk                   ),           
        .rst_n               (rst_n                 ),           
                                                                 
        .channal_sel         (channal18_sel         ),           
        .tx_data             (tx_data               ),           
        .tx_data_en          (tx_data_en            ),           
                                                                 
        .uart_tx_status      (uart18_tx_status      ),           
        .uart_tx_over        (uart18_tx_over        ),           
        .uart_tx_data        (uart18_tx_data        ),           
        .uart_tx_data_ready  (uart18_tx_data_ready  )            
        );                                                  
    wire    channal19_sel;                                       
    assign  channal19_sel =  (channal_no == 8'h13)? 1'b1:1'b0;    
    uart_tx_ctrl uart19_tx_ctrl(                                 
        .clk                 (clk                   ),           
        .rst_n               (rst_n                 ),           
                                                                 
        .channal_sel         (channal19_sel         ),           
        .tx_data             (tx_data               ),           
        .tx_data_en          (tx_data_en            ),           
                                                                 
        .uart_tx_status      (uart19_tx_status      ),           
        .uart_tx_over        (uart19_tx_over        ),           
        .uart_tx_data        (uart19_tx_data        ),           
        .uart_tx_data_ready  (uart19_tx_data_ready  )            
        );                                                     
    wire    channal20_sel;                                       
    assign  channal20_sel =  (channal_no == 8'h14)? 1'b1:1'b0;    
    uart_tx_ctrl uart20_tx_ctrl(                                 
        .clk                 (clk                   ),           
        .rst_n               (rst_n                 ),           
                                                                 
        .channal_sel         (channal20_sel         ),           
        .tx_data             (tx_data               ),           
        .tx_data_en          (tx_data_en            ),           
                                                                 
        .uart_tx_status      (uart20_tx_status      ),           
        .uart_tx_over        (uart20_tx_over        ),           
        .uart_tx_data        (uart20_tx_data        ),           
        .uart_tx_data_ready  (uart20_tx_data_ready  )            
        );                                                  

endmodule
