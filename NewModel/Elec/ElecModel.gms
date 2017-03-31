$ontext
*******************************************************************************
Author: Sriram Sankaranarayanan
File: ElecModel.gms
Institution: Johns Hopkins University
Contact: ssankar5@jhu.edu

All rights reserved.
You are free to distribute this code for non-profit purposes
as long as this header is kept intact
*******************************************************************************
$offtext

Option solvelink=5;

Set
Nodes /Node1*Node11/
Lines(Nodes, Nodes)/#Nodes.#Nodes/
ProdUnits /P1*P5/
ProdNodes(ProdUnits,Nodes)/
P1.Node1
P2.Node5
P3.Node7
P4.Node9
P5.Node11
/
;

Alias(Nodes,NNodes)

Parameter
Distance(Nodes,Nodes)
Resistance(Nodes,Nodes)
CostLin(ProdUnits)
CostQuad(ProdUnits)
Demand(Nodes)
LoLimProd(ProdUnits)
UpLimProd(ProdUnits)
FlowLim /60/
;


LoLimProd(ProdUnits) = 170;
UpLimProd(ProdUnits) = 270;


Positive Variables
Production(ProdUnits)
Flow(Nodes,Nodes)
;

Variable Obj;

* Some weird distance
Distance(Nodes,NNodes)$Lines(Nodes,NNodes) = abs(ord(nodes)-ord(nnodes)) - 
                                                max(0,-0.9+abs(+ord(nodes)-ord(nnodes))*0.3);

Demand(Nodes) = (1+sin((Ord(Nodes)-1)/(Card(Nodes)-1)*2*3.14159))*100;
CostLin(ProdUnits) = (1+sin((Ord(ProdUnits)-1)/(Card(ProdUnits)-1)*15*3));
CostQuad(ProdUnits) = (1+sin((Ord(ProdUnits)-1)/(Card(ProdUnits)-1)*17*3));
CostQuad('P3') = 5;
Display CostLin, CostQuad;
Scalar LF /0.01/;

Equation
FlowBalance(Nodes)
CostEq
LoLimProdEq(ProdUnits)
UpLimProdEq(ProdUnits)
FlowLimEq(Nodes,NNodes)
;

FlowBalance(Nodes).. sum(ProdUnits$ProdNodes(ProdUnits,Nodes),Production(ProdUnits))
                -sum(NNodes,Flow(Nodes,NNodes)$Lines(Nodes, NNodes)-Flow(NNodes,Nodes)$Lines(NNodes,Nodes))
                -sum(NNodes,Flow(NNodes,Nodes)$Lines(NNodes,Nodes)*LF*Distance(NNodes,Nodes))
                -Demand(Nodes) =e= 0;

CostEq.. obj =e= sum(ProdUnits,(CostLin(ProdUnits)+CostQuad(ProdUnits)*Production(ProdUnits))*Production(ProdUnits));
LoLimProdEq(ProdUnits).. LoLimProd(ProdUnits)=l= Production(ProdUnits);
UpLimProdEq(ProdUnits).. UpLimProd(ProdUnits)=g= Production(ProdUnits);
FlowLimEq(Nodes,NNodes)$Lines(Nodes,NNodes).. Flow(Nodes,NNodes) =l= FlowLim;

Model M /all/;

Solve M min obj use QCP;

Display Demand;
Display Flow.L, Production.L;