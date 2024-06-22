task WaitNS;
  input [31:0] delay;
    begin
        #(1000*delay);
    end
endtask

task WaitPS;
  input [31:0] delay;
    begin
        #(delay);
    end
endtask


//---
// Task to send a single packet

task TxPacket;
  integer        i;
    begin

        $display("Transmit packet with length: %d", tx_length);

        @(posedge clk_156m25);
        WaitNS(1);
        pkt_tx_val = 1'b1;

        for (i = 0; i < tx_length; i = i + 8) begin

            pkt_tx_sop = 1'b0;
            pkt_tx_eop = 1'b0;
            pkt_tx_mod = 2'b0;

            if (i == 0) pkt_tx_sop = 1'b1;

            if (i + 8 >= tx_length) begin
                pkt_tx_eop = 1'b1;
                pkt_tx_mod = tx_length % 8;
            end

            pkt_tx_data[`LANE7] = tx_buffer[i];
            pkt_tx_data[`LANE6] = tx_buffer[i+1];
            pkt_tx_data[`LANE5] = tx_buffer[i+2];
            pkt_tx_data[`LANE4] = tx_buffer[i+3];
            pkt_tx_data[`LANE3] = tx_buffer[i+4];
            pkt_tx_data[`LANE2] = tx_buffer[i+5];
            pkt_tx_data[`LANE1] = tx_buffer[i+6];
            pkt_tx_data[`LANE0] = tx_buffer[i+7];

            @(posedge clk_156m25);
            WaitNS(1);

        end

        pkt_tx_val = 1'b0;
        pkt_tx_eop = 1'b0;
        pkt_tx_mod = 3'b0;

        tx_count = tx_count + 1;

    end

endtask


//---
// Task to read a single packet from command file and transmit

task CmdTxPacket;
  input [31:0] file;
  integer count;
  integer data;
  integer i;
    begin

        count = $fscanf(file, "%2d", tx_length);

        if (count == 1) begin

            for (i = 0; i < tx_length; i = i + 1) begin

                count = $fscanf(file, "%2X", data);
                if (count) begin
                    tx_buffer[i] = data;
                end

            end

            TxPacket();

        end
    end

endtask


//---
// Task to read commands from file and stop when complete

task ProcessCmdFile;
  integer    file_cmd;
  integer  count;
  reg [8*8-1:0] str;
    begin

        file_cmd = $fopen("../../testbench/verilog/packets_tx.txt", "r");
        if (!file_cmd) $stop;

        while (!$feof(file_cmd)) begin

            count = $fscanf(file_cmd, "%s", str);
            if (count != 1) continue;

            $display("CMD %s", str);

            case (str)

              "SEND_PKT":
                begin
                    CmdTxPacket(file_cmd);
                end

            endcase

        end

        $fclose(file_cmd);

        WaitNS(50000);
        //$stop;
        $finish;

    end
endtask


//---
// Task to read a single packet from receive interface and display

task RxPacket;
  reg done;
    begin

        done = 0;

        pkt_rx_ren <= 1'b1;
        @(posedge clk_156m25);

        while (!done) begin

            if (pkt_rx_val) begin

                if (pkt_rx_sop) begin
                    $display("\n\n------------------------");
                    $display("Received Packet");
                    $display("------------------------");
                end

                $display("%x", pkt_rx_data);

                if (pkt_rx_eop) begin
                    done <= 1;
                    pkt_rx_ren <= 1'b0;
                end

                if (pkt_rx_eop) begin
                    $display("------------------------\n\n");
                end

            end

            @(posedge clk_156m25);

        end

        rx_count = rx_count + 1;

    end
endtask