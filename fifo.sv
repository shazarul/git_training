//-------------------------------------------------
//      Design      : FIFO
//      Designer    : shazarul.islam@siliconova.com
//      company     : Siliconova
//
//      Version     : 1.1
//      Created     : 1 May, 2024
//      Last updated: 3 May, 2024   
//--------------------------------------------------

`define dataWidth 32
`define DEPTH 32

class FIFO;
  
  // signals
  bit clk, rst_n;                                             // Global signals
  bit push, pop;                                              // Control signals
  bit empty, full, err;                                       // Flags signals
  logic [`dataWidth -1:0] data_in;                            // Data input signals
  logic [`dataWidth -1:0] data_out;                           // Data output signals


  logic [`dataWidth:0] fifo [$:`DEPTH];                       // Declaring fifo queue 

  // Task to write data into the FIFO
  task push_data(input logic [`dataWidth:0] data_in);
    if (push && !(fifo.size() == `DEPTH)) begin               // wr enabel and fifo is not full          
      fifo.push_back(data_in);
      empty = 0;
      err = 0;                                                // No error when pushing data
    end
    else begin
      err = 1;                                                // Error when attempting to push data into a full FIFO
      full =1;
    end
  endtask

  // Task to pop data from the FIFO
  task pop_data(output logic [`dataWidth:0] data_out);
    if (pop && !(fifo.size() == 0)) begin                    // rd enable and fifo is not empty
      data_out = fifo.pop_front();
      err = 0;                                               // No error when popping data
      full =0; 
    end
    else begin  
      err = 1;                                               // Error when attempting to pop data from an empty FIFO
      empty = 1;
    end
  endtask

endclass

//............................................................................//

module tb();
 // bit clk;
  FIFO f;
  logic [31:0] out;

//   initial clk = 0;
//   always #5 clk = ~clk;

  initial begin
    f =new ();
    // Write data to FIFO
    //@(posedge clk);
    f.push = 1;
    repeat(`DEPTH)begin
      f.push_data($urandom);
    end
    $display("Fifo write = %p",f.fifo);
    f.push = 0;
    f.pop = 1;
    repeat(`DEPTH)begin
      f.pop_data(out);
      $display("Fifo read = %h",out);
    end
    $display("Fifo = %p",f.fifo);
    
    //$finish;
  end

//   initial begin
//     $dumpfile("dump.vcd"); $dumpvars;
//   end

endmodule

//..............................................................................//
