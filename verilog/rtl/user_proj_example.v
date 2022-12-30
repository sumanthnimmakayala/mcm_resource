// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module user_proj_example #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);
    wire clk;
    wire rst;

    wire [`MPRJ_IO_PADS-1:0] io_in;
    wire [`MPRJ_IO_PADS-1:0] io_out;
    wire [`MPRJ_IO_PADS-1:0] io_oeb;

    wire [31:0] rdata; 
    wire [31:0] wdata;
    wire [BITS-1:0] count;

    wire valid;
    wire [3:0] wstrb;
    wire [31:0] la_write;

    // WB MI A
    assign valid = wbs_cyc_i && wbs_stb_i; 
    assign wstrb = wbs_sel_i & {4{wbs_we_i}};
    assign wbs_dat_o = rdata;
    assign wdata = wbs_dat_i;

    // IO
    assign io_out = count;
    assign io_oeb = {(`MPRJ_IO_PADS-1){rst}};

    // IRQ
    assign irq = 3'b000;	// Unused

    // LA
    assign la_data_out = {{(127-BITS){1'b0}}, count};
    // Assuming LA probes [63:32] are for controlling the count register  
    assign la_write = ~la_oenb[63:32] & ~{BITS{valid}};
    // Assuming LA probes [65:64] are for controlling the count clk & reset  
    assign clk = (~la_oenb[64]) ? la_data_in[64]: wb_clk_i;
    assign rst = (~la_oenb[65]) ? la_data_in[65]: wb_rst_i;

mcm_resource dut(x0s,x1s,x2s,x3s,x4s,x5s,x6s,x7s,
x0,x1,x2,x3,x4,x5,x6,x7,os,o,

s0_1,s0_2,s0_3,s0_4,s0_5,s0_6,s0_7,s0_a,s0_b,s0_c,s0_d,s0_e,s0_f,s0_g,s0_el,
s1_1,s1_2,s1_3,s1_4,s1_5,s1_6,s1_7,s1_a,s1_b,s1_c,s1_d,s1_e,s1_f,s1_g,s1_el,
s2_1,s2_2,s2_3,s2_4,s2_5,s2_6,s2_7,s2_a,s2_b,s2_c,s2_d,s2_e,s2_f,s2_g,s2_el,
s3_1,s3_2,s3_3,s3_4,s3_5,s3_6,s3_7,s3_a,s3_b,s3_c,s3_d,s3_e,s3_f,s3_g,s3_el,
s4_1,s4_2,s4_3,s4_4,s4_5,s4_6,s4_7,s4_a,s4_b,s4_c,s4_d,s4_e,s4_f,s4_g,s4_el,
s5_1,s5_2,s5_3,s5_4,s5_5,s5_6,s5_7,s5_a,s5_b,s5_c,s5_d,s5_e,s5_f,s5_g,s5_el,
s6_1,s6_2,s6_3,s6_4,s6_5,s6_6,s6_7,s6_a,s6_b,s6_c,s6_d,s6_e,s6_f,s6_g,s6_el,
s7_1,s7_2,s7_3,s7_4,s7_5,s7_6,s7_7,s7_a,s7_b,s7_c,s7_d,s7_e,s7_f,s7_g,s7_el

);

endmodule

//multi-transform integer DCT using mcmr existing IEEE
//Resource shared architecture of multiple transforms for multiple video codecs

/*`include "mcmr.v"
`include "mux2_1.v"
`include "mux2_32.v"
`include "recurse.v"
`include "kgp.v"
`include "kgp_carry.v"
`include "recursive_stage1.v"
`include "adder32.v"
`include "mux3_32.v"
`include "mux5_33.v"
`include "mux6_33.v"
`include "mux4_33.v"
`include "mux3_33.v"
`include "mux7_33.v"*/

module mcm_resource(x0s,x1s,x2s,x3s,x4s,x5s,x6s,x7s,
x0,x1,x2,x3,x4,x5,x6,x7,os,o,

s0_1,s0_2,s0_3,s0_4,s0_5,s0_6,s0_7,s0_a,s0_b,s0_c,s0_d,s0_e,s0_f,s0_g,s0_el,
s1_1,s1_2,s1_3,s1_4,s1_5,s1_6,s1_7,s1_a,s1_b,s1_c,s1_d,s1_e,s1_f,s1_g,s1_el,
s2_1,s2_2,s2_3,s2_4,s2_5,s2_6,s2_7,s2_a,s2_b,s2_c,s2_d,s2_e,s2_f,s2_g,s2_el,
s3_1,s3_2,s3_3,s3_4,s3_5,s3_6,s3_7,s3_a,s3_b,s3_c,s3_d,s3_e,s3_f,s3_g,s3_el,
s4_1,s4_2,s4_3,s4_4,s4_5,s4_6,s4_7,s4_a,s4_b,s4_c,s4_d,s4_e,s4_f,s4_g,s4_el,
s5_1,s5_2,s5_3,s5_4,s5_5,s5_6,s5_7,s5_a,s5_b,s5_c,s5_d,s5_e,s5_f,s5_g,s5_el,
s6_1,s6_2,s6_3,s6_4,s6_5,s6_6,s6_7,s6_a,s6_b,s6_c,s6_d,s6_e,s6_f,s6_g,s6_el,
s7_1,s7_2,s7_3,s7_4,s7_5,s7_6,s7_7,s7_a,s7_b,s7_c,s7_d,s7_e,s7_f,s7_g,s7_el

);

input x0s,x1s,x2s,x3s,x4s,x5s,x6s,x7s;
input [15:0] x0,x1,x2,x3,x4,x5,x6,x7;
output os;
output [31:0] o;

input s0_1,s0_2,s0_3,s0_4,s0_6,s0_7;
input [1:0] s0_5;
input [2:0] s0_a,s0_f,s0_el;
input [1:0] s0_b,s0_c,s0_d,s0_e,s0_g;

input s1_1,s1_2,s1_3,s1_4,s1_6,s1_7;
input [1:0] s1_5;
input [2:0] s1_a,s1_f,s1_el;
input [1:0] s1_b,s1_c,s1_d,s1_e,s1_g;

input s2_1,s2_2,s2_3,s2_4,s2_6,s2_7;
input [1:0] s2_5;
input [2:0] s2_a,s2_f,s2_el;
input [1:0] s2_b,s2_c,s2_d,s2_e,s2_g;

input s3_1,s3_2,s3_3,s3_4,s3_6,s3_7;
input [1:0] s3_5;
input [2:0] s3_a,s3_f,s3_el;
input [1:0] s3_b,s3_c,s3_d,s3_e,s3_g;

input s4_1,s4_2,s4_3,s4_4,s4_6,s4_7;
input [1:0] s4_5;
input [2:0] s4_a,s4_f,s4_el;
input [1:0] s4_b,s4_c,s4_d,s4_e,s4_g;

input s5_1,s5_2,s5_3,s5_4,s5_6,s5_7;
input [1:0] s5_5;
input [2:0] s5_a,s5_f,s5_el;
input [1:0] s5_b,s5_c,s5_d,s5_e,s5_g;

input s6_1,s6_2,s6_3,s6_4,s6_6,s6_7;
input [1:0] s6_5;
input [2:0] s6_a,s6_f,s6_el;
input [1:0] s6_b,s6_c,s6_d,s6_e,s6_g;

input s7_1,s7_2,s7_3,s7_4,s7_6,s7_7;
input [1:0] s7_5;
input [2:0] s7_a,s7_f,s7_el;
input [1:0] s7_b,s7_c,s7_d,s7_e,s7_g;

wire y0s,y1s,y2s,y3s,y4s,y5s,y6s,y7s;
wire [31:0] y0,y1,y2,y3,y4,y5,y6,y7;

mcmr m0(x0s,x0,y0s,y0,
s0_1,s0_2,s0_3,s0_4,s0_5,s0_6,s0_7,s0_a,s0_b,s0_c,s0_d,s0_e,s0_f,s0_g,s0_el);

mcmr m1(x1s,x1,y1s,y1,
s1_1,s1_2,s1_3,s1_4,s1_5,s1_6,s1_7,s1_a,s1_b,s1_c,s1_d,s1_e,s1_f,s1_g,s1_el);

mcmr m2(x2s,x2,y2s,y2,
s2_1,s2_2,s2_3,s2_4,s2_5,s2_6,s2_7,s2_a,s2_b,s2_c,s2_d,s2_e,s2_f,s2_g,s2_el);

mcmr m3(x3s,x3,y3s,y3,
s3_1,s3_2,s3_3,s3_4,s3_5,s3_6,s3_7,s3_a,s3_b,s3_c,s3_d,s3_e,s3_f,s3_g,s3_el);

mcmr m4(x4s,x4,y4s,y4,
s4_1,s4_2,s4_3,s4_4,s4_5,s4_6,s4_7,s4_a,s4_b,s4_c,s4_d,s4_e,s4_f,s4_g,s4_el);

mcmr m5(x5s,x5,y5s,y5,
s5_1,s5_2,s5_3,s5_4,s5_5,s5_6,s5_7,s5_a,s5_b,s5_c,s5_d,s5_e,s5_f,s5_g,s5_el);

mcmr m6(x6s,x6,y6s,y6,
s6_1,s6_2,s6_3,s6_4,s6_5,s6_6,s6_7,s6_a,s6_b,s6_c,s6_d,s6_e,s6_f,s6_g,s6_el);

mcmr m7(x7s,x7,y7s,y7,
s7_1,s7_2,s7_3,s7_4,s7_5,s7_6,s7_7,s7_a,s7_b,s7_c,s7_d,s7_e,s7_f,s7_g,s7_el);

//adder tree

wire l11s,l12s,l13s,l14s,l15s,l16s,l17s,l18s;
wire [31:0] l11,l12,l13,l14,l15,l16,l17,l18;
wire c11,c12,c13,c14,c15,c16,c17,c18;

adder32 l1a_1(y0s,y0,y1s,y1,l11s,l11,c11);
adder32 l1a_2(y2s,y2,y3s,y3,l12s,l12,c12);
adder32 l1a_3(y4s,y4,y5s,y5,l13s,l13,c13);
adder32 l1a_4(y6s,y6,y7s,y7,l14s,l14,c14);

wire l21s,l22s,l23s,l24s;
wire [31:0] l21,l22,l23,l24;
wire c21,c22,c23,c24;

adder32 l2a_1(l11s,l11,l12s,l12,l21s,l21,c21);
adder32 l2a_2(l13s,l13,l14s,l14,l22s,l22,c22);

wire l31s,l32s;
wire [31:0] l31,l32;
wire c31,c32;

adder32 l3a_1(l21s,l21,l22s,l22,os,o,c31);

endmodule




//multiple constant multiplication

module mcmr(ins,in,ys,y,
s1,s2,s3,s4,s5,s6,s7,sa,sb,sc,sd,se,sf,sg,sel);

input ins;
input [15:0] in;
input s1,s2,s3,s4,s6,s7;
input [1:0] s5;
input [2:0] sa,sf,sel;
input [1:0] sb,sc,sd,se,sg;

output ys;
output [31:0] y;

wire axs,bxs,cxs,dxs,exs,fxs,gxs;
wire [31:0] ax,bx,cx,dx,ex,fx,gx;

wire [31:0] x;
wire xs;
assign x={16'b0,in};
assign xs=ins;

wire x1s;
wire s1s;
mux2_1 m1(xs,(~xs),x1s,s1);

wire [31:0] x1;
wire s2;
mux2_32 m2({x[28:0],3'b000},{x[29:0],2'b00},x1,s2);

wire x2s;
wire s3;
mux2_1 m3(xs,(~xs),x2s,s3);

wire c1;
wire r1s;
wire [31:0] r1;
adder32 a1(xs,{x[27:0],4'b0},x1s,x,r1s,r1,c1);//{15x,17x}

wire c2;
wire r2s;
wire [31:0] r2;
adder32 a2(xs,x1,x2s,x,r2s,r2,c2);//{3x,5x,7x}

wire [31:0] x3;
wire s4;
mux2_32 m4({r1[26:0],5'b000},{x[27:0],4'b0},x3,s4);
wire x3s;
mux2_1 m5(r1s,xs,x3s,s4);

wire c3;
wire r3s;
wire [31:0] r3;
adder32 a3(xs,{x[25:0],6'b0},(~r1s),r1,r3s,r3,c3);//49x

wire c4;
wire r4s;
wire [31:0] r4;
adder32 a4(x3s,x3,(~r2s),r2,r4s,r4,c4);//{11x,473x}

wire c5;
wire r5s;
wire [31:0] r5;
adder32 a5(r3s,{r3[29:0],2'b00},(~r1s),r1,r5s,r5,c5); //181x

wire c6;
wire r6s;
wire [31:0] r6;
adder32 a6(xs,{x[29:0],2'b00},xs,x,r6s,r6,c6); //5x

wire [31:0] x4;
wire [1:0] s5;
mux3_32 m6({r6[29:0],2'b00},{x[27:0],4'b00},{x[29:0],2'b00},x4,s5); 

wire [31:0] x5;
wire s6;
mux2_32 m7(r6,x,x5,s6); 

wire [31:0] x6;
wire s7;
mux2_32 m8({r6[29:0],2'b00},{x[28:0],3'b00},x6,s7);

wire c7;
wire r7s;
wire [31:0] r7;
adder32 a7(xs,{x[23:0],8'b00},(~r6s),r6,r7s,r7,c7); //251x

wire c8;
wire r8s;
wire [31:0] r8;
adder32 a8(xs,x4,(~xs),x,r8s,r8,c8); //{3x,15x,19x}

wire c9;
wire r9s;
wire [31:0] r9;
adder32 a9(xs,x5,xs,x6,r9s,r9,c9); //{9x,25x}

wire c10;
wire r10s;
wire [31:0] r10;
adder32 a10(r7s,r7,(~r8s),{r8[30:0],1'b0},r10s,r10,c10); //{213x}

wire c11;
wire r11s;
wire [31:0] r11;
adder32 a11(r8s,{r8[29:0],2'b00},(~r6s),r6,r11s,r11,c11); //{71x}

wire [2:0] sa;

mux5_33 ma({r5s,{r5[30:0],1'b0}},{r2s,{r2[29:0],2'b00}},{xs,{x[28:0],3'b000}},{r1s,r1},{xs,x},{axs,ax},sa);

wire [2:0] sf;

mux6_33 mf({r4s,r4},{xs,{x[27:0],4'b00}},{xs,{x[28:0],3'b000}},{r4s,{r4[30:0],1'b0}},{xs,{x[30:0],1'b0}},{r2s,{r2}},{fxs,fx},sf);

wire [1:0] sg;

mux4_33 mg({r3s,{r3[29:0],2'b00}},{r2s,{r2[30:0],1'b0}},{xs,{x[29:0],2'b00}},{xs,x},{gxs,gx},sg);

wire [1:0] sb;

mux4_33 mb({r7s,{r7[30:0],1'b0}},{xs,{x[27:0],4'b00}},{r8s,{r8[29:0],2'b00}},{r6s,{r6[30:0],1'b0}},{bxs,bx},sb);

wire [1:0] sc;

mux4_33 mc({r10s,{r10[30:0],1'b0}},{r8s,r8},{r6s,{r6[30:0],1'b0}},{r9s,r9},{cxs,cx},sc);

wire [1:0] sd;

mux3_33 md({r11s,{r11[29:0],2'b00}},{r9s,r9},{r8s,{r8[30:0],1'b0}},{dxs,dx},sd);

wire [1:0] se;

mux4_33 me({r9s,{r9[29:0],2'b00}},{xs,{x[29:0],2'b00}},{r8s,r8},{xs,{x[30:0],1'b0}},{exs,ex},se);

wire [2:0] sel;

mux7_33 my({axs,ax},{bxs,bx},{cxs,cx},{dxs,dx},{exs,ex},{fxs,fx},{gxs,gx},{ys,y},sel);

endmodule



//mux2to1

module mux2_1(in0,in1,y,sel);

input in0,in1;
input sel;
output y;

reg y;
always@(in0 or in1 or sel)
begin
case(sel)
1'b0:y=in0;  
1'b1:y=in1;	 
endcase   
end

endmodule


//mux2to1

module mux2_32(in0,in1,y,sel);

input [31:0] in0,in1;
input sel;
output [31:0] y;

reg [31:0] y;
always@(in0 or in1 or sel)
begin
case(sel)
1'b0:y=in0;  
1'b1:y=in1;	 
endcase   
end

endmodule


//mux3to1

module mux3_32(in0,in1,in2,y,sel);

input [31:0] in0,in1,in2;
input [1:0] sel;
output [31:0] y;

reg [31:0] y;
always@(in0 or in1 or in2 or sel)
begin
case(sel)
2'b00:y=in0;  
2'b01:y=in1;
2'b10:y=in2;	 
endcase   
end

endmodule




//mux4to1

module mux5_33(in0,in1,in2,in3,in4,y,sel);

input [32:0] in0,in1,in2,in3,in4;
input [2:0] sel;
output [32:0] y;

reg [32:0] y;
always@(in0 or in1 or in2 or in3 or in4 or sel)
begin
case(sel)
3'b000:y=in0;  
3'b001:y=in1;
3'b010:y=in2;	
3'b011:y=in3;  
3'b100:y=in4;
endcase   
end

endmodule




//mux4to1

module mux6_33(in0,in1,in2,in3,in4,in5,y,sel);

input [32:0] in0,in1,in2,in3,in4,in5;
input [2:0] sel;
output [32:0] y;

reg [32:0] y;
always@(in0 or in1 or in2 or in3 or in4 or in5 or sel)
begin
case(sel)
3'b000:y=in0;  
3'b001:y=in1;
3'b010:y=in2;	
3'b011:y=in3;  
3'b100:y=in4;
3'b101:y=in5;
endcase   
end

endmodule



//mux4to1

module mux4_33(in0,in1,in2,in3,y,sel);

input [32:0] in0,in1,in2,in3;
input [1:0] sel;
output [32:0] y;

reg [32:0] y;
always@(in0 or in1 or in2 or in3 or sel)
begin
case(sel)
2'b00:y=in0;  
2'b01:y=in1;
2'b10:y=in2;	
2'b11:y=in3;  
endcase   
end

endmodule


//mux3to1

module mux3_33(in0,in1,in2,y,sel);

input [32:0] in0,in1,in2;
input [1:0] sel;
output [32:0] y;

reg [32:0] y;
always@(in0 or in1 or in2 or sel)
begin
case(sel)
2'b00:y=in0;  
2'b01:y=in1;
2'b10:y=in2;	 
endcase   
end

endmodule



//mux4to1

module mux7_33(in0,in1,in2,in3,in4,in5,in6,y,sel);

input [32:0] in0,in1,in2,in3,in4,in5,in6;
input [2:0] sel;
output [32:0] y;

reg [32:0] y;
always@(in0 or in1 or in2 or in3 or in4 or in5 or in6 or sel)
begin
case(sel)
3'b000:y=in0;  
3'b001:y=in1;
3'b010:y=in2;	
3'b011:y=in3;  
3'b100:y=in4;
3'b101:y=in5;
3'b110:y=in6;
endcase   
end

endmodule


//32 bit fixed point adder

module adder32(as,a,bs,in_b,rrs,rr,carry);

input as,bs;
input [31:0] a,in_b;
output rrs;
output [31:0] rr;
output carry;

reg rrs;
reg [31:0] rr;
wire z;
assign z=as^bs;
wire cout,cout1;

wire [31:0] r1,b1,b2;
reg [31:0] b;
assign b1=(~in_b);

recurse c0(b2,cout1,b1,32'b00000000000000000000000000000001);

always@(z or in_b or b2)
	begin
		if(z==0)
			b=in_b;
		else if (z==1)
			//b=(~in_b)+1;
			b=b2;
	end
	
recurse c1(r1,cout,a,b);

wire cout2;
wire [31:0] r11,r22;
assign r11=(~r1);
recurse c2(r22,cout2,r11,32'b00000000000000000000000000000001);

reg carry;
always@(r1 or cout or z or as or bs or r22)
 begin
	if(z==0)	
		begin
			rrs=as;
			rr=r1;
			carry=cout;
		end
	else if (z==1 && cout==1)
		begin	
			rrs=as;
			rr=r1;
			carry=1'b0;
		end
	else if (z==1 && cout==0)
		begin
			rrs=(~as);
			//rr=(~r1)+1;
			rr=r22;
			carry=1'b0;
		end
 end

endmodule



//32 bit recursive doubling technique

/*`include "kgp.v"
`include "kgp_carry.v"
`include "recursive_stage1.v"*/

module recurse(sum,carry,a,b); 

output [31:0] sum;
output  carry;
input [31:0] a,b;

wire [65:0] x;

assign x[1:0]=2'b00;  // kgp generation

//assign {x[3:2]}=(a[0]==b[0])?((a[0]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[5:4]}=(a[1]==b[1])?((a[1]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[7:6]}=(a[2]==b[2])?((a[2]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[9:8]}=(a[3]==b[3])?((a[3]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[11:10]}=(a[4]==b[4])?((a[4]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[13:12]}=(a[5]==b[5])?((a[5]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[15:14]}=(a[6]==b[6])?((a[6]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[17:16]}=(a[7]==b[7])?((a[7]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[19:18]}=(a[8]==b[8])?((a[8]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[21:20]}=(a[9]==b[9])?((a[9]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[23:22]}=(a[10]==b[10])?((a[10]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[25:24]}=(a[11]==b[11])?((a[11]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[27:26]}=(a[12]==b[12])?((a[12]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[29:28]}=(a[13]==b[13])?((a[13]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[31:30]}=(a[14]==b[14])?((a[14]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[33:32]}=(a[15]==b[15])?((a[15]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[35:34]}=(a[16]==b[16])?((a[16]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[37:36]}=(a[17]==b[17])?((a[17]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[39:38]}=(a[18]==b[18])?((a[18]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[41:40]}=(a[19]==b[19])?((a[19]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[43:42]}=(a[20]==b[20])?((a[20]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[45:44]}=(a[21]==b[21])?((a[21]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[47:46]}=(a[22]==b[22])?((a[22]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[49:48]}=(a[23]==b[23])?((a[23]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[51:50]}=(a[24]==b[24])?((a[24]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[53:52]}=(a[25]==b[25])?((a[25]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[55:54]}=(a[26]==b[26])?((a[26]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[57:56]}=(a[27]==b[27])?((a[27]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[59:58]}=(a[28]==b[28])?((a[28]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[61:60]}=(a[29]==b[29])?((a[29]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[63:62]}=(a[30]==b[30])?((a[30]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[65:64]}=(a[31]==b[31])?((a[31]==1'b1)?2'b11:2'b00):2'b01;

kgp a00(a[0],b[0],x[3:2]);
kgp a01(a[1],b[1],x[5:4]);
kgp a02(a[2],b[2],x[7:6]);
kgp a03(a[3],b[3],x[9:8]);
kgp a04(a[4],b[4],x[11:10]);
kgp a05(a[5],b[5],x[13:12]);
kgp a06(a[6],b[6],x[15:14]);
kgp a07(a[7],b[7],x[17:16]);
kgp a08(a[8],b[8],x[19:18]);
kgp a09(a[9],b[9],x[21:20]);
kgp a10(a[10],b[10],x[23:22]);
kgp a11(a[11],b[11],x[25:24]);
kgp a12(a[12],b[12],x[27:26]);
kgp a13(a[13],b[13],x[29:28]);
kgp a14(a[14],b[14],x[31:30]);
kgp a15(a[15],b[15],x[33:32]);
kgp a16(a[16],b[16],x[35:34]);
kgp a17(a[17],b[17],x[37:36]);
kgp a18(a[18],b[18],x[39:38]);
kgp a19(a[19],b[19],x[41:40]);
kgp a20(a[20],b[20],x[43:42]);
kgp a21(a[21],b[21],x[45:44]);
kgp a22(a[22],b[22],x[47:46]);
kgp a23(a[23],b[23],x[49:48]);
kgp a24(a[24],b[24],x[51:50]);
kgp a25(a[25],b[25],x[53:52]);
kgp a26(a[26],b[26],x[55:54]);
kgp a27(a[27],b[27],x[57:56]);
kgp a28(a[28],b[28],x[59:58]);
kgp a29(a[29],b[29],x[61:60]);
kgp a30(a[30],b[30],x[63:62]);
kgp a31(a[31],b[31],x[65:64]);

wire [63:0] x1;  //recursive doubling stage 1
assign x1[1:0]=x[1:0];

recursive_stage1 s00(x[1:0],x[3:2],x1[3:2]);
recursive_stage1 s01(x[3:2],x[5:4],x1[5:4]);
recursive_stage1 s02(x[5:4],x[7:6],x1[7:6]);
recursive_stage1 s03(x[7:6],x[9:8],x1[9:8]);
recursive_stage1 s04(x[9:8],x[11:10],x1[11:10]);
recursive_stage1 s05(x[11:10],x[13:12],x1[13:12]);
recursive_stage1 s06(x[13:12],x[15:14],x1[15:14]);
recursive_stage1 s07(x[15:14],x[17:16],x1[17:16]);
recursive_stage1 s08(x[17:16],x[19:18],x1[19:18]);
recursive_stage1 s09(x[19:18],x[21:20],x1[21:20]);
recursive_stage1 s10(x[21:20],x[23:22],x1[23:22]);
recursive_stage1 s11(x[23:22],x[25:24],x1[25:24]);
recursive_stage1 s12(x[25:24],x[27:26],x1[27:26]);
recursive_stage1 s13(x[27:26],x[29:28],x1[29:28]);
recursive_stage1 s14(x[29:28],x[31:30],x1[31:30]);
recursive_stage1 s15(x[31:30],x[33:32],x1[33:32]);
recursive_stage1 s16(x[33:32],x[35:34],x1[35:34]);
recursive_stage1 s17(x[35:34],x[37:36],x1[37:36]);
recursive_stage1 s18(x[37:36],x[39:38],x1[39:38]);
recursive_stage1 s19(x[39:38],x[41:40],x1[41:40]);
recursive_stage1 s20(x[41:40],x[43:42],x1[43:42]);
recursive_stage1 s21(x[43:42],x[45:44],x1[45:44]);
recursive_stage1 s22(x[45:44],x[47:46],x1[47:46]);
recursive_stage1 s23(x[47:46],x[49:48],x1[49:48]);
recursive_stage1 s24(x[49:48],x[51:50],x1[51:50]);
recursive_stage1 s25(x[51:50],x[53:52],x1[53:52]);
recursive_stage1 s26(x[53:52],x[55:54],x1[55:54]);
recursive_stage1 s27(x[55:54],x[57:56],x1[57:56]);
recursive_stage1 s28(x[57:56],x[59:58],x1[59:58]);
recursive_stage1 s29(x[59:58],x[61:60],x1[61:60]);
recursive_stage1 s30(x[61:60],x[63:62],x1[63:62]);

wire [63:0] x2;  //recursive doubling stage2
assign x2[3:0]=x1[3:0];

recursive_stage1 s101(x1[1:0],x1[5:4],x2[5:4]);
recursive_stage1 s102(x1[3:2],x1[7:6],x2[7:6]);
recursive_stage1 s103(x1[5:4],x1[9:8],x2[9:8]);
recursive_stage1 s104(x1[7:6],x1[11:10],x2[11:10]);
recursive_stage1 s105(x1[9:8],x1[13:12],x2[13:12]);
recursive_stage1 s106(x1[11:10],x1[15:14],x2[15:14]);
recursive_stage1 s107(x1[13:12],x1[17:16],x2[17:16]);
recursive_stage1 s108(x1[15:14],x1[19:18],x2[19:18]);
recursive_stage1 s109(x1[17:16],x1[21:20],x2[21:20]);
recursive_stage1 s110(x1[19:18],x1[23:22],x2[23:22]);
recursive_stage1 s111(x1[21:20],x1[25:24],x2[25:24]);
recursive_stage1 s112(x1[23:22],x1[27:26],x2[27:26]);
recursive_stage1 s113(x1[25:24],x1[29:28],x2[29:28]);
recursive_stage1 s114(x1[27:26],x1[31:30],x2[31:30]);
recursive_stage1 s115(x1[29:28],x1[33:32],x2[33:32]);
recursive_stage1 s116(x1[31:30],x1[35:34],x2[35:34]);
recursive_stage1 s117(x1[33:32],x1[37:36],x2[37:36]);
recursive_stage1 s118(x1[35:34],x1[39:38],x2[39:38]);
recursive_stage1 s119(x1[37:36],x1[41:40],x2[41:40]);
recursive_stage1 s120(x1[39:38],x1[43:42],x2[43:42]);
recursive_stage1 s121(x1[41:40],x1[45:44],x2[45:44]);
recursive_stage1 s122(x1[43:42],x1[47:46],x2[47:46]);
recursive_stage1 s123(x1[45:44],x1[49:48],x2[49:48]);
recursive_stage1 s124(x1[47:46],x1[51:50],x2[51:50]);
recursive_stage1 s125(x1[49:48],x1[53:52],x2[53:52]);
recursive_stage1 s126(x1[51:50],x1[55:54],x2[55:54]);
recursive_stage1 s127(x1[53:52],x1[57:56],x2[57:56]);
recursive_stage1 s128(x1[55:54],x1[59:58],x2[59:58]);
recursive_stage1 s129(x1[57:56],x1[61:60],x2[61:60]);
recursive_stage1 s130(x1[59:58],x1[63:62],x2[63:62]);

wire [63:0] x3;  //recursive doubling stage3
assign x3[7:0]=x2[7:0];

recursive_stage1 s203(x2[1:0],x2[9:8],x3[9:8]);
recursive_stage1 s204(x2[3:2],x2[11:10],x3[11:10]);
recursive_stage1 s205(x2[5:4],x2[13:12],x3[13:12]);
recursive_stage1 s206(x2[7:6],x2[15:14],x3[15:14]);
recursive_stage1 s207(x2[9:8],x2[17:16],x3[17:16]);
recursive_stage1 s208(x2[11:10],x2[19:18],x3[19:18]);
recursive_stage1 s209(x2[13:12],x2[21:20],x3[21:20]);
recursive_stage1 s210(x2[15:14],x2[23:22],x3[23:22]);
recursive_stage1 s211(x2[17:16],x2[25:24],x3[25:24]);
recursive_stage1 s212(x2[19:18],x2[27:26],x3[27:26]);
recursive_stage1 s213(x2[21:20],x2[29:28],x3[29:28]);
recursive_stage1 s214(x2[23:22],x2[31:30],x3[31:30]);
recursive_stage1 s215(x2[25:24],x2[33:32],x3[33:32]);
recursive_stage1 s216(x2[27:26],x2[35:34],x3[35:34]);
recursive_stage1 s217(x2[29:28],x2[37:36],x3[37:36]);
recursive_stage1 s218(x2[31:30],x2[39:38],x3[39:38]);
recursive_stage1 s219(x2[33:32],x2[41:40],x3[41:40]);
recursive_stage1 s220(x2[35:34],x2[43:42],x3[43:42]);
recursive_stage1 s221(x2[37:36],x2[45:44],x3[45:44]);
recursive_stage1 s222(x2[39:38],x2[47:46],x3[47:46]);
recursive_stage1 s223(x2[41:40],x2[49:48],x3[49:48]);
recursive_stage1 s224(x2[43:42],x2[51:50],x3[51:50]);
recursive_stage1 s225(x2[45:44],x2[53:52],x3[53:52]);
recursive_stage1 s226(x2[47:46],x2[55:54],x3[55:54]);
recursive_stage1 s227(x2[49:48],x2[57:56],x3[57:56]);
recursive_stage1 s228(x2[51:50],x2[59:58],x3[59:58]);
recursive_stage1 s229(x2[53:52],x2[61:60],x3[61:60]);
recursive_stage1 s230(x2[55:54],x2[63:62],x3[63:62]);

wire [63:0] x4;  //recursive doubling stage 4
assign x4[15:0]=x3[15:0];

recursive_stage1 s307(x3[1:0],x3[17:16],x4[17:16]);
recursive_stage1 s308(x3[3:2],x3[19:18],x4[19:18]);
recursive_stage1 s309(x3[5:4],x3[21:20],x4[21:20]);
recursive_stage1 s310(x3[7:6],x3[23:22],x4[23:22]);
recursive_stage1 s311(x3[9:8],x3[25:24],x4[25:24]);
recursive_stage1 s312(x3[11:10],x3[27:26],x4[27:26]);
recursive_stage1 s313(x3[13:12],x3[29:28],x4[29:28]);
recursive_stage1 s314(x3[15:14],x3[31:30],x4[31:30]);
recursive_stage1 s315(x3[17:16],x3[33:32],x4[33:32]);
recursive_stage1 s316(x3[19:18],x3[35:34],x4[35:34]);
recursive_stage1 s317(x3[21:20],x3[37:36],x4[37:36]);
recursive_stage1 s318(x3[23:22],x3[39:38],x4[39:38]);
recursive_stage1 s319(x3[25:24],x3[41:40],x4[41:40]);
recursive_stage1 s320(x3[27:26],x3[43:42],x4[43:42]);
recursive_stage1 s321(x3[29:28],x3[45:44],x4[45:44]);
recursive_stage1 s322(x3[31:30],x3[47:46],x4[47:46]);
recursive_stage1 s323(x3[33:32],x3[49:48],x4[49:48]);
recursive_stage1 s324(x3[35:34],x3[51:50],x4[51:50]);
recursive_stage1 s325(x3[37:36],x3[53:52],x4[53:52]);
recursive_stage1 s326(x3[39:38],x3[55:54],x4[55:54]);
recursive_stage1 s327(x3[41:40],x3[57:56],x4[57:56]);
recursive_stage1 s328(x3[43:42],x3[59:58],x4[59:58]);
recursive_stage1 s329(x3[45:44],x3[61:60],x4[61:60]);
recursive_stage1 s330(x3[47:46],x3[63:62],x4[63:62]);

wire [63:0] x5;  //recursive doubling stage 5
assign x5[31:0]=x4[31:0];

recursive_stage1 s415(x4[1:0],x4[33:32],x5[33:32]);
recursive_stage1 s416(x4[3:2],x4[35:34],x5[35:34]);
recursive_stage1 s417(x4[5:4],x4[37:36],x5[37:36]);
recursive_stage1 s418(x4[7:6],x4[39:38],x5[39:38]);
recursive_stage1 s419(x4[9:8],x4[41:40],x5[41:40]);
recursive_stage1 s420(x4[11:10],x4[43:42],x5[43:42]);
recursive_stage1 s421(x4[13:12],x4[45:44],x5[45:44]);
recursive_stage1 s422(x4[15:14],x4[47:46],x5[47:46]);
recursive_stage1 s423(x4[17:16],x4[49:48],x5[49:48]);
recursive_stage1 s424(x4[19:18],x4[51:50],x5[51:50]);
recursive_stage1 s425(x4[21:20],x4[53:52],x5[53:52]);
recursive_stage1 s426(x4[23:22],x4[55:54],x5[55:54]);
recursive_stage1 s427(x4[25:24],x4[57:56],x5[57:56]);
recursive_stage1 s428(x4[27:26],x4[59:58],x5[59:58]);
recursive_stage1 s429(x4[29:28],x4[61:60],x5[61:60]);
recursive_stage1 s430(x4[31:30],x4[63:62],x5[63:62]);

 // final sum and carry

assign sum[0]=a[0]^b[0]^x5[0];
assign sum[1]=a[1]^b[1]^x5[2];
assign sum[2]=a[2]^b[2]^x5[4];
assign sum[3]=a[3]^b[3]^x5[6];
assign sum[4]=a[4]^b[4]^x5[8];
assign sum[5]=a[5]^b[5]^x5[10];
assign sum[6]=a[6]^b[6]^x5[12];
assign sum[7]=a[7]^b[7]^x5[14];
assign sum[8]=a[8]^b[8]^x5[16];
assign sum[9]=a[9]^b[9]^x5[18];
assign sum[10]=a[10]^b[10]^x5[20];
assign sum[11]=a[11]^b[11]^x5[22];
assign sum[12]=a[12]^b[12]^x5[24];
assign sum[13]=a[13]^b[13]^x5[26];
assign sum[14]=a[14]^b[14]^x5[28];
assign sum[15]=a[15]^b[15]^x5[30];
assign sum[16]=a[16]^b[16]^x5[32];
assign sum[17]=a[17]^b[17]^x5[34];
assign sum[18]=a[18]^b[18]^x5[36];
assign sum[19]=a[19]^b[19]^x5[38];
assign sum[20]=a[20]^b[20]^x5[40];
assign sum[21]=a[21]^b[21]^x5[42];
assign sum[22]=a[22]^b[22]^x5[44];
assign sum[23]=a[23]^b[23]^x5[46];
assign sum[24]=a[24]^b[24]^x5[48];
assign sum[25]=a[25]^b[25]^x5[50];
assign sum[26]=a[26]^b[26]^x5[52];
assign sum[27]=a[27]^b[27]^x5[54];
assign sum[28]=a[28]^b[28]^x5[56];
assign sum[29]=a[29]^b[29]^x5[58];
assign sum[30]=a[30]^b[30]^x5[60];
assign sum[31]=a[31]^b[31]^x5[62];


kgp_carry kkc(x[65:64],x5[63:62],carry);

endmodule




module kgp(a,b,y);

input a,b;
output [1:0] y;
//reg [1:0] y;

//always@(a or b)
//begin
//case({a,b})
//2'b00:y=2'b00;  //kill
//2'b11:y=2'b11;	  //generate
//2'b01:y=2'b01;	//propagate
//2'b10:y=2'b01;  //propagate
//endcase   //y[1]=ab  y[0]=a+b  
//end

assign y[0]=a | b;
assign y[1]=a & b;

endmodule




module kgp_carry(a,b,carry);

input [1:0] a,b;
output carry;
reg carry;

always@(a or b)
begin
case(a)
2'b00:carry=1'b0;  
2'b11:carry=1'b1;
2'b01:carry=b[0];
2'b10:carry=b[0];
default:carry=1'bx;
endcase
end

/*wire carry;

wire f,g;
assign g=a[0] & a[1];
assign f=a[0] ^ a[1];

assign carry=g|(b[0] & f);*/

endmodule


module recursive_stage1(a,b,y);

input [1:0] a,b;
output [1:0] y;

wire [1:0] y;
wire b0;
not n1(b0,b[1]);
wire f,g0,g1;
and a1(f,b[0],b[1]);
and a2(g0,b0,b[0],a[0]);
and a3(g1,b0,b[0],a[1]);

or o1(y[0],f,g0);
or o2(y[1],f,g1);

//reg [1:0] y;
//always@(a or b)
//begin
//case(b)
//2'b00:y=2'b00;  
//2'b11:y=2'b11;
//2'b01:y=a;
//default:y=2'bx;
//endcase
//end

//always@(a or b)
//begin
//if(b==2'b00)
//	y=2'b00;  
//else if (b==2'b11)
//	y=2'b11;
//else if (b==2'b01)
//	y=a;
//end

//wire x;
//assign x=a[0] ^ b[0];
//always@(a or b or x)
//begin
//case(x)
//1'b0:y[0]=b[0];  
//1'b1:y[0]=a[0]; 
//endcase
//end
//
//always@(a or b or x)
//begin
//case(x)
//1'b0:y[1]=b[1];  
//1'b1:y[1]=a[1];
//endcase
//end


//always@(a or b)
//begin
//if (b==2'b00)
//	y=2'b00; 
//else if (b==2'b11)	
//	y=2'b11;
//else if (b==2'b01 && a==2'b00)
//	y=2'b00;
//else if (b==2'b01 && a==2'b11)
//	y=2'b11;
//else if (b==2'b01 && a==2'b01)
//	y=2'b01;
//end

endmodule







`default_nettype wire
