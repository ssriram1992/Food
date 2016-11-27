************************************************************************
**********************       SET DEFINITION       **********************
************************************************************************
Sets
    Year "Years" /2016*2020/
    Month "Months" /1*12/
    Node "Nodes" /N1*N3/
    Livestock "Livestock growers" /L1*L10/
    Season "seasons" /belg,kremt/
	FoodItem "FoodItem" /wheat, potato, lentils, Milk, beef/;
    Crop(FoodItems) "Crops" /wheat, potato, lentils/
	Road(Node, Node) "Transport connectivity"
;
alias(Node, NodeFrom);
* Connecting roads in one direction only. 
* Negative flow implies flow in other direction
Road(NodeFrom, Node)$(Ord(NodeFrom)<Ord(Node))=yes;



************************************************************************
**********************       CROP PRODDUCER       **********************
************************************************************************
Parameter
    df(y) "Discount factor"
;


*For farmers
alias(Node, Farmer);

Variables
    pi_Food(FoodItem, Node, Year) "Price of Food item"
    q_Food(FoodItem, Node, Year) "quantity of Food produced"
    Area_Crop(Crop, Node, Year) "area allotted for each Crop"
    Area_conv(Node, Year) "area converted to become arable"
;

Parameters
    C_prod(Crop, Node, Year) "Cost of producing a Crop per unit area"
    C_convert(Node, Year) "Cost of converting land to make it arable"
	Yield(FoodItem, Node, Year) "Yield"
;    


************************************************************************
*******************       LIVESTOCK PRODDUCER       ********************
************************************************************************
* Quantity, price of Milk and Beef are defined as (q/pi)_Food. Similarly for yield.
Variables
    q_Hide(Node, Year) "Quantity of Hide produced"
    N_cattle(Node, Year) "Number of cattle in the herd"
    N_cattle_buy(Node, NodeFrom, Year) "Number of cattle bought from a certain node"
;

Parameters
	pr_Hide "Price of Hide"
;



************************************************************************
***********************       DISTRIBUTORS       ***********************
************************************************************************
Variables
	qF_DS(FoodItem, Node, Year) "Quantity of Food bought by stores from distributor"
	qF_D(FoodItem, Node, Year) "Quantity of Food bought by distributor"
	qF_Road(FoodItem, Road, Year) "Quantity of Food transported"
	qN_Road(Road, Year) "Number of cattle transported"
;

Parameters
	CF_Road(FoodItem, Road, Year) "Cost of transporting food item"
	CN_Road(Road, Year) "Cost of transporting cattle"
;


************************************************************************
***********************       STORE/RETAIL       ***********************
************************************************************************
Variables
	qF_S(FoodItem, Node, Year) "Quantity bought by store from Farmer"
	qF_U(FoodItem, Node, Year) "Quantity sold to consumers"
;

Parameters
	CS_Food(FoodItem, Node, Year) "Cost of food storage"
;


************************************************************************
**********************       CROP PRODDUCER       **********************
************************************************************************
Parameters
	DemSlope(FoodItem, Node, Year) "Slope of Demand curve"
	DemInt(FoodItem, Node, Year) "Intercept of demand curve"
	DemCrossTerms(FoodItem, FoodItem, Node, Year) "Cross terms in demand curve"
;
