************************************************************************
***********************       CROP PRODUCER       **********************
************************************************************************

Equations
E1_3a(FoodItem, Node, Season, Year)
E1_3b(FoodItem, Node, Season, Year)
;


E1_3a(FoodItem, Node, Season, Year).. D2(FoodItem, Node, Season, Year) - df(Year)*PI_FOOD(FoodItem, Node, Season, Year)
                            =g=
                            0;
* Fallow and crop rotation costraints not yet added
E1_3b(FoodItem, Node, Season, Year)$Crop(FoodItem).. D1(Node, Year)
        -D2(FoodItem, Node, Season, Year)*aFAO(FoodItem, Node, Season, Year)*CYF(FoodItem, Node, Season, Year)*(1+(rPower(PI_FOOD(FoodItem, Node, Season, Year),Elas(FoodItem, Node, Season, Year))-1)$(Elas(FoodItem, Node, Season, Year)))
        + df(Year)*(
            C_prod(FoodItem, Node, Season, Year) +
*            C_convert(Node, Year) - C_convert(Node, Year+1) +
            C_chg(Node, Year)*(AREA_CROP(FoodItem, Node, Season, Year) - AREA_CROP(FoodItem, Node, Season, Year-1) - Area_init(Node, Season,  FoodItem)$(Ord(Year)=1))-
            C_chg(Node, Year+1)*(AREA_CROP(FoodItem, Node, Season, Year+1) - AREA_CROP(FoodItem, Node, Season, Year))
            )
                    =g=
            0;



************************************************************************
********************       LIVESTOCK PRODUCER       ********************
************************************************************************
* Quantity, price of milk and Beef are defined as (q/pi)_Food. Similarly for yield.

Equations
    E2_3a(FoodItem, Node, Season, Year)
    E2_3b(NodeFrom, Node, Season, Year)
    E2_3c(Node, Season, Year)
    E2_3d(Node, Season, Year)
;


E2_3a(FoodItem, Node, Season, Year)$sameas(FoodItem, "Milk").. df(Year)*C_cow(Node, Season, Year) - D2(FoodItem, Node, Season, Year)*Yield(FoodItem, Node, Season, Year)$sameas(FoodItem, "Milk") -
    D4(Node, Season, Year)+ PI_COW(Node, Season, Year) - (1+k(Node, Season, Year)-kappa(Node, Season, Year))*(PI_COW(Node, Season+1, Year)$(ORD(Season)<CARD(Season)) + PI_COW(Node, Season-(CARD(Season)-1), Year+1)$(ORD(Season)=CARD(Season)))
    +CowDeath(Node, Season, Year)*D9(Node, Season, Year) - D10(Node, Season, Year)
    =g=
    0;
Q_CATTLE.fx(FoodItem, Node, Season, Year)$(NOT(sameas(FoodItem,"Milk"))) = 0;
E2_3b(NodeFrom, Node, Season, Year)$(NOT(sameas(Node, NodeFrom)))..   df(Year)*(C_cow_tr(NodeFrom, Node, Season, Year)+
    PI_COW(NodeFrom, Season, Year) - PI_COW(Node, Season, Year))+
    (PI_COW(NodeFrom, Season, Year)-PI_COW(Node, Season, Year))
    =g=
    0;
E2_3c(Node, Season, Year).. D3(Node, Season, Year)-df(Year)*pr_Hide(Node, Season, Year) =g= 0;
E2_3d(Node, Season, Year).. D4(Node, Season, Year) - sum(FoodItem$sameas(FoodItem, "beef"), D2(FoodItem, Node, Season, Year)*Yield(FoodItem, Node, Season, Year))-
        D3(Node, Season, Year)*Yld_H(Node, Season, Year) + PI_COW(Node, Season+1, Year)$(ORD(Season)<CARD(Season)) + PI_COW(Node, Season-(CARD(Season)-1), Year+1)$(ORD(Season)=CARD(Season))-D9(Node, Season, Year)
                        =g=
                        0;


************************************************************************
***********************       DISTRIBUTORS       ***********************
************************************************************************

Equations
    E3_3a(FoodItem, Node, Season, Year)
    E3_3b(FoodItem, NodeFrom, Node, Season, Year)
    E3_3c(FoodItem, Node, Season, Year)
;

E3_3a(FoodItem, Node, Season, Year).. df(Year)*PI_FOOD(FoodItem, Node, Season, Year)
                                =g=
                                D6(FoodItem, Node, Season, Year);
E3_3b(FoodItem, NodeFrom, Node, Season, Year)$Road(NodeFrom, Node).. D7(FoodItem, NodeFrom, Node, Season, Year)$(FoodDistrCap) + D16(NodeFrom, Node, Season, Year)  + df(Year)*CF_Road(FoodItem, NodeFrom, Node, Season, Year)
                                        =g=
                                        D6(FoodItem, Node, Season, Year) - D6(FoodItem, NodeFrom, Season, Year) ;
E3_3c(FoodItem, Node, Season, Year).. D6(FoodItem, Node, Season, Year)
                                =g=
                                df(Year)*PI_W(FoodItem, Node, Season, Year);



************************************************************************
***********************       STORE/RETAIL       ***********************
************************************************************************
Equations
    E4_3a(FoodItem, Node, Season, Year)
    E4_3b(FoodItem, Node, Season, Year)
    E4_3c(FoodItem, Node, Season, Year)
;


E4_3a(FoodItem, Node, Season, Year).. PI_W(FoodItem, Node, Season, Year) - D11(FoodItem, Node, Season, Year)=g= 0;
E4_3b(FoodItem, Node, Season, Year).. D11(FoodItem, Node, Season, Year) - PI_U(FoodItem, Node, Season, Year)=g= 0;

E4_3c(FoodItem, Node, Season, Year).. D8(FoodItem, Node, Season, Year)  + D11(FoodItem, Node, Season, Year)
            + CS_Q(FoodItem, Node, Season, Year)*Q_W(FoodItem, Node, Season, Year)
            + CS_L(FoodItem, Node, Season, Year) + D8(FoodItem, Node, Season, Year)
            - D11(FoodItem, Node, Season-(Card(Season)-1), Year+1)$(Ord(Season)=Card(Season))
            - D11(FoodItem, Node, Season+1, Year)$(Ord(Season)<>Card(Season))
            =g= 0;



************************************************************************
************************       ELECTRICITY       ***********************
************************************************************************
Equations
    E6_3a(Node, Season, Year)
    E6_3b(NodeFrom, Node, Season, Year)
;

E6_3a(Node, Season, Year).. C_Elec_L(Node, Season, Year)+C_Elec_Q(Node, Season, Year)*Q_ELEC(Node, Season, Year)+
                        D13(Node, Season, Year) - D14(Node, Season, Year) =g= 0;
E6_3b(NodeFrom, Node, Season, Year)$Eline(NodeFrom, Node).. C_Elec_Trans(NodeFrom, Node, Season, Year)  +
                D15(NodeFrom, Node, Season, Year) + D14(NodeFrom, Season, Year) - D14(Node, Season, Year) =g= 0;

