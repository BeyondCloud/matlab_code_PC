a=0;
for i = 1:1000000
   a =a+  floor(mod(rand*4,4))+1;
end
a/1000000