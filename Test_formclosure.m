function [form]= Test_formclosure(D)
% D is 4*3 matrix with 1st column having x coordinate value,2nd with that
% of y and the last column has angle made by inward normal with positive x
%the angle ranges from -pi to pi.
F=ones(3,4);%initializing F matrix
%Now we define f,b,A same as example 12.7
f=[1,1,1,1];
b = [-1,-1,-1,-1];
A=[-1,0,0,0;0,-1,0,0;0,0,-1,0;0,0,0,-1];
beq = [0,0,0];
%this for loop evaluates F matrix
for i=1:4
    F(2,i)=cos(D(i,3));
    F(3,i)=sin(D(i,3));
    F(1,i)=((D(i,1)*F(3,i))-(D(i,2)*F(2,i)));
end
r = rank(F);
if r<3
    disp('body is not in closure')
    form=0;
else
    k = linprog(f,A,b,F,beq);
    [m,n] = size(k);
    if [m,n]==[4,1]%i.e if k is a 4*1 matrix then..
        disp('body in form closure')
        display(k)
        form=1;
    else % if k is not a 4*1 matrix then it means k has no solution,so...
         disp('body not in form closure');
         form=0;
     end
end