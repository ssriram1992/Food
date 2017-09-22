************************************************************************
***********************       CROP PRODUCER       **********************
************************************************************************


Equations
E1_2b(Node, Period)
E1_2cd(FoodItem, Node, Season, Period)
* Fallow Constraint
* E1_2e(Node, Period)
* Crop Rotation Constraint
* E1_2f(FoodItem, FoodItem2, Node, Period)
;

E1_2b(Node, Period).. TotArea(Node)
                    =g=
                    sum((Crop, Season),AREA_CROP(Crop, Node, Season, Period));

* Yield of livestock also defined
E1_2cd(FoodItem, Node, Season, Period).. -Q_FOOD(FoodItem, Node, Season, Period)
            =g=
            -(aFAO_roll(FoodItem, Node, Season, Period)*Cyf_roll(FoodItem, Node, Season, Period)*(1+(rPower(PI_FOOD(FoodItem, Node, Season, Period),Elas_roll(FoodItem, Node, Season, Period))-1)$(Elas_roll(FoodItem, Node, Season, Period)))*AREA_CROP(FoodItem, Node, Season, Period))$Crop(FoodItem)
            -Yield_roll(FoodItem, Node, Season, Period)*(
                            Q_CATTLE(FoodItem, Node, Season, Period)$(sameas(FoodItem,"milk"))+
                            Q_CATTLE_SL(Node, Season, Period)$(sameas(FoodItem,"beef"))
                            );

************************************************************************
********************       LIVESTOCK PRODUCER       ********************
************************************************************************
* Quantity, price of milk and Beef are defined as (q/pi)_Food. Similarly for yield.

Equations
    E2_2b(Node, Season, Period)
    E2_2c(Node, Season, Period)
    E2_2d(Node, Season, Period)
    E2_2e(Node, Season, Period)
    E2_2f(Node, Season, Period)
;


* Yield defined with Foodcrop

E2_2b(Node, Season, Period).. -Q_HIDE(Node, Season, Period)
                    =g=
                    -Yld_H_roll(Node, Season, Period)*Q_CATTLE_SL(Node, Season, Period);
E2_2c(Node, Season, Period).. -Q_CATTLE_SL(Node, Season, Period) =g= -sum(FoodItem, Q_CATTLE(FoodItem, Node, Season, Period));


E2_2d(Node, Season, Period).. -sum(FoodItem, Q_CATTLE(FoodItem, Node, Season, Period))
    =g=
    -((1+k_roll(Node, Season, Period)-kappa_roll(Node, Season, Period))*(sum(FoodItem, Q_CATTLE(FoodItem, Node, Season-1, Period)$(ORD(Season)>1) + Q_CATTLE(FoodItem, Node, Season+(CARD(Season)-1), Period-1)$(ORD(Season)=1)) + InitCow(Node)$(ORD(Period)=1 AND ORD(Season)=1)) -
    Q_CATTLE_SL(Node, Season+(CARD(Season)-1), Period-1)$(ORD(Season)=1) - Q_CATTLE_SL(Node, Season-1, Period)$(ORD(Season)>1) +
    sum(NodeFrom, Q_CATTLE_BUY(NodeFrom, Node, Season, Period) - Q_CATTLE_BUY(Node, NodeFrom, Season, Period)));



E2_2e(Node, Season, Period).. Q_CATTLE_SL(Node, Season, Period) =g= CowDeath_roll(Node, Season, Period)*sum(FoodItem, Q_CATTLE(FoodItem, Node, Season, Period));
E2_2f(Node, Season, Period).. sum(FoodItem, Q_CATTLE(FoodItem, Node, Season, Period)) =g= Herdsize(Node)-10;



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
***********************       CONSUMERS       **********************
************************************************************************
Equations
    E5_1a(FoodItem, Node, Season, Period)
    E5_1b(FoodItem, Node, Season, Period)
    E5_1c(FoodItem, Node, Season, Period)
;

E5_1a(FoodItem, Node, Season, Period).. Q_FOOD(FoodItem, Node, Season, Period) =e= QF_DB(FoodItem, Node, Season, Period);
E5_1b(FoodItem, Node, Season, Period).. PI_U(FoodItem, Node, Season, Period) =e= DemInt_roll(FoodItem, Node, Season, Period)*10
                                - DemSlope_roll(FoodItem, Node, Season, Period)*Q_WS(FoodItem, Node, Season, Period)
                                + sum(FoodItem2, DemCrossTerms_roll(FoodItem, FoodItem2, Node, Season, Period)*DemCrossTerms_roll(FoodItem, FoodItem2, Node, Season, Period)*DemSlope_roll(FoodItem, Node, Season, Period)*(PI_U(FoodItem2, Node, Season, Period) - PI_U(FoodItem, Node, Season, Period)))$(CrossElasOn);
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
E_ElecDem(Node, Season, Period).. Q_ELEC_DEM(Node, Season, Period) =e= Base_Elec_Dem_roll(Node, Season, Period)/2;
