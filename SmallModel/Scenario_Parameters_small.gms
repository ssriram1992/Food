parameters
eta_production(n,m,y,adv),m_crop(c,s,n,m,y,adv),
         r_loss_transp(f,n_from,n_to,m,y,adv),m_clear(n,y,adv),
         r_loss_storage(f,n,m,y,adv),Q_food_clear(n),A_tot_init(n),
         a_food(f,n,I,m,y,adv),q_food_aid(f,n,m,y,adv),sub_consumers(f,n,m,y,adv),
         sub_producers(f,n,m,y,adv),cash_transf(n,I,m,y,adv),
         transp_exp(n_from,n_to,y,adv);

* run MATLAB first to get calcd_pars
$GDXIN calcd_pars.gdx
$LOAD eta_production
$LOAD m_crop
$LOAD r_loss_storage
$LOAD r_loss_transp
$LOAD m_clear
$GDXIN

* the maximum amount of food they're allowed to hold over from one year to another
Q_food_clear(n) = N_pop(n)*10;

* adjust transportation capacity
q_transp_capacity_init(n_from,n_to) = q_transp_capacity_init(n_from,n_to)*8;

* total area available for crops is half of total region area unless otherwise specified
A_tot_init(n) = 0.5*A_i(n);
A_tot_init('3') = 25e3;
A_tot_init('6') = 18e3;
A_tot_init('7') = 2e3;
A_tot_init('8') = 20e3;

* Intervention measures
q_food_aid(f,n,m,y,adv) = 0;
sub_consumers(f,n,m,y,adv) = 0;
sub_producers(f,n,m,y,adv) = 0;
cash_transf(n,I,m,y,adv) = 0;
transp_exp(n_from,n_to,y,adv) = 0;

a_food(f,n,I,m,y,adv) = a_tilde_food(f)*log(I_ave(I)
         + cash_transf(n,I,m,y,adv)*card(m));
