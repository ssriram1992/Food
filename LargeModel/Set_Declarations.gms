set
f        "food" /wheat, potatoes, peppers, beef, milk/
c(f)     "crops" /wheat, potatoes, peppers/
fc(f,c)   /#f:#c/
n        "nodes" /1*10/
m        "months" /1*12/
* the year starts in February and ends in January, so February = 1

adv      "advisory variables" /1*3/
* 0 is for the variables that are kept, 1 is for the first year of advisory
* variables, 2 is for the second year of advisory variables
I        "income" /500, 1500, 2500/
a        "ages" /0-5, 6-10, 11-15, 16+/
nut      "nutrients" /protein, calories, micronutrients/
d        "day" /1*365/
y        "year"/2001*2011/
s_nut    "soil nutrients" /N, P, K/
s_q      "soil quality" /1*3/
s_f      "soil fertility" /1*3/
g        "gender" /male,female/
s        "season" /belg, kremt/

* these are actually calibrated soil quality and fertility values for each node
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

dfirst(d)
mfirst(m)
mlast(m)
yfirst(y)
advfirst(adv)
advlast(adv)
iscrop(f)
ismilk(f)
isbeef(f)

alias(n,n_from,n_to);
alias(nut,nut2);
alias(f,f2);


* beginning and end of set markers to deal with end-of-year advisory issues
dfirst(d) = yes$(ord(d) = 1);
mfirst(m) = yes$(ord(m) = 1);
mlast(m) = yes$(ord(m) = card(m));
yfirst(y) = yes$(ord(y) = 1);
advfirst(adv) = yes$(ord(adv) = 1);
advlast(adv) = yes$(ord(adv) = card(adv));
ismilk('milk') = yes;
isbeef('beef') = yes;
