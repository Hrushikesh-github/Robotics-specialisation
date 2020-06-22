function [intersect]=intersect(obstacles,p1,p2)
 for i=1:8
    C=obstacles(i,1:2);
    r=obstacles(i,3);
            
P1=p1';
P2=p2';
if  ((P1(1,1)-C(1,1)).^2+(P1(2,1)-C(2,1)).^2<=r^2)
    intersect=1;
    break
end
if  ((P2(1,1)-C(1,1)).^2+(P2(2,1)-C(2,1)).^2<=r^2)
        intersect=1;
        break
    end
A = P1-C;
   B = P2-P1;
   d2 = dot(B,B);
   t = (r^2-dot(A,A))*d2+dot(A,B)^2;
   if t < 0 
       intersect=0;
       break
     end
   Q = P1-dot(A,B)/d2*B;
   t2 = sqrt(t)/d2*B;
   I1 = Q + t2;
   I2 = Q - t2;
  D1=norm(P1-I1);
  D2=norm(P2-I1);
  D3=norm(P1-P2);
  if (D1+D2)==D3
      intersect=1;
      break
  else
      intersect=0;
  end
end
