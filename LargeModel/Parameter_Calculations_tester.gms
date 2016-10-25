parameters

* climate parameters
* these get inputted in from the climate model
d_precip(n,d,y), E_PAR(n,d,y), T_min(n,d,y), T_max(n,d,y),
T_mean(n,d,y), T_wb(n,d,y), T_db(n,d,y);

$CALL GDXXRW.EXE climate.xls par=d_precip rng=d_precip!A1:M3651 rdim=2 cdim=1
$GDXIN climate.gdx
$LOAD d_precip
$GDXIN

$CALL GDXXRW.EXE climate.xls par=E_PAR rng=E_PAR!A1:M3651 rdim=2 cdim=1
$GDXIN climate.gdx
$LOAD E_PAR
$GDXIN

$CALL GDXXRW.EXE climate.xls par=T_min rng=T_min!A1:M3651 rdim=2 cdim=1
$GDXIN climate.gdx
$LOAD T_min
$GDXIN

$CALL GDXXRW.EXE climate.xls par=T_max rng=T_max!A1:M3651 rdim=2 cdim=1
$GDXIN climate.gdx
$LOAD T_max
$GDXIN

$CALL GDXXRW.EXE climate.xls par=T_mean rng=T_mean!A1:M3651 rdim=2 cdim=1
$GDXIN climate.gdx
$LOAD T_mean
$GDXIN

$CALL GDXXRW.EXE climate.xls par=T_wb rng=T_wb!A1:M3651 rdim=2 cdim=1
$GDXIN climate.gdx
$LOAD T_wb
$GDXIN

$CALL GDXXRW.EXE climate.xls par=T_db rng=T_db!A1:M3651 rdim=2 cdim=1
$GDXIN climate.gdx
$LOAD T_db
$GDXIN


parameters d_water(n,d,y),p_fuel(m,y),
         r_temp(n,d,y),r_water(c,n,d,y),sowing_date(s,n,y),sowing_flag(s,n,y),
         Delta_N(c,n,d,y),N_sum(c,s,n,d,y),mature_date(c,s,n,y)
         a_plant(c,s,n,d,y),Delta_L(c,s,n,d,y),L_sum(c,s,n,d,y),
         mature_date(c,s,n,y),Y_1(c),Delta_I(c,n,d,y),I_sum(c,s,n,d,y),
         Delta_m_h(c,s,n,d,y),m_h_sum(c,s,n,d,y),m_crop(c,s,n,m,y,adv),
         harvest_date(c,s,n,y),harvest(c,s,n,y),harvest_month(c,s,n,y),
         tau(n,d,y),tau_sum(n,m,y),eta_production(n,m,y,adv),
         mature_flag(c,s,n,y),harvest_flag(c,s,n,y);


d_water(n,d,y) = 0;
loop(d,
         d_water(n,d,y) = node_r_sq(n)*d_precip(n,d,y)
                 + d_water(n,d-1,y)*node_r_sq(n)**alpha_soil
                 + (d_water(n,'365',y-1)*node_r_sq(n)**alpha_soil)$(dfirst(d))
                 + (d_water_init(n)*node_r_sq(n)**alpha_soil)$(dfirst(d)
                 and yfirst(y)););


*crops

r_temp(n,d,y) = 1 - 0.0025*(0.25*T_min(n,d,y)+ 0.75*T_max(n,d,y) - 26)*
         (0.25*T_min(n,d,y)+ 0.75*T_max(n,d,y) - 26);

r_water(c,n,d,y) = min(d_water(n,d,y)/(V_water(c)*rho_plant(c)),1);
Delta_N(c,n,d,y) = r_temp(n,d,y)*Delta_N_max(c);


* calculate sowing dates
sowing_date(s,n,y) = season_end(s);
sowing_flag(s,n,y) = 0;
loop((s,n,y),
         loop(d$((d.val > (season_start(s) + Delta_d_early))
                 and (d.val < (season_end(s) + Delta_d_early + 1))),
                 if ((d_water(n,d,y) > d_water_thresh) and (sowing_flag(s,n,y) ne 1),
                         sowing_date(s,n,y) = d.val - Delta_d_early;
                         sowing_flag(s,n,y) = 1);
         );
);

* initialize variables as necessary
N_sum(c,s,n,d,y) = 0;
L_sum(c,s,n,d,y) = 0;
m_h_sum(c,s,n,d,y) = 0;
I_sum(c,s,n,d,y) = 0;

Delta_I(c,n,d,y) = 0;
Delta_I(c,n,d,y)$((T_mean(n,d,y) > T_base(c)) and (T_mean(n,d,y) < 25)) =
         T_mean(n,d,y) - T_base(c);
Y_1(c) = 1.5 - 0.768*((delta_row(c)**2)*rho_plant(c))**0.1;

mature_flag(c,s,n,y) = 0;
harvest_flag(c,s,n,y) = 0;

loop((c,s,n,y),
         if((sowing_date(s,n,y) = season_end(s)),
                 m_crop(c,s,n,m,y,'1') = 0;
         else
*                calculate yield for that season


*                vegetative growth
*                given the sowing date for each c, n_from, track L_sum and N_sum
*                        until N_sum >= N_mature

                 loop(d,
                         if(((d.val > sowing_date(s,n,y))
                                 and (N_sum(c,s,n,d-1,y) < N_mature(c))),
                                 mature_flag(c,s,n,y) = 1;
                                 mature_date(c,s,n,y) = d.val;
                         else
                                 mature_flag(c,s,n,y) = 0;);
                         N_sum(c,s,n,d,y) = (N_sum(c,s,n,d-1,y) + Delta_N(c,n,d,y))*
                                 mature_flag(c,s,n,y);
                         a_plant(c,s,n,d,y) = exp(2*alpha_1(c)*(N_sum(c,s,n,d,y)
                                 - alpha_2(c)));
                         Delta_L(c,s,n,d,y) = r_temp(n,d,y)*r_water(c,n,d,y)*rho_plant(c)*
                                 Delta_A_leaf_max(c)*Delta_N(c,n,d,y)*a_plant(c,s,n,d,y)
                                 /(1+a_plant(c,s,n,d,y));
                         L_sum(c,s,n,d,y) = (L_sum(c,s,n,d-1,y) + Delta_L(c,s,n,d,y))*
                                 mature_flag(c,s,n,y););

* reproductive growth
* from the date at which N_sum >= N_mature, for each c, n_from, track I_sum,
*        m_h_sum, L_sum until I_sum >= I_tot

                 loop(d,
                         if(((d.val > mature_date(c,s,n,y))
                                 and (I_sum(c,s,n,d-1,y) < I_tot(c))),
                                 harvest_flag(c,s,n,y) = 1;
                                 harvest_date(c,s,n,y) = d.val;
                                 harvest(c,s,n,y) = m_h_sum(c,s,n,d,y);
                         else
                                 harvest_flag(c,s,n,y) = 0;);
                         Delta_L(c,s,n,d,y) = - rho_plant(c)*Delta_I(c,n,d,y)*
                                 Delta_A_remove(c)*rho_SLA(c);
                         L_sum(c,s,n,d,y) = (L_sum(c,s,n,d-1,y) + Delta_L(c,s,n,d,y))*
                                 harvest_flag(c,s,n,y);
                         Delta_m_h(c,s,n,d,y) = 2.1*r_water(c,n,d,y)*r_temp(n,d,y)*
                                 E_PAR(n,d,y)*(1-exp(-Y_1(c)*L_sum(c,s,n,d,y)));
                         m_h_sum(c,s,n,d,y) = (m_h_sum(c,s,n,d-1,y) + Delta_m_h(c,s,n,d,y))*harvest_flag(c,s,n,y);
                         I_sum(c,s,n,d,y) = (I_sum(c,s,n,d-1,y) + Delta_I(c,n,d,y))*
                                 harvest_flag(c,s,n,y););

* m_crop(c,n_from,t,y) = m_h_sum(c,n_from,harvest_date(c,n_from,y),y) for the
*        month 't' that d falls in

*                harvest date when I_sum >= I_tot
                 loop(m,
                         if((harvest_date(c,s,n,y) < month_starts(m)),
                         harvest_month(c,s,n,y) = m.val + 1;););

* m_crop(c,n_from,t,y) = m_h_sum(c,n_from,harvest_date(c,n_from,y),y) for the
*        month 't' that d falls in

                 m_crop(c,s,n,m,y,'1') = harvest(c,s,n,y)*
                         (m.val = harvest_month(c,s,n,y));


* this is the end of the 'else' above
         );
* this is the end of the (c,s,n,y) loop
);

m_crop(c,s,n,m,y,'2') = m_crop(c,s,n,m,y+1,'1');
m_crop(c,s,n,m,y,'3') = m_crop(c,s,n,m,y+2,'1');


* livestock
tau(n,d,y) = max(1.8*(0.25*T_db(n,d,y) + 0.65*T_wb(n,d,y)) + 32 - 74,0);
tau_sum(n,m,y) = 0;

loop((n,m,y),
         loop(d$(d.val>=month_starts(m) and d.val < (month_starts(m) + month_length(m))),
                 tau_sum(n,m,y) = tau_sum(n,m,y) + tau(n,d,y);
         );
);

* sum tau over all of the days in each month
eta_production(n,m,y,'1') = 1 - alpha_dairy*tau_sum(n,m,y);
eta_production(n,m,y,'2') = eta_production(n,m,y+1,'1');
eta_production(n,m,y,'3') = eta_production(n,m,y+2,'1');