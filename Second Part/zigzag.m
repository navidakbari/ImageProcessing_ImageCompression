function out = zigzag(in)

[row , col] = size(in);

out = zeros(1 , row * col);

cur_row = 1;
cur_col = 1;
cur_index = 1;

while cur_row <= row && cur_col <= col
	if cur_row == 1 && mod(cur_row + cur_col , 2 ) == 0 && cur_col ~= col
		out(cur_index) = in(cur_row,cur_col);
		cur_col = cur_col + 1;
		cur_index = cur_index + 1;
		
	elseif cur_row == row && mod(cur_row + cur_col , 2) ~= 0 && cur_col ~= col
		out(cur_index) = in(cur_row,cur_col);
		cur_col = cur_col + 1;							
		cur_index = cur_index + 1;
		
	elseif cur_col == 1 && mod(cur_row + cur_col,2) ~= 0 && cur_row ~= row
		out(cur_index) = in(cur_row,cur_col);
		cur_row = cur_row + 1;							
		cur_index = cur_index + 1;
		
	elseif cur_col == col && mod(cur_row + cur_col , 2) == 0 && cur_row ~= row
		out(cur_index) = in(cur_row,cur_col);
		cur_row = cur_row + 1;							
		cur_index = cur_index + 1;
		
	elseif cur_col ~= 1 && cur_row ~= row && mod(cur_row + cur_col,2) ~= 0
		out(cur_index) = in(cur_row,cur_col);
		cur_row = cur_row + 1;
        cur_col = cur_col - 1;	
		cur_index = cur_index + 1;
		
	elseif cur_row ~= 1 && cur_col ~= col && mod(cur_row + cur_col,2) == 0
		out(cur_index) = in(cur_row,cur_col);
		cur_row = cur_row - 1;		
        cur_col = cur_col + 1;	
		cur_index = cur_index + 1;
		
	elseif cur_row == row && cur_col == col	
        out(end) = in(end);							
		break									
    end
end