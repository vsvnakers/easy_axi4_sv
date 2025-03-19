module axi4_slave (
    input  logic        ACLK,
    input  logic        ARESETn,

    // 写地址通道
    input  logic [31:0] AWADDR,
    input  logic        AWVALID,
    output logic        AWREADY,

    // 写数据通道
    input  logic [31:0] WDATA,
    input  logic [3:0]  WSTRB,
    input  logic        WVALID,
    output logic        WREADY,

    // 写响应通道
    output logic [1:0]  BRESP,
    output logic        BVALID,
    input  logic        BREADY,

    // 读地址通道
    input  logic [31:0] ARADDR,
    input  logic        ARVALID,
    output logic        ARREADY,

    // 读数据通道
    output logic [31:0] RDATA,
    output logic [1:0]  RRESP,
    output logic        RVALID,
    input  logic        RREADY
);
    // 内部寄存器存储器 (256字)
    logic [31:0] mem [0:255];

    // 写地址、数据握手
    always_ff @(posedge ACLK or negedge ARESETn) begin
        if (!ARESETn) begin
            AWREADY <= 0;
            WREADY  <= 0;
            BVALID  <= 0;
        end else begin
            if (AWVALID && !AWREADY) AWREADY <= 1;
            else AWREADY <= 0;

            if (WVALID && !WREADY) begin
                WREADY <= 1;
                if (WSTRB[0]) mem[AWADDR[9:2]][7:0]   <= WDATA[7:0];
                if (WSTRB[1]) mem[AWADDR[9:2]][15:8]  <= WDATA[15:8];
                if (WSTRB[2]) mem[AWADDR[9:2]][23:16] <= WDATA[23:16];
                if (WSTRB[3]) mem[AWADDR[9:2]][31:24] <= WDATA[31:24];
                BVALID <= 1;
            end else begin
                WREADY <= 0;
            end

            if (BVALID && BREADY) BVALID <= 0;
        end
    end

    // 读地址、数据握手
    always_ff @(posedge ACLK or negedge ARESETn) begin
        if (!ARESETn) begin
            ARREADY <= 0;
            RVALID  <= 0;
        end else begin
            if (ARVALID && !ARREADY) begin
                ARREADY <= 1;
                RDATA   <= mem[ARADDR[9:2]];
                RVALID  <= 1;
            end else begin
                ARREADY <= 0;
            end

            if (RVALID && RREADY) RVALID <= 0;
        end
    end

    // 写响应
    assign BRESP = 2'b00; // OKAY
    assign RRESP = 2'b00; // OKAY
endmodule
