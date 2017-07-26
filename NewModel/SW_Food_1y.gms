$TITLE "INFEWS FOOD MODEL with SOCIAL WELFARE"
$ontext
$offlisting
option dispwidth=60;
$inlinecom /* */
$offsymlist
$Offsymxref
$oninline
Option Solprint = off;
Option limrow = 0;
Option limcol = 0;
$offtext
option savepoint=2;
option solvelink=5;

************************************************************************
***********************       COMMON INIT       ************************
************************************************************************
$INCLUDE ./ControlPanel.gms
Sets
    Year "Years"
    Month "Months"
    Node "Nodes"
    Season "seasons"
    FoodItem "FoodItem"
    Crop(FoodItem) "Crops"
    NonCrop(FoodItem) "Animal products"
    Road(Node, Node) "Transport connectivity"
    Eline(Node, Node) "Electricity Transmission"
;

Scalar Infinity /10000/;


alias(Node, NodeFrom);
alias(FoodItem, FoodItem2);
*Road(NodeFrom, Node)$(Ord(NodeFrom)<Ord(Node))=yes;
*Eline(NodeFrom, Node)$(Ord(NodeFrom)<Ord(Node))=yes;


************************************************************************
**********************       INITIALIZATION       **********************
************************************************************************

Parameter
    df(Year) "Discount factor"
;

*** Crop Producer ***
Parameters
    C_prod(FoodItem, Node, Season, Year) "Cost of producing a Crop per unit area"
    C_convert(Node, Year) "Cost of converting land to make it arable"
    C_chg(Node, Year) "Penalty to change cropping pattern"
    CYF(FoodItem, Node, Season, Year) "CYF in FAO model"
    aFAO(FoodItem, Node, Season, Year) "a in FAOs yield equation"
    Elas(FoodItem, Node, Season, Year) "Elasticity"
    Yield(FoodItem, Node, Season, Year) "Yield"
    TotArea(Node) "Total Area available in the node"
    Area_init(FoodItem, Node) "Initial Area"
;

*** Livestock ***
Parameters
    pr_Hide(Node, Season, Year) "Price of Hide"
    Yld_H(Node, Season, Year) "Hide yield per unit slaughtered cattle"
    k(Node, Season, Year) "Cattle birth rate"
    kappa(Node, Season, Year) "cattle death rate"
    C_cow(Node, Season, Year) "Cost of rearing cattle"
    C_cow_tr(Node, NodeFrom, Season, Year) "Cost of transporting cattle"
    C_cow_tr1(NodeFrom, Node)
    InitCow(Node) "Initial number of cows"
    Herdsize(Node) "Minimum herd size to be maintained"
    CowDeath(Node, Season, Year) "Rate of cowdeath to determine Minimum number cows to slaughter"
;

*** Distributors ***
Parameters
    CF_Road(FoodItem, Node, NodeFrom, Season, Year) "Cost of transporting food item"
    CF_Road_data(FoodItem, Node, NodeFrom) "Data without temporal info"
    Cap_Road(FoodItem, NodeFrom, Node)  "Transportation capacity"
    Cap_Road_Tot(NodeFrom, Node)
;

*** Storage ***
Parameters
    CS_L(FoodItem, Node, Season, Year) "Cost of food storage Linear term"
    CS_Q(FoodItem, Node, Season, Year) "Cost of food storage Quadratic term"
    CAP_Store(FoodItem, Node, Season, Year) "Storage Capacity"
;

*** Consumers ***
Parameters
    DemSlope(FoodItem, Node, Season, Year) "Slope of Demand curve"
    DemInt(FoodItem, Node, Season, Year) "Intercept of demand curve"
    DemCrossTerms(FoodItem, FoodItem2, Node, Season, Year) "Cross terms in demand curve"
;

*** Electricity ***
Parameters
    C_Elec_L(Node, Season, Year) "Linear cost of electricity production"
    C_Elec_Q(Node, Season, Year) "Quadratic cost of electricity production"
    C_Elec_Trans(NodeFrom, Node, Season, Year) "Cost of Electricity transmission"
    Cap_Elec(Node, Season, Year) "Electricity production cap"
    Cap_Elec_Trans(NodeFrom, Node, Season, Year) "Electricity Transmission cap"
    Base_Elec_Dem(Node, Season, Year) "Base Demand for electricity"
;


*********************
***** Variables *****
*********************

*** Crop Producer ***
Positive Variables
    q_Food(FoodItem, Node, Season, Year) "quantity of Food produced"
    Area_Crop(FoodItem, Node, Season, Year) "area allotted for each Crop"
*    Area_conv(Node, Year) "area converted to become arable"
;
Positive Variables
    pi_Food(FoodItem, Node, Season, Year) "Price of Food item"
;

*** Livestock ***
Positive Variables
    q_Hide(Node, Season, Year) "Quantity of Hide produced"
    Q_cattle_buy(NodeFrom, Node, Season, Year) "Number of cattle bought from a certain node"
    Q_cattle(FoodItem, Node, Season, Year) "Number of cattle in the herd"
    Q_cattle_sl(Node, Season, Year) "Number of cattle slaughtered"
;
Variable pi_cow(Node, Season, Year) "price of a cow";

*** Distributors ***
Positive Variables
    qF_Ds(FoodItem, Node, Season, Year) "Quantity of Food sold by distributor"
    qF_Db(FoodItem, Node, Season, Year) "Quantity of Food bought by distributor"
    qF_Road(FoodItem, Node, NodeFrom, Season, Year) "Quantity of Food transported"
;
Variable pi_W(FoodItem, Node, Season, Year);

*** Storage ***
Positive Variables
    q_W(FoodItem, Node, Season, Year) "Total quantity stored"
    q_Ws(FoodItem, Node, Season, Year) "Quantity sold"
    q_Wb(FoodItem, Node, Season, Year) "Quantity bought"
;

Positive Variables
    pi_U(FoodItem, Node, Season, Year)
;


*** Electricity ***
Positive Variables
    q_Elec(Node, Season, Year)
    q_Elec_Trans(NodeFrom, Node, Season, Year)
    q_Elec_Dem(Node, Season, Year)
;


*** Dual Variables ***
$ontext
Positive Variables
    d1(Node, Year) "Dual to E1_2b"
    d2(FoodItem, Node, Season, Year) "Dual to E1_2cd"
    d3(Node, Season, Year) "Dual to E2_2b"
    d4(Node, Season, Year) "Dual to E2_2c"
    d6(FoodItem, Node, Season, Year) "Dual to E3_2b"
    d7(FoodItem, NodeFrom, Node, Season, Year) "Dual to E3_2c"
    d8(FoodItem, Node, Season, Year) "Dual to E4_2a"
    d9(Node, Season, Year) "Dual to E2_2e"
    d10(Node, Season, Year) "Dual to E2_2f"
    d11(FoodItem, Node, Season, Year) "Dual to E4_2b"
    d13(Node, Season, Year) "Dual to E6_2a"
    d14(Node, Season, Year) "Dual to E6_2b"
    d15(NodeFrom, Node, Season, Year) "Dual to E6_2c"
    d16(NodeFrom, Node, Season, Year) "Dual to E3_2d"
;
$offtext

************************************************************************
***********************       DATA LOADING       ***********************
************************************************************************

* Load from gams data - temporary; switch to GDX using data import
*$INCLUDE ./Data/Data.gms

*Call from GDX to here
$GDXIN Data/DataGdx1y
* Loading sets
$LOAD Year
$LOAD Season
$LOAD Node
$LOAD FoodItem
$LOAD Crop
$LOAD Road
$LOAD Eline
$LOAD df=DiscFact
$LOAD C_convert
$LOAD C_chg
$LOAD CYF
$LOAD aFAO
$LOAD C_prod
$LOAD TotArea
$LOAD Area_init

*Declaring parameters without seasonal/yearly variations and appropriating variations later

Parameters
pr_Hide1(Node, Year)
Yld_H1(Node, Year)
k1(Node, Year)
kappa1(Node, Year)
C_Cow1(Node, Year)
CowDeath1(Node)
Cap_Road1(NodeFrom, Node)
CF_Road_data1(NodeFrom, Node)
MilkYield(Node, Year)
BeefYield(Node, Year)
;


$LOAD DemInt
$LOAD DemSlope
$LOAD Base_Elec_Dem

$LOAD pr_Hide1=pr_Hide
pr_Hide(Node, Season, Year) = pr_Hide1(Node, Year);

$LOAD Yld_H1=Yld_H
Yld_H(Node, Season, Year) = Yld_H1(Node, Year);

$LOAD k1=k
k(Node, Season, Year) = k1(Node, Year);

$LOAD kappa1=kappa
kappa(Node, Season, Year) = kappa1(Node, Year);

$LOAD C_Cow1=C_Cow
C_Cow(Node, Season, Year) = C_Cow1(Node, Year);

$LOAD CowDeath1=CowDeath
CowDeath(Node, Season, Year) = CowDeath1(Node);

$LOAD CF_Road_data1=CF_Road_data
CF_Road(FoodItem, NodeFrom, Node, Season, Year) = CF_Road_data1(NodeFrom, Node);

$LOAD Cap_Road1=Cap_Road
Cap_Road(FoodItem, NodeFrom, Node) = Cap_Road1(NodeFrom, Node);

$LOAD InitCow
$LOAD Herdsize
$LOAD C_cow_tr1=CowtranYr1


$LOAD BeefYield
Yield("Beef", Node, Season, Year) = BeefYield(Node, Year);
$LOAD MilkYield
Yield("Milk", Node, Season, Year) = MilkYield(Node, Year);

$GDXIN


Elas(FoodItem, Node, Season, Year) = 0;
DemCrossTerms(FoodItem, FoodItem2, Node, Season, Year) = 0;

*These are/could be altered in the calibration file
C_Elec_L(Node, Season, Year) = 1;
C_Elec_Q(Node, Season, Year) = 1;
Cap_Elec(Node, Season, Year) = 10000;
C_Elec_Trans(NodeFrom, Node, Season, Year) = 1;
Cap_Elec_Trans(NodeFrom, Node, Season, Year) = 10000;

CS_L(FoodItem, Node, Season, Year) = 0.01;
CS_Q(FoodItem, Node, Season, Year) = 0.01;
CAP_Store(FoodItem, Node, Season, Year) = 100;

C_cow_tr(NodeFrom, Node, Season, Year) = 4;
Cap_Road_Tot(NodeFrom, Node) = 1000000;





************************************************************************
***********************       CROP PRODUCER       **********************
************************************************************************

Equations
E1_2b(Node, Year)
E1_2cd(FoodItem, Node, Season, Year)
* Fallow Constraint
* E1_2e(Node, Year)
* Crop Rotation Constraint
* E1_2f(FoodItem, FoodItem2, Node, Year)
;

E1_2b(Node, Year).. TotArea(Node)
                    =g=
                    sum((Crop, Season),q_Food(Crop, Node, Season, Year));

* Yield of livestock also defined
E1_2cd(FoodItem, Node, Season, Year).. -q_Food(FoodItem, Node, Season, Year)
            =g=
            -(aFAO(FoodItem, Node, Season, Year)*CYF(FoodItem, Node, Season, Year)*(1+(rPower(pi_Food(FoodItem, Node, Season, Year),Elas(FoodItem, Node, Season, Year))-1)$(Elas(FoodItem, Node, Season, Year)))*Area_Crop(FoodItem, Node, Season, Year))$Crop(FoodItem)
            -Yield(FoodItem, Node, Season, Year)*(
                            Q_cattle(FoodItem, Node, Season, Year)$(sameas(FoodItem,"milk"))+
                            Q_cattle_sl(Node, Season, Year)$(sameas(FoodItem,"beef"))
                            );



************************************************************************
********************       LIVESTOCK PRODUCER       ********************
************************************************************************
* Quantity, price of milk and Beef are defined as (q/pi)_Food. Similarly for yield.


Equations
    E2_2b(Node, Season, Year)
    E2_2c(Node, Season, Year)
    E2_2d(Node, Season, Year)
    E2_2e(Node, Season, Year)
    E2_2f(Node, Season, Year)
;
* Yield defined with Foodcrop

E2_2b(Node, Season, Year).. -q_Hide(Node, Season, Year)
                    =g=
                    -Yld_H(Node, Season, Year)*Q_cattle_sl(Node, Season, Year);
E2_2c(Node, Season, Year).. -Q_cattle_sl(Node, Season, Year) =g= -sum(FoodItem, Q_cattle(FoodItem, Node, Season, Year));
E2_2d(Node, Season, Year).. -sum(FoodItem, Q_cattle(FoodItem, Node, Season, Year))
    =e=
    -((1+k(Node, Season, Year)-kappa(Node, Season, Year))*(sum(FoodItem, Q_cattle(FoodItem, Node, Season, Year-1)) + InitCow(Node)$(ORD(Year)=1)) -
    Q_cattle_sl(Node, Season, Year) +
    sum(NodeFrom, Q_cattle_buy(NodeFrom, Node, Season, Year) - Q_cattle_buy(Node, NodeFrom, Season, Year)));
E2_2e(Node, Season, Year).. Q_cattle_sl(Node, Season, Year) =g= CowDeath(Node, Season, Year)*sum(FoodItem, Q_cattle(FoodItem, Node, Season, Year));
E2_2f(Node, Season, Year).. sum(FoodItem, Q_cattle(FoodItem, Node, Season, Year)) =g= Herdsize(Node);



************************************************************************
***********************       DISTRIBUTORS       ***********************
************************************************************************
Equations
    E3_2b(FoodItem, Node, Season, Year)
    E3_2c(FoodItem, NodeFrom, Node, Season, Year)
    E3_2d(NodeFrom, Node, Season, Year)
;

E3_2b(FoodItem, Node, Season, Year).. QF_Db(FoodItem, Node, Season, Year) + sum(NodeFrom$Road(NodeFrom, Node), qF_Road(FoodItem, NodeFrom, Node, Season, Year))
                                =g=
                                QF_Ds(FoodItem, Node, Season, Year) + sum(NodeFrom$Road(Node, NodeFrom),qF_Road(FoodItem, Node, NodeFrom, Season, Year));
E3_2c(FoodItem, NodeFrom, Node, Season, Year)$((FoodDistrCap AND Road(NodeFrom, Node))).. -qF_Road(FoodItem, NodeFrom, Node, Season, Year)
                                        =g=
                                        -Cap_Road(FoodItem, NodeFrom, Node);

E3_2d(NodeFrom, Node, Season, Year)$Road(NodeFrom, Node).. -sum(FoodItem,qF_Road(FoodItem, NodeFrom, Node, Season, Year))
                                        =g=
                                        -Cap_Road_Tot(NodeFrom, Node);


************************************************************************
***********************       STORE/RETAIL       ***********************
************************************************************************
Equations
    E4_2a(FoodItem, Node, Season, Year)
    E4_2b(FoodItem, Node, Season, Year)
;
E4_2a(FoodItem, Node, Season, Year).. -q_W(FoodItem, Node, Season, Year) =g= -CAP_Store(FoodItem, Node, Season, Year);
E4_2b(FoodItem, Node, Season, Year).. q_W(FoodItem, Node, Season-1, Year)$(Ord(Season)>=2) +
        q_W(FoodItem, Node, Season + (Card(Season)-1), Year-1)$(Ord(Season)=1) + q_Wb(FoodItem, Node, Season, Year)
        -q_Ws(FoodItem, Node, Season, Year) =g= q_W(FoodItem, Node, Season, Year);



************************************************************************
***********************       CONSUMERS       **********************
************************************************************************
Equations
    E5_1a(FoodItem, Node, Season, Year)
    E5_1b(FoodItem, Node, Season, Year)
    E5_1c(FoodItem, Node, Season, Year)
;

E5_1a(FoodItem, Node, Season, Year).. -q_Food(FoodItem, Node, Season, Year) =g= -qF_Db(FoodItem, Node, Season, Year);
E5_1b(FoodItem, Node, Season, Year).. pi_U(FoodItem, Node, Season, Year) =g= DemInt(FoodItem, Node, Season, Year)
                                - DemSlope(FoodItem, Node, Season, Year)*q_Ws(FoodItem, Node, Season, Year)
                                + sum(FoodItem2, DemCrossTerms(FoodItem, FoodItem2, Node, Season, Year));
E5_1c(FoodItem, Node, Season, Year).. q_Wb(FoodItem, Node, Season, Year) =e= qF_Ds(FoodItem, Node, Season, Year);



************************************************************************
************************       ELECTRICITY       ***********************
************************************************************************
Equations
    E6_2a(Node, Season, Year)
    E6_2b(Node, Season, Year)
    E6_2c(NodeFrom, Node, Season, Year)
    E_ElecDem(Node, Season, Year)
;


E6_2a(Node, Season, Year).. Cap_Elec(Node, Season, Year) =g= q_Elec(Node, Season, Year);
E6_2b(Node, Season, Year).. q_Elec(Node, Season, Year) + sum(NodeFrom$Eline(Node, NodeFrom), q_Elec_Trans(Node, NodeFrom, Season, Year))
                                 =g=
                q_Elec_Dem(Node, Season, Year)+sum(NodeFrom$Eline(NodeFrom, Node), q_Elec_Trans(NodeFrom, Node, Season, Year));
E6_2c(NodeFrom, Node, Season, Year)$Eline(NodeFrom, Node).. Cap_Elec_Trans(NodeFrom, Node, Season, Year)
                                =g=
                q_Elec_Trans(NodeFrom, Node, Season, Year);
E_ElecDem(Node, Season, Year).. q_Elec_Dem(Node, Season, Year) =g= Base_Elec_Dem(Node, Season, Year);

************************************************************************
*************************       OBJECTIVES       ***********************
************************************************************************
Equations
ObjectiveEq
;

Variable 
Objective
;


 
ObjectiveEq.. Objective =e= sum((Year, Season, Node),
*Crop production
    sum(FoodItem, C_prod(FoodItem, Node, Season, Year)*Area_Crop(FoodItem, Node, Season, Year)) +
*Livestock
    C_cow(Node, Season, Year)*sum(FoodItem, Q_cattle(FoodItem, Node, Season, Year))+
*Distribution
    sum((FoodItem, NodeFrom), CF_Road(FoodItem, Node, NodeFrom, Season, Year)*qF_Road(FoodItem, Node, NodeFrom, Season, Year))+
*Storage
    sum(FoodItem, CS_L(FoodItem, Node, Season, Year)*q_W(FoodItem, Node, Season, Year) + 0.5*CS_Q(FoodItem, Node, Season, Year)*q_W(FoodItem, Node, Season, Year)*q_W(FoodItem, Node, Season, Year))
);



************************************************************************
**********************       DATA-PROCESSING       *********************
************************************************************************

*CF_Road(FoodItem, Node, NodeFrom, Season, Year) = CF_Road_data(FoodItem, Node, NodeFrom);


Model SWFood1y / All /;


Solve SWFood1y use NLP min Objective;
execute_unload 'SWFood1y';

$ontext

************************************************************************
**********************       POST-PROCESSING       *********************
************************************************************************

$offtext

$ontext
execute_unload 'Food1y';
Display pi_Food.L, q_Food.L, pi_U.L, DemInt,q_W.L, DemSlope ,qF_Road.L;
*Display q_W.L,pi_U.L,pi_Food.L;
*Display qF_Road.L, CF_Road;
Display Q_cattle_sl.L, Q_cattle.L, Q_cattle_buy.L, Q_cattle_sl.L;
*Display Area_Crop.L, Area_init;
Parameter produce(*, Season, Year);
produce(FoodItem, Season, Year) = sum((Node), q_Food.L(FoodItem, Node, Season, Year));
produce("Hide",Season, Year) = sum(Node, q_Hide.L(Node, Season, Year));
Display produce;
Parameter price(FoodItem, Season, Year);
price(FoodItem, Season, Year) = sum(Node, q_W.L(FoodItem, Node, Season, Year)*pi_U.L(FoodItem, Node, Season, Year))/sum(Node, q_W.L(FoodItem, Node, Season, Year));
Display price;

$ontext
Parameter FarmerPrice(*, Year);
Farmerprice("Cow",Year) = sum(Node, pi_cow.L(Node, Year))/card(Node);
Farmerprice(FoodItem, Year) = sum(Node,  q_Food.L(FoodItem, Node, Year)*pi_Food.L(FoodItem, Node, Year))/sum(Node, q_Food.L(FoodItem, Node, Year));
Display FarmerPrice;
Parameter AllFood(Node, Year);
AllFood(Node, Year) = sum(FoodItem, q_W.L(FoodItem, Node, Year));
Display AllFood;
*Display q_W.L, pi_U.L;

Parameter AllFoodProd(Node, Year);
AllFoodProd(Node, Year) = sum(FoodItem$sameas(FoodItem,"Milk"), q_Food.L(FoodItem, Node, Year));
Display AllFoodProd;

Display Area_Crop.L, q_Food.L, q_W.L, qF_Road.L;
Parameter Arable(Node, Year);
Arable(Node, Year) = sum(Crop,Area_Crop.L(Crop, Node, Year));
Display Arable ;
Arable(Node, Year) = Arable(Node, Year)/TotArea(Node);
Display Arable ;


*Display DemSlope, DemInt;
*execute_unload 'Food';


$offtext
Display Year;
