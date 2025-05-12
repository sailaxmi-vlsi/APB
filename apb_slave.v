`timescale 1ns / 1ps
module APB_slave#(parameter ADDR=5,DATA=32)(
input pclk,prst,

input psel,            
input penable,         
input pwrite,          
input [ADDR-1:0] paddr,
input [DATA-1:0] pwdata,

output reg [DATA-1:0] prdata,
output reg preadyout);

reg [31:0]mem[4:0];

always@(posedge pclk or negedge prst)begin
  if(!prst)begin                               
               preadyout=1'b0;
               prdata=32'b0;
           end 
  else if(psel&&penable)begin
               if(pwrite)
                   mem[paddr]=pwdata;                                 
            else   
               prdata=mem[paddr];             
               preadyout=1'b1;
       end 
      else  
      preadyout=1'b0;
    end       
endmodule
