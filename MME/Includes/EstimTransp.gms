
LOOP(FoodItem$Crop(FoodItem),
	p_area_crop(Adapt, Season) = AREA_CROP.L(FoodItem, Adapt, Season, 'Period2');
	p_q_food(Adapt, Season) = aFAO_roll(FoodItem, Adapt, Season, 'Period1')*Cyf_roll(FoodItem, Adapt, Season, 'Period1')*p_area_crop(Adapt, Season);
	p_q_city_Start(Node, Season) = sum(Adapt, Adapt2Node(Adapt, Node)*p_q_food(Adapt, Season));
	p_consm(Adapt, Season) = Q_U.L(FoodItem, Adapt, Season, 'Period2');
	p_consm(Adapt, Season) = p_consm(Adapt, Season)/sum((Adapt2, Season2), p_consm(Adapt2, Season2))*sum((Adapt2, Season2), p_q_food(Adapt2, Season2));
	p_q_city_End(Node, Season) = sum(Adapt, Adapt2Node(Adapt, Node)*p_consm(Adapt, Season));
	Solve EstimTransp using LP maximizing P_OBJ;
	QF_ROAD.L(FoodItem, NodeFrom, Node, Season, Period) = P_TRANSP.L(NodeFrom, Node, Season);
	AREA_CROP.L(FoodItem, Adapt, Season, Period) = p_area_crop(Adapt, Season);
	Q_FOOD.L(FoodItem, Adapt, Season, Period) = p_q_food(Adapt, Season);
	Q_U.L(FoodItem, Adapt, Season, Period) = p_consm(Adapt, Season);
	Q_WS.L(FoodItem, Node, Season, Period) = sum(Adapt, Adapt2Node(Adapt, Node)*p_consm(Adapt, Season)) ;
	Q_WU.L(FoodItem, Node, Adapt, Season, Period) = p_consm(Adapt, Season)*Adapt2Node(Adapt, Node);
);

Q_FOOD_TRANS.L(FoodItem, Adapt, Node, Season, Period) = Adapt2Node(Adapt, Node)*Q_FOOD.L(FoodItem, Adapt, Season, Period);
QF_DB.L(FoodItem, Node, Season, Period) = sum(Adapt, Adapt2Node(Adapt, Node)*Q_FOOD_TRANS.L(FoodItem, Adapt, Node, Season, Period));
