`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2025 12:08:04 PM
// Design Name: 
// Module Name: tb_ps2_keyboard
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

module tb_ps2_keyboard;

    reg clk;
    reg rst;
    reg ps2_clk;
    reg ps2_data;
    wire [7:0] ascii;
    wire [1:0] comand;

    ps2_keyboard uut (
        .clk(clk),
        .rst(rst),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .ascii(ascii),
        .comand(comand)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100 MHz clock
    end
    
    task send_scan_code(input [7:0] code);
        integer i;
        reg parity;
        begin
            ps2_data = 0;
            #10; ps2_clk = 0; #10; ps2_clk = 1;

            parity = 0;
            for (i = 0; i < 8; i = i + 1) begin
                ps2_data = code[i];
                parity = parity ^ code[i];
                #10; ps2_clk = 0; #10; ps2_clk = 1;
            end

            ps2_data = (parity == 0) ? 1 : 0;
            #10; ps2_clk = 0; #10; ps2_clk = 1;
    
            ps2_data = 1;
            #10; ps2_clk = 0; #10; ps2_clk = 1;
            #50;
        end
    endtask

    // Test stimulus
    initial begin
        rst = 1;
        ps2_clk = 1;
        ps2_data = 1;
        #10 rst = 0;
        #20;
    
        // Teste: Enviar o código para '1' (0x16)
        send_scan_code(8'h16);
        // Teste: Enviar o código para '1' (0x16)
        send_scan_code(8'h1C);
        // Teste: Enviar código de "break" (0xF0)
        send_scan_code(8'hF0);
        // Em seguida, envia novamente o código da tecla '1'
        send_scan_code(8'h16);
        // Teste: Enviar o código para 'extend' (0xE0)
        send_scan_code(8'hE0);
        // Teste: Enviar o código para '53' (0x16)
        send_scan_code(8'h42);
        
        #100;
        $stop;
    end

endmodule
