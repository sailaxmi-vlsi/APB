`timescale 1ns / 1ps
module APB_top(input pclk,prst);
parameter ADDR=5,DATA=32;
wire psel;            
wire penable;         
wire pwrite;         
wire[ADDR-1:0] paddr;
wire [DATA-1:0] pwdata;

APB_master #(ADDR,DATA )DUT ( .pclk(pclk),.prst(prst),.tr(tr),.ext_write(ext_write),.w_paddr(w_paddr),.r_paddr(r_paddr),.ext_pwdata(ext_pwdata),.ext_prdata(ext_prdata),.preadyout(preadyout),.
 psel(psel),.penable(penable),.pwrite(pwrite),.paddr(paddr),.pwdata(pwdata),.prdata(prdata));


APB_slave#(.ADDR(ADDR),.DATA(DATA)) dut (.pclk(pclk),.prst(prst),.psel(psel),.penable(penable),.pwrite(pwrite),.paddr(paddr),.pwdata(pwdata),.prdata(prdata),.preadyout(preadyout));


endmodule
