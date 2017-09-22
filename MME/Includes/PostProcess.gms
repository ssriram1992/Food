************************************************************************
**********************       POST-PROCESSING       *********************
************************************************************************

Parameter produce(*, Node, Season, Year);
produce(FoodItem, Node, Season, Year) = Q_FOOD.L(FoodItem, Node, Season, Year);
produce("Hide", Node, Season, Year) = Q_HIDE.L(Node, Season, Year);


Parameter Cows(*, Node, Season, Year);
Cows("Number", Node, Season, Year) = Q_CATTLE.L("Milk", Node, Season, Year);
Cows("Slaughter", Node, Season, Year) = Q_CATTLE_SL.L(Node, Season, Year);


Parameter Prices(*, *, Node, Season, Year);
Prices("Farmer", FoodItem, Node, Season, Year) = PI_FOOD.L(FoodItem, Node, Season, Year);
Prices("Distribution", FoodItem, Node, Season, Year) = PI_W.L(FoodItem, Node, Season, Year);
Prices("Store", FoodItem, Node, Season, Year) = PI_U.L(FoodItem, Node, Season, Year);
Prices("Cow", "Animal", Node, Season, Year) = PI_COW.L(Node, Season, Year);
Prices("Grid", "Electricity", Node, Season, Year) = D14.L(Node, Season, Year);

Parameter Elec(*, Node, Season, Year);
Elec("Production", Node, Season, Year) = Q_ELEC.L(Node, Season, Year);
Elec("Consumption", Node, Season, Year) = Q_ELEC_DEM.L(Node, Season, Year);
Elec("CapProduce", Node, Season, Year) = Cap_Elec(Node, Season, Year);
Elec("Price", Node, Season, Year) = D14.L(Node, Season, Year);

Parameter Transports(*, NodeFrom, Node, Season, Year);
Transports(FoodItem, NodeFrom, Node, Season, Year) = QF_ROAD.L(FoodItem, NodeFrom, Node, Season, Year);
Transports("Cow", NodeFrom, Node, Season, Year) = Q_CATTLE_BUY.L(NodeFrom, Node, Season, Year);
Transports("Electricity", NodeFrom, Node, Season, Year) = Q_ELEC_TRANS.L(NodeFrom, Node, Season, Year);

Parameter TranspCost(*, NodeFrom, Node, Season, Year);
TranspCost("RoadCong", NodeFrom, Node, Season, Year) = D16.L(NodeFrom, Node, Season, Year);
TranspCost("ElecCong", NodeFrom, Node, Season, Year) = d15.L(NodeFrom, Node, Season, Year);
TranspCost("Roadfix", NodeFrom, Node, Season, Year) =  sum(FoodItem, QF_ROAD.L(FoodItem, NodeFrom, Node, Season, Year)*CF_Road(FoodItem, NodeFrom, Node, Season, Year));
TranspCost("Elecfix", NodeFrom, Node, Season, Year) = Q_ELEC_TRANS.L(NodeFrom, Node, Season, Year)*C_Elec_Trans(NodeFrom, Node, Season, Year);


Parameter Storage(*, FoodItem, Node, Season, Year);
Storage("Purchase", FoodItem, Node, Season, Year) = Q_WB.L(FoodItem, Node, Season, Year);
Storage("Sold", FoodItem, Node, Season, Year) = Q_WS.L(FoodItem, Node, Season, Year);
Storage("Stored", FoodItem, Node, Season, Year) = Q_W.L(FoodItem, Node, Season, Year);


* Printing results to lst file
%RunningOnCluster%$ontext
Display AREA_CROP.L, Area_init;
Display Prices;
option produce:2:2:2;
Display produce;
option Cows:2:2:2;
Display Cows;
option Elec:2:2:2;
Display Elec;
$ontext
$offtext

