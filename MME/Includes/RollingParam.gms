df_roll('Period1') = df(Year2Loop);

*** Crop Producer ***
C_prod_roll(FoodItem, Adapt, Season, 'Period1') 	= C_prod(FoodItem, Adapt, Season, Year2Loop);
C_convert_roll(Adapt, 'Period1') 				= C_convert(Adapt, Year2Loop);
C_chg_roll(Adapt, 'Period1') 					= C_chg(Adapt, Year2Loop);
Cyf_roll(FoodItem, Adapt, Season, 'Period1') 	= Cyf(FoodItem, Adapt, Season, Year2Loop);
aFAO_roll(FoodItem, Adapt, Season, 'Period1') 	= aFAO(FoodItem, Adapt, Season, Year2Loop);
Elas_roll(FoodItem, Adapt, Season, 'Period1') 	= Elas(FoodItem, Adapt, Season, Year2Loop);


*** Livestock ***
Yield_roll(FoodItem, Adapt, Season, 'Period1') 	= Yield(FoodItem, Adapt, Season, Year2Loop);
pr_Hide_roll(Adapt, Season, 'Period1')			= pr_Hide(Adapt, Season, Year2Loop);
Yld_H_roll(Adapt, Season, 'Period1')				= Yld_H(Adapt, Season, Year2Loop);
k_roll(Adapt, Season, 'Period1')					= k(Adapt, Season, Year2Loop);
kappa_roll(Adapt, Season, 'Period1')				= kappa(Adapt, Season, Year2Loop);
C_cow_roll(Adapt, Season, 'Period1')				= C_cow(Adapt, Season, Year2Loop);
C_cow_tr_roll(Adapt, AdaptFrom, Season, 'Period1')= C_cow_tr(Adapt, AdaptFrom, Season, Year2Loop);
CowDeath_roll(Adapt, Season, 'Period1')			= CowDeath(Adapt, Season, Year2Loop);

*** Distributors ***
CF_Road_roll(FoodItem, Node, NodeFrom, Season, 'Period1') = CF_Road(FoodItem, Node, NodeFrom, Season, Year2Loop);


*** Storage ***
CS_L_roll(FoodItem, Node, Season, 'Period1')		= CS_L(FoodItem, Node, Season, Year2Loop);
CS_Q_roll(FoodItem, Node, Season, 'Period1')		= CS_Q(FoodItem, Node, Season, Year2Loop);
CAP_Store_roll(FoodItem, Node, Season, 'Period1')	= CAP_Store(FoodItem, Node, Season, Year2Loop);


*** Consumers ***
DemSlope_roll(FoodItem, Adapt, Season, 'Period1')					= DemSlope(FoodItem, Adapt, Season, Year2Loop);
DemInt_roll(FoodItem, Adapt, Season, 'Period1')						= DemInt(FoodItem, Adapt, Season, Year2Loop);
DemCrossTerms_roll(FoodItem, FoodItem2, Adapt, Season, 'Period1')	= DemCrossTerms(FoodItem, FoodItem2, Adapt, Season, Year2Loop);

*** Electricity ***
C_Elec_L_roll(Node, Season, 'Period1')								= C_Elec_L(Node, Season, Year2Loop);
C_Elec_Q_roll(Node, Season, 'Period1')								= C_Elec_Q(Node, Season, Year2Loop);
C_Elec_Trans_roll(NodeFrom, Node, Season, 'Period1')				= C_Elec_Trans(NodeFrom, Node, Season, Year2Loop);
Cap_Elec_roll(Node, Season, 'Period1')								= Cap_Elec(Node, Season, Year2Loop);
Cap_Elec_Trans_roll(NodeFrom, Node, Season, 'Period1')				= Cap_Elec_Trans(NodeFrom, Node, Season, Year2Loop);
Base_Elec_Dem_roll(Node, Season, 'Period1')							= Base_Elec_Dem(Node, Season, Year2Loop);
