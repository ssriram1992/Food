variables
* these are all free variables, even though in reality, they should all turn out positive

* health variables
r_labour(n,m,y,adv) "productivity reduction factor due to malnutrition"
r_labour_ave(n,y,adv)

* crop variables
A_crop(c,s,n,y,adv) "Area devoted to each crop"
Delta_A_conv(n,y,adv) "non agricultural land converted for agri"
q_crop_store_C(c,n,m,y,adv) "amount of each crop sold to storage or retail"
q_crop_transp_buy_C(c,n_from,n_to,m,y,adv) "Amount of crop sold to distribution"
A_tot(n,y,adv) "total crop area in node"


* livestock variables
q_milk_store_L(n,m,y,adv) "Amount of milk sold to storage or retail"
q_beef_store_L(n,m,y,adv) "Amount of beef sold to storage or retail"
q_milk_transp_buy_L(n_from,n_to,m,y,adv) "Amount of milk sold to distribution"
q_cattle_transp_buy_L(n_from,n_to,m,y,adv) "Number of cattle sold to distribution"
q_cattle_transp_sell_L(n_from,n_to,m,y,adv) "Number of cattle bought from distribution"
q_beef_transp_buy_L(n_from,n_to,m,y,adv) "Amount of beef sold to distribution"
N_cattle(n,m,y,adv) "Total number of cattle"


* distribution variables
q_food_transp_buy_D(f,n_from,n_to,m,y,adv) "Food bought from producer in i"
q_food_transp_sell_D(f,n_from,n_to,m,y,adv) "Food sold to storage or retail in j"
q_food_transfer_buy_D(f,n_from,n_to,m,y,adv) "Food bought from retail or storage in i"
q_cattle_transp_buy_D(n_from,n_to,m,y,adv) "Cattle bough from producer in i"
q_cattle_transp_sell_D(n_from,n_to,m,y,adv) "Cattle sold to producers in j"
C_labour(n_from,n_to,m,y,adv) "labour cost"
Delta_q_transp_capacity(n_from,n_to,m,y,adv) "Change in total transport capacity"
q_transp_capacity(n_from,n_to,m,y,adv) "Total transport capacity between nodes"

* storage variables
q_food_store_S(f,n,m,y,adv) "Amount of food purchased from producers"
q_food_transfer_buy_S(f,n_from,n_to,m,y,adv) "food sold to distributor"
q_food_transp_sell_S(f,n_from,n_to,m,y,adv) "food purchased from distributor"
Delta_Q_storage(f,n,m,y,adv) "Change in available storage"
q_food_market_S(f,n,m,y,adv) "Food sold to consumers"
Q_food(f,n,m,y,adv) "Total food stored"
Q_food_max(f,n,m,y,adv) "Maximum food storage"

* consumer variables
q_food_market_A(f,n,I,m,y,adv) "Food bought from storage or retail"

* utilization variables
nu_actual(nut,n,a,g,I,m,y,adv)
nu_working(nut,n,m,y,adv)
q_food_a_g_I(f,n,a,g,I,m,y,adv)

* prices (matched with equality constraints
p_land_exp(n,y,adv) "price of land expansion"
p_cattle(n,m,y,adv) "value of cows"
p_cattle_transp_buy(n_from,n_to,m,y,adv) "price of cattle bought from producers by distribution"
p_cattle_transp_sell(n_from,n_to,m,y,adv) "price of cattle sold to producers by distribution"
p_food_transfer_buy(f,n_from,n_to,m,y,adv) "price of food bought by distribution from storage"
p_food_transp_buy(f,n_from,n_to,m,y,adv) "price of milk bought from producers by distribution"
p_food_transp_sell(f,n_from,n_to,m,y,adv) "price of food sold by distribution to storage"
p_food_store(f,n,m,y,adv) "price of entity sold to storage by producers"
p_food_market(f,n,m,y,adv) "price of food sold to market by storage"
p_transp_exp(n_from,n_to,m,y,adv) "price of capacity expansion"
p_storage_food_eff(f,n,m,y,adv) "price of food loss and efficiency in storage"
p_storage_exp(f,n,m,y,adv) "price of storage expansion"

Positive variables
* these are prices matched with inequality constraints

* crop producer
p_exp_max(n,y,adv) "price of limit on maximum agri land expansion"
p_crop(c,n,m,y,adv) "price of crop commodity"
p_land(n,y,adv) "price of crop land"

* livestock producer
p_milk(n,m,y,adv) "price of milk produced"
p_herd(n,m,y,adv) "price of selling or slaughtering the whole herd"

* distributor
p_transp_eff(f,n_from,n_to,m,y,adv) "price of food loss vs efficiency in transport"
p_transp(n_from,n_to,m,y,adv) "price of limit on maximum transport"
p_transp_exp_max(n_from,n_to,m,y,adv) "price of limit on maximum transport expansion"
p_transp_cattle(n_from,n_to,m,y,adv) "price of transporting cattle"


* storage
p_storage_food(f,n,m,y,adv) "price of limited storage"
p_storage_exp_lim(f,n,m,y,adv) "price of limited expansion capacity"
p_storage_empty(f,n,m,y,adv) "price of having no stored food"

