//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2022 22:47:71
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
  module test;

  reg PCLK,PRESETn,transfer,READ_WRITE;
  reg [8:0]apb_write_paddr;
  reg [7:0]apb_write_data;
  reg [8:0]apb_read_paddr;
  wire [7:0]apb_read_data_out;
  wire PSLVERR;
  
                 
       APB_Protocol dut_c(  PCLK,
	           PRESETn,
		       transfer,
		       READ_WRITE,
               apb_write_paddr,
		       apb_write_data,
		       apb_read_paddr,
		       PSLVERR, 
               apb_read_data_out
	           );

    always #5 PCLK=~PCLK;
    initial 
      begin 
        initialize;
        idle;
        read(9'hx);              //read operation with no address 
        
        //Slave1 
        write(9'h01,8'haa);      //write address
        write(9'h02,8'h11);
        write(9'h03,8'h99);
        write(9'h05,8'hx);      //write operation without proper data 
        write(9'h04,8'hff);  
        //Slave2
        write(9'h101,8'hbb);      //write address
        write(9'h102,8'hcc);
        write(9'h103,8'hdd);
        write(9'h105,8'hx);      //write operation without proper data 
        write(9'h104,8'hff); 
        write(9'hx,8'h12);      //write operation without write address       
        initialize;
        idle;
        //slave1
        read(9'h01);            //Read operation 
        read(9'h02);
        read(9'h03);
        read(9'h04);
        read(9'h06);
        //Slave2 
        read(9'h101);            //Read operation 
        read(9'h102);
        read(9'h103);
        read(9'h104);
        read(9'h106);
        #20 $finish;
      end
      
      task initialize();
        begin
          PRESETn=0;
          PCLK=1'b0;
          READ_WRITE=1'b0;
          transfer=1'b0;
          @ (posedge PCLK);
        end
      endtask
      
      task idle();
        begin
          PRESETn=1'b1;
        end
      endtask
      
      task write( input [8:0]addr,input [7:0]data);
        begin
          transfer=1'b1;
          READ_WRITE=1'b0;
          apb_write_paddr=addr;
          apb_write_data=data;
          repeat(3)  @ (posedge PCLK);
        end
      endtask
      
      task read( input [8:0]addr);
        begin
          transfer=1'b1;
          READ_WRITE=1'b1;
          apb_read_paddr=addr;
          repeat(3) @ (posedge PCLK);
        end
      endtask
      
     endmodule