module AXI4MM_write 
  #(parameter DATA_SIZE=32,//BITS EACH TR
              BURST_SIZE=8,//ONE BYTE TRANS
              BURST_LENGTH=DATA_SIZE/BURST_SIZE,
              MEMORY_STORAGE=20//1MB STORAGE
                     )
  ( 
    output reg awvalid,
    input awready,//awlock,awcache,awprot,
    output reg [$clog2(BURST_LENGTH)-1:0]awid,
    output reg  [MEMORY_STORAGE-1:0] awaddr,
    output reg  [$clog2(BURST_LENGTH)-1:0]awlen,
    output reg  [$clog2(BURST_SIZE)-1:0]awsize,
    output reg  [1:0] awburst,//fixed,increment,wrap,reserved
    input  [DATA_SIZE-1:0] wdata,
    

    output reg  [BURST_LENGTH-1:0] wstrb,
    output reg   wlast,wvalid,wready,                    
    input  aclk,aresetn,
    output [$clog2(BURST_LENGTH)-1:0]bid,
    input [2:0] bresp,
    output reg bvalid,
    input bready);
  
  
reg state,nextstate;
  reg done;
  reg[(($clog2(BURST_LENGTH))+(BURST_SIZE))-1:0] wdata_id;
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
    else if (state == WRITE_DATA && wvalid && wready) begin
        if (burst_counter == BURST_LENGTH-1) begin
            burst_counter <= 0;
      		awaddr<=0;end
      		// reset after last beat
        else
            burst_counter <= burst_counter + 1;
      		awaddr<=awaddr+1;
    end
    else if (state != WRITE_DATA)
        burst_counter <= 0;
    	awaddr<=0;
end
  
  
  always@(*) begin
    case(state)
      
IDLE:begin
awlen  = BURST_LENGTH;
awsize = BURST_SIZE;
awburst = 3'b001; // incremental
awid   = 0;
wlast  = 0;
wvalid = 0;

end
SEND_ADDRESS:
    if(awready) begin
      	nextstate<=WRITE_DATA;
      	awaddr<=awaddr+1;end
     else nextstate<=IDLE;
      
WRITE_DATA:
      if(wready&&wvalid)begin
        if (burst_counter < BURST_LENGTH-1)begin
          wdata_id = {burst_counter, wdata[BURST_SIZE*burst_counter +: BURST_SIZE]};
          wstrb[burst_counter]<=1;
      	  wlast<=0;
      	  nextstate<=SEND_ADDRESS;end
         else
           nextstate<=CHECK;end

CHECK:begin
      if(bvalid&&bready)begin
        if(bresp==1) 
          	nextstate<=DONE;
       else
         	nextstate<=IDLE;
         	          end
         	          end
DONE:begin
      done<=1;
      nextstate=IDLE;
    end      
endcase
end
      endmodule
           
           
           
    
      
      
   
  
  
  
  
  
    
  
  
  
  
  
  
  
  

