* distribution
table
d_ij(n_from,n_to)
      1     2     3     4     5     6     7     8     9     10
1     1e6   500   500   500   500   500   500   500   500   500
2     500   1e6   500   500   500   500   500   500   500   500
3     500   500   1e6   500   500   500   500   500   500   500
4     500   500   500   1e6   500   500   500   500   500   500
5     500   500   500   500   1e6   500   500   500   500   500
6     500   500   500   500   500   1e6   500   500   500   500
7     500   500   500   500   500   500   1e6   500   500   500
8     500   500   500   500   500   500   500   1e6   500   500
9     500   500   500   500   500   500   500   500   1e6   500
10    500   500   500   500   500   500   500   500   500   1e6;

table
Delta_q_transp_capacity_max(n_from,n_to)
      1     2     3     4     5     6     7     8     9     10
1     0     1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5
2     1e5   0     1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5
3     1e5   1e5   0     1e5   1e5   1e5   1e5   1e5   1e5   1e5
4     1e5   1e5   1e5   0     1e5   1e5   1e5   1e5   1e5   1e5
5     1e5   1e5   1e5   1e5   0     1e5   1e5   1e5   1e5   1e5
6     1e5   1e5   1e5   1e5   1e5   0     1e5   1e5   1e5   1e5
7     1e5   1e5   1e5   1e5   1e5   1e5   0     1e5   1e5   1e5
8     1e5   1e5   1e5   1e5   1e5   1e5   1e5   0     1e5   1e5
9     1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5   0     1e5
10    1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5   1e5   0  ;


* having zeros on the diagonal for q_transp_max_init and
* Delta_q_transp_capacity_max ensures that there won't be any transportation
* between a node and itself


* storage

table
Delta_Q_storage_max(f,n)
                 1     2     3     4     5     6     7     8     9     10
wheat            1e3   1e3   1e3   1e3   1e3   1e3   1e3   1e3   1e3   1e3
potatoes         1e3   1e3   1e3   1e3   1e3   1e3   1e3   1e3   1e3   1e3
peppers          1e3   1e3   1e3   1e3   1e3   1e3   1e3   1e3   1e3   1e3
beef             1e3   1e3   1e3   1e3   1e3   1e3   1e3   1e3   1e3   1e3
milk             1e3   1e3   1e3   1e3   1e3   1e3   1e3   1e3   1e3   1e3  ;


* consumers
table
B(nut,nut2)
                 protein         calories        micronutrients
protein          1000            -1              10
calories         -1              0.01            0.1
micronutrients   10              0.1             1;

table
* calculate this separately and enter it in manually because GAMS doesn't do
* matrix inverses!!!
B_inv(nut,nut2)
                 protein         calories        micronutrients
protein          0               -0.5            0.05
calories         -0.5            -225            27.5
micronutrients   0.05            27.5            -2.25;

table
gamma_nut(nut,f)
                 wheat   potatoes        peppers         beef    milk
protein          0.005   0.005           0               0.026   0.01
calories         60      70              50              250     100
micronutrients   1       0.5             2               2       2;

table
w(a,g)
         male            female
0-5      0.2             0.2
6-10     0.5             0.5
11-15    0.75            0.7
16+      1               0.9;

table
A_crop_init(c,s,n)

                 1     2     3     4     5     6     7     8     9     10
wheat.belg       1e7   1e7   1e7   1e7   1e7   1e7   1e7   1e7   1e7   1e7
potatoes.belg    1e7   1e7   1e7   1e7   1e7   1e7   1e7   1e7   1e7   1e7
peppers.belg     1e6   1e6   1e6   1e6   1e6   1e6   1e6   1e6   1e6   1e6
wheat.kremt      1e7   1e7   1e7   1e7   1e7   1e7   1e7   1e7   1e7   1e7
potatoes.kremt   1e7   1e7   1e7   1e7   1e7   1e7   1e7   1e7   1e7   1e7
peppers.kremt    1e6   1e6   1e6   1e6   1e6   1e6   1e6   1e6   1e6   1e6;

table
q_food_market_init(f,I,n)
                 1     2     3     4     5     6     7     8     9     10
wheat.500        10    10    10    10    10    10    10    10    10    10
potatoes.500     10    10    10    10    10    10    10    10    10    10
peppers.500      5     5     5     5     5     5     5     5     5     5
beef.500         5     5     5     5     5     5     5     5     5     5
milk.500         5     5     5     5     5     5     5     5     5     5
wheat.1500       15    15    15    15    15    15    15    15    15    15
potatoes.1500    15    15    15    15    15    15    15    15    15    15
peppers.1500     8     8     8     8     8     8     8     8     8     8
beef.1500        8     8     8     8     8     8     8     8     8     8
milk.1500        8     8     8     8     8     8     8     8     8     8
wheat.2500       20    20    20    20    20    20    20    20    20    20
potatoes.2500    20    20    20    20    20    20    20    20    20    20
peppers.2500     10    10    10    10    10    10    10    10    10    10
beef.2500        10    10    10    10    10    10    10    10    10    10
milk.2500        10    10    10    10    10    10    10    10    10    10
;


table
q_transp_capacity_init(n_from,n_to)
      1     2     3     4     5     6     7     8     9     10
1     0     1e6   1e6   1e6   1e6   1e6   1e6   1e6   1e6   1e6
2     1e6   0     1e6   1e6   1e6   1e6   1e6   1e6   1e6   1e6
3     1e6   1e6   0     1e6   1e6   1e6   1e6   1e6   1e6   1e6
4     1e6   1e6   1e6   0     1e6   1e6   1e6   1e6   1e6   1e6
5     1e6   1e6   1e6   1e6   0     1e6   1e6   1e6   1e6   1e6
6     1e6   1e6   1e6   1e6   1e6   0     1e6   1e6   1e6   1e6
7     1e6   1e6   1e6   1e6   1e6   1e6   0     1e6   1e6   1e6
8     1e6   1e6   1e6   1e6   1e6   1e6   1e6   0     1e6   1e6
9     1e6   1e6   1e6   1e6   1e6   1e6   1e6   1e6   0     1e6
10    1e6   1e6   1e6   1e6   1e6   1e6   1e6   1e6   1e6   0;


table
Q_food_max_init(f,n)
                 1     2     3     4     5     6     7     8     9     10
wheat            1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8
potatoes         1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8
peppers          1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8
beef             1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8
milk             1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8 ;

table
Q_food_init(f,n)
                 1     2     3     4     5     6     7     8     9     10
wheat            1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8
potatoes         1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8
peppers          1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8   1e8
beef             1e7   1e7   1e7   1e7   1e7   1e7   1e7   1e7   1e7   1e7
milk             1e7   1e7   1e7   1e7   1e7   1e7   1e7   1e7   1e7   1e7 ;

