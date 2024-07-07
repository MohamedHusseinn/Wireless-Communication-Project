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
