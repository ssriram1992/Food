* calculate simple model parameters

parameters
month_ratio(m),node_r_sq(n),node_r_sf(n),p_fuel(m,y,adv),p_fuel_ave(y,adv),
         C_fuel(n_from,n_to,m,y,adv),t_i(n),t_ij(n_from,n_to),
         mu_w,Q_food_init(f,n);

* calendrical
month_ratio(m) = month_length(m)/30;

* soil
node_r_sq(n) = sum(n_s_q(n,s_q),r_sq(s_q));
node_r_sf(n) = sum(n_s_f(n,s_f),r_sf(s_f));

* energy
* p_fuel(m,y,adv) calculated from energy model

* $/L
p_fuel(m,y,adv) = 1;
p_fuel_ave(y,adv) = 1;


* distribution
C_fuel(n_from,n_to,m,y,adv) = p_fuel(m,y,adv)*eta_fuel*(2*
         d_ij(n_from,n_to)/(eta_i(n_from) + eta_i(n_to))
         + sqrt(A_i(n_from))/eta_i(n_from)
         + sqrt(A_i(n_to))/eta_i(n_from));

* hours
t_ij(n_from,n_to) = 2*d_ij(n_from,n_to)/(v_c*((eta_i(n_from) + eta_i(n_to))));
t_i(n) = sqrt(A_i(n))/(v_c_internal*eta_i(n));

mu_w = sum((a,g),w(a,g)*rho_a(a)*rho_g(g));

* adjust the transporation capacity
q_transp_capacity_init(n_from_tot,n_to_tot) =
         q_transp_capacity_init(n_from_tot,n_to_tot)/100;

* account for increased trade with capital city
q_transp_capacity_init('1',n_to_tot) = q_transp_capacity_init('1',n_to_tot)*10;
q_transp_capacity_init(n_from_tot,'1') = q_transp_capacity_init(n_from_tot,'1')*10;

* initialize storage
Q_food_init(f,n) = 0;
Q_food_init('wheat','1') = 100;
Q_food_init('potatoes','1') = 40;
Q_food_init('peppers','1') = 50;
Q_food_init('lentils','1') = 8;
Q_food_init(f,n) = Q_food_init(f,'1')*N_pop(n);

* to represent the fact that not all of the animals are beef, dairy, or breeding
N_cattle_init(n) = N_cattle_init(n)/3;

* this is a calibration factor for consumption/prices
B_f(f,f) = B_f(f,f)/2;
