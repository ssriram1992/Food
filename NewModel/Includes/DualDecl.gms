$ontext
*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%%*%*%*%**%*
  DECLARATION OF DUAL VARIABLES AND EQUATIONS
*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*%*
$offtext



*********************
***** Variables *****
*********************

*** Crop Producer ***
Variables
    pi_Food(FoodItem, Node, Season, Year) "Price of Food item"
;

*** Livestock ***
Variable pi_cow(Node, Season, Year) "price of a cow";

*** Distributors ***
Variable pi_W(FoodItem, Node, Season, Year);

*** Storage ***
Variables
    pi_U(FoodItem, Node, Season, Year)
;

*** Electricity ***
Variables
    d6(FoodItem, Node, Season, Year) "Dual to E3_2b"
    d11(FoodItem, Node, Season, Year) "Dual to E4_2b"
;

*** Dual Variables ***
Positive Variables
    d1(Node, Year) "Dual to E1_2b"
    d2(FoodItem, Node, Season, Year) "Dual to E1_2cd"
    d3(Node, Season, Year) "Dual to E2_2b"
    d4(Node, Season, Year) "Dual to E2_2c"
    d7(FoodItem, NodeFrom, Node, Season, Year) "Dual to E3_2c"
    d8(FoodItem, Node, Season, Year) "Dual to E4_2a"
    d9(Node, Season, Year) "Dual to E2_2e"
    d10(Node, Season, Year) "Dual to E2_2f"
    d13(Node, Season, Year) "Dual to E6_2a"
    d14(Node, Season, Year) "Dual to E6_2b"
    d15(NodeFrom, Node, Season, Year) "Dual to E6_2c"
    d16(NodeFrom, Node, Season, Year) "Dual to E3_2d"
;
