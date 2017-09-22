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
Alias(Year, Year2Loop);

Set Period /Period1*Period3/;

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
    df_roll(Period) "Discount factor"
;

*** Crop Producer ***
Parameters
    C_prod(FoodItem, Node, Season, Year) "Cost of producing a Crop per unit area"
    C_prod_roll(FoodItem, Node, Season, Period) "Cost of producing a Crop per unit area"

    C_convert(Node, Year) "Cost of converting land to make it arable"
    C_convert_roll(Node, Period) "Cost of converting land to make it arable"

    C_chg(Node, Year) "Penalty to change cropping pattern"
    C_chg_roll(Node, Period) "Penalty to change cropping pattern"

    Cyf(FoodItem, Node, Season, Year) "CYF in FAO model"
    Cyf_roll(FoodItem, Node, Season, Period) "CYF in FAO model"

    aFAO(FoodItem, Node, Season, Year) "a in FAOs yield equation"
    aFAO_roll(FoodItem, Node, Season, Period) "a in FAOs yield equation"

    Elas(FoodItem, Node, Season, Year) "Elasticity"
    Elas_roll(FoodItem, Node, Season, Period) "Elasticity"

    Yield(FoodItem, Node, Season, Year) "Yield"
    Yield_roll(FoodItem, Node, Season, Period) "Yield"

    TotArea(Node) "Total Area available in the node"

    Area_init(Node, Season,  FoodItem) "Initial Area"
;

*** Livestock ***
Parameters
    pr_Hide(Node, Season, Year) "Price of Hide"
    pr_Hide_roll(Node, Season, Period) "Price of Hide"

    Yld_H(Node, Season, Year) "Hide yield per unit slaughtered cattle"
    Yld_H_roll(Node, Season, Period) "Hide yield per unit slaughtered cattle"

    k(Node, Season, Year) "Cattle birth rate"
    k_roll(Node, Season, Period) "Cattle birth rate"

    kappa(Node, Season, Year) "cattle death rate"
    kappa_roll(Node, Season, Period) "cattle death rate"

    C_cow(Node, Season, Year) "Cost of rearing cattle"
    C_cow_roll(Node, Season, Period) "Cost of rearing cattle"

    C_cow_tr(Node, NodeFrom, Season, Year) "Cost of transporting cattle"
    C_cow_tr_roll(Node, NodeFrom, Season, Period) "Cost of transporting cattle"

    C_cow_tr1(NodeFrom, Node)

    InitCow(Node) "Initial number of cows"

    Herdsize(Node) "Minimum herd size to be maintained"

    CowDeath(Node, Season, Year) "Rate of cowdeath to determine Minimum number cows to slaughter"
    CowDeath_roll(Node, Season, Period) "Rate of cowdeath to determine Minimum number cows to slaughter"
;

*** Distributors ***
Parameters
    CF_Road(FoodItem, Node, NodeFrom, Season, Year) "Cost of transporting food item"
    CF_Road_roll(FoodItem, Node, NodeFrom, Season, Period) "Cost of transporting food item"

    CF_Road_data(FoodItem, Node, NodeFrom) "Data without temporal info"

    Cap_Road(FoodItem, NodeFrom, Node)  "Transportation capacity"

    Cap_Road_Tot(NodeFrom, Node)
;

*** Storage ***
Parameters
    CS_L(FoodItem, Node, Season, Year) "Cost of food storage Linear term"
    CS_L_roll(FoodItem, Node, Season, Period) "Cost of food storage Linear term"

    CS_Q(FoodItem, Node, Season, Year) "Cost of food storage Quadratic term"
    CS_Q_roll(FoodItem, Node, Season, Period) "Cost of food storage Quadratic term"

    CAP_Store(FoodItem, Node, Season, Year) "Storage Capacity"
    CAP_Store_roll(FoodItem, Node, Season, Period) "Storage Capacity"

    q_WInit(FoodItem, Node)
;

*** Consumers ***
Parameters
    DemSlope(FoodItem, Node, Season, Year) "Slope of Demand curve"
    DemSlope_roll(FoodItem, Node, Season, Period) "Slope of Demand curve"

    DemInt(FoodItem, Node, Season, Year) "Intercept of demand curve"
    DemInt_roll(FoodItem, Node, Season, Period) "Intercept of demand curve"

    DemCrossTerms(FoodItem, FoodItem2, Node, Season, Year) "Cross terms in demand curve"
    DemCrossTerms_roll(FoodItem, FoodItem2, Node, Season, Period) "Cross terms in demand curve"
;

*** Electricity ***
Parameters
    C_Elec_L(Node, Season, Year) "Linear cost of electricity production"
    C_Elec_L_roll(Node, Season, Period) "Linear cost of electricity production"

    C_Elec_Q(Node, Season, Year) "Quadratic cost of electricity production"
    C_Elec_Q_roll(Node, Season, Period) "Quadratic cost of electricity production"

    C_Elec_Trans(NodeFrom, Node, Season, Year) "Cost of Electricity transmission"
    C_Elec_Trans_roll(NodeFrom, Node, Season, Period) "Cost of Electricity transmission"

    Cap_Elec(Node, Season, Year) "Electricity production cap"
    Cap_Elec_roll(Node, Season, Period) "Electricity production cap"

    Cap_Elec_Trans(NodeFrom, Node, Season, Year) "Electricity Transmission cap"
    Cap_Elec_Trans_roll(NodeFrom, Node, Season, Period) "Electricity Transmission cap"

    Base_Elec_Dem(Node, Season, Year) "Base Demand for electricity"
    Base_Elec_Dem_roll(Node, Season, Period) "Base Demand for electricity"
;

*********************
***** Variables *****
*********************

*** Crop Producer ***
Positive Variables
    Q_FOOD(FoodItem, Node, Season, Period) "quantity of Food produced"
    AREA_CROP(FoodItem, Node, Season, Period) "area allotted for each Crop"
*    Area_conv(Node, Period) "area converted to become arable"
;

*** Livestock ***
Positive Variables
    Q_HIDE(Node, Season, Period) "Quantity of Hide produced"
    Q_CATTLE_BUY(NodeFrom, Node, Season, Period) "Number of cattle bought from a certain node"
    Q_CATTLE(FoodItem, Node, Season, Period) "Number of cattle in the herd"
    Q_CATTLE_SL(Node, Season, Period) "Number of cattle slaughtered"
;

*** Distributors ***
Positive Variables
    QF_DS(FoodItem, Node, Season, Period) "Quantity of Food sold by distributor"
    QF_DB(FoodItem, Node, Season, Period) "Quantity of Food bought by distributor"
    QF_ROAD(FoodItem, Node, NodeFrom, Season, Period) "Quantity of Food transported"
;

*** Storage ***
Positive Variables
    Q_W(FoodItem, Node, Season, Period) "Total quantity stored"
    Q_WS(FoodItem, Node, Season, Period) "Quantity sold"
    Q_WB(FoodItem, Node, Season, Period) "Quantity bought"
;

*** Electricity ***
Positive Variables
    Q_ELEC(Node, Season, Period)
    Q_ELEC_TRANS(NodeFrom, Node, Season, Period)
    Q_ELEC_DEM(Node, Season, Period)
    ;



Parameter produce(*, Node, Season, Year);
Parameter Cows(*, Node, Season, Year);
Parameter Prices(*, *, Node, Season, Year);
Parameter Elec(*, Node, Season, Year);
Parameter Transports(*, NodeFrom, Node, Season, Year);
Parameter TranspCost(*, NodeFrom, Node, Season, Year);
Parameter Storage(*, FoodItem, Node, Season, Year);