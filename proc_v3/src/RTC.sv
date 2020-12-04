module RTC(rtc_on, clk, resetn, operation, w_data, r_data, alarm_intrpt);

input rtc_on; //only do operations if this is on
input clk; //1 Hz clock
input resetn; //active Low
input [1:0] operation; //00=read, 01=write, 10=alarm, 11=add/sub time 
input [31:0] w_data; 
output logic [31:0] r_data;
output logic alarm_intrpt; //1 = alarm going off, 0 = otherwise

//alarm registers
logic [31:0] alarm1 ;
logic [31:0] alarm2 ;
logic [31:0] alarm3 ;
logic [31:0] alarm4 ;
logic [2:0] alarm_count; //which alarm is next up to be filled
logic alarm_logic; //If high, output an interrupt

//add/sub vars
logic [5:0] sec_add ;
logic [5:0] min_add ;
logic [4:0] hr_add ;
logic [8:0] day_add ;
logic add;

logic sec_add_inc ;// used to add a implement carrying for adding
logic min_add_inc ;// or borrowing for subtraction (inc = increment)
logic hr_add_inc ;
logic day_add_inc ;
/*
logic [5:0] sec_add_tmp ;
logic [5:0] min_add_tmp ;
logic [4:0] hr_add_tmp ;
logic [8:0] day_add_tmp ;
logic add_tmp ;
*/

//current time registers
logic [31:0] sec;
logic [31:0] min;
logic [31:0] hr;
logic [31:0] day;
logic [31:0] yr;
logic [31:0] curr_time;

//assignments
assign curr_time = {sec[5:0], min[5:0], hr[4:0], day[8:0], yr[5:0]}; //current time as one 32-bit word
assign alarm_intrpt = (alarm1[31:14] == {curr_time[31:15], 1'b1}) | (alarm2[31:14] == {curr_time[31:15], 1'b1}) | (alarm3[31:14] == {curr_time[31:15], 1'b1}) | (alarm4[31:14] == {curr_time[31:15], 1'b1});
    //logic to determine whether or not to send an interrupt
assign sec_add = w_data[31:26];
assign min_add = w_data[25:20];
assign hr_add = w_data[19:15];
assign day_add = w_data[14:6];
assign add = w_data[5];



//Time Changes
always @ (posedge clk) 
begin
    //Reset
    if(resetn == 1'b0)
    begin
        sec <= 0;
        min <= 0;
        hr <= 0;
        day <= 0;
        yr <= 0;
    end //reset

    //Write
    else if(rtc_on == 1'b1 && operation == 2'b01)
    begin
        sec <= {26'b0, w_data[31:26]};
        min <= {26'b0, w_data[25:20]};
        hr <= {27'b0, w_data[19:15]};
        day <= {23'b0, w_data[14:6]};
        yr <= {27'b0, w_data[5:0]};
    end //write
    
    //Add/Sub Time TEST WITH NO DELAY
    else if(rtc_on == 1'b1 && operation == 2'b11)
    begin
        sec_add_inc = 1'b0;
        min_add_inc = 1'b0;
        hr_add_inc = 1'b0;
        day_add_inc = 1'b0;

        //add
        if(add == 1'b1) begin
            //add sec
            if(sec+sec_add >= 6'd60)begin
                sec = sec + sec_add - 6'd60;
                min_add_inc = 1'b1; 
            end else begin
                sec = sec+sec_add;
            end
            //add min
            if(min+min_add+min_add_inc >= 6'd60)begin
                min = min + min_add + min_add_inc - 6'd60;
                hr_add_inc = 1'b1;
            end else begin
                min = min + min_add + min_add_inc;
            end
            //add hr
            if(hr+hr_add+hr_add_inc >= 5'd24)begin
                hr = hr + hr_add + hr_add_inc - 5'd24;
                day_add_inc =  1'b1;
            end else begin
                hr = hr + hr_add + hr_add_inc;
            end
            //add day
            if(day+day_add+day_add_inc >= 9'd365)begin
                day = day + day_add + day_add_inc - 365;
                yr = yr + 1'b1;
            end else begin
                day = day + day_add + day_add_inc;
            end
        end //end add block

        //subtract (and it hasnt been done yet)
        else if(add == 1'b0) begin
            //sub sec
            if(sec_add > sec)begin
                sec = sec + 32'd60 - sec_add;
                min_add_inc = 1'b1; 
            end else begin
                sec = sec - sec_add;
            end
            //sub min
            if(min_add > min)begin
                min = min + 32'd60 - min_add - min_add_inc;
                hr_add_inc =  1'b1;
            end else begin
                min = min - min_add - min_add_inc;
            end
            //sub hr
            if(hr_add > hr)begin
                hr = hr + 32'd24 - hr_add - hr_add_inc ;
                day_add_inc =  1'b1;
            end else begin
                hr = hr - hr_add - hr_add_inc;
            end
            //sub day
            if(day_add > day)begin
                day = day + 32'd365 - day_add - day_add_inc;
                yr = yr-1'b1;
            end else begin
                day = day - day_add - day_add_inc;
            end
        end //end of subtract block

        //if add/sub has already been completed - do nothing?
        else begin
            $display("couldn't add) ");
        end
    end //add/sub
    
    //Increment
    else 
    begin
        if(sec == 6'd59) begin
            sec <= 6'b000000;
            //increment min
            if(min == 6'd59) begin
                min <= 6'b000000;
                //increment hr
                if(hr == 5'd23) begin
                    hr <= 5'b0;
                    //increment day
                    if(day == 9'd364) begin
                        day <= 9'd0;
                        yr <= yr+1;
                    end else begin
                        day <= day + 1;
                    end      
                end else begin
                    hr <= hr + 1;
                end       
            end else begin
                min <= min + 1;
            end   
        end else begin
            sec <= sec + 1;
        end
    end //increment

end //end always (time)

//R_Data Changes 
always_comb 
begin
    //Read
    if(rtc_on == 1'b1 && operation == 2'b00)
    begin
        r_data[31:26] = sec;
        r_data[25:20] = min;
        r_data[19:15] = hr;
        r_data[14:6] = day;
        r_data[5:0] = yr;  
    end else 
        r_data = 0;
end //end always (r_data)

//Alarm Changes
always @ (posedge clk) 
begin
    //reset
    if(resetn == 1'b0)
    begin
        //alarm_intrpt <= 0;
        alarm_count <= 0;
        alarm1 <= 0;
        alarm2 <= 0;
        alarm3 <= 0;
        alarm4 <= 0; 
    end
    //add assignment to look neater
    //Add Alarm
    if(rtc_on == 1'b1 && operation == 2'b10)
    begin
        if(alarm_count == 3'b00)
        begin
            alarm1 <= w_data;
            alarm1[14] <= 1;
            alarm_count <= 3'b01;
        end else if(alarm_count == 3'b01 && alarm1[31:14] != {w_data[31:15], 1'b1})
        begin
            alarm2 <= w_data;
            alarm2[14] <= 1;
            alarm_count <= 3'b10;
        end else if(alarm_count == 3'b10 && alarm1[31:14] != {w_data[31:15], 1'b1} && alarm2[31:14] != {w_data[31:15], 1'b1})
        begin
            alarm3 <= w_data;
            alarm3[14] <= 1;
            alarm_count <= 3'b11;
        end else if(alarm_count == 3'b11 && alarm1[31:14] != {w_data[31:15], 1'b1} && alarm2[31:14] != {w_data[31:15], 1'b1}&& alarm3[31:14] != {w_data[31:15], 1'b1})
        begin
            alarm4 <= w_data;
            alarm4[14] <= 1;
            alarm_count <= 3'b111;
        end else
        begin
            $display("not enough alarm regs");
        end
    end
end //end always (alarm)


endmodule


