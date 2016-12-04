$offlisting
option dispwidth=60;
option savepoint=2;
************************************************************************
***********************       COMMON INIT       ************************
************************************************************************

Sets
    Year "Years" /2016*2020/
	YearAct(Year) "Active Years" /2016*2020/
    Month "Months" /1*12/
    Node "Nodes" /N1*N3/
	NodeAct(Node) "Nodes" /N1*N3/
    Livestock "Livestock growers" /L1*L10/
    Season "seasons" /belg,kremt/
    FoodItem "FoodItem" /wheat, potato, lentils, milk, beef/
    Crop(FoodItem) "Crops" /wheat, potato, lentils/
    NonCrop(FoodItem) "Animal products" /milk, beef/
    Road(Node, Node) "Transport connectivity"
	RoadAct(NodeAct,NodeAct) "Roads"
	Adv "Advisory years" /1*3/
;
alias(Node, NodeFrom);
alias(FoodItem, FoodItem2);
* Connecting roads in one direction only.
* Negative flow implies flow in other direction
Road(NodeFrom, Node)$(Ord(NodeFrom)<Ord(Node))=yes;

Parameter
    df(Year) "Discount factor"
;

Equations
E5_1a
E5_1b
E5_1c
;

************************************************************************
***********************       CROP PRODUCER       **********************
************************************************************************
*For farmers
alias(Node, Farmer);

Positive Variables    
    q_Food(FoodItem, Node, Year) "quantity of Food produced"
    Area_Crop(FoodItem, Node, Year) "area allotted for each Crop"
*    Area_conv(Node, Year) "area converted to become arable"
;

* Duals
Positive Variables
d1(Node, Year)
d2(FoodItem, Node, Year)
;

Variable pi_Food(FoodItem, Node, Year) "Price of Food item";

Parameters
    C_prod(Crop, Node, Year) "Cost of producing a Crop per unit area"
    C_convert(Node, Year) "Cost of converting land to make it arable"
    C_chg(Node, Year) "Penalty to change cropping pattern"
    Yield(FoodItem, Node, Year) "Yield"
    TotArea "Total Area available in the node"
;

Equations
E1_2b(Node, Year)
E1_2c(FoodItem, Node, Year)
E1_3a(FoodItem, Node, Year)
E1_3b(Crop, Node, Year)
;

E1_2b(Node, Year).. TotArea 
                    =g= 
                    sum(Crop,q_Food(Crop, Node, Year));

E1_3a(FoodItem, Node, Year).. d2(FoodItem, Node, Year) - df(Year)*pi_Food(FoodItem, Node, Year)
                            =g=
                            0;
E1_3b(Crop, Node, Year).. d1(Node, Year) -d2(Crop, Node, Year) + df(Year)*(
                                C_prod(Crop, Node, Year) +
                                C_convert(Node, Year) - C_convert(Node, Year+1) +
                                C_chg(Node, Year)*(Area_Crop(Crop, Node, Year) - Area_Crop(Crop, Node, Year-1))-
                                C_chg(Node, Year+1)*(Area_Crop(Crop, Node, Year+1) - Area_Crop(Crop, Node, Year))
                            )
                            =g=
                            0;


************************************************************************
********************       LIVESTOCK PRODUCER       ********************
************************************************************************
* Quantity, price of milk and Beef are defined as (q/pi)_Food. Similarly for yield.
Positive Variables
    q_Hide(Node, Year) "Quantity of Hide produced"
    Q_cattle(Node, Year) "Number of cattle in the herd"
    Q_cattle_sl(Node, Year) "Number of cattle slaughtered"
    Q_cattle_buy(Node, NodeFrom, Year) "Number of cattle bought from a certain node"
;
* DUal Variables
Positive Variables
    d3(Node, Year)
    d4(Node, Year)
    pi_cow "price of a cow"
;


Parameters
    pr_Hide "Price of Hide"
    Yld_H(Node, Year) "Hide yield per unit slaughtered cattle"
    k "Cattle birth rate"
    kappa "cattle death rate"
    C_cow(Node, Year) "Cost of rearing cattle"
    C_cow_tr(Node, NodeFrom, Year) "Cost of transporting cattle"
;

Equations
E2_2b(Node, Year)
E2_2c(Node, Year)
E2_2d(Node, Year)
E2_3a(Node, Year)
E2_3b(NodeFrom, Node, Year)
E2_3c(Node, Year)
E2_3d(Node, Year)
;

E1_2c(FoodItem, Node, Year).. q_Food(FoodItem, Node, Year) 
                            =l= 
                          Yield(FoodItem, Node, Year)*(
                            Area_Crop(FoodItem, Node, Year)$(Crop(FoodItem))+
                            Q_cattle(Node, Year)$(sameas(FoodItem,"milk"))+
                            Q_cattle_sl(Node, Year)$(sameas(FoodItem,"beef"))
                            );

E2_2b(Node, Year).. q_Hide(Node, Year)
                    =l=
                    Yld_H(Node, Year)*Q_cattle_sl(Node, Year);
E2_2c(Node, Year).. Q_cattle_sl(Node, Year) =l= Q_cattle(Node, Year);
E2_2d(Node, Year).. Q_cattle(Node, Year+1) 
                    =l= 
                    (1+k-kappa)*Q_cattle(Node, Year) -
                    Q_cattle_sl(Node, Year) +
                    sum(NodeFrom, Q_cattle_buy(NodeFrom, Node, Year) - Q_cattle_buy(Node, NodeFrom, Year));
E2_3a(Node, Year).. df(Year)*C_cow(Node, Year) - d2("Milk", Node, Year)*Yield("Milk", Node, Year) - 
                    d4(Node, Year)+ pi_cow(Node, Year-1) - (1+k-kappa)*pi_cow(Node, Year)
                    =g=
                    0;
E2_3b(NodeFrom, Node, Year)$(NOT(sameas(Node, NodeFrom)))..   df(Year)*( C_cow_tr(NodeFrom, Node, Year)+pi_cow(NodeFrom, Year))+
                                ( pi_cow(NodeFrom, Year)-pi_cow(Node, Year))
                                =g=
                                0;
E2_3c(Node, Year).. d3(Node, Year)-df(Year)*pr_Hide(Node, Year) =g= 0;
E2_3d(Node, Year).. d4(Node, Year) - d2("beef", Node, Year)*Yield("beef", Node, Year)-
                        d3(Node, Year)*Yld_H(Node, Year) + pi_cow(Node,Year)
                        =g=
                        0;


************************************************************************
***********************       DISTRIBUTORS       ***********************
************************************************************************
Positive Variables
    qF_Ds(FoodItem, Node, Year) "Quantity of Food sold by distributor"
    qF_Db(FoodItem, Node, Year) "Quantity of Food bought by distributor"
    qF_Road(FoodItem, Node, NodeFrom, Year) "Quantity of Food transported"    
;
* Dual variables
Positive Variables
d6(FoodItem, Node, Year)
d7(FoodItem, NodeFrom, Node, Year)
;

Parameters
    CF_Road(FoodItem, Node, NodeFrom, Year) "Cost of transporting food item"  
    Cap_Road(FoodItem, NodeFrom, Node, Year)  "Transportation capacity"
;

Equations
E3_2b(FoodItem, Node, Year)
E3_2c(FoodItem, NodeFrom, Node, Year)
E3_3a(FoodItem, Node, Year)
E3_3b(FoodItem, NodeFrom, Node, Year)
E3_3c(FoodItem, Node, Year)
;

E3_2b(FoodItem, Node, Year).. QF_Db(FoodItem, Node, Year) + sum(NodeFrom, qF_Road(FoodItem, NodeFrom, Node, Year))
                                =g=
                                QF_Ds(FoodItem, Node, Year) + sum(NodeFrom,qF_Road(FoodItem, Node, NodeFrom, Year));
E3_2c(FoodItem, NodeFrom, Node, Year).. qF_Road(FoodItem, NodeFrom, Node, Year)
                                        =l=
                                        Cap_Road(FoodItem, NodeFrom, Node, Year);
E3_3a(FoodItem, Node, Year).. df(Year)*pi_Food(FoodItem, Node, Year)
                                =g=
                                d6(FoodItem, Node, Year);
E3_3b(FoodItem, NodeFrom, Node, Year).. d7(FoodItem, NodeFrom, Node, Year) + df(Year)*CF_Road(FoodItem, NodeFrom, Node, Year)
                                        =g=
                                        d6(FoodItem, Node, Year) - d6(FoodItem, NodeFrom, Year) ;
E3_3c(FoodItem, Node, Year).. d6(FoodItem, Node, Year)
                                =g=
                                df(Year)*pi_Food(FoodItem, Node, Year);                                        


************************************************************************
***********************       STORE/RETAIL       ***********************
************************************************************************
Positive Variables
    q_S(FoodItem, Node, Year) "Total quantity stored and sold"    
;

Variable pi_U(FoodItem, Node, Year);

* Dual
Positive Variable d8(FoodItem, Node, Year);

Parameters
    CS_L(FoodItem, Node, Year) "Cost of food storage Linear term"
    CS_Q(FoodItem, Node, Year) "Cost of food storage Quadratic term"
    CAP_Store(FoodItem, Node, Year) "Storage Capacity"
;

Equations
    E4_2a(FoodItem, Node, Year)
    E4_3a(FoodItem, Node, Year)
;
E4_2a(FoodItem, Node, Year).. q_S(FoodItem, Node, Year) =l= CAP_Store(FoodItem, Node, Year);
E4_3a(FoodItem, Node, Year).. pi_Food(FoodItem, Node, Year) - pi_U(FoodItem, Node, Year)
                            +CS_Q(FoodItem, Node, Year)*q_S(FoodItem, Node, Year)
                            +CS_L(FoodItem, Node, Year) + d8(FoodItem, Node, Year) =g= 0;


************************************************************************
***********************       CONSUMERS       **********************
************************************************************************
Parameters
    DemSlope(FoodItem, Node, Year) "Slope of Demand curve"
    DemInt(FoodItem, Node, Year) "Intercept of demand curve"
    DemCrossTerms(FoodItem, FoodItem2, Node, Year) "Cross terms in demand curve"
;
Equations
E5_1a(FoodItem, Node, Year)
E5_1b(FoodItem, Node, Year)
;

E5_1a(FoodItem, Node, Year).. q_Food(FoodItem, Node, Year) =e= qF_Db(FoodItem, Node, Year); 
E5_1b(FoodItem, Node, Year).. pi_U(FoodItem, Node, Year) =e= DemInt(FoodItem, Node, Year) 
                                - DemSlope(FoodItem, Node, Year)*q_S(FoodItem, Node, Year) 
                                + sum(FoodItem2, pi_U(FoodItem, Node, Year));

DemSlope(FoodItem, Node, Year) = Ord(FoodItem)+Ord(Node)*3+Ord(Year)/7;

************************************************************************
**********************       POST-PROCESSING       *********************
************************************************************************

Model FoodModel /
E1_2b.d1
E1_2c.d2
E1_3a.q_Food
E1_3b.Area_Crop
E2_2b.d3
E2_2c.d4
E2_2d.pi_cow
E2_3a.Q_cattle
E2_3b.Q_cattle_buy
E2_3c.q_Hide
E2_3d.Q_cattle_sl
E3_2b.d6
E3_2c.d7
E3_3a.qF_Db
E3_3b.qF_Road
E3_3c.qF_Ds
E4_2a.d8
E4_3a.q_S
E5_1a.pi_Food
E5_1b.pi_U
/;

Solve FoodModel using MCP;

execute_unload 'Food'
