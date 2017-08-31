$TITLE "INFEWS FOOD MODEL with SOCIAL WELFARE"
$ontext
$offlisting
option dispwidth=60;
$inlinecom /* */
$offsymlist
$Offsymxref
$oninline
Option Solprint = off;
Option limrow = 0;
Option limcol = 0;
$offtext
*option savepoint=2;
option solvelink=5;


$SETGLOBAL Scenario "Base"
$SETGLOBAL DataFile "Data/DataGdx"

Sets
Year "Years" /2015*2017/
;

$INCLUDE Includes/ControlPanel.gms
$INCLUDE Includes/PrimalDecl.gms
$INCLUDE Includes/DataLoad.gms

$if exist Data/%Scenario% $include Data/%Scenario%.gms
$if exist Data/%Scenario% Display 'Data/%Scenario%.gms loaded' ;
$if not exist Data/%Scenario% Display 'Data/%Scenario%.gms does not exist. Running Base Scenario' ;

$INCLUDE Includes/PrimalEq.gms

************************************************************************
*************************       OBJECTIVES       ***********************
************************************************************************
Equations
ObjectiveEq
;

Variable
Objective
;



ObjectiveEq.. Objective =e= sum((Year, Season, Node),
*Crop production
    sum(FoodItem, C_prod(FoodItem, Node, Season, Year)*Area_Crop(FoodItem, Node, Season, Year)) +
*Livestock
    C_cow(Node, Season, Year)*sum(FoodItem, Q_cattle(FoodItem, Node, Season, Year))+
*Distribution
    sum((FoodItem, NodeFrom), CF_Road(FoodItem, NodeFrom, Node, Season, Year)*qF_Road(FoodItem, NodeFrom, Node, Season, Year))+
*Storage
    sum(FoodItem, CS_L(FoodItem, Node, Season, Year)*q_W(FoodItem, Node, Season, Year) + 0.5*CS_Q(FoodItem, Node, Season, Year)*q_W(FoodItem, Node, Season, Year)*q_W(FoodItem, Node, Season, Year))
);



************************************************************************
**********************       DATA-PROCESSING       *********************
************************************************************************

*CF_Road(FoodItem, Node, NodeFrom, Season, Year) = CF_Road_data(FoodItem, Node, NodeFrom);


Model SWFood / All /;


Solve SWFood use NLP min Objective;
execute_unload 'SW_%Scenario%';
