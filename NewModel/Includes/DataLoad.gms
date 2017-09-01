************************************************************************
***********************       DATA LOADING       ***********************
************************************************************************


*Call from GDX to here
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
Consumption(FoodItem, Node, Season, Year)
Base_Elec_Dem(Node, Season, Year)
DemCrossElas(FoodItem, FoodItem2)
;

$LOAD Consumption


$LOAD DemInt
$LOAD DemSlope
$LOAD DemCrossElas
$LOAD Base_Elec_Dem=Base_Elec_Dem1

DemCrossTerms(FoodItem, FoodItem2, Node, Season, Year) = DemCrossElas(FoodItem, FoodItem2);

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

