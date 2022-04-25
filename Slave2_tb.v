`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2022 23:32:08
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


module slave2_tb();
 reg [7:0]PADDR;
   reg  [7:0]PWDATA;
   reg  PCLK;
   reg  PENABLE;
   reg PRESETn;
   reg  PWRITE;
   reg  PSEL;
   wire [7:0]PRDATA;
   wire PREADY;
  // wire addr,wdata;
   slave2 utt(PCLK,PRESETn,PSEL,PENABLE,PWRITE,PADDR,PWDATA, PRDATA,PREADY);

   initial
   begin 
   initialize;
   idle;
   write(8'h01,8'haa);
   write(8'h02,8'h4a);
   write(8'h03,8'hff);
   write(8'h04,8'h33);
   read(8'h01);
   read(8'h02);
   read(8'h03);
   read(8'h04);
   #15 $finish;
//Write transfer with no wait states 
end

task initialize;
  begin
    PADDR=8'h00;
    PWDATA=8'h00;
    PCLK=1'b0;
    PSEL=1'b0;
    PENABLE=1'b0;
    PWRITE=1'b0;
    PRESETn=1'b0;
    //addr=0;
   #5; 
    end
endtask
task idle;
  begin
   PSEL=1'b0;
   PENABLE=1'b0;
   PRESETn=1'b1;
  end
endtask
task write(input [7:0]addr,input [7:0]wdata);
  begin
    @ (posedge PCLK);
    #1
    PSEL=1'b1;
    PWRITE=1'b1;
    PADDR=addr;
    PWDATA=wdata;
    PENABLE=1'b0;
    
    @ (posedge PCLK);
    #1
    PENABLE=1'b1;
    @ (posedge PCLK);
    //#1
  end
endtask  
task read(input [7:0]addr);
  begin
    @ (posedge PCLK);
    #1
    PWRITE=1'b0;
    PSEL=1'b1;
    PADDR=addr;
    PENABLE=1'b0;
    @ (posedge PCLK);
    #1
    PENABLE=1'b1;
    @ (posedge PCLK);
    //#1
  end
endtask  
always #5 PCLK=~PCLK;
endmodule