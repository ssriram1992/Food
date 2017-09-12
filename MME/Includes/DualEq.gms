************************************************************************
***********************       CROP PRODUCER       **********************
************************************************************************

Equations
E1_3a(FoodItem, Node, Season, Year)
E1_3b(FoodItem, Node, Season, Year)
;


E1_3a(FoodItem, Node, Season, Year).. d2(FoodItem, Node, Season, Year) - df(Year)*pi_Food(FoodItem, Node, Season, Year)
                            =g=
                            0;
* Fallow and crop rotation costraints not yet added
E1_3b(FoodItem, Node, Season, Year)$Crop(FoodItem).. d1(Node, Year)
        -d2(FoodItem, Node, Season, Year)*aFAO(FoodItem, Node, Season, Year)*CYF(FoodItem, Node, Season, Year)*(1+(rPower(pi_Food(FoodItem, Node, Season, Year),Elas(FoodItem, Node, Season, Year))-1)$(Elas(FoodItem, Node, Season, Year)))
        + df(Year)*(
            C_prod(FoodItem, Node, Season, Year) +
*            C_convert(Node, Year) - C_convert(Node, Year+1) +
            C_chg(Node, Year)*(Area_Crop(FoodItem, Node, Season, Year) - Area_Crop(FoodItem, Node, Season, Year-1) - Area_init(Node, Season,  FoodItem)$(Ord(Year)=1))-
            C_chg(Node, Year+1)*(Area_Crop(FoodItem, Node, Season, Year+1) - Area_Crop(FoodItem, Node, Season, Year))
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


E2_3a(FoodItem, Node, Season, Year)$sameas(FoodItem, "Milk").. df(Year)*C_cow(Node, Season, Year) - d2(FoodItem, Node, Season, Year)*Yield(FoodItem, Node, Season, Year)$sameas(FoodItem, "Milk") -
    d4(Node, Season, Year)+ pi_cow(Node, Season, Year) - (1+k(Node, Season, Year)-kappa(Node, Season, Year))*(pi_cow(Node, Season+1, Year)$(ORD(Season)<CARD(Season)) + pi_cow(Node, Season-(CARD(Season)-1), Year+1)$(ORD(Season)=CARD(Season)))
    +CowDeath(Node, Season, Year)*d9(Node, Season, Year) - d10(Node, Season, Year)
    =g=
    0;
Q_cattle.fx(FoodItem, Node, Season, Year)$(NOT(sameas(FoodItem,"Milk"))) = 0;
E2_3b(NodeFrom, Node, Season, Year)$(NOT(sameas(Node, NodeFrom)))..   df(Year)*(C_cow_tr(NodeFrom, Node, Season, Year)+
    pi_cow(NodeFrom, Season, Year) - pi_cow(Node, Season, Year))+
    (pi_cow(NodeFrom, Season, Year)-pi_cow(Node, Season, Year))
    =g=
    0;
E2_3c(Node, Season, Year).. d3(Node, Season, Year)-df(Year)*pr_Hide(Node, Season, Year) =g= 0;
E2_3d(Node, Season, Year).. d4(Node, Season, Year) - sum(FoodItem$sameas(FoodItem, "beef"), d2(FoodItem, Node, Season, Year)*Yield(FoodItem, Node, Season, Year))-
        d3(Node, Season, Year)*Yld_H(Node, Season, Year) + pi_cow(Node, Season+1, Year)$(ORD(Season)<CARD(Season)) + pi_cow(Node, Season-(CARD(Season)-1), Year+1)$(ORD(Season)=CARD(Season))-d9(Node, Season, Year)
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

E3_3a(FoodItem, Node, Season, Year).. df(Year)*pi_Food(FoodItem, Node, Season, Year)
                                =g=
                                d6(FoodItem, Node, Season, Year);
E3_3b(FoodItem, NodeFrom, Node, Season, Year)$Road(NodeFrom, Node).. d7(FoodItem, NodeFrom, Node, Season, Year)$(FoodDistrCap) + d16(NodeFrom, Node, Season, Year)  + df(Year)*CF_Road(FoodItem, NodeFrom, Node, Season, Year)
                                        =g=
                                        d6(FoodItem, Node, Season, Year) - d6(FoodItem, NodeFrom, Season, Year) ;
E3_3c(FoodItem, Node, Season, Year).. d6(FoodItem, Node, Season, Year)
                                =g=
                                df(Year)*pi_W(FoodItem, Node, Season, Year);



************************************************************************
***********************       STORE/RETAIL       ***********************
************************************************************************
Equations
    E4_3a(FoodItem, Node, Season, Year)
    E4_3b(FoodItem, Node, Season, Year)
    E4_3c(FoodItem, Node, Season, Year)
;


E4_3a(FoodItem, Node, Season, Year).. pi_W(FoodItem, Node, Season, Year) - d11(FoodItem, Node, Season, Year)=g= 0;
E4_3b(FoodItem, Node, Season, Year).. d11(FoodItem, Node, Season, Year) - pi_U(FoodItem, Node, Season, Year)=g= 0;

E4_3c(FoodItem, Node, Season, Year).. d8(FoodItem, Node, Season, Year)  + d11(FoodItem, Node, Season, Year)
            + CS_Q(FoodItem, Node, Season, Year)*q_W(FoodItem, Node, Season, Year)
            + CS_L(FoodItem, Node, Season, Year) + d8(FoodItem, Node, Season, Year)
            - d11(FoodItem, Node, Season-(Card(Season)-1), Year+1)$(Ord(Season)=Card(Season))
            - d11(FoodItem, Node, Season+1, Year)$(Ord(Season)<>Card(Season))
            =g= 0;



************************************************************************
************************       ELECTRICITY       ***********************
************************************************************************
Equations
    E6_3a(Node, Season, Year)
    E6_3b(NodeFrom, Node, Season, Year)
;

E6_3a(Node, Season, Year).. C_Elec_L(Node, Season, Year)+C_Elec_Q(Node, Season, Year)*q_Elec(Node, Season, Year)+
                        d13(Node, Season, Year) - d14(Node, Season, Year) =g= 0;
E6_3b(NodeFrom, Node, Season, Year)$Eline(NodeFrom, Node).. C_Elec_Trans(NodeFrom, Node, Season, Year)  +
                d15(NodeFrom, Node, Season, Year) + d14(NodeFrom, Season, Year) - d14(Node, Season, Year) =g= 0;

