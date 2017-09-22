************************************************************************
***********************       CROP PRODUCER       **********************
************************************************************************


Equations
E1_2b(Node, Year)
E1_2cd(FoodItem, Node, Season, Year)
* Fallow Constraint
* E1_2e(Node, Year)
* Crop Rotation Constraint
* E1_2f(FoodItem, FoodItem2, Node, Year)
;

E1_2b(Node, Year).. TotArea(Node)
                    =g=
                    sum((Crop, Season),AREA_CROP(Crop, Node, Season, Year));

* Yield of livestock also defined
E1_2cd(FoodItem, Node, Season, Year).. -q_Food(FoodItem, Node, Season, Year)
            =g=
            -(aFAO(FoodItem, Node, Season, Year)*Cyf(FoodItem, Node, Season, Year)*(1+(rPower(pi_Food(FoodItem, Node, Season, Year),Elas(FoodItem, Node, Season, Year))-1)$(Elas(FoodItem, Node, Season, Year)))*AREA_CROP(FoodItem, Node, Season, Year))$Crop(FoodItem)
            -Yield(FoodItem, Node, Season, Year)*(
                            Q_CATTLE(FoodItem, Node, Season, Year)$(sameas(FoodItem,"milk"))+
                            Q_CATTLE_SL(Node, Season, Year)$(sameas(FoodItem,"beef"))
                            );

************************************************************************
********************       LIVESTOCK PRODUCER       ********************
************************************************************************
* Quantity, price of milk and Beef are defined as (q/pi)_Food. Similarly for yield.

Equations
    E2_2b(Node, Season, Year)
    E2_2c(Node, Season, Year)
    E2_2d(Node, Season, Year)
    E2_2e(Node, Season, Year)
    E2_2f(Node, Season, Year)
;


* Yield defined with Foodcrop

E2_2b(Node, Season, Year).. -Q_HIDE(Node, Season, Year)
                    =g=
                    -Yld_H(Node, Season, Year)*Q_CATTLE_SL(Node, Season, Year);
E2_2c(Node, Season, Year).. -Q_CATTLE_SL(Node, Season, Year) =g= -sum(FoodItem, Q_CATTLE(FoodItem, Node, Season, Year));


E2_2d(Node, Season, Year).. -sum(FoodItem, Q_CATTLE(FoodItem, Node, Season, Year))
    =g=
    -((1+k(Node, Season, Year)-kappa(Node, Season, Year))*(sum(FoodItem, Q_CATTLE(FoodItem, Node, Season-1, Year)$(ORD(Season)>1) + Q_CATTLE(FoodItem, Node, Season+(CARD(Season)-1), Year-1)$(ORD(Season)=1)) + InitCow(Node)$(ORD(Year)=1 AND ORD(Season)=1)) -
    Q_CATTLE_SL(Node, Season+(CARD(Season)-1), Year-1)$(ORD(Season)=1) - Q_CATTLE_SL(Node, Season-1, Year)$(ORD(Season)>1) +
    sum(NodeFrom, Q_CATTLE_BUY(NodeFrom, Node, Season, Year) - Q_CATTLE_BUY(Node, NodeFrom, Season, Year)));



E2_2e(Node, Season, Year).. Q_CATTLE_SL(Node, Season, Year) =g= CowDeath(Node, Season, Year)*sum(FoodItem, Q_CATTLE(FoodItem, Node, Season, Year));
E2_2f(Node, Season, Year).. sum(FoodItem, Q_CATTLE(FoodItem, Node, Season, Year)) =g= Herdsize(Node)-10;



************************************************************************
***********************       DISTRIBUTORS       ***********************
************************************************************************

Equations
    E3_2b(FoodItem, Node, Season, Year)
    E3_2c(FoodItem, NodeFrom, Node, Season, Year)
    E3_2d(NodeFrom, Node, Season, Year)
;

E3_2b(FoodItem, Node, Season, Year).. QF_DB(FoodItem, Node, Season, Year) + sum(NodeFrom$Road(NodeFrom, Node), QF_ROAD(FoodItem, NodeFrom, Node, Season, Year))
                                =e=
                                QF_DS(FoodItem, Node, Season, Year) + sum(NodeFrom$Road(Node, NodeFrom),QF_ROAD(FoodItem, Node, NodeFrom, Season, Year));
E3_2c(FoodItem, NodeFrom, Node, Season, Year)$((FoodDistrCap AND Road(NodeFrom, Node))).. -QF_ROAD(FoodItem, NodeFrom, Node, Season, Year)
                                        =g=
                                        -Cap_Road(FoodItem, NodeFrom, Node);

E3_2d(NodeFrom, Node, Season, Year)$Road(NodeFrom, Node).. -sum(FoodItem,QF_ROAD(FoodItem, NodeFrom, Node, Season, Year))
                                        =g=
                                        -Cap_Road_Tot(NodeFrom, Node);



************************************************************************
***********************       STORE/RETAIL       ***********************
************************************************************************
Equations
    E4_2a(FoodItem, Node, Season, Year)
    E4_2b(FoodItem, Node, Season, Year)
;

E4_2a(FoodItem, Node, Season, Year).. -Q_W(FoodItem, Node, Season, Year) =g= -CAP_Store(FoodItem, Node, Season, Year);
E4_2b(FoodItem, Node, Season, Year).. Q_W(FoodItem, Node, Season-1, Year)$(Ord(Season)>1) +
        (Q_WInit(FoodItem, Node)$(ORD(Year)=1) +Q_W(FoodItem, Node, Season + (Card(Season)-1), Year-1))$(Ord(Season)=1) + Q_WB(FoodItem, Node, Season, Year)
        -Q_WS(FoodItem, Node, Season, Year) =e= Q_W(FoodItem, Node, Season, Year);


************************************************************************
***********************       CONSUMERS       **********************
************************************************************************
Equations
    E5_1a(FoodItem, Node, Season, Year)
    E5_1b(FoodItem, Node, Season, Year)
    E5_1c(FoodItem, Node, Season, Year)
;

E5_1a(FoodItem, Node, Season, Year).. q_Food(FoodItem, Node, Season, Year) =e= QF_DB(FoodItem, Node, Season, Year);
E5_1b(FoodItem, Node, Season, Year).. pi_U(FoodItem, Node, Season, Year) =e= DemInt(FoodItem, Node, Season, Year)*10
                                - DemSlope(FoodItem, Node, Season, Year)*Q_WS(FoodItem, Node, Season, Year)
                                + sum(FoodItem2, DemCrossTerms(FoodItem, FoodItem2, Node, Season, Year)*DemCrossTerms(FoodItem, FoodItem2, Node, Season, Year)*DemSlope(FoodItem, Node, Season, Year)*(pi_U(FoodItem2, Node, Season, Year) - pi_U(FoodItem, Node, Season, Year)))$(CrossElasOn);
E5_1c(FoodItem, Node, Season, Year).. Q_WB(FoodItem, Node, Season, Year) =e= QF_DS(FoodItem, Node, Season, Year);


************************************************************************
************************       ELECTRICITY       ***********************
************************************************************************
Equations
    E6_2a(Node, Season, Year)
    E6_2b(Node, Season, Year)
    E6_2c(NodeFrom, Node, Season, Year)
    E_ElecDem(Node, Season, Year)
;


E6_2a(Node, Season, Year).. Cap_Elec(Node, Season, Year) =g= Q_ELEC(Node, Season, Year);
E6_2b(Node, Season, Year).. Q_ELEC(Node, Season, Year) + sum(NodeFrom$Eline(NodeFrom, Node), Q_ELEC_TRANS(NodeFrom, Node, Season, Year))
                                 =g=
                Q_ELEC_DEM(Node, Season, Year)+sum(NodeFrom$Eline(Node, NodeFrom), Q_ELEC_TRANS(Node, NodeFrom, Season, Year));
E6_2c(NodeFrom, Node, Season, Year)$Eline(NodeFrom, Node).. Cap_Elec_Trans(NodeFrom, Node, Season, Year)
                                =g=
                Q_ELEC_TRANS(NodeFrom, Node, Season, Year);
E_ElecDem(Node, Season, Year).. Q_ELEC_DEM(Node, Season, Year) =e= Base_Elec_Dem(Node, Season, Year)/2;
