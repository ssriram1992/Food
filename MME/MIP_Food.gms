$TITLE "INFEWS FOOD MODEL"

************************************************************************
************************       SETTINGS       **************************
************************************************************************

$SETGLOBAL Limit_Listing "*"
$SETGLOBAL RunningOnCluster ""

$SETGLOBAL Scenario "Base_MIP"
$SETGLOBAL FutureKnowledge "Current"

$SETGLOBAL DataFile "Data/DataGdx"

* Remember to specify in Includes/PointLoad.gms on what years to be used with existing point
$SETGLOBAL UseInitialPoint "*"
$SETGLOBAL Point "%Scenario%_%FutureKnowledge%"
$SETGLOBAL Point "Food_Base"
$SETGLOBAL MIP "Positive "


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
*option solvelink=5;

Sets
Year "Years" /2015*2017/
;

$INCLUDE Includes/ControlPanel.gms
$INCLUDE Includes/PrimalDecl.gms
$INCLUDE Includes/DualDecl.gms
$INCLUDE Includes/DataLoad.gms


* Including Scenario File
$if exist Data/%Scenario% $include Data/%Scenario%.gms
$if exist Data/%Scenario% Display 'Data/%Scenario%.gms loaded' ;
$if not exist Data/%Scenario% Display 'Data/%Scenario%.gms does not exist. Running Base Scenario' ;

$INCLUDE Includes/PrimalEqLin.gms
$INCLUDE Includes/DualEqLin.gms

$INCLUDE Includes/DisjunPrimal.gms
$INCLUDE Includes/DisjunctDual.gms

**************************************************************
*********OBJECTIVE********************************************
**************************************************************
Equation objEq;
Variable obj;
objEq.. obj =e= 0;

Model FoodMIP /
all
/;

option MIP=cplex;
option optcr=0.99;
FoodMIP.savepoint = 2;
*q_Ws.lo(FoodItem, Node, Season, Year) = Consumption(FoodItem, Node, Season, Year);


$INCLUDE Includes/PointLoad.gms
option reslim=10000000;





Loop(Year2Loop$(ORD(Year2Loop)+card(Period)-1<=Card(Year2Loop)),


%UseInitialPoint%$ONTEXT
put_utility 'gdxin' / 'auxiliary/%Point%_'Year2Loop.tl:0 ;

if(Years2PtLoad(Year2Loop),
execute_load  D1, D2, D18, Q_FOOD, AREA_CROP, Q_FOOD_TRANS, D3, D4, PI_COW, D9, D10, Q_CATTLE, Q_CATTLE_BUY, Q_HIDE, Q_CATTLE_SL, PI_FOOD_ADMIN, D6, D16, QF_DB, QF_ROAD, QF_DS, PI_W, D8, D11, Q_WB, Q_WS, Q_W, PI_U, D19, D17, Q_WU, Q_U, D13, D14, D15, Q_ELEC, Q_ELEC_TRANS, Q_ELEC_DEM ;
*execute_load  E1_2b, D1, E1_2cd, D2, E1_2e, D18, E1_3a, Q_FOOD, E1_3b, AREA_CROP, E1_3c, Q_FOOD_TRANS, E2_2b, D3, E2_2c, D4, E2_2d, PI_COW, E2_2e, D9, E2_2f, D10, E2_3a, Q_CATTLE, E2_3b, Q_CATTLE_BUY, E2_3c, Q_HIDE, E2_3d, Q_CATTLE_SL, E2_4a, PI_FOOD_ADMIN, E3_2b, D6, E3_2c, D7, E3_2d, D16, E3_3a, QF_DB, E3_3b, QF_ROAD, E3_3c, QF_DS, E3_4a, PI_W, E4_2a, D8, E4_2b, D11, E4_3a, Q_WB, E4_3b, Q_WS, E4_3c, Q_W, E4_4a, PI_U, E5_2a, D19, E5_2b, D17, E5_3a, Q_WU, E5_3b, Q_U, E6_2a, D13, E6_2b, D14, E6_2c, D15, E6_3a, Q_ELEC, E6_3b, Q_ELEC_TRANS, E_ElecDem, Q_ELEC_DEM ;
);
$ONTEXT
$OFFTEXT

$INCLUDE Includes/RollingParam.gms
$INCLUDE Includes/RollRules/%FutureKnowledge%
*$INCLUDE Includes/EstimTransp.gms

        Solve FoodMIP use MIP min obj;
        SolveCount = SolveCount + 1;

$INCLUDE Includes/ContinueRoll.gms
$INCLUDE Includes/PostProcess.gms
);



Parameter dbgPrn(*);
dbgPrn('CowTr ExtA1') = C_cow_tr_roll('External', 'A1', 'Kremt', 'Period1');
dbgPrn('CowTr A1Ext') = C_cow_tr_roll('A1', 'External', 'Kremt', 'Period1');
dbgPrn('CowpriceA1') = PI_COW.L('A1', 'Kremt', 'Period1');
dbgPrn('CowpriceExt') = PI_COW.L('External', 'Kremt', 'Period1');


Display dbgPrn;




%RunningOnCluster%$ontext
option Prices:2:1:2;
Display Prices;
option produce:2:1:3;
Display produce;

* Exporting results
execute_unload 'Results/MIP%Scenario%';

$ontext
Parameters t1,t2,t3(Node),t4(Node),t5,t6, t7, t8, t9;
t1 = QF_DB.L("Teff", "AddisAbaba","Kremt", "Period1");
t2 = QF_DS.L("Teff", "AddisAbaba","Kremt", "Period1");
t3(NodeFrom) = QF_ROAD.L("Teff", NodeFrom, "AddisAbaba", "Kremt", "Period1");
t4(Node) = QF_ROAD.L("Teff", "AddisAbaba", Node, "Kremt", "Period1");
t5 = sum(Node, t3(Node));
t6 = sum(Node, t4(Node));
t7 = t1+t5 - t2-t6;
Parameters start(node), end(node);
start(node) = QF_DB.L("Teff", Node,"Kremt", "Period1");
end(node) = QF_DS.L("Teff", Node,"Kremt", "Period1");

t8 = sum(Node, QF_DB.L("Teff", Node, "Kremt", "Period1"));
t9 = sum(Node, QF_DS.L("Teff", Node, "Kremt", "Period1"));
Display t1,t2,t3,t4,t5,t6,t7, t8,t9;
Parameters t1(FoodItem, Adapt), t2(FoodItem, Adapt);
t1(FoodItem, Adapt) = DemInt1('Kremt', FoodItem, Adapt);
t2(FoodItem, Adapt) = DemInt1('Belg', FoodItem, Adapt);
Display t1, t2;
$offtext
