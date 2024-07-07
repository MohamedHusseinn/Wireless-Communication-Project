
% %% %%%%%%%%%%%%%%%%%% Point (1) %%%%%%%%%%%%%%%%%% %%

% Given range of SIRmin
SIRmin = linspace(1,30,30);

% Initialize a vector for every sectorization method
N = zeros(size(SIRmin));

% Sectorization values
sectorization = ["no_sectorization","120_sectorization","60_sectorization"];

% Initiate a figure window
Nfig = figure('Name', 'N VS SIRmin', 'NumberTitle', 'off');
colors = ["bo-","ro-","go-"];

% Compute the vectors
for sectMethod = 1:length(sectorization)
    for SIRindex = 1 : length(SIRmin)
        N(SIRindex) =cluster_size_fn(SIRmin(SIRindex),sectorization(sectMethod));
    end
    % Plot using stairs
    stairs(SIRmin,N,colors(sectMethod),'LineWidth', 1.5);
    hold on
end
hold off

% Plot settings
xlabel('$SIR_{min}$', 'Interpreter', 'latex', 'FontSize', 14);
ylabel('$Cluster\ size\ (N)$', 'Interpreter', 'latex', 'FontSize', 14);
legend('Omni-directional', '$120^o$ Sectorization', '$60^o$ Sectorization', ...
       'Location', 'northeast', 'Interpreter', 'latex', 'FontSize', 12);
grid on;
title('Cluster Size VS $SIR_{min}$','Interpreter', 'latex', 'FontSize', 16);

 %%%%%%%%%%%%%%%%%% Point (2&3) %%%%%%%%%%%%%%%%%% %%
for SIR = [14,19]
    % Givens
    SIRmin = SIR ;
    userDesnity = 1400 ;
    cityArea = 100 ;

    % GOS range
    GOS = linspace(1,30,30) / 100;

    % Initialize a vector for A (cell traffic intensity)
    [ACell,ASector,NoCells] = deal(zeros(size(GOS)));

    % Sectorization values
    sectorization = ["no_sectorization","120_sectorization","60_sectorization"];

    % Initialize figures
    Afig = figure('Name', 'Cell traffic intensity VS GOS', 'NumberTitle', 'off');
    NumberOfCellsfig = figure('Name', 'Number of cells VS GOS', 'NumberTitle', 'off');

    % Plot colors
    colors = ["bd-","rp-","gh-"];

    for sectMethod = 1:length(sectorization)
        N = cluster_size_fn(SIRmin,sectorization(sectMethod));
        for GOSindex = 1 : length(GOS)
            [ACell(GOSindex),ASector(GOSindex)] = intesityCalculation(GOS(GOSindex),N,sectorization(sectMethod));
            R = radiusCalculation(userDesnity,ASector(GOSindex),sectorization(sectMethod));
            NoCells(GOSindex)= no_cells_fn(R,cityArea);
        end
        % Plot the traffic intensity
        figure(Afig)
        plot(GOS,ACell,colors(sectMethod), 'LineWidth', 1.5);
        hold on
        figure(NumberOfCellsfig)
        plot(GOS,NoCells,colors(sectMethod), 'LineWidth', 1.5);
        hold on
    end
    hold off
    hold off

    % Plots settings
    figure(Afig)
    xlabel('GOS', 'Interpreter', 'latex', 'FontSize', 14);
    ylabel('Traffic intensity per cell', 'Interpreter', 'latex', 'FontSize', 14);
    legend('Omni-directional', '$120^o$ Sectorization', '$60^o$ Sectorization', ...
           'Location', 'northeast', 'Interpreter', 'latex', 'FontSize', 12);
    grid on;
    title(sprintf('Traffic intensity per cell VS GOS for SIRmin = %d dB',SIRmin),'Interpreter', 'latex', 'FontSize', 16);


    figure(NumberOfCellsfig)
    xlabel('GOS', 'Interpreter', 'latex', 'FontSize', 14);
    ylabel('Traffic intensity per cell', 'Interpreter', 'latex', 'FontSize', 14);
    legend('Omni-directional', '$120^o$ Sectorization', '$60^o$ Sectorization', ...
           'Location', 'northeast', 'Interpreter', 'latex', 'FontSize', 12);
    grid on;
    title(sprintf('Number of cells VS GOS for SIRmin = %d dB', SIRmin),'Interpreter', 'latex', 'FontSize', 16);
end


 %%%%%%%%%%%%%%%%%% Point (4&5) %%%%%%%%%%%%%%%%%% %%
for SIR = [14,19]
    % Givens
    SIRmin = SIR ;
    GOS = 2/100 ;
    cityArea = 100 ;

    % GOS range
    userDesnity = linspace(100,2000,30);

    % Initialize a vector for A (cell traffic intensity)
    [ACell,ASector,NoCells,R] = deal(zeros(size(userDesnity)));

    % Sectorization values
    sectorization = ["no_sectorization","120_sectorization","60_sectorization"];

    % Initialize figures
    Rfig = figure('Name', 'Radius VS user density', 'NumberTitle', 'off');
    NumberOfCellsfig2 = figure('Name', 'Number of cells VS user density', 'NumberTitle', 'off');

    % Plot colors
    colors = ["bd-","rp-","gh-"];

    for sectMethod = 1:length(sectorization)
        N = cluster_size_fn(SIRmin,sectorization(sectMethod));
        for UDindex = 1 : length(userDesnity)
            [ACell(UDindex),ASector(UDindex)] = intesityCalculation(GOS,N,sectorization(sectMethod));
            R(UDindex) = radiusCalculation(userDesnity(UDindex),ASector(UDindex),sectorization(sectMethod));
            NoCells(UDindex)= no_cells_fn(R(UDindex),cityArea);
        end
        % Plot the traffic intensity
        figure(Rfig)
        plot(userDesnity,R,colors(sectMethod), 'LineWidth', 1.5);
        hold on
        figure(NumberOfCellsfig2)
        plot(userDesnity,NoCells,colors(sectMethod), 'LineWidth', 1.5);
        hold on
    end
    hold off

    % Plots settings
    figure(Rfig)
    xlabel('GOS', 'Interpreter', 'latex', 'FontSize', 14);
    ylabel('Traffic intensity per cell', 'Interpreter', 'latex', 'FontSize', 14);
    legend('Omni-directional', '$120^o$ Sectorization', '$60^o$ Sectorization', ...
           'Location', 'northeast', 'Interpreter', 'latex', 'FontSize', 12);
    grid on;
    title(sprintf('Cell Radius VS user density for SIRmin = %d dB',SIRmin),'Interpreter', 'latex', 'FontSize', 16);


    figure(NumberOfCellsfig2)
    xlabel('GOS', 'Interpreter', 'latex', 'FontSize', 14);
    ylabel('Traffic intensity per cell', 'Interpreter', 'latex', 'FontSize', 14);
    legend('Omni-directional', '$120^o$ Sectorization', '$60^o$ Sectorization', ...
           'Location', 'northeast', 'Interpreter', 'latex', 'FontSize', 12);
    grid on;
    title(sprintf('Number of cells VS user density for SIRmin = %d dB', SIRmin),'Interpreter', 'latex', 'FontSize', 16);
end

