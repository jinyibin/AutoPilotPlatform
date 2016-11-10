

`timescale 1 ns/10 ps

module Uart1To20Top(
    input   wire        clk             ,//8M
    input   wire        rst_n           ,  
    
    input   wire        spi_mosi        ,//spi data input from master
    input   wire        spi_cs_n        ,//spi selection ,active low
    input   wire        spi_clk         ,//spi clock
    output  wire        spi_miso        ,//spi data output to master 
    
    //上位机为源
    input   wire        uart_tx_to_fpga ,
    output  wire        uart_rx_from_fpga,
    //FPGA 为源
    input   wire [19:0] uart_rx ,
    output  wire [19:0] uart_tx        
);
    
    wire    clk_50M;
    wire    clk_25M;
    pll_8MIn pll_8MIn(
    	.areset     (1'b0   ),
    	.inclk0     (clk    ),
    	.c0         (clk_50M),
    	.c1         (clk_25M),
    	.locked     ());
    
    
    wire         spi_clk_error;
    wire         rx_data_ready;
    wire[15:0]   rx_data      ;
    wire         tx_data_ready;
    wire[15:0]   tx_data      ;
    
    
    spi_slave_transceiver spi_slave_inst(
            .clk            (clk_50M        ),
            .rst_n          (rst_n          ),
             
            .spi_mosi       (spi_mosi       ),     //spi data input from master
            .spi_cs_n       (spi_cs_n       ),     //spi selection ,active low
            .spi_clk        (spi_clk        ),     //spi clock
            .spi_miso       (spi_miso       ),     //spi data output to master 
            
            .spi_clk_error  (spi_clk_error  ),//spi clock error detection ,high level pulse active
            
            .rx_data_ready  (rx_data_ready  ),//high level pulse active
            .rx_data        (rx_data        ),
            .tx_data_ready  (tx_data_ready  ),//high level pulse active
            .tx_data        (tx_data        )
            );
    wire [31:0] version;  
    wire [15:0] reg_baudrate_main; 
    wire [15:0] reg_baudrate_01  ; 
    wire [15:0] reg_baudrate_02  ; 
    wire [15:0] reg_baudrate_03  ; 
    wire [15:0] reg_baudrate_04  ; 
    wire [15:0] reg_baudrate_05  ; 
    wire [15:0] reg_baudrate_06  ; 
    wire [15:0] reg_baudrate_07  ; 
    wire [15:0] reg_baudrate_08  ; 
    wire [15:0] reg_baudrate_09  ; 
    wire [15:0] reg_baudrate_10  ; 
    wire [15:0] reg_baudrate_11  ; 
    wire [15:0] reg_baudrate_12  ; 
    wire [15:0] reg_baudrate_13  ; 
    wire [15:0] reg_baudrate_14  ; 
    wire [15:0] reg_baudrate_15  ; 
    wire [15:0] reg_baudrate_16  ; 
    wire [15:0] reg_baudrate_17  ; 
    wire [15:0] reg_baudrate_18  ; 
    wire [15:0] reg_baudrate_19  ; 
    wire [15:0] reg_baudrate_20  ; 
    wire [ 7:0] timer_trig01     ; 
    wire [ 7:0] timer_trig02     ;
    wire [ 7:0] timer_trig03     ;
    wire [ 7:0] timer_trig04     ;
    wire [ 7:0] timer_trig05     ;
    wire [ 7:0] timer_trig06     ;
    wire [ 7:0] timer_trig07     ;
    wire [ 7:0] timer_trig08     ;
    wire [ 7:0] timer_trig09     ;
    wire [ 7:0] timer_trig10     ;
    wire [ 7:0] timer_trig11     ;
    wire [ 7:0] timer_trig12     ;
    wire [ 7:0] timer_trig13     ;
    wire [ 7:0] timer_trig14     ;
    wire [ 7:0] timer_trig15     ;
    wire [ 7:0] timer_trig16     ;
    wire [ 7:0] timer_trig17     ;
    wire [ 7:0] timer_trig18     ;
    wire [ 7:0] timer_trig19     ;
    wire [ 7:0] timer_trig20     ;
    
    wire        frame_lost_error;
     
    spi_slave_reg spi_slave_reg_inst(
            .clk                (clk_50M           ),
            .rst_n              (rst_n             ),
           
            .rx_data_ready      (rx_data_ready     ),
            .rx_data            (rx_data           ), 
            .tx_data_ready      (tx_data_ready     ),
            .tx_data            (tx_data           ),
                                                                                                                        
            .spi_clk_error      (spi_clk_error     ),        
            .version            (version           ),// version of this project 
                                                                                                            
            .reg_baudrate_main  (reg_baudrate_main ),
            .reg_baudrate_01    (reg_baudrate_01   ),
            .reg_baudrate_02    (reg_baudrate_02   ),
            .reg_baudrate_03    (reg_baudrate_03   ),
            .reg_baudrate_04    (reg_baudrate_04   ),
            .reg_baudrate_05    (reg_baudrate_05   ),
            .reg_baudrate_06    (reg_baudrate_06   ),
            .reg_baudrate_07    (reg_baudrate_07   ),
            .reg_baudrate_08    (reg_baudrate_08   ),
            .reg_baudrate_09    (reg_baudrate_09   ),
            .reg_baudrate_10    (reg_baudrate_10   ),
            .reg_baudrate_11    (reg_baudrate_11   ),
            .reg_baudrate_12    (reg_baudrate_12   ),
            .reg_baudrate_13    (reg_baudrate_13   ),
            .reg_baudrate_14    (reg_baudrate_14   ),
            .reg_baudrate_15    (reg_baudrate_15   ),
            .reg_baudrate_16    (reg_baudrate_16   ),
            .reg_baudrate_17    (reg_baudrate_17   ),
            .reg_baudrate_18    (reg_baudrate_18   ),
            .reg_baudrate_19    (reg_baudrate_19   ),
            .reg_baudrate_20    (reg_baudrate_20   ),
            
            .reg_timer_trig01   (timer_trig01      ),
            .reg_timer_trig02   (timer_trig02      ),
            .reg_timer_trig03   (timer_trig03      ),
            .reg_timer_trig04   (timer_trig04      ),
            .reg_timer_trig05   (timer_trig05      ),
            .reg_timer_trig06   (timer_trig06      ),
            .reg_timer_trig07   (timer_trig07      ),
            .reg_timer_trig08   (timer_trig08      ),
            .reg_timer_trig09   (timer_trig09      ),
            .reg_timer_trig10   (timer_trig10      ),
            .reg_timer_trig11   (timer_trig11      ),
            .reg_timer_trig12   (timer_trig12      ),
            .reg_timer_trig13   (timer_trig13      ),
            .reg_timer_trig14   (timer_trig14      ),
            .reg_timer_trig15   (timer_trig15      ),
            .reg_timer_trig16   (timer_trig16      ),
            .reg_timer_trig17   (timer_trig17      ),
            .reg_timer_trig18   (timer_trig18      ),
            .reg_timer_trig19   (timer_trig19      ),
            .reg_timer_trig20   (timer_trig20      ),
             
            .frame_lost_error   (frame_lost_error  )
            );
    
    wire [7:0]  uartM_rx_data        ;        
    wire        uartM_rx_data_ready  ;
    wire        uartM_rx_err         ;	             
                  
    wire        uartM_tx_status      ;      
    wire        uartM_tx_over        ;
    wire [7:0]  uartM_tx_data        ;
    wire        uartM_tx_data_ready  ;
    uart_transceiver uart_transceiver_Main(
            .uart_rx_data       (uartM_rx_data       ),  
	        .uart_rx_data_ready (uartM_rx_data_ready ), //high level pulse active,one clk cycle
            .uart_rx_err        (uartM_rx_err        ),	      //high level pulse active,one clk cycle
	                                              
	        .uart_tx_status     (uartM_tx_status     ),      //high level means tx is in progress
	        .uart_tx_over       (uartM_tx_over       ),        //high level pulse active,one clk cycle
	        .uart_tx_data       (uartM_tx_data       ),  
	        .uart_tx_data_ready (uartM_tx_data_ready ),   
	       
	        .uart_chip_de       (),                  //uart transceiver chip transmit enable
	        .uart_chip_re_n     (),                  //uart transceiver chip receive enable
	        .uart_chip_di       (uart_rx_from_fpga  ),//uart transceiver chip transmit input
	        .uart_chip_ro       (uart_tx_to_fpga    ),//uart transceiver chip receive output
	        
	        .baudrate_reg       (reg_baudrate_main  ),
	                             
	        .clk                (clk_50M            ),  
            .uart_clk           (clk_25M            ),//uart sampling clock	,baudrate is calcurated according this clock
	        .rst_n              (rst_n              )
	        );
    wire        uart01_tx_status    ;      
    wire        uart01_tx_over      ;
    wire [7:0]  uart01_tx_data      ;
    wire        uart01_tx_data_ready;
                                    
    wire        uart02_tx_status    ;
    wire        uart02_tx_over      ;
    wire [7:0]  uart02_tx_data      ;
    wire        uart02_tx_data_ready;
                                    
    wire        uart03_tx_status    ;
    wire        uart03_tx_over      ;
    wire [7:0]  uart03_tx_data      ;
    wire        uart03_tx_data_ready;
                                   
    wire        uart04_tx_status    ;
    wire        uart04_tx_over      ;
    wire [7:0]  uart04_tx_data      ;
    wire        uart04_tx_data_ready;
                                   
    wire        uart05_tx_status    ;
    wire        uart05_tx_over      ;
    wire [7:0]  uart05_tx_data      ;
    wire        uart05_tx_data_ready;
                                     
    wire        uart06_tx_status    ;
    wire        uart06_tx_over      ;
    wire [7:0]  uart06_tx_data      ;
    wire        uart06_tx_data_ready;
                                   
    wire        uart07_tx_status    ;
    wire        uart07_tx_over      ;
    wire [7:0]  uart07_tx_data      ;
    wire        uart07_tx_data_ready;
                                    
    wire        uart08_tx_status    ;
    wire        uart08_tx_over      ;
    wire [7:0]  uart08_tx_data      ;
    wire        uart08_tx_data_ready;
                                    
    wire        uart09_tx_status    ;
    wire        uart09_tx_over      ;
    wire [7:0]  uart09_tx_data      ;
    wire        uart09_tx_data_ready;
                                    
    wire        uart10_tx_status    ;
    wire        uart10_tx_over      ;
    wire [7:0]  uart10_tx_data      ;
    wire        uart10_tx_data_ready;
                                     
    wire        uart11_tx_status    ;
    wire        uart11_tx_over      ;
    wire [7:0]  uart11_tx_data      ;
    wire        uart11_tx_data_ready;
                                     
    wire        uart12_tx_status    ;
    wire        uart12_tx_over      ;
    wire [7:0]  uart12_tx_data      ;
    wire        uart12_tx_data_ready;
                                     
    wire        uart13_tx_status    ;
    wire        uart13_tx_over      ;
    wire [7:0]  uart13_tx_data      ;
    wire        uart13_tx_data_ready;
                                     
    wire        uart14_tx_status    ;
    wire        uart14_tx_over      ;
    wire [7:0]  uart14_tx_data      ;
    wire        uart14_tx_data_ready;
                                    
    wire        uart15_tx_status    ;
    wire        uart15_tx_over      ;
    wire [7:0]  uart15_tx_data      ;
    wire        uart15_tx_data_ready;
                                     
    wire        uart16_tx_status    ;
    wire        uart16_tx_over      ;
    wire [7:0]  uart16_tx_data      ;
    wire        uart16_tx_data_ready;
                                     
    wire        uart17_tx_status    ;
    wire        uart17_tx_over      ;
    wire [7:0]  uart17_tx_data      ;
    wire        uart17_tx_data_ready;
                                     
    wire        uart18_tx_status    ;
    wire        uart18_tx_over      ;
    wire [7:0]  uart18_tx_data      ;
    wire        uart18_tx_data_ready;
                                    
    wire        uart19_tx_status    ;
    wire        uart19_tx_over      ;
    wire [7:0]  uart19_tx_data      ;
    wire        uart19_tx_data_ready;
                                     
    wire        uart20_tx_status    ;
    wire        uart20_tx_over      ;
    wire [7:0]  uart20_tx_data      ;
    wire        uart20_tx_data_ready;
    
    MainTxctrl MainTxctrl_inst( 
            .clk                    (clk_50M        ),
            .rst_n                  (rst_n          ),
            
            .uartM_rx_data          (uartM_rx_data          ),        
            .uartM_rx_data_ready    (uartM_rx_data_ready    ), 
                                                            
            .uart01_tx_status       (uart01_tx_status       ),
            .uart01_tx_over         (uart01_tx_over         ),
            .uart01_tx_data         (uart01_tx_data         ),
            .uart01_tx_data_ready   (uart01_tx_data_ready   ),
                                                            
            .uart02_tx_status       (uart02_tx_status       ),
            .uart02_tx_over         (uart02_tx_over         ),
            .uart02_tx_data         (uart02_tx_data         ),
            .uart02_tx_data_ready   (uart02_tx_data_ready   ),
             
            .uart03_tx_status       (uart03_tx_status       ),
            .uart03_tx_over         (uart03_tx_over         ),
            .uart03_tx_data         (uart03_tx_data         ),
            .uart03_tx_data_ready   (uart03_tx_data_ready   ),
                                                            
            .uart04_tx_status       (uart04_tx_status       ),
            .uart04_tx_over         (uart04_tx_over         ),
            .uart04_tx_data         (uart04_tx_data         ),
            .uart04_tx_data_ready   (uart04_tx_data_ready   ),
                                                            
            .uart05_tx_status       (uart05_tx_status       ),
            .uart05_tx_over         (uart05_tx_over         ),
            .uart05_tx_data         (uart05_tx_data         ),
            .uart05_tx_data_ready   (uart05_tx_data_ready   ),
                                                            
            .uart06_tx_status       (uart06_tx_status       ),
            .uart06_tx_over         (uart06_tx_over         ),
            .uart06_tx_data         (uart06_tx_data         ),
            .uart06_tx_data_ready   (uart06_tx_data_ready   ),
                                                            
            .uart07_tx_status       (uart07_tx_status       ),
            .uart07_tx_over         (uart07_tx_over         ),
            .uart07_tx_data         (uart07_tx_data         ),
            .uart07_tx_data_ready   (uart07_tx_data_ready   ),
                                                            
            .uart08_tx_status       (uart08_tx_status       ),
            .uart08_tx_over         (uart08_tx_over         ),
            .uart08_tx_data         (uart08_tx_data         ),
            .uart08_tx_data_ready   (uart08_tx_data_ready   ),
                                                            
            .uart09_tx_status       (uart09_tx_status       ),
            .uart09_tx_over         (uart09_tx_over         ),
            .uart09_tx_data         (uart09_tx_data         ),
            .uart09_tx_data_ready   (uart09_tx_data_ready   ),
                                                            
            .uart10_tx_status       (uart10_tx_status       ),
            .uart10_tx_over         (uart10_tx_over         ),
            .uart10_tx_data         (uart10_tx_data         ),
            .uart10_tx_data_ready   (uart10_tx_data_ready   ),
                                                            
            .uart11_tx_status       (uart11_tx_status       ),
            .uart11_tx_over         (uart11_tx_over         ),
            .uart11_tx_data         (uart11_tx_data         ),
            .uart11_tx_data_ready   (uart11_tx_data_ready   ),
                                                            
            .uart12_tx_status       (uart12_tx_status       ),
            .uart12_tx_over         (uart12_tx_over         ),
            .uart12_tx_data         (uart12_tx_data         ),
            .uart12_tx_data_ready   (uart12_tx_data_ready   ),
                                                            
            .uart13_tx_status       (uart13_tx_status       ),
            .uart13_tx_over         (uart13_tx_over         ),
            .uart13_tx_data         (uart13_tx_data         ),
            .uart13_tx_data_ready   (uart13_tx_data_ready   ),
                                                            
            .uart14_tx_status       (uart14_tx_status       ),
            .uart14_tx_over         (uart14_tx_over         ),
            .uart14_tx_data         (uart14_tx_data         ),
            .uart14_tx_data_ready   (uart14_tx_data_ready   ),
                                                            
            .uart15_tx_status       (uart15_tx_status       ),
            .uart15_tx_over         (uart15_tx_over         ),
            .uart15_tx_data         (uart15_tx_data         ),
            .uart15_tx_data_ready   (uart15_tx_data_ready   ),
                                                            
            .uart16_tx_status       (uart16_tx_status       ),
            .uart16_tx_over         (uart16_tx_over         ),
            .uart16_tx_data         (uart16_tx_data         ),
            .uart16_tx_data_ready   (uart16_tx_data_ready   ),
                                                            
            .uart17_tx_status       (uart17_tx_status       ),
            .uart17_tx_over         (uart17_tx_over         ),
            .uart17_tx_data         (uart17_tx_data         ),
            .uart17_tx_data_ready   (uart17_tx_data_ready   ),
                                                            
            .uart18_tx_status       (uart18_tx_status       ),
            .uart18_tx_over         (uart18_tx_over         ),
            .uart18_tx_data         (uart18_tx_data         ),
            .uart18_tx_data_ready   (uart18_tx_data_ready   ),
                                                            
            .uart19_tx_status       (uart19_tx_status       ),
            .uart19_tx_over         (uart19_tx_over         ),
            .uart19_tx_data         (uart19_tx_data         ),
            .uart19_tx_data_ready   (uart19_tx_data_ready   ),
                                                            
            .uart20_tx_status       (uart20_tx_status       ),
            .uart20_tx_over         (uart20_tx_over         ),
            .uart20_tx_data         (uart20_tx_data         ),
            .uart20_tx_data_ready   (uart20_tx_data_ready   )                           
            );
 
    
    
    
    wire [7:0]  uart01_rx_data        ;        
    wire        uart01_rx_data_ready  ;
    wire        uart01_rx_err         ;	                              
 
    uart_transceiver uart_transceiver_01inst(
            .uart_rx_data       (uart01_rx_data       ),  
	        .uart_rx_data_ready (uart01_rx_data_ready ), //high level pulse active,one clk cycle
            .uart_rx_err        (uart01_rx_err        ),	      //high level pulse active,one clk cycle
	                                           
	        .uart_tx_status     (uart01_tx_status     ),      //high level means tx is in progress
	        .uart_tx_over       (uart01_tx_over       ),        //high level pulse active,one clk cycle
	        .uart_tx_data       (uart01_tx_data       ),  
	        .uart_tx_data_ready (uart01_tx_data_ready ),   
	       
	        .uart_chip_de       (),                  //uart transceiver chip transmit enable
	        .uart_chip_re_n     (),                  //uart transceiver chip receive enable
	        .uart_chip_di       (uart_tx[0]         ),//uart transceiver chip transmit input
	        .uart_chip_ro       (uart_rx[0]         ),//uart transceiver chip receive output
	        
	        .baudrate_reg       (reg_baudrate_01    ),
	                             
	        .clk                (clk_50M            ),  
            .uart_clk           (clk_25M            ),//uart sampling clock	,baudrate is calcurated according this clock
	        .rst_n              (rst_n              )
	        );
     
    wire [7:0]  uart02_rx_data        ;        
    wire        uart02_rx_data_ready  ;
    wire        uart02_rx_err         ;	                              
 
    uart_transceiver uart_transceiver_02inst(
            .uart_rx_data       (uart02_rx_data       ),  
	        .uart_rx_data_ready (uart02_rx_data_ready ), //high level pulse active,one clk cycle
            .uart_rx_err        (uart02_rx_err        ),	      //high level pulse active,one clk cycle
	                                  
	        .uart_tx_status     (uart02_tx_status     ),      //high level means tx is in progress
	        .uart_tx_over       (uart02_tx_over       ),        //high level pulse active,one clk cycle
	        .uart_tx_data       (uart02_tx_data       ),  
	        .uart_tx_data_ready (uart02_tx_data_ready ),   
	       
	        .uart_chip_de       (),                  //uart transceiver chip transmit enable
	        .uart_chip_re_n     (),                  //uart transceiver chip receive enable
	        .uart_chip_di       (uart_tx[1]         ),//uart transceiver chip transmit input
	        .uart_chip_ro       (uart_rx[1]         ),//uart transceiver chip receive output
	        
	        .baudrate_reg       (reg_baudrate_02    ),
	                             
	        .clk                (clk_50M            ),  
            .uart_clk           (clk_25M            ),//uart sampling clock	,baudrate is calcurated according this clock
	        .rst_n              (rst_n              )
	        );
    wire [7:0]  uart03_rx_data        ;        
    wire        uart03_rx_data_ready  ;
    wire        uart03_rx_err         ;	 
    uart_transceiver uart_transceiver_03inst(
            .uart_rx_data       (uart03_rx_data       ),  
	        .uart_rx_data_ready (uart03_rx_data_ready ), //high level pulse active,one clk cycle
            .uart_rx_err        (uart03_rx_err        ),	      //high level pulse active,one clk cycle
	                                 
	        .uart_tx_status     (uart03_tx_status     ),      //high level means tx is in progress
	        .uart_tx_over       (uart03_tx_over       ),        //high level pulse active,one clk cycle
	        .uart_tx_data       (uart03_tx_data       ),  
	        .uart_tx_data_ready (uart03_tx_data_ready ),   
	       
	        .uart_chip_de       (),                  //uart transceiver chip transmit enable
	        .uart_chip_re_n     (),                  //uart transceiver chip receive enable
	        .uart_chip_di       (uart_tx[2]         ),//uart transceiver chip transmit input
	        .uart_chip_ro       (uart_rx[2]         ),//uart transceiver chip receive output
	        
	        .baudrate_reg       (reg_baudrate_03    ),
	                             
	        .clk                (clk_50M            ),  
            .uart_clk           (clk_25M            ),//uart sampling clock	,baudrate is calcurated according this clock
	        .rst_n              (rst_n              )
	        );
    wire [7:0]  uart04_rx_data        ;        
    wire        uart04_rx_data_ready  ;
    wire        uart04_rx_err         ;	 
    uart_transceiver uart_transceiver_04inst(
            .uart_rx_data       (uart04_rx_data       ),  
	        .uart_rx_data_ready (uart04_rx_data_ready ), //high level pulse active,one clk cycle
            .uart_rx_err        (uart04_rx_err        ),	      //high level pulse active,one clk cycle
	                                 
	        .uart_tx_status     (uart04_tx_status     ),      //high level means tx is in progress
	        .uart_tx_over       (uart04_tx_over       ),        //high level pulse active,one clk cycle
	        .uart_tx_data       (uart04_tx_data       ),  
	        .uart_tx_data_ready (uart04_tx_data_ready ),   
	       
	        .uart_chip_de       (),                  //uart transceiver chip transmit enable
	        .uart_chip_re_n     (),                  //uart transceiver chip receive enable
	        .uart_chip_di       (uart_tx[3]         ),//uart transceiver chip transmit input
	        .uart_chip_ro       (uart_rx[3]         ),//uart transceiver chip receive output
	        
	        .baudrate_reg       (reg_baudrate_04    ),
	                             
	        .clk                (clk_50M            ),  
            .uart_clk           (clk_25M            ),//uart sampling clock	,baudrate is calcurated according this clock
	        .rst_n              (rst_n              )
	        );
    wire [7:0]  uart05_rx_data        ;        
    wire        uart05_rx_data_ready  ;
    wire        uart05_rx_err         ;	 
    uart_transceiver uart_transceiver_05inst(
            .uart_rx_data       (uart05_rx_data       ),  
	        .uart_rx_data_ready (uart05_rx_data_ready ), //high level pulse active,one clk cycle
            .uart_rx_err        (uart05_rx_err        ),	      //high level pulse active,one clk cycle
	                                 
	        .uart_tx_status     (uart05_tx_status     ),      //high level means tx is in progress
	        .uart_tx_over       (uart05_tx_over       ),        //high level pulse active,one clk cycle
	        .uart_tx_data       (uart05_tx_data       ),  
	        .uart_tx_data_ready (uart05_tx_data_ready ),   
	       
	        .uart_chip_de       (),                  //uart transceiver chip transmit enable
	        .uart_chip_re_n     (),                  //uart transceiver chip receive enable
	        .uart_chip_di       (uart_tx[4]         ),//uart transceiver chip transmit input
	        .uart_chip_ro       (uart_rx[4]         ),//uart transceiver chip receive output
	        
	        .baudrate_reg       (reg_baudrate_05    ),
	                             
	        .clk                (clk_50M            ),  
            .uart_clk           (clk_25M            ),//uart sampling clock	,baudrate is calcurated according this clock
	        .rst_n              (rst_n              )
	        );
     
    wire [7:0]  uart06_rx_data        ;        
    wire        uart06_rx_data_ready  ;
    wire        uart06_rx_err         ;	                              
 
    uart_transceiver uart_transceiver_06inst(
            .uart_rx_data       (uart06_rx_data       ),  
	        .uart_rx_data_ready (uart06_rx_data_ready ), //high level pulse active,one clk cycle
            .uart_rx_err        (uart06_rx_err        ),	      //high level pulse active,one clk cycle
	                                           
	        .uart_tx_status     (uart06_tx_status     ),      //high level means tx is in progress
	        .uart_tx_over       (uart06_tx_over       ),        //high level pulse active,one clk cycle
	        .uart_tx_data       (uart06_tx_data       ),  
	        .uart_tx_data_ready (uart06_tx_data_ready ),   
	       
	        .uart_chip_de       (),                  //uart transceiver chip transmit enable
	        .uart_chip_re_n     (),                  //uart transceiver chip receive enable
	        .uart_chip_di       (uart_tx[5]         ),//uart transceiver chip transmit input
	        .uart_chip_ro       (uart_rx[5]         ),//uart transceiver chip receive output
	        
	        .baudrate_reg       (reg_baudrate_06    ),
	                             
	        .clk                (clk_50M            ),  
            .uart_clk           (clk_25M            ),//uart sampling clock	,baudrate is calcurated according this clock
	        .rst_n              (rst_n              )
	        );
     
    wire [7:0]  uart07_rx_data        ;        
    wire        uart07_rx_data_ready  ;
    wire        uart07_rx_err         ;	                              
 
    uart_transceiver uart_transceiver_07inst(
            .uart_rx_data       (uart07_rx_data       ),  
	        .uart_rx_data_ready (uart07_rx_data_ready ), //high level pulse active,one clk cycle
            .uart_rx_err        (uart07_rx_err        ),	      //high level pulse active,one clk cycle
	                                  
	        .uart_tx_status     (uart07_tx_status     ),      //high level means tx is in progress
	        .uart_tx_over       (uart07_tx_over       ),        //high level pulse active,one clk cycle
	        .uart_tx_data       (uart07_tx_data       ),  
	        .uart_tx_data_ready (uart07_tx_data_ready ),   
	       
	        .uart_chip_de       (),                  //uart transceiver chip transmit enable
	        .uart_chip_re_n     (),                  //uart transceiver chip receive enable
	        .uart_chip_di       (uart_tx[6]         ),//uart transceiver chip transmit input
	        .uart_chip_ro       (uart_rx[6]         ),//uart transceiver chip receive output
	        
	        .baudrate_reg       (reg_baudrate_07    ),
	                             
	        .clk                (clk_50M            ),  
            .uart_clk           (clk_25M            ),//uart sampling clock	,baudrate is calcurated according this clock
	        .rst_n              (rst_n              )
	        );
    wire [7:0]  uart08_rx_data        ;        
    wire        uart08_rx_data_ready  ;
    wire        uart08_rx_err         ;	 
    uart_transceiver uart_transceiver_08inst(
            .uart_rx_data       (uart08_rx_data       ),  
	        .uart_rx_data_ready (uart08_rx_data_ready ), //high level pulse active,one clk cycle
            .uart_rx_err        (uart08_rx_err        ),	      //high level pulse active,one clk cycle
	                                 
	        .uart_tx_status     (uart08_tx_status     ),      //high level means tx is in progress
	        .uart_tx_over       (uart08_tx_over       ),        //high level pulse active,one clk cycle
	        .uart_tx_data       (uart08_tx_data       ),  
	        .uart_tx_data_ready (uart08_tx_data_ready ),   
	       
	        .uart_chip_de       (),                  //uart transceiver chip transmit enable
	        .uart_chip_re_n     (),                  //uart transceiver chip receive enable
	        .uart_chip_di       (uart_tx[7]         ),//uart transceiver chip transmit input
	        .uart_chip_ro       (uart_rx[7]         ),//uart transceiver chip receive output
	        
	        .baudrate_reg       (reg_baudrate_09    ),
	                             
	        .clk                (clk_50M            ),  
            .uart_clk           (clk_25M            ),//uart sampling clock	,baudrate is calcurated according this clock
	        .rst_n              (rst_n              )
	        );
    wire [7:0]  uart09_rx_data        ;        
    wire        uart09_rx_data_ready  ;
    wire        uart09_rx_err         ;	 
    uart_transceiver uart_transceiver_09inst(
            .uart_rx_data       (uart09_rx_data       ),  
	        .uart_rx_data_ready (uart09_rx_data_ready ), //high level pulse active,one clk cycle
            .uart_rx_err        (uart09_rx_err        ),	      //high level pulse active,one clk cycle
	                                 
	        .uart_tx_status     (uart09_tx_status     ),      //high level means tx is in progress
	        .uart_tx_over       (uart09_tx_over       ),        //high level pulse active,one clk cycle
	        .uart_tx_data       (uart09_tx_data       ),  
	        .uart_tx_data_ready (uart09_tx_data_ready ),   
	       
	        .uart_chip_de       (),                  //uart transceiver chip transmit enable
	        .uart_chip_re_n     (),                  //uart transceiver chip receive enable
	        .uart_chip_di       (uart_tx[8]         ),//uart transceiver chip transmit input
	        .uart_chip_ro       (uart_rx[8]         ),//uart transceiver chip receive output
	        
	        .baudrate_reg       (reg_baudrate_09    ),
	                             
	        .clk                (clk_50M            ),  
            .uart_clk           (clk_25M            ),//uart sampling clock	,baudrate is calcurated according this clock
	        .rst_n              (rst_n              )
	        );
    wire [7:0]  uart10_rx_data        ;        
    wire        uart10_rx_data_ready  ;
    wire        uart10_rx_err         ;	 
    uart_transceiver uart_transceiver_10inst(
            .uart_rx_data       (uart10_rx_data       ),  
	        .uart_rx_data_ready (uart10_rx_data_ready ), //high level pulse active,one clk cycle
            .uart_rx_err        (uart10_rx_err        ),	      //high level pulse active,one clk cycle
	                                 
	        .uart_tx_status     (uart10_tx_status     ),      //high level means tx is in progress
	        .uart_tx_over       (uart10_tx_over       ),        //high level pulse active,one clk cycle
	        .uart_tx_data       (uart10_tx_data       ),  
	        .uart_tx_data_ready (uart10_tx_data_ready ),   
	       
	        .uart_chip_de       (),                  //uart transceiver chip transmit enable
	        .uart_chip_re_n     (),                  //uart transceiver chip receive enable
	        .uart_chip_di       (uart_tx[9]         ),//uart transceiver chip transmit input
	        .uart_chip_ro       (uart_rx[9]         ),//uart transceiver chip receive output
	        
	        .baudrate_reg       (reg_baudrate_10    ),
	                             
	        .clk                (clk_50M            ),  
            .uart_clk           (clk_25M            ),//uart sampling clock	,baudrate is calcurated according this clock
	        .rst_n              (rst_n              )
	        );
     
    
    
    wire [7:0]  uart11_rx_data        ;        
    wire        uart11_rx_data_ready  ;
    wire        uart11_rx_err         ;	                              
 
    uart_transceiver uart_transceiver_11inst(
            .uart_rx_data       (uart11_rx_data       ),  
	        .uart_rx_data_ready (uart11_rx_data_ready ), //high level pulse active,one clk cycle
            .uart_rx_err        (uart11_rx_err        ),	      //high level pulse active,one clk cycle
	                                           
	        .uart_tx_status     (uart11_tx_status     ),      //high level means tx is in progress
	        .uart_tx_over       (uart11_tx_over       ),        //high level pulse active,one clk cycle
	        .uart_tx_data       (uart11_tx_data       ),  
	        .uart_tx_data_ready (uart11_tx_data_ready ),   
	       
	        .uart_chip_de       (),                  //uart transceiver chip transmit enable
	        .uart_chip_re_n     (),                  //uart transceiver chip receive enable
	        .uart_chip_di       (uart_tx[10]         ),//uart transceiver chip transmit input
	        .uart_chip_ro       (uart_rx[10]         ),//uart transceiver chip receive output
	        
	        .baudrate_reg       (reg_baudrate_11    ),
	                             
	        .clk                (clk_50M            ),  
            .uart_clk           (clk_25M            ),//uart sampling clock	,baudrate is calcurated according this clock
	        .rst_n              (rst_n              )
	        );
     
    wire [7:0]  uart12_rx_data        ;        
    wire        uart12_rx_data_ready  ;
    wire        uart12_rx_err         ;	                              
 
    uart_transceiver uart_transceiver_12inst(
            .uart_rx_data       (uart12_rx_data       ),  
	        .uart_rx_data_ready (uart12_rx_data_ready ), //high level pulse active,one clk cycle
            .uart_rx_err        (uart12_rx_err        ),	      //high level pulse active,one clk cycle
	                                  
	        .uart_tx_status     (uart12_tx_status     ),      //high level means tx is in progress
	        .uart_tx_over       (uart12_tx_over       ),        //high level pulse active,one clk cycle
	        .uart_tx_data       (uart12_tx_data       ),  
	        .uart_tx_data_ready (uart12_tx_data_ready ),   
	       
	        .uart_chip_de       (),                  //uart transceiver chip transmit enable
	        .uart_chip_re_n     (),                  //uart transceiver chip receive enable
	        .uart_chip_di       (uart_tx[11]         ),//uart transceiver chip transmit input
	        .uart_chip_ro       (uart_rx[11]         ),//uart transceiver chip receive output
	        
	        .baudrate_reg       (reg_baudrate_12    ),
	                             
	        .clk                (clk_50M            ),  
            .uart_clk           (clk_25M            ),//uart sampling clock	,baudrate is calcurated according this clock
	        .rst_n              (rst_n              )
	        );
    wire [7:0]  uart13_rx_data        ;        
    wire        uart13_rx_data_ready  ;
    wire        uart13_rx_err         ;	 
    uart_transceiver uart_transceiver_13inst(
            .uart_rx_data       (uart13_rx_data       ),  
	        .uart_rx_data_ready (uart13_rx_data_ready ), //high level pulse active,one clk cycle
            .uart_rx_err        (uart13_rx_err        ),	      //high level pulse active,one clk cycle
	                                 
	        .uart_tx_status     (uart13_tx_status     ),      //high level means tx is in progress
	        .uart_tx_over       (uart13_tx_over       ),        //high level pulse active,one clk cycle
	        .uart_tx_data       (uart13_tx_data       ),  
	        .uart_tx_data_ready (uart13_tx_data_ready ),   
	       
	        .uart_chip_de       (),                  //uart transceiver chip transmit enable
	        .uart_chip_re_n     (),                  //uart transceiver chip receive enable
	        .uart_chip_di       (uart_tx[12]         ),//uart transceiver chip transmit input
	        .uart_chip_ro       (uart_rx[12]         ),//uart transceiver chip receive output
	        
	        .baudrate_reg       (reg_baudrate_13    ),
	                             
	        .clk                (clk_50M            ),  
            .uart_clk           (clk_25M            ),//uart sampling clock	,baudrate is calcurated according this clock
	        .rst_n              (rst_n              )
	        );
    wire [7:0]  uart14_rx_data        ;        
    wire        uart14_rx_data_ready  ;
    wire        uart14_rx_err         ;	 
    uart_transceiver uart_transceiver_14inst(
            .uart_rx_data       (uart14_rx_data       ),  
	        .uart_rx_data_ready (uart14_rx_data_ready ), //high level pulse active,one clk cycle
            .uart_rx_err        (uart14_rx_err        ),	      //high level pulse active,one clk cycle
	                                 
	        .uart_tx_status     (uart14_tx_status     ),      //high level means tx is in progress
	        .uart_tx_over       (uart14_tx_over       ),        //high level pulse active,one clk cycle
	        .uart_tx_data       (uart14_tx_data       ),  
	        .uart_tx_data_ready (uart14_tx_data_ready ),   
	       
	        .uart_chip_de       (),                  //uart transceiver chip transmit enable
	        .uart_chip_re_n     (),                  //uart transceiver chip receive enable
	        .uart_chip_di       (uart_tx[13]         ),//uart transceiver chip transmit input
	        .uart_chip_ro       (uart_rx[13]         ),//uart transceiver chip receive output
	        
	        .baudrate_reg       (reg_baudrate_14    ),
	                             
	        .clk                (clk_50M            ),  
            .uart_clk           (clk_25M            ),//uart sampling clock	,baudrate is calcurated according this clock
	        .rst_n              (rst_n              )
	        );
    wire [7:0]  uart15_rx_data        ;        
    wire        uart15_rx_data_ready  ;
    wire        uart15_rx_err         ;	 
    uart_transceiver uart_transceiver_15inst(
            .uart_rx_data       (uart15_rx_data       ),  
	        .uart_rx_data_ready (uart15_rx_data_ready ), //high level pulse active,one clk cycle
            .uart_rx_err        (uart15_rx_err        ),	      //high level pulse active,one clk cycle
	                                 
	        .uart_tx_status     (uart15_tx_status     ),      //high level means tx is in progress
	        .uart_tx_over       (uart15_tx_over       ),        //high level pulse active,one clk cycle
	        .uart_tx_data       (uart15_tx_data       ),  
	        .uart_tx_data_ready (uart15_tx_data_ready ),   
	       
	        .uart_chip_de       (),                  //uart transceiver chip transmit enable
	        .uart_chip_re_n     (),                  //uart transceiver chip receive enable
	        .uart_chip_di       (uart_tx[14]         ),//uart transceiver chip transmit input
	        .uart_chip_ro       (uart_rx[14]         ),//uart transceiver chip receive output
	        
	        .baudrate_reg       (reg_baudrate_15    ),
	                             
	        .clk                (clk_50M            ),  
            .uart_clk           (clk_25M            ),//uart sampling clock	,baudrate is calcurated according this clock
	        .rst_n              (rst_n              )
	        );
     
    wire [7:0]  uart16_rx_data        ;        
    wire        uart16_rx_data_ready  ;
    wire        uart16_rx_err         ;	                              
 
    uart_transceiver uart_transceiver_16inst(
            .uart_rx_data       (uart16_rx_data       ),  
	        .uart_rx_data_ready (uart16_rx_data_ready ), //high level pulse active,one clk cycle
            .uart_rx_err        (uart16_rx_err        ),	      //high level pulse active,one clk cycle
	                                           
	        .uart_tx_status     (uart16_tx_status     ),      //high level means tx is in progress
	        .uart_tx_over       (uart16_tx_over       ),        //high level pulse active,one clk cycle
	        .uart_tx_data       (uart16_tx_data       ),  
	        .uart_tx_data_ready (uart16_tx_data_ready ),   
	       
	        .uart_chip_de       (),                  //uart transceiver chip transmit enable
	        .uart_chip_re_n     (),                  //uart transceiver chip receive enable
	        .uart_chip_di       (uart_tx[15]         ),//uart transceiver chip transmit input
	        .uart_chip_ro       (uart_rx[15]         ),//uart transceiver chip receive output
	        
	        .baudrate_reg       (reg_baudrate_16    ),
	                             
	        .clk                (clk_50M            ),  
            .uart_clk           (clk_25M            ),//uart sampling clock	,baudrate is calcurated according this clock
	        .rst_n              (rst_n              )
	        );
     
    wire [7:0]  uart17_rx_data        ;        
    wire        uart17_rx_data_ready  ;
    wire        uart17_rx_err         ;	                              
 
    uart_transceiver uart_transceiver_17inst(
            .uart_rx_data       (uart17_rx_data       ),  
	        .uart_rx_data_ready (uart17_rx_data_ready ), //high level pulse active,one clk cycle
            .uart_rx_err        (uart17_rx_err        ),	      //high level pulse active,one clk cycle
	                                  
	        .uart_tx_status     (uart17_tx_status     ),      //high level means tx is in progress
	        .uart_tx_over       (uart17_tx_over       ),        //high level pulse active,one clk cycle
	        .uart_tx_data       (uart17_tx_data       ),  
	        .uart_tx_data_ready (uart17_tx_data_ready ),   
	       
	        .uart_chip_de       (),                  //uart transceiver chip transmit enable
	        .uart_chip_re_n     (),                  //uart transceiver chip receive enable
	        .uart_chip_di       (uart_tx[16]         ),//uart transceiver chip transmit input
	        .uart_chip_ro       (uart_rx[16]         ),//uart transceiver chip receive output
	        
	        .baudrate_reg       (reg_baudrate_17    ),
	                             
	        .clk                (clk_50M            ),  
            .uart_clk           (clk_25M            ),//uart sampling clock	,baudrate is calcurated according this clock
	        .rst_n              (rst_n              )
	        );
    wire [7:0]  uart18_rx_data        ;        
    wire        uart18_rx_data_ready  ;
    wire        uart18_rx_err         ;	 
    uart_transceiver uart_transceiver_18inst(
            .uart_rx_data       (uart18_rx_data       ),  
	        .uart_rx_data_ready (uart18_rx_data_ready ), //high level pulse active,one clk cycle
            .uart_rx_err        (uart18_rx_err        ),	      //high level pulse active,one clk cycle
	                                 
	        .uart_tx_status     (uart18_tx_status     ),      //high level means tx is in progress
	        .uart_tx_over       (uart18_tx_over       ),        //high level pulse active,one clk cycle
	        .uart_tx_data       (uart18_tx_data       ),  
	        .uart_tx_data_ready (uart18_tx_data_ready ),   
	       
	        .uart_chip_de       (),                  //uart transceiver chip transmit enable
	        .uart_chip_re_n     (),                  //uart transceiver chip receive enable
	        .uart_chip_di       (uart_tx[17]         ),//uart transceiver chip transmit input
	        .uart_chip_ro       (uart_rx[17]         ),//uart transceiver chip receive output
	        
	        .baudrate_reg       (reg_baudrate_19    ),
	                             
	        .clk                (clk_50M            ),  
            .uart_clk           (clk_25M            ),//uart sampling clock	,baudrate is calcurated according this clock
	        .rst_n              (rst_n              )
	        );
    wire [7:0]  uart19_rx_data        ;        
    wire        uart19_rx_data_ready  ;
    wire        uart19_rx_err         ;	 
    uart_transceiver uart_transceiver_19inst(
            .uart_rx_data       (uart19_rx_data       ),  
	        .uart_rx_data_ready (uart19_rx_data_ready ), //high level pulse active,one clk cycle
            .uart_rx_err        (uart19_rx_err        ),	      //high level pulse active,one clk cycle
	                                 
	        .uart_tx_status     (uart19_tx_status     ),      //high level means tx is in progress
	        .uart_tx_over       (uart19_tx_over       ),        //high level pulse active,one clk cycle
	        .uart_tx_data       (uart19_tx_data       ),  
	        .uart_tx_data_ready (uart19_tx_data_ready ),   
	       
	        .uart_chip_de       (),                  //uart transceiver chip transmit enable
	        .uart_chip_re_n     (),                  //uart transceiver chip receive enable
	        .uart_chip_di       (uart_tx[18]         ),//uart transceiver chip transmit input
	        .uart_chip_ro       (uart_rx[18]         ),//uart transceiver chip receive output
	        
	        .baudrate_reg       (reg_baudrate_19    ),
	                             
	        .clk                (clk_50M            ),  
            .uart_clk           (clk_25M            ),//uart sampling clock	,baudrate is calcurated according this clock
	        .rst_n              (rst_n              )
	        );
    wire [7:0]  uart20_rx_data        ;        
    wire        uart20_rx_data_ready  ;
    wire        uart20_rx_err         ;	 
    uart_transceiver uart_transceiver_20inst(
            .uart_rx_data       (uart20_rx_data       ),  
	        .uart_rx_data_ready (uart20_rx_data_ready ), //high level pulse active,one clk cycle
            .uart_rx_err        (uart20_rx_err        ),	      //high level pulse active,one clk cycle
	                                 
	        .uart_tx_status     (uart20_tx_status     ),      //high level means tx is in progress
	        .uart_tx_over       (uart20_tx_over       ),        //high level pulse active,one clk cycle
	        .uart_tx_data       (uart20_tx_data       ),  
	        .uart_tx_data_ready (uart20_tx_data_ready ),   
	       
	        .uart_chip_de       (),                  //uart transceiver chip transmit enable
	        .uart_chip_re_n     (),                  //uart transceiver chip receive enable
	        .uart_chip_di       (uart_tx[19]         ),//uart transceiver chip transmit input
	        .uart_chip_ro       (uart_rx[19]         ),//uart transceiver chip receive output
	        
	        .baudrate_reg       (reg_baudrate_20    ),
	                             
	        .clk                (clk_50M            ),  
            .uart_clk           (clk_25M            ),//uart sampling clock	,baudrate is calcurated according this clock
	        .rst_n              (rst_n              )
	        );
     
    
    MainRxctrl MainRxctrl_inst(
            .clk                   (clk_50M               ),        
            .rst_n                 (rst_n                 ), 
            
            .timer_trig01          (timer_trig01          ),
            .timer_trig02          (timer_trig02          ),
            .timer_trig03          (timer_trig03          ),
            .timer_trig04          (timer_trig04          ),
            .timer_trig05          (timer_trig05          ),
            .timer_trig06          (timer_trig06          ),
            .timer_trig07          (timer_trig07          ),
            .timer_trig08          (timer_trig08          ),
            .timer_trig09          (timer_trig09          ),
            .timer_trig10          (timer_trig10          ),
            .timer_trig11          (timer_trig11          ),
            .timer_trig12          (timer_trig12          ),
            .timer_trig13          (timer_trig13          ),
            .timer_trig14          (timer_trig14          ),
            .timer_trig15          (timer_trig15          ),
            .timer_trig16          (timer_trig16          ),
            .timer_trig17          (timer_trig17          ),
            .timer_trig18          (timer_trig18          ),
            .timer_trig19          (timer_trig19          ),
            .timer_trig20          (timer_trig20          ),
             
            .uart01_rx_data        (uart01_rx_data        ),       
            .uart01_rx_data_ready  (uart01_rx_data_ready  ),
            .uart01_rx_err         (uart01_rx_err         ),
            
            .uart02_rx_data        (uart02_rx_data        ),       
            .uart02_rx_data_ready  (uart02_rx_data_ready  ),
            .uart02_rx_err         (uart02_rx_err         ),
            
            .uart03_rx_data        (uart03_rx_data        ),       
            .uart03_rx_data_ready  (uart03_rx_data_ready  ),
            .uart03_rx_err         (uart03_rx_err         ),
           
            .uart04_rx_data        (uart04_rx_data        ),       
            .uart04_rx_data_ready  (uart04_rx_data_ready  ),
            .uart04_rx_err         (uart04_rx_err         ),
            
            .uart05_rx_data        (uart05_rx_data        ),       
            .uart05_rx_data_ready  (uart05_rx_data_ready  ),
            .uart05_rx_err         (uart05_rx_err         ),
            
            .uart06_rx_data        (uart06_rx_data        ),       
            .uart06_rx_data_ready  (uart06_rx_data_ready  ),
            .uart06_rx_err         (uart06_rx_err         ),
            
            .uart07_rx_data        (uart07_rx_data        ),       
            .uart07_rx_data_ready  (uart07_rx_data_ready  ),
            .uart07_rx_err         (uart07_rx_err         ),
           
            .uart08_rx_data        (uart08_rx_data        ),       
            .uart08_rx_data_ready  (uart08_rx_data_ready  ),
            .uart08_rx_err         (uart08_rx_err         ),
           
            .uart09_rx_data        (uart09_rx_data        ),       
            .uart09_rx_data_ready  (uart09_rx_data_ready  ),
            .uart09_rx_err         (uart09_rx_err         ),
          
            .uart10_rx_data        (uart10_rx_data        ),       
            .uart10_rx_data_ready  (uart10_rx_data_ready  ),
            .uart10_rx_err         (uart10_rx_err         ), 
            
            .uart11_rx_data        (uart11_rx_data        ),    
            .uart11_rx_data_ready  (uart11_rx_data_ready  ),
            .uart11_rx_err         (uart11_rx_err         ),
            
            .uart12_rx_data        (uart12_rx_data        ),
            .uart12_rx_data_ready  (uart12_rx_data_ready  ),
            .uart12_rx_err         (uart12_rx_err         ),
          
            .uart13_rx_data        (uart13_rx_data        ),
            .uart13_rx_data_ready  (uart13_rx_data_ready  ),
            .uart13_rx_err         (uart13_rx_err         ),
          
            .uart14_rx_data        (uart14_rx_data        ),
            .uart14_rx_data_ready  (uart14_rx_data_ready  ),
            .uart14_rx_err         (uart14_rx_err         ),
           
            .uart15_rx_data        (uart15_rx_data        ),
            .uart15_rx_data_ready  (uart15_rx_data_ready  ),
            .uart15_rx_err         (uart15_rx_err         ),
         
            .uart16_rx_data        (uart16_rx_data        ),
            .uart16_rx_data_ready  (uart16_rx_data_ready  ),
            .uart16_rx_err         (uart16_rx_err         ),
            
            .uart17_rx_data        (uart17_rx_data        ),
            .uart17_rx_data_ready  (uart17_rx_data_ready  ),
            .uart17_rx_err         (uart17_rx_err         ),
          
            .uart18_rx_data        (uart18_rx_data        ),
            .uart18_rx_data_ready  (uart18_rx_data_ready  ),
            .uart18_rx_err         (uart18_rx_err         ),
           
            .uart19_rx_data        (uart19_rx_data        ),
            .uart19_rx_data_ready  (uart19_rx_data_ready  ),
            .uart19_rx_err         (uart19_rx_err         ),
            
            .uart20_rx_data        (uart20_rx_data        ),
            .uart20_rx_data_ready  (uart20_rx_data_ready  ),
            .uart20_rx_err         (uart20_rx_err         ),
             
            .uartM_tx_status       (uartM_tx_status       ),    
            .uartM_tx_over         (uartM_tx_over         ),
            .uartM_tx_data         (uartM_tx_data         ),
            .uartM_tx_data_ready   (uartM_tx_data_ready   ) 
            );
   
endmodule
