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
    PI_FOOD(FoodItem, Adapt, Season, Period) "Price of Food item"
    PI_FOOD_ADMIN(FoodItem, Node, Season, Period) "Price of Food item"
;

*** Livestock ***
Variable PI_COW(Adapt, Season, Period) "price of a cow";

*** Distributors ***
Variable PI_W(FoodItem, Node, Season, Period);

*** Storage ***
Variables
    PI_U(FoodItem, Node, Season, Period)
    PI_U_ADAPT(FoodItem, Adapt, Season, Period)
;

*** Electricity ***
Variables
    D11(FoodItem, Node, Season, Period) "Dual to E4_2b"
    D18(FoodItem, Adapt, Node, Season, Period) "Dual to E1_2e"
;

*** Dual Variables ***
Positive Variables
    D1(Adapt, Season, Period) "Dual to E1_2b"
    D2(FoodItem, Adapt, Season, Period) "Dual to E1_2cd"
    D3(Adapt, Season, Period) "Dual to E2_2b"
    D4(Adapt, Season, Period) "Dual to E2_2c"
    D6(FoodItem, Node, Season, Period) "Dual to E3_2b"
    D7(FoodItem, NodeFrom, Node, Season, Period) "Dual to E3_2c"
    D8(FoodItem, Node, Season, Period) "Dual to E4_2a"
    D9(Adapt, Season, Period) "Dual to E2_2e"
    D10(Adapt, Season, Period) "Dual to E2_2f"
    D13(Node, Season, Period) "Dual to E6_2a"
    D14(Node, Season, Period) "Dual to E6_2b"
    D15(NodeFrom, Node, Season, Period) "Dual to E6_2c"
    D16(NodeFrom, Node, Season, Period) "Dual to E3_2d"
    D17(FoodItem, Node, Adapt, Season, Period) "Dual to E5_2b"
    D19(FoodItem, Adapt, Season, Period) "Dual to E5_2a"
;
