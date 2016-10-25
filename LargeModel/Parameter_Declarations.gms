parameters

*calendrical

discount /0.95/

month_starts(m) "Day of the year when the mont begins"
         /1              1
          2              29
          3              60
          4              90
          5              121
          6              151
          7              182
          8              213
          9              243
          10             274
          11             304
          12             335/
* remember that these are the days of the year for first day of the month
* for a year that starts in February

month_length(m) "Length of each month"
         /1              28
          2              31
          3              30
          4              31
          5              30
          6              31
          7              31
          8              30
          9              31
          10             30
          11             31
          12             31/

t_month /720/




* soil parameters

r_sq(s_q) "Soil quality parameter"
         /1              1
          2              0.7
          3              0.4/

r_sf(s_f) "Soil fertility parameter"
         /1              1
          2              0.7
          3              0.4/

alpha_soil      "soil water retention coefficient"         /0.5/

* health parameters
* still need this data from Matt Bee
alpha_labour(nut) "parameter relating nutrients to labour productivity"
         /protein        6e-2
          calories       1.5e-3
          micronutrients 0/

d_water_init(n) "no idea if Is this initial moisture level"
         /1              1e-4
          2              1e-4
          3              1e-4
          4              1e-4
          5              1e-4
          6              1e-4
          7              1e-4
          8              1e-4
          9              1e-4
          10             1e-4/


* demography parameters
* may change these distributions to be joint distributions

N_pop(n) "Total population in each node"
         /1              5e6
          2              6e6
          3              7e6
          4              8e6
          5              9e6
          6              1e7
          7              1.1e7
          8              1.2e7
          9              1.3e7
          10             1.4e7/

* right now, assuming that population distributions are the same across nodes
* that won't hold, in general, in the final model

rho_I(I) "Income distribution"
         / 500           0.5
           1500          0.3
           2500          0.2/

rho_a(a) "Age distribution"
         / 0-5           0.2
           6-10          0.1
           11-15         0.1
           16+           0.6/

rho_g(g) "Gender distribution"
         /male           0.5
          female         0.5/



* crop producer parameters
Delta_A_conv_max(n) "Maximum land conversion to agriculture per year"
         /1              1e3
          2              1e3
          3              1e3
          4              1e3
          5              1e3
          6              1e3
          7              1e3
          8              1e3
          9              1e3
          10             1e3/
t_crop(c) "Time required to work a particular crop"
         /wheat          100
          potatoes       120
          peppers        200/
q_fuel_crop(c) "Fuel required to work a particular crop"
         /wheat          2
          potatoes       1.5
          peppers        1/
p_labour        "Labour cost"         /10/
p_conv          "Cost to convert land for agricultural use"         /2/
p_change_crop(c) "Penalty cost for changing crop usage"
         /wheat          10
          potatoes       10
          peppers        10/

* crop parameters
rho_plant(c) "Plant density"
         /wheat          5
          potatoes       5
          peppers        5/
Delta_A_leaf_max(c) "<aximum leaf area expansion per leaf per day"
         /wheat          0.104
          potatoes       0.104
          peppers        0.104/
Delta_A_remove(c) "Dry matter of leaves removed per plant per unit development after max nos of leaves is reached"
         /wheat          0.03
          potatoes       0.03
          peppers        0.03/
alpha_1(c) "Empirical constant"
         /wheat          0.6
          potatoes       0.6
          peppers        0.6/
alpha_2(c) "Empirical constant"
         /wheat          5
          potatoes       5
          peppers        5/
Delta_N_max(c) "Maximum daily change in leaf number"
         /wheat          0.1
          potatoes       0.1
          peppers        0.1/
N_mature(c) "Leaf number at maturity"
         /wheat          12
          potatoes       12
          peppers        12/
delta_row(c) "Crop row spacing"
         /wheat          0.6
          potatoes       0.6
          peppers        0.6/
T_base(c) "Base growing temperature"
         /wheat          10
          potatoes       10
          peppers        10/

rho_SLA(c) "Specific leaf area"
         /wheat          0.028
          potatoes       0.028
          peppers        0.028/
rho_fert_x(s_nut) "no idea"
         /N              0.2
          P              0.2
          K              0.2/
I_tot(c) "degree days to fruit or seed maturity"
         /wheat          300
          potatoes       300
          peppers        300/
V_water(c) "volume of water no idea"
         /wheat          0.01
          potatoes       0.01
          peppers        0.02/

d_water_thresh    "soil moisture threshold for planting"       /0.01/
Delta_d_early     "no idea"       /5/

season_start(s)
         /belg           1
          kremt          120/

season_end(s)
         /belg           90
          kremt          210/


* livestock parameters
k                  "Percent herd growth over time"      /6e-3/
kappa              "Percent herd loss over time"      /8e-4/
r_dairy            "Percent cattle used for dairy"      /0.67/
mu_production       "Expected milk produce per cow per month"     /30/
alpha_dairy         "percent milk produce reduction coefff"     /5.3e-5/
m_cow               "Avg cow size"     /500/
p_hide              "Price of cow hide"     /500/
r_feed              "Percent cow food coming from feed"     /0.1/
mu_feed             "total food needed per cow per month"     /330/
p_feed              "price of feed"     /1/
r_meat              "fraction of cow mass that can be sold as beef"     /0.75/
t_cattle            "Labour reqd per cow per month"     /5/

* distribution parameters
v_c             "Characteristic velocity between nodes"         /80/
eta_i(n) "Transportation efficiency within node i"
         /1              0.8
          2              0.8
          3              0.8
          4              0.8
          5              0.8
          6              0.8
          7              0.8
          8              0.8
          9              0.8
          10             0.8/
A_i(n) "Area of node i"
         /1              1e5
          2              1e5
          3              1e5
          4              1e5
          5              1e5
          6              1e5
          7              1e5
          8              1e5
          9              1e5
          10             1e5/
v_c_internal     "Characteristic velocity within node"        /50/
eta_fuel     "Nominal fuel efficiency per mass of food transported"            /1.6e-5/
tau_food(f) "Half life for food spoilage"
         /wheat          6e3
          potatoes       1e3
          peppers        1e2
          beef           10
          milk           15/

p_transp_capacity "price of increasing capacity" /100/

alpha_q_transp    "Storage quality in food distribution"       /1/

* storage parameters

p_storage_food_expansion(f)
/wheat           2
potatoes         2
peppers          2
beef             10
milk             10/

alpha_q_storage          /8/

C_food(f)
/wheat            2
potatoes         2
peppers          2
beef             10
milk             10/

* consumer parameters

a_tilde_nut(nut)
/protein         3e-3
calories         300
micronutrients   3/

p_change                 /100/


r_loss_utilization  /0.9/
r_diarrhea               /0.25/

rho_diarrhea(n)
         /1              0.1
          2              0.1
          3              0.1
          4              0.1
          5              0.1
          6              0.1
          7              0.1
          8              0.1
          9              0.1
          10             0.1 /


* initialization values
A_tot_init(n)
         /1              1e8
          2              1e8
          3              1e8
          4              1e8
          5              1e8
          6              1e8
          7              1e8
          8              1e8
          9              1e8
          10             1e8/

N_cattle_init(n)
         /1              1e4
          2              1e4
          3              1e4
          4              1e4
          5              1e4
          6              1e4
          7              1e4
          8              1e4
          9              1e4
          10             1e4/



