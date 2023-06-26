
`define true 1'b1
`define false 1'b0

`define FIND 1'b0
`define AUTHENTICATE 1'b1

`define INPUT METHOD              3'b000
`define BILL PAYMENT                  3'b010
`define CHARGES               3'b011
`define PAYMENT METHOD              3'b100
`define OLD BALANCE 3'b101
`define TRANSACTION           3'b110


module authentication(
  input [11:0] phone number,
  input [3:0] customer validation,
  input [3:0] receipt,
  input action,
  input deAuth,
  output reg  wasSuccessful,
  output reg [3:0] accIndex
);


  reg [11:0] phone_number [0:9];
  reg [3:0] customer_number [0:9];

  //initializing the database with arbitrary accounts
  initial begin
    phone_number[0] = 12'd2749; customer_number[0] = 4'b0000;
    phone_number[1] = 12'd2175; customer_number[1] = 4'b0001;
    phone_number[2] = 12'd2429; customer_number[2] = 4'b0010;
    phone_number[3] = 12'd2125; customer_number[3] = 4'b0011;
    phone_number[4] = 12'd2178; customer_number[4] = 4'b0100;
    phone_number[5] = 12'd2647; customer_number[5] = 4'b0101;
    phone_number[6] = 12'd2816; customer_number[6] = 4'b0110;
    phone_number[7] = 12'd2910; customer_number[7] = 4'b0111;
    phone_number[8] = 12'd2299; customer_number[8] = 4'b1000;
    phone_number[9] = 12'd2689; customer_number[9] = 4'b1001;
    end

  always @ (deAuth) begin
    if(deAuth == `true)
      wasSuccessful = 1'bx;
  end
  //looping through the database, trying to find a match for the given accNumber and pin
  // if action is set to find then it'll simply ry to find a match for the given accNumber and returns its index
  integer i;
  always @(phone_number or cuastomer_number) begin
      wasSuccessful = `false;
      accIndex = 0;

      //loop through the data base
      for(i = 0; i < 10; i = i+1) begin

          //found a match for accNumber
          if(accNumber == acc_database[i]) begin
              
              if(action == `FIND) begin
                wasSuccessful = `true;
                accIndex = i;
              end

              if(action == `AUTHENTICATE) begin
                if(pin == pin_database[i]) begin
                  wasSuccessful = `true;
                  accIndex = i;

                end
              end
          end    
      end
  end

endmodule

//

module ATM(
  input clk,
  input exit,
  input [11:0] accNumber,
  input [3:0] pin,
  input [11:0] destinationAcc, 
  input [2:0]menuOption,
  input [10:0] amount, 
  output reg error,
  output reg [10:0] balance
  );


  //initializing the balance database with an arbitrary amount of money
  reg [15:0] balance_database [0:9];
  initial begin
    $display("Welcome to the ATM");
     balance_database[0] = 16'd500;
     balance_database[1] = 16'd500;
     balance_database[2] = 16'd500;
     balance_database[3] = 16'd500;
     balance_database[4] = 16'd500;
     balance_database[5] = 16'd500;
     balance_database[6] = 16'd500;
     balance_database[7] = 16'd500;
     balance_database[8] = 16'd500;
     balance_database[9] = 16'd500;

  end
  
  reg [2:0] currState = `WAITING;
  
  wire [3:0] accIndex;
  wire [3:0] destinationAccIndex;
  wire isAuthenticated;
  wire wasFound;
  
  reg deAuth = `false;

  authentication authAccNumberModule(accNumber, pin, `AUTHENTICATE, deAuth, isAuthenticated, accIndex);
  authentication findAccNumberModule(destinationAcc, 0, `FIND, deAuth, wasFound, destinationAccIndex);

  //main block of module with asynchronous exit
  always @(posedge clk or isAuthenticated or menuOption or exit) begin
    
    //restart the error
	error = `false;
    if(exit == `true) begin
      //transition to the waiting state
      currState = `WAITING;
      //deathenticate the current user
      deAuth = `true;
      #20;      
    end
    
    if(currState == `MENU) begin
      //set the selected option as the current state
      if((menuOption >= 0) & (menuOption <= 7))begin 
        currState = menuOption;
      end else
      currState = menuOption;
    end
    

    //switch case for the menu options
    //the rest is pretty straight forward
      case (currState)


      `WAITING: begin
        if (isAuthenticated == `true) begin
          currState = `MENU;
          $display("Logged In.");
        end
        else if(isAuthenticated == `false) begin
          $display("phone number or password was incorrect");
          currState = `WAITING;
        end
      end


      `BALANCE: begin
        balance = balance_database[accIndex];
        $display("Account %d has balance %d", accNumber, balance_database[accIndex]);
        currState = `MENU;
      end


      `WITHDRAW: begin
          if (amount <= balance_database[accIndex]) begin
            balance_database[accIndex] = balance_database[accIndex] - amount;
            balance = balance_database[accIndex];
            currState = `MENU;
            error = `false;
          end
          else begin
            currState = `MENU;
            error = `true;
          end
      end


      `WITHDRAW_SHOW_BALANCE: begin
          if (amount <= balance_database[accIndex]) begin
            balance_database[accIndex] = balance_database[accIndex] - amount;
            balance = balance_database[accIndex];
            currState = `MENU;
            error = `false;
            $display("Account %d has balance %d after withdrawing %d", accNumber, balance_database[accIndex], amount);
          end
          else begin
            currState = `MENU;
            error = `true;
          end
      end


      `TRANSACTION: begin
        if ((amount <= balance_database[accIndex]) & (wasFound == `true) & (balance_database[accIndex] + amount < 2048)) begin
            currState = `MENU;
            error = `false;
            balance_database[destinationAccIndex] = balance_database[destinationAccIndex] + amount;
            balance_database[accIndex] = balance_database[accIndex] - amount;
            $display("Destination account %d after transaction has a total balance of %d", destinationAcc, balance_database[destinationAccIndex]);
        end
        else begin
            currState = `MENU;
            error = `true;
        end
      end

    endcase 
		

  end

endmodule
