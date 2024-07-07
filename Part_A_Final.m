clear;
clc;
%% Main Code
c=340; %# channels
f=900; %in MHZ
%GOS=input('Enter GOS: ');
%City_Area=input('Enter City area in Km^2: ');
%user_density=input('Enter user density in user/Km^2: ');
%SIR=input('Enter minimum SIR in dB: ');
%sectorization=input('Choose sectorization:no_sectorization,120_sectorization, 60_sectorization: ');
prompt = {'Enter GOS(ratio no percent): ','Enter City area in Km^2: ',...
    'Enter user density in user/Km^2: ','Enter minimum SIR in dB: ',...
    'Choose sectorization:no_sectorization,120_sectorization, 60_sectorization: '};
answer = inputdlg(prompt);
GOS=str2double(answer(1));
City_Area=str2double(answer(2));
user_density=str2double(answer(3));
SIR=str2double(answer(4));
sectorization=string(answer(5));
Hm=1.5; % in meters
Hb=20; % in meters
ms_sensitivity=-95; % in dBm
Au=0.025; %traffic intensity per user
%% 1) Cluster Size
N=cluster_size_fn(SIR,sectorization);
%% 2) Number of cells
[ACell,ASector]  = intesityCalculation(GOS,N,sectorization);
R = radiusCalculation(user_density,ASector,sectorization);
number_of_Cells = no_cells_fn(R,City_Area);
%% 3) Cell Radius
R = radiusCalculation(user_density,ASector,sectorization);

%% 4) Traffic intensity per cell, and traffic intensity per sector
[ACell,ASector]  = intesityCalculation(GOS,N,sectorization);

%% 5) Base station transmitted power
transmittedPower = powerCalculation(ms_sensitivity,R);

%% 6)A plot for the MS received power in dBm versus the receiver distance from the BS 
D=sqrt(3*N)*R; %reuse distance
plot_PRX(transmittedPower,D)
%%  printing results 
msgbox({['cluster size = ',num2str(N)] ...
    ['number of cells = ',num2str(number_of_Cells)] ...
    ['Cell Radius  = ',num2str(R),' Km'] ...
    ['Traffic intensity per cell = ',num2str(ACell),' Erlang'] ...
    ['Traffic intensity per sector = ',num2str(ASector),' Erlang'] ...
    ['Base station transmitted power = ',num2str(transmittedPower),' dBm']})
%% 1) Cluster Size function

function [N] = cluster_size_fn (SIR,sectorization)
%input('please choose SIR in dB, & Choose sectorization method:no_sectorization,120_sectorization, 60_sectorization')
io=6;% intialize 
SIR_ratio=power(10,SIR/10); %find SIR in ratio
if sectorization=="no_sectorization"
    io=6;
elseif sectorization=="120_sectorization"
    io=2;
elseif sectorization=="60_sectorization"
    io=1;
else
    msgbox('invalid data, assumed no_sectorization ');
end
dummy=power(io*SIR_ratio,1/4); %dummy variable used in middle operations
dummy=dummy + 1 ;
dummy=power(dummy,2);
N=dummy/3;
N_vector=[];
for i=0:ceil(N)
    for k=0:ceil(N)
        N_correct=power(i,2)+(i*k)+power(k,2);
        N_vector=[N_vector,N_correct];
    end
end
N_vector=sort(N_vector);
 for i=1:length(N_vector)
    if N_vector(i) >= N
        N=N_vector(i);
        break;
    end 
 end
end

%% 2) Intensity Calculation function

function [ACell,ASector]  = intesityCalculation(GOSGiven,N,sectorization)
   % S which is given
   totalNumberOfChannels = 340 ;

   % K which is calculated aftetr knowing the number of cells per cluster
   channelsPerCell = totalNumberOfChannels / N ;

   % Number of Channels per sector (sub cell)
   switch sectorization
       case 'no_sectorization'
           numberOfSectors = 1;
           c = floor(channelsPerCell);
       case '120_sectorization'
           numberOfSectors = 3;
           c = floor(channelsPerCell/3);
       case '60_sectorization'
           numberOfSectors = 6;
           c = floor(channelsPerCell/6);
   end
   % GOS Formula as a function of A 
   GOSEquation = @(As,GOS) GOS - (As^c / factorial(c)) /  sum( As.^(0:c) ./ factorial( (0:c) ) )  ; 

   % Solve for A
   options = optimoptions('fsolve', 'Diagnostics','off','Display', 'none');
   initial_guess = c ;
   ASector = fsolve(@(As) GOSEquation(As,GOSGiven) , initial_guess , options ) ; 

   ACell = numberOfSectors*ASector ;
end 

%% 3) Radius Calculation function

function cellRadius = radiusCalculation(userDensity,ASector,sectorization)

   % Based on sectorization method we can get the area of sector (sub cell)
   switch sectorization
        case 'no_sectorization'
            numberOfSectors = 1;
        case '120_sectorization'
            numberOfSectors = 3;
        case '60_sectorization'
            numberOfSectors = 6;
   end
    
    % Au is given (I assumed it per sector)
    Au = 0.025;
    
    % Calculate Number of users per sector
    numberOfUsersPerSector = floor(ASector / Au) ;
    
    % Sector area
    sectorArea = numberOfUsersPerSector / userDensity ; 
    
    % Cell area
    cellArea = sectorArea * numberOfSectors ;
    
    % Radius of the cell in Km
    cellRadius = sqrt( 2*cellArea / (3*sqrt(3)) );

end

%% 4)Number of cells function

function [number_of_Cells] = no_cells_fn(R,A) %R is the cell radius in km / A is the city area in km^2
cell_area=1.5*power(3,0.5)*power(R,2);
number_of_Cells=ceil(A/cell_area); 
end

%% 5) Power calculation function

	function transmittedPower = powerCalculation(prxmin,R)
    % Given the transmission frequency is 900 MHZ
    f = 900 ;
    
    % BS height
    hB = 20 ;
    
    % MS height
    hM = 1.5 ;
    
    % Resource for the Hata model formulae : https://en.wikipedia.org/wiki/Hata_model
    % Antenna height correction factor
    CH = 0.8 + (1.1*log10(f)-0.7)*hM -1.56*log10(f);
    % Path loss in urban areas. Unit: decibel (dB)
    LU = 69.55 + 26.16*log10(f) - 13.82*log10(hB) - CH + (44.9 -6.55*log10(hB))*log10(R) ;
    transmittedPower = prxmin + LU ;
    end

%% 6) Plot PRX function

function [] = plot_PRX(P_TX,D) %P_TX is in dBm
Hm=1.5;%in meter
Hb=20;%in meter
f=900; %in MHZ
d=0:D/1000:D;
P_RX=zeros(length(d));
CH=0.8 + (1.1 * log10(f) - 0.7) * Hm- 1.56 * log10(f);
Lu=69.55 + 26.16*log10(f) - 13.82*log10(Hb) - CH + (44.9-6.55 * log10(Hb)) * log10(d);
% assume that anntena at TX and RX has unity gain
P_RX=P_TX-Lu;% P_RX is in dBm
plot(d,P_RX,'linewidth',1.5)
xlabel('d in km');
ylabel('PRX in dBm')
grid on;
end


