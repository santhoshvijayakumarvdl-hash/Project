module AXI4MM_READ 
  #(parameter DATA_SIZE=32,//BITS EACH TR
              BURST_SIZE=8,//ONE BYTE TRANS
              BURST_LENGTH=DATA_SIZE/BURST_SIZE,
              MEMORY_STORAGE=20//1MB STORAGE
                     )
  ( 
    output reg arvalid,
    input arready,//arlock,arcache,arprot,
    output reg [$clog2(BURST_LENGTH)-1:0]arid,
    output reg  [MEMORY_STORAGE-1:0] araddr,
    output reg  [$clog2(BURST_LENGTH)-1:0]arlen,
    output reg  [$clog2(BURST_SIZE)-1:0]arsize,
    output reg  [1:0] arburst,//fixed,increment,wrap,reserved
    input  [DATA_SIZE-1:0] rdata,
    

    
    output reg   rlast,rvalid,                    
    input  aclk,aresetn,
    output [$clog2(BURST_LENGTH)-1:0]rid,
    input [2:0] rresp,
    input rready);
  
  
reg state,nextstate;
  reg done;
  reg[(($clog2(BURST_LENGTH))+(BURST_SIZE))-1:0] rdata_id;
// first 2 BIT ID AND NEXT  8 BIT DATA 
  reg[$clog2(BURST_LENGTH)-1:0] burst_counter;
    
  localparam[2:0] IDLE=0,SEND_ADDRESS=1,WRITE_DATA=2,CHECK=3,DONE=4;
  
  
  always@(posedge aclk or  negedge aresetn) begin
    
    if(!aresetn) state<=0;
  	else state<=nextstate;
  end
  
  always @(posedge aclk or negedge aresetn) begin
    if (!aresetn)
        burst_counter <= 0;
    else if (state == WRITE_DATA) begin
        if (burst_counter == BURST_LENGTH-1) begin
            burst_counter <= 0;
      		araddr<=0;end
      		// reset after last beat
        else
            burst_counter <= burst_counter + 1;
      		araddr<=araddr+1;
    end
    else if (state != WRITE_DATA)
        burst_counter <= 0;
    	araddr<=0;
end
  
  
  always@(*) begin
    case(state)
      
IDLE:begin
arlen  = BURST_LENGTH;
arsize = BURST_SIZE;
arburst = 3'b001; // incremental
arid   = 0;
rlast  = 0;


end
SEND_ADDRESS:
  if(arready) begin
      	nextstate<=WRITE_DATA;
      	end
     else nextstate<=IDLE;
      
WRITE_DATA:
  if(rvalid&&rready) begin
        if (burst_counter < BURST_LENGTH-1)begin
          rdata_id = {burst_counter, rdata[BURST_SIZE*burst_counter +: BURST_SIZE]};
      	  rlast<=0;
      	  nextstate<=SEND_ADDRESS;end
         else
           nextstate<=CHECK;end

CHECK:begin
  if(rresp==1) 
          	nextstate<=DONE;
       else
         	nextstate<=IDLE;
         	          end
         	         
DONE:begin
      done<=1;
      nextstate=IDLE;
    end      
endcase
end
      endmodule
