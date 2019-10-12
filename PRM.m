%PRM code
%Let R be the matrix consisting node number,it's coordinates in x and y
function [edges,nodes,path]=PRM(obstacles)
obstacles=csvread('obstacles.csv');%obstacles is now a matrix 
R=[1,-0.5,-0.5];
for i=2:25 %In this for loop we use rand function which gives random numbers between 0 and 1   
a = -0.50;
b = 0.50;   %By assigning a and b,
R = [R;i,(b-a).*rand(1,1) + a,(b-a).*rand(1,1) + a];%  we get values between a and b by using the rand function 
end
R=[R;26,0.5,0.5];
E=zeros(26,1);
for i=1:26 
x = [R(i,2) R(i,3)];
y = [0.5 0.5];
E(i,1)= norm(x-y); % From this for loop,we get the euclidean distance between the node and goal configuration
end
Nodelist=[R,E];% since cost to go is equal to euclidean,we concatinate,i.e attach the matrix E with the R matrix creating nodelist matrix
disp(Nodelist) %Nodelist matrix has node number,thier coordinates and the cost to go 
[D,I] = pdist2(R(:,(2:3)),R(:,(2:3)),'euclidean','Smallest',6);
%this function calculates for each node,the 6 nearest nodes and their
%node number in ascending order. But for each node,the node itself is
%counted, so it must be removed.
D(1,:)=[];%the first row of D matrix which has distances is removed
I(1,:)=[];%the first row of I matrix which has node number is removed
Edge=zeros(130,3);%initialing the Edge matrix
%next we use intersect function which returns a value 1,if a line segment
%intersects the circles given or else 0
%the below for loop,gives edge points and edge length.But if the edge is in
%collision with one of the obstacles,the row becomes a zero row
intersect(obstacles);
for i=1:26
  
  if intersect(R(i,2:3),R(I(1,i),2:3))==1
      continue
  else
      Edge(i,2)=i;
      Edge(i,1)=I(1,i);
      Edge(i,3)=D(1,i);
  end
end
for j=1:26
    
    if intersect(R(j,2:3),R(I(2,j),2:3))==1
      continue
  else
      Edge(j+26,2)=j;
      Edge(j+26,1)=I(2,j);
      Edge(j+26,3)=D(2,j);
   end
end
for k=1:26
    
    if intersect(R(k,2:3),R(I(2,k),2:3))==1
      continue
  else
      Edge(k+52,2)=k;
      Edge(k+52,1)=I(3,k);
      Edge(k+52,3)=D(3,k);
   end
end
for k=1:26
 if intersect(R(k,2:3),R(I(2,k),2:3))==1
      continue
  else
      Edge(k+78,2)=k;
      Edge(k+78,1)=I(4,k);
      Edge(k+78,3)=D(4,k);
   end
end
for k=1:26
 if intersect(R(k,2:3),R(I(2,k),2:3))==1
      continue
  else
      Edge(k+104,2)=k;
      Edge(k+104,1)=I(5,k);
      Edge(k+104,3)=D(5,k);
   end
end

Q=zeros(1,3);
 %Now we need to remove the zero row matrices, so we make a for loop,to
 %detect and then remove the rows.
for k=129:-1:1
    if Edge(k,:)==Q
        Edge(k,:)=[];
    end
end
disp(Edge)
%Our Edge matrix is ready!We write it a csv file.
csvwrite('edges.csv',Edge);
csvwrite('nodes.csv',Nodelist);
%the Astar_code which I created for last week assignment is used to find
%the most economical path.
Astar_code(nodes,edges)
end
%Thank you




    
    

    
            