$TITLE "INFEWS FOOD MODEL"

************************************************************************
************************       SETTINGS       **************************
************************************************************************

$SETGLOBAL Limit_Listing ""

$SETGLOBAL DataFile "Data/DataGdx"

* Remember to specify in Includes/PointLoad.gms on what years to be used with existing point
$SETGLOBAL UseInitialPoint ""
$SETGLOBAL Point "Base_Current"



%Limit_Listing%$ONTEXT
$offlisting
option dispwidth=60;
$inlinecom /* */
$offsymlist
$Offsymxref
$oninline
Option Solprint = off;
Option limrow = 0;
Option limcol = 0;
$ONTEXT
$OFFTEXT
option solvelink=5;

Sets
Year "Years" /2015*2017/
;

$INCLUDE Includes/ControlPanel.gms
$INCLUDE Includes/PrimalDecl.gms
$INCLUDE Includes/DualDecl.gms
$INCLUDE Includes/DataLoad.gms


$INCLUDE Includes/PrimalEq.gms
$INCLUDE Includes/DualEq.gms

Equations
E_Supply_Cost
E_Dem_Cons(FoodItem, Adapt, Season, Period)
;

Variable Obj;

E_Supply_Cost.. Obj =e= sum((Period, Season), df_roll(Period)*
* Crop Production costs
	sum((Adapt, FoodItem)$Crop(FoodItem), C_prod_roll(FoodItem, Adapt, Season, Period)*AREA_CROP(FoodItem, Adapt, Season, Period) + 
	0.5* C_chg_roll(Adapt, Period)*SQR(AREA_CROP(FoodItem, Adapt, Season, Period) - AREA_CROP(FoodItem, Adapt, Season, Period-1) - Area_init(Adapt, Season,  FoodItem)$(Ord(Period)=1) ) 
	 )+
* Livestock costs
	sum((Adapt, FoodItem), Q_CATTLE(FoodItem, Adapt, Season, Period)*C_cow_roll(Adapt, Season, Period))+
* Distribution costs
	sum((NodeFrom, Node, FoodItem), CF_Road_roll(FoodItem, NodeFrom, Node, Season, Period)* QF_ROAD(FoodItem, NodeFrom, Node, Season, Period)) + 
* Storage Costs
	sum((Node, FoodItem), 0.5*CS_Q_roll(FoodItem, Node, Season, Period)*SQR(Q_W(FoodItem, Node, Season, Period)) + CS_L_roll(FoodItem, Node, Season, Period)*Q_W(FoodItem, Node, Season, Period))+
* Electricity Generation cost
	sum(Node, 0.5*C_Elec_Q_roll(Node, Season, Period)*SQR(Q_ELEC(Node, Season, Period) + C_Elec_L_roll(Node, Season, Period)*Q_ELEC(Node, Season, Period)))+
* Electricity Transmission cost
	sum((NodeFrom, Node), C_Elec_Trans_roll(NodeFrom, Node, Season, Period) * Q_ELEC_TRANS(NodeFrom, Node, Season, Period))
	);


E_Dem_Cons(FoodItem, Adapt, Season, Period).. Q_U(FoodItem, Adapt, Season, Period) =g= Consumption(Adapt, FoodItem)/2;

Q_U.L(FoodItem, Adapt, Season, Period) = Consumption(Adapt, FoodItem)/2;


Model Supply_Price /
E1_2b
E1_2cd
E2_2b
E2_2c
E2_2d
E2_2e
E2_2f
E2_4a
E2_4b
E3_2b
E3_2c
E3_2d
E4_2a
E4_2b
E4_4a
E4_4b
E5_1a
E5_1b
E5_1c
E6_2a
E6_2b
E6_2c
E_ElecDem
E_Supply_Cost
E_Dem_Cons
/;
Supply_Price.savepoint = 2;
*q_Ws.lo(FoodItem, Node, Season, Year) = Consumption(FoodItem, Node, Season, Year);



$INCLUDE Includes/PointLoad.gms
option reslim=10000000;
Loop(Year2Loop$(ORD(Year2Loop)+card(Period)-1<=Card(Year2Loop)),


%UseInitialPoint%$ONTEXT
put_utility 'gdxin' / 'auxiliary/%Point%_'Year2Loop.tl:0 ;
execute_load$(Years2PtLoad(Year2Loop)) ;
$ONTEXT
$OFFTEXT

$INCLUDE Includes/RollingParam.gms
$INCLUDE Includes/RollRules/Current

Q_FOOD.L("Milk", Adapt, Season, Period) = Yield_roll("Milk", Adapt, Season, Period)*InitCow(Adapt);
Q_FOOD.L("Beef", Adapt, Season, Period) = Yield_roll("Beef", Adapt, Season, Period)*(InitCow(Adapt) - HerdSize(Adapt));

        Solve Supply_Price using NLP min obj;
        SolveCount = SolveCount + 1;

*$INCLUDE Includes/ContinueRoll.gms
*$INCLUDE Includes/PostProcess.gms
);



*Display Prices;
*option produce:2:2:2;
*Display produce;
*option Cows:2:2:2;
*Display Cows;
*option Elec:2:2:2;
*Display Elec;

* Exporting results
execute_unload 'Results/Supply_Price';

Parameters t1,t2,t3, t5;
Scalar t4;
t1 = Q_FOOD.L("CashCrop", "SM2N", "Belg", "Period3");
t2 = aFAO_roll("CashCrop", "SM2N", "Belg", "Period3");
t3 = Cyf_roll("CashCrop", "SM2N", "Belg", "Period3");
t4 = AREA_CROP.L("CashCrop", "SM2N", "Belg", "Period3");
t5 = t2*t3*t4;
Display t1,t2,t3,t4, t5;