$ontext
*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%%*%*%*%**%*
      DECLARATION OF NON-DUAL QUANTITIES
*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*
$offtext


************************************************************************
***********************       COMMON INIT       ************************
************************************************************************
Sets
    Node "Nodes"
    Season "seasons"
    FoodItem "FoodItem"
    Crop(FoodItem) "Crops"
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

*** Livestock ***
Positive Variables
    q_Hide(Node, Season, Year) "Quantity of Hide produced"
    Q_cattle_buy(NodeFrom, Node, Season, Year) "Number of cattle bought from a certain node"
    Q_cattle(FoodItem, Node, Season, Year) "Number of cattle in the herd"
    Q_cattle_sl(Node, Season, Year) "Number of cattle slaughtered"
;

*** Distributors ***
Positive Variables
    qF_Ds(FoodItem, Node, Season, Year) "Quantity of Food sold by distributor"
    qF_Db(FoodItem, Node, Season, Year) "Quantity of Food bought by distributor"
    qF_Road(FoodItem, Node, NodeFrom, Season, Year) "Quantity of Food transported"
;

*** Storage ***
Positive Variables
    q_W(FoodItem, Node, Season, Year) "Total quantity stored"
    q_Ws(FoodItem, Node, Season, Year) "Quantity sold"
    q_Wb(FoodItem, Node, Season, Year) "Quantity bought"
;

*** Electricity ***
Positive Variables
    q_Elec(Node, Season, Year)
    q_Elec_Trans(NodeFrom, Node, Season, Year)
    q_Elec_Dem(Node, Season, Year)
;

