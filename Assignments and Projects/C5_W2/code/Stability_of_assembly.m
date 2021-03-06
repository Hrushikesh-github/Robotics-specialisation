M = csvread('mass.csv');
C = csvread('contacts.csv');
% M is a matrix with 1st column having weight in kg,2nd and 3rd columns
% have x,y coordinates of the centre of mass respectively
% In the C matrix, 1st and 2nd columns represent the bodies which are in contact,
% 3rd,4th column has x,y coordinates of contact location and the 5th column 
%has angle made by inward normal with positive x the angle ranges from 0 to 2*pi.
%6th column has coefficient of friction
[a,b]=size(M);
%a gives the number of bodies present
[n,m]=size(C);
%n gives the number of contacts.
WC=ones(5,1);
%the below for loop evaluates WC matrix, wrench cone matrix for all
%contacts, so wrench cone matrix has number of columns as 2*n+1, here +1 as
%we initialzed first column, we will eventually delete it though.
for i=1:n
        N=[cos(C(i,5));sin(C(i,5))];
        f=[C(i,6)*sin(C(i,5));C(i,6)*-cos(C(i,5))];
        R=N+f;
        F1=[C(i,1);C(i,2);(C(i,3)*R(2,1))-(C(i,4)*R(1,1));R(1,1);R(2,1)];
        R=N-f;
        F2=[C(i,1);C(i,2);(C(i,3)*R(2,1))-(C(i,4)*R(1,1));R(1,1);R(2,1)];
        WC=[WC,F1,F2];
end
%F is a cell, where each element in cell contains the wrench cone edges.
F=cell(a,2*n);
F(:) = {zeros(3,1)};%initializing wrench cone edges.
WC(:,1)=[];%the first column of WC matrix which was temporarily used is removed
%The below for loop fills the F cell. F cell is filled with the wrench cone
%edges in a such a way that the later calculation to find k will be done easily 
for(j=1:n)
   for i=1:2*n     
        if WC(1,i)==j
            F{j,i}=(WC([3,4,5],i));
            if WC(2,i)~=0
            F{WC(2,i),i}=-1*F{j,i};
            end
        end
   end
end
%E is the Force_external acting on the bodies.The first three rows has
%External forces on 1st body,the next three rows for the 2nd body, so on...
E=zeros(3,1);
for i=1:a
    X=[M(i,2)*M(i,1)*9.81;0;M(i,1)*9.81];
    E=[E;X];
end
E([1,2,3],:) = [];%We remove the 1st three rows used to initialize E matrix
T=cell2mat(F);%T matrix is matrix representation of F cell.It is used to calculate k
b=zeros(2*n,1);
A=-1*eye(2*n);%A,b matrices for necessary to ensure all the elements of k are positive.
k=T\E;%Evaluating k
if A*k<=b
    disp('solution exists');
    display(k)
else 
    disp('solution does not exist');
end
    
        



