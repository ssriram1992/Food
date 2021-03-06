$TITLE "INFEWS FOOD MODEL"

************************************************************************
************************       SETTINGS       **************************
************************************************************************

$SETGLOBAL Limit_Listing ""
$SETGLOBAL RunningOnCluster ""

$SETGLOBAL Scenario "Multi"
$SETGLOBAL FutureKnowledge "Current"

$SETGLOBAL DataFile "Data/DataGdx"
$SETGLOBAL RemoveLiveStock ""

* Remember to specify in Includes/PointLoad.gms on what years to be used with existing point
$SETGLOBAL UseInitialPoint "*"
$SETGLOBAL Point "%Scenario%_%FutureKnowledge%"
$SETGLOBAL Point "Food_Base"
*$SETGLOBAL Point "Base2_Current"
$SETGLOBAL MIP ""



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
Year "Years" /2015*2027/
;

$INCLUDE Includes/ControlPanel.gms
$INCLUDE Includes/PrimalDecl.gms
$INCLUDE Includes/DualDecl.gms
$INCLUDE Includes/DataLoad.gms
$INCLUDE Includes/Calibration.gms


* Including Scenario File
$if exist Data/%Scenario% $include Data/%Scenario%.gms
$if exist Data/%Scenario% Display 'Data/%Scenario%.gms loaded' ;
$if not exist Data/%Scenario% Display 'Data/%Scenario%.gms does not exist. Running Base Scenario' ;

$INCLUDE Includes/PrimalEq.gms
$INCLUDE Includes/DualEq.gms


Model Food1y /
E1_2b.D1
E1_2cd.D2
E1_2e.D18
E1_3a.Q_FOOD
E1_3b.AREA_CROP
E1_3c.Q_FOOD_TRANS
E2_2b.D3
E2_2c.D4
E2_2d.PI_COW
E2_2e.D9
E2_2f.D10
E2_3a.Q_CATTLE
E2_3b.Q_CATTLE_BUY
E2_3c.Q_HIDE
E2_3d.Q_CATTLE_SL
E2_4a.PI_FOOD_ADMIN
E3_2b.D6
E3_2c.D7
E3_2d.D16
E3_3a.QF_DB
E3_3b.QF_ROAD
E3_3c.QF_DS
E3_4a.PI_W
E4_2a.D8
E4_2b.D11
E4_3a.Q_WB
E4_3b.Q_WS
E4_3c.Q_W
E4_4a.PI_U
E5_2a.D19
E5_2b.D17
E5_3a.Q_WU
E5_3b.Q_U
E6_2a.D13
E6_2b.D14
E6_2c.D15
E6_3a.Q_ELEC
E6_3b.Q_ELEC_TRANS
E_ElecDem.Q_ELEC_DEM
/;
Food1y.savepoint = 2;
*q_Ws.lo(FoodItem, Node, Season, Year) = Consumption(FoodItem, Node, Season, Year);


$INCLUDE Includes/PointLoad.gms
option reslim=10000000;
scalar oldWt /0.5/;




Loop(Year2Loop$(ORD(Year2Loop)+card(Period)-1<=Card(Year2Loop)),


%UseInitialPoint%$ONTEXT
put_utility 'gdxin' / 'auxiliary/%Point%_'Year2Loop.tl:0 ;

if(Years2PtLoad(Year2Loop),
execute_load  E1_2b, D1, E1_2cd, D2, E1_2e, D18, E1_3a, Q_FOOD, E1_3b, AREA_CROP, E1_3c, Q_FOOD_TRANS, E2_2b, D3, E2_2c, D4, E2_2d, PI_COW, E2_2e, D9, E2_2f, D10, E2_3a, Q_CATTLE, E2_3b, Q_CATTLE_BUY, E2_3c, Q_HIDE, E2_3d, Q_CATTLE_SL, E2_4a, PI_FOOD_ADMIN, E3_2b, D6, E3_2c, E3_2d, D16, E3_3a, QF_DB, E3_3b, QF_ROAD, E3_3c, QF_DS, E3_4a, PI_W, E4_2a, D8, E4_2b, D11, E4_3a, Q_WB, E4_3b, Q_WS, E4_3c, Q_W, E4_4a, PI_U, E5_2a, D19, E5_2b, D17, E5_3a, Q_WU, E5_3b, Q_U, E6_2a, D13, E6_2b, D14, E6_2c, D15, E6_3a, Q_ELEC, E6_3b, Q_ELEC_TRANS, E_ElecDem, Q_ELEC_DEM ;
*execute_load  E1_2b, D1, E1_2cd, D2, E1_2e, D18, E1_3a, Q_FOOD, E1_3b, AREA_CROP, E1_3c, Q_FOOD_TRANS, E2_2b, D3, E2_2c, D4, E2_2d, PI_COW, E2_2e, D9, E2_2f, D10, E2_3a, Q_CATTLE, E2_3b, Q_CATTLE_BUY, E2_3c, Q_HIDE, E2_3d, Q_CATTLE_SL, E2_4a, PI_FOOD_ADMIN, E3_2b, D6, E3_2c, D7, E3_2d, D16, E3_3a, QF_DB, E3_3b, QF_ROAD, E3_3c, QF_DS, E3_4a, PI_W, E4_2a, D8, E4_2b, D11, E4_3a, Q_WB, E4_3b, Q_WS, E4_3c, Q_W, E4_4a, PI_U, E5_2a, D19, E5_2b, D17, E5_3a, Q_WU, E5_3b, Q_U, E6_2a, D13, E6_2b, D14, E6_2c, D15, E6_3a, Q_ELEC, E6_3b, Q_ELEC_TRANS, E_ElecDem, Q_ELEC_DEM ;
);
$ONTEXT
$OFFTEXT

$INCLUDE Includes/RollingParam.gms
$INCLUDE Includes/RollRules/%FutureKnowledge%
if(Ord(Year2Loop)>=2,
$INCLUDE Includes/EstimTransp.gms
);

        Solve Food1y using MCP;
        SolveCount = SolveCount + 1;

$INCLUDE Includes/ContinueRoll.gms
$INCLUDE Includes/PostProcess.gms
);



%RunningOnCluster%$ontext
option Prices:2:1:2;
Display Prices;
option produce:2:1:3;
Display produce;
$ontext
$offtext

* Exporting results
execute_unload 'Results/%Scenario%';

Parameters t1(Adapt, Season, FoodItem);
t1(Adapt, Season, FoodItem) = Area_Crop.L(FoodItem, Adapt, Season, 'Period1');
Display t1, Area_init;
Display q_WInit;
