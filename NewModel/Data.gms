df(Year) = 1;

* Farmer
Table Yieldinit(FoodItem, Node)
            N1     N2     N3     N4     N5     N6     N7     N8     N9     N10
wheat       3      1      1      5      5      3      2      5      2      4              
potato      3      2      2      4      4      3      2      5      3      3             
lentils     3      3      3      3      3      3      2      5      4      2              
pepper      3      4      4      2      2      3      2      5      2      4              
milk        3      5      5      1      1      3      2      5      3      3              
Beef        10     10     5      10     5      5      8      12     7      8
;                  

Yield(FoodItem, Node, Year) = Yieldinit(FoodItem, Node) + 0.1*((abs(ord(Year)-3))**2);


*Yield(FoodItem, Node, Year) = MAX(0.5,3 -(ORD(FoodItem)*5 - 3*Ord(Node)**2 + ORD(Year))/20);
*Yield("beef",Node,Year) = 1.85 + 0.1*Ord(Node) - 0.4;
C_prod(Crop, Node, Year) = (Ord(Crop)+Ord(Node)*3+Ord(Year)/7)*0.25 + Ord(Year)*0.5;
*C_prod("pepper", Node, Year) = C_prod("potato", Node, Year)/1.2;
C_convert(Node, Year) = 0;
C_chg(Node, Year) = 0.1;
TotArea(Node) = Ord(Node)+30;
Area_init(Crop, Node) = 1;

* Livestock
pr_Hide(Node, Year) = 3*Ord(Year);
InitCow(Node) = 3;
Yld_H(Node, Year) = 3-0.1*Ord(Year);
k(Node, Year) = 0.1;
kappa(Node, Year) = 0.02;
C_cow(Node, Year) = 1.75 - ord(node)/15 +ord(year)/100;
CowDeath(Node, Year) = 0.07;
Herdsize(Node) = InitCow(Node)/3;

* Distribution

Table
Distance(NodeFrom, Node)
      N1     N2     N3     N4     N5     N6     N7     N8     N9     N10
N1    0      400    300    450    500    300    750    350    600    250
N2    400    0      350    650    900    700    750    800    300    600
N3    300    350    0      400    650    700    900    700    300    450
N4    450    650    400    0      400    750    1200   500    550    300
N5    500    900    650    400    0      750    1250   350    900    350
N6    300    700    700    750    750    0      600    450    850    500
N7    750    750    900    1200   1250   600    0      850    1000   900
N8    350    800    700    500    350    450    850    0      950    300
N9    600    300    300    550    900    850    1000   950    0      700
N10   250    600    450    300    350    500    900    300    700    0
;

Distance(NodeFrom, Node) = Distance(NodeFrom, Node)/100;

*Distance(NodeFrom, Node) = ABS(ord(Node) - ord(NodeFrom))*1;
C_cow_tr(NodeFrom, Node, Year) = Max(0.01,Distance(NodeFrom, Node)*(0.05) - ord(Year)/20);
CF_Road(FoodItem, Node, NodeFrom, Year) = Max(0.01,Distance(NodeFrom, Node)*(0.05) - 3/20)*10;
Cap_Road(FoodItem, Node, NodeFrom, Year) = 10000;



* Store
CS_L(FoodItem, Node, Year) = 100;
*1 - ord(Node)/10 + ord(Year)/10;
CS_Q(FoodItem, Node, Year) = 20;
CAP_Store(FoodItem, Node, Year) = 1000;

* Consumer
DemInt(FoodItem, Node, Year) = (Ord(FoodItem)+Ord(Node)*3+Ord(Year)/7);
DemSlope(FoodItem, Node, Year) = 1.5 + ORD(Year)/10- 0.3  - ORD(Node)/10 + ORD(FoodItem)/50;
DemSlope(FoodItem, Node, Year) = DemSlope(FoodItem, Node, Year)*500;
DemInt(FoodItem, Node, Year) = DemInt(FoodItem, Node, Year) + 5*DemSlope(FoodItem, Node, Year);
DemCrossTerms(FoodItem, FoodItem2, Node, Year) = 400;
DemCrossTerms(FoodItem, FoodItem2, Node, Year)$(sameas(FoodItem,FoodItem2))  = 0;



$ontext
Display DemSlope, DemInt,Yield, C_prod, TotArea, DemCrossTerms;

Display pr_Hide, Yld_H, C_cow, C_cow_tr;

Display Distance, CF_Road;

$offtext