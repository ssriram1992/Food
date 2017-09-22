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
    PI_FOOD(FoodItem, Node, Season, Period) "Price of Food item"
;

*** Livestock ***
Variable PI_COW(Node, Season, Period) "price of a cow";

*** Distributors ***
Variable PI_W(FoodItem, Node, Season, Period);

*** Storage ***
Variables
    PI_U(FoodItem, Node, Season, Period)
;

*** Electricity ***
Variables
    D6(FoodItem, Node, Season, Period) "Dual to E3_2b"
    D11(FoodItem, Node, Season, Period) "Dual to E4_2b"
;

*** Dual Variables ***
Positive Variables
    D1(Node, Period) "Dual to E1_2b"
    D2(FoodItem, Node, Season, Period) "Dual to E1_2cd"
    D3(Node, Season, Period) "Dual to E2_2b"
    D4(Node, Season, Period) "Dual to E2_2c"
    D7(FoodItem, NodeFrom, Node, Season, Period) "Dual to E3_2c"
    D8(FoodItem, Node, Season, Period) "Dual to E4_2a"
    D9(Node, Season, Period) "Dual to E2_2e"
    D10(Node, Season, Period) "Dual to E2_2f"
    D13(Node, Season, Period) "Dual to E6_2a"
    D14(Node, Season, Period) "Dual to E6_2b"
    D15(NodeFrom, Node, Season, Period) "Dual to E6_2c"
    D16(NodeFrom, Node, Season, Period) "Dual to E3_2d"
;
