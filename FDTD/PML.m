clc;clear;
%%%%%% PARAMETERS %%%%%%%%%%%%%%
Nx=100; % No of grids in x direction
dx=10; % grid increment
Ny=100; % No of grids in y direction
dy=10; % grid increment
%%%%%%% SOURCE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SRCNX = Nx/ 2 ; %source position
SRCNY = Ny/ 2 ; %source position
T = 1000; % total time
dt =.002; % time increment
f = 10 ; % frequency of source
t0 = 0.15 ; % source term

%%%%%%%%%% MODEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%
c = 2000; % velocity
r = 2000; % density
const1 = ( r *( c ^2) /dx ) ; % constant used in time updation
const2 = (1/( dx* r)); % constant used in time updation

%%%%%%%%%%%%% FIELD VARIABLES %%%%%%%%%%%%%%%
px0 = zeros(Nx,Ny) ; px2 = zeros(Nx,Ny) ;
py0 = zeros(Nx,Ny) ; py2 = zeros(Nx,Ny) ; 
p = zeros(Nx,Ny) ;
vx0 = zeros(Nx,Ny) ; vx2 = zeros(Nx,Ny) ; 
vy0 = zeros(Nx,Ny) ; vy2 = zeros(Nx,Ny) ; 

%%%%%%%%%%%%%% PML boundary conditions %%%%%%
d0 =150; % maximum value of damping
w = 12 ; % width of PML in terms of nodes
a = (1:w) ; % constant for evaluating damping array
b = fliplr ( a ) ; % constant for evaluating damping array

ox = zeros(Nx, 1 ) ; %initialize ar ray for damping
ox(1 :w) = d0 * ((b/w).^2 ) ; %Assign damping
ox((Nx-(w-1) ) :Nx) = d0*((a/w)).^2 ; %Assign damping
oy = zeros(1,Ny) ; %initialize array for damping
oy( 1 :w) = d0 * ((b/w) ).^2 ; %Assign damping
oy((Ny-(w-1) ) :Ny) = d0 * ((a/w) ).^2 ;%Assign damping

 %%%%%%%%%%%% TIME UPDATING %%%%%%%%%%%%%%%%%
bv=p; 
h1=surface(bv); hold on;
h2=pcolor(abs(p)); colormap(flipud(bone)); hold off;
colorbar;
caxis([0 0.05]);

shading interp;

 for k = 0:T
     t = k*dt ;

     %insert source 
     px0(SRCNX,SRCNY) = px0(SRCNX,SRCNY) +(ricker( f,t,t0));
     py0(SRCNX,SRCNY) = py0(SRCNX,SRCNY) +(ricker( f,t,t0));

     for i =2:Nx-1
         for j =2:Ny-1
             px2 (i,j) = ((2.0* dt ) /(2.0+( ox(i,1) *dt)))* ((px0 (i,j)...
                  *( (2.0 -( ox(i,1) *dt))/ ( 2.0* dt)))+...
                 (const1*( vx0 (i+1,j)-vx0 (i,j))));
             py2 (i,j) = ((2.0* dt ) /(2.0+(oy(1,j) *dt)))* ((py0 (i,j)...
                *( (2.0 -( oy(1,j) *dt))/ ( 2.0* dt)))+...
                (const1*( vy0 (i,j+1)-vy0 (i,j))));
            
             p(i,j) = px2 (i,j)+py2 (i,j) ;
             
             vx2 (i,j) = ((2.0* dt ) /(2.0+( ox(i,1) *dt)))* ((vx0 (i,j)...
                     *( (2.0 -( ox(i,1) *dt))/ ( 2.0* dt)))+...
                 ((const2 ) *(p(i,j)-p( i -1, j)))) ;
             vy2 (i,j) = ((2.0* dt ) /(2.0+( oy(1,j) *dt)))* ((vy0 (i,j)...
                  *( (2.0 -( oy(1,j) *dt))/ ( 2.0* dt)))+...
                 ((const2 ) *(p(i,j)-p(i,j-1))));
         end
     end

     px0 = px2 ;
     py0 = py2 ;
     vx0 = vx2 ;
     vy0 = vy2 ;
    p1 = abs(p);
    set(h2,'CData',p1); 

     xlabel('Distance(m)') ; ylabel( ' Distance(m) ' )
     drawnow; 
 end