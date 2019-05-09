
aFAO(FoodItem, Node, Season, Year) = aFAO(FoodItem, Node, Season, Year)*(1+ORD(Year)*0.1);
DemInt(FoodItem, Node, Season, Year) = DemInt(FoodItem, Node, Season, Year)*(1 - ORD(Year)*0.05);
