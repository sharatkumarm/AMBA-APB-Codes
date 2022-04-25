//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.04.2022 23:32:08
// Design Name: 
// Module Name: testing
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns

  module master_bridge #(
     parameter DATAWIDTH=8,
     parameter ADDRWIDTH=8 
     )
     (    
	input [ADDRWIDTH:0]apb_write_paddr,apb_read_paddr,
	input [DATAWIDTH-1:0] apb_write_data,PRDATA,         
	input PRESETn,PCLK,READ_WRITE,transfer,PREADY,
	output PSEL1,PSEL2,
	output reg PENABLE,
	output reg [ADDRWIDTH:0]PADDR,
	output reg PWRITE,
	output reg [DATAWIDTH:0]PWDATA,apb_read_data_out,
	output reg PSLVERR ); 
	
  reg [2:0] state, next_state;


  localparam IDLE = 3'b001, SETUP = 3'b010, ENABLE = 3'b100 ;


  always @(posedge PCLK)
  begin
	if(!PRESETn)
		state <= IDLE;
	else
		state <= next_state; 
  end

  always @(state,transfer,PREADY)

  begin
	if(!PRESETn)
	  next_state = IDLE;
	else
          begin
             PWRITE = ~READ_WRITE;
	     case(state)
                  
                IDLE: 
                begin 
                PENABLE =0;
		        if(!transfer)
	         	   next_state = IDLE ;
	            else
			       next_state = SETUP;
	            end

	         	SETUP:   begin
			    PENABLE =0;

			    if(READ_WRITE) 
				 //     @(posedge PCLK)
	             begin   
	             PADDR = apb_read_paddr;
	             end
			     else 
			     begin   
			          //@(posedge PCLK)
                 PADDR = apb_write_paddr;
				 PWDATA = apb_write_data;  
				 end
			    
			    if(transfer && !PSLVERR)
			      next_state = ENABLE;
		        else
           	     next_state = IDLE;
		        end

                ENABLE: 
                 begin 
                 if(PSEL1 || PSEL2)
                       PENABLE =1;
                 if(transfer & !PSLVERR)
                 begin
                 if(PREADY)
                 begin
                     if(!READ_WRITE)
                     begin
                            next_state = SETUP; 
                     end
                     else 
                     begin
                           next_state = SETUP; 
                           apb_read_data_out = PRDATA; 
                     end
                     end
                    else 
                        next_state = ENABLE;
                    end
                    else next_state = IDLE;
                 end
                       default: next_state = IDLE; 
                    endcase
                 end
              end
       
         assign {PSEL1,PSEL2} = ((state != IDLE) ? (PADDR[8] ? {1'b0,1'b1} : {1'b1,1'b0}) : 2'd0);

  // PSLVERR LOGIC
  
always @(*)
      begin
       if(!PRESETn)
         PSLVERR=0;
       else
         begin
           if(state == IDLE && next_state == ENABLE)                                                    //to check if setup state is skipped  
                PSLVERR=1;
           else if((apb_write_data===8'dx) && (!READ_WRITE) && (state==SETUP || state==ENABLE))
             PSLVERR=1;
           else if((apb_read_paddr===9'dx) && READ_WRITE && (state==SETUP || state==ENABLE))
             PSLVERR=1;
           else if((apb_write_paddr===9'dx) && (!READ_WRITE) && (state==SETUP || state==ENABLE))
             PSLVERR=1;
           else if(state == SETUP)
             begin
               if(PWRITE)
                 begin
                   if(PADDR!=apb_write_paddr && PWDATA!=apb_write_data)
                     PSLVERR=1;
                   else if (PADDR!=apb_read_paddr)
                     PSLVERR=1;
                   else
                     PSLVERR=0;
                 end    
              end 
            else PSLVERR=0;
            
         end
       end

 endmodule