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