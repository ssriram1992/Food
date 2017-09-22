************************************************************************
**********************       POST-PROCESSING       *********************
************************************************************************


produce(FoodItem, Node, Season, Year2Loop) = Q_FOOD.L(FoodItem, Node, Season, "Period1");
produce("Hide", Node, Season, Year2Loop) = Q_HIDE.L(Node, Season, "Period1");



Cows("Number", Node, Season, Year2Loop) = Q_CATTLE.L("Milk", Node, Season, "Period1");
Cows("Slaughter", Node, Season, Year2Loop) = Q_CATTLE_SL.L(Node, Season, "Period1");


Prices("Farmer", FoodItem, Node, Season, Year2Loop) = PI_FOOD.L(FoodItem, Node, Season, "Period1");
Prices("Distribution", FoodItem, Node, Season, Year2Loop) = PI_W.L(FoodItem, Node, Season, "Period1");
Prices("Store", FoodItem, Node, Season, Year2Loop) = PI_U.L(FoodItem, Node, Season, "Period1");
Prices("Cow", "Animal", Node, Season, Year2Loop) = PI_COW.L(Node, Season, "Period1");
Prices("Grid", "Electricity", Node, Season, Year2Loop) = D14.L(Node, Season, "Period1");


Elec("Production", Node, Season, Year2Loop) = Q_ELEC.L(Node, Season, "Period1");
Elec("Consumption", Node, Season, Year2Loop) = Q_ELEC_DEM.L(Node, Season, "Period1");
Elec("CapProduce", Node, Season, Year2Loop) = Cap_Elec_roll(Node, Season, "Period1");
Elec("Price", Node, Season, Year2Loop) = D14.L(Node, Season, "Period1");


Transports(FoodItem, NodeFrom, Node, Season, Year2Loop) = QF_ROAD.L(FoodItem, NodeFrom, Node, Season, "Period1");
Transports("Cow", NodeFrom, Node, Season, Year2Loop) = Q_CATTLE_BUY.L(NodeFrom, Node, Season, "Period1");
Transports("Electricity", NodeFrom, Node, Season, Year2Loop) = Q_ELEC_TRANS.L(NodeFrom, Node, Season, "Period1");

TranspCost("RoadCong", NodeFrom, Node, Season, Year2Loop) = D16.L(NodeFrom, Node, Season, "Period1");
TranspCost("ElecCong", NodeFrom, Node, Season, Year2Loop) = d15.L(NodeFrom, Node, Season, "Period1");
TranspCost("Roadfix", NodeFrom, Node, Season, Year2Loop) =  sum(FoodItem, QF_ROAD.L(FoodItem, NodeFrom, Node, Season, "Period1")*CF_Road_roll(FoodItem, NodeFrom, Node, Season, "Period1"));
TranspCost("Elecfix", NodeFrom, Node, Season, Year2Loop) = Q_ELEC_TRANS.L(NodeFrom, Node, Season, "Period1")*C_Elec_Trans_roll(NodeFrom, Node, Season, "Period1");


Storage("Purchase", FoodItem, Node, Season, Year2Loop) = Q_WB.L(FoodItem, Node, Season, "Period1");
Storage("Sold", FoodItem, Node, Season, Year2Loop) = Q_WS.L(FoodItem, Node, Season, "Period1");
Storage("Stored", FoodItem, Node, Season, Year2Loop) = Q_W.L(FoodItem, Node, Season, "Period1");


* Printing results to lst file

