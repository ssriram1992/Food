* Hydel capacity goes down, more electricity from other sources in Afar.
Cap_Elec(Node, Season, Year) = Cap_Elec(Node, Season, Year)/1.1;
Cap_Elec('Afar', Season, Year) = 40;

* Marginal increase in farming cost
C_prod(FoodItem, Node, Season, Year) = C_prod(FoodItem, Node, Season, Year)*1.1;

* 25 percent reduction in all food crop production, 50% reduction in Teff production all over the country.
aFAO(FoodItem, Node, Season, '2020') = aFAO(FoodItem, Node, Season, '2020')*0.75;
aFAO('Teff', Node, Season, '2020') = aFAO('Teff', Node, Season, '2020')*2/3;

* Marginal increase in crop productivity
CYF(FoodItem, Node, Season, Year) = CYF(FoodItem, Node, Season, Year)*1.1;


* Increased irrigation in 2020
Cap_Elec(Node, Season, '2020') = Cap_Elec(Node, Season, '2020')/1.1;
Cap_Elec('Afar', Season, '2020') = 60;
* Increased productivity in 2020
CYF(FoodItem, Node, Season, '2020') = CYF(FoodItem, Node, Season, '2020')*1.20;
CYF('Teff', Node, Season, '2020') = CYF('Teff', Node, Season, '2020')*1.20;
C_prod(FoodItem, Node, Season, '2020') = C_prod(FoodItem, Node, Season, '2020')*1.05;