************************************************************************
***********************       PRE-PROCESSING       *********************
************************************************************************

scalar SolveCount /0/;
* File handle to store solution in each round
File F;
Put F;

Set Years2PtLoad(Year2Loop);


* Set this to "yes" for those years where point loading has to be used
Years2PtLoad(Year2Loop) = yes ; 