 $include "Set Declarations"
$include "Parameter Declarations"
$include "Table Declarations"
$include "Parameter Calculations"
$include "Variable Declarations"
$include "Equation Calculations"
$include "MCP Definition"


* Outstanding tasks
*        figure out enset, banana model
*        find calibration data



solve Ethiopia_MCP using MCP;

* export data to Matlab for postprocessing


