`timescale 1ns / 1ps
module asynch_fifo#(data=6,addr=6,depth=32)(
input wclk,rclk,
      r_en,w_en,
      wrst,rrst,
input [data-1:0]wdata,
output w_full,r_empty,almost_full,almost_empty,over_flow,under_flow,
output [addr-1:0] wq2,rq2,wq1,rq1,
output [data-1:0]rdata);
wire [addr-1:0]rgray;
wire [addr-1:0]wgray;
wire [addr-1:0]wptr;
wire [addr-1:0]rptr;
wire [addr-1:0]wq2_bin;
wire [addr-1:0]rq2_bin;
wire [addr-2:0]waddr;
wire [addr-2:0]raddr;
wire wclken;
write_block#(.data(data),.addr(addr)) DUT1(.wclk(wclk),.w_en(w_en),.wrst(wrst),.wq2(wq2),.w_full(w_full),.almost_full(almost_full),.over_flow(over_flow),.wgray(wgray),.wptr(wptr),.wq2_bin(wq2_bin),.waddr(waddr));

read_block #(.data(data),.addr(addr)) DUT2(.rclk(rclk),.r_en(r_en),.rrst(rrst),.rq2(rq2),.r_empty(r_empty),.rgray(rgray),.rptr(rptr),.raddr(raddr),.almost_empty(almost_empty),.under_flow(under_flow));

mem_block#(.addr(addr),.data(data),.depth(depth))DUT3 (.wclken(wclken),.wclk(wclk),.wdata(wdata),.waddr(waddr),.raddr(raddr),.rdata(rdata));

sync_cicuit#(.addr(addr)) DUT4(.rclk(rclk),.rrst(rrst),.wgray(wgray),.rq2(rq2),.rq1(rq1));

sync_cicuit2#(.addr(addr)) DUT5(.wclk(wclk),.wrst(wrst),.rgray(rgray),.wq2(wq2),.wq1(wq1));

assign wclken=((!w_full)&(w_en));


endmodule
