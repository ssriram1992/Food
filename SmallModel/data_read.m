function mcp_data = data_read()

% import data from GAMS MCP model

s.name = 'q_food_market_A_rec';
s.form = 'full';
s.compress = true;
x = rgdx('Ethiopia_small_mcp', s);
q_food_market = x.val;
food_names = x.uels{1};
len_n = length(x.uels{2}');
node_nums = zeros(len_n,1);

for i = 1:len_n
    node_nums(i) = str2num(cell2mat(x.uels{2}(i)));
end

s.name = 'p_food_market_rec';
x = rgdx('Ethiopia_small_mcp', s);
p_food_market = x.val;

s.name = 'Q_food_rec';
x = rgdx('Ethiopia_small_mcp', s);
Q_food = x.val;

s.name = 'q_food_market_S_rec';
x = rgdx('Ethiopia_small_mcp', s);
q_food_market_tot = x.val;

s.name = 'A_crop_rec';
x = rgdx('Ethiopia_small_mcp', s);
A_crop = x.val;
crop_names = x.uels{1};
season_names = x.uels{2};

s.name = 'q_food_store_rec';
x = rgdx('Ethiopia_small_mcp', s);
q_food_store = x.val;

s.form = 'sparse';
s.name = 'q_food_transp_rec';
x = rgdx('Ethiopia_small_mcp', s);
q_food_transp = x.val;

% put food trade data into usable form
food_transp = zeros(length(x.uels{1}),1);
for i = 1:length(x.uels{1})
    food_transp(i) = strcmpi(x.uels{1}(i),'wheat') ...
        + 2*strcmpi(x.uels{1}(i),'potatoes')...
        + 3*strcmpi(x.uels{1}(i),'peppers')...
        + 4*strcmpi(x.uels{1}(i),'lentils')...
        + 5*strcmpi(x.uels{1}(i),'beef')...
        + 6*strcmpi(x.uels{1}(i),'milk');
end


node_from = str2double(x.uels{2}');
node_to = str2double(x.uels{3}');
month_transp = str2double(x.uels{4}');
year_transp = str2double(x.uels{5}');
adv_transp = str2double(x.uels{6}');

for i = 1:length(q_food_transp(:,1))
    q_food_transp(i,1) = food_transp(q_food_transp(i,1));
    q_food_transp(i,2) = node_from(q_food_transp(i,2));
    q_food_transp(i,3) = node_to(q_food_transp(i,3));
    q_food_transp(i,4) = month_transp(q_food_transp(i,4));
    q_food_transp(i,5) = year_transp(q_food_transp(i,5))-2000;
    q_food_transp(i,6) = adv_transp(q_food_transp(i,6));
end



s.name = 'q_cattle_transp_rec';
x = rgdx('Ethiopia_small_mcp', s);
q_cattle_transp = x.val;

% put cattle trade data into usable form
node_from = str2double(x.uels{1}');
node_to = str2double(x.uels{2}');
month_transp = str2double(x.uels{3}');
year_transp = str2double(x.uels{4}');
adv_transp = str2double(x.uels{5}');

for i = 1:length(q_cattle_transp(:,1))
    q_cattle_transp(i,1) = node_from(q_cattle_transp(i,1));
    q_cattle_transp(i,2) = node_to(q_cattle_transp(i,2));
    q_cattle_transp(i,3) = month_transp(q_cattle_transp(i,3));
    q_cattle_transp(i,4) = year_transp(q_cattle_transp(i,4))-2000;
    q_cattle_transp(i,5) = adv_transp(q_cattle_transp(i,5));
end


s.name = 'N_cattle_rec';
s.form = 'full';
x = rgdx('Ethiopia_small_mcp', s);
N_cattle = x.val;
year_names = x.uels{3};



f_n = length(q_food_market(:,1,1,1,1,1));
n_n = length(q_food_market(1,:,1,1,1,1));
I_n = length(q_food_market(1,1,:,1,1,1));
m_n = length(q_food_market(1,1,1,:,1,1));
y_n = length(q_food_market(1,1,1,1,:,1));
adv_n = length(q_food_market(1,1,1,1,1,:));
c_n = length(A_crop(:,1,1,1,1));
s_n = length(A_crop(1,:,1,1,1));


mcp_data.q_food_market = q_food_market;
mcp_data.p_food_market = p_food_market;
mcp_data.Q_food = Q_food;
mcp_data.q_food_store = q_food_store;
mcp_data.q_food_market_tot = q_food_market_tot;
mcp_data.N_cattle = N_cattle;
mcp_data.A_crop = A_crop;
mcp_data.q_food_transp = q_food_transp;
mcp_data.q_cattle_transp = q_cattle_transp;

mcp_data.f_n = f_n;
mcp_data.n_n = n_n;
mcp_data.I_n = I_n;
mcp_data.m_n = m_n;
mcp_data.y_n = y_n;
mcp_data.adv_n = adv_n;
mcp_data.c_n = c_n;
mcp_data.s_n = s_n;
mcp_data.food_names = food_names;
mcp_data.crop_names = crop_names;
mcp_data.season_names = season_names;
mcp_data.year_names = year_names;
mcp_data.node_nums = node_nums;

