function out=invzigzag(in,num_rows,num_cols)

tot_elem=length(in);

if nargin>3
	error('Too many input arguments');
elseif nargin<3
	error('Too few input arguments');
end

% Check if matrix dimensions correspond
if tot_elem~=num_rows*num_cols
	error('Matrix dimensions do not coincide');
end


% Initialise the output matrix
out=zeros(num_rows,num_cols);

cur_row=1;	cur_col=1;	cur_index=1;

% First element
%out(1,1)=in(1);

while cur_index<=tot_elem
	if cur_row==1 & mod(cur_row+cur_col,2)==0 & cur_col~=num_cols
		out(cur_row,cur_col)=in(cur_index);
		cur_col=cur_col+1;							%move right at the top
		cur_index=cur_index+1;
		
	elseif cur_row==num_rows & mod(cur_row+cur_col,2)~=0 & cur_col~=num_cols
		out(cur_row,cur_col)=in(cur_index);
		cur_col=cur_col+1;							%move right at the bottom
		cur_index=cur_index+1;
		
	elseif cur_col==1 & mod(cur_row+cur_col,2)~=0 & cur_row~=num_rows
		out(cur_row,cur_col)=in(cur_index);
		cur_row=cur_row+1;							%move down at the left
		cur_index=cur_index+1;
		
	elseif cur_col==num_cols & mod(cur_row+cur_col,2)==0 & cur_row~=num_rows
		out(cur_row,cur_col)=in(cur_index);
		cur_row=cur_row+1;							%move down at the right
		cur_index=cur_index+1;
		
	elseif cur_col~=1 & cur_row~=num_rows & mod(cur_row+cur_col,2)~=0
		out(cur_row,cur_col)=in(cur_index);
		cur_row=cur_row+1;		cur_col=cur_col-1;	%move diagonally left down
		cur_index=cur_index+1;
		
	elseif cur_row~=1 & cur_col~=num_cols & mod(cur_row+cur_col,2)==0
		out(cur_row,cur_col)=in(cur_index);
		cur_row=cur_row-1;		cur_col=cur_col+1;	%move diagonally right up
		cur_index=cur_index+1;
		
	elseif cur_index==tot_elem						%input the bottom right element
        out(end)=in(end);							%end of the operation
		break										%terminate the operation
    end
end