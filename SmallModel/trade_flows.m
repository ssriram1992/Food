function trade_flows(s,addis)

% plot trade flows between regions

inds = s.node_nums;

% deal with cattle flows

g_cattle = zeros(10,10,s.m_n,s.y_n,s.adv_n);
transp = s.q_cattle_transp;

for i = 1:length(transp(:,1))
    g_cattle(transp(i,1),transp(i,2),transp(i,3),transp(i,4),transp(i,5)) = ...
        transp(i,6);
end

g_cattle = round(g_cattle(inds,inds,:,:,:),2);

% deal with food flows
g_food = zeros(10,10,s.m_n,s.y_n,s.adv_n);
transp = s.q_food_transp;

for i = 1:length(transp(:,1))
    g_food(transp(i,2),transp(i,3),transp(i,1),transp(i,4),transp(i,5),transp(i,6)) = ...
        transp(i,7);
end

g_food = round(g_food(inds,inds,:,:,:,:),2);

% you have to change the code to get the specific information you want -
% there are too many combinations/permutations just to take an argument

% cattle
%incidence_mat = sum(sum(g_cattle(:,:,:,:,1),3),4);

% food
incidence_mat = sum(sum(sum(g_food(:,:,:,:,2:9,1),4),5),3);


switch addis
    case 'addis'
        incidence_mat(2:5,2:5) = 0;
        
    case 'not addis'
        incidence_mat(1,:) = 0;
        incidence_mat(:,1) = 0;
end



G = digraph(incidence_mat);

% node locations
x = [-1.8   1  -2.5   -5.5  -7   -4   5    -4    -2   0];
y = [-0.2   5  4.5    3     -2   0    -3   -4.5  8.5  -4];

x = x(inds);
y = y(inds);

% plot with automatic labels
figure
ha = axes('units','normalized','position',[0 0 1 1]);
I=imread('ethiopia_map.jpg');
hi = imagesc(I);
colormap gray
set(ha,'handlevisibility','off','visible','off')

axes('position',[0 0 1 1])

p = plot(G,'XData',x,'YData',y,'EdgeLabel',G.Edges.Weight,'NodeLabel',[],...
    'EdgeColor','k','ArrowSize',10,'EdgeAlpha',1);
xlim([-10 10])
ylim([-10 10])

set(hi,'alphadata',0.5)
%uistack(ha,'top');
set(gca, 'Color', 'None');


% plot with manual labels
% the automatic labels are too small and can't be moved
% use the plot with automatic labels to determine where each manual flow
% label belongs
figure
ha = axes('units','normalized','position',[0 0 1 1]);
I=imread('ethiopia_map.jpg');
hi = imagesc(I);
colormap gray
set(ha,'handlevisibility','off','visible','off')

axes('position',[0 0 1 1])

p = plot(G,'XData',x,'YData',y,'NodeLabel',[],...
    'EdgeColor','k','ArrowSize',10,'EdgeAlpha',1);
xlim([-10 10])
ylim([-10 10])

for i = 1:height(G.Edges)
    xcoord = (x(G.Edges{i,1}(1)) + x(G.Edges{i,1}(2)))/2;
    ycoord = (y(G.Edges{i,1}(1)) + y(G.Edges{i,1}(2)))/2;
    text(xcoord,ycoord,num2str(G.Edges{i,2}),'fontsize',12);
end

set(hi,'alphadata',0.5)
set(gca, 'Color', 'None');

