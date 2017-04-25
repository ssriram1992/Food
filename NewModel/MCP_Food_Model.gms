$TITLE "INFEWS FOOD MODEL"
$offlisting
option dispwidth=60;
option savepoint=2;
option solvelink=5;
$inlinecom /* */
$offsymlist
$Offsymxref
$oninline
Option Solprint = off;
Option limrow = 0;
Option limcol = 0;

************************************************************************
***********************       COMMON INIT       ************************
************************************************************************

Sets
    Year "Years" 
    Month "Months" 
    Node "Nodes" 
    Season "seasons" 
    FoodItem "FoodItem" 
    Crop(FoodItem) "Crops" 
    NonCrop(FoodItem) "Animal products" 
    Road(Node, Node) "Transport connectivity"
;

alias(Node, NodeFrom);
alias(FoodItem, FoodItem2);
Road(NodeFrom, Node)$(Ord(NodeFrom)<Ord(Node))=yes;

************************************************************************
***********************       CROP PRODUCER       **********************
************************************************************************
Parameter
    df(Year) "Discount factor"
;

*For farmers
alias(Node, Farmer);

Positive Variables
    q_Food(FoodItem, Node, Season, Year) "quantity of Food produced"
    Area_Crop(FoodItem, Node, Season, Year) "area allotted for each Crop"
*    Area_conv(Node, Year) "area converted to become arable"
;

* Duals
Positive Variables
d1(Node, Season, Year)
d2(FoodItem, Node, Season, Year)
;

Variables
Yield_CYF(FoodItem, Node, Season, Year)
pi_Food(FoodItem, Node, Season, Year) "Price of Food item"
;

Parameters
    C_prod(Crop, Node, Year) "Cost of producing a Crop per unit area"
    C_convert(Node, Year) "Cost of converting land to make it arable"
    C_chg(Node, Year) "Penalty to change cropping pattern"
    CYF(FoodItem, Node, Season, Year) "CYF in FAO model"
    aFAO(FoodItem, Node, Season, Year) "a in FAOs yield equation"
    Elas(FoodItem, Node, Season, Year) "Elasticity"
    Yield(FoodItem, Node, Year) "Yield"
    TotArea(Node) "Total Area available in the node"
    Area_init(Crop, Node) "Initial Area"
;

Equations
E1_2b(Node, Season, Year)
E1_2cd(FoodItem, Node, Season, Year)
* Fallow Constraint
* E1_2e(Node, Year)
* Crop Rotation Constraint
* E1_2f(FoodItem, FoodItem2, Node, Year)
E1_3a(FoodItem, Node, Season, Year)
E1_3b(Crop, Node, Season, Year)
;

E1_2b(Node, Year).. TotArea(Node)
                    =g=
                    sum((Crop, Season),q_Food(Crop, Node, Season, Year));
E1_2cd(FoodItem, Node, Season, Year).. q_Food(Crop, Node, Season, Year)
            =l=
            aFAO(FoodItem, Node, Season, Year)*CYF(FoodItem, Node, Season, Year)*(1+(rPower(pi_Food(FoodItem, Node, Season, Year),Elas(FoodItem, Node, Season, Year))-1)$(Elas(FoodItem, Node, Season, Year)))*Area_Crop(FoodItem, Node, Season, Year);

E1_3a(FoodItem, Node, Season, Year).. d2(FoodItem, Node, Season, Year) - df(Year)*pi_Food(FoodItem, Node, Year)
                            =g=
                            0;
* Fallow and crop rotation costraints not yet added
E1_3b(Crop, Node, Season, Year).. d1(Node, Season, Year) 
        -d2(Crop, Node, Season, Year)*aFAO(FoodItem, Node, Season, Year)*CYF(FoodItem, Node, Season, Year)*rPower(pi_Food(FoodItem, Node, Season, Year),Elas(FoodItem, Node, Season, Year)) 
        + df(Year)*(
            C_prod(Crop, Node, Season, Year) +
            C_convert(Node, Season, Year) - C_convert(Node, Season, Year+1) +
            C_chg(Node, Season, Year)*(Area_Crop(Crop, Node, Season, Year) - Area_Crop(Crop, Node, Season, Year-1) - Area_init(Crop, Node, Season)$(Ord(Year)=1))-
            C_chg(Node, Season, Year+1)*(Area_Crop(Crop, Node, Season, Year+1) - Area_Crop(Crop, Node, Season, Year))
            )
                    =g=
            0;


************************************************************************
********************       LIVESTOCK PRODUCER       ********************
************************************************************************
* Quantity, price of milk and Beef are defined as (q/pi)_Food. Similarly for yield.
Positive Variables
    q_Hide(Node, Season, Year) "Quantity of Hide produced"
    Q_cattle(Node, Season, Year) "Number of cattle in the herd"
    Q_cattle_sl(Node, Season, Year) "Number of cattle slaughtered"
    Q_cattle_buy(Node, NodeFrom, Season, Year) "Number of cattle bought from a certain node"
;

* Dual Variables
Positive Variables
    d3(Node, Season, Year)
    d4(Node, Season, Year)
    d9(Node, Season, Year)
    d10(Node, Season, Year)
;

Variable pi_cow(Node, Season, Year) "price of a cow";


Parameters
    pr_Hide(Node, Season, Year) "Price of Hide"
    Yld_H(Node, Season, Year) "Hide yield per unit slaughtered cattle"
    k(Node, Season, Year) "Cattle birth rate"
    kappa(Node, Season, Year) "cattle death rate"
    C_cow(Node, Season, Year) "Cost of rearing cattle"
    C_cow_tr(Node, NodeFrom, Season, Year) "Cost of transporting cattle"
    InitCow(Node) "Initial number of cows"
    Herdsize(Node) "Minimum herd size to be maintained"
    CowDeath(Node, Season, Year) "Rate of cowdeath to determine Minimum number cows to slaughter"
;

Equations
E2_2b(Node, Season, Year)
E2_2c(Node, Season, Year)
E2_2d(Node, Season, Year)
E2_2e(Node, Season, Year)
E2_2f(Node, Season, Year)
E2_3a(Node, Season, Year)
E2_3b(NodeFrom, Node, Season, Year)
E2_3c(Node, Season, Year)
E2_3d(Node, Season, Year)
;

E1_2c(FoodItem, Node, Year).. -q_Food(FoodItem, Node, Year)
                            =g=
                          -Yield(FoodItem, Node, Year)*(
                            Area_Crop(FoodItem, Node, Year)$(Crop(FoodItem))+
                            Q_cattle(Node, Year)$(sameas(FoodItem,"milk"))+
                            Q_cattle_sl(Node, Year)$(sameas(FoodItem,"beef"))
                            );

E2_2b(Node, Season, Year).. -q_Hide(Node, Season, Year)
                    =g=
                    -Yld_H(Node, Season, Year)*Q_cattle_sl(Node, Season, Year);
E2_2c(Node, Season, Year).. -Q_cattle_sl(Node, Season, Year) =g= -Q_cattle(Node, Season, Year);
E2_2d(Node, Season, Year).. -Q_cattle(Node, Season, Year)
    =e=
    -((1+k(Node, Season, Year)-kappa(Node, Season, Year))*(Q_cattle(Node, Season, Year-1) + InitCow(Node)$(ORD(Year)=1)) -
    Q_cattle_sl(Node, Season, Year) +
    sum(NodeFrom, Q_cattle_buy(NodeFrom, Node, Season, Year) - Q_cattle_buy(Node, NodeFrom, Season, Year)));
E2_2e(Node, Season, Year).. Q_cattle_sl(Node, Season, Year) =g= CowDeath(Node, Season, Year)*Q_cattle(Node, Season, Year);
E2_2f(Node, Season, Year).. Q_cattle(Node, Season, Year) =g= Herdsize(Node);


E2_3a(Node, Season, Year).. df(Year)*C_cow(Node, Season, Year) - d2("Milk", Node, Season, Year)*Yield("Milk", Node, Season, Year) -
    d4(Node, Season, Year)+ pi_cow(Node, Season, Year) - (1+k(Node, Season, Year)-kappa(Node, Season, Year))*pi_cow(Node, Season, Year+1)
    +CowDeath(Node, Season, Year)*d9(Node, Season, Year) - d10(Node, Season, Year)
    =g=
    0;
E2_3b(NodeFrom, Node, Season, Year)$(NOT(sameas(Node, NodeFrom)))..   df(Year)*(C_cow_tr(NodeFrom, Node, Season, Year)+
    pi_cow(NodeFrom, Season, Year) - pi_cow(Node, Season, Year))+
    (pi_cow(NodeFrom, Season, Year)-pi_cow(Node, Season, Year))
    =g=
    0;
E2_3c(Node, Season, Year).. d3(Node, Season, Year)-df(Year)*pr_Hide(Node, Season, Year) =g= 0;
E2_3d(Node, Season, Year).. d4(Node, Season, Year) - d2("beef", Node, Season, Year)*Yield("beef", Node, Season, Year)-
        d3(Node, Season, Year)*Yld_H(Node, Season, Year) + pi_cow(Node, Season, Year)-d10(Node, Season, Year)
                        =g=
                        0;


************************************************************************
***********************       DISTRIBUTORS       ***********************
************************************************************************
Positive Variables
    qF_Ds(FoodItem, Node, Season, Year) "Quantity of Food sold by distributor"
    qF_Db(FoodItem, Node, Season, Year) "Quantity of Food bought by distributor"
    qF_Road(FoodItem, Node, NodeFrom, Season, Year) "Quantity of Food transported"
;
* Dual variables
Positive Variables
d6(FoodItem, Node, Season, Year)
d7(FoodItem, NodeFrom, Node, Season, Year)
;
Variable pi_W(FoodItem, Node, Season, Year);
Parameters
    CF_Road(FoodItem, Node, NodeFrom, Season, Year) "Cost of transporting food item"
    Cap_Road(FoodItem, NodeFrom, Node, Season, Year)  "Transportation capacity"
;

Equations
E3_2b(FoodItem, Node, Season, Year)
E3_2c(FoodItem, NodeFrom, Node, Season, Year)
E3_3a(FoodItem, Node, Season, Year)
E3_3b(FoodItem, NodeFrom, Node, Season, Year)
E3_3c(FoodItem, Node, Season, Year)
;

E3_2b(FoodItem, Node, Season, Year).. QF_Db(FoodItem, Node, Season, Year) + sum(NodeFrom, qF_Road(FoodItem, NodeFrom, Node, Season, Year))
                                =g=
                                QF_Ds(FoodItem, Node, Season, Year) + sum(NodeFrom,qF_Road(FoodItem, Node, NodeFrom, Season, Year));
E3_2c(FoodItem, NodeFrom, Node, Season, Year).. -qF_Road(FoodItem, NodeFrom, Node, Season, Year)
                                        =g=
                                        -Cap_Road(FoodItem, NodeFrom, Node, Season, Year);
E3_3a(FoodItem, Node, Season, Year).. df(Year)*pi_Food(FoodItem, Node, Season, Year)
                                =g=
                                d6(FoodItem, Node, Season, Year);
E3_3b(FoodItem, NodeFrom, Node, Season, Year).. d7(FoodItem, NodeFrom, Node, Season, Year) + df(Year)*CF_Road(FoodItem, NodeFrom, Node, Season, Year)
                                        =g=
                                        d6(FoodItem, Node, Season, Year) - d6(FoodItem, NodeFrom, Season, Year) ;
E3_3c(FoodItem, Node, Season, Year).. d6(FoodItem, Node, Season, Year)
                                =g=
                                df(Year)*pi_W(FoodItem, Node, Season, Year);


************************************************************************
***********************       STORE/RETAIL       ***********************
************************************************************************
Positive Variables
    q_W(FoodItem, Node, Season, Year) "Total quantity stored"
    q_Ws(FoodItem, Node, Season, Year) "Quantity sold"
    q_Wb(FoodItem, Node, Season, Year) "Quantity bought"
;

Variables
    pi_U(FoodItem, Node, Season, Year)
;

* Dual
Positive Variable 
    d8(FoodItem, Node, Season, Year)
    d11(FoodItem, Node, Season, Year)
;

Parameters
    CS_L(FoodItem, Node, Season, Year) "Cost of food storage Linear term"
    CS_Q(FoodItem, Node, Season, Year) "Cost of food storage Quadratic term"
    CAP_Store(FoodItem, Node, Season, Year) "Storage Capacity"
;

Equations
    E4_2a(FoodItem, Node, Season, Year)
    E4_2b(FoodItem, Node, Season, Year)
    E4_3a(FoodItem, Node, Season, Year)
    E4_3b(FoodItem, Node, Season, Year)
    E4_3c(FoodItem, Node, Season, Year)
;
E4_2a(FoodItem, Node, Season, Year).. -q_W(FoodItem, Node, Season, Year) =g= -CAP_Store(FoodItem, Node, Season, Year);
E4_2b(FoodItem, Node, Season, Year).. q_W(FoodItem, Node, Season-1, Year)$(Ord(Season)>=2) + 
        q_W(FoodItem, Node, Season + (Card(Season)-1), Year-1)$(Ord(Season)=1) + q_Wb(FoodItem, Node, Season, Year) 
        q_Ws(FoodItem, Node, Season, Year) =g= q_W(FoodItem, Node, Season, Year);

E4_3a(FoodItem, Node, Season, Year).. pi_W(FoodItem, Node, Season, Year) - d11(FoodItem, Node, Season, Year)=g= 0;
E4_3b(FoodItem, Node, Season, Year).. pi_U(FoodItem, Node, Season, Year) - d11(FoodItem, Node, Season, Year)=g= 0;

E4_3c(FoodItem, Node, Season, Year).. d8(FoodItem, Node, Season, Year)  + d11(FoodItem, Node, Season, Year)
            + CS_Q(FoodItem, Node, Season, Year)*q_W(FoodItem, Node, Season, Year)
            + CS_L(FoodItem, Node, Season, Year) + d8(FoodItem, Node, Season, Year) 
            - d11(FoodItem, Node, Season-(Card(Season)-1), Year+1)$(Ord(Season)=Card(Season)) 
            - d11(FoodItem, Node, Season+1, Year)$(Ord(Season)<>Card(Season))
            =g= 0;


************************************************************************
***********************       CONSUMERS       **********************
************************************************************************
Parameters
    DemSlope(FoodItem, Node, Year) "Slope of Demand curve"
    DemInt(FoodItem, Node, Year) "Intercept of demand curve"
    DemCrossTerms(FoodItem, FoodItem2, Node, Year) "Cross terms in demand curve"
;

Equations
E5_1a(FoodItem, Node, Season, Year)
E5_1b(FoodItem, Node, Season, Year)
E5_1c(FoodItem, Node, Season, Year)
;

E5_1a(FoodItem, Node, Season, Year).. q_Food(FoodItem, Node, Season, Year) =e= qF_Db(FoodItem, Node, Season, Year);
E5_1b(FoodItem, Node, Season, Year).. pi_U(FoodItem, Node, Season, Year) =e= DemInt(FoodItem, Node, Season, Year)
                                - DemSlope(FoodItem, Node, Season, Year)*q_Ws(FoodItem, Node, Season, Year)
                                + sum(FoodItem2, DemCrossTerms(FoodItem, FoodItem2, Node, Season, Year));
E5_1c(FoodItem, Node, Season, Year).. q_Wb(FoodItem, Node, Season, Year) =e= qF_Ds(FoodItem, Node, Season, Year);




************************************************************************
**********************       POST-PROCESSING       *********************
************************************************************************
* Load from gams data - temporary; switch to GDX using data import
*$INCLUDE ./Data/Data.gms

* Call from GDX to here
*$GDXIN DataXL
*$LOAD 
*$GDXIN

Model FoodModel /
E1_2b.d1
E1_2cd.d2
E1_3a.q_Food
E1_3b.Area_Crop
E2_2b.d3
E2_2c.d4
E2_2d.pi_cow
E2_2e.d9
E2_2f.d10
E2_3a.Q_cattle
E2_3b.Q_cattle_buy
E2_3c.q_Hide
E2_3d.Q_cattle_sl
E3_2b.d6
E3_2c.d7
E3_3a.qF_Db
E3_3b.qF_Road
E3_3c.qF_Ds
E4_2a.d8
E4_2b.d11
E4_3a.q_Wb
E4_3b.q_Ws
E4_3c.q_W
E5_1a.pi_Food
E5_1b.pi_U
E5_1c.pi_W
/;
execute_loadpoint 'FoodModel_p1';

Solve FoodModel using MCP;
execute_unload 'Food';
Display pi_Food.L, q_Food.L, pi_U.L, DemInt,q_W.L, DemSlope ,qF_Road.L;
*Display q_W.L,pi_U.L,pi_Food.L;
*Display qF_Road.L, CF_Road;
Display Q_cattle_sl.L, Q_cattle.L, Q_cattle_buy.L, Q_cattle_sl.L;
*Display Area_Crop.L, Area_init;
Parameter produce(*, Year);
produce(FoodItem, Year) = sum(Node, q_Food.L(FoodItem, Node, Year));
produce("Hide",Year) = sum(Node, q_Hide.L(Node, Year));
Display produce;
Parameter price(FoodItem, Year);
price(FoodItem, Year) = sum(Node, q_W.L(FoodItem, Node, Year)*pi_U.L(FoodItem, Node, Year))/sum(Node, q_W.L(FoodItem, Node, Year));
Display price;

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
