Equations

* Analysis equations
* health
r_labour_eqn(n_active,m,adv)

* distribution
C_labour_eqn(n_from,n_to,m,adv)

* utilization
nu_working_eqn(nut,n_active,m,adv)

* MCP equations
* crop producer
L_A_crop(c,s_active,n,adv)
L_q_crop_store_C(c,n_active,m,adv)
g_crop_2(c,n_active,m,adv)
g_crop_3(n_active,adv)
h_crop_1(n_active,adv)
h_food_store(f,n_active,m,adv)
h_food_transp_buy(f,n_from,n_to,m,adv)

* livestock producer
L_q_milk_store_L(n_active,m,adv)
L_q_beef_store_L(n_active,m,adv)
L_q_cattle_transp_buy_L(n_active,n_to,m,adv)
L_q_cattle_transp_sell_L(n_from,n_active,m,adv)
L_N_cattle(n_active,m,adv)
g_livestock_1(n_active,m,adv)
g_livestock_2(n_active,m,adv)
h_livestock_1(n_active,m,adv)
h_cattle_transp_buy(n_from,n_to,m,adv)
h_cattle_transp_sell(n_from,n_to,m,adv)

* distribution
L_q_food_transp_sell_D(f,n_from,n_to,m,adv)
L_q_food_transfer_buy_D(f,n_from,n_to,m,adv)
L_q_cattle_transp_buy_D(n_from,n_to,m,adv)
L_q_cattle_transp_sell_D(n_from,n_to,m,adv)
g_distribution_1(f,n_from,n_to,m,adv)
g_distribution_2(n_from,n_to,m,adv)
g_distribution_4(n_from,n_to,m,adv)
h_food_transfer_buy(f,n_from,n_to,m,adv)
h_food_transp_sell(f,n_from,n_to,m,adv)

* storage/retail
L_q_food_market_S(f,n_active,m,adv)
L_q_food_store_S(f,n_active,m,adv)
L_q_food_transp_sell_S(f,n_from,n_active,m,adv)
L_q_food_transfer_buy_S(f,n_active,n_to,m,adv)
L_Q_food(f,n_active,m,adv)
g_storage_1(f,n_active,m,adv)
g_storage_3(f,n_active,m,adv)
g_storage_4(n_active,adv)
h_food_market(f,n_active,m,adv)
h_storage_1(f,n_active,m,adv)


* consumers
U_q_food_market_A(f,n_active,I,m,adv)

;


r_labour_eqn(n_active,m,adv)..        r_labour(n_active,m,adv)
         - exp(sum(nut,-alpha_labour(nut)*
         nu_working(nut,n_active,m,adv)/(30*month_ratio(m))))
         - 1 =e= 0;

* utilization
nu_working_eqn(nut,n_active,m,adv)..    nu_working(nut,n_active,m,adv) -
         sum(I,sum(f,gamma_nut(nut,f)*(1-r_loss_utilization)*w('16+','male')*
         q_food_market_A(f,n_active,I,m,adv)/mu_w)*rho_I(I)) =e= 0;

C_labour_eqn(n_from,n_to,m,adv)..  C_labour(n_from,n_to,m,adv)
         - p_labour*mu_transp*((r_labour(n_from,m,adv)
         + r_labour(n_to,m,adv))*t_ij(n_from,n_to)/2
         + r_labour(n_from,m,adv)*t_i(n_from)
         + r_labour(n_to,m,adv)*t_i(n_to)) =e= 0;


*Crop Producer


* Advisory equations ********
* seems to solve better when it's multiplied by -1, as done here
L_A_crop(c,s_active,n_active,adv)..  ((sum(m,r_labour(n_active,m,adv)*
         30*month_ratio(m))/365)*t_crop(c)*p_labour
         + p_fuel_ave_y(adv)*q_fuel_crop(c))
         + sum(m,p_crop(c,n_active,m,adv)*
         (-m_crop_y(c,s_active,n_active,m,adv))*
         node_r_sq(n_active)*node_r_sf(n_active))
         + p_land(n_active,adv)
         =e= 0;
*****************************

L_q_crop_store_C(c,n_active,m,adv)..  p_food_store(c,n_active,m,adv)*
         (1 + sub_producers_y(c,n_active,m,adv)) - p_crop(c,n_active,m,adv) =e= 0;

g_crop_2(c,n_active,m,adv)..  -(q_crop_store_C(c,n_active,m,adv)
         - sum(s_active,m_crop_y(c,s_active,n_active,m,adv)*
         A_crop(c,s_active,n_active,adv)*
         node_r_sq(n_active)*node_r_sf(n_active)))
         =g= 0;

g_crop_3(n_active,adv).. -(sum((c,s_active),A_crop(c,s_active,n_active,adv))
         - A_tot_init(n_active)) =g= 0;

h_food_store(f,n_active,m,adv)..   sum(fc(f,c),q_crop_store_C(c,n_active,m,adv))
         + q_milk_store_L(n_active,m,adv)$ismilk(f)
         + q_beef_store_L(n_active,m,adv)$isbeef(f)
         - q_food_store_S(f,n_active,m,adv) =e= 0;


* livestock producer
L_q_milk_store_L(n_active,m,adv)..    p_food_store('milk',n_active,m,adv)*
         (1 + sub_producers_y('milk',n_active,m,adv)) - p_milk(n_active,m,adv)
         =e= 0;

* note the divide by 1000 with respect to cattle as a unit conversion because
* the number of cattle is in thousands rather than millions
* this was done to keep p_cattle at roughly the same magnitude as the other prices
L_q_beef_store_L(n_active,m,adv)..    p_food_store('beef',n_active,m,adv)*
         (1 + sub_producers_y('beef',n_active,m,adv)) + p_hide/(r_meat*m_cow/1000)
         - p_cattle(n_active,m,adv)/(r_meat*m_cow/1000) =e= 0;

L_q_cattle_transp_buy_L(n_active,n_to,m,adv).. p_cattle_transp_buy(n_active,n_to,m,adv)
         - p_cattle(n_active,m,adv) =e= 0;

L_q_cattle_transp_sell_L(n_from,n_active,m,adv).. -p_cattle_transp_sell(n_from,n_active,m,adv)
         - p_cattle(n_active,m,adv)*(-1) =e= 0;

* Advisory equations *********
L_N_cattle(n_active,m,adv)..      -(r_feed*mu_feed*p_feed
         + r_labour(n_active,m,adv)*p_labour*t_cattle)/1000
         - p_milk(n_active,m,adv)*
         (-eta_production_y(n_active,m,adv)*r_dairy*mu_production*
         month_ratio(m)/1000) - p_herd(n_active,m,adv)*(-1)
         - p_cattle(n_active,m+1,adv)*(-1)*(1+k-kappa)
         - p_cattle(n_active,'1',adv+1)*(-1)*(1+k-kappa)$mlast(m)
         - p_cattle(n_active,m,adv)
         + sum(m2,p_cattle(n_active,m2,'3')/(card(m)))$(mlast(m) and advlast(adv))
         =e= 0;
******************************

g_livestock_1(n_active,m,adv)..       -(q_milk_store_L(n_active,m,adv)
         - eta_production_y(n_active,m,adv)*r_dairy*mu_production*month_ratio(m)*
         N_cattle(n_active,m,adv)/1000) =g= 0;

g_livestock_2(n_active,m,adv)..   N_cattle(n_active,m,adv) =g= 0;

* Advisory equations ********
h_livestock_1(n_active,m,adv)..       -(N_cattle(n_active,m,adv)
         - N_cattle(n_active,m-1,adv)*(1+k-kappa)
         - N_cattle(n_active,'12',adv-1)*(1+k-kappa)$mfirst(m)
         - N_cattle_init(n_active)*(1+k-kappa)$(mfirst(m) and advfirst(adv))
         + q_beef_store_L(n_active,m,adv)/(r_meat*m_cow/1000)
         - sum(n_from,q_cattle_transp_sell_L(n_from,n_active,m,adv))
         + sum(n_to,q_cattle_transp_buy_L(n_active,n_to,m,adv))
         ) =g= 0;
*****************************

h_cattle_transp_buy(n_active,n_to,m,adv)..    q_cattle_transp_buy_L(n_active,n_to,m,adv)
         - q_cattle_transp_buy_D(n_active,n_to,m,adv) =e= 0;

h_cattle_transp_sell(n_from,n_active,m,adv).. q_cattle_transp_sell_L(n_from,n_active,m,adv)
         - q_cattle_transp_sell_D(n_from,n_active,m,adv) =e= 0;

* distribution

L_q_food_transp_sell_D(f,n_from,n_to,m,adv)..  p_food_transp_sell(f,n_from,n_to,m,adv)
         - p_transp_eff(f,n_from,n_to,m,adv) =e= 0;

* turned this into inequality so that it would solve
L_q_food_transfer_buy_D(f,n_from,n_to,m,adv).. -(-p_food_transfer_buy(f,n_from,n_to,m,adv)
         - C_fuel_y(n_from,n_to,m,adv) - C_labour(n_from,n_to,m,adv)
         - p_transp_eff(f,n_from,n_to,m,adv)*(-1)*
         (1 - r_loss_transp_y(f,n_from,n_to,m,adv))
         - p_transp(n_from,n_to,m,adv))
         =g= 0;

* turned this into inequality so that it would solve
L_q_cattle_transp_buy_D(n_from,n_to,m,adv)..  -(
         -p_cattle_transp_buy(n_from,n_to,m,adv)
         - m_cow*(C_fuel_y(n_from,n_to,m,adv)
         + C_labour(n_from,n_to,m,adv))/1000
         - m_cow*p_transp(n_from,n_to,m,adv)/1000
         - p_transp_cattle(n_from,n_to,m,adv)*(-1)) =g= 0;

L_q_cattle_transp_sell_D(n_from,n_to,m,adv)..
         p_cattle_transp_sell(n_from,n_to,m,adv)
         - p_transp_cattle(n_from,n_to,m,adv) =e= 0;

g_distribution_1(f,n_from,n_to,m,adv)..        -(
         q_food_transp_sell_D(f,n_from,n_to,m,adv)
         - (1-r_loss_transp_y(f,n_from,n_to,m,adv))*
         q_food_transfer_buy_D(f,n_from,n_to,m,adv))
         =g= 0;

g_distribution_2(n_from,n_to,m,adv)..  -(
         sum(f,q_food_transfer_buy_D(f,n_from,n_to,m,adv))
         + m_cow*q_cattle_transp_buy_D(n_from,n_to,m,adv)/1000
         - (q_transp_capacity_init(n_from,n_to) + transp_exp_y(n_from,n_to,adv)))
         =g= 0;

g_distribution_4(n_from,n_to,m,adv)..  -(
         q_cattle_transp_sell_D(n_from,n_to,m,adv)
         - q_cattle_transp_buy_D(n_from,n_to,m,adv)) =g= 0;

h_food_transfer_buy(f,n_from,n_to,m,adv)..     q_food_transfer_buy_D(f,n_from,n_to,m,adv)
         - q_food_transfer_buy_S(f,n_from,n_to,m,adv) =e= 0;

h_food_transp_sell(f,n_from,n_to,m,adv)..      q_food_transp_sell_D(f,n_from,n_to,m,adv)
         - q_food_transp_sell_S(f,n_from,n_to,m,adv) =e= 0;



* storage/retail

L_q_food_market_S(f,n_active,m,adv)..         p_food_market(f,n_active,m,adv)
         - p_storage_food_eff(f,n_active,m,adv) =e= 0;

L_q_food_transp_sell_S(f,n_from,n_active,m,adv)..     -p_food_transp_sell(f,n_from,n_active,m,adv)
         - p_storage_food_eff(f,n_active,m,adv)*(-1) =e= 0;

L_q_food_transfer_buy_S(f,n_active,n_to,m,adv)..  p_food_transfer_buy(f,n_active,n_to,m,adv)
         - p_storage_food_eff(f,n_active,m,adv) =e= 0;

L_q_food_store_S(f,n_active,m,adv)..          -p_food_store(f,n_active,m,adv)
         - p_storage_food_eff(f,n_active,m,adv)*(-1) =e= 0;

* Advisory equations *********
L_Q_food(f,n_active,m,adv)..  -C_food(f)
         - p_storage_food(f,n_active,m,adv)
         - p_storage_empty(f,n_active,m,adv)*(-1)
         - p_clear(n_active,adv)$(m.val = m_clear_y(n_active,adv))
         - p_storage_food_eff(f,n_active,m,adv)
         - p_storage_food_eff(f,n_active,m+1,adv)*(-1)*
         (1-r_loss_storage_y(f,n_active,m+1,adv))
         - p_storage_food_eff(f,n_active,'1',adv+1)*(-1)*
         (1-r_loss_storage_y(f,n_active,'1',adv+1))$mlast(m)
         =e= 0;
*****************************

g_storage_1(f,n_active,m,adv)..       -(Q_food(f,n_active,m,adv)
         - Q_food_max_init(f,n_active)) =g= 0;

g_storage_3(f,n_active,m,adv)..  Q_food(f,n_active,m,adv) =g= 0;

g_storage_4(n_active,adv)..    Q_food_clear(n_active) - sum((f,m),
         (Q_food(f,n_active,m,adv))$(m.val = m_clear_y(n_active,adv))) =g= 0;

* Advisory equations *********
h_storage_1(f,n_active,m,adv)..       -(Q_food(f,n_active,m,adv)
         - (1 - r_loss_storage_y(f,n_active,m,adv))*(Q_food(f,n_active,m-1,adv)
         + Q_food(f,n_active,'12',adv-1)$mfirst(m)
         + Q_food_init(f,n_active)$(mfirst(m) and advfirst(adv)))
         - sum(n_from,q_food_transp_sell_S(f,n_from,n_active,m,adv))
         + sum(n_to,q_food_transfer_buy_S(f,n_active,n_to,m,adv))
         - q_food_store_S(f,n_active,m,adv)
         + q_food_market_S(f,n_active,m,adv)
         - q_food_aid_y(f,n_active,m,adv)
         ) =g= 0;
*****************************


h_food_market(f,n_active,m,adv).. q_food_market_S(f,n_active,m,adv)
         - sum(I,N_pop(n_active)*q_food_market_A(f,n_active,I,m,adv)*
         rho_I(I)) =e= 0;


* consumers

* food-specific linear demand function, using B_f instead of the inverse of B_f
* multiplying the original formulation by B_f seems to make it solve better
U_q_food_market_A(f,n_active,I,m,adv)..   -(a_food_y(f,n_active,I,m,adv)
         - q_food_market_A(f,n_active,I,m,adv)/month_ratio(m)
         - sum(f2,B_f(f,f2)*(1 - sub_consumers_y(f2,n_active,m,adv))*
         p_food_market(f2,n_active,m,adv))) =g= 0;
