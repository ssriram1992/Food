Area_init(Node, Season, FoodItem) = AREA_CROP.L(FoodItem, Node, Season, "Period1");
InitCow(Node) = sum((FoodItem, Season), Q_CATTLE.L(FoodItem, Node, Season, "Period1")$(ORD(Season)=CARD(Season)));
q_WInit(FoodItem, Node) = sum(Season, Q_W.L(FoodItem, Node, Season, "Period1")$(ORD(Season)=CARD(Season)));