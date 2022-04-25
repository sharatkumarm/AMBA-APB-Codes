//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2022 19:16:17
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

module APB_Protocol #(
    parameter DATAWIDTH=8,
    parameter ADDRWIDTH=8
    )(
         input PCLK,PRESETn,transfer,READ_WRITE,
         input [ADDRWIDTH:0] apb_write_paddr,
		 input [DATAWIDTH-1:0]apb_write_data,
		 input [ADDRWIDTH:0] apb_read_paddr,
		 output PSLVERR, 
         output [DATAWIDTH-1:0] apb_read_data_out
          );

       wire [DATAWIDTH-1:0]PWDATA,PRDATA,PRDATA1,PRDATA2;
       wire [ADDRWIDTH:0]PADDR;

       wire PREADY,PREADY1,PREADY2,PENABLE,PSEL1,PSEL2,PWRITE;
    
      
       //  assign PREADY = READ_WRITE ? (apb_read_paddr[8] ? PREADY2 : PREADY1) : (apb_write_paddr[8] ? PREADY2 : PREADY1);
        assign PREADY = PADDR[8] ? PREADY2 : PREADY1 ;
        assign PRDATA = READ_WRITE ? (PADDR[8] ? PRDATA2 : PRDATA1) : 8'dx ;
       // assign PRDATA = READ_WRITE ? (apb_read_paddr[8] ? PRDATA2 : PRDATA1) : 16'dx;

              
        master_bridge dut_mas(.apb_write_paddr(apb_write_paddr),
                                .apb_read_paddr(apb_read_paddr),
                                .apb_write_data(apb_write_data),
                                .PRDATA(PRDATA),         
                                .PRESETn(PRESETn),
                                .PCLK(PCLK),
                                .READ_WRITE(READ_WRITE),
                                .transfer(transfer),
                                .PREADY(PREADY),
                                .PSEL1(PSEL1),
                                .PSEL2(PSEL2),
                                .PENABLE(PENABLE),
                                .PADDR(PADDR),
                                .PWRITE(PWRITE),
                                .PWDATA(PWDATA),
                                .apb_read_data_out(apb_read_data_out),
                                .PSLVERR(PSLVERR)
                                  ); 	         

          slave1  dut1(.PCLK(PCLK),
              .PRESETn(PRESETn),
              .PSEL(PSEL1),
              .PENABLE(PENABLE),
              .PWRITE(PWRITE),
              .PADDR(PADDR),
              .PWDATA(PWDATA),
              .PRDATA1(PRDATA1),
              .PREADY(PREADY1));

         slave2  dut2(.PCLK(PCLK),
              .PRESETn(PRESETn),
              .PSEL(PSEL2),
              .PENABLE(PENABLE),
              .PWRITE(PWRITE),
              .PADDR(PADDR),
              .PWDATA(PWDATA),
              .PRDATA2(PRDATA2),
              .PREADY(PREADY2));
 
endmodule