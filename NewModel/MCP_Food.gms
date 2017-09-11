$TITLE "INFEWS FOOD MODEL"

************************************************************************
************************       SETTINGS       **************************
************************************************************************

$SETGLOBAL Detailed_Listing ""
$SETGLOBAL RunningOnCluster "*"

$SETGLOBAL Scenario "Base"

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
E1_2b.d1
E1_2cd.d2
E1_3a.q_Food
E1_3b.Area_Crop
E2_2b.d3
E2_2c.d4
E2_2d.pi_cow
E2_2e.d9
E2_2f.d10
E2_3a.Q_cattle
E2_3b.Q_cattle_buy
E2_3c.q_Hide
E2_3d.Q_cattle_sl
E3_2b.d6
E3_2c.d7
E3_2d.d16
E3_3a.qF_Db
E3_3b.qF_Road
E3_3c.qF_Ds
E4_2a.d8
E4_2b.d11
E4_3a.q_Wb
E4_3b.q_Ws
E4_3c.q_W
E5_1a.pi_Food
E5_1b.pi_U
E5_1c.pi_W
E6_2a.d13
E6_2b.d14
E6_2c.d15
E6_3a.q_Elec
E6_3b.q_Elec_Trans
E_ElecDem.q_Elec_Dem
/;
*q_Ws.lo(FoodItem, Node, Season, Year) = Consumption(FoodItem, Node, Season, Year);

%UseInitialPoint%$ontext
execute_loadpoint '%Point%';
$ontext
$offtext

option reslim=10000000;
Solve Food1y using MCP;

$INCLUDE Includes/PostProcess.gms

* Exporting results
execute_unload 'Results/%Scenario%';

