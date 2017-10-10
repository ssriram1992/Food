$TITLE "INFEWS FOOD MODEL"

************************************************************************
************************       SETTINGS       **************************
************************************************************************

$SETGLOBAL Detailed_Listing "*"
$SETGLOBAL RunningOnCluster "*"

$SETGLOBAL Scenario "Base"
$SETGLOBAL FutureKnowledge "Current"

$SETGLOBAL DataFile "Data/DataGdx"

$SETGLOBAL UseInitialPoint "*"
$SETGLOBAL Point "Results/%Scenario%"



%Detailed_Listing%$ontext
$offlisting
option dispwidth=60;
$inlinecom /* */
$offsymlist
$Offsymxref
$oninline
Option Solprint = off;
Option limrow = 0;
Option limcol = 0;
$ontext
$offtext
option solvelink=5;

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

$INCLUDE Includes/PrimalEq.gms
$INCLUDE Includes/DualEq.gms


Model Food1y /
E1_2b.D1
E1_2cd.D2
E1_3a.Q_FOOD
E1_3b.AREA_CROP
E2_2b.D3
E2_2c.D4
E2_2d.PI_COW
E2_2e.D9
E2_2f.D10
E2_3a.Q_CATTLE
E2_3b.Q_CATTLE_BUY
E2_3c.Q_HIDE
E2_3d.Q_CATTLE_SL
E2_4a.Q_FOOD_ADMIN
E2_4b.PI_FOOD
E3_2b.D6
E3_2c.D7
E3_2d.D16
E3_3a.QF_DB
E3_3b.QF_ROAD
E3_3c.QF_DS
E4_2a.D8
E4_2b.D11
E4_3a.Q_WB
E4_3b.Q_WS
E4_3c.Q_W
E4_4a.Q_U
E4_4b.PI_U
E5_1a.PI_FOOD_ADMIN
E5_1b.PI_U_ADAPT
E5_1c.PI_W
E6_2a.D13
E6_2b.D14
E6_2c.D15
E6_3a.Q_ELEC
E6_3b.Q_ELEC_TRANS
E_ElecDem.Q_ELEC_DEM
/;
*q_Ws.lo(FoodItem, Node, Season, Year) = Consumption(FoodItem, Node, Season, Year);



option reslim=10000000;
Loop(Year2Loop$(ORD(Year2Loop)+card(Period)-1<=Card(Year2Loop)),

$INCLUDE Includes/RollingParam.gms
$INCLUDE Includes/RollRules/%FutureKnowledge%

        Solve Food1y using MCP;

$INCLUDE Includes/ContinueRoll.gms
$INCLUDE Includes/PostProcess.gms
);



%RunningOnCluster%$ontext
Display Prices;
option produce:2:2:2;
Display produce;
option Cows:2:2:2;
Display Cows;
option Elec:2:2:2;
Display Elec;
$ontext
$offtext


* Exporting results
execute_unload 'Results/%Scenario%';

