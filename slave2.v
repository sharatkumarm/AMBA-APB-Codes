//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.04.2022 23:34:19
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

`define IDLE     2'b00
`define W_ENABLE  2'b01
`define R_ENABLE  2'b10

 module slave2 #(
    parameter DATAWIDTH=8,
    parameter ADDRWIDTH=8       
    )
    (
         input PCLK,PRESETn,
         input PSEL,PENABLE,PWRITE,
         input [ADDRWIDTH-1:0] PADDR,
         input [DATAWIDTH-1:0] PWDATA,
         output reg [DATAWIDTH-1:0] PRDATA2,
         output reg PREADY );
          
     //reg [ADDRWIDTH:0]reg_addr;     
     reg  [DATAWIDTH-1:0] mem2[0:2**ADDRWIDTH -1];
     //assign PRDATA1 =  mem[reg_addr];


   always @(*)
       begin
         if(!PRESETn)
              PREADY = 0;                                                                      //  Same logic as used by slave1 but states are replaced by is-else statements
          else
	  if(PSEL && !PENABLE && !PWRITE)
	     begin PREADY = 0; end
	         
	  else if(PSEL && PENABLE && !PWRITE)
	     begin  PREADY = 1;
                    PRDATA2=  mem2[PADDR]; 
	       end
          else if(PSEL && !PENABLE && PWRITE)
	     begin  PREADY = 0; end

	  else if(PSEL && PENABLE && PWRITE)
	     begin  PREADY = 1;
	            mem2[PADDR] = PWDATA; end

           else PREADY = 0;
        end
    endmodule
