



Area_init(Adapt, Season, FoodItem) = AREA_CROP.L(FoodItem, Adapt, Season, "Period1")*(1-oldWt) + Area_init(Adapt, Season, FoodItem)*oldWt ;



*Area_init(Adapt, Season, FoodItem) = AREA_CROP.L(FoodItem, Adapt, Season, "Period1");
%RemoveLiveStock%InitCow(Adapt) = sum((FoodItem, Season), Q_CATTLE.L(FoodItem, Adapt, Season, "Period1")$(ORD(Season)=CARD(Season)));
q_WInit(FoodItem, Node) = sum(Season, Q_W.L(FoodItem, Node, Season, "Period1")$(ORD(Season)=CARD(Season)));
