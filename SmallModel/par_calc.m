function pars = par_calc()

% calculate parameters for GAMS MCP solution and for post-processing
% watch out for parameters that show up here and in GAMS

n = [1:10]';
y = [1:9]';
adv = [1:3]';

% initialize indices

% 1 = wheat, 2 = potatoes, 3 = peppers, 4 = lentils, 5 = beef, 6 = milk
f = [1:6]';
c = [1:4]';

% months start with February
m = [1:12]';

% 1 = 500, 2 = 1500, 3 = 2500
I = [1:3]';
I_mean = [250;550;1100];

% 1 = 0-5, 2 = 6-10, 3 = 11-15, 4 = 16+
a = [1:4]';

% 1 = protein, 2 = calories, 3 = micronutrients
nut = [1:3]';

d = [1:365]';


% 1 = male, 2 = female
g = [1;2];

% 1 = belg, 2 = kremt
s = [1;2];

s_q = [1:3]';
s_f = [1:3]';

num_f = length(f);
num_c = length(c);
num_n = length(n);
num_m = length(m);
num_adv = length(adv);
num_I = length(I);
num_a = length(a);
num_nut = length(nut);
num_d = length(d);
num_y = length(y);
y_tot = [1:(num_y + num_adv - 1)]';
num_y_tot = length(y_tot);

month_starts = [1;29;60;90;121;151;182;213;243;274;304;335];
% remember that these are the days of the year for first day of the month
% for a year that starts in February

month_length = [28;31;30;31;30;31;31;30;31;30;31;31];

t_month = 720;

% soil parameters

r_sq = [1;0.7;0.4];
r_sf = [1;0.7;0.4];
alpha_soil = 0.2;

d_water_init(n) = 1e-4;

% demography parameters
% may change these distributions to be joint distributions

N_pop = [2.7;1.4;17.2;0.7;0.3;14.1;4.4;15;4.3;14.1];


% right now, assuming that population distributions are the same across nodes
% that won't hold, in general, in the final model

rho_I = [0.5;0.3;0.2];
rho_a = [0.2;0.15;0.15;0.5];
rho_g = [0.5;0.5];

% crop parameters
rho_plant(c) = [6;3;3.5;5];
Delta_A_leaf_max(c) = 0.1;
Delta_A_remove(c) = 0.03;
alpha_1(c) = 0.6;
alpha_2(c) = 5;
Delta_N_max(c) = 0.1;
N_mature(c,s) = 12;
N_mature(c,1) = N_mature(c,1)*2/3;
delta_row(c) = [0.6;0.5;0.45;0.7];
T_base(c) = 10;
rho_SLA(c) = 0.03;
I_tot(c,s) = 300;
I_tot(c,1) = I_tot(c,1)*2/3;
alpha_water = [2.2e-3;2.5e-3;2.5e-3;2.8e-3];
d_water_thresh = 0.02;
Delta_d_early = 5;
season_start = [30;90];
season_end = [90;180];

% livestock parameters
alpha_dairy = 5.3e-3;


% distribution parameters
v_c = 80;
eta_i(n) = 0.8;
A_i = [500;7.2e4;1.5e4;5.1e4;3e4;1.4e5;2.8e5;1.1e5;4.1e4;1.4e5];
v_c_internal = 50;
eta_fuel = 1.6e-5;
tau_food = [1.5e3;1.2e3;8e2;1.5e3;50;80];
alpha_q_transp(n,n) = 1;
d_ij = [0     400   300   450   500   300   750   350   600   250;...
    400   0     350   650   900   700   750   800   300   600;...
    300   350   0     400   650   700   900   700   300   450;...
    450   650   400   0     400   750   1200  500   550   300;...
    500   900   650   400   0     750   1250  350   900   350;...
    300   700   700   750   750   0     600   450   850   500;...
    750   750   900   1200  1250  600   0     850   1000  900;...
    350   800   700   500   350   450   850   0     950   300;...
    600   300   300   550   900   850   1000  950   0     700;...
    250   600   450   300   350   500   900   300   700   0];

% storage parameters
alpha_q_storage(n) = 8;

% consumer parameters
w = [0.2,0.2;0.5,0.5;0.75,0.7;1,0.9];
B = [1000,-1,10;-1,0.01,0.1;10,0.1,1];
B_inv = inv(B);
r_loss_utilization = 0.9;

gamma_nut = [0.07,0.01,0.01,0.10,0.18,0.03;...
    3.4,0.8,0.3,3.5,3.2,0.5;...
    1,0.5,2,1.5,2,2];

% climate parameters
load('d_precip.mat')
load('E_PAR.mat')
load('T_min.mat')
load('T_max.mat')
load('T_mean.mat')
load('T_wb.mat')
load('T_db.mat')

d_precip = d_precip(1:num_n,:,1:num_y_tot);
% assuming that the data is in kJ/m^2 - I need MJ/m^2
E_PAR = E_PAR(1:num_n,:,1:num_y_tot)/1000;
T_min = T_min(1:num_n,:,1:num_y_tot);
T_max = T_max(1:num_n,:,1:num_y_tot);
T_mean = T_mean(1:num_n,:,1:num_y_tot);
T_wb = T_wb(1:num_n,:,1:num_y_tot);
T_db = T_db(1:num_n,:,1:num_y_tot);

% Calculated Parameters

% calendrical
month_ratio = month_length/30;

% soil
node_s_q(n) = 2;
node_s_f(n) = 2;

node_r_sq = ones(num_n,1);
node_r_sf = ones(num_n,1);

for n2 = 1:num_n
    node_r_sq(n2) = r_sq(node_s_q(n2));
    node_r_sf(n2) = r_sf(node_s_f(n2));
end

d_water(n,d,y_tot) = 0;
d_water(:,1,1) = d_water_init;

for y2 = 1:num_y_tot
    if (y2 ~= 1)
        d_water(:,1,y2) = node_r_sq.*d_precip(:,1,y2)...
            + d_water(:,365,y2-1).*node_r_sq.^alpha_soil;
    end
        for d2 = 2:num_d
            d_water(:,d2,y2) = node_r_sq.*d_precip(:,d2,y2)...
                + d_water(:,d2-1,y2).*node_r_sq.^alpha_soil;
        end
end   

% energy
% p_fuel(m,y,adv) calculated from energy model

p_fuel = ones(num_m,num_y,num_adv);

% crop yield calculations

Delta_N(c,n,d,y_tot) = 0;
r_water(c,n,d,y_tot) = 0;
Delta_I(c,n,d,y_tot) = 0;

r_temp = 1 - 0.0025*(0.25*T_min + 0.75*T_max  - 26).^2;

for y2 = 1:num_y_tot
    for n2 = 1:num_n
        for d2 = 1:num_d            
            for c2 = 1:num_c
                Delta_N(c2,n2,d2,y2) = r_temp(n2,d2,y2)*Delta_N_max(c2);
                r_water(c2,n2,d2,y2) = 1 - exp(-d_water(n2,d2,y2)*log(2)...
                    /(alpha_water(c2)*rho_plant(c2)));
                Delta_I(c2,n2,d2,y2) = ((T_mean(n2,d2,y2) > T_base(c2)) ...
                    && (T_mean(n2,d2,y2) < 25)).*(T_mean(n2,d2,y2) - T_base(c2));
            end
        end
    end
end

% calculate sowing dates

sowing_date(s,n,y_tot) = 0;

for y2 = 1:num_y_tot
    for n2 = 1:num_n
        for s2 = 1:2
            d2 = season_start(s2) + Delta_d_early;
            sowing_date(s2,n2,y2) = d2 - Delta_d_early;
            while((d_water(n2,d2,y2) < d_water_thresh) && (d2 <= (season_end(s2)...
                    + Delta_d_early)))
                sowing_date(s2,n2,y2) = d2 - Delta_d_early;
                d2 = d2 + 1;
            end
        end
    end
end

% initialize variables as necessary
N_sum(c,s,n,d,y_tot) = 0;
L_sum(c,s,n,d,y_tot) = 0;
m_h_sum(c,s,n,d,y_tot) = 0;
I_sum(c,s,n,d,y_tot) = 0;
m_crop(c,s,n,m,y_tot,adv) = 0;

Y_1(c) = 1.5 - 0.768*((delta_row(c).^2).*rho_plant(c)).^0.1;

a_plant(c,s,n,d,y_tot) = 0;
Delta_L(c,s,n,d,y_tot) = 0;
mature_date(c,s,n,y_tot) = 0;
Delta_m_h(c,s,n,d,y_tot) = 0;
harvest_date(c,s,n,y_tot) = 0;
harvest(c,s,n,y_tot) = 0;
harvest_month(c,s,n,y_tot) = 0;

for y2 = 1:num_y_tot
    for n2 = 1:num_n
        for s2 = 1:2
            if (sowing_date(s2,n2,y2) == season_end(s2))
                m_crop(:,s2,n2,:,y2,1) = 0;
            else
                % calculate yield for that season and crop
                
                % vegetative growth                
                for c2 = 1:num_c
                    d2 = sowing_date(s2,n2,y2) + 1;
                    while (N_sum(c2,s2,n2,d2-1,y2) < N_mature(c2,s2)) && (d2 < 363)
                        N_sum(c2,s2,n2,d2,y2) = N_sum(c2,s2,n2,d2-1,y2) ...
                            + Delta_N(c2,n2,d2,y2);
                        a_plant(c2,s2,n2,d2,y2) = exp(2*alpha_1(c2)*...
                            (N_sum(c2,s2,n2,d2,y2) - alpha_2(c2)));
                        Delta_L(c2,s2,n2,d2,y2) = r_temp(n2,d2,y2)*r_water(c2,n2,d2,y2)...
                            *rho_plant(c2)*Delta_A_leaf_max(c2)*Delta_N(c2,n2,d2,y2)...
                            *a_plant(c2,s2,n2,d2,y2)/(1+a_plant(c2,s2,n2,d2,y2));
                        L_sum(c2,s2,n2,d2,y2) = L_sum(c2,s2,n2,d2-1,y2) ...
                            + Delta_L(c2,s2,n2,d2,y2);
                        mature_date(c2,s2,n2,y2) = d2;
                        d2 = d2 + 1;
                    end
                    
                    % reproductive growth                    
                    while((I_sum(c2,s2,n2,d2-1,y2) < I_tot(c2,s2)) && (d2 < 365))
                        Delta_L(c2,s2,n2,d2,y2) = - rho_plant(c2)...
                            *Delta_I(c2,n2,d2,y2)*Delta_A_remove(c2)*rho_SLA(c2);
                        
                        % L_sum sometimes drops below zero - need to fix
                        % this, probably a parameter value issue
                        % if it drops to below zero, just set it to zero
                         L_sum(c2,s2,n2,d2,y2) = L_sum(c2,s2,n2,d2-1,y2) ...
                            + Delta_L(c2,s2,n2,d2,y2);
                        if L_sum(c2,s2,n2,d2,y2) < 0
                            L_sum(c2,s2,n2,d2,y2) = 0;
                        end
                        
                         Delta_m_h(c2,s2,n2,d2,y2) = 2.1*r_water(c2,n2,d2,y2)...
                             *r_temp(n2,d2,y2)*E_PAR(n2,d2,y2)...
                             *(1-exp(-Y_1(c2)*L_sum(c2,s2,n2,d2,y2)));
                         m_h_sum(c2,s2,n2,d2,y2) = m_h_sum(c2,s2,n2,d2-1,y2)...
                                 + Delta_m_h(c2,s2,n2,d2,y2);
                         I_sum(c2,s2,n2,d2,y2) = I_sum(c2,s2,n2,d2-1,y2) ...
                             + Delta_I(c2,n2,d2,y2);
                         harvest_date(c2,s2,n2,y2) = d2;
                         harvest(c2,s2,n2,y2) = m_h_sum(c2,s2,n2,d2,y2);
                         d2 = d2 + 1;
                    end
                    
                    m2 = 1;
                    while((harvest_date(c2,s2,n2,y2) > month_starts(m2)) &&...
                            m2 < num_m)
                        harvest_month(c2,s2,n2,y2) = m2;
                        m2 = m2 + 1;
                    end
                    
                    if harvest(c2,s2,n2,y2) == 0
                        display('error')
                    end
                    
                    m_crop(c2,s2,n2,harvest_month(c2,s2,n2,y2),y2,1) = ...
                        harvest(c2,s2,n2,y2);
                end
            end
        end
    end
end


% livestock

tau = max(1.8*(0.35*T_db + 0.65*T_wb)+ 32 - 74,0);
tau_sum(n,m,y_tot) = 0;
d2 = 0;
for m2 = 1:num_m
    while(d2 <= month_length(m2)-1)
        tau_sum(:,m2,:) = tau_sum(:,m2,:) + tau(:,(month_starts(m2)+d2),:);
        d2 = d2 + 1;
    end
end

eta_production(n,m,y_tot,adv) = 0;
m_harvest(c,s,n,y_tot,adv) = 0;
m_harvest(c,s,n,y_tot,1) = harvest_month;
eta_production(:,:,:,1) = 1 - alpha_dairy*tau_sum(:,:,:);

% sum tau over all of the days in each month
for y2 = 1:(num_y_tot - num_adv + 1)
    for adv2 = 2:num_adv
        m_crop(c,s,n,m,y2,adv2) = m_crop(c,s,n,m,y2+adv2-1,1);
        eta_production(n,m,y2,adv2) = eta_production(n,m,y2+adv2-1,1);
        m_harvest(c,s,n,y2,adv2) = m_harvest(c,s,n,y2+adv2-1,1);
    end
end

% distribution
C_fuel(n,n,m,y,adv) = 0;
t_ij(n,n) = 0;
t_i(n) = 0;

for n_from = 1:num_n
    for n_to = 1:num_n
        for m2 = 1:num_m
            for y2 = 1:num_y
                for adv2 = 1:num_adv
                    C_fuel(n_from,n_to,m2,y2,adv2) = p_fuel(m2,y2,adv2)*eta_fuel...
                        *(2*d_ij(n_from,n_to)/(eta_i(n_from) + eta_i(n_to))...
                        + sqrt(A_i(n_from))/eta_i(n_from)...
                        + sqrt(A_i(n_to))/eta_i(n_from));
                end
            end
        end
        t_ij(n_from,n_to) = 2*d_ij(n_from,n_to)/(v_c*((eta_i(n_from) + eta_i(n_to))));
        
    end
    t_i(n_from) = sqrt(A_i(n_from))/(v_c_internal*eta_i(n_from));
end

% calculate storage losses

t_eff(f,n,m,y,adv) = 0;

for y2 = 1:num_y
    for adv2 = 1:num_adv
        for m2 = 1:num_m
            
            if m2 == 1
                if adv2 == 1
                    if y2 ~= 1
                        t_eff(c,:,m2,y2,adv2) = t_eff(c,:,num_m,y2-1,1);
                    end
                else
                    t_eff(c,:,m2,y2,adv2) = t_eff(c,:,num_m,y2,adv2-1);
                    
                end
                
            else
                t_eff(c,:,m2,y2,adv2) = t_eff(c,:,m2-1,y2,adv2);   
            end
            
            for n2 = 1:num_n
                for c2 = 1:num_c
                    if ((m2 == (m_harvest(c2,1,n2,y2,adv2) + 1)*...
                          (m_harvest(c2,1,n2,y2,adv2)>0)) || ...
                        (m2 == (m_harvest(c2,2,n2,y2,adv2) + 1)))
                        t_eff(c2,n2,m2,y2,adv2) = 0;
                    end
                end
            end
            
            t_eff(:,:,m2,y2,adv2) = t_eff(:,:,m2,y2,adv2) ...
                + t_month*month_ratio(m2);       
        end
    end
end

r_loss_storage(f,n,m,y,adv) = 0;

for y2 = 1:num_y
    for adv2 = 1:num_adv
        for n2 = 1:num_n
            for m2 = 1:num_m
                for f2 = 1:num_f
                    
                    r_loss_storage(f2,n2,m2,y2,adv2) = 1/(1 ...
                        + exp(-10*t_eff(f2,n2,m2,y2,adv2)/(alpha_q_storage(n2)*...
                        tau_food(f2))+10));
                    
                    
                end
            end
        end
    end
end

% calculate transportation losses

t_eff_transp(f,n,n,m,y,adv) = 0;
r_loss_transp(f,n,n,m,y,adv) = 0;

for y2 = 1:num_y
    for adv2 = 1:num_adv
        for n_from = 1:num_n
            for n_to = 1:num_n
                for m2 = 1:num_m
                    for f2 = 1:num_f
                    
                        t_eff_transp(f2,n_from,n_to,m2,y2,adv2) = ...
                            t_eff(f2,n_from,m2,y2,adv2)*alpha_q_transp(n_from,n_to)/...
                            alpha_q_storage(n_from) + t_ij(n_from,n_to) ...
                            + + t_i(n_from) + t_i(n_to);
                        
                        r_loss_transp(f2,n_from,n_to,m2,y2,adv2) = 1/(1 ...
                        + exp(-10*t_eff_transp(f2,n_from,n_to,m2,y2,adv2)...
                        /(alpha_q_transp(n2)*tau_food(f2))+10));
                    
                    
                    end
                end
            end
        end
    end
end

% trim results down to num_y
eta_production = eta_production(:,:,1:num_y,:);
m_crop = m_crop(:,:,:,:,1:num_y,:);
m_harvest = m_harvest(:,:,:,1:num_y,:);

% calculate the month, in each region, that storage has to clear
m_clear = permute(max(max(m_harvest(:,:,:,:,:),[],2),[],1),[3 4 5 1 2]);
m_clear = m_clear - 1;

mu_w = rho_a'*w*rho_g;

pars.month_ratio = month_ratio;
pars.m_crop = m_crop;
pars.sowing_date = sowing_date;
pars.harvest_date = harvest_date;
pars.harvest_month = harvest_month;
pars.m_harvest = m_harvest;
pars.C_fuel = C_fuel;
pars.r_loss_transp = r_loss_transp;
pars.t_i = t_i;
pars.t_ij = t_ij;
pars.eta_production = eta_production;
pars.node_r_sf = node_r_sf;
pars.node_r_sq = node_r_sq;
pars.r_loss_storage = r_loss_storage;
pars.m_clear = m_clear;
pars.mu_w = mu_w;
pars.B_inv = B_inv;
pars.gamma_nut = gamma_nut;
pars.N_pop = N_pop;
pars.r_loss_utilization = r_loss_utilization;
pars.rho_I = rho_I;
pars.rho_a = rho_a;
pars.rho_g = rho_g;
pars.w = w;