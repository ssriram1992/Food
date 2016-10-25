* define parameter tables for GAMS code


* distribution

* km
table
d_ij(n_from_tot,n_to_tot)
      1     2     3     4     5     6     7     8     9     10
1     0     400   300   450   500   300   750   350   600   250
2     400   0     350   650   900   700   750   800   300   600
3     300   350   0     400   650   700   900   700   300   450
4     450   650   400   0     400   750   1200  500   550   300
5     500   900   650   400   0     750   1250  350   900   350
6     300   700   700   750   750   0     600   450   850   500
7     750   750   900   1200  1250  600   0     850   1000  900
8     350   800   700   500   350   450   850   0     950   300
9     600   300   300   550   900   850   1000  950   0     700
10    250   600   450   300   350   500   900   300   700   0;


* having zeros on the diagonal for q_transp_max_init and
* ensures that there won't be any transportation between a node and itself

* million kg
table
q_transp_capacity_init(n_from_tot,n_to_tot)
      1     2     3     4     5     6     7     8     9     10
1     0     500   500   500   500   500   500   500   500   500
2     500   0     500   500   500   500   500   500   500   500
3     500   500   0     500   500   500   500   500   500   500
4     500   500   500   0     500   500   500   500   500   500
5     500   500   500   500   0     500   500   500   500   500
6     500   500   500   500   500   0     500   500   500   500
7     500   500   500   500   500   500   0     500   500   500
8     500   500   500   500   500   500   500   0     500   500
9     500   500   500   500   500   500   500   500   0     500
10    500   500   500   500   500   500   500   500   500   0;

* storage

* million kg
table
Q_food_max_init(f,n)
                 1     2     3     4     5     6     7     8     9     10
wheat            1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5
potatoes         1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5
peppers          1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5
lentils          1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5
beef             1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5
milk             1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5 ;


* consumers
table
B_f(f,f)
                 wheat   potatoes        peppers lentils beef    milk
wheat            1e-1    -1e-2           1e-3    1e-2    1e-3    1e-2
potatoes         -1e-2   1e-1            1e-3    1e-2    1e-3    1e-2
peppers          1e-3    1e-3            1e-1    1e-3    1e-3    1e-2
lentils          1e-2    1e-2            1e-3    1e-1    -1e-3   -1e-3
beef             1e-3    1e-3            1e-3    -1e-3   4e-2    1e-3
milk             1e-2    1e-2            1e-2    -1e-3   1e-3    1e-1;

* 100 g protein, 1000 kcal, or unitless micronutrient measure per kg food
table
gamma_nut(nut,f)
                 wheat   potatoes        peppers lentils beef    milk
protein          0.07    0.01            0.01    0.10    0.18    0.03
calories         3.4     0.8             0.3     3.6     3.2     0.5
micronutrients   1       0.5             2       1.5     2       2;

table
w(a,g)
         male            female
0-5      0.2             0.2
6-10     0.5             0.5
11-15    0.75            0.7
16+      1               0.9;







