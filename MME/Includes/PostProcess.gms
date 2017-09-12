************************************************************************
**********************       POST-PROCESSING       *********************
************************************************************************

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
%RunningOnCluster%$ontext
Display Area_Crop.L, Area_init;
Display Prices;
option produce:2:2:2;
Display produce;
option Cows:2:2:2;
Display Cows;
option Elec:2:2:2;
Display Elec;
$ontext
$offtext

