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
%might wanna change the line "i=0:ceil(N)" to ceil(root(N))