Sets
    Year /2015*2020/
    Node "Nodes"
    Season "seasons"
    FoodItem "FoodItem"
    Crop(FoodItem) "Crops"
    Road(Node, Node) "Transport connectivity"
    Eline(Node, Node) "Electricity Transmission"
    Adapt "Adaptation regions"
;
Alias(Year, Year2Loop);

Set Period /Period1*Period3/;

Scalar Infinity /10000/;


alias(Node, NodeFrom);
Alias(Adapt, AdaptFrom)
alias(FoodItem, FoodItem2);
alias(node, NodeTo);
Alias(Adapt, Adapt2);
Alias(Season, Season2);

Parameters
    Cyf(FoodItem, Adapt, Season, Year) "CYF in FAO model"
    Cyf_roll(FoodItem, Adapt, Season, Period) "CYF in FAO model"
    aFAO(FoodItem, Adapt, Season, Year) "a in FAOs yield equation"
    aFAO_roll(FoodItem, Adapt, Season, Period) "a in FAOs yield equation"
    Adapt2Node(Adapt, Node)
    Psi(Node, Adapt)
;

$GDXIN "..\Data\DataGdx.gdx"
* Loading sets
$LOAD Season
$LOAD Node
$LOAD FoodItem
$LOAD Crop
$LOAD Road
$LOAD Eline
$LOAD Adapt

$LOAD aFAO
$LOAD Cyf
$Load Psi
$GDXIN
Adapt2Node(Adapt, Node) = Psi(Node, Adapt);

Cyf_roll(FoodItem, Adapt, Season, Period)    = Cyf(FoodItem, Adapt, Season, '2016');
aFAO_roll(FoodItem, Adapt, Season, Period)   = aFAO(FoodItem, Adapt, Season, '2016');


Table Consum(Adapt, Season)
              'Kremt'                     'Belg'
'External'    0                           0
'A1'          1586.978075268              1582.14607411131
'H2'          623.833964840312            589.045435118967
'H3'          2116.48600048518            2106.31206290033
'H4'          948.420871863906            924.032783072188
'H5'          12.5278941335801            0
'M1'          1668.74190068307            1657.70528057372
'M3'          6107.77477360833            6104.37391925617
'M5'          357.522590876252            0
'SA1'         175.598976457272            44.9368624381807
'SA3'         3449.64995320165            3444.51861272952
'SH1'         1935.44143250912            1927.66207454197
'SH3'         4815.97259297107            4811.78369304116
'SM2'         569.478462485411            548.469769204777
'SM2N'        506.816055346369            480.97060458842
;
Table Area(Adapt, Season)
      'Kremt'             'Belg'
'A1'  1.36329889903604    0
'H2'  33.8329240517864    14.114103285943
'H3'  91.5267928602865    7.26922799534171
'H4'  49.7415570319274    2.45208873490643
'H5'  9.58261807407778    0.395267204410331
'M1'  392.51400484173     18.479715144666
'M3'  992.730995927299    15.6802791574096
'M5'  8.97446154153349    0.0728850478025403
'SA1' 21.021694512969     7.03959506541019
'SA3' 480.33282443885     10.7631643331228
'SH1' 255.084343147239    10.5118926384027
'SH3' 517.804990480402    13.8243862123744
'SM2' 27.0405865457043    3.52530952963875
'SM2N'108.03318597452     4.20738082177077
;

$INCLUDE Calibration.gms


p_area_crop(Adapt, Season) = Area(Adapt, Season);
p_q_food(Adapt, Season) = aFAO_roll('Teff', Adapt, Season, 'Period1')*Cyf_roll('Teff', Adapt, Season, 'Period1')*p_area_crop(Adapt, Season);
p_q_city_Start(Node, Season) = sum(Adapt, Adapt2Node(Adapt, Node)*p_q_food(Adapt, Season));
p_consm(Adapt, Season) = Consum(Adapt, Season)*0.99;
p_consm(Adapt, Season) = p_consm(Adapt, Season)/sum((Adapt2, Season2), p_consm(Adapt2, Season2))*sum((Adapt2, Season2), p_q_food(Adapt2, Season2));
p_q_city_End(Node, Season) = sum(Adapt, Adapt2Node(Adapt, Node)*p_consm(Adapt, Season));
Solve EstimTransp using LP min P_OBJ;



Display p_q_city_Start, p_q_city_End, Road;
Display P_STOR.L, P_TRANSP.L;