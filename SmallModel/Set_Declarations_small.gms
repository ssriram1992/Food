* declare all sets used in the GAMS code (including dynamic sets)

set
f        "food" /wheat, potatoes, peppers, lentils, beef, milk/
c(f)     "crops" /wheat, potatoes, peppers, lentils/
fc(f,c)   /#f:#c/
n        "total nodes" /1*10/

* the nodes that the model will actually be solved for
n_active(n)      active nodes /1,3,6,7/

m        "month" /1*12/
* the year starts in February and ends in January, so February = 1

adv      "advisory variables" /1*3/
* 1 is for the variables that are kept, 2 is for the first year of advisory
* variables, 3 is for the second year of advisory variables

nut      "nutrients" /protein, calories, micronutrients/
y        "year" /2001*2009/

* the nodes that the model will actually be solved for
y_active(y)      "years of interest" /2004*2006/

s_q      "soil quality" /1*3/
s_f      "soil fertility" /1*3/
g        "gender" /male,female/
s        "season" /belg, kremt/
I        "income" /low, medium, high/
a        "ages" /0-5, 6-10, 11-15, 16+/
s_active(s) "cropping season(s) of interest" /belg, kremt/

* these are actually soil quality and fertility values for each node
* necessitated by awkward GAMS syntax!!!
* the format is node.soil_quality
n_s_q(n,s_q)     /1.2
                 2.2
                 3.2
                 4.2
                 5.2
                 6.2
                 7.2
                 8.2
                 9.2
                 10.2/

* the format is node.soil_fertility
n_s_f(n,s_f)     /1.2
                 2.2
                 3.2
                 4.2
                 5.2
                 6.2
                 7.2
                 8.2
                 9.2
                 10.2/

mfirst(m)
mlast(m)
yfirst(y_active)
ylast(y_active)
advfirst(adv)
advlast(adv)
iscrop(f)
ismilk(f)
isbeef(f)
;

alias(n_active,n_from,n_to);
alias(n,n_from_tot,n_to_tot);
alias(nut,nut2);
alias(f,f2);
alias(m,m2);
alias(adv,adv2);


* beginning and end of set markers to deal with end-of-year advisory issues
mfirst(m) = yes$(ord(m) = 1);
mlast(m) = yes$(ord(m) = card(m));
yfirst(y_active) = yes$(ord(y_active) = 1);
ylast(y_active) = yes$(ord(y_active) = card(y));
advfirst(adv) = yes$(ord(adv) = 1);
advlast(adv) = yes$(ord(adv) = card(adv));
ismilk('milk') = yes;
isbeef('beef') = yes;
