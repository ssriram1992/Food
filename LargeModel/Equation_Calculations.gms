equations

* Analysis equations
* health
r_labour_eqn(n,m,y,adv)
r_labour_ave_eqn(n,y,adv)

* distribution
C_labour_eqn(n_from,n_to,m,y,adv)

* utilization
q_food_a_g_I_eqn(f,n,a,g,I,m,y,adv)
nu_actual_eqn(nut,n,a,g,I,m,y,adv)
nu_working_eqn(nut,n,m,y,adv)

* MCP equations
* crop producer
L_A_crop(c,s,n,y,adv)
L_Delta_A_conv(n,y,adv)
L_q_crop_store_C(c,n,m,y,adv)
L_q_crop_transp_buy_C(c,n,n_to,m,y,adv)
L_A_tot(n,y,adv)
g_crop_1(n,y,adv)
g_crop_2(c,n,m,y,adv)
g_crop_3(n,y,adv)
h_food_store(f,n,m,y,adv)
h_food_transp_buy(f,n_from,n_to,m,y,adv)
h_crop_1(n,y,adv)

* livestock producer
L_q_milk_store_L(n,m,y,adv)
L_q_milk_transp_buy_L(n,n_to,m,y,adv)
L_q_beef_store_L(n,m,y,adv)
L_q_beef_transp_buy_L(n,n_to,m,y,adv)
L_q_cattle_transp_buy_L(n,n_to,m,y,adv)
L_q_cattle_transp_sell_L(n_from,n,m,y,adv)
L_N_cattle(n,m,y,adv)
g_livestock_1(n,m,y,adv)
g_livestock_2(n,m,y,adv)
*h_milk_store(n,m,y,adv)
*h_beef_store(n,m,y,adv)
*h_milk_transp_buy(n_from,n_to,m,y,adv)
*h_beef_transp_buy(n_from,n_to,m,y,adv)
h_cattle_transp_buy(n_from,n_to,m,y,adv)
h_cattle_transp_sell(n_from,n_to,m,y,adv)
h_livestock_1(n,m,y,adv)

* distribution
L_q_food_transp_buy_D(f,n_from,n_to,m,y,adv)
L_q_food_transp_sell_D(f,n_from,n_to,m,y,adv)
L_q_food_transfer_buy_D(f,n_from,n_to,m,y,adv)
L_q_cattle_transp_buy_D(n_from,n_to,m,y,adv)
L_q_cattle_transp_sell_D(n_from,n_to,m,y,adv)
L_Delta_q_transp_capacity(n_from,n_to,m,y,adv)
L_q_transp_capacity(n_from,n_to,m,y,adv)
g_distribution_1(f,n_from,n_to,m,y,adv)
g_distribution_2(n_from,n_to,m,y,adv)
g_distribution_3(n_from,n_to,m,y,adv)
g_distribution_4(n_from,n_to,m,y,adv)
h_food_transfer_buy(f,n_from,n_to,m,y,adv)
h_food_transp_sell(f,n_from,n_to,m,y,adv)
h_distribution_1(n_from,n_to,m,y,adv)

* storage/retail
L_q_food_market_S(f,n,m,y,adv)
L_q_food_transp_sell_S(f,n_from,n,m,y,adv)
L_q_food_transfer_buy_S(f,n,n_to,m,y,adv)
L_q_food_store_S(f,n,m,y,adv)
L_Delta_Q_storage(f,n,m,y,adv)
L_Q_food_max(f,n,m,y,adv)
L_Q_food(f,n,m,y,adv)
g_storage_1(f,n,m,y,adv)
g_storage_2(f,n,m,y,adv)
g_storage_3(f,n,m,y,adv)
h_food_market(f,n,m,y,adv)
h_storage_1(f,n,m,y,adv)
h_storage_2(f,n,m,y,adv)

* consumers
U_q_food_market_A(f,n,I,m,y,adv)

;

* health
r_labour_eqn(n,m,y,adv)..        r_labour(n,m,y,adv) -
         exp(-sum(nut,alpha_labour(nut)*nu_working(nut,n,m,y,adv))) - 1 =e= 0;
r_labour_ave_eqn(n,y,adv)..      r_labour_ave(n,y,adv) -
         sum(m,r_labour(n,m,y,adv)*30*month_ratio(m))/365 =e= 0;

* utilization
q_food_a_g_I_eqn(f,n,a,g,I,m,y,adv)..    q_food_a_g_I(f,n,a,g,I,m,y,adv) -
         (1-r_loss_utilization)*w(a,g)*q_food_market_A(f,n,I,m,y,adv)/mu_w =e= 0;

nu_actual_eqn(nut,n,a,g,I,m,y,adv)..      nu_actual(nut,n,a,g,I,m,y,adv) -
         (1 - r_diarrhea*rho_diarrhea(n))*
         sum(f,gamma_nut(nut,f)*q_food_a_g_I(f,n,a,g,I,m,y,adv)) =e= 0;

nu_working_eqn(nut,n,m,y,adv)..          nu_working(nut,n,m,y,adv) -
         sum(I,nu_actual(nut,n,'16+','male',I,m,y,adv)*rho_I(I)) =e= 0;

C_labour_eqn(n_from,n_to,m,y,adv)..      C_labour(n_from,n_to,m,y,adv) -
         p_labour*((r_labour(n_from,m,y,adv)
         - r_labour(n_to,m,y,adv))*t_ij(n_from,n_to)/2
         - r_labour(n_from,m,y,adv)*t_i(n_from) + r_labour(n_to,m,y,adv)*t_i(n_to)) =e= 0;


*Crop Producer


* Advisory equations ********
L_A_crop(c,s,n,y,adv)..  -(r_labour_ave(n,y,adv)*t_crop(c)*p_labour
         + sum(m,p_fuel(m,y,adv)*month_ratio(m)*30*q_fuel_crop(c))/365)
         - p_change*(A_crop(c,s,n,y,adv) - A_crop(c,s,n,y,adv-1)
         - A_crop(c,s,n,y-1,adv)$advfirst(adv)
         - A_crop_init(c,s,n)$(advfirst(adv) and yfirst(y)))
         + discount*p_change*((A_crop(c,s,n,y,adv+1)
         - A_crop(c,s,n,y,adv))$(not advlast(adv)))
         - sum(m,p_crop(c,n,m,y,adv)*(-m_crop(c,s,n,m,y,adv))*
         node_r_sq(n)*node_r_sf(n))
         - p_land(n,y,adv) =e= 0;
*****************************

L_Delta_A_conv(n,y,adv)..        -p_conv - p_exp_max(n,y,adv)
         - p_land_exp(n,y,adv) *(-1) =e= 0;

L_q_crop_store_C(c,n,m,y,adv)..  p_food_store(c,n,m,y,adv)
         - p_crop(c,n,m,y,adv) =e= 0;

L_q_crop_transp_buy_C(c,n,n_to,m,y,adv)..        p_food_transp_buy(c,n,n_to,m,y,adv)
         - p_crop(c,n,m,y,adv) =e= 0;

* Advisory equations **********
L_A_tot(n,y,adv)..       -p_land(n,y,adv)*(-1) - p_land_exp(n,y,adv)
         - discount*p_land_exp(n,y,adv+1)*(-1) =e= 0;
*******************************

g_crop_1(n,y,adv)..      -(Delta_A_conv(n,y,adv) - Delta_A_conv_max(n)) =g= 0;

g_crop_2(c,n,m,y,adv)..  -(q_crop_store_C(c,n,m,y,adv)
         + sum(n_to, q_crop_transp_buy_C(c,n,n_to,m,y,adv))
         - sum(s,m_crop(c,s,n,m,y,adv)*A_crop(c,s,n,y,adv)*node_r_sq(n)*
         node_r_sf(n))) =g= 0;

g_crop_3(n,y,adv)..      -(sum((c,s),A_crop(c,s,n,y,adv)) - A_tot(n,y,adv)) =g= 0;

* Advisory equations *********
h_crop_1(n,y,adv)..      A_tot(n,y,adv) - A_tot(n,y,adv-1)
         - A_tot(n,y-1,adv)$advfirst(adv)
         - A_tot_init(n)$(advfirst(adv) and yfirst(y))
         - Delta_A_conv(n,y,adv) =e= 0;
******************************

h_food_store(f,n,m,y,adv)..      sum(fc(f,c),q_crop_store_C(c,n,m,y,adv))
         + q_milk_store_L(n,m,y,adv)$ismilk(f)
         + q_beef_store_L(n,m,y,adv)$isbeef(f)
         - q_food_store_S(f,n,m,y,adv) =e= 0;

h_food_transp_buy(f,n,n_to,m,y,adv)..    sum(fc(f,c),q_crop_transp_buy_C(c,n,n_to,m,y,adv))
         + q_milk_transp_buy_L(n,n_to,m,y,adv)$ismilk(f)
         + q_beef_transp_buy_L(n,n_to,m,y,adv)$isbeef(f)
         - q_food_transp_buy_D(f,n,n_to,m,y,adv) =e= 0;


* livestock producer
L_q_milk_store_L(n,m,y,adv)..    p_food_store('milk',n,m,y,adv)
         - p_milk(n,m,y,adv) =e= 0;

L_q_milk_transp_buy_L(n,n_to,m,y,adv)..  p_food_transp_buy('milk',n,n_to,m,y,adv)
         - p_milk(n,m,y,adv) =e= 0;

L_q_beef_store_L(n,m,y,adv)..    p_food_store('beef',n,m,y,adv) + p_hide
         - p_cattle(n,m,y,adv)/(r_meat*m_cow) =e= 0;

L_q_beef_transp_buy_L(n,n_to,m,y,adv)..  p_food_transp_buy('beef',n,n_to,m,y,adv)
         + p_hide - p_cattle(n,m,y,adv)/(r_meat*m_cow) =e= 0;

L_q_cattle_transp_buy_L(n,n_to,m,y,adv)..        p_cattle_transp_buy(n,n_to,m,y,adv)
         - p_cattle(n,m,y,adv) =e= 0;

L_q_cattle_transp_sell_L(n_from,n,m,y,adv)..     -p_cattle_transp_sell(n_from,n,m,y,adv)
         - p_cattle(n,m,y,adv)*(-1) =e= 0;

* Advisory equations *********
L_N_cattle(n,m,y,adv)..      -(r_feed*mu_feed*p_feed
         + r_labour(n,m,y,adv)*p_labour*t_cattle) - p_milk(n,m,y,adv)*
         (-eta_production(n,m,y,adv)*r_dairy*mu_production*month_ratio(m))
         - p_herd(n,m,y,adv)*(-1) - p_cattle(n,m+1,y,adv)*(-1)*(1+k+kappa)
         - p_cattle(n,'1',y,adv+1)*(-1)*(1+k+kappa)$mlast(m)
         - p_cattle(n,m,y,adv) =e= 0;
******************************

g_livestock_1(n,m,y,adv)..       -(q_milk_store_L(n,m,y,adv)
         + sum(n_to,q_milk_transp_buy_L(n,n_to,m,y,adv))
         - eta_production(n,m,y,adv)*r_dairy*mu_production*month_ratio(m)*
         N_cattle(n,m,y,adv)) =g= 0;

g_livestock_2(n,m,y,adv)..   N_cattle(n,m,y,adv) =g= 0;

* Advisory equations ********
h_livestock_1(n,m,y,adv)..       N_cattle(n,m,y,adv)
         - N_cattle(n,m-1,y,adv)*(1+k+kappa)
         - N_cattle(n,'12',y,adv-1)*(1+k+kappa)$mfirst(m)
         - N_cattle(n,'12',y-1,adv)*(1+k+kappa)$(mfirst(m) and advfirst(adv))
         - N_cattle_init(n)*(1+k+kappa)$(mfirst(m) and advfirst(adv) and yfirst(y))
         + q_beef_store_L(n,m,y,adv)/(r_meat*m_cow)
         + sum(n_from,q_cattle_transp_sell_L(n_from,n,m,y,adv))
         + sum(n_to,q_cattle_transp_buy_L(n,n_to,m,y,adv)
         + q_beef_transp_buy_L(n,n_to,m,y,adv)/(r_meat*m_cow)) =e= 0;
*****************************

* these are now taken care of with dynamic sets under 'crop producer'
*h_food_store('milk',n,m,y,adv)..         q_milk_store_L(n,m,y,adv)
*         - q_food_store_S('milk',n,m,y,adv) =e= 0;

*h_food_store('beef',n,m,y,adv)..         q_beef_store_L(n,m,y,adv)
*         - q_food_store_S('beef',n,m,y,adv) =e= 0;

*h_food_transp_buy('milk',n,n_to,m,y,adv)..       q_milk_transp_buy_L(n,n_to,m,y,adv)
*         - q_food_transp_buy_D('milk',n,n_to,m,y,adv) =e= 0;

*h_food_transp_buy('beef',n,n_to,m,y,adv)..       q_beef_transp_buy_L(n,n_to,m,y,adv)
*         - q_food_transp_buy_D('beef',n,n_to,m,y,adv) =e= 0;

h_cattle_transp_buy(n,n_to,m,y,adv)..    q_cattle_transp_buy_L(n,n_to,m,y,adv)
         - q_cattle_transp_buy_D(n,n_to,m,y,adv) =e= 0;

h_cattle_transp_sell(n_from,n,m,y,adv).. q_cattle_transp_sell_L(n_from,n,m,y,adv)
         - q_cattle_transp_sell_D(n_from,n,m,y,adv) =e= 0;


* distribution

L_q_food_transp_buy_D(f,n_from,n_to,m,y,adv)..   -p_food_transp_buy(f,n_from,n_to,m,y,adv)
         - C_fuel(n_from,n_to,m,y,adv) - C_labour(n_from,n_to,m,y,adv)
         - p_transp_eff(f,n_from,n_to,m,y,adv)*(-1)*(1- r_loss_transp(f,n_from,n_to))
         - p_transp(n_from,n_to,m,y,adv) =e= 0;

L_q_food_transp_sell_D(f,n_from,n_to,m,y,adv)..  p_food_transp_sell(f,n_from,n_to,m,y,adv)
         - p_transp_eff(f,n_from,n_to,m,y,adv) =e= 0;

L_q_food_transfer_buy_D(f,n_from,n_to,m,y,adv).. -p_food_transfer_buy(f,n_from,n_to,m,y,adv)
         - C_fuel(n_from,n_to,m,y,adv) - C_labour(n_from,n_to,m,y,adv)
         - p_transp_eff(f,n_from,n_to,m,y,adv)*(-1)*(1- r_loss_transp(f,n_from,n_to))
         - p_transp(n_from,n_to,m,y,adv) =e= 0;

L_q_cattle_transp_buy_D(n_from,n_to,m,y,adv)..   -p_cattle_transp_buy(n_from,n_to,m,y,adv)
         - m_cow*(C_fuel(n_from,n_to,m,y,adv) + C_labour(n_from,n_to,m,y,adv))
         - m_cow*p_transp(n_from,n_to,m,y,adv)
         - p_transp_cattle(n_from,n_to,m,y,adv)*(-1) =e= 0;

L_q_cattle_transp_sell_D(n_from,n_to,m,y,adv)..   p_cattle_transp_sell(n_from,n_to,m,y,adv)
         - m_cow*p_transp(n_from,n_to,m,y,adv)
         - p_transp_cattle(n_from,n_to,m,y,adv) =e= 0;

L_Delta_q_transp_capacity(n_from,n_to,m,y,adv)..  -p_transp_capacity
         - p_transp_exp_max(n_from,n_to,m,y,adv)
         - p_transp_exp(n_from,n_to,m,y,adv)*(-1) =e= 0;

* Advisory equations **********
L_q_transp_capacity(n_from,n_to,m,y,adv)..       -p_transp(n_from,n_to,m,y,adv)*(-1)
         - p_transp_exp(n_from,n_to,m,y,adv)
         - p_transp_exp(n_from,n_to,m+1,y,adv)*(-1)
         - p_transp_exp(n_from,n_to,'1',y,adv+1)*(-1)$mlast(m) =e= 0;
*******************************

g_distribution_1(f,n_from,n_to,m,y,adv)..        -(q_food_transp_sell_D(f,n_from,n_to,m,y,adv)
         - (1-r_loss_transp(f,n_from,n_to))*
         (q_food_transp_buy_D(f,n_from,n_to,m,y,adv)
         + q_food_transfer_buy_D(f,n_from,n_to,m,y,adv))) =g= 0;

g_distribution_2(n_from,n_to,m,y,adv)..  -(sum(f,q_food_transp_buy_D(f,n_from,n_to,m,y,adv)
         + q_food_transfer_buy_D(f,n_from,n_to,m,y,adv))
         + m_cow*q_cattle_transp_buy_D(n_from,n_to,m,y,adv)
         - q_transp_capacity(n_from,n_to,m,y,adv)) =g= 0;

g_distribution_3(n_from,n_to,m,y,adv)..  -(Delta_q_transp_capacity(n_from,n_to,m,y,adv)
         - Delta_q_transp_capacity_max(n_from,n_to)) =g= 0;

g_distribution_4(n_from,n_to,m,y,adv)..  -(q_cattle_transp_sell_D(n_from,n_to,m,y,adv)
         - q_cattle_transp_buy_D(n_from,n_to,m,y,adv)) =g= 0;

* Advisory equations ***********
h_distribution_1(n_from,n_to,m,y,adv)..  q_transp_capacity(n_from,n_to,m,y,adv)
         - q_transp_capacity(n_from,n_to,m-1,y,adv)
         - q_transp_capacity(n_from,n_to,'12',y,adv-1)$mfirst(m)
         - q_transp_capacity(n_from,n_to,'12',y-1,adv)$(mfirst(m) and advfirst(adv))
         - q_transp_capacity_init(n_from,n_to)$(mfirst(m) and advfirst(adv) and yfirst(y))
         - Delta_q_transp_capacity(n_from,n_to,m,y,adv) =e= 0;
*******************************

h_food_transfer_buy(f,n_from,n_to,m,y,adv)..     q_food_transfer_buy_D(f,n_from,n_to,m,y,adv)
         - q_food_transfer_buy_S(f,n_from,n_to,m,y,adv) =e= 0;

h_food_transp_sell(f,n_from,n_to,m,y,adv)..      q_food_transp_sell_D(f,n_from,n_to,m,y,adv)
         - q_food_transp_sell_S(f,n_from,n_to,m,y,adv) =e= 0;




* storage/retail

L_q_food_market_S(f,n,m,y,adv)..         p_food_market(f,n,m,y,adv)
         - p_storage_food_eff(f,n,m,y,adv) =e= 0;

L_q_food_transp_sell_S(f,n_from,n,m,y,adv)..     -p_food_transp_sell(f,n_from,n,m,y,adv)
         - p_storage_food_eff(f,n,m,y,adv)*(-1) =e= 0;

L_q_food_transfer_buy_S(f,n,n_to,m,y,adv)..  p_food_transp_sell(f,n,n_to,m,y,adv)
         - p_storage_food_eff(f,n,m,y,adv) =e= 0;

L_q_food_store_S(f,n,m,y,adv)..          -p_food_store(f,n,m,y,adv)
         - p_storage_food_eff(f,n,m,y,adv)*(-1) =e= 0;

L_Delta_Q_storage(f,n,m,y,adv)..         -p_storage_food_expansion(f)
         - p_storage_exp_lim(f,n,m,y,adv) - p_storage_exp(f,n,m,y,adv)*(-1) =e= 0;

* Advisory equations *********
L_Q_food_max(f,n,m,y,adv)..      -p_storage_food(f,n,m,y,adv)*(-1)
         - p_storage_exp(f,n,m,y,adv) - p_storage_exp(f,n,m+1,y,adv)*(-1)
         - p_storage_exp(f,n,'1',y,adv+1)*(-1)$mlast(m) =e= 0;
*****************************

* Advisory equations *********
L_Q_food(f,n,m,y,adv)..  -p_storage_food(f,n,m,y,adv)
         - p_storage_empty(f,n,m,y,adv)*(-1)
         - p_storage_food_eff(f,n,m,y,adv)
         - p_storage_food_eff(f,n,m+1,y,adv)*(-1)*(1-r_loss_storage(f,m+1))
         - p_storage_food_eff(f,n,'1',y,adv+1)*(-1)*
         (1-r_loss_storage(f,'1'))$mlast(m) =e= 0;
*****************************


g_storage_1(f,n,m,y,adv)..       -(Q_food(f,n,m,y,adv) - Q_food_max(f,n,m,y,adv)) =g= 0;

g_storage_2(f,n,m,y,adv)..       -(Delta_Q_storage(f,n,m,y,adv)
         - Delta_Q_storage_max(f,n)) =g= 0;

g_storage_3(f,n,m,y,adv)..       Q_food(f,n,m,y,adv) =g= 0;

* Advisory equations *********
h_storage_1(f,n,m,y,adv)..       Q_food(f,n,m,y,adv)
         - (1 - r_loss_storage(f,m))*(Q_food(f,n,m-1,y,adv)
         + Q_food(f,n,'12',y,adv-1)$mfirst(m)
         + Q_food(f,n,'12',y-1,adv)$(mfirst(m) and advfirst(adv))
         + Q_food_init(f,n)$(mfirst(m) and advfirst(adv) and yfirst(y)))
         - sum(n_from,q_food_transp_sell_S(f,n_from,n,m,y,adv))
         + sum(n_to,q_food_transfer_buy_S(f,n,n_to,m,y,adv))
         - q_food_store_S(f,n,m,y,adv) + q_food_market_S(f,n,m,y,adv) =e= 0;
*****************************

* Advisory equations *********
h_storage_2(f,n,m,y,adv)..       Q_food_max(f,n,m,y,adv)
         - Q_food_max(f,n,m-1,y,adv)
         - Q_food_max(f,n,'12',y,adv-1)$mfirst(m)
         - Q_food_max(f,n,'12',y-1,adv)$(mfirst(m) and advfirst(adv))
         - Q_food_max_init(f,n)$(mfirst(m) and advfirst(adv) and yfirst(y))
         + Delta_Q_storage_max(f,n) =e= 0;
*****************************

h_food_market(f,n,m,y,adv).. q_food_market_S(f,n,m,y,adv)
         - sum(I,N_pop(n)*q_food_market_A(f,n,I,m,y,adv)*rho_I(I)) =e= 0;


* consumers

* Advisory equations *********
*U_q_food_market_A(f,n,I,m,y,adv)..   sum((nut,nut2),gamma_nut(nut,f)*
*         B_inv(nut,nut2)*a_nut(nut2,I)) - (1/month_ratio(m))*
*         sum((nut,nut2,f2),gamma_nut(nut,f)*B_inv(nut,nut2)*gamma_nut(nut2,f2)*
*         q_food_market_A(f,n,I,m,y,adv)) - p_food_market(f,n,m,y,adv)
*         - p_change*(q_food_market_A(f,n,I,m,y,adv)/(month_ratio(m)*month_ratio(m))
*         - q_food_market_A(f,n,I,m-1,y,adv)/(month_ratio(m)*month_ratio(m-1))
*         - q_food_market_A(f,n,I,'12',y,adv-1)
*         /(month_ratio(m)*month_ratio('12'))$mfirst(m)
*         - q_food_market_A(f,n,I,'12',y-1,adv)
*         /(month_ratio(m)*month_ratio('12'))$(mfirst(m) and advfirst(adv))
*         - q_food_market_init(f,I,n)
*         /(month_ratio(m)*month_ratio('12'))$(mfirst(m) and advfirst(adv) and yfirst(y))
*         + q_food_market_A(f,n,I,m,y,adv)/(month_ratio(m)*month_ratio(m))
*         - q_food_market_A(f,n,I,m+1,y,adv)
*         /(month_ratio(m)*month_ratio(m+1))
*         - q_food_market_A(f,n,I,'1',y,adv+1)
*         /(month_ratio(m)*month_ratio('1'))$mlast(m)) =e= 0;

U_q_food_market_A(f,n,I,m,y,adv)..   sum((nut,nut2),gamma_nut(nut,f)*
         B_inv(nut,nut2)*a_nut(nut2,I))
         - sum((nut,nut2,f2),gamma_nut(nut,f)*B_inv(nut,nut2)*gamma_nut(nut2,f2)*
         q_food_market_A(f,n,I,m,y,adv)) - p_food_market(f,n,m,y,adv)
         - p_change*(q_food_market_A(f,n,I,m,y,adv)
         - q_food_market_A(f,n,I,m-1,y,adv)
         - q_food_market_A(f,n,I,'12',y,adv-1)
         - q_food_market_A(f,n,I,'12',y-1,adv)
         - q_food_market_init(f,I,n)
         + q_food_market_A(f,n,I,m,y,adv)
         - q_food_market_A(f,n,I,m+1,y,adv)
         - q_food_market_A(f,n,I,'1',y,adv+1)) =e= 0;
*****************************

