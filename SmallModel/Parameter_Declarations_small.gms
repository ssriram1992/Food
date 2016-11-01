* declare and define simple parameters used in the GAMS code

parameters

*calendrical

* in days
month_starts(m)
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

* in days
month_length(m)
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

* hours in 30 days
t_month /720/




* soil parameters

r_sq(s_q)
         /1              1
          2              0.7
          3              0.4/

r_sf(s_f)
         /1              1
          2              0.7
          3              0.4/

*alpha_soil               /0.5/

* health parameters
alpha_labour(nut)
         /protein        0
          calories       0.45
          micronutrients 0/

* in meters
*d_water_init(n)
*         /1              1e-4
*          2              1e-4
*          3              1e-4
*          4              1e-4
*          5              1e-4
*          6              1e-4
*          7              1e-4
*          8              1e-4
*          9              1e-4
*          10             1e-4/


* demography parameters
* may eventually change these distributions to be joint distributions

* millions of people
N_pop(n)
         /1              2.7
          2              1.4
          3              17.2
          4              0.7
          5              0.3
          6              14.1
          7              4.4
          8              15
          9              4.3
          10             14.1/


* right now, assuming that population distributions are the same across nodes
* that won't hold, in general

* this income data comes from a log-normal distribution approximation to quintile
* income data in Ethiopia
rho_I(I)
         / low           0.5
           medium        0.3
           high          0.2/
* $/year
I_ave(I)
         / low           250
           medium        550
           high          1100/

rho_a(a)
         / 0-5           0.2
           6-10          0.15
           11-15         0.15
           16+           0.5/

rho_g(g)
         /male           0.5
          female         0.5/



* crop producer parameters

* hours per square meter
t_crop(c)
         /wheat          0.12
          potatoes       0.15
          peppers        0.18
          lentils        0.15/

* Liters per square meter
q_fuel_crop(c)
         /wheat          0.2
          potatoes       0.15
          peppers        0.25
          lentils        0.2/

* $/hour
p_labour                 /4/


* livestock parameters
* be careful with these - model is very sensitive
k                        /6e-3/
kappa                    /4e-3/
r_dairy                  /0.3/

* Liters per day
mu_production            /30/

* kg/cow
m_cow                    /500/

* $/cow
p_hide                   /1/
r_feed                   /0.1/

* kg/cow
mu_feed                  /330/

* $/kg
p_feed                   /5/
r_meat                   /0.6/

* hr/cow
t_cattle                 /5/

* distribution parameters

* km/hr
v_c                      /80/
eta_i(n)
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

* square kilometers
A_i(n)
         /1              500
          2              7.2e4
          3              1.5e5
          4              5.1e4
          5              3e4
          6              1.4e5
          7              2.8e5
          8              1.1e5
          9              4.1e4
          10             1.4e5/

* km/hr
v_c_internal             /50/

* L/km/kg
eta_fuel                 /1.6e-5/

* people/kg food
mu_transp        /1e-2/

*alpha_q_transp           /1/

* storage parameters

*alpha_q_storage          /8/

* $/kg food
C_food(f)
/wheat           0.2
potatoes         0.2
peppers          0.2
lentils          0.2
beef             1.0
milk             0.5/

* consumer parameters
* very important!!!
* these used to adjust consumption levels - demand curve intercepts
a_tilde_food(f)
/wheat           1.8
potatoes         0.65
peppers          0.85
lentils          0.25
beef             0.2
milk             0.5/


r_loss_utilization  /0.1/


* initialization values

* thousands of cattle
N_cattle_init(n)
         /1              0.5e3
          2              0.9e3
          3              13.4e3
          4              0.5e3
          5              0.3e3
          6              11.5e3
          7              0.6e3
          8              11.1e3
          9              3.6e3
          10             11.5e3/



