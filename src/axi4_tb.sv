module axi4_tb;
    logic        clk;
    logic        rstn;
    logic [31:0] awaddr, wdata, araddr;
    logic        awvalid, wvalid, arvalid, bready, rready;
    logic [3:0]  wstrb;
    logic        awready, wready, bvalid, arready, rvalid;
    logic [31:0] rdata;
    logic [1:0]  bresp, rresp;

    // 生成时钟信号
    always #5 clk = ~clk;

    // 实例化 AXI4 从设备
    axi4_slave dut (
        .ACLK(clk),
        .ARESETn(rstn),
        .AWADDR(awaddr),
        .AWVALID(awvalid),
        .AWREADY(awready),
        .WDATA(wdata),
        .WSTRB(wstrb),
        .WVALID(wvalid),
        .WREADY(wready),
        .BRESP(bresp),
        .BVALID(bvalid),
        .BREADY(bready),
        .ARADDR(araddr),
        .ARVALID(arvalid),
        .ARREADY(arready),
        .RDATA(rdata),
        .RRESP(rresp),
        .RVALID(rvalid),
        .RREADY(rready)
    );

    initial begin
        // 初始化
        clk = 0;
        rstn = 0;
        awvalid = 0; wvalid = 0; arvalid = 0;
        bready = 0; rready = 0;
        #20 rstn = 1;

        // 写数据测试
        #10 awaddr = 32'h00000004; awvalid = 1;
        wdata = 32'hDEADBEEF; wstrb = 4'b1111; wvalid = 1;
        #10 awvalid = 0; wvalid = 0; bready = 1;
        #10 bready = 0;

        // 读数据测试
        #10 araddr = 32'h00000004; arvalid = 1;
        #10 arvalid = 0; rready = 1;
        #10 rready = 0;

        #50 $finish;
    end

    initial begin
        $dumpfile("axi4_tb.vcd");
        $dumpvars(0, axi4_tb);
    end
endmodule
