//ATP controller first step verilog code for FSM
//Done by Team estherosis
`define true 1'b1
`define false 1'b0

`define FIND 1'b0
`define AUTHENTICATE 1'b1

`define INPUT METHOD             3'b000
`define VALIDATE CUSTOMER        3'b001
`define BILL PAYMENT             3'b010
`define CHARGES                  3'b011
`define PAYMENT METHOD           3'b100
`define OLD BALANCE              3'b101
`define TRANSACTION              3'b110
`define RECEIPT                  3'b111

module atp_tb();
  
  reg clk, exit;
  reg [11:0] phone number;
  reg [3:0] consumer number;
  reg [11:0] destinationconsumer number;
  reg [2:0] display bill amount;
  reg [10:0] amount;
  wire error;
  wire [10:0] Charges;
  
  ATP atpModule(clk, exit, phone number, consumer number, destinationconsumer number, display bill payment, amount, error, charges);
  
  
  initial begin
    clk = 1'b0;
  end
  
   always @(error) begin
      if(error == `true)
        $display("Error!, action causes an invalid operation.");
   end
  
  initial begin
	module authorization(auth,check,checkhash);
    input [7:0] auth;
    input [7:0] checkhash;
    output reg check;
    always @(*)
    begin
    // Simple logic of hash-match or not
    if(auth==checkhash) 
	    check=1;
    else
	    check=0;
    end 
endmodule
//bio-metrics scanner to undergo as barcode scanner is under process
module test;
    wire check;
    reg [0:7]auth;
    reg [0:7]checkhash;
    authorization authen(auth,check,checkhash);
    initial
    begin
    $dumpfile("vcd/BiometricsImplement.vcd");
    $dumpvars(0,test);
    $display("Bytes \t Checker");
    $monitor("%b %b",auth,check);

    checkhash=8'b11101101;
    auth=8'b10010110;
    #10 auth=8'b10110010;
    #10 auth=8'b11101101;
    $finish;
    end
endmodule

    //incorrect PIN
    phone number = 12'd2278;
    barcode scanner = 4'b0100;
    
    #30

    //valid credentials
    phone number = 12'd2178;
    bar code scanner = 4'b0100;
    
    #30
    
    amount = 100;
	display bill amount = `balance';
    clk = ~clk;#5clk = ~clk;
    #30

    //show the balance
	display bill amount = `CHARGES';
    clk = ~clk;#5clk = ~clk;
    #30
    
    //withdraw too much money, resulting in an error
    amount = 2500;
	display bill amount = `payment method';
    clk = ~clk;#5clk = ~clk;
    #30

        payment method = 'cash';
    clk = ~clk;#5clk = ~clk;
    #30
    
       payment method = 'check/dd';
    clk = ~clk;#5clk = ~clk;
    #30
    
    $display("cash")
    $display("cheque/dd")
    if(cash==true)
      input wire = cash;
    else(cheque/dd)
      input wire = cheque/dd;
    

   
	display bill amount  = `BALANCE;
    clk = ~clk;#5clk = ~clk;
    #30



    amount = 50;
    destinationconsumer number = 2816;
	display bill amount = `TRANSACTION;
    clk = ~clk;#5clk = ~clk;
    #30

    amount = 2550;
    destinationconsumer number = 2816;
	display bill amount = `TRANSACTION;
    clk = ~clk;#5clk = ~clk;
    #30
    

    //exit the system
    exit = 1;
    #30
    exit = 0;
    #30
    
 
    customer number = 12'd2816;
    pin = 4'b0110;
    #30

   	display bill number = 'CHARGES';
   clk = ~clk;#5clk = ~clk;
   #30
  
    
  end
  
endmodule
