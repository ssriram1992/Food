Scalar DualM /10000000/;

************************************************************************
***********************       CROP PRODUCER       **********************
************************************************************************

Equations
E1_3a_M1(FoodItem, Adapt, Season, Period)
E1_3b_M1(FoodItem, Adapt, Season, Period)
E1_3c_M1(FoodItem, Adapt, Node, Season, Period) 

E1_3a_M2(FoodItem, Adapt, Season, Period)
E1_3b_M2(FoodItem, Adapt, Season, Period)
E1_3c_M2(FoodItem, Adapt, Node, Season, Period) 
;

Binary Variables
B1_3a(FoodItem, Adapt, Season, Period)
B1_3b(FoodItem, Adapt, Season, Period)
B1_3c(FoodItem, Adapt, Node, Season, Period) 
;



E1_3a_M1(FoodItem, Adapt, Season, Period).. D2(FoodItem, Adapt, Season, Period) - sum(Node, Adapt2Node(Adapt, Node)*D18(FoodItem, Adapt, Node, Season, Period)) 
                            =l=
                            B1_3a(FoodItem, Adapt, Season, Period)*DualM;
E1_3a_M2(FoodItem, Adapt, Season, Period).. Q_FOOD(FoodItem, Adapt, Season, Period) =l= (1 - B1_3a(FoodItem, Adapt, Season, Period))*DualM;
* Fallow and crop rotation costraints not yet added

E1_3b_M1(FoodItem, Adapt, Season, Period)$Crop(FoodItem).. D1(Adapt, Season, Period)
        -D2(FoodItem, Adapt, Season, Period)*aFAO_roll(FoodItem, Adapt, Season, Period)*Cyf_roll(FoodItem, Adapt, Season, Period)
        + df_roll(Period)*(
            C_prod_roll(FoodItem, Adapt, Season, Period) +
*            C_convert(Adapt, Period) - C_convert(Adapt, Period+1) +
            C_chg_roll(Adapt, Period)*(AREA_CROP(FoodItem, Adapt, Season, Period) - AREA_CROP(FoodItem, Adapt, Season, Period-1) - Area_init(Adapt, Season,  FoodItem)$(Ord(Period)=1))-
            C_chg_roll(Adapt, Period+1)*(AREA_CROP(FoodItem, Adapt, Season, Period+1) - AREA_CROP(FoodItem, Adapt, Season, Period))
            )
                    =l=
            B1_3b(FoodItem, Adapt, Season, Period)*DualM;
E1_3b_M2(FoodItem, Adapt, Season, Period).. AREA_CROP(FoodItem, Adapt, Season, Period) =l= (1-B1_3b(FoodItem, Adapt, Season, Period))*DualM;

E1_3c_M1(FoodItem, Adapt, Node, Season, Period).. D18(FoodItem, Adapt, Node, Season, Period)  - df_roll(Period)*PI_FOOD_ADMIN(FoodItem, Node, Season, Period)
                                                    =l=
            B1_3c(FoodItem, Adapt, Node, Season, Period)*DualM;
E1_3c_M2(FoodItem, Adapt, Node, Season, Period)..Q_FOOD_TRANS(FoodItem, Adapt, Node, Season, Period)
        =l=
    (1-B1_3c(FoodItem, Adapt, Node, Season, Period))*DualM;


$ontext

************************************************************************
********************       LIVESTOCK PRODUCER       ********************
************************************************************************
* Quantity, price of milk and Beef are defined as (q/pi)_Food. Similarly for yield.

Equations
    E2_3a_M1(FoodItem, Adapt, Season, Period)
    E2_3a_M2(FoodItem, Adapt, Season, Period)
    E2_3b_M1(AdaptFrom, Adapt, Season, Period)
    E2_3b_M2(AdaptFrom, Adapt, Season, Period)
    E2_3c_M1(Adapt, Season, Period)
    E2_3c_M2(Adapt, Season, Period)
    E2_3d_M1(Adapt, Season, Period)
    E2_3d_M2(Adapt, Season, Period)
;
Binary Variables
    B2_3a(FoodItem, Adapt, Season, Period)
    B2_3b(AdaptFrom, Adapt, Season, Period)
    B2_3c(Adapt, Season, Period)
    B2_3d(Adapt, Season, Period)
;


E2_3a_M1(FoodItem, Adapt, Season, Period)$sameas(FoodItem, "Milk").. df_roll(Period)*C_cow_roll(Adapt, Season, Period) - D2(FoodItem, Adapt, Season, Period)*Yield_roll(FoodItem, Adapt, Season, Period)$sameas(FoodItem, "Milk") -
    D4(Adapt, Season, Period)+ PI_COW(Adapt, Season, Period) - (1+k_roll(Adapt, Season, Period)-kappa_roll(Adapt, Season, Period))*(PI_COW(Adapt, Season+1, Period)$(ORD(Season)<CARD(Season)) + PI_COW(Adapt, Season-(CARD(Season)-1), Period+1)$(ORD(Season)=CARD(Season)))
    +CowDeath_roll(Adapt, Season, Period)*D9(Adapt, Season, Period) - D10(Adapt, Season, Period)
    =l=
            B2_3a(FoodItem, Adapt, Season, Period)*DualM;
E2_3a_M2(FoodItem, Adapt, Season, Period)..Q_CATTLE(FoodItem, Adapt, Season, Period)
        =l=
    (1-B2_3a(FoodItem, Adapt, Season, Period))*DualM;



*Q_CATTLE.fx(FoodItem, Adapt, Season, Period)$(NOT(sameas(FoodItem,"Milk"))) = 0;


*$ontext

E2_3b_M1(AdaptFrom, Adapt, Season, Period)$(NOT(sameas(Adapt, AdaptFrom)))..   df_roll(Period)*(C_cow_tr_roll(AdaptFrom, Adapt, Season, Period)+
    PI_COW(AdaptFrom, Season, Period) - PI_COW(Adapt, Season, Period))+
    (PI_COW(AdaptFrom, Season, Period)-PI_COW(Adapt, Season, Period))
    =l=
    B2_3b(AdaptFrom, Adapt, Season, Period)*DualM;
*$offtext
E2_3b_M2(AdaptFrom, Adapt, Season, Period)..Q_CATTLE_BUY(AdaptFrom, Adapt, Season, Period)
    =e=
    (1-B2_3b(AdaptFrom, Adapt, Season, Period))*DualM;


E2_3c_M1(Adapt, Season, Period).. D3(Adapt, Season, Period)-df_roll(Period)*pr_Hide_roll(Adapt, Season, Period) =l= B2_3c(Adapt, Season, Period)*DualM;
E2_3c_M2(Adapt, Season, Period).. Q_HIDE(Adapt, Season, Period)
    =l=
    (1-B2_3c(Adapt, Season, Period))*DualM;


E2_3d_M1(Adapt, Season, Period).. D4(Adapt, Season, Period) - sum(FoodItem$sameas(FoodItem, "beef"), D2(FoodItem, Adapt, Season, Period)*Yield_roll(FoodItem, Adapt, Season, Period))-
        D3(Adapt, Season, Period)*Yld_H_roll(Adapt, Season, Period) + PI_COW(Adapt, Season+1, Period)$(ORD(Season)<CARD(Season)) + PI_COW(Adapt, Season-(CARD(Season)-1), Period+1)$(ORD(Season)=CARD(Season))-D9(Adapt, Season, Period)
                        =l=
                        B2_3d(Adapt, Season, Period)*DualM;
E2_3d_M2(Adapt, Season, Period).. Q_CATTLE_SL(Adapt, Season, Period)
    =l=
    (1-B2_3d(Adapt, Season, Period))*DualM;

$offtext

************************************************************************
***********************       DISTRIBUTORS       ***********************
************************************************************************

Equations
    E3_3a_M1(FoodItem, Node, Season, Period)
    E3_3a_M2(FoodItem, Node, Season, Period)
    E3_3b_M1(FoodItem, NodeFrom, Node, Season, Period)
    E3_3b_M2(FoodItem, NodeFrom, Node, Season, Period)
    E3_3c_M1(FoodItem, Node, Season, Period)
    E3_3c_M2(FoodItem, Node, Season, Period)
;

Binary Variables
    B3_3a(FoodItem, Node, Season, Period)
    B3_3b(FoodItem, NodeFrom, Node, Season, Period)
    B3_3c(FoodItem, Node, Season, Period)
;
E3_3a_M1(FoodItem, Node, Season, Period).. df_roll(Period)*PI_FOOD_ADMIN(FoodItem, Node, Season, Period) - D6(FoodItem, Node, Season, Period)
                                =l=
                                   B3_3a(FoodItem, Node, Season, Period)*DualM ;
E3_3a_M2(FoodItem, Node, Season, Period).. QF_DB(FoodItem, Node, Season, Period)
    =l=
    (1-B3_3a(FoodItem, Node, Season, Period))*DualM;
                                ;


E3_3b_M1(FoodItem, NodeFrom, Node, Season, Period)$Road(NodeFrom, Node).. D7(FoodItem, NodeFrom, Node, Season, Period)$(FoodDistrCap) + D16(NodeFrom, Node, Season, Period)  + df_roll(Period)*CF_Road_roll(FoodItem, NodeFrom, Node, Season, Period) - (D6(FoodItem, Node, Season, Period) - D6(FoodItem, NodeFrom, Season, Period))
                                        =l=
                                        B3_3b(FoodItem, NodeFrom, Node, Season, Period)*DualM;
E3_3b_M2(FoodItem, NodeFrom, Node, Season, Period).. QF_ROAD(FoodItem, Node, NodeFrom, Season, Period)
    =l=
    (1-B3_3b(FoodItem, NodeFrom, Node, Season, Period))*DualM;



E3_3c_M1(FoodItem, Node, Season, Period).. D6(FoodItem, Node, Season, Period) - df_roll(Period)*PI_W(FoodItem, Node, Season, Period)
                                =l=
                               B3_3c(FoodItem, Node, Season, Period)*DualM ;
E3_3c_M2(FoodItem, Node, Season, Period)..QF_DS(FoodItem, Node, Season, Period)
    =l=
    (1-B3_3c(FoodItem, Node, Season, Period))*DualM;



************************************************************************
***********************       STORE/RETAIL       ***********************
************************************************************************
Equations
    E4_3a_M1(FoodItem, Node, Season, Period)
    E4_3a_M2(FoodItem, Node, Season, Period)
    E4_3b_M1(FoodItem, Node, Season, Period)
    E4_3b_M2(FoodItem, Node, Season, Period)
    E4_3c_M1(FoodItem, Node, Season, Period)
    E4_3c_M2(FoodItem, Node, Season, Period)
;

Binary Variables
    B4_3a(FoodItem, Node, Season, Period)
    B4_3b(FoodItem, Node, Season, Period)
    B4_3c(FoodItem, Node, Season, Period)
;

E4_3a_M1(FoodItem, Node, Season, Period).. PI_W(FoodItem, Node, Season, Period) - D11(FoodItem, Node, Season, Period)=l= B4_3a(FoodItem, Node, Season, Period)*DualM;
E4_3a_M2(FoodItem, Node, Season, Period).. Q_WB(FoodItem, Node, Season, Period)
    =l=
    (1-B4_3a(FoodItem, Node, Season, Period))*DualM;



E4_3b_M1(FoodItem, Node, Season, Period).. D11(FoodItem, Node, Season, Period) 
                                        - PI_U(FoodItem, Node, Season, Period) 
                                            =l= 
                                            B4_3b(FoodItem, Node, Season, Period)*DualM;
E4_3b_M2(FoodItem, Node, Season, Period).. Q_WS(FoodItem, Node, Season, Period)
    =l=
    (1-B4_3b(FoodItem, Node, Season, Period))*DualM;



E4_3c_M1(FoodItem, Node, Season, Period).. D8(FoodItem, Node, Season, Period)  + D11(FoodItem, Node, Season, Period)
            + CS_Q_roll(FoodItem, Node, Season, Period)*Q_W(FoodItem, Node, Season, Period)
            + CS_L_roll(FoodItem, Node, Season, Period) + D8(FoodItem, Node, Season, Period)
            - D11(FoodItem, Node, Season-(Card(Season)-1), Period+1)$(Ord(Season)=Card(Season))
            - D11(FoodItem, Node, Season+1, Period)$(Ord(Season)<>Card(Season))
            =l= B4_3c(FoodItem, Node, Season, Period)*DualM;
E4_3c_M2(FoodItem, Node, Season, Period).. Q_W(FoodItem, Node, Season, Period)
    =l=
    (1-B4_3c(FoodItem, Node, Season, Period))*DualM;


************************************************************************
************************       CONSUMERS       *************************
************************************************************************
Equations
    E5_3a_M1(FoodItem, Node, Adapt, Season, Period)
    E5_3a_M2(FoodItem, Node, Adapt, Season, Period)
    E5_3b_M1(FoodItem, Adapt, Season, Period)
    E5_3b_M2(FoodItem, Adapt, Season, Period)
;

Binary Variables
    B5_3a(FoodItem, Node, Adapt, Season, Period)
    B5_3b(FoodItem, Adapt, Season, Period)
;
E5_3a_M1(FoodItem, Node, Adapt, Season, Period).. PI_U(FoodItem, Node, Season, Period) - D19(FoodItem, Adapt, Season, Period) 
                                    - D17(FoodItem, Node, Adapt, Season, Period) =l= B5_3a(FoodItem, Node, Adapt, Season, Period)*DualM;
E5_3a_M2(FoodItem, Node, Adapt, Season, Period).. Q_WU(FoodItem, Node, Adapt, Season, Period)
    =l=
    (1-B5_3a(FoodItem, Node, Adapt, Season, Period))*DualM;

E5_3b_M1(FoodItem, Adapt, Season, Period).. DemSlope_roll(FoodItem, Adapt, Season, Period)*Q_U(FoodItem, Adapt, Season, Period)
                                    - DemInt_roll(FoodItem, Adapt, Season, Period) + D19(FoodItem, Adapt, Season, Period)
                                    + sum(Node, Adapt2Node(Adapt, Node)*D17(FoodItem, Node, Adapt, Season, Period))
                                    =l= B5_3b(FoodItem, Adapt, Season, Period)*DualM;
E5_3b_M2(FoodItem, Adapt, Season, Period).. Q_U(FoodItem, Adapt, Season, Period)
    =l=
    (1-B5_3b(FoodItem, Adapt, Season, Period))*DualM;

************************************************************************
************************       ELECTRICITY       ***********************
************************************************************************
Equations
    E6_3a_M1(Node, Season, Period)
    E6_3a_M2(Node, Season, Period)
    E6_3b_M1(NodeFrom, Node, Season, Period)
    E6_3b_M2(NodeFrom, Node, Season, Period)
;

Binary Variables
    B6_3a(Node, Season, Period)
    B6_3b(NodeFrom, Node, Season, Period)
;

E6_3a_M1(Node, Season, Period).. C_Elec_L_roll(Node, Season, Period)+C_Elec_Q_roll(Node, Season, Period)*Q_ELEC(Node, Season, Period)+
                        D13(Node, Season, Period) - D14(Node, Season, Period) =l= B6_3a(Node, Season, Period)*DualM;
E6_3a_M2(Node, Season, Period)..Q_ELEC(Node, Season, Period)
    =l=
    (1-B6_3a(Node, Season, Period))*DualM;

E6_3b_M1(NodeFrom, Node, Season, Period)$Eline(NodeFrom, Node).. C_Elec_Trans_roll(NodeFrom, Node, Season, Period)  +
                D15(NodeFrom, Node, Season, Period) + D14(NodeFrom, Season, Period) - D14(Node, Season, Period) =l= B6_3b(NodeFrom, Node, Season, Period)*DualM;
E6_3b_M2(NodeFrom, Node, Season, Period)..Q_ELEC_TRANS(NodeFrom, Node, Season, Period)
    =l=
    (1-B6_3b(NodeFrom, Node, Season, Period))*DualM;

