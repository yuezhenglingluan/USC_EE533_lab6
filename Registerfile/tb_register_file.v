
module tb_register_file;
    reg clk;
    reg [1:0] ra1, ra2, wa;
    reg [63:0] wd;
    reg we;
    wire [63:0] rd1, rd2;

    register_file uut (clk, ra1, ra2, rd1, rd2, wa, wd, we);

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        ra1 = 0; ra2 = 0; wa = 0; wd = 0; we = 0;

        // Test write and read
        @(negedge clk);
        we = 1; wa = 2'b01; wd = 64'h123456789ABCDEF0;
        @(negedge clk);
        we = 0; ra1 = 2'b01;
        #1;
        if (rd1 !== 64'h123456789ABCDEF0) $error("Test 1 failed");

        // Simultaneous read/write
        @(negedge clk);
        we = 1; wa = 2'b10; wd = 64'hFEDCBA9876543210;
        ra1 = 2'b01; ra2 = 2'b10;
        @(negedge clk);
        we = 0;
        #1;
        if (rd1 !== 64'h123456789ABCDEF0 || rd2 !== 64'hFEDCBA9876543210)
            $error("Test 2 failed");

        $finish;
    end
endmodule