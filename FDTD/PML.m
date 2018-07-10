%Clearing variables in memory and Matlab command screen
clear all;
clc;

% Grid Dimension in x (xdim) and y (ydim) directions
xdim=200;
ydim=200;

%Total no of time steps
time_tot=350;

%Position of the source (center of the domain)
xsource=100;
ysource=100;

%Courant stability factor
S=1/(2^0.5);

% Parameters of free space (permittivity and permeability and speed of
% light) are all not 1 and are given real values
epsilon0=(1/(36*pi))*1e-9;
mu0=4*pi*1e-7;
c=3e+8;

% Spatial grid step length (spatial grid step= 1 micron and can be changed)
delta=1e-6;
% Temporal grid step obtained using Courant condition
deltat=S*delta/c;

% Initialization of field matrices
Ez=zeros(xdim,ydim);
Ezx=zeros(xdim,ydim);
Ezy=zeros(xdim,ydim);
Hy=zeros(xdim,ydim);
Hx=zeros(xdim,ydim);

% Initialization of permittivity and permeability matrices
epsilon=epsilon0*ones(xdim,ydim);
mu=mu0*ones(xdim,ydim);

% Initializing electric conductivity matrices in x and y directions
sigmax=zeros(xdim,ydim);
sigmay=zeros(xdim,ydim);


%Perfectly matched layer boundary design
%Reference:-http://dougneubauer.com/wp-content/uploads/wdata/yee2dpml1/yee2d_c.txt
%(An adaptation of 2-D FDTD TE code of Dr. Susan Hagness)

%Boundary width of PML in all directions
bound_width=25;

%Order of polynomial on which sigma is modeled
gradingorder=6;

%Required reflection co-efficient
refl_coeff=1e-6;

%Polynomial model for sigma
sigmamax=(-log10(refl_coeff)*(gradingorder+1)*epsilon0*c)/(2*bound_width*delta);
boundfact1=((epsilon(xdim/2,bound_width)/epsilon0)*sigmamax)/((bound_width^gradingorder)*(gradingorder+1));
boundfact2=((epsilon(xdim/2,ydim-bound_width)/epsilon0)*sigmamax)/((bound_width^gradingorder)*(gradingorder+1));
boundfact3=((epsilon(bound_width,ydim/2)/epsilon0)*sigmamax)/((bound_width^gradingorder)*(gradingorder+1));
boundfact4=((epsilon(xdim-bound_width,ydim/2)/epsilon0)*sigmamax)/((bound_width^gradingorder)*(gradingorder+1));
x=0:1:bound_width;
for i=1:1:xdim
    sigmax(i,bound_width+1:-1:1)=boundfact1*((x+0.5*ones(1,bound_width+1)).^(gradingorder+1)-(x-0.5*[0 ones(1,bound_width)]).^(gradingorder+1));
    sigmax(i,ydim-bound_width:1:ydim)=boundfact2*((x+0.5*ones(1,bound_width+1)).^(gradingorder+1)-(x-0.5*[0 ones(1,bound_width)]).^(gradingorder+1));
end
for i=1:1:ydim
    sigmay(bound_width+1:-1:1,i)=boundfact3*((x+0.5*ones(1,bound_width+1)).^(gradingorder+1)-(x-0.5*[0 ones(1,bound_width)]).^(gradingorder+1))';
    sigmay(xdim-bound_width:1:xdim,i)=boundfact4*((x+0.5*ones(1,bound_width+1)).^(gradingorder+1)-(x-0.5*[0 ones(1,bound_width)]).^(gradingorder+1))';
end

%Magnetic conductivity matrix obtained by Perfectly Matched Layer condition
%This is also split into x and y directions in Berenger's model
sigma_starx=(sigmax.*mu)./epsilon;
sigma_stary=(sigmay.*mu)./epsilon;

%Choice of nature of source
gaussian=0;
sine=0;
% The user can give a frequency of his choice for sinusoidal (if sine=1 above) waves in Hz 
frequency=1.5e+13;
impulse=0;
%Choose any one as 1 and rest as 0. Default (when all are 0): Unit time step

%Multiplication factor matrices for H matrix update to avoid being calculated many times 
%in the time update loop so as to increase computation speed
G=((mu-0.5*deltat*sigma_starx)./(mu+0.5*deltat*sigma_starx)); 
H=(deltat/delta)./(mu+0.5*deltat*sigma_starx);
A=((mu-0.5*deltat*sigma_stary)./(mu+0.5*deltat*sigma_stary)); 
B=(deltat/delta)./(mu+0.5*deltat*sigma_stary);
                          
%Multiplication factor matrices for E matrix update to avoid being calculated many times 
%in the time update loop so as to increase computation speed                          
C=((epsilon-0.5*deltat*sigmax)./(epsilon+0.5*deltat*sigmax)); 
D=(deltat/delta)./(epsilon+0.5*deltat*sigmax);   
E=((epsilon-0.5*deltat*sigmay)./(epsilon+0.5*deltat*sigmay)); 
F=(deltat/delta)./(epsilon+0.5*deltat*sigmay);

% Update loop begins
for n=1:1:time_tot
    
    %if source is impulse or unit-time step 
    if gaussian==0 && sine==0 && n==1
        Ezx(xsource,ysource)=0.5;
        Ezy(xsource,ysource)=0.5;
    end
    
    % Setting time dependent boundaries to update only relevant parts of the 
    % matrix where the wave has reached to avoid unnecessary updates.
    if n<xsource-2
        n1=xsource-n-1;
    else
        n1=1;
    end
    if n<xdim-1-xsource
        n2=xsource+n;
    else
        n2=xdim-1;
    end
    if n<ysource-2
        n11=ysource-n-1;
    else
        n11=1;
    end
    if n<ydim-1-ysource
        n21=ysource+n;
    else
        n21=ydim-1;
    end
    
    %matrix update instead of for-loop for Hy and Hx fields
    Hy(n1:n2,n11:n21)=A(n1:n2,n11:n21).*Hy(n1:n2,n11:n21)+B(n1:n2,n11:n21).*(Ezx(n1+1:n2+1,n11:n21)-Ezx(n1:n2,n11:n21)+Ezy(n1+1:n2+1,n11:n21)-Ezy(n1:n2,n11:n21));
    Hx(n1:n2,n11:n21)=G(n1:n2,n11:n21).*Hx(n1:n2,n11:n21)-H(n1:n2,n11:n21).*(Ezx(n1:n2,n11+1:n21+1)-Ezx(n1:n2,n11:n21)+Ezy(n1:n2,n11+1:n21+1)-Ezy(n1:n2,n11:n21));
    
    %matrix update instead of for-loop for Ez field
    Ezx(n1+1:n2+1,n11+1:n21+1)=C(n1+1:n2+1,n11+1:n21+1).*Ezx(n1+1:n2+1,n11+1:n21+1)+D(n1+1:n2+1,n11+1:n21+1).*(-Hx(n1+1:n2+1,n11+1:n21+1)+Hx(n1+1:n2+1,n11:n21));
    Ezy(n1+1:n2+1,n11+1:n21+1)=E(n1+1:n2+1,n11+1:n21+1).*Ezy(n1+1:n2+1,n11+1:n21+1)+F(n1+1:n2+1,n11+1:n21+1).*(Hy(n1+1:n2+1,n11+1:n21+1)-Hy(n1:n2,n11+1:n21+1));
    
    % Source conditions
    if impulse==0
        % If unit-time step
        if gaussian==0 && sine==0
            Ezx(xsource,ysource)=0.5;
            Ezy(xsource,ysource)=0.5;
        end
        %if sine
        if sine==1
            tstart=1;
            N_lambda=c/(frequency*delta);
            Ezx(xsource,ysource)=0.5*sin(((2*pi*(c/(delta*N_lambda))*(n-tstart)*deltat)));
            Ezy(xsource,ysource)=0.5*sin(((2*pi*(c/(delta*N_lambda))*(n-tstart)*deltat)));
        end
        %if gaussian
        if gaussian==1
            if n<=42
                Ezx(xsource,ysource)=(10-15*cos(n*pi/20)+6*cos(2*n*pi/20)-cos(3*n*pi/20))/64;
                Ezy(xsource,ysource)=(10-15*cos(n*pi/20)+6*cos(2*n*pi/20)-cos(3*n*pi/20))/64;
            else
                Ezx(xsource,ysource)=0;
                Ezy(xsource,ysource)=0;
            end
        end
    else
        %if impulse
        Ezx(xsource,ysource)=0;
        Ezy(xsource,ysource)=0;
    end
    
    Ez=Ezx+Ezy;
    
    %Movie type colour scaled image plot of Ez
    imagesc(delta*1e+6*(1:1:xdim),(delta*1e+6*(1:1:ydim))',Ez',[-1,1]);colorbar;
    title(['\fontsize{20}Colour-scaled image plot of Ez in a spatial domain with PML boundary and at time = ',num2str(round(n*deltat*1e+15)),' fs']); 
    xlabel('x (in um)','FontSize',20);
    ylabel('y (in um)','FontSize',20);
    set(gca,'FontSize',20);
    getframe;
end