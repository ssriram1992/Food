parameters
a_nut(nut,I),
C_fuel(n_from,n_to,m,y,adv),
eta_production(n,m,y,adv),
m_crop(c,s,n,m,y,adv),
month_ratio(m),
mu_w,
node_r_sf(n),
node_r_sq(n),
p_fuel(m,y,adv),
r_loss_storage(f,m),
r_loss_transp(f,n_from,n_to),
t_i(n),
t_ij(n_from,n_to)
;

* calendrical
month_ratio(m) = month_length(m)/30;

* soil
node_r_sq(n) = sum(n_s_q(n,s_q),r_sq(s_q));
node_r_sf(n) = sum(n_s_f(n,s_f),r_sf(s_f));

$GDXIN calcd_pars.gdx
$LOAD eta_production
$LOAD m_crop
$GDXIN


* energy
* p_fuel(m,y,adv) calculated from energy model

p_fuel(m,y,adv) = 2;


* distribution
C_fuel(n_from,n_to,m,y,adv) = p_fuel(m,y,adv)*eta_fuel*(2*
         d_ij(n_from,n_to)/(eta_i(n_from) + eta_i(n_to))
         + sqrt(A_i(n_from))/eta_i(n_from)
         + sqrt(A_i(n_to))/eta_i(n_from));

t_ij(n_from,n_to) = 2*d_ij(n_from,n_to)/(v_c*((eta_i(n_from) + eta_i(n_to))));
t_i(n) = sqrt(A_i(n))/(v_c_internal*eta_i(n));

r_loss_transp(f,n_from,n_to) = 1 - exp(-log(2)*(t_ij(n_from,n_to) + t_i(n_from)
         + t_i(n_to))/(alpha_q_transp*tau_food(f)));

r_loss_storage(f,m) = 1 - exp(-log(2)*(t_month*month_ratio(m)/
         (alpha_q_storage*tau_food(f))));

a_nut(nut,I) = a_tilde_nut(nut)*sqrt(I.val);
mu_w = sum((a,g),w(a,g)*rho_a(a)*rho_g(g));
