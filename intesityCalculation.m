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