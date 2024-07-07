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
