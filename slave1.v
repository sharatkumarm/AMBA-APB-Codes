//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.04.2022 22:44:41
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

`define IDLE      2'b00
`define W_ENABLE  2'b01
`define R_ENABLE  2'b10

 module slave1 #(
    parameter DATAWIDTH=8,
    parameter ADDRWIDTH=8       
    )
    (
         input PCLK,PRESETn,
         input PSEL,PENABLE,PWRITE,
         input [ADDRWIDTH-1:0] PADDR,
         input [DATAWIDTH-1:0] PWDATA,
         output reg [DATAWIDTH-1:0] PRDATA1,
         output reg PREADY );
          
 
     reg [DATAWIDTH-1:0] mem[0:2**ADDRWIDTH -1];
 
     reg [1:0] State,NS;
    
      always @(negedge PRESETn or posedge PCLK) begin
      if (PRESETn == 0) 
      begin
        State <= `IDLE ;
        PRDATA1 <= 0;
      end   
      else
      State<=NS;
      end
      
      always@(*)
      begin
        case (State)
          `IDLE : begin
            PRDATA1 <= 0;
            if (PSEL && PENABLE) 
            begin
              if (PWRITE) 
              begin
                NS <= `W_ENABLE;
              end
              else 
              begin
                NS <= `R_ENABLE;
              end
            end
          end
    
          `W_ENABLE : begin
            if (PSEL && PWRITE && PENABLE) 
            begin
              mem[PADDR]  <= PWDATA;
              PREADY <=1;          
            end
              NS<= `IDLE;
          end
    
          `R_ENABLE : begin
            if (PSEL && !PWRITE && PENABLE) 
            begin
              PREADY <= 1;
              PRDATA1 <= mem[PADDR];
            end
            NS <= `IDLE;
          end
          default: begin
            NS <= `IDLE;
          end
        endcase
      end 
    endmodule
                                                                                                          
           