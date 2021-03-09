% Example
% by Bowen 2020/12/29 didn't figure out the parameters
load fisheriris.mat

clear g
figure('Position',[100 100 800 600]);
%Create an histogram of all the data in the background (no facet_ is given yet)
g(1,1)=gramm('x',meas(:,2));
g(1,1).set_names('x','Sepal Width','column','');
g(1,1).stat_bin('fill','all'); %histogram
g(1,1).set_color_options('chroma',0,'lightness',75); %We make it light grey
g(1,1).set_title('Overlaid histograms');

g.draw(); %Draw the backgrounds

g(1,1).update('color',species); %Add color with update()
g(1,1).facet_grid([],species); %Provide facets
g(1,1).stat_bin('dodge',0); %Histogram (we set dodge to zero as facet_grid makes it useless)
g(1,1).set_color_options(); %Reset to default colors
g(1,1).no_legend();
g(1,1).axe_property('ylim',[-2 30]); %We have to set y scale manually, as the automatic scaling from the first plot was forgotten


g(1,1).axe_property('TickDir','out','XGrid','on','Ygrid','on','GridColor',[0.5 0.5 0.5]);
%Draw the news elements
g(1,1).draw();


% My project
species_ant = cell(74,1);
species_ant(1:21,:) = {'Ant'};
species_ant(22:35,:) = {'neoT'};
species_ant(35:51,:) = {'Post'};
species_ant(52:74,:) = {'mTLE'};
percent = [];

clear g
figure('Position',[100 100 800 600]);
gP=gramm('x',percent(:,2));
gP.set_names('x','pt_ID','column','');
gP.stat_bin('fill','all'); %histogram
gP.set_color_options('chroma',0,'lightness',75); %We make it light grey
gP.set_title('Overlaid histograms');

gP.draw(); %Draw the backgrounds

gP.update('color',species_ant); %Add color with update()
gP.facet_grid([],species_ant); %Provide facets
gP.stat_bin('dodge',0); %Histogram (we set dodge to zero as facet_grid makes it useless)
gP.set_color_options(); %Reset to default colors
gP.no_legend();
gP.axe_property('ylim',[-2 12]);

%Set global axe properties
gP.axe_property('TickDir','out','XGrid','on','Ygrid','on','GridColor',[0.5 0.5 0.5]);
%Draw the news elements
gP.draw();