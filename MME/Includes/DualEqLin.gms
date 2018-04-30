************************************************************************
***********************       CROP PRODUCER       **********************
************************************************************************

Equations
E1_3a(FoodItem, Adapt, Season, Period)
E1_3b(FoodItem, Adapt, Season, Period)
E1_3c(FoodItem, Adapt, Node, Season, Period) 
;


E1_3a(FoodItem, Adapt, Season, Period).. D2(FoodItem, Adapt, Season, Period) - sum(Node, Adapt2Node(Adapt, Node)*D18(FoodItem, Adapt, Node, Season, Period)) 
                            =g=
                            0;
* Fallow and crop rotation costraints not yet added
E1_3b(FoodItem, Adapt, Season, Period)$Crop(FoodItem).. D1(Adapt, Season, Period)
        -D2(FoodItem, Adapt, Season, Period)*aFAO_roll(FoodItem, Adapt, Season, Period)*Cyf_roll(FoodItem, Adapt, Season, Period) + df_roll(Period)*(
            C_prod_roll(FoodItem, Adapt, Season, Period) +
*            C_convert(Adapt, Period) - C_convert(Adapt, Period+1) +
            C_chg_roll(Adapt, Period)*(AREA_CROP(FoodItem, Adapt, Season, Period) - AREA_CROP(FoodItem, Adapt, Season, Period-1) - Area_init(Adapt, Season,  FoodItem)$(Ord(Period)=1))-
            C_chg_roll(Adapt, Period+1)*(AREA_CROP(FoodItem, Adapt, Season, Period+1) - AREA_CROP(FoodItem, Adapt, Season, Period))
            )
                    =g=
            0;
E1_3c(FoodItem, Adapt, Node, Season, Period).. D18(FoodItem, Adapt, Node, Season, Period)  - df_roll(Period)*PI_FOOD_ADMIN(FoodItem, Node, Season, Period) 
                                                    =g=
                                                    0;



************************************************************************
********************       LIVESTOCK PRODUCER       ********************
************************************************************************
* Quantity, price of milk and Beef are defined as (q/pi)_Food. Similarly for yield.

Equations
    E2_3a(FoodItem, Adapt, Season, Period)
    E2_3b(AdaptFrom, Adapt, Season, Period)
    E2_3c(Adapt, Season, Period)
    E2_3d(Adapt, Season, Period)
;


E2_3a(FoodItem, Adapt, Season, Period)$sameas(FoodItem, "Milk").. df_roll(Period)*C_cow_roll(Adapt, Season, Period) - D2(FoodItem, Adapt, Season, Period)*Yield_roll(FoodItem, Adapt, Season, Period)$sameas(FoodItem, "Milk") -
    D4(Adapt, Season, Period)+ PI_COW(Adapt, Season, Period) - (1+k_roll(Adapt, Season, Period)-kappa_roll(Adapt, Season, Period))*(PI_COW(Adapt, Season+1, Period)$(ORD(Season)<CARD(Season)) + PI_COW(Adapt, Season-(CARD(Season)-1), Period+1)$(ORD(Season)=CARD(Season)))
    +CowDeath_roll(Adapt, Season, Period)*D9(Adapt, Season, Period) - D10(Adapt, Season, Period)
    =g=
    0;
Q_CATTLE.fx(FoodItem, Adapt, Season, Period)$(NOT(sameas(FoodItem,"Milk"))) = 0;
E2_3b(AdaptFrom, Adapt, Season, Period)$(NOT(sameas(Adapt, AdaptFrom)))..   df_roll(Period)*(C_cow_tr_roll(AdaptFrom, Adapt, Season, Period)+
    PI_COW(AdaptFrom, Season, Period) - PI_COW(Adapt, Season, Period))+
    (PI_COW(AdaptFrom, Season, Period)-PI_COW(Adapt, Season, Period))
    =g=
    0;
E2_3c(Adapt, Season, Period).. D3(Adapt, Season, Period)-df_roll(Period)*pr_Hide_roll(Adapt, Season, Period) =g= 0;
E2_3d(Adapt, Season, Period).. D4(Adapt, Season, Period) - sum(FoodItem$sameas(FoodItem, "beef"), D2(FoodItem, Adapt, Season, Period)*Yield_roll(FoodItem, Adapt, Season, Period))-
        D3(Adapt, Season, Period)*Yld_H_roll(Adapt, Season, Period) + PI_COW(Adapt, Season+1, Period)$(ORD(Season)<CARD(Season)) + PI_COW(Adapt, Season-(CARD(Season)-1), Period+1)$(ORD(Season)=CARD(Season))-D9(Adapt, Season, Period)
                        =g=
                        0;


************************************************************************
***********************       DISTRIBUTORS       ***********************
************************************************************************

Equations
    E3_3a(FoodItem, Node, Season, Period)
    E3_3b(FoodItem, NodeFrom, Node, Season, Period)
    E3_3c(FoodItem, Node, Season, Period)
;

E3_3a(FoodItem, Node, Season, Period).. df_roll(Period)*PI_FOOD_ADMIN(FoodItem, Node, Season, Period)
                                =g=
                                D6(FoodItem, Node, Season, Period);
E3_3b(FoodItem, NodeFrom, Node, Season, Period)$Road(NodeFrom, Node).. D7(FoodItem, NodeFrom, Node, Season, Period)$(FoodDistrCap) + D16(NodeFrom, Node, Season, Period)  + df_roll(Period)*CF_Road_roll(FoodItem, NodeFrom, Node, Season, Period)
                                        =g=
                                        D6(FoodItem, Node, Season, Period) - D6(FoodItem, NodeFrom, Season, Period) ;
E3_3c(FoodItem, Node, Season, Period).. D6(FoodItem, Node, Season, Period)
                                =g=
                                df_roll(Period)*PI_W(FoodItem, Node, Season, Period);



************************************************************************
***********************       STORE/RETAIL       ***********************
************************************************************************
Equations
    E4_3a(FoodItem, Node, Season, Period)
    E4_3b(FoodItem, Node, Season, Period)
    E4_3c(FoodItem, Node, Season, Period)
;


E4_3a(FoodItem, Node, Season, Period).. PI_W(FoodItem, Node, Season, Period) - D11(FoodItem, Node, Season, Period)=g= 0;
E4_3b(FoodItem, Node, Season, Period).. D11(FoodItem, Node, Season, Period) 
                                        - PI_U(FoodItem, Node, Season, Period) 
                                            =g= 
                                            0;

E4_3c(FoodItem, Node, Season, Period).. D8(FoodItem, Node, Season, Period)  + D11(FoodItem, Node, Season, Period)
            + CS_Q_roll(FoodItem, Node, Season, Period)*Q_W(FoodItem, Node, Season, Period)
            + CS_L_roll(FoodItem, Node, Season, Period) + D8(FoodItem, Node, Season, Period)
            - D11(FoodItem, Node, Season-(Card(Season)-1), Period+1)$(Ord(Season)=Card(Season))
            - D11(FoodItem, Node, Season+1, Period)$(Ord(Season)<>Card(Season))
            =g= 0;


************************************************************************
************************       CONSUMERS       *************************
************************************************************************
Equations
    E5_3a(FoodItem, Node, Adapt, Season, Period)
    E5_3b(FoodItem, Adapt, Season, Period)
;

E5_3a(FoodItem, Node, Adapt, Season, Period).. PI_U(FoodItem, Node, Season, Period) - D19(FoodItem, Adapt, Season, Period) 
                                    - D17(FoodItem, Node, Adapt, Season, Period) =g= 0;

E5_3b(FoodItem, Adapt, Season, Period).. DemSlope_roll(FoodItem, Adapt, Season, Period)*Q_U(FoodItem, Adapt, Season, Period)
                                    - DemInt_roll(FoodItem, Adapt, Season, Period) + D19(FoodItem, Adapt, Season, Period)
                                    + sum(Node, Adapt2Node(Adapt, Node)*D17(FoodItem, Node, Adapt, Season, Period))
                                    =g= 0;

************************************************************************
************************       ELECTRICITY       ***********************
************************************************************************
Equations
    E6_3a(Node, Season, Period)
    E6_3b(NodeFrom, Node, Season, Period)
;

E6_3a(Node, Season, Period).. C_Elec_L_roll(Node, Season, Period)+C_Elec_Q_roll(Node, Season, Period)*Q_ELEC(Node, Season, Period)+
                        D13(Node, Season, Period) - D14(Node, Season, Period) =g= 0;
E6_3b(NodeFrom, Node, Season, Period)$Eline(NodeFrom, Node).. C_Elec_Trans_roll(NodeFrom, Node, Season, Period)  +
                D15(NodeFrom, Node, Season, Period) + D14(NodeFrom, Season, Period) - D14(Node, Season, Period) =g= 0;

