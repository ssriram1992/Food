************************************************************************
***********************       CROP PRODUCER       **********************
************************************************************************

Equations
E1_2b(Adapt, Period)
E1_2cd(FoodItem, Adapt, Season, Period)
* Fallow Constraint
* E1_2e(Node, Period)
* Crop Rotation Constraint
* E1_2f(FoodItem, FoodItem2, Node, Period)
;

E1_2b(Adapt, Period).. TotArea(Adapt)
                    =g=
                    sum((Crop, Season),AREA_CROP(Crop, Adapt, Season, Period));

* Yield of livestock also defined
E1_2cd(FoodItem, Adapt, Season, Period).. -Q_FOOD(FoodItem, Adapt, Season, Period)
            =g=
            -(aFAO_roll(FoodItem, Adapt, Season, Period)*Cyf_roll(FoodItem, Adapt, Season, Period)*(1+(rPower(PI_FOOD(FoodItem, Adapt, Season, Period),Elas_roll(FoodItem, Adapt, Season, Period))-1)$(Elas_roll(FoodItem, Adapt, Season, Period)))*AREA_CROP(FoodItem, Adapt, Season, Period))$Crop(FoodItem)
            -Yield_roll(FoodItem, Adapt, Season, Period)*(
                            Q_CATTLE(FoodItem, Adapt, Season, Period)$(sameas(FoodItem,"milk"))+
                            Q_CATTLE_SL(Adapt, Season, Period)$(sameas(FoodItem,"beef"))
                            );

************************************************************************
********************       LIVESTOCK PRODUCER       ********************
************************************************************************
* Quantity, price of milk and Beef are defined as (q/pi)_Food. Similarly for yield.

Equations
    E2_2b(Adapt, Season, Period)
    E2_2c(Adapt, Season, Period)
    E2_2d(Adapt, Season, Period)
    E2_2e(Adapt, Season, Period)
    E2_2f(Adapt, Season, Period)
;


* Yield defined with Foodcrop

E2_2b(Adapt, Season, Period).. -Q_HIDE(Adapt, Season, Period)
                    =g=
                    -Yld_H_roll(Adapt, Season, Period)*Q_CATTLE_SL(Adapt, Season, Period);
E2_2c(Adapt, Season, Period).. -Q_CATTLE_SL(Adapt, Season, Period) =g= -sum(FoodItem, Q_CATTLE(FoodItem, Adapt, Season, Period));


E2_2d(Adapt, Season, Period).. ((1+k_roll(Adapt, Season, Period)-kappa_roll(Adapt, Season, Period))*(sum(FoodItem, Q_CATTLE(FoodItem, Adapt, Season-1, Period)$(ORD(Season)>1) + 
        Q_CATTLE(FoodItem, Adapt, Season+(CARD(Season)-1), Period-1)$(ORD(Season)=1)) + InitCow(Adapt)$(ORD(Period)=1 AND ORD(Season)=1)) -
    Q_CATTLE_SL(Adapt, Season+(CARD(Season)-1), Period-1)$(ORD(Season)=1) - Q_CATTLE_SL(Adapt, Season-1, Period)$(ORD(Season)>1) +
    sum(AdaptFrom, Q_CATTLE_BUY(AdaptFrom, Adapt, Season, Period) - Q_CATTLE_BUY(Adapt, AdaptFrom, Season, Period)))
    =g=
    sum(FoodItem, Q_CATTLE(FoodItem, Adapt, Season, Period));



E2_2e(Adapt, Season, Period).. Q_CATTLE_SL(Adapt, Season, Period) =g= CowDeath_roll(Adapt, Season, Period)*sum(FoodItem, Q_CATTLE(FoodItem, Adapt, Season, Period));
E2_2f(Adapt, Season, Period).. sum(FoodItem, Q_CATTLE(FoodItem, Adapt, Season, Period)) =g= Herdsize(Adapt);


************************************************************************
************************       Adapt2Node       ************************
************************************************************************
Equations
E2_4a(FoodItem, Node, Season, Period)
E2_4b(FoodItem, Adapt, Season, Period)
;

 E2_4a(FoodItem, Node, Season, Period).. Q_FOOD_ADMIN(FoodItem, Node, Season, Period) =e=  sum(Adapt, Adapt2Node(Adapt, Node)*Q_FOOD(FoodItem, Adapt, Season, Period));
 
 E2_4b(FoodItem, Adapt, Season, Period).. Q_FOOD(FoodItem, Adapt, Season, Period)*PI_FOOD(FoodItem, ADAPT, Season, Period) =e= sum(Node, Adapt2Node(Adapt, Node)*
                                                            PI_FOOD_ADMIN(FoodItem, Node, Season, Period)*Q_FOOD_ADMIN(FoodItem, Node, Season, Period)
                                                                );


************************************************************************
***********************       DISTRIBUTORS       ***********************
************************************************************************

Equations
    E3_2b(FoodItem, Node, Season, Period)
    E3_2c(FoodItem, NodeFrom, Node, Season, Period)
    E3_2d(NodeFrom, Node, Season, Period)
;

E3_2b(FoodItem, Node, Season, Period).. QF_DB(FoodItem, Node, Season, Period) + sum(NodeFrom$Road(NodeFrom, Node), QF_ROAD(FoodItem, NodeFrom, Node, Season, Period))
                                =e=
                                QF_DS(FoodItem, Node, Season, Period) + sum(NodeFrom$Road(Node, NodeFrom),QF_ROAD(FoodItem, Node, NodeFrom, Season, Period));
E3_2c(FoodItem, NodeFrom, Node, Season, Period)$((FoodDistrCap AND Road(NodeFrom, Node))).. -QF_ROAD(FoodItem, NodeFrom, Node, Season, Period)
                                        =g=
                                        -Cap_Road(FoodItem, NodeFrom, Node);

E3_2d(NodeFrom, Node, Season, Period)$Road(NodeFrom, Node).. -sum(FoodItem,QF_ROAD(FoodItem, NodeFrom, Node, Season, Period))
                                        =g=
                                        -Cap_Road_Tot(NodeFrom, Node);



************************************************************************
***********************       STORE/RETAIL       ***********************
************************************************************************
Equations
    E4_2a(FoodItem, Node, Season, Period)
    E4_2b(FoodItem, Node, Season, Period)
;

E4_2a(FoodItem, Node, Season, Period).. -Q_W(FoodItem, Node, Season, Period) =g= -CAP_Store_roll(FoodItem, Node, Season, Period);
E4_2b(FoodItem, Node, Season, Period).. Q_W(FoodItem, Node, Season-1, Period)$(Ord(Season)>1) +
        (Q_WInit(FoodItem, Node)$(ORD(Period)=1) +Q_W(FoodItem, Node, Season + (Card(Season)-1), Period-1))$(Ord(Season)=1) + Q_WB(FoodItem, Node, Season, Period)
        -Q_WS(FoodItem, Node, Season, Period) =e= Q_W(FoodItem, Node, Season, Period);


************************************************************************
************************       Node2Adapt       ************************
************************************************************************
Equations
    E4_4a(FoodItem, Adapt, Season, Period)
    E4_4b(FoodItem, Node, Season, Period)
;

E4_4a(FoodItem, Adapt, Season, Period).. -Q_U(FoodItem, Adapt, Season, Period) =g= -sum(Node, Node2Adapt(Node, Adapt)*Q_WS(FoodItem, Node, Season, Period));
E4_4b(FoodItem, Node, Season, Period).. -sum(Adapt, Adapt2Node(Adapt, Node)*
                    PI_U_ADAPT(FoodItem, Adapt, Season, Period)*Q_U(FoodItem, Adapt, Season, Period)) =g= 
                    -PI_U(FoodItem, Node, Season, Period)*Q_WS(FoodItem, Node, Season, Period);

$ontext
E4_4b(FoodItem, Node, Season, Period).. sum(Adapt, Adapt2Node(Adapt, Node)*
                    PI_U_ADAPT(FoodItem, Adapt, Season, Period)*Q_U(FoodItem, Adapt, Season, Period)) =g= 
                    PI_U(FoodItem, Node, Season, Period)*Q_WS(FoodItem, Node, Season, Period);
$offtext                    


************************************************************************
***********************       CONSUMERS       **********************
************************************************************************
Equations
    E5_1a(FoodItem, Node, Season, Period)
    E5_1b(FoodItem, Adapt, Season, Period)
    E5_1c(FoodItem, Node, Season, Period)
;

E5_1a(FoodItem, Node, Season, Period).. Q_FOOD_ADMIN(FoodItem, Node, Season, Period) =e= QF_DB(FoodItem, Node, Season, Period);
E5_1b(FoodItem, Adapt, Season, Period).. PI_U_ADAPT(FoodItem, Adapt, Season, Period) =e= DemInt_roll(FoodItem, Adapt, Season, Period)
                                - DemSlope_roll(FoodItem, Adapt, Season, Period)*Q_U(FoodItem, Adapt, Season, Period)
                                + sum(FoodItem2, DemCrossTerms_roll(FoodItem, FoodItem2, Adapt, Season, Period)*DemCrossTerms_roll(FoodItem, FoodItem2, Adapt, Season, Period)*DemSlope_roll(FoodItem, Adapt, Season, Period)*(PI_U_ADAPT(FoodItem2, Adapt, Season, Period) - PI_U_ADAPT(FoodItem, Adapt, Season, Period)))$(CrossElasOn);
E5_1c(FoodItem, Node, Season, Period).. Q_WB(FoodItem, Node, Season, Period) =e= QF_DS(FoodItem, Node, Season, Period);


************************************************************************
************************       ELECTRICITY       ***********************
************************************************************************
Equations
    E6_2a(Node, Season, Period)
    E6_2b(Node, Season, Period)
    E6_2c(NodeFrom, Node, Season, Period)
    E_ElecDem(Node, Season, Period)
;


E6_2a(Node, Season, Period).. Cap_Elec_roll(Node, Season, Period) =g= Q_ELEC(Node, Season, Period);
E6_2b(Node, Season, Period).. Q_ELEC(Node, Season, Period) + sum(NodeFrom$Eline(NodeFrom, Node), Q_ELEC_TRANS(NodeFrom, Node, Season, Period))
                                 =g=
                Q_ELEC_DEM(Node, Season, Period)+sum(NodeFrom$Eline(Node, NodeFrom), Q_ELEC_TRANS(Node, NodeFrom, Season, Period));
E6_2c(NodeFrom, Node, Season, Period)$Eline(NodeFrom, Node).. Cap_Elec_Trans_roll(NodeFrom, Node, Season, Period)
                                =g=
                Q_ELEC_TRANS(NodeFrom, Node, Season, Period);
E_ElecDem(Node, Season, Period).. Q_ELEC_DEM(Node, Season, Period) =g= Base_Elec_Dem_roll(Node, Season, Period)/2;
