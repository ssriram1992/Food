************************************************************************
***********************       CROP PRODUCER       **********************
************************************************************************

Equations
E1_3a(FoodItem, Node, Season, Period)
E1_3b(FoodItem, Node, Season, Period)
;


E1_3a(FoodItem, Node, Season, Period).. D2(FoodItem, Node, Season, Period) - df_roll(Period)*PI_FOOD(FoodItem, Node, Season, Period)
                            =g=
                            0;
* Fallow and crop rotation costraints not yet added
E1_3b(FoodItem, Node, Season, Period)$Crop(FoodItem).. D1(Node, Period)
        -D2(FoodItem, Node, Season, Period)*aFAO_roll(FoodItem, Node, Season, Period)*Cyf_roll(FoodItem, Node, Season, Period)*(1+(rPower(PI_FOOD(FoodItem, Node, Season, Period),Elas_roll(FoodItem, Node, Season, Period))-1)$(Elas_roll(FoodItem, Node, Season, Period)))
        + df_roll(Period)*(
            C_prod_roll(FoodItem, Node, Season, Period) +
*            C_convert(Node, Period) - C_convert(Node, Period+1) +
            C_chg_roll(Node, Period)*(AREA_CROP(FoodItem, Node, Season, Period) - AREA_CROP(FoodItem, Node, Season, Period-1) - Area_init(Node, Season,  FoodItem)$(Ord(Period)=1))-
            C_chg_roll(Node, Period+1)*(AREA_CROP(FoodItem, Node, Season, Period+1) - AREA_CROP(FoodItem, Node, Season, Period))
            )
                    =g=
            0;



************************************************************************
********************       LIVESTOCK PRODUCER       ********************
************************************************************************
* Quantity, price of milk and Beef are defined as (q/pi)_Food. Similarly for yield.

Equations
    E2_3a(FoodItem, Node, Season, Period)
    E2_3b(NodeFrom, Node, Season, Period)
    E2_3c(Node, Season, Period)
    E2_3d(Node, Season, Period)
;


E2_3a(FoodItem, Node, Season, Period)$sameas(FoodItem, "Milk").. df_roll(Period)*C_cow_roll(Node, Season, Period) - D2(FoodItem, Node, Season, Period)*Yield_roll(FoodItem, Node, Season, Period)$sameas(FoodItem, "Milk") -
    D4(Node, Season, Period)+ PI_COW(Node, Season, Period) - (1+k_roll(Node, Season, Period)-kappa_roll(Node, Season, Period))*(PI_COW(Node, Season+1, Period)$(ORD(Season)<CARD(Season)) + PI_COW(Node, Season-(CARD(Season)-1), Period+1)$(ORD(Season)=CARD(Season)))
    +CowDeath_roll(Node, Season, Period)*D9(Node, Season, Period) - D10(Node, Season, Period)
    =g=
    0;
Q_CATTLE.fx(FoodItem, Node, Season, Period)$(NOT(sameas(FoodItem,"Milk"))) = 0;
E2_3b(NodeFrom, Node, Season, Period)$(NOT(sameas(Node, NodeFrom)))..   df_roll(Period)*(C_cow_tr_roll(NodeFrom, Node, Season, Period)+
    PI_COW(NodeFrom, Season, Period) - PI_COW(Node, Season, Period))+
    (PI_COW(NodeFrom, Season, Period)-PI_COW(Node, Season, Period))
    =g=
    0;
E2_3c(Node, Season, Period).. D3(Node, Season, Period)-df_roll(Period)*pr_Hide_roll(Node, Season, Period) =g= 0;
E2_3d(Node, Season, Period).. D4(Node, Season, Period) - sum(FoodItem$sameas(FoodItem, "beef"), D2(FoodItem, Node, Season, Period)*Yield_roll(FoodItem, Node, Season, Period))-
        D3(Node, Season, Period)*Yld_H_roll(Node, Season, Period) + PI_COW(Node, Season+1, Period)$(ORD(Season)<CARD(Season)) + PI_COW(Node, Season-(CARD(Season)-1), Period+1)$(ORD(Season)=CARD(Season))-D9(Node, Season, Period)
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

E3_3a(FoodItem, Node, Season, Period).. df_roll(Period)*PI_FOOD(FoodItem, Node, Season, Period)
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
E4_3b(FoodItem, Node, Season, Period).. D11(FoodItem, Node, Season, Period) - PI_U(FoodItem, Node, Season, Period)=g= 0;

E4_3c(FoodItem, Node, Season, Period).. D8(FoodItem, Node, Season, Period)  + D11(FoodItem, Node, Season, Period)
            + CS_Q_roll(FoodItem, Node, Season, Period)*Q_W(FoodItem, Node, Season, Period)
            + CS_L_roll(FoodItem, Node, Season, Period) + D8(FoodItem, Node, Season, Period)
            - D11(FoodItem, Node, Season-(Card(Season)-1), Period+1)$(Ord(Season)=Card(Season))
            - D11(FoodItem, Node, Season+1, Period)$(Ord(Season)<>Card(Season))
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

