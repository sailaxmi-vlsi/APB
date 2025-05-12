`timescale 1ns / 1ps
 module APB_master #(
    parameter ADDR = 5,
    parameter DATA = 32
)(
    input  pclk,
    input  prst,
    input  tr,
    input  ext_write,
    input  [ADDR-1:0] w_paddr,
    input  [ADDR-1:0] r_paddr,
    input  [DATA-1:0] ext_pwdata,ext_prdata,
    input  preadyout,

    output reg psel,
    output reg penable,
    output reg pwrite,
    output reg [ADDR-1:0] paddr,
    output reg [DATA-1:0] pwdata,
    output reg [DATA-1:0] prdata
);

    // Define state registers
    reg [1:0] p_state, n_state;
    
    // Define states
    localparam idle = 2'b00, setup = 2'b01, access = 2'b10;

    // State transition on clock or reset
    always @(posedge pclk or negedge prst) begin
        if (!prst)
            p_state <= idle;
        else
            p_state <= n_state;
    end

    // Next-state logic and output logic
    always @(*) begin
        // Default values
        //psel = 1'b0;
        //penable = 1'b0;
        pwrite = ext_write;
        n_state = p_state;

        case (p_state)
            idle: begin
            psel = 1'b0;
            penable = 1'b0;
                if (tr) begin
                    psel = 1'b1;
                    n_state = setup;
                end
            end

            setup: begin
                psel = 1'b1;
                penable = 1'b0;

                // Set paddr and pwdata based on write or read
                if (ext_write) begin
                    paddr = w_paddr;
                    pwdata = ext_pwdata;
                end else begin
                    paddr = r_paddr;
                end
                
                // Move to access state
                n_state = access;
            end

            access: begin
                if (psel) begin
                    penable = 1'b1;
                    if (preadyout) begin
                        if (ext_write) begin
                            n_state = setup;
                        end else begin
                            prdata = ext_prdata;
                            n_state = setup;
                        end
                    end else begin
                        n_state = access;
                    end
                end else begin
                    n_state = idle;
                end
            end

            default: n_state = idle;
        endcase
    end

endmodule
