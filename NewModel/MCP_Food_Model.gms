$ontext
*******************************************************************************
Author: Sriram Sankaranarayanan
File: MCP_Food_Model.gms
Institution: Johns Hopkins University
Contact: ssankar5@jhu.edu

All rights reserved.
You are free to distribute this code for non-profit purposes
as long as this header is kept intact
*******************************************************************************
$offtext
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
    Year "Years" /2016*2020/
    Month "Months" /1*12/
    Node "Nodes" /N1*N10/    
    Season "seasons" /belg,kremt/
    FoodItem "FoodItem" /wheat, potato, lentils, pepper, milk, beef/
    Crop(FoodItem) "Crops" /wheat, potato, lentils, pepper/
    NonCrop(FoodItem) "Animal products" /milk, beef/
    Road(Node, Node) "Transport connectivity"
;

alias(Node, NodeFrom);
alias(FoodItem, FoodItem2);
* Connecting roads in one direction only.
* Negative flow implies flow in other direction
Road(NodeFrom, Node)$(Ord(NodeFrom)<Ord(Node))=yes;

Parameter
    df(Year) "Discount factor"
;



************************************************************************
***********************       CROP PRODUCER       **********************
************************************************************************
Parameter
    df(Year) "Discount factor"
=======
*For farmers
alias(Node, Farmer);

Positive Variables
    q_Food(FoodItem, Node, Year) "quantity of Food produced"
    Area_Crop(FoodItem, Node, Year) "area allotted for each Crop"
*    Area_conv(Node, Year) "area converted to become arable"
;

* Duals
Positive Variables
d1(Node, Year)

;

Variables
pi_Food(FoodItem, Node, Year) "Price of Food item"
d2(FoodItem, Node, Year)
;

Parameters
    C_prod(Crop, Node, Year) "Cost of producing a Crop per unit area"
    C_convert(Node, Year) "Cost of converting land to make it arable"
    C_chg(Node, Year) "Penalty to change cropping pattern"
    Yield(FoodItem, Node, Year) "Yield"
    TotArea(Node) "Total Area available in the node"
    Area_init(Crop, Node) "Initial Area"
;

Equations
E1_2b(Node, Year)
E1_2c(FoodItem, Node, Year)
E1_3a(FoodItem, Node, Year)
E1_3b(Crop, Node, Year)
;

E1_2b(Node, Year).. TotArea(Node)
                    =g=
                    sum(Crop,q_Food(Crop, Node, Year));

E1_3a(FoodItem, Node, Year).. d2(FoodItem, Node, Year) - df(Year)*pi_Food(FoodItem, Node, Year)
                            =g=
                            0;
E1_3b(Crop, Node, Year).. d1(Node, Year) -d2(Crop, Node, Year) + df(Year)*(
                                C_prod(Crop, Node, Year) +
                                C_convert(Node, Year) - C_convert(Node, Year+1) +
                                C_chg(Node, Year)*(Area_Crop(Crop, Node, Year) - Area_Crop(Crop, Node, Year-1) - Area_init(Crop,Node)$(Ord(Year)=1))-
                                C_chg(Node, Year+1)*(Area_Crop(Crop, Node, Year+1) - Area_Crop(Crop, Node, Year))
                            )
                            =g=
                            0;


************************************************************************
********************       LIVESTOCK PRODUCER       ********************
************************************************************************
* Quantity, price of milk and Beef are defined as (q/pi)_Food. Similarly for yield.
Positive Variables
    q_Hide(Node, Year) "Quantity of Hide produced"
    Q_cattle(Node, Year) "Number of cattle in the herd"
    Q_cattle_sl(Node, Year) "Number of cattle slaughtered"
    Q_cattle_buy(Node, NodeFrom, Year) "Number of cattle bought from a certain node"
;
* DUal Variables
Positive Variables
    d3(Node, Year)
    d4(Node, Year)
    d9(Node, Year)
    d10(Node, Year)
;

Variable pi_cow "price of a cow";


Parameters
    pr_Hide(Node, Year) "Price of Hide"
    Yld_H(Node, Year) "Hide yield per unit slaughtered cattle"
    k(Node, Year) "Cattle birth rate"
    kappa(Node, Year) "cattle death rate"
    C_cow(Node, Year) "Cost of rearing cattle"
    C_cow_tr(Node, NodeFrom, Year) "Cost of transporting cattle"
    InitCow(Node) "Initial number of cows"
    Herdsize(Node) "Minimum herd size to be maintained"
    CowDeath(Node, Year) "Rate of cowdeath to determine Minimum number cows to slaughter"
;

Equations
E2_2b(Node, Year)
E2_2c(Node, Year)
E2_2d(Node, Year)
E2_2e(Node, Year)
E2_2f(Node, Year)
E2_3a(Node, Year)
E2_3b(NodeFrom, Node, Year)
E2_3c(Node, Year)
E2_3d(Node, Year)
;

E1_2c(FoodItem, Node, Year).. -q_Food(FoodItem, Node, Year)
                            =g=
                          -Yield(FoodItem, Node, Year)*(
                            Area_Crop(FoodItem, Node, Year)$(Crop(FoodItem))+
                            Q_cattle(Node, Year)$(sameas(FoodItem,"milk"))+
                            Q_cattle_sl(Node, Year)$(sameas(FoodItem,"beef"))
                            );

E2_2b(Node, Year).. -q_Hide(Node, Year)
                    =g=
                    -Yld_H(Node, Year)*Q_cattle_sl(Node, Year);
E2_2c(Node, Year).. -Q_cattle_sl(Node, Year) =g= -Q_cattle(Node, Year);
E2_2d(Node, Year).. -Q_cattle(Node, Year)
                    =e=
                    -((1+k(Node, Year)-kappa(Node, Year))*(Q_cattle(Node, Year-1) + InitCow(Node)$(ORD(Year)=1)) -
                                        Q_cattle_sl(Node, Year) +
                                        sum(NodeFrom, Q_cattle_buy(NodeFrom, Node, Year) - Q_cattle_buy(Node, NodeFrom, Year)));
E2_2e(Node, Year).. Q_cattle_sl(Node, Year) =g= CowDeath(Node, Year)*Q_cattle(Node, Year);
E2_2f(Node, Year).. Q_cattle(Node, Year) =g= Herdsize(Node);
E2_3a(Node, Year).. df(Year)*C_cow(Node, Year) - d2("Milk", Node, Year)*Yield("Milk", Node, Year) -
                    d4(Node, Year)+ pi_cow(Node, Year) - (1+k(Node, Year)-kappa(Node, Year))*pi_cow(Node, Year+1)
                    +CowDeath(Node, Year)*d9(Node, Year) - d10(Node, Year)
                    =g=
                    0;
E2_3b(NodeFrom, Node, Year)$(NOT(sameas(Node, NodeFrom)))..   df(Year)*( C_cow_tr(NodeFrom, Node, Year)+pi_cow(NodeFrom, Year))+
                                ( pi_cow(NodeFrom, Year)-pi_cow(Node, Year))
                                =g=
                                0;
E2_3c(Node, Year).. d3(Node, Year)-df(Year)*pr_Hide(Node, Year) =g= 0;
E2_3d(Node, Year).. d4(Node, Year) - d2("beef", Node, Year)*Yield("beef", Node, Year)-
                        d3(Node, Year)*Yld_H(Node, Year) + pi_cow(Node,Year)-d10(Node, Year)
                        =g=
                        0;


************************************************************************
***********************       DISTRIBUTORS       ***********************
************************************************************************
Positive Variables
    qF_Ds(FoodItem, Node, Year) "Quantity of Food sold by distributor"
    qF_Db(FoodItem, Node, Year) "Quantity of Food bought by distributor"
    qF_Road(FoodItem, Node, NodeFrom, Year) "Quantity of Food transported"
;
* Dual variables
Positive Variables
d6(FoodItem, Node, Year)
d7(FoodItem, NodeFrom, Node, Year)
;
Variable pi_S(FoodItem, Node, Year);
Parameters
    CF_Road(FoodItem, Node, NodeFrom, Year) "Cost of transporting food item"
    Cap_Road(FoodItem, NodeFrom, Node, Year)  "Transportation capacity"
;

Equations
E3_2b(FoodItem, Node, Year)
E3_2c(FoodItem, NodeFrom, Node, Year)
E3_3a(FoodItem, Node, Year)
E3_3b(FoodItem, NodeFrom, Node, Year)
E3_3c(FoodItem, Node, Year)
;

E3_2b(FoodItem, Node, Year).. QF_Db(FoodItem, Node, Year) + sum(NodeFrom, qF_Road(FoodItem, NodeFrom, Node, Year))
                                =g=
                                QF_Ds(FoodItem, Node, Year) + sum(NodeFrom,qF_Road(FoodItem, Node, NodeFrom, Year));
E3_2c(FoodItem, NodeFrom, Node, Year).. -qF_Road(FoodItem, NodeFrom, Node, Year)
                                        =g=
                                        -Cap_Road(FoodItem, NodeFrom, Node, Year);
E3_3a(FoodItem, Node, Year).. df(Year)*pi_Food(FoodItem, Node, Year)
                                =g=
                                d6(FoodItem, Node, Year);
E3_3b(FoodItem, NodeFrom, Node, Year).. d7(FoodItem, NodeFrom, Node, Year) + df(Year)*CF_Road(FoodItem, NodeFrom, Node, Year)
                                        =g=
                                        d6(FoodItem, Node, Year) - d6(FoodItem, NodeFrom, Year) ;
E3_3c(FoodItem, Node, Year).. d6(FoodItem, Node, Year)
                                =g=
                                df(Year)*pi_S(FoodItem, Node, Year);


************************************************************************
***********************       STORE/RETAIL       ***********************
************************************************************************
Positive Variables
    q_S(FoodItem, Node, Year) "Total quantity stored and sold"
;

Variables
pi_U(FoodItem, Node, Year)
;

* Dual
Positive Variable d8(FoodItem, Node, Year);

Parameters
    CS_L(FoodItem, Node, Year) "Cost of food storage Linear term"
    CS_Q(FoodItem, Node, Year) "Cost of food storage Quadratic term"
    CAP_Store(FoodItem, Node, Year) "Storage Capacity"
;

Equations
    E4_2a(FoodItem, Node, Year)
    E4_3a(FoodItem, Node, Year)
;
E4_2a(FoodItem, Node, Year).. -q_S(FoodItem, Node, Year) =g= -CAP_Store(FoodItem, Node, Year);
E4_3a(FoodItem, Node, Year).. pi_S(FoodItem, Node, Year) - pi_U(FoodItem, Node, Year)
                            +CS_Q(FoodItem, Node, Year)*q_S(FoodItem, Node, Year)
                            +CS_L(FoodItem, Node, Year) + d8(FoodItem, Node, Year) =g= 0;


************************************************************************
***********************       CONSUMERS       **********************
************************************************************************
Parameters
    DemSlope(FoodItem, Node, Year) "Slope of Demand curve"
    DemInt(FoodItem, Node, Year) "Intercept of demand curve"
    DemCrossTerms(FoodItem, FoodItem2, Node, Year) "Cross terms in demand curve"
;

Equations
E5_1a(FoodItem, Node, Year)
E5_1b(FoodItem, Node, Year)
E5_1c(FoodItem, Node, Year)
;

E5_1a(FoodItem, Node, Year).. q_Food(FoodItem, Node, Year) =e= qF_Db(FoodItem, Node, Year);
E5_1b(FoodItem, Node, Year).. pi_U(FoodItem, Node, Year) =e= DemInt(FoodItem, Node, Year)
                                - DemSlope(FoodItem, Node, Year)*q_S(FoodItem, Node, Year)
                                + sum(FoodItem2, DemCrossTerms(FoodItem, FoodItem2, Node, Year));
E5_1c(FoodItem, Node, Year).. q_S(FoodItem, Node, Year) =e= qF_Ds(FoodItem, Node, Year);




************************************************************************
**********************       POST-PROCESSING       *********************
************************************************************************

$INCLUDE Data.gms

Model FoodModel /
E1_2b.d1
E1_2c.d2
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
E4_3a.q_S
E5_1a.pi_Food
E5_1b.pi_U
E5_1c.pi_S
/;
execute_loadpoint 'Food';

Solve FoodModel using MCP;
execute_unload 'Food';
Display pi_Food.L, q_Food.L, pi_U.L, DemInt,q_S.L, DemSlope ,qF_Road.L;
*Display q_S.L,pi_U.L,pi_Food.L;
*Display qF_Road.L, CF_Road;
Display Q_cattle_sl.L, Q_cattle.L, Q_cattle_buy.L, Q_cattle_sl.L;
*Display Area_Crop.L, Area_init;
Parameter produce(*, Year);
produce(FoodItem, Year) = sum(Node, q_Food.L(FoodItem, Node, Year));
produce("Hide",Year) = sum(Node, q_Hide.L(Node, Year));
Display produce;
Parameter price(FoodItem, Year);
price(FoodItem, Year) = sum(Node, q_S.L(FoodItem, Node, Year)*pi_U.L(FoodItem, Node, Year))/sum(Node, q_S.L(FoodItem, Node, Year));
Display price;

Parameter FarmerPrice(*, Year);
Farmerprice("Cow",Year) = sum(Node, pi_cow.L(Node, Year))/card(Node);
Farmerprice(FoodItem, Year) = sum(Node,  q_Food.L(FoodItem, Node, Year)*pi_Food.L(FoodItem, Node, Year))/sum(Node, q_Food.L(FoodItem, Node, Year));
Display FarmerPrice;
Parameter AllFood(Node, Year);
AllFood(Node, Year) = sum(FoodItem, q_S.L(FoodItem, Node, Year));
Display AllFood;
*Display q_S.L, pi_U.L;

Parameter AllFoodProd(Node, Year);
AllFoodProd(Node, Year) = sum(FoodItem$sameas(FoodItem,"Milk"), q_Food.L(FoodItem, Node, Year));
Display AllFoodProd;

Display Area_Crop.L, q_Food.L, q_S.L, qF_Road.L;
Parameter Arable(Node, Year);
Arable(Node, Year) = sum(Crop,Area_Crop.L(Crop, Node, Year));
Display Arable ;
Arable(Node, Year) = Arable(Node, Year)/TotArea(Node);
Display Arable ;


*Display DemSlope, DemInt;
*execute_unload 'Food';
