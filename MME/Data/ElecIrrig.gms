* Hydel capacity goes down, more electricity from other sources in Afar.
Cap_Elec(Node, Season, Year) = MAX(Cap_Elec(Node, Season, Year)-0.2,0);
Cap_Elec('Afar', Season, Year) = 40;

* Marginal increase in crop productivity
CYF(FoodItem, Node, Season, Year) = CYF(FoodItem, Node, Season, Year)*1.1;

* Marginal increase in farming cost
C_prod(FoodItem, Node, Season, Year) = C_prod(FoodItem, Node, Season, Year)*1.1;