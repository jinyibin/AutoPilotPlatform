`timescale 1 ns/10 ps

module MainRxctrl(
    input   wire        clk                   ,        
    input   wire        rst_n                 , 
    
    input   wire [7:0]  timer_trig01          ,
    input   wire [7:0]  timer_trig02          ,
    input   wire [7:0]  timer_trig03          ,
    input   wire [7:0]  timer_trig04          ,
    input   wire [7:0]  timer_trig05          ,
    input   wire [7:0]  timer_trig06          ,
    input   wire [7:0]  timer_trig07          ,
    input   wire [7:0]  timer_trig08          ,
    input   wire [7:0]  timer_trig09          ,
    input   wire [7:0]  timer_trig10          ,
    input   wire [7:0]  timer_trig11          ,
    input   wire [7:0]  timer_trig12          ,
    input   wire [7:0]  timer_trig13          ,
    input   wire [7:0]  timer_trig14          ,
    input   wire [7:0]  timer_trig15          ,
    input   wire [7:0]  timer_trig16          ,
    input   wire [7:0]  timer_trig17          ,
    input   wire [7:0]  timer_trig18          ,
    input   wire [7:0]  timer_trig19          ,
    input   wire [7:0]  timer_trig20          ,
      
    input   wire [7:0]  uart01_rx_data        ,       
    input   wire        uart01_rx_data_ready  ,
    input   wire        uart01_rx_err         ,
    
    input   wire [7:0]  uart02_rx_data        ,       
    input   wire        uart02_rx_data_ready  ,
    input   wire        uart02_rx_err         ,
    
    input   wire [7:0]  uart03_rx_data        ,       
    input   wire        uart03_rx_data_ready  ,
    input   wire        uart03_rx_err         ,
    
    input   wire [7:0]  uart04_rx_data        ,       
    input   wire        uart04_rx_data_ready  ,
    input   wire        uart04_rx_err         ,
    
    input   wire [7:0]  uart05_rx_data        ,       
    input   wire        uart05_rx_data_ready  ,
    input   wire        uart05_rx_err         ,
    
    input   wire [7:0]  uart06_rx_data        ,       
    input   wire        uart06_rx_data_ready  ,
    input   wire        uart06_rx_err         ,
    
    input   wire [7:0]  uart07_rx_data        ,       
    input   wire        uart07_rx_data_ready  ,
    input   wire        uart07_rx_err         ,
    
    input   wire [7:0]  uart08_rx_data        ,       
    input   wire        uart08_rx_data_ready  ,
    input   wire        uart08_rx_err         ,
    
    input   wire [7:0]  uart09_rx_data        ,       
    input   wire        uart09_rx_data_ready  ,
    input   wire        uart09_rx_err         ,
    
    input   wire [7:0]  uart10_rx_data        ,       
    input   wire        uart10_rx_data_ready  ,
    input   wire        uart10_rx_err         ,
    
    input   wire [7:0]  uart11_rx_data        ,       
    input   wire        uart11_rx_data_ready  ,
    input   wire        uart11_rx_err         ,
    
    input   wire [7:0]  uart12_rx_data        ,       
    input   wire        uart12_rx_data_ready  ,
    input   wire        uart12_rx_err         ,
    
    input   wire [7:0]  uart13_rx_data        ,       
    input   wire        uart13_rx_data_ready  ,
    input   wire        uart13_rx_err         ,
    
    input   wire [7:0]  uart14_rx_data        ,       
    input   wire        uart14_rx_data_ready  ,
    input   wire        uart14_rx_err         ,
    
    input   wire [7:0]  uart15_rx_data        ,       
    input   wire        uart15_rx_data_ready  ,
    input   wire        uart15_rx_err         ,
    
    input   wire [7:0]  uart16_rx_data        ,       
    input   wire        uart16_rx_data_ready  ,
    input   wire        uart16_rx_err         ,
    
    input   wire [7:0]  uart17_rx_data        ,       
    input   wire        uart17_rx_data_ready  ,
    input   wire        uart17_rx_err         ,
    
    input   wire [7:0]  uart18_rx_data        ,       
    input   wire        uart18_rx_data_ready  ,
    input   wire        uart18_rx_err         ,
    
    input   wire [7:0]  uart19_rx_data        ,       
    input   wire        uart19_rx_data_ready  ,
    input   wire        uart19_rx_err         ,
    
    input   wire [7:0]  uart20_rx_data        ,       
    input   wire        uart20_rx_data_ready  ,
    input   wire        uart20_rx_err         ,
    
    input   wire        uartM_tx_status       ,      
    input   wire        uartM_tx_over         ,
    output  reg  [7:0]  uartM_tx_data         ,
    output  reg         uartM_tx_data_ready                   
);                    
    reg         clk_100k;
    reg [9:0]   clk_cnt500;
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)begin
            clk_100k    <=  1'b0;
            clk_cnt500  <= 10'h0;   
        end 
        else begin
            if(clk_cnt500 == 10'd499) begin
                clk_100k    <=  1'b1;
                clk_cnt500  <= 10'h0;      
            end
            else begin
                clk_100k    <= 1'b0;
                clk_cnt500  <= clk_cnt500 + 1'b1;      
            end  
        end
    end
    
    wire        rxfifo01_rdreq     ;      
    wire        rxfifo01_data_ready;
    wire [7:0]  rxfifo01_usedw     ;
    wire [7:0]  rxfifo01_q         ;
    
    uart_rx_ctrl uart01_rx_ctrl_inst( 
            .clk                 (clk                   ),
            .rst_n               (rst_n                 ),
            .clk_100k            (clk_100k              ),
           
            .uart_rx_data        (uart01_rx_data        ),
            .uart_rx_data_ready  (uart01_rx_data_ready  ),
            //触发UART接受到的数据上传时间，单位10us，如果该时间内未收到数据，将现有数据组包上传
            .timer_trig          (timer_trig01          ),
            
            .rxfifo_rdreq        (rxfifo01_rdreq        ),
            .rxfifo_data_ready   (rxfifo01_data_ready   ),
            .rxfifo_usedw        (rxfifo01_usedw        ),
            .rxfifo_q            (rxfifo01_q            ) 
            );
    wire        rxfifo02_rdreq     ;      
    wire        rxfifo02_data_ready;
    wire [7:0]  rxfifo02_usedw     ;
    wire [7:0]  rxfifo02_q         ;
    
    uart_rx_ctrl uart02_rx_ctrl_inst( 
            .clk                 (clk                   ),
            .rst_n               (rst_n                 ),
            .clk_100k            (clk_100k              ),
           
            .uart_rx_data        (uart02_rx_data        ),
            .uart_rx_data_ready  (uart02_rx_data_ready  ),
            //触发UART接受到的数据上传时间，单位10us，如果该时间内未收到数据，将现有数据组包上传
            .timer_trig          (timer_trig02          ),
            
            .rxfifo_rdreq        (rxfifo02_rdreq        ),
            .rxfifo_data_ready   (rxfifo02_data_ready   ),
            .rxfifo_usedw        (rxfifo02_usedw        ),
            .rxfifo_q            (rxfifo02_q            ) 
            );
    
    wire        rxfifo03_rdreq     ;      
    wire        rxfifo03_data_ready;
    wire [7:0]  rxfifo03_usedw     ;
    wire [7:0]  rxfifo03_q         ;
    
    uart_rx_ctrl uart03_rx_ctrl_inst( 
            .clk                 (clk                   ),
            .rst_n               (rst_n                 ),
            .clk_100k            (clk_100k              ),
           
            .uart_rx_data        (uart03_rx_data        ),
            .uart_rx_data_ready  (uart03_rx_data_ready  ),
            //触发UART接受到的数据上传时间，单位10us，如果该时间内未收到数据，将现有数据组包上传
            .timer_trig          (timer_trig03          ),
            
            .rxfifo_rdreq        (rxfifo03_rdreq        ),
            .rxfifo_data_ready   (rxfifo03_data_ready   ),
            .rxfifo_usedw        (rxfifo03_usedw        ),
            .rxfifo_q            (rxfifo03_q            ) 
            );
    wire        rxfifo04_rdreq     ;      
    wire        rxfifo04_data_ready;
    wire [7:0]  rxfifo04_usedw     ;
    wire [7:0]  rxfifo04_q         ;
    
    uart_rx_ctrl uart04_rx_ctrl_inst( 
            .clk                 (clk                   ),
            .rst_n               (rst_n                 ),
            .clk_100k            (clk_100k              ),
           
            .uart_rx_data        (uart04_rx_data        ),
            .uart_rx_data_ready  (uart04_rx_data_ready  ),
            //触发UART接受到的数据上传时间，单位10us，如果该时间内未收到数据，将现有数据组包上传
            .timer_trig          (timer_trig04          ),
            
            .rxfifo_rdreq        (rxfifo04_rdreq        ),
            .rxfifo_data_ready   (rxfifo04_data_ready   ),
            .rxfifo_usedw        (rxfifo04_usedw        ),
            .rxfifo_q            (rxfifo04_q            ) 
            );
    wire        rxfifo05_rdreq     ;      
    wire        rxfifo05_data_ready;
    wire [7:0]  rxfifo05_usedw     ;
    wire [7:0]  rxfifo05_q         ;
    
    uart_rx_ctrl uart05_rx_ctrl_inst( 
            .clk                 (clk                   ),
            .rst_n               (rst_n                 ),
            .clk_100k            (clk_100k              ),
           
            .uart_rx_data        (uart05_rx_data        ),
            .uart_rx_data_ready  (uart05_rx_data_ready  ),
            //触发UART接受到的数据上传时间，单位10us，如果该时间内未收到数据，将现有数据组包上传
            .timer_trig          (timer_trig05          ),
            
            .rxfifo_rdreq        (rxfifo05_rdreq        ),
            .rxfifo_data_ready   (rxfifo05_data_ready   ),
            .rxfifo_usedw        (rxfifo05_usedw        ),
            .rxfifo_q            (rxfifo05_q            ) 
            );
    wire        rxfifo06_rdreq     ;      
    wire        rxfifo06_data_ready;
    wire [7:0]  rxfifo06_usedw     ;
    wire [7:0]  rxfifo06_q         ;
    
    uart_rx_ctrl uart06_rx_ctrl_inst( 
            .clk                 (clk                   ),
            .rst_n               (rst_n                 ),
            .clk_100k            (clk_100k              ),
           
            .uart_rx_data        (uart06_rx_data        ),
            .uart_rx_data_ready  (uart06_rx_data_ready  ),
            //触发UART接受到的数据上传时间，单位10us，如果该时间内未收到数据，将现有数据组包上传
            .timer_trig          (timer_trig06          ),
            
            .rxfifo_rdreq        (rxfifo06_rdreq        ),
            .rxfifo_data_ready   (rxfifo06_data_ready   ),
            .rxfifo_usedw        (rxfifo06_usedw        ),
            .rxfifo_q            (rxfifo06_q            ) 
            );
    
    wire        rxfifo07_rdreq     ;      
    wire        rxfifo07_data_ready;
    wire [7:0]  rxfifo07_usedw     ;
    wire [7:0]  rxfifo07_q         ;
    
    uart_rx_ctrl uart07_rx_ctrl_inst( 
            .clk                 (clk                   ),
            .rst_n               (rst_n                 ),
            .clk_100k            (clk_100k              ),
           
            .uart_rx_data        (uart07_rx_data        ),
            .uart_rx_data_ready  (uart07_rx_data_ready  ),
            //触发UART接受到的数据上传时间，单位10us，如果该时间内未收到数据，将现有数据组包上传
            .timer_trig          (timer_trig07          ),
            
            .rxfifo_rdreq        (rxfifo07_rdreq        ),
            .rxfifo_data_ready   (rxfifo07_data_ready   ),
            .rxfifo_usedw        (rxfifo07_usedw        ),
            .rxfifo_q            (rxfifo07_q            ) 
            );
    wire        rxfifo08_rdreq     ;      
    wire        rxfifo08_data_ready;
    wire [7:0]  rxfifo08_usedw     ;
    wire [7:0]  rxfifo08_q         ;
    
    uart_rx_ctrl uart08_rx_ctrl_inst( 
            .clk                 (clk                   ),
            .rst_n               (rst_n                 ),
            .clk_100k            (clk_100k              ),
           
            .uart_rx_data        (uart08_rx_data        ),
            .uart_rx_data_ready  (uart08_rx_data_ready  ),
            //触发UART接受到的数据上传时间，单位10us，如果该时间内未收到数据，将现有数据组包上传
            .timer_trig          (timer_trig08          ),
            
            .rxfifo_rdreq        (rxfifo08_rdreq        ),
            .rxfifo_data_ready   (rxfifo08_data_ready   ),
            .rxfifo_usedw        (rxfifo08_usedw        ),
            .rxfifo_q            (rxfifo08_q            ) 
            );
    
    
    wire        rxfifo09_rdreq     ;      
    wire        rxfifo09_data_ready;
    wire [7:0]  rxfifo09_usedw     ;
    wire [7:0]  rxfifo09_q         ;
    
    uart_rx_ctrl uart09_rx_ctrl_inst( 
            .clk                 (clk                   ),
            .rst_n               (rst_n                 ),
            .clk_100k            (clk_100k              ),
           
            .uart_rx_data        (uart09_rx_data        ),
            .uart_rx_data_ready  (uart09_rx_data_ready  ),
            //触发UART接受到的数据上传时间，单位10us，如果该时间内未收到数据，将现有数据组包上传
            .timer_trig          (timer_trig09          ),
            
            .rxfifo_rdreq        (rxfifo09_rdreq        ),
            .rxfifo_data_ready   (rxfifo09_data_ready   ),
            .rxfifo_usedw        (rxfifo09_usedw        ),
            .rxfifo_q            (rxfifo09_q            ) 
            );
    wire        rxfifo10_rdreq     ;      
    wire        rxfifo10_data_ready;
    wire [7:0]  rxfifo10_usedw     ;
    wire [7:0]  rxfifo10_q         ;
    
    uart_rx_ctrl uart10_rx_ctrl_inst( 
            .clk                 (clk                   ),
            .rst_n               (rst_n                 ),
            .clk_100k            (clk_100k              ),
           
            .uart_rx_data        (uart10_rx_data        ),
            .uart_rx_data_ready  (uart10_rx_data_ready  ),
            //触发UART接受到的数据上传时间，单位10us，如果该时间内未收到数据，将现有数据组包上传
            .timer_trig          (timer_trig10          ),
            
            .rxfifo_rdreq        (rxfifo10_rdreq        ),
            .rxfifo_data_ready   (rxfifo10_data_ready   ),
            .rxfifo_usedw        (rxfifo10_usedw        ),
            .rxfifo_q            (rxfifo10_q            ) 
            );
    
    wire        rxfifo11_rdreq     ;      
    wire        rxfifo11_data_ready;
    wire [7:0]  rxfifo11_usedw     ;
    wire [7:0]  rxfifo11_q         ;
    
    uart_rx_ctrl uart11_rx_ctrl_inst( 
            .clk                 (clk                   ),
            .rst_n               (rst_n                 ),
            .clk_100k            (clk_100k              ),
           
            .uart_rx_data        (uart11_rx_data        ),
            .uart_rx_data_ready  (uart11_rx_data_ready  ),
            //触发UART接受到的数据上传时间，单位10us，如果该时间内未收到数据，将现有数据组包上传
            .timer_trig          (timer_trig11          ),
            
            .rxfifo_rdreq        (rxfifo11_rdreq        ),
            .rxfifo_data_ready   (rxfifo11_data_ready   ),
            .rxfifo_usedw        (rxfifo11_usedw        ),
            .rxfifo_q            (rxfifo11_q            ) 
            );
    wire        rxfifo12_rdreq     ;      
    wire        rxfifo12_data_ready;
    wire [7:0]  rxfifo12_usedw     ;
    wire [7:0]  rxfifo12_q         ;
    
    uart_rx_ctrl uart12_rx_ctrl_inst( 
            .clk                 (clk                   ),
            .rst_n               (rst_n                 ),
            .clk_100k            (clk_100k              ),
           
            .uart_rx_data        (uart12_rx_data        ),
            .uart_rx_data_ready  (uart12_rx_data_ready  ),
            //触发UART接受到的数据上传时间，单位10us，如果该时间内未收到数据，将现有数据组包上传
            .timer_trig          (timer_trig12          ),
            
            .rxfifo_rdreq        (rxfifo12_rdreq        ),
            .rxfifo_data_ready   (rxfifo12_data_ready   ),
            .rxfifo_usedw        (rxfifo12_usedw        ),
            .rxfifo_q            (rxfifo12_q            ) 
            );
    
    wire        rxfifo13_rdreq     ;      
    wire        rxfifo13_data_ready;
    wire [7:0]  rxfifo13_usedw     ;
    wire [7:0]  rxfifo13_q         ;
    
    uart_rx_ctrl uart13_rx_ctrl_inst( 
            .clk                 (clk                   ),
            .rst_n               (rst_n                 ),
            .clk_100k            (clk_100k              ),
           
            .uart_rx_data        (uart13_rx_data        ),
            .uart_rx_data_ready  (uart13_rx_data_ready  ),
            //触发UART接受到的数据上传时间，单位10us，如果该时间内未收到数据，将现有数据组包上传
            .timer_trig          (timer_trig13          ),
            
            .rxfifo_rdreq        (rxfifo13_rdreq        ),
            .rxfifo_data_ready   (rxfifo13_data_ready   ),
            .rxfifo_usedw        (rxfifo13_usedw        ),
            .rxfifo_q            (rxfifo13_q            ) 
            );
    wire        rxfifo14_rdreq     ;      
    wire        rxfifo14_data_ready;
    wire [7:0]  rxfifo14_usedw     ;
    wire [7:0]  rxfifo14_q         ;
    
    uart_rx_ctrl uart14_rx_ctrl_inst( 
            .clk                 (clk                   ),
            .rst_n               (rst_n                 ),
            .clk_100k            (clk_100k              ),
           
            .uart_rx_data        (uart14_rx_data        ),
            .uart_rx_data_ready  (uart14_rx_data_ready  ),
            //触发UART接受到的数据上传时间，单位10us，如果该时间内未收到数据，将现有数据组包上传
            .timer_trig          (timer_trig14          ),
            
            .rxfifo_rdreq        (rxfifo14_rdreq        ),
            .rxfifo_data_ready   (rxfifo14_data_ready   ),
            .rxfifo_usedw        (rxfifo14_usedw        ),
            .rxfifo_q            (rxfifo14_q            ) 
            );
    wire        rxfifo15_rdreq     ;      
    wire        rxfifo15_data_ready;
    wire [7:0]  rxfifo15_usedw     ;
    wire [7:0]  rxfifo15_q         ;
    
    uart_rx_ctrl uart15_rx_ctrl_inst( 
            .clk                 (clk                   ),
            .rst_n               (rst_n                 ),
            .clk_100k            (clk_100k              ),
           
            .uart_rx_data        (uart15_rx_data        ),
            .uart_rx_data_ready  (uart15_rx_data_ready  ),
            //触发UART接受到的数据上传时间，单位10us，如果该时间内未收到数据，将现有数据组包上传
            .timer_trig          (timer_trig15          ),
            
            .rxfifo_rdreq        (rxfifo15_rdreq        ),
            .rxfifo_data_ready   (rxfifo15_data_ready   ),
            .rxfifo_usedw        (rxfifo15_usedw        ),
            .rxfifo_q            (rxfifo15_q            ) 
            );
    wire        rxfifo16_rdreq     ;      
    wire        rxfifo16_data_ready;
    wire [7:0]  rxfifo16_usedw     ;
    wire [7:0]  rxfifo16_q         ;
    
    uart_rx_ctrl uart16_rx_ctrl_inst( 
            .clk                 (clk                   ),
            .rst_n               (rst_n                 ),
            .clk_100k            (clk_100k              ),
           
            .uart_rx_data        (uart16_rx_data        ),
            .uart_rx_data_ready  (uart16_rx_data_ready  ),
            //触发UART接受到的数据上传时间，单位10us，如果该时间内未收到数据，将现有数据组包上传
            .timer_trig          (timer_trig16          ),
            
            .rxfifo_rdreq        (rxfifo16_rdreq        ),
            .rxfifo_data_ready   (rxfifo16_data_ready   ),
            .rxfifo_usedw        (rxfifo16_usedw        ),
            .rxfifo_q            (rxfifo16_q            ) 
            );
    
    wire        rxfifo17_rdreq     ;      
    wire        rxfifo17_data_ready;
    wire [7:0]  rxfifo17_usedw     ;
    wire [7:0]  rxfifo17_q         ;
    
    uart_rx_ctrl uart17_rx_ctrl_inst( 
            .clk                 (clk                   ),
            .rst_n               (rst_n                 ),
            .clk_100k            (clk_100k              ),
           
            .uart_rx_data        (uart17_rx_data        ),
            .uart_rx_data_ready  (uart17_rx_data_ready  ),
            //触发UART接受到的数据上传时间，单位10us，如果该时间内未收到数据，将现有数据组包上传
            .timer_trig          (timer_trig17          ),
            
            .rxfifo_rdreq        (rxfifo17_rdreq        ),
            .rxfifo_data_ready   (rxfifo17_data_ready   ),
            .rxfifo_usedw        (rxfifo17_usedw        ),
            .rxfifo_q            (rxfifo17_q            ) 
            );
    wire        rxfifo18_rdreq     ;      
    wire        rxfifo18_data_ready;
    wire [7:0]  rxfifo18_usedw     ;
    wire [7:0]  rxfifo18_q         ;
    
    uart_rx_ctrl uart18_rx_ctrl_inst( 
            .clk                 (clk                   ),
            .rst_n               (rst_n                 ),
            .clk_100k            (clk_100k              ),
           
            .uart_rx_data        (uart18_rx_data        ),
            .uart_rx_data_ready  (uart18_rx_data_ready  ),
            //触发UART接受到的数据上传时间，单位10us，如果该时间内未收到数据，将现有数据组包上传
            .timer_trig          (timer_trig18          ),
            
            .rxfifo_rdreq        (rxfifo18_rdreq        ),
            .rxfifo_data_ready   (rxfifo18_data_ready   ),
            .rxfifo_usedw        (rxfifo18_usedw        ),
            .rxfifo_q            (rxfifo18_q            ) 
            );
    
    
    wire        rxfifo19_rdreq     ;      
    wire        rxfifo19_data_ready;
    wire [7:0]  rxfifo19_usedw     ;
    wire [7:0]  rxfifo19_q         ;
    
    uart_rx_ctrl uart19_rx_ctrl_inst( 
            .clk                 (clk                   ),
            .rst_n               (rst_n                 ),
            .clk_100k            (clk_100k              ),
           
            .uart_rx_data        (uart19_rx_data        ),
            .uart_rx_data_ready  (uart19_rx_data_ready  ),
            //触发UART接受到的数据上传时间，单位10us，如果该时间内未收到数据，将现有数据组包上传
            .timer_trig          (timer_trig19          ),
            
            .rxfifo_rdreq        (rxfifo19_rdreq        ),
            .rxfifo_data_ready   (rxfifo19_data_ready   ),
            .rxfifo_usedw        (rxfifo19_usedw        ),
            .rxfifo_q            (rxfifo19_q            ) 
            );
    wire        rxfifo20_rdreq     ;      
    wire        rxfifo20_data_ready;
    wire [7:0]  rxfifo20_usedw     ;
    wire [7:0]  rxfifo20_q         ;
    
    uart_rx_ctrl uart20_rx_ctrl_inst( 
            .clk                 (clk                   ),
            .rst_n               (rst_n                 ),
            .clk_100k            (clk_100k              ),
           
            .uart_rx_data        (uart20_rx_data        ),
            .uart_rx_data_ready  (uart20_rx_data_ready  ),
            //触发UART接受到的数据上传时间，单位10us，如果该时间内未收到数据，将现有数据组包上传
            .timer_trig          (timer_trig20          ),
            
            .rxfifo_rdreq        (rxfifo20_rdreq        ),
            .rxfifo_data_ready   (rxfifo20_data_ready   ),
            .rxfifo_usedw        (rxfifo20_usedw        ),
            .rxfifo_q            (rxfifo20_q            ) 
            );
    
    
    
    
    reg [3:0]   state;
    reg [7:0]   channal_no; 
    reg [7:0]   data_len  ;
    reg         fifo_rdreq;
    reg [2:0]   cnt;
    reg [7:0]   send_cnt;
    reg [7:0]   rxfifo_q;
    wire[15:0]  CRC; 
    reg         crc_en  ;
    reg [ 7:0]  data_crc;
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)begin
            state                       <= 4'h0; 
            channal_no                  <= 8'h0; 
            fifo_rdreq                  <= 1'b0; 
            uartM_tx_data               <= 8'h0;    
            uartM_tx_data_ready         <= 1'b0; 
            data_len                    <= 8'h0; 
            cnt                         <= 3'b000;
            send_cnt                    <= 8'h0; 
            crc_en                      <= 1'b0;  
            data_crc                    <= 8'h0;
        end
        else begin
            case (state)
            4'h0:begin
                if(rxfifo01_data_ready)begin
                    state               <= 4'h1;     
                    channal_no          <= 8'h1;
                    data_len            <= rxfifo01_usedw; 
                end
                else if(rxfifo02_data_ready)begin
                    state               <= 4'h1;    
                    channal_no          <= 8'h2;
                    data_len            <= rxfifo02_usedw;        
                end 
                else if(rxfifo03_data_ready)begin
                    state               <= 4'h1;    
                    channal_no          <= 8'h3;
                    data_len            <= rxfifo03_usedw;        
                end 
                else if(rxfifo04_data_ready)begin
                    state               <= 4'h1;    
                    channal_no          <= 8'h4;
                    data_len            <= rxfifo04_usedw;        
                end 
                else if(rxfifo05_data_ready)begin
                    state               <= 4'h1;    
                    channal_no          <= 8'h5;
                    data_len            <= rxfifo05_usedw;        
                end 
                else if(rxfifo06_data_ready)begin
                    state               <= 4'h1;    
                    channal_no          <= 8'h6;
                    data_len            <= rxfifo06_usedw;        
                end 
                else if(rxfifo07_data_ready)begin
                    state               <= 4'h1;    
                    channal_no          <= 8'h7;
                    data_len            <= rxfifo07_usedw;        
                end 
                else if(rxfifo08_data_ready)begin
                    state               <= 4'h1;    
                    channal_no          <= 8'h8;
                    data_len            <= rxfifo08_usedw;        
                end 
                else if(rxfifo09_data_ready)begin
                    state               <= 4'h1;    
                    channal_no          <= 8'h9;
                    data_len            <= rxfifo09_usedw;        
                end 
                else if(rxfifo10_data_ready)begin
                    state               <= 4'h1;    
                    channal_no          <= 8'd10;
                    data_len            <= rxfifo10_usedw;        
                end 
                else if(rxfifo11_data_ready)begin
                    state               <= 4'h1;     
                    channal_no          <= 8'd11;
                    data_len            <= rxfifo11_usedw; 
                end
                else if(rxfifo12_data_ready)begin
                    state               <= 4'h1;    
                    channal_no          <= 8'd12;
                    data_len            <= rxfifo12_usedw;        
                end 
                else if(rxfifo13_data_ready)begin
                    state               <= 4'h1;    
                    channal_no          <= 8'd13;
                    data_len            <= rxfifo13_usedw;        
                end 
                else if(rxfifo14_data_ready)begin
                    state               <= 4'h1;    
                    channal_no          <= 8'd14;
                    data_len            <= rxfifo14_usedw;        
                end 
                else if(rxfifo15_data_ready)begin
                    state               <= 4'h1;    
                    channal_no          <= 8'd15;
                    data_len            <= rxfifo15_usedw;        
                end 
                else if(rxfifo16_data_ready)begin
                    state               <= 4'h1;    
                    channal_no          <= 8'd16;
                    data_len            <= rxfifo16_usedw;        
                end 
                else if(rxfifo17_data_ready)begin
                    state               <= 4'h1;    
                    channal_no          <= 8'd17;
                    data_len            <= rxfifo17_usedw;        
                end 
                else if(rxfifo18_data_ready)begin
                    state               <= 4'h1;    
                    channal_no          <= 8'd18;
                    data_len            <= rxfifo18_usedw;        
                end 
                else if(rxfifo19_data_ready)begin
                    state               <= 4'h1;    
                    channal_no          <= 8'd19;
                    data_len            <= rxfifo19_usedw;        
                end 
                else if(rxfifo20_data_ready)begin
                    state               <= 4'h1;    
                    channal_no          <= 8'd20;
                    data_len            <= rxfifo20_usedw;        
                end               
                fifo_rdreq              <= 1'b0; 
                uartM_tx_data           <= 8'h0;    
                uartM_tx_data_ready     <= 1'b0; 
                cnt                     <= 3'b000; 
                send_cnt                <= 8'h0;
                crc_en                  <= 1'b0;   
                data_crc                <= 8'h0;             
            end
            4'h1:begin//send 0x24 
                if(cnt == 3'b101) begin
                    state               <= 4'h2;     
                end 
                else begin
                    state               <= state; 
                end 
                uartM_tx_data           <= 8'h24;    
                uartM_tx_data_ready     <= (cnt == 3'b100)? 1'b1:1'b0;
                
                if(uartM_tx_status)
                    cnt                 <= 3'b000;
                else 
                    cnt                 <= cnt + 1'b1;  
            end
            4'h2:begin//send 0x46  
                if(cnt == 3'b101) begin
                    state               <= 4'h3;     
                end 
                else begin
                    state               <= state; 
                end 
                uartM_tx_data           <= 8'h46;    
                uartM_tx_data_ready     <= (cnt == 3'b100)? 1'b1:1'b0;
                
                if(uartM_tx_status)
                    cnt                 <= 3'b000;
                else 
                    cnt                 <= cnt + 1'b1;   
            end
            4'h3:begin//send 0x54  
                if(cnt == 3'b101) begin
                    state               <= 4'h4;     
                end 
                else begin
                    state               <= state; 
                end 
                uartM_tx_data           <= 8'h54;    
                uartM_tx_data_ready     <= (cnt == 3'b100)? 1'b1:1'b0;
                
                if(uartM_tx_status)
                    cnt                 <= 3'b000;
                else 
                    cnt                 <= cnt + 1'b1;  
            end
            4'h4:begin//send 0x43  
                if(cnt == 3'b101) begin
                    state               <= 4'h5;     
                end 
                else begin
                    state               <= state; 
                end 
                uartM_tx_data           <= 8'h43;    
                uartM_tx_data_ready     <= (cnt == 3'b100)? 1'b1:1'b0;
                
                if(uartM_tx_status)
                    cnt                 <= 3'b000;
                else 
                    cnt                 <= cnt + 1'b1;  
            end
            4'h5:begin//send data length   
                if(cnt == 3'b101) begin
                    state               <= 4'h6;     
                end 
                else begin
                    state               <= state; 
                end 
                uartM_tx_data           <= data_len;    
                uartM_tx_data_ready     <= (cnt == 3'b100)? 1'b1:1'b0;
                
                if(uartM_tx_status)
                    cnt                 <= 3'b000;
                else 
                    cnt                 <= cnt + 1'b1;   
            end
            4'h6:begin//send 通道号   
                if(cnt == 3'b101) begin
                    state               <= 4'h7;     
                end 
                else begin
                    state               <= state; 
                end 
                uartM_tx_data           <= channal_no;    
                uartM_tx_data_ready     <= (cnt == 3'b100)? 1'b1:1'b0;
                
                if(uartM_tx_status)
                    cnt                 <= 3'b000;
                else 
                    cnt                 <= cnt + 1'b1;       
            end
            4'h7:begin//send data  
                if(send_cnt == data_len && cnt == 3'b101) begin        
                    state               <= 4'h8;      
                end 
                else begin
                    state               <= state; 
                end  
                
                fifo_rdreq              <= (cnt === 3'b001)? 1'b1:1'b0; 
                uartM_tx_data           <= rxfifo_q;    
                uartM_tx_data_ready     <= (cnt == 3'b100)? 1'b1:1'b0;
                crc_en                  <= (cnt == 3'b100)? 1'b1:1'b0;         
                data_crc                <= rxfifo_q; 
                if(fifo_rdreq)
                    send_cnt            <= send_cnt + 1'b1;
                
                
                if(uartM_tx_status)
                    cnt                 <= 3'b000;
                else 
                    cnt                 <= cnt + 1'b1;    
            end
            4'h8:begin//send CRC  
                if(cnt == 3'b101) begin
                    state               <= 4'h9;     
                end 
                else begin
                    state               <= state; 
                end 
                uartM_tx_data           <= CRC[7:0];    
                uartM_tx_data_ready     <= (cnt == 3'b100)? 1'b1:1'b0;
                
                if(uartM_tx_status)
                    cnt                 <= 3'b000;
                else 
                    cnt                 <= cnt + 1'b1;           
            end
            4'h9:begin//send CRC  
                if(cnt == 3'b101) begin
                    state               <= 4'hA;     
                end 
                else begin
                    state               <= state; 
                end 
                uartM_tx_data           <= CRC[15:8];    
                uartM_tx_data_ready     <= (cnt == 3'b100)? 1'b1:1'b0;
                
                if(uartM_tx_status)
                    cnt                 <= 3'b000;
                else 
                    cnt                 <= cnt + 1'b1;           
            end
            4'hA:begin//send END  
                if(cnt == 3'b101) begin
                    state               <= 4'h0;     
                end 
                else begin
                    state               <= state; 
                end 
                uartM_tx_data           <= 8'hFE;    
                uartM_tx_data_ready     <= (cnt == 3'b100)? 1'b1:1'b0;
                
                if(uartM_tx_status)
                    cnt                 <= 3'b000;
                else 
                    cnt                 <= cnt + 1'b1;             
            end
            default:begin
                state       <= 4'h0;     
            end
            endcase   
        end
    end	
	
    wire crc_rst_n;
    assign crc_rst_n = (state == 4'h2)?1'b0:1'b1;
    
    crc_16 crc_16(
	    .clk        (clk        ),    
	    .rst_n      (rst_n & crc_rst_n     ),
	    .crc_en     (crc_en     ),
	    .data_in    (data_crc  ),
	    .crc_reg    (CRC        ),
	    .crc_ready  ()
        );
    
    
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)begin
            rxfifo_q            <= 8'h0;   
        end
        else begin
            case(channal_no)
            8'd1 :   rxfifo_q   <= rxfifo01_q;  
            8'd2 :   rxfifo_q   <= rxfifo02_q; 
            8'd3 :   rxfifo_q   <= rxfifo03_q; 
            8'd4 :   rxfifo_q   <= rxfifo04_q;
            8'd5 :   rxfifo_q   <= rxfifo05_q; 
            8'd6 :   rxfifo_q   <= rxfifo06_q; 
            8'd7 :   rxfifo_q   <= rxfifo07_q; 
            8'd8 :   rxfifo_q   <= rxfifo08_q; 
            8'd9 :   rxfifo_q   <= rxfifo09_q; 
            8'd10:   rxfifo_q   <= rxfifo10_q;   
            8'd11:   rxfifo_q   <= rxfifo11_q;       
            8'd12:   rxfifo_q   <= rxfifo12_q;       
            8'd13:   rxfifo_q   <= rxfifo13_q;       
            8'd14:   rxfifo_q   <= rxfifo14_q;       
            8'd15:   rxfifo_q   <= rxfifo15_q;       
            8'd16:   rxfifo_q   <= rxfifo16_q;       
            8'd17:   rxfifo_q   <= rxfifo17_q;       
            8'd18:   rxfifo_q   <= rxfifo18_q;       
            8'd19:   rxfifo_q   <= rxfifo19_q;       
            8'd20:   rxfifo_q   <= rxfifo20_q;       
            default: rxfifo_q   <= rxfifo01_q;  
            endcase  
        end
    end
    
    
    assign rxfifo01_rdreq = (channal_no == 8'd1 ) ?	fifo_rdreq : 1'b0;   
    assign rxfifo02_rdreq = (channal_no == 8'd2 ) ?	fifo_rdreq : 1'b0;   
    assign rxfifo03_rdreq = (channal_no == 8'd3 ) ?	fifo_rdreq : 1'b0;   
    assign rxfifo04_rdreq = (channal_no == 8'd4 ) ?	fifo_rdreq : 1'b0;   
    assign rxfifo05_rdreq = (channal_no == 8'd5 ) ?	fifo_rdreq : 1'b0;   
    assign rxfifo06_rdreq = (channal_no == 8'd6 ) ?	fifo_rdreq : 1'b0;   
    assign rxfifo07_rdreq = (channal_no == 8'd7 ) ?	fifo_rdreq : 1'b0; 
    assign rxfifo08_rdreq = (channal_no == 8'd8 ) ?	fifo_rdreq : 1'b0;   
    assign rxfifo09_rdreq = (channal_no == 8'd9 ) ?	fifo_rdreq : 1'b0;   
    assign rxfifo10_rdreq = (channal_no == 8'd10) ?	fifo_rdreq : 1'b0;   
    assign rxfifo11_rdreq = (channal_no == 8'd11) ?	fifo_rdreq : 1'b0; 
    assign rxfifo12_rdreq = (channal_no == 8'd12) ?	fifo_rdreq : 1'b0;   
    assign rxfifo13_rdreq = (channal_no == 8'd13) ?	fifo_rdreq : 1'b0;   
    assign rxfifo14_rdreq = (channal_no == 8'd14) ?	fifo_rdreq : 1'b0;   
    assign rxfifo15_rdreq = (channal_no == 8'd15) ?	fifo_rdreq : 1'b0; 
    assign rxfifo16_rdreq = (channal_no == 8'd16) ?	fifo_rdreq : 1'b0;   
    assign rxfifo17_rdreq = (channal_no == 8'd17) ?	fifo_rdreq : 1'b0;   
    assign rxfifo18_rdreq = (channal_no == 8'd18) ?	fifo_rdreq : 1'b0;   
    assign rxfifo19_rdreq = (channal_no == 8'd19) ?	fifo_rdreq : 1'b0; 
    assign rxfifo20_rdreq = (channal_no == 8'd20) ?	fifo_rdreq : 1'b0;  
    
endmodule
