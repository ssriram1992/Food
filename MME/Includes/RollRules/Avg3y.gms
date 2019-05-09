************
$ontext
Period 2
$offtext
************

df_roll('Period2') = df(Year2Loop+1);

*** Crop Producer ***
C_prod_roll(FoodItem, Node, Season, 'Period2') 	= C_prod(FoodItem, Node, Season, Year2Loop);
C_convert_roll(Node, 'Period2') 				= C_convert(Node, Year2Loop);
C_chg_roll(Node, 'Period2') 					= C_chg(Node, Year2Loop);
Cyf_roll(FoodItem, Node, Season, 'Period2') 	= Cyf(FoodItem, Node, Season, Year2Loop);
aFAO_roll(FoodItem, Node, Season, 'Period2') 	= aFAO(FoodItem, Node, Season, Year2Loop);
Elas_roll(FoodItem, Node, Season, 'Period2') 	= Elas(FoodItem, Node, Season, Year2Loop);
Yield_roll(FoodItem, Node, Season, 'Period2') 	= Yield(FoodItem, Node, Season, Year2Loop);


*** Livestock ***
pr_Hide_roll(Node, Season, 'Period2')			= pr_Hide(Node, Season, Year2Loop);
Yld_H_roll(Node, Season, 'Period2')				= Yld_H(Node, Season, Year2Loop);
k_roll(Node, Season, 'Period2')					= k(Node, Season, Year2Loop);
kappa_roll(Node, Season, 'Period2')				= kappa(Node, Season, Year2Loop);
C_cow_roll(Node, Season, 'Period2')				= C_cow(Node, Season, Year2Loop);
C_cow_tr_roll(Node, NodeFrom, Season, 'Period2')= C_cow_tr(Node, NodeFrom, Season, Year2Loop);
CowDeath_roll(Node, Season, 'Period2')			= CowDeath(Node, Season, Year2Loop);

*** Distributors ***
CF_Road_roll(FoodItem, Node, NodeFrom, Season, 'Period2') = CF_Road(FoodItem, Node, NodeFrom, Season, Year2Loop);


*** Storage ***
CS_L_roll(FoodItem, Node, Season, 'Period2')		= CS_L(FoodItem, Node, Season, Year2Loop);
CS_Q_roll(FoodItem, Node, Season, 'Period2')		= CS_Q(FoodItem, Node, Season, Year2Loop);
CAP_Store_roll(FoodItem, Node, Season, 'Period2')	= CAP_Store(FoodItem, Node, Season, Year2Loop);


*** Consumers ***
DemSlope_roll(FoodItem, Node, Season, 'Period2')					= DemSlope(FoodItem, Node, Season, Year2Loop);
DemInt_roll(FoodItem, Node, Season, 'Period2')						= DemInt(FoodItem, Node, Season, Year2Loop);
DemCrossTerms_roll(FoodItem, FoodItem2, Node, Season, 'Period2')	= DemCrossTerms(FoodItem, FoodItem2, Node, Season, Year2Loop);

*** Electricity ***
C_Elec_L_roll(Node, Season, 'Period2')								= C_Elec_L(Node, Season, Year2Loop);
C_Elec_Q_roll(Node, Season, 'Period2')								= C_Elec_Q(Node, Season, Year2Loop);
C_Elec_Trans_roll(NodeFrom, Node, Season, 'Period2')				= C_Elec_Trans(NodeFrom, Node, Season, Year2Loop);
Cap_Elec_roll(Node, Season, 'Period2')								= Cap_Elec(Node, Season, Year2Loop);
Cap_Elec_Trans_roll(NodeFrom, Node, Season, 'Period2')				= Cap_Elec_Trans(NodeFrom, Node, Season, Year2Loop);
Base_Elec_Dem_roll(Node, Season, 'Period2')							= Base_Elec_Dem(Node, Season, Year2Loop);


************
$ontext
Period 3
$offtext
************


df_roll('Period3') = df(Year2Loop+2);

*** Crop Producer ***
C_prod_roll(FoodItem, Node, Season, 'Period3') 	= C_prod(FoodItem, Node, Season, Year2Loop);
C_convert_roll(Node, 'Period3') 				= C_convert(Node, Year2Loop);
C_chg_roll(Node, 'Period3') 					= C_chg(Node, Year2Loop);
Cyf_roll(FoodItem, Node, Season, 'Period3') 	= Cyf(FoodItem, Node, Season, Year2Loop);
aFAO_roll(FoodItem, Node, Season, 'Period3') 	= aFAO(FoodItem, Node, Season, Year2Loop);
Elas_roll(FoodItem, Node, Season, 'Period3') 	= Elas(FoodItem, Node, Season, Year2Loop);
Yield_roll(FoodItem, Node, Season, 'Period3') 	= Yield(FoodItem, Node, Season, Year2Loop);


*** Livestock ***
pr_Hide_roll(Node, Season, 'Period3')			= pr_Hide(Node, Season, Year2Loop);
Yld_H_roll(Node, Season, 'Period3')				= Yld_H(Node, Season, Year2Loop);
k_roll(Node, Season, 'Period3')					= k(Node, Season, Year2Loop);
kappa_roll(Node, Season, 'Period3')				= kappa(Node, Season, Year2Loop);
C_cow_roll(Node, Season, 'Period3')				= C_cow(Node, Season, Year2Loop);
C_cow_tr_roll(Node, NodeFrom, Season, 'Period3')= C_cow_tr(Node, NodeFrom, Season, Year2Loop);
CowDeath_roll(Node, Season, 'Period3')			= CowDeath(Node, Season, Year2Loop);

*** Distributors ***
CF_Road_roll(FoodItem, Node, NodeFrom, Season, 'Period3') = CF_Road(FoodItem, Node, NodeFrom, Season, Year2Loop);


*** Storage ***
CS_L_roll(FoodItem, Node, Season, 'Period3')		= CS_L(FoodItem, Node, Season, Year2Loop);
CS_Q_roll(FoodItem, Node, Season, 'Period3')		= CS_Q(FoodItem, Node, Season, Year2Loop);
CAP_Store_roll(FoodItem, Node, Season, 'Period3')	= CAP_Store(FoodItem, Node, Season, Year2Loop);


*** Consumers ***
DemSlope_roll(FoodItem, Node, Season, 'Period3')					= DemSlope(FoodItem, Node, Season, Year2Loop);
DemInt_roll(FoodItem, Node, Season, 'Period3')						= DemInt(FoodItem, Node, Season, Year2Loop);
DemCrossTerms_roll(FoodItem, FoodItem2, Node, Season, 'Period3')	= DemCrossTerms(FoodItem, FoodItem2, Node, Season, Year2Loop);

*** Electricity ***
C_Elec_L_roll(Node, Season, 'Period3')								= C_Elec_L(Node, Season, Year2Loop);
C_Elec_Q_roll(Node, Season, 'Period3')								= C_Elec_Q(Node, Season, Year2Loop);
C_Elec_Trans_roll(NodeFrom, Node, Season, 'Period3')				= C_Elec_Trans(NodeFrom, Node, Season, Year2Loop);
Cap_Elec_roll(Node, Season, 'Period3')								= Cap_Elec(Node, Season, Year2Loop);
Cap_Elec_Trans_roll(NodeFrom, Node, Season, 'Period3')				= Cap_Elec_Trans(NodeFrom, Node, Season, Year2Loop);
Base_Elec_Dem_roll(Node, Season, 'Period3')							= Base_Elec_Dem(Node, Season, Year2Loop);
`