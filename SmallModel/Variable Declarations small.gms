variables
* these are all free variables, even though in reality, they should all turn
* out positive

* health variables
* dimensionless
r_labour(n_active,m,adv)

* crop variables

* million kg of food
q_crop_store_C(c,n_active,m,adv)


* livestock variables

* million kg of food
q_milk_store_L(n_active,m,adv)
q_beef_store_L(n_active,m,adv)

* 1000s of cattle
q_cattle_transp_buy_L(n_from,n_to,m,adv)
q_cattle_transp_sell_L(n_from,n_to,m,adv)
N_cattle(n_active,m,adv)


* distribution variables

* million kg of food
q_food_transp_sell_D(f,n_from,n_to,m,adv)

* $/kg
C_labour(n_from,n_to,m,adv)

* 1000s of cattle
q_cattle_transp_sell_D(n_from,n_to,m,adv)

* storage variables
* million kg of food
q_food_store_S(f,n_active,m,adv)
q_food_transfer_buy_S(f,n_from,n_to,m,adv)
q_food_transp_sell_S(f,n_from,n_to,m,adv)
q_food_market_S(f,n_active,m,adv)
Q_food(f,n,m,adv)

* utilization variables
*dimensionless
nu_working(nut,n_active,m,adv)

* prices (matched with equality constraints)

* 1000s of $ per cow
p_cattle_transp_buy(n_from,n_to,m,adv)
p_cattle_transp_sell(n_from,n_to,m,adv)

* $/kg food
p_food_store(f,n_active,m,adv)
p_food_market(f,n_active,m,adv)
p_food_transp_sell(f,n_from,n_to,m,adv)
p_food_transfer_buy(f,n_from,n_to,m,adv)



positive variables

* A_crop should be free but needs to be positive
* million m^2
A_crop(c,s_active,n_active,adv)

* these are quantities matched with KKT conditions that were originally equalities
* but have been turned into inequalities
* 1000s of cattle
q_cattle_transp_buy_D(n_from,n_to,m,adv)
* million kg of food
q_food_transfer_buy_D(f,n_from,n_to,m,adv)
q_food_market_A(f,n_active,I,m,adv)


* these are prices matched with inequality constraints

* crop producer
* $/kg of crop
p_crop(c,n_active,m,adv)
* $ per million m^2 land
p_land(n_active,adv)

* livestock producer
* $/kg
p_milk(n_active,m,adv)
* 1000s of $ per cow
p_herd(n_active,m,adv)
p_cattle(n_active,m,adv)

* distributor
* $/kg
p_transp_eff(f,n_from,n_to,m,adv)
p_transp(n_from,n_to,m,adv)
* 1000s of $ per cow
p_transp_cattle(n_from,n_to,m,adv)

* storage
* $/kg food
p_storage_food(f,n_active,m,adv)
p_storage_empty(f,n,m,adv)
p_storage_food_eff(f,n_active,m,adv)
p_clear(n_active,adv)
