option solvelink=5;
$include "Set_Declarations"
$include "Parameter_Declarations"
$include "Table_Declarations"
$include "Parameter_Calculations"
$include "Variable_Declarations"
$include "Equation_Calculations"
$include "MCP_Definition"


* Outstanding tasks
*        figure out enset, banana model
*        find calibration data



solve Ethiopia_MCP using MCP;

* export data to Matlab for postprocessing


