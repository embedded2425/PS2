`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2025 12:03:08 AM
// Design Name: 
// Module Name: ps2_keyboard
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
/////////////////////////////////////Quick Access/////////////////////////////////////////////

module ps2_keyboard (
    input wire clk,             // System clock
    input wire rst,             // Reset signal
    input wire ps2_clk,         // PS/2 clock signal
    input wire ps2_data,        // PS/2 data signal
    output reg [7:0] ascii,     // Output ASCII value
    output reg [1:0] comand     // Reg to log Make '00', Break '01', Extended '10'
); //criar uma flag para alertar o 8051 quando tem um tem caracter maybe interrupt?? 

// Define states as parameters
parameter IDLE = 3'd0;
parameter CAPTURE = 3'd1;
parameter PARITY = 3'd2;
parameter DECODE = 3'd3;

reg [2:0] state;        // 3-bit register to hold the state
reg [10:0] shift_reg;   // Shift register to store the 11-bit frame (start + 8 data + parity + stop)
reg [3:0] bit_count;    // Bit counter (0 to 10)
reg computed_parity;    // Parity_check
reg extended_flag;      // Extended flag
reg break_flag;         // Break flag


always @(negedge ps2_clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        shift_reg <= 11'b0;
        bit_count <= 4'b0;
        ascii <= 8'b0;
        comand <= 2'b0;
    end else begin
        case (state)
            IDLE: begin
                 $display("IDLE: Bit Count: %d, ps2_data: %b, Shift Reg: %b", bit_count, ps2_data, shift_reg);
                if (!ps2_data) begin
                    state <= CAPTURE;
                    shift_reg <= 11'b0;
                end else begin
                    state <= IDLE;
                end
            end

            CAPTURE: begin
                shift_reg <= {ps2_data, shift_reg[8:1]};
                bit_count <= bit_count + 1;
                $display("CAPTURE: Bit Count: %d, ps2_data: %b, Shift Reg: %b", bit_count, ps2_data, shift_reg);
                if (bit_count == 7) begin
                    state <= PARITY;
                    bit_count <= 4'b0;
                    $display("Captured Shift Register: %b", shift_reg);
                end else begin
                    state <= CAPTURE;
                end
            end

            PARITY: begin
                $display("PARITY: Bit Count: %d, ps2_data: %b, Shift Reg: %b", bit_count, ps2_data, shift_reg);
                computed_parity = ^shift_reg[8:1];  // if odd is 1
                if (!computed_parity == ps2_data) begin
                    state <= DECODE;
                    $display("Parity Check Passed");
                end else begin
                    state <= IDLE;
                    $display("Parity Check Failed | Expected: %b, Received: %b, Data: %b", !computed_parity, ps2_data, shift_reg[8:1]);
                end
            end

            DECODE: begin
                if (shift_reg[8:1] == 8'hE0) begin
                    extended_flag <= 1;
                    state <= IDLE;
                    $display("Extended Code Detected");
                end
                // Verifica se o código recebido é o break code
                else if (shift_reg[8:1] == 8'hF0) begin
                    break_flag <= 1;
                    state <= IDLE;
                    $display("Break Code Detected");
                end
                else begin
                    if (break_flag) begin
                        break_flag <= 0;
                        ascii <= scan_to_ascii(shift_reg[8:1]);
                        comand = 2'b01;
                        $display("Key Released: %h", shift_reg[8:1]);
                    end else begin
                        if (extended_flag) begin
                            ascii <= scan_to_ascii(shift_reg[8:1]);
                            extended_flag <= 0;
                            comand = 2'b10;
                        end else begin
                            ascii <= scan_to_ascii(shift_reg[8:1]);
                            comand = 2'b00;
                        end
                        $display("Decoding Scan Code: %h", shift_reg[8:1]);
                    end
                    state <= IDLE;
                end
            end 
        endcase
    end
end

// Lookup table for scan code to ASCII conversion
// Faz sentido converter?? ou devemos deixar isso para o 8051??
function [7:0] scan_to_ascii;
    input [7:0] scan_code;
    begin
        case (scan_code)
            8'h16: scan_to_ascii = 8'h31;  // '1'
            8'h1E: scan_to_ascii = 8'h32;  // '2'
            8'h26: scan_to_ascii = 8'h33;  // '3'
            8'h25: scan_to_ascii = 8'h34;  // '4'
            8'h2E: scan_to_ascii = 8'h35;  // '5'
            8'h36: scan_to_ascii = 8'h36;  // '6'
            8'h3D: scan_to_ascii = 8'h37;  // '7'
            8'h3E: scan_to_ascii = 8'h38;  // '8'
            8'h46: scan_to_ascii = 8'h39;  // '9'
            8'h45: scan_to_ascii = 8'h30;  // '0'
            8'h1C: scan_to_ascii = 8'h41;  // 'A'
            8'h32: scan_to_ascii = 8'h42;  // 'B'
            8'h21: scan_to_ascii = 8'h43;  // 'C'
            8'h23: scan_to_ascii = 8'h44;  // 'D'
            8'h24: scan_to_ascii = 8'h45;  // 'E'
            8'h2B: scan_to_ascii = 8'h46;  // 'F'
            8'h34: scan_to_ascii = 8'h47;  // 'G'
            8'h33: scan_to_ascii = 8'h48;  // 'H'
            8'h43: scan_to_ascii = 8'h49;  // 'I'
            8'h3B: scan_to_ascii = 8'h4A;  // 'J'
            8'h42: scan_to_ascii = 8'h4B;  // 'K'
            8'h4B: scan_to_ascii = 8'h4C;  // 'L'
            8'h3A: scan_to_ascii = 8'h4D;  // 'M'
            8'h31: scan_to_ascii = 8'h4E;  // 'N'
            8'h44: scan_to_ascii = 8'h4F;  // 'O'
            8'h4D: scan_to_ascii = 8'h50;  // 'P'
            8'h15: scan_to_ascii = 8'h51;  // 'Q'
            8'h2D: scan_to_ascii = 8'h52;  // 'R'
            8'h1B: scan_to_ascii = 8'h53;  // 'S'
            8'h2C: scan_to_ascii = 8'h54;  // 'T'
            8'h3C: scan_to_ascii = 8'h55;  // 'U'
            8'h2A: scan_to_ascii = 8'h56;  // 'V'
            8'h1D: scan_to_ascii = 8'h57;  // 'W'
            8'h22: scan_to_ascii = 8'h58;  // 'X'
            8'h35: scan_to_ascii = 8'h59;  // 'Y'
            8'h1A: scan_to_ascii = 8'h5A;  // 'Z'
            default: scan_to_ascii = 8'h00;  // Default to null
        endcase
    end
endfunction

endmodule
