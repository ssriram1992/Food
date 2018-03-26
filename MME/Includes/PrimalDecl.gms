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
    Adapt "Adaptation regions"
;
Alias(Year, Year2Loop);

Set Period /Period1*Period3/;

Scalar Infinity /10000/;


alias(Node, NodeFrom);
Alias(Adapt, AdaptFrom)
alias(FoodItem, FoodItem2);
*Road(NodeFrom, Node)$(Ord(NodeFrom)<Ord(Node))=yes;
*Eline(NodeFrom, Node)$(Ord(NodeFrom)<Ord(Node))=yes;


************************************************************************
**********************       INITIALIZATION       **********************
************************************************************************

Parameter
    df(Year) "Discount factor"
    df_roll(Period) "Discount factor"
    Adapt2Node(Adapt, Node) "Ratios for converting data in adaptation zone to administrative regions"
;

*** Crop Producer ***
Parameters
    C_prod(FoodItem, Adapt, Season, Year) "Cost of producing a Crop per unit area"
    C_prod_roll(FoodItem, Adapt, Season, Period) "Cost of producing a Crop per unit area"

    C_convert(Adapt, Year) "Cost of converting land to make it arable"
    C_convert_roll(Adapt, Period) "Cost of converting land to make it arable"

    C_chg(Adapt, Year) "Penalty to change cropping pattern"
    C_chg_roll(Adapt, Period) "Penalty to change cropping pattern"

    Cyf(FoodItem, Adapt, Season, Year) "CYF in FAO model"
    Cyf_roll(FoodItem, Adapt, Season, Period) "CYF in FAO model"

    aFAO(FoodItem, Adapt, Season, Year) "a in FAOs yield equation"
    aFAO_roll(FoodItem, Adapt, Season, Period) "a in FAOs yield equation"

    Elas(FoodItem, Adapt, Season, Year) "Elasticity"
    Elas_roll(FoodItem, Adapt, Season, Period) "Elasticity"

    TotArea(Adapt, Season) "Total Area available in the node"

    Area_init(Adapt, Season,  FoodItem) "Initial Area"
;

*** Livestock ***
Parameters
    pr_Hide(Adapt, Season, Year) "Price of Hide"
    pr_Hide_roll(Adapt, Season, Period) "Price of Hide"

    Yield(FoodItem, Adapt, Season, Year) "Yield"
    Yield_roll(FoodItem, Adapt, Season, Period) "Yield"

    Yld_H(Adapt, Season, Year) "Hide yield per unit slaughtered cattle"
    Yld_H_roll(Adapt, Season, Period) "Hide yield per unit slaughtered cattle"

    k(Adapt, Season, Year) "Cattle birth rate"
    k_roll(Adapt, Season, Period) "Cattle birth rate"

    kappa(Adapt, Season, Year) "cattle death rate"
    kappa_roll(Adapt, Season, Period) "cattle death rate"

    C_cow(Adapt, Season, Year) "Cost of rearing cattle"
    C_cow_roll(Adapt, Season, Period) "Cost of rearing cattle"

    C_cow_tr(Adapt, AdaptFrom, Season, Year) "Cost of transporting cattle"
    C_cow_tr_roll(Adapt, AdaptFrom, Season, Period) "Cost of transporting cattle"

    C_cow_tr1(AdaptFrom, Adapt)

    InitCow(Adapt) "Initial number of cows"

    Herdsize(Adapt) "Minimum herd size to be maintained"

    CowDeath(Adapt, Season, Year) "Rate of cowdeath to determine Minimum number cows to slaughter"
    CowDeath_roll(Adapt, Season, Period) "Rate of cowdeath to determine Minimum number cows to slaughter"
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
    DemSlope(FoodItem, Adapt, Season, Year) "Slope of Demand curve"
    DemSlope_roll(FoodItem, Adapt, Season, Period) "Slope of Demand curve"

    DemInt(FoodItem, Adapt, Season, Year) "Intercept of demand curve"
    DemInt_roll(FoodItem, Adapt, Season, Period) "Intercept of demand curve"

    DemCrossTerms(FoodItem, FoodItem2, Adapt, Season, Year) "Cross terms in demand curve"
    DemCrossTerms_roll(FoodItem, FoodItem2, Adapt, Season, Period) "Cross terms in demand curve"
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
    Q_FOOD(FoodItem, Adapt, Season, Period) "quantity of Food produced"
    AREA_CROP(FoodItem, Adapt, Season, Period) "area allotted for each Crop"
*    Area_conv(Adapt, Period) "area converted to become arable"
    Q_FOOD_ADMIN(FoodItem, Node, Season, Period) "Quantity of Food - by admin region"
    Q_FOOD_TRANS(FoodItem, Adapt, Node, Season, Period)
;

*** Livestock ***
Positive Variables
    Q_HIDE(Adapt, Season, Period) "Quantity of Hide produced"
    Q_CATTLE_BUY(AdaptFrom, Adapt, Season, Period) "Number of cattle bought from a certain node"
    Q_CATTLE(FoodItem, Adapt, Season, Period) "Number of cattle in the herd"
    Q_CATTLE_SL(Adapt, Season, Period) "Number of cattle slaughtered"
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


*** Consumers ***
Positive Variables
    Q_WU(FoodItem, Node, Adapt, Season, Period) "Transfered to adaptation zones"
    Q_U(FoodItem, Adapt, Season, Period) "Quantity of Food consmued"
;
*** Electricity ***
Positive Variables
    Q_ELEC(Node, Season, Period)
    Q_ELEC_TRANS(NodeFrom, Node, Season, Period)
    Q_ELEC_DEM(Node, Season, Period)
    ;



Parameter produce(*, Adapt, Season, Year);
Parameter Cows(*, Adapt, Season, Year);
Parameter Prices(*, *, *, Season, Year);
Parameter Elec(*, Node, Season, Year);
Parameter Transports(*, NodeFrom, Node, Season, Year);
Parameter TranspCost(*, NodeFrom, Node, Season, Year);
Parameter Storage(*, FoodItem, Node, Season, Year);