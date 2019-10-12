nodeset = csvread('nodes.csv');
edges=csvread('edges.csv');
%nodeset and edges are matrices into which we read data from csv file.
N = size(nodeset(:,1),1); % # of nodes
E = size(edges(:,1),1); % # of edges
past_cost(1) = 0;               % initializes past_cost as 0 and infinity
past_cost(2:N) = inf;
parent_node = zeros(1, N);       %we set parent node to 0 first
heuristic_ctg = nodeset(:,4)';   %heuristic cost to go is taken fron the 4th column of csv file
est_tot_cost = past_cost + heuristic_ctg; %the general formula
% we now create a matrix 'node' which is a table similar to that shown in
% the video.1st row has node number,the 2nd row has past cost and the other
% nodes are same as expected.
Node=[nodeset(:,1)';past_cost;heuristic_ctg;est_tot_cost;parent_node];
%now we create a matrix open which stores node number and est cost data
Open=[Node(1,1),Node(1,4)];
%the below for loop finds the neighbours of start node 1 and edits the past
%cost of each node as well as the est cost to go.
for i=1:E
    if edges(i,2)==1
        ngr=edges(i,1);% ngr stands for neighbour,this variable stores neighbour's node number
        Node(2,ngr)=past_cost(1)+edges(i,3);%editting past cost
        Node(4,ngr)=Node(2,ngr)+Node(3,ngr);%editting est cost to go
        Node(5,ngr)=1;                      %editting parent node number
        Open=[Open;Node(1,ngr),Node(4,ngr)]; % including the neighbour node in open list(matrix in this case)
        
     end
    
    
end
%now we create a matrix closed which also stores node number and past cost data
Closed=[Open(1,1),Open(1,2)];

Open(1,:)=[];  %removes the first row of open matrix i.e it removes the complete data of node from open!
Open= sortrows(Open,2); %sorts the rows of the matrix based on 2nd column which is cost to go,i.e the nodes are sorted based on est cost to go

%%
%now we generalize the above pattern
% In Open list, we identify 'current' as the 1st node in open
while isempty(Open) == false
    current=Open(1,1);
    %the below for loop modifies the neighbours data similar to the
    %previous for loop
    for i=1:E
        if edges(i,2)==current
            ngr=edges(i,1);
            if Node(2,ngr)>(edges(i,3)+Node(2,current))
                Node(2,ngr)=(edges(i,3)+Node(2,current));
                Node(4,ngr)=Node(2,ngr)+Node(3,ngr);
                Node(5,ngr)=current;
                %we now include the neighbour node in the open list
                Open=[Open;Node(1,ngr),Node(4,ngr)];
                
            end
        end
    end
    %after completing all the neighbour nodes, the initial node is put in
    %closed list and removed from open
    Closed=[Closed;Open(1,1),Open(1,2)];
    Open(1,:)=[];  %removes the first row i.e the 1st node of open
    Open= sortrows(Open,2); %sorts the rows of the matrix based on 2nd column which is cost to go,i.e the nodes are sorted based on est cost to go
end
% We can now generate path
Path=Node(1,N);% This means path has the element as node(1,N) which is equal to last node number 
temp=N;% A temporary variable
while Path(end)~=1
    Path=[Path,Node(5,temp)];% here we keep adding parent nodes to the Path matrix 
    temp=Node(5,temp);
    %this process is carried until we reach parent node as 1 which is start
    %node
   end
display(Path)
csvwrite('path.csv',Path);% writes Path matrix into a csv file










