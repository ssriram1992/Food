************************************************************************
***********************       CROP PRODUCER       **********************
************************************************************************
Scalar PrimalM /100000/;

Equations
    E1_2b_M1(Adapt, Season, Period)
    E1_2b_M2(Adapt, Season, Period)
    E1_2cd_M1(FoodItem, Adapt, Season, Period)
    E1_2cd_M2(FoodItem, Adapt, Season, Period)
    E1_2e_M1(FoodItem, Adapt, Node, Season, Period)
* Fallow Constraint
* E1_2f(Adapt, Period)
* Crop Rotation Constraint
* E1_2g(FoodItem, FoodItem2, Adapt, Period)
;

Binary Variables
B1_2b(Adapt, Season, Period)
B1_2cd(FoodItem, Adapt, Season, Period)
B1_2e(FoodItem, Adapt, Node, Season, Period)
;


E1_2b_M1(Adapt, Season, Period).. TotArea(Adapt, Season)
                    =l= B1_2b(Adapt, Season, Period)*PrimalM +
                    sum(Crop,AREA_CROP(Crop, Adapt, Season, Period));
E1_2b_M2(Adapt, Season, Period)..D1(Adapt, Season, Period)
        =l= (1 - B1_2b(Adapt, Season, Period))*PrimalM ;

* Yield of livestock also defined
E1_2cd_M1(FoodItem, Adapt, Season, Period).. -Q_FOOD(FoodItem, Adapt, Season, Period)
            =l= B1_2cd(FoodItem, Adapt, Season, Period)*PrimalM
            -(aFAO_roll(FoodItem, Adapt, Season, Period)*Cyf_roll(FoodItem, Adapt, Season, Period)*AREA_CROP(FoodItem, Adapt, Season, Period))$Crop(FoodItem)
            -Yield_roll(FoodItem, Adapt, Season, Period)*(
                            Q_CATTLE(FoodItem, Adapt, Season, Period)$(sameas(FoodItem,"milk"))+
                            Q_CATTLE_SL(Adapt, Season, Period)$(sameas(FoodItem,"beef"))
                            );
E1_2cd_M2(FoodItem, Adapt, Season, Period)..D2(FoodItem, Adapt, Season, Period)
        =l= (1 - B1_2cd(FoodItem, Adapt, Season, Period))*PrimalM ;



* Written together for livestock also
E1_2e_M1(FoodItem, Adapt, Node, Season, Period).. Q_FOOD_TRANS(FoodItem, Adapt, Node, Season, Period)
                                                 =e= 
                                                Adapt2Node(Adapt, Node)*Q_FOOD(FoodItem, Adapt, Season, Period); 

************************************************************************
********************       LIVESTOCK PRODUCER       ********************
************************************************************************
* Quantity, price of milk and Beef are defined as (q/pi)_Food. Similarly for yield.

Equations
    E2_2b_M1(Adapt, Season, Period)
    E2_2b_M2(Adapt, Season, Period)
    E2_2c_M1(Adapt, Season, Period)
    E2_2c_M2(Adapt, Season, Period)
    E2_2d_M1(Adapt, Season, Period)
    E2_2d_M2(Adapt, Season, Period)
    E2_2e_M1(Adapt, Season, Period)
    E2_2e_M2(Adapt, Season, Period)
    E2_2f_M1(Adapt, Season, Period)
    E2_2f_M2(Adapt, Season, Period)
;
Binary Variables
    B2_2b(Adapt, Season, Period)
    B2_2c(Adapt, Season, Period)
    B2_2d(Adapt, Season, Period)
    B2_2e(Adapt, Season, Period)
    B2_2f(Adapt, Season, Period)
;


* Yield defined with Foodcrop

E2_2b_M1(Adapt, Season, Period).. -Q_HIDE(Adapt, Season, Period)
                    =l= B2_2b(Adapt, Season, Period)*PrimalM  
                    -Yld_H_roll(Adapt, Season, Period)*Q_CATTLE_SL(Adapt, Season, Period);
E2_2b_M2(Adapt, Season, Period)..D3(Adapt, Season, Period)
        =l= (1 - B2_2b(Adapt, Season, Period))*PrimalM ;


E2_2c_M1(Adapt, Season, Period).. -Q_CATTLE_SL(Adapt, Season, Period) =l= B2_2c(Adapt, Season, Period)*PrimalM  -sum(FoodItem, Q_CATTLE(FoodItem, Adapt, Season, Period));
E2_2c_M2(Adapt, Season, Period)..D4(Adapt, Season, Period)
        =l= (1 - B2_2c(Adapt, Season, Period))*PrimalM ;



E2_2d_M1(Adapt, Season, Period).. ((1+k_roll(Adapt, Season, Period)-kappa_roll(Adapt, Season, Period))*(sum(FoodItem, Q_CATTLE(FoodItem, Adapt, Season-1, Period)$(ORD(Season)>1) + 
        Q_CATTLE(FoodItem, Adapt, Season+(CARD(Season)-1), Period-1)$(ORD(Season)=1)) + InitCow(Adapt)$(ORD(Period)=1 AND ORD(Season)=1)) -
    Q_CATTLE_SL(Adapt, Season+(CARD(Season)-1), Period-1)$(ORD(Season)=1) - Q_CATTLE_SL(Adapt, Season-1, Period)$(ORD(Season)>1) +
    sum(AdaptFrom, Q_CATTLE_BUY(AdaptFrom, Adapt, Season, Period) - Q_CATTLE_BUY(Adapt, AdaptFrom, Season, Period)))
    =l= B2_2d(Adapt, Season, Period)*PrimalM +
    sum(FoodItem, Q_CATTLE(FoodItem, Adapt, Season, Period));
E2_2d_M2(Adapt, Season, Period)..PI_COW(Adapt, Season, Period)
        =l= (1 - B2_2d(Adapt, Season, Period))*PrimalM ;




E2_2e_M1(Adapt, Season, Period).. Q_CATTLE_SL(Adapt, Season, Period) =l= B2_2e(Adapt, Season, Period)*PrimalM + CowDeath_roll(Adapt, Season, Period)*sum(FoodItem, Q_CATTLE(FoodItem, Adapt, Season, Period));
E2_2e_M2(Adapt, Season, Period)..D9(Adapt, Season, Period)
        =l= (1 - B2_2e(Adapt, Season, Period))*PrimalM ;


E2_2f_M1(Adapt, Season, Period).. sum(FoodItem, Q_CATTLE(FoodItem, Adapt, Season, Period)) =l= B2_2f(Adapt, Season, Period)*PrimalM + Herdsize(Adapt);
E2_2f_M2(Adapt, Season, Period)..D10(Adapt, Season, Period)
        =l= (1 - B2_2f(Adapt, Season, Period))*PrimalM ;




************************************************************************
************************       Adapt2Node       ************************
************************************************************************
Equations
    E2_4a_M1(FoodItem, Node, Season, Period)
;

Binary Variables
    B2_4a(FoodItem, Node, Season, Period)
;



E2_4a_M1(FoodItem, Node, Season, Period).. QF_DB(FoodItem, Node, Season, Period) =e=  sum(Adapt, Q_FOOD_TRANS(FoodItem, Adapt, Node, Season, Period));
 
 
************************************************************************
***********************       DISTRIBUTORS       ***********************
************************************************************************

Equations
    E3_2b_M1(FoodItem, Node, Season, Period)
    E3_2b_M2(FoodItem, Node, Season, Period)
    E3_2c_M1(FoodItem, NodeFrom, Node, Season, Period)
    E3_2c_M2(FoodItem, NodeFrom, Node, Season, Period)
    E3_2d_M1(NodeFrom, Node, Season, Period)
    E3_2d_M2(NodeFrom, Node, Season, Period)
    E3_4a_M1(FoodItem, Node, Season, Period)
;

Binary Variables
    B3_2b(FoodItem, Node, Season, Period)
    B3_2c(FoodItem, NodeFrom, Node, Season, Period)
    B3_2d(NodeFrom, Node, Season, Period)
    B3_4a(FoodItem, Node, Season, Period)
;


E3_2b_M1(FoodItem, Node, Season, Period).. QF_DB(FoodItem, Node, Season, Period) + sum(NodeFrom$Road(NodeFrom, Node), QF_ROAD(FoodItem, NodeFrom, Node, Season, Period))
                                =l= B3_2b(FoodItem, Node, Season, Period)*PrimalM +
                                QF_DS(FoodItem, Node, Season, Period) + sum(NodeFrom$Road(Node, NodeFrom),QF_ROAD(FoodItem, Node, NodeFrom, Season, Period));
E3_2b_M2(FoodItem, Node, Season, Period)..D6(FoodItem, Node, Season, Period)
        =l= (1 - B3_2b(FoodItem, Node, Season, Period))*PrimalM ;


E3_2c_M1(FoodItem, NodeFrom, Node, Season, Period)$((FoodDistrCap AND Road(NodeFrom, Node))).. -QF_ROAD(FoodItem, NodeFrom, Node, Season, Period)
                                        =l= B3_2c(FoodItem, NodeFrom, Node, Season, Period)*PrimalM
                                        -Cap_Road(FoodItem, NodeFrom, Node);
E3_2c_M2(FoodItem, NodeFrom, Node, Season, Period)..D7(FoodItem, NodeFrom, Node, Season, Period)
        =l= (1 - B3_2c(FoodItem, NodeFrom, Node, Season, Period))*PrimalM ;


E3_2d_M1(NodeFrom, Node, Season, Period)$Road(NodeFrom, Node).. -sum(FoodItem,QF_ROAD(FoodItem, NodeFrom, Node, Season, Period))
                                        =l= B3_2d(NodeFrom, Node, Season, Period)*PrimalM
                                        -Cap_Road_Tot(NodeFrom, Node);
E3_2d_M2(NodeFrom, Node, Season, Period)..D16(NodeFrom, Node, Season, Period)
        =l= (1 - B3_2d(NodeFrom, Node, Season, Period))*PrimalM ;


E3_4a_M1(FoodItem, Node, Season, Period).. Q_WB(FoodItem, Node, Season, Period) =e= QF_DS(FoodItem, Node, Season, Period);

************************************************************************
***********************       STORE/RETAIL       ***********************
************************************************************************
Equations
    E4_2a_M1(FoodItem, Node, Season, Period)
    E4_2a_M2(FoodItem, Node, Season, Period)
    E4_2b_M1(FoodItem, Node, Season, Period)
;

Binary Variables
    B4_2a(FoodItem, Node, Season, Period)
    B4_2b(FoodItem, Node, Season, Period)
;

E4_2a_M1(FoodItem, Node, Season, Period).. -Q_W(FoodItem, Node, Season, Period) =l= B4_2a(FoodItem, Node, Season, Period)*PrimalM -CAP_Store_roll(FoodItem, Node, Season, Period);
E4_2a_M2(FoodItem, Node, Season, Period)..D8(FoodItem, Node, Season, Period)
        =l= (1 - B4_2a(FoodItem, Node, Season, Period))*PrimalM ;



E4_2b_M1(FoodItem, Node, Season, Period).. Q_W(FoodItem, Node, Season-1, Period)$(Ord(Season)>1) +
        (Q_WInit(FoodItem, Node)$(ORD(Period)=1) +Q_W(FoodItem, Node, Season + (Card(Season)-1), Period-1))$(Ord(Season)=1) + Q_WB(FoodItem, Node, Season, Period)
        -Q_WS(FoodItem, Node, Season, Period) =e= Q_W(FoodItem, Node, Season, Period);



************************************************************************
************************       Node2Adapt       ************************
************************************************************************
Equations
    E4_4a_M1(FoodItem, Node, Season, Period)
;

Binary Variables
    B4_4a(FoodItem, Node, Season, Period)
;

E4_4a_M1(FoodItem, Node, Season, Period).. Q_WS(FoodItem, Node, Season, Period) =e= sum(Adapt,
                                                Q_WU(FoodItem, Node, Adapt, Season, Period)
                                                        );


$ontext
E4_4b(FoodItem, Node, Season, Period).. sum(Adapt, Adapt2Node(Adapt, Node)*
                    PI_U_ADAPT(FoodItem, Adapt, Season, Period)*Q_U(FoodItem, Adapt, Season, Period)) =l= 
                    PI_U(FoodItem, Node, Season, Period)*Q_WS(FoodItem, Node, Season, Period);
$offtext                    


************************************************************************
***********************       CONSUMERS       **********************
************************************************************************
Equations
    E5_2a_M1(FoodItem, Adapt, Season, Period)
    E5_2a_M2(FoodItem, Adapt, Season, Period)
    E5_2b_M1(FoodItem, Node, Adapt, Season, Period)
    E5_2b_M2(FoodItem, Node, Adapt, Season, Period)
;

Binary Variables
    B5_2a(FoodItem, Adapt, Season, Period)
    B5_2b(FoodItem, Node, Adapt, Season, Period)
;

E5_2a_M1(FoodItem, Adapt, Season, Period).. sum(Node, Q_WU(FoodItem, Node, Adapt, Season, Period)) 
                                            =l= B5_2a(FoodItem, Adapt, Season, Period)*PrimalM + 
                                    Q_U(FoodItem, Adapt, Season, Period);
E5_2a_M2(FoodItem, Adapt, Season, Period)..D19(FoodItem, Adapt, Season, Period)
        =l= (1 - B5_2a(FoodItem, Adapt, Season, Period))*PrimalM ;


E5_2b_M1(FoodItem, Node, Adapt, Season, Period).. Q_WU(FoodItem, Node, Adapt, Season, Period) 
                                                                =l= B5_2b(FoodItem, Node, Adapt, Season, Period)*PrimalM +
                                                Adapt2Node(Adapt, Node)*Q_U(FoodItem, Adapt, Season, Period);
E5_2b_M2(FoodItem, Node, Adapt, Season, Period)..D17(FoodItem, Node, Adapt, Season, Period)
        =l= (1 - B5_2b(FoodItem, Node, Adapt, Season, Period))*PrimalM ;



*E5_1a(FoodItem, Node, Season, Period).. Q_FOOD_ADMIN(FoodItem, Node, Season, Period) =e= QF_DB(FoodItem, Node, Season, Period);
*E5_2a(FoodItem, Adapt, Season, Period).. -PI_U_ADAPT(FoodItem, Adapt, Season, Period) =l= -(DemInt_roll(FoodItem, Adapt, Season, Period)
*                                - DemSlope_roll(FoodItem, Adapt, Season, Period)*Q_U(FoodItem, Adapt, Season, Period) 
*                                + sum(FoodItem2, DemCrossTerms_roll(FoodItem, FoodItem2, Adapt, Season, Period)*DemCrossTerms_roll(FoodItem, FoodItem2, Adapt, Season, Period)*DemSlope_roll(FoodItem, Adapt, Season, Period)*(PI_U_ADAPT(FoodItem2, Adapt, Season, Period) - PI_U_ADAPT(FoodItem, Adapt, Season, Period)))$(CrossElasOn));
*


************************************************************************
************************       ELECTRICITY       ***********************
************************************************************************
Equations
    E6_2a_M1(Node, Season, Period)
    E6_2a_M2(Node, Season, Period)
    E6_2b_M1(Node, Season, Period)
    E6_2b_M2(Node, Season, Period)
    E6_2c_M1(NodeFrom, Node, Season, Period)
    E6_2c_M2(NodeFrom, Node, Season, Period)
    E_ElecDem_M1(Node, Season, Period)
    E_ElecDem_M2(Node, Season, Period)
;

Binary Variables
    B6_2a(Node, Season, Period)
    B6_2b(Node, Season, Period)
    B6_2c(NodeFrom, Node, Season, Period)
    B_ElecDem(Node, Season, Period)
;


E6_2a_M1(Node, Season, Period).. Cap_Elec_roll(Node, Season, Period) =l= B6_2a(Node, Season, Period)*PrimalM + Q_ELEC(Node, Season, Period);
E6_2a_M2(Node, Season, Period)..D13(Node, Season, Period)
        =l= (1 - B6_2a(Node, Season, Period))*PrimalM ;


E6_2b_M1(Node, Season, Period).. Q_ELEC(Node, Season, Period) + sum(NodeFrom$Eline(NodeFrom, Node), Q_ELEC_TRANS(NodeFrom, Node, Season, Period))
                                 =l= B6_2b(Node, Season, Period)*PrimalM +
                Q_ELEC_DEM(Node, Season, Period)+sum(NodeFrom$Eline(Node, NodeFrom), Q_ELEC_TRANS(Node, NodeFrom, Season, Period));
E6_2b_M2(Node, Season, Period)..D14(Node, Season, Period)
        =l= (1 - B6_2b(Node, Season, Period))*PrimalM ;


E6_2c_M1(NodeFrom, Node, Season, Period)$Eline(NodeFrom, Node).. Cap_Elec_Trans_roll(NodeFrom, Node, Season, Period)
                                =l= B6_2c(NodeFrom, Node, Season, Period)*PrimalM +
                Q_ELEC_TRANS(NodeFrom, Node, Season, Period);
E6_2c_M2(NodeFrom, Node, Season, Period)..D15(NodeFrom, Node, Season, Period)
        =l= (1 - B6_2c(NodeFrom, Node, Season, Period))*PrimalM ;



E_ElecDem_M1(Node, Season, Period).. Q_ELEC_DEM(Node, Season, Period) =l= B_ElecDem(Node, Season, Period)*PrimalM + Base_Elec_Dem_roll(Node, Season, Period)/2;
E_ElecDem_M2(Node, Season, Period)..Q_ELEC_DEM(Node, Season, Period)
        =l= (1 - B_ElecDem(Node, Season, Period))*PrimalM ;

**************************************************************
*********OBJECTIVE********************************************
**************************************************************
Equation objEq;
Variable obj;
objEq.. obj =e= 0;
