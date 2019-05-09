$TITLE "INFEWS FOOD MODEL"

************************************************************************
************************       SETTINGS       **************************
************************************************************************

$SETGLOBAL Detailed_Listing ""
$SETGLOBAL RunningOnCluster "*"

$SETGLOBAL Scenario "DemCalib2"

$SETGLOBAL DataFile "Data/DataGdx"

$SETGLOBAL Point "%Scenario%"


%Detailed_Listing%$ontext
$offlisting
option dispwidth=60;
$inlinecom /* */
$offsymlist
$Offsymxref
$oninline
Option Solprint = off;
Option limrow = 0;
Option limcol = 0;
$ontext
$offtext
%RunningOnCluster%option solvelink=5;

************************************************************************
***********************       COMMON INIT       ************************
************************************************************************
$INCLUDE Data/ControlPanel.gms
Sets
    Year "Years" /2015*2015/
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
    Area_init(Node, Season,  FoodItem) "Initial Area"
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
    q_WInit(FoodItem, Node)
;

*** Consumers ***
Parameters
    Consumption(FoodItem, Node, Season, Year) "Target Consumption"
    DemElas(FoodItem) "Demand Elasticity"
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
Variables
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

Variables
    pi_U(FoodItem, Node, Season, Year)
;


*** Electricity ***
Positive Variables
    q_Elec(Node, Season, Year)
    q_Elec_Trans(NodeFrom, Node, Season, Year)
    q_Elec_Dem(Node, Season, Year)
;

Variables
    d6(FoodItem, Node, Season, Year) "Dual to E3_2b"
    d11(FoodItem, Node, Season, Year) "Dual to E4_2b"
;


*** Dual Variables ***
Positive Variables
    d1(Node, Year) "Dual to E1_2b"
    d2(FoodItem, Node, Season, Year) "Dual to E1_2cd"
    d3(Node, Season, Year) "Dual to E2_2b"
    d4(Node, Season, Year) "Dual to E2_2c"
    d7(FoodItem, NodeFrom, Node, Season, Year) "Dual to E3_2c"
    d8(FoodItem, Node, Season, Year) "Dual to E4_2a"
    d9(Node, Season, Year) "Dual to E2_2e"
    d10(Node, Season, Year) "Dual to E2_2f"
    d13(Node, Season, Year) "Dual to E6_2a"
    d14(Node, Season, Year) "Dual to E6_2b"
    d15(NodeFrom, Node, Season, Year) "Dual to E6_2c"
    d16(NodeFrom, Node, Season, Year) "Dual to E3_2d"
;

************************************************************************
***********************       DATA LOADING       ***********************
************************************************************************

* Load from gams data - temporary; switch to GDX using data import
*$INCLUDE ./Data/Data.gms

*Call from GDX to here
*$if exist DemCalib.gdx
*$if not exist DemCalib.gdx
$GDXIN %DataFile%
* Loading sets
*$LOAD Year
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
Display TotArea;
$LOAD Area_init
$LOAD Consumption
$LOAD DemElas

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
C_Elec_L1(Node)
C_Elec_Q1(Node)
Cap_Elec1(Node)
Base_Elec_Dem(Node, Season, Year)
DemCrossElas(FoodItem, FoodItem2)
;




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
CowDeath(Node, Season, Year) = CowDeath1(Node)*0 + 0.05;

$LOAD CF_Road_data1=CF_Road_data
CF_Road(FoodItem, NodeFrom, Node, Season, Year) = CF_Road_data1(NodeFrom, Node);

$LOAD Cap_Road1=Cap_Road
Cap_Road(FoodItem, NodeFrom, Node) = Cap_Road1(NodeFrom, Node);

$LOAD InitCow
InitCow(Node) = InitCow(Node)*3;
$LOAD Herdsize
$LOAD C_cow_tr1=CowtranYr1


$LOAD BeefYield
Yield("Beef", Node, Season, Year) = BeefYield(Node, Year);
$LOAD MilkYield
Yield("Milk", Node, Season, Year) = MilkYield(Node, Year);
$LOAD q_WInit=qWInit

$LOAD C_Elec_L1
$LOAD C_Elec_Q1
$Load Cap_Elec1

C_Elec_L(Node, Season, Year) = C_Elec_L1(Node);
C_Elec_Q(Node, Season, Year) = C_Elec_Q1(Node);
Cap_Elec(Node, Season, Year) = Cap_Elec1(Node);

$ontext
$LOAD DemInt
$LOAD DemSlope
$offtext
$LOAD DemCrossElas
$LOAD Base_Elec_Dem=Base_Elec_Dem1

DemCrossTerms(FoodItem, FoodItem2, Node, Season, Year) = DemCrossElas(FoodItem, FoodItem2);

$GDXIN


Elas(FoodItem, Node, Season, Year) = 0;
DemCrossTerms(FoodItem, FoodItem2, Node, Season, Year) = 0;

*These are/could be altered in the calibration file
C_Elec_Trans(NodeFrom, Node, Season, Year) = 1;
Cap_Elec_Trans(NodeFrom, Node, Season, Year) = 10000;

CS_L(FoodItem, Node, Season, Year) = 0.01;
CS_Q(FoodItem, Node, Season, Year) = 0.01;
CAP_Store(FoodItem, Node, Season, Year) = 2000;

C_cow_tr(NodeFrom, Node, Season, Year) = 4;
Cap_Road_Tot(NodeFrom, Node) = 1000000;


$GDXIN DemCalib
$LOAD DemInt
$LOAD DemSlope
$GDXIN
$ontext
$offtext


* Including Scenario File
$if exist Data/%Scenario% $include Data/%Scenario%.gms
$if exist Data/%Scenario% Display 'Data/%Scenario%.gms loaded' ;
$if not exist Data/%Scenario% Display 'Data/%Scenario%.gms does not exist. Running Base Scenario' ;


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
E1_3a(FoodItem, Node, Season, Year)
E1_3b(FoodItem, Node, Season, Year)
;

E1_2b(Node, Year).. TotArea(Node)
                    =g=
                    sum((Crop, Season),Area_Crop(Crop, Node, Season, Year));

* Yield of livestock also defined
E1_2cd(FoodItem, Node, Season, Year).. -q_Food(FoodItem, Node, Season, Year)
            =g=
            -(aFAO(FoodItem, Node, Season, Year)*CYF(FoodItem, Node, Season, Year)*(1+(rPower(pi_Food(FoodItem, Node, Season, Year),Elas(FoodItem, Node, Season, Year))-1)$(Elas(FoodItem, Node, Season, Year)))*Area_Crop(FoodItem, Node, Season, Year))$Crop(FoodItem)
            -Yield(FoodItem, Node, Season, Year)*(
                            Q_cattle(FoodItem, Node, Season, Year)$(sameas(FoodItem,"milk"))+
                            Q_cattle_sl(Node, Season, Year)$(sameas(FoodItem,"beef"))
                            );


E1_3a(FoodItem, Node, Season, Year).. d2(FoodItem, Node, Season, Year) - df(Year)*pi_Food(FoodItem, Node, Season, Year)
                            =g=
                            0;
* Fallow and crop rotation costraints not yet added
E1_3b(FoodItem, Node, Season, Year)$Crop(FoodItem).. d1(Node, Year)
        -d2(FoodItem, Node, Season, Year)*aFAO(FoodItem, Node, Season, Year)*CYF(FoodItem, Node, Season, Year)*(1+(rPower(pi_Food(FoodItem, Node, Season, Year),Elas(FoodItem, Node, Season, Year))-1)$(Elas(FoodItem, Node, Season, Year)))
        + df(Year)*(
            C_prod(FoodItem, Node, Season, Year) +
*            C_convert(Node, Year) - C_convert(Node, Year+1) +
            C_chg(Node, Year)*(Area_Crop(FoodItem, Node, Season, Year) - Area_Crop(FoodItem, Node, Season, Year-1) - Area_init(Node, Season,  FoodItem)$(Ord(Year)=1))-
            C_chg(Node, Year+1)*(Area_Crop(FoodItem, Node, Season, Year+1) - Area_Crop(FoodItem, Node, Season, Year))
            )
                    =g=
            0;


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
    E2_3a(FoodItem, Node, Season, Year)
    E2_3b(NodeFrom, Node, Season, Year)
    E2_3c(Node, Season, Year)
    E2_3d(Node, Season, Year)
;
* Yield defined with Foodcrop

E2_2b(Node, Season, Year).. -q_Hide(Node, Season, Year)
                    =g=
                    -Yld_H(Node, Season, Year)*Q_cattle_sl(Node, Season, Year);
E2_2c(Node, Season, Year).. -Q_cattle_sl(Node, Season, Year) =g= -sum(FoodItem, Q_cattle(FoodItem, Node, Season, Year));


E2_2d(Node, Season, Year).. -sum(FoodItem, Q_cattle(FoodItem, Node, Season, Year))
    =g=
    -((1+k(Node, Season, Year)-kappa(Node, Season, Year))*(sum(FoodItem, Q_cattle(FoodItem, Node, Season-1, Year)$(ORD(Season)>1) + Q_cattle(FoodItem, Node, Season+(CARD(Season)-1), Year-1)$(ORD(Season)=1)) + InitCow(Node)$(ORD(Year)=1 AND ORD(Season)=1)) -
    Q_cattle_sl(Node, Season+(CARD(Season)-1), Year-1)$(ORD(Season)=1) - Q_cattle_sl(Node, Season-1, Year)$(ORD(Season)>1) +
    sum(NodeFrom, Q_cattle_buy(NodeFrom, Node, Season, Year) - Q_cattle_buy(Node, NodeFrom, Season, Year)));



E2_2e(Node, Season, Year).. Q_cattle_sl(Node, Season, Year) =g= CowDeath(Node, Season, Year)*sum(FoodItem, Q_cattle(FoodItem, Node, Season, Year));
E2_2f(Node, Season, Year).. sum(FoodItem, Q_cattle(FoodItem, Node, Season, Year)) =g= Herdsize(Node)-10;


E2_3a(FoodItem, Node, Season, Year)$sameas(FoodItem, "Milk").. df(Year)*C_cow(Node, Season, Year) - d2(FoodItem, Node, Season, Year)*Yield(FoodItem, Node, Season, Year)$sameas(FoodItem, "Milk") -
    d4(Node, Season, Year)+ pi_cow(Node, Season, Year) - (1+k(Node, Season, Year)-kappa(Node, Season, Year))*(pi_cow(Node, Season+1, Year)$(ORD(Season)<CARD(Season)) + pi_cow(Node, Season-(CARD(Season)-1), Year+1)$(ORD(Season)=CARD(Season)))
    +CowDeath(Node, Season, Year)*d9(Node, Season, Year) - d10(Node, Season, Year)
    =g=
    0;
Q_cattle.fx(FoodItem, Node, Season, Year)$(NOT(sameas(FoodItem,"Milk"))) = 0;
E2_3b(NodeFrom, Node, Season, Year)$(NOT(sameas(Node, NodeFrom)))..   df(Year)*(C_cow_tr(NodeFrom, Node, Season, Year)+
    pi_cow(NodeFrom, Season, Year) - pi_cow(Node, Season, Year))+
    (pi_cow(NodeFrom, Season, Year)-pi_cow(Node, Season, Year))
    =g=
    0;
E2_3c(Node, Season, Year).. d3(Node, Season, Year)-df(Year)*pr_Hide(Node, Season, Year) =g= 0;
E2_3d(Node, Season, Year).. d4(Node, Season, Year) - sum(FoodItem$sameas(FoodItem, "beef"), d2(FoodItem, Node, Season, Year)*Yield(FoodItem, Node, Season, Year))-
        d3(Node, Season, Year)*Yld_H(Node, Season, Year) + pi_cow(Node, Season+1, Year)$(ORD(Season)<CARD(Season)) + pi_cow(Node, Season-(CARD(Season)-1), Year+1)$(ORD(Season)=CARD(Season))-d9(Node, Season, Year)
                        =g=
                        0;


************************************************************************
***********************       DISTRIBUTORS       ***********************
************************************************************************
Equations
    E3_2b(FoodItem, Node, Season, Year)
    E3_2c(FoodItem, NodeFrom, Node, Season, Year)
    E3_2d(NodeFrom, Node, Season, Year)
    E3_3a(FoodItem, Node, Season, Year)
    E3_3b(FoodItem, NodeFrom, Node, Season, Year)
    E3_3c(FoodItem, Node, Season, Year)
;

E3_2b(FoodItem, Node, Season, Year).. QF_Db(FoodItem, Node, Season, Year) + sum(NodeFrom$Road(NodeFrom, Node), qF_Road(FoodItem, NodeFrom, Node, Season, Year))
                                =e=
                                QF_Ds(FoodItem, Node, Season, Year) + sum(NodeFrom$Road(Node, NodeFrom),qF_Road(FoodItem, Node, NodeFrom, Season, Year));
E3_2c(FoodItem, NodeFrom, Node, Season, Year)$((FoodDistrCap AND Road(NodeFrom, Node))).. -qF_Road(FoodItem, NodeFrom, Node, Season, Year)
                                        =g=
                                        -Cap_Road(FoodItem, NodeFrom, Node);

E3_2d(NodeFrom, Node, Season, Year)$Road(NodeFrom, Node).. -sum(FoodItem,qF_Road(FoodItem, NodeFrom, Node, Season, Year))
                                        =g=
                                        -Cap_Road_Tot(NodeFrom, Node);
E3_3a(FoodItem, Node, Season, Year).. df(Year)*pi_Food(FoodItem, Node, Season, Year)
                                =g=
                                d6(FoodItem, Node, Season, Year);
E3_3b(FoodItem, NodeFrom, Node, Season, Year)$Road(NodeFrom, Node).. d7(FoodItem, NodeFrom, Node, Season, Year)$(FoodDistrCap) + d16(NodeFrom, Node, Season, Year)  + df(Year)*CF_Road(FoodItem, NodeFrom, Node, Season, Year)
                                        =g=
                                        d6(FoodItem, Node, Season, Year) - d6(FoodItem, NodeFrom, Season, Year) ;
E3_3c(FoodItem, Node, Season, Year).. d6(FoodItem, Node, Season, Year)
                                =g=
                                df(Year)*pi_W(FoodItem, Node, Season, Year);


************************************************************************
***********************       STORE/RETAIL       ***********************
************************************************************************
Equations
    E4_2a(FoodItem, Node, Season, Year)
    E4_2b(FoodItem, Node, Season, Year)
    E4_3a(FoodItem, Node, Season, Year)
    E4_3b(FoodItem, Node, Season, Year)
    E4_3c(FoodItem, Node, Season, Year)
;
E4_2a(FoodItem, Node, Season, Year).. -q_W(FoodItem, Node, Season, Year) =g= -CAP_Store(FoodItem, Node, Season, Year);
E4_2b(FoodItem, Node, Season, Year).. q_W(FoodItem, Node, Season-1, Year)$(Ord(Season)>1) +
        (q_WInit(FoodItem, Node)$(ORD(Year)=1) +q_W(FoodItem, Node, Season + (Card(Season)-1), Year-1))$(Ord(Season)=1) + q_Wb(FoodItem, Node, Season, Year)
        -q_Ws(FoodItem, Node, Season, Year) =e= q_W(FoodItem, Node, Season, Year);

E4_3a(FoodItem, Node, Season, Year).. pi_W(FoodItem, Node, Season, Year) - d11(FoodItem, Node, Season, Year)=g= 0;
E4_3b(FoodItem, Node, Season, Year).. d11(FoodItem, Node, Season, Year) - pi_U(FoodItem, Node, Season, Year)=g= 0;

E4_3c(FoodItem, Node, Season, Year).. d8(FoodItem, Node, Season, Year)  + d11(FoodItem, Node, Season, Year)
            + CS_Q(FoodItem, Node, Season, Year)*q_W(FoodItem, Node, Season, Year)
            + CS_L(FoodItem, Node, Season, Year) + d8(FoodItem, Node, Season, Year)
            - d11(FoodItem, Node, Season-(Card(Season)-1), Year+1)$(Ord(Season)=Card(Season))
            - d11(FoodItem, Node, Season+1, Year)$(Ord(Season)<>Card(Season))
            =g= 0;


************************************************************************
***********************       CONSUMERS       **********************
************************************************************************
Equations
    E5_1a(FoodItem, Node, Season, Year)
    E5_1b(FoodItem, Node, Season, Year)
    E5_1c(FoodItem, Node, Season, Year)
;

E5_1a(FoodItem, Node, Season, Year).. q_Food(FoodItem, Node, Season, Year) =e= qF_Db(FoodItem, Node, Season, Year);
E5_1b(FoodItem, Node, Season, Year).. pi_U(FoodItem, Node, Season, Year) =e= DemInt(FoodItem, Node, Season, Year)*10
                                - DemSlope(FoodItem, Node, Season, Year)*q_Ws(FoodItem, Node, Season, Year)
                                + sum(FoodItem2, DemCrossTerms(FoodItem, FoodItem2, Node, Season, Year)*DemCrossTerms(FoodItem, FoodItem2, Node, Season, Year)*DemSlope(FoodItem, Node, Season, Year)*(pi_U(FoodItem2, Node, Season, Year) - pi_U(FoodItem, Node, Season, Year)))$(CrossElasOn);
E5_1c(FoodItem, Node, Season, Year).. q_Wb(FoodItem, Node, Season, Year) =e= qF_Ds(FoodItem, Node, Season, Year);



************************************************************************
************************       ELECTRICITY       ***********************
************************************************************************
Equations
    E6_2a(Node, Season, Year)
    E6_2b(Node, Season, Year)
    E6_2c(NodeFrom, Node, Season, Year)
    E6_3a(Node, Season, Year)
    E6_3b(NodeFrom, Node, Season, Year)
    E_ElecDem(Node, Season, Year)
;


E6_2a(Node, Season, Year).. Cap_Elec(Node, Season, Year) =g= q_Elec(Node, Season, Year);
E6_2b(Node, Season, Year).. q_Elec(Node, Season, Year) + sum(NodeFrom$Eline(NodeFrom, Node), q_Elec_Trans(NodeFrom, Node, Season, Year))
                                 =g=
                q_Elec_Dem(Node, Season, Year)+sum(NodeFrom$Eline(Node, NodeFrom), q_Elec_Trans(Node, NodeFrom, Season, Year));
E6_2c(NodeFrom, Node, Season, Year)$Eline(NodeFrom, Node).. Cap_Elec_Trans(NodeFrom, Node, Season, Year)
                                =g=
                q_Elec_Trans(NodeFrom, Node, Season, Year);
E6_3a(Node, Season, Year).. C_Elec_L(Node, Season, Year)+C_Elec_Q(Node, Season, Year)*q_Elec(Node, Season, Year)+
                        d13(Node, Season, Year) - d14(Node, Season, Year) =g= 0;
E6_3b(NodeFrom, Node, Season, Year)$Eline(NodeFrom, Node).. C_Elec_Trans(NodeFrom, Node, Season, Year)  +
                d15(NodeFrom, Node, Season, Year) + d14(NodeFrom, Season, Year) - d14(Node, Season, Year) =g= 0;
E_ElecDem(Node, Season, Year).. q_Elec_Dem(Node, Season, Year) =e= Base_Elec_Dem(Node, Season, Year)/2;
Display Base_Elec_Dem;


************************************************************************
**********************       DATA-PROCESSING       *********************
************************************************************************

*CF_Road(FoodItem, Node, NodeFrom, Season, Year) = CF_Road_data(FoodItem, Node, NodeFrom);


Model Food1y /
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
E3_2d.d16
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
E6_2a.d13
E6_2b.d14
E6_2c.d15
E6_3a.q_Elec
E6_3b.q_Elec_Trans
E_ElecDem.q_Elec_Dem
/;


q_Ws.lo(FoodItem, Node, Season, Year) = Consumption(FoodItem, Node, Season, Year)*0;





option reslim=10000000;
Set iteration /i1*i1/;
Parameters
Deviation(FoodItem, Node, Season, Year)
ref_price_S(FoodItem, Node, Season, Year)
eR(FoodItem)
tol /0.1/
up_it /0.3/
lo_it /0.3/
;

DemElas(FoodItem) = -DemElas(FoodItem);

eR(FoodItem) = 1/DemElas(FoodItem);
ref_price_S(FoodItem, Node, Season, Year) = DemInt(FoodItem, Node, Season, Year)/(1+eR(FoodItem));
Display ref_price_S;
Solve Food1y using MCP;

loop(iteration,
Deviation(FoodItem, Node, Season, Year) = q_Ws.L(FoodItem, Node, Season, Year)/Consumption(FoodItem, Node, Season, Year);
ref_price_S(FoodItem, Node, Season, Year)$(Deviation(FoodItem, Node, Season, Year) < 1-tol)= ref_price_S(FoodItem, Node, Season, Year)*(1+up_it);
ref_price_S(FoodItem, Node, Season, Year)$(Deviation(FoodItem, Node, Season, Year) < 0.5)= ref_price_S(FoodItem, Node, Season, Year)*(1+10*up_it);
ref_price_S(FoodItem, Node, Season, Year)$(Deviation(FoodItem, Node, Season, Year) < 0.1)= ref_price_S(FoodItem, Node, Season, Year)*(1+30*up_it);
ref_price_S(FoodItem, Node, Season, Year)$(Deviation(FoodItem, Node, Season, Year) > 1+tol)= ref_price_S(FoodItem, Node, Season, Year)*(1-lo_it);
ref_price_S(FoodItem, Node, Season, Year)$(Deviation(FoodItem, Node, Season, Year) > 2)= ref_price_S(FoodItem, Node, Season, Year)*(0.5);
*DemInt(FoodItem, Node, Season, Year) = ref_price_S(FoodItem, Node, Season, Year)*(1+eR(FoodItem));
*DemSlope(FoodItem, Node, Season, Year) = eR(FoodItem)*ref_price_S(FoodItem, Node, Season, Year)/Consumption(FoodItem, Node, Season, Year);

Display iteration;

);

$ontext

************************************************************************
**********************       POST-PROCESSING       *********************
************************************************************************

$offtext

Parameter produce(*, Node, Season, Year);
produce(FoodItem, Node, Season, Year) = q_Food.L(FoodItem, Node, Season, Year);
produce("Hide", Node, Season, Year) = q_Hide.L(Node, Season, Year);


Parameter Cows(*, Node, Season, Year);
Cows("Number", Node, Season, Year) = Q_cattle.L("Milk", Node, Season, Year);
Cows("Slaughter", Node, Season, Year) = Q_cattle_sl.L(Node, Season, Year);


Parameter Prices(*, *, Node, Season, Year);
Prices("Farmer", FoodItem, Node, Season, Year) = pi_Food.L(FoodItem, Node, Season, Year);
Prices("Distribution", FoodItem, Node, Season, Year) = pi_W.L(FoodItem, Node, Season, Year);
Prices("Store", FoodItem, Node, Season, Year) = pi_U.L(FoodItem, Node, Season, Year);
Prices("Cow", "Animal", Node, Season, Year) = pi_cow.L(Node, Season, Year);
Prices("Grid", "Electricity", Node, Season, Year) = d14.L(Node, Season, Year);

Parameter Elec(*, Node, Season, Year);
Elec("Production", Node, Season, Year) = q_Elec.L(Node, Season, Year);
Elec("Consumption", Node, Season, Year) = q_Elec_Dem.L(Node, Season, Year);
Elec("CapProduce", Node, Season, Year) = Cap_Elec(Node, Season, Year);
Elec("Price", Node, Season, Year) = d14.L(Node, Season, Year);

Parameter Transports(*, NodeFrom, Node, Season, Year);
Transports(FoodItem, NodeFrom, Node, Season, Year) = qF_Road.L(FoodItem, NodeFrom, Node, Season, Year);
Transports("Cow", NodeFrom, Node, Season, Year) = Q_cattle_buy.L(NodeFrom, Node, Season, Year);
Transports("Electricity", NodeFrom, Node, Season, Year) = q_Elec_Trans.L(NodeFrom, Node, Season, Year);

Parameter TranspCost(*, NodeFrom, Node, Season, Year);
TranspCost("RoadCong", NodeFrom, Node, Season, Year) = d16.L(NodeFrom, Node, Season, Year);
TranspCost("ElecCong", NodeFrom, Node, Season, Year) = d15.L(NodeFrom, Node, Season, Year);
TranspCost("Roadfix", NodeFrom, Node, Season, Year) =  sum(FoodItem, qF_Road.L(FoodItem, NodeFrom, Node, Season, Year)*CF_Road(FoodItem, NodeFrom, Node, Season, Year));
TranspCost("Elecfix", NodeFrom, Node, Season, Year) = q_Elec_Trans.L(NodeFrom, Node, Season, Year)*C_Elec_Trans(NodeFrom, Node, Season, Year);


Parameter Storage(*, FoodItem, Node, Season, Year);
Storage("Purchase", FoodItem, Node, Season, Year) = q_Wb.L(FoodItem, Node, Season, Year);
Storage("Sold", FoodItem, Node, Season, Year) = q_Ws.L(FoodItem, Node, Season, Year);
Storage("Stored", FoodItem, Node, Season, Year) = q_W.L(FoodItem, Node, Season, Year);


* Printing results to lst file
$ontext
Display Area_Crop.L, Area_init;
Display Prices;
option produce:2:2:2;
Display produce;
option Cows:2:2:2;
Display Cows;
option Elec:2:2:2;
Display Elec;
$offtext



* Exporting results
%RunningOnCluster%execute_unload 'Results/%Scenario%';
%RunningOnCluster%$ontext
execute_unload '%Scenario%';
$ontext
$offtext
