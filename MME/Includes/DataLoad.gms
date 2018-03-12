************************************************************************
***********************       DATA LOADING       ***********************
************************************************************************


*Call from GDX to here
$GDXIN %DataFile%
* Loading sets
$LOAD Season
$LOAD Node
$LOAD FoodItem
$LOAD Crop
$LOAD Road
$LOAD Eline
$LOAD Adapt

* Discount Factor
$LOAD df=DiscFact


*Declaring parameters without seasonal/yearly variations and appropriating variations later
Parameters
*Factors
Psi(Node, Adapt)
Phi(Adapt, Node)

*Crop Producer
C_prod1(Season, FoodItem, Adapt)
C_convert1(Adapt)
C_chg1(Adapt)


* Livestock raiser
pr_Hide1(Adapt)
Yld_H1(Adapt)
k1(Adapt)
kappa1(Adapt)
C_Cow1(Adapt)
CowDeath1(Adapt)
MilkYield(Adapt, Year)
BeefYield(Adapt, Year)

* Distribution
Cap_Road1(NodeFrom, Node)
CF_Road_data1(NodeFrom, Node)

* Consumption
DemInt1(Season, FoodItem, Adapt)
DemSlope1(Season, FoodItem, Adapt)
DemCrossElas(FoodItem, FoodItem2)

* Electricity
Base_Elec_Dem(Node, Season, Year)
C_Elec_L1(Node)
C_Elec_Q1(Node)
Cap_Elec1(Node)

* Initialization
Consumption(Adapt, FoodItem)
Consum_Admin(Node, FoodItem)
Production(Adapt, Season, FoodItem)
Produc_Admin(Node, Season, FoodItem)
Price(Adapt, FoodItem, Season)
Price_Admin(Node, FoodItem, Season)
;

*** Conversion Factors
$LOAD Psi
Adapt2Node(Adapt, Node) = Psi(Node, Adapt);
$LOAD Phi
Node2Adapt(Node, Adapt) = Phi(Adapt, Node);



***Crop Producer***
$LOAD C_prod1=C_prod
C_prod(FoodItem, Adapt, Season, Year) = C_prod1(Season, FoodItem, Adapt);

* Change to adaptation zone input when possible
$LOAD aFAO
$LOAD C_convert1=C_convert
C_convert(Adapt, Year) = C_convert1(Adapt);
$LOAD C_chg1=C_chg
C_chg(Adapt, Year) = C_chg1(Adapt)*10*100;

$LOAD Cyf
$LOAD TotArea
$LOAD Area_init



*** Livestock production ***
$LOAD pr_Hide1=pr_Hide
pr_Hide(Adapt, Season, Year) = pr_Hide1(Adapt);
$LOAD Yld_H1=Yld_H
Yld_H(Adapt, Season, Year) = Yld_H1(Adapt);
$LOAD k1=k
k(Adapt, Season, Year) = k1(Adapt);
$LOAD kappa1=kappa
kappa(Adapt, Season, Year) = kappa1(Adapt);
$LOAD C_Cow1=C_Cow
C_Cow(Adapt, Season, Year) = C_Cow1(Adapt);
$LOAD CowDeath1=CowDeath
CowDeath(Adapt, Season, Year) = CowDeath1(Adapt);
$LOAD InitCow
$LOAD Herdsize
$LOAD C_cow_tr1=CowtranYr1
$LOAD BeefYield
Yield("Beef", Adapt, Season, Year) = BeefYield(Adapt, Year);
$LOAD MilkYield
Yield("Milk", Adapt, Season, Year) = MilkYield(Adapt, Year);
C_cow_tr(AdaptFrom, Adapt, Season, Year) = C_cow_tr1(AdaptFrom, Adapt);


*** Distribution ***
$LOAD CF_Road_data1=CF_Road_data
CF_Road(FoodItem, NodeFrom, Node, Season, Year) = CF_Road_data1(NodeFrom, Node);
$LOAD Cap_Road1=Cap_Road
Cap_Road(FoodItem, NodeFrom, Node) = Cap_Road1(NodeFrom, Node);
Cap_Road_Tot(NodeFrom, Node) = 100000000;
Cap_Road(FoodItem, NodeFrom, Node) = 10000000;

*** Storage ***
$LOAD q_WInit=qWInit
*q_WInit(FoodItem, Node)
CS_L(FoodItem, Node, Season, Year) = 0.01;
CS_Q(FoodItem, Node, Season, Year) = 0.01;
CAP_Store(FoodItem, Node, Season, Year) = 2000000;


*** Consumption ***
$LOAD DemInt1=DemInt
DemInt(FoodItem, Adapt, Season, Year) =  DemInt1(Season, FoodItem, Adapt);
$LOAD DemSlope1=DemSlope
DemSlope(FoodItem, Adapt, Season, Year) = DemSlope1(Season, FoodItem, Adapt);
$LOAD DemCrossElas
$LOAD Base_Elec_Dem=Base_Elec_Dem1

DemCrossTerms(FoodItem, FoodItem2, Adapt, Season, Year) = DemCrossElas(FoodItem, FoodItem2);
Elas(FoodItem, Adapt, Season, Year) = 0;
DemCrossTerms(FoodItem, FoodItem2, Adapt, Season, Year) = 0;


*** Electricity ***
$LOAD C_Elec_L1
C_Elec_L(Node, Season, Year) = C_Elec_L1(Node);
$LOAD C_Elec_Q1
C_Elec_Q(Node, Season, Year) = C_Elec_Q1(Node);
$Load Cap_Elec1
Cap_Elec(Node, Season, Year) = Cap_Elec1(Node);
*These are/could be altered in the calibration file
C_Elec_Trans(NodeFrom, Node, Season, Year) = 1;
Cap_Elec_Trans(NodeFrom, Node, Season, Year) = 10000;


*** Data Initialization ***
$LOAD Consumption
Q_U.FX(FoodItem, Adapt, Season, Period) = Consumption(Adapt, FoodItem) ;
$LOAD Consum_Admin
*Q_WB.L(FoodItem, Node, Season, Period) = Consum_Admin(Node, FoodItem);
*QF_DS.L(FoodItem, Node, Season, Period) = Consum_Admin(Node, FoodItem);
Q_WS.FX(FoodItem, Node, Season, Period) = Consum_Admin(Node, FoodItem);
$LOAD Production
Q_FOOD.FX(FoodItem, Adapt, Season, Period) = Production(Adapt, Season, FoodItem);
$LOAD Produc_Admin
QF_DB.FX(FoodItem, Node, Season, Period) = Produc_Admin(Node, Season, FoodItem);
$LOAD Price
PI_U_ADAPT.L(FoodItem, Adapt, Season, Period) = Price(Adapt, FoodItem, Season);
PI_U_ADAPT.FX(FoodItem, Adapt, Season, Period) = DemInt(FoodItem, Adapt, Season, "2015") - DemSlope(FoodItem, Adapt, Season, "2015")*Consumption(Adapt, FoodItem);
$LOAD Price_Admin
PI_U.L(FoodItem, Node, Season, Period) = Price_Admin(Node, FoodItem, Season);

AREA_CROP.FX(FoodItem, Adapt, Season, Period) = Area_init(Adapt, Season,  FoodItem);
$GDXIN

$INCLUDE Includes/Calibration.gms
*QF_ROAD.FX("Teff", "BahirDar", "AddisAbaba", "Kremt", "Period1") = 2557.50818564473;