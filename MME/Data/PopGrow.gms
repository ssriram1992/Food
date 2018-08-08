Parameter Consum_Year(FoodItem, Adapt);
Scalar PopGrowRate /0.025/;

Consum_Year(FoodItem, Adapt) = Consumption(Adapt, FoodItem)/(1-PopGrowRate);

Parameter El(FoodItem) /'Teff'	-0.9,
'Sorghum'	-0.75,
'Maize'	-0.8,
'Lentils'	-0.9,
'Vegetables'	-0.95,
'CashCrop'	-0.95,
'Beef'	-0.9,
'Milk'	-0.9,
'Wheat'	-0.9
/;


Loop(Year,
	Consum_Year(FoodItem, Adapt) = Consum_Year(FoodItem, Adapt)*(1+PopGrowRate);
	DemSlope(FoodItem, Adapt, Season, Year) = -El(FoodItem)*Consum_Year(FoodItem, Adapt)/Price(Adapt, FoodItem, Season);
	DemInt(FoodItem, Adapt, Season, Year) = Price(Adapt, FoodItem, Season) + DemSlope(FoodItem, Adapt, Season, Year)*Consum_Year(FoodItem, Adapt);
	);