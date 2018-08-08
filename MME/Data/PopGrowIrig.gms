Parameter Consum_Year(Adapt, FoodItem), Prod_Year(Adapt, Season, FoodItem);
Scalar PopGrowRate /0.025/;
Scalar CyfGrowRate /0.025/;

Consum_Year(Adapt, FoodItem) = Consumption(Adapt, FoodItem)/(1-PopGrowRate);

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
	Consum_Year(Adapt, FoodItem) = Consum_Year(Adapt, FoodItem)*(1+PopGrowRate);
	DemSlope(FoodItem, Adapt, Season, Year) = -El(FoodItem)*Consum_Year(Adapt, FoodItem)/Price(Adapt, FoodItem, Season);
	DemInt(FoodItem, Adapt, Season, Year) = Price(Adapt, FoodItem, Season) + DemSlope(FoodItem, Adapt, Season, Year)*Consum_Year(Adapt, FoodItem);


    Q_U.L(FoodItem, Adapt, Season, Period)$(ORD(Period)=ORD(Year)) = Consum_Year(Adapt, FoodItem);
    Q_WS.L(FoodItem, Node, Season, Period)$(ORD(Period)=ORD(Year)) = sum(Adapt, Adapt2Node(Adapt, Node)*Consum_Year(Adapt, FoodItem) ) ;
    Q_WU.L(FoodItem, Node, Adapt, Season, Period)$(ORD(Period)=ORD(Year)) = Consum_Year(Adapt, FoodItem)*Adapt2Node(Adapt, Node);

	);

Loop(Year$(ORD(Year)>=2),
	Cyf(FoodItem, Adapt, Season, Year) = min(Cyf(FoodItem, Adapt, Season, Year-1)*(1+CyfGrowRate), 1);
    Prod_Year(Adapt, Season, FoodItem) = aFAO(FoodItem, Adapt, Season, Year)*Cyf(FoodItem, Adapt, Season, Year)*Area_init(Adapt, Season,  FoodItem);

    Q_FOOD.L(FoodItem, Adapt, Season, Period)$(ORD(Period)=ORD(Year)) = Prod_Year(Adapt, Season, FoodItem);
    Q_FOOD_TRANS.L(FoodItem, Adapt, Node, Season, Period)$(ORD(Period)=ORD(Year)) = Adapt2Node(Adapt, Node)*Prod_Year(Adapt, Season, FoodItem);
    QF_DB.L(FoodItem, Node, Season, Period)$(ORD(Period)=ORD(Year)) = sum(Adapt, Adapt2Node(Adapt, Node)*Prod_Year(Adapt, Season, FoodItem));

	);
