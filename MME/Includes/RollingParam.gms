df_roll('Period1') = df(Year2Loop);

*** Crop Producer ***
C_prod_roll(FoodItem, Node, Season, 'Period1') 	= C_prod(FoodItem, Node, Season, Year2Loop);
C_convert_roll(Node, 'Period1') 				= C_convert(Node, Year2Loop);
C_chg_roll(Node, 'Period1') 					= C_chg(Node, Year2Loop);
Cyf_roll(FoodItem, Node, Season, 'Period1') 	= Cyf(FoodItem, Node, Season, Year2Loop);
aFAO_roll(FoodItem, Node, Season, 'Period1') 	= aFAO(FoodItem, Node, Season, Year2Loop);
Elas_roll(FoodItem, Node, Season, 'Period1') 	= Elas(FoodItem, Node, Season, Year2Loop);
Yield_roll(FoodItem, Node, Season, 'Period1') 	= Yield(FoodItem, Node, Season, Year2Loop);


*** Livestock ***
pr_Hide_roll(Node, Season, 'Period1')			= pr_Hide(Node, Season, Year2Loop);
Yld_H_roll(Node, Season, 'Period1')				= Yld_H(Node, Season, Year2Loop);
k_roll(Node, Season, 'Period1')					= k(Node, Season, Year2Loop);
kappa_roll(Node, Season, 'Period1')				= kappa(Node, Season, Year2Loop);
C_cow_roll(Node, Season, 'Period1')				= C_cow(Node, Season, Year2Loop);
C_cow_tr_roll(Node, NodeFrom, Season, 'Period1')= C_cow_tr(Node, NodeFrom, Season, Year2Loop);
CowDeath_roll(Node, Season, 'Period1')			= CowDeath(Node, Season, Year2Loop);

*** Distributors ***
CF_Road_roll(FoodItem, Node, NodeFrom, Season, 'Period1') = CF_Road(FoodItem, Node, NodeFrom, Season, Year2Loop);


*** Storage ***
CS_L_roll(FoodItem, Node, Season, 'Period1')		= CS_L(FoodItem, Node, Season, Year2Loop);
CS_Q_roll(FoodItem, Node, Season, 'Period1')		= CS_Q(FoodItem, Node, Season, Year2Loop);
CAP_Store_roll(FoodItem, Node, Season, 'Period1')	= CAP_Store(FoodItem, Node, Season, Year2Loop);


*** Consumers ***
DemSlope_roll(FoodItem, Node, Season, 'Period1')					= DemSlope(FoodItem, Node, Season, Year2Loop);
DemInt_roll(FoodItem, Node, Season, 'Period1')						= DemInt(FoodItem, Node, Season, Year2Loop);
DemCrossTerms_roll(FoodItem, FoodItem2, Node, Season, 'Period1')	= DemCrossTerms(FoodItem, FoodItem2, Node, Season, Year2Loop);

*** Electricity ***
C_Elec_L_roll(Node, Season, 'Period1')								= C_Elec_L(Node, Season, Year2Loop);
C_Elec_Q_roll(Node, Season, 'Period1')								= C_Elec_Q(Node, Season, Year2Loop);
C_Elec_Trans_roll(NodeFrom, Node, Season, 'Period1')				= C_Elec_Trans(NodeFrom, Node, Season, Year2Loop);
Cap_Elec_roll(Node, Season, 'Period1')								= Cap_Elec(Node, Season, Year2Loop);
Cap_Elec_Trans_roll(NodeFrom, Node, Season, 'Period1')				= Cap_Elec_Trans(NodeFrom, Node, Season, Year2Loop);
Base_Elec_Dem_roll(Node, Season, 'Period1')							= Base_Elec_Dem(Node, Season, Year2Loop);
