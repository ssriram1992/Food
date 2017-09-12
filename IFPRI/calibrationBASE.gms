$TITLE Multimarket model for Ethiopia agriculture
* Rewrote by Ying ZHANG 2016/10 based on script ZonalModel4Input.gms  cleaner version
* ying 6 - adjusted for zero kcmean situations
*===================================================================================================================
* Developed by Xinshen, 12/2003
* Disaggregate production to zonal level
* Zonal level demand but with national market to balance supply and demand
*1. There are 11 regions and 56 zones in production in the model
*2. There are cross price elasticities in area function and for livestock it is the number of the head,
*3. There is only own price elasticity in yield function of prices, but technical shift parameter links with
*   a technical model done by Charles
*4. Food demand for each commodity at zonal level is a function of all prices and income
*   from the zone, taking into account of rural and urban income and demand, add up to national level
*5. By-product is modeled as a function of main product
*6. Feed demand is modeled as a function of livestock production but is very small
*7. For tradable goods, world prices are exgenous and domestic producer and consumer prices are function of
*   world prices with marketing margins which are exogenous
*8. For non-traded good, domestic prices are endogenously determined by market clearing condition and there
*   are marketing margins on both proudction and consumption sides
*9. Growth in income, area, yields are exogenous variable
*10. MCP is used for shift from non-traded to imports/exports
*===================================================================================================================

*CHANGES BY P. BLOCK:    added two excel dump commands to analyze irrigation area
*                        gave a Kcmean (CYF) to cash crops equal to the maximum cereal CYF for any given zone
*                        split final yield equation into water-type (Kcmean=1) and no water-type (Kcmean as reported)
*                        added a "crop intensity" factor that allows for multiple crop rotations per NEW irri area per year.
*                                doubling the newly irrigated area is a surrogate way of saying 2 crop harvests/year
*                                currently set at 2 rotations/year for cereals.  cash crops left at 1 rotation/year
* Ying Zhang
* PARAMETER with '0' is the calculated value under calibration which will be assigned to varibale w/o '0' for solving the model
* parameter redefined without '0' to enter the real model/ seperate from calibratiob process

SET
* ying -we will only use t=2003 for calibration and no growth rate over t is considered in simulations
* i.e. only change kcmean with other parameters constant
T          Time     /2003*2020/

* ========= commodity SETs =============
C         34 ag commodities
 /Maize,Wheat,Teff,Sorghum,Barley,Millet,Oats,Rice,Potatoes,SweetPotatoes,Enset,RootsOther,SugarRawEquivalent,Beans,Peas
PulsesOther,Ground_nuts,Rapeseed,OilcropsOther,Sesame,Tomato_Onion,VegetablesOther,Bananas,Fruits,Coffee,Beverage_spices
Stimulants from chat - a type of stimulating plant
CottonLint,BovineMeat,Mutton_GoatMeat,Poultry_Egg,MeatOther,Milk,Fish
Nagtrade,Nagntrade/

AG(c)     Agricultural commodities
 /Maize,Wheat,Teff,Sorghum,Barley,Millet,Oats,Rice,Potatoes,SweetPotatoes,Enset,RootsOther,SugarRawEquivalent,Beans,Peas
PulsesOther,Ground_nuts,Rapeseed,OilcropsOther,Sesame,Tomato_Onion,VegetablesOther,Bananas,Fruits,Coffee,Beverage_spices
Stimulants,CottonLint,BovineMeat,Mutton_GoatMeat,Poultry_Egg,MeatOther,Milk,Fish/

CROP(c)   crops
 /Maize,Wheat,Teff,Sorghum,Barley,Millet,Oats,Rice,Potatoes,SweetPotatoes,Enset,RootsOther,SugarRawEquivalent,Beans,Peas
PulsesOther,Ground_nuts,Rapeseed,OilcropsOther,Sesame,Tomato_Onion,VegetablesOther,Bananas,Fruits,Coffee,Beverage_spices
Stimulants,CottonLint/

RAINcrop(c) crops which are affected by climatic factors (CYFs)
 /Maize,Wheat,Teff,Sorghum,Barley,Millet/

CEREAL(c)
/Maize,Wheat,Teff,Sorghum,Barley,Millet,Oats,Rice/

CASH(c)      cash ag commodities
 /Enset,RootsOther,Beans,Peas,PulsesOther,Potatoes,SweetPotatoes,SugarRawEquivalent,Ground_nuts,Rapeseed,OilcropsOther
Sesame,Tomato_Onion,VegetablesOther,Bananas,Fruits,Coffee,Beverage_spices,Stimulants,CottonLint/

STAPLE(c)
 /Maize,Wheat,Teff,Sorghum,Barley,Millet,Oats,Rice,Potatoes,SweetPotatoes,Enset,RootsOther,Beans,Peas,PulsesOther,Ground_nuts,
Rapeseed,OilcropsOther,BovineMeat,Mutton_GoatMeat,Poultry_Egg,MeatOther,Milk,Fish/

OSTAPLE(c)
 /Potatoes,SweetPotatoes,Enset,RootsOther,Beans,Peas,PulsesOther,Ground_nuts,Rapeseed,OilcropsOther/

OSTAPLESM(c)
 /Potatoes,SweetPotatoes,Enset,RootsOther,Beans,Peas,PulsesOther/

smallcereal(c)
 /Sorghum,Barley,Millet,Oats/

pulse(c)
 /Beans,Peas,PulsesOther/

roots(c)
 /Potatoes,SweetPotatoes,Enset,RootsOther/

oilseed(c)
 /Ground_nuts,Rapeseed,Sesame,OilcropsOther/

Allothfod(c)
 /Coffee,Beverage_spices,SugarRawEquivalent/

LV(c)        Livestock
 /BovineMeat,Mutton_GoatMeat,Poultry_Egg,MeatOther,Milk,Fish/

meat(C)      Livestock
 /BovineMeat,Mutton_GoatMeat,Poultry_Egg,MeatOther,Fish/

veg_fruit(C)
 /Tomato_Onion,VegetablesOther,Fruits,Bananas/

ntradition(c)
/SugarRawEquivalent,Sesame,Tomato_Onion,VegetablesOther,Bananas,Fruits,Stimulants,CottonLint/

ofood(C)       other food
 /Potatoes,SweetPotatoes,Enset,RootsOther,SugarRawEquivalent,Beans,Peas,PulsesOther,Ground_nuts,
Rapeseed,OilcropsOther,Sesame,Tomato_Onion,VegetablesOther,Bananas,Fruits,Coffee,Beverage_spices,Stimulants/

CROPinput(C)      Agricultural commodities
 /Maize,Wheat,Teff,Sorghum,Barley,Millet,Oats,PulsesOther,Sesame,OilcropsOther/

CROPnone(C)       Agricultural commodities
 /Rice,Potatoes,SweetPotatoes,Enset,RootsOther,SugarRawEquivalent,Beans,Peas,Ground_nuts,Rapeseed,Tomato_Onion,
VegetablesOther,Bananas,Fruits,Coffee,Beverage_spices,Stimulants,CottonLint/


NCR(c)    Noncrops without yield function  /BovineMeat,Mutton_GoatMeat,Poultry_Egg,MeatOther,Milk,Fish,Nagtrade,Nagntrade/

TC(C)     Traded commodities
/Wheat,Rice,Sesame,Tomato_Onion,Coffee,Stimulants,CottonLint/

MC(c)     Imported commodities  /Wheat,Rice/

EC(c)     Exported commodities  /Sesame,Tomato_Onion,Coffee,Stimulants,CottonLint/

AIDC(c)   food adi commodities  /Wheat/

NTR_NAG(c)      not include nagntrade and transpt
NTC(c)          Non-traded commodities

NTC2(c)     Non-traded commodities
 /PulsesOther,Enset,RootsOther,MeatOther,Milk,nagtrade,nagntrade/

CR(c)           crops
NAG(c)          non-ag commodities

* ============= region, zone, urban or rural SETs =============
REG        11 Regions plus two foreign regions
 /Afar, Amhara, Benshangul, Gambella, Oromia, Somali, Tigray, Southern, AddisAbaba, DireDawa, Harari/

Naddis(reg)
/Afar, Amhara, Benshangul, Gambella, Oromia, Somali, Tigray, Southern, DireDawa, Harari /

ZONE 56 zones
 /
WestTigray        WEST TIGRAY (TIGRAY)
CentralTigray     CENTRAL TIGRAY (TIGRAY)
EastTigray        EAST TIGRAY (TIGRAY)
SouthTigray       SOUTH TIGRAY (TIGRAY)
Afar1             ZONE 1 (AFAR)
Afar3             ZONE 3 (AFAR)
Afar5             ZONE 5 (AFAR)
NorthGonder       NORTH GONDER (AMHARA)
SouthGonder       SOUTH GONDER (AMHARA)
NorthWolo         NORTH WOLO (AMHARA)
SouthWolo         SOUTH WOLO (AMHARA)
NorthShewaA       NORTH SHEWA (AMHARA)
EastGojam         EAST GOJAM (AMHARA)
WestGojam         WEST GOJAM (AMHARA)
Waghamera         WAGHAMERA (AMHARA)
Agewawia          AGEWAWIA (AMHARA)
AmharaOromia      OROMIA (AMHARA)
WestWelega        WEST WELEGA (OROMIA)
EastWelega        EAST WELEGA (OROMIA)
Illibabor         ILLIBABOR (OROMIA)
Jimma             JIMMA (OROMIA)
WestShewa         WEST SHEWA (OROMIA)
NorthShewaO       NORTH SHEWA (OROMIA)
EastShewa         EAST SHEWA (OROMIA)
Arsi              ARSI (OROMIA)
WestHarerge       WEST HARERGE (OROMIA)
EastHarerge       EAST HARERGE (OROMIA)
Bale              BALE (OROMIA)
Borena            BORENA (OROMIA)
Shinele           SHINELE (SOMALE)
Jijiga            JIJIGA (SOMALE)
Moyale            MOYALE (SOMALE)
Metekel           METEKEL (BENSHANGUL-GUMUZ)
Asosa             ASOSA (BENSHANGUL-GUMUZ)
Kemeshi           KEMESHI (BENSHANGUL-GUMUZ)
Gurage            GURAGE (SNNPR)
Hadiya            HADIYA (SNNPR)
KATembaro         KEMBATA ALABA TEMBARO (SNNPR)
Sidama            SIDAMA (SNNPR)
Gedio             GEDIO (SNNPR)
NorthOmo          NORTH OMO (SNNPR)
SouthOmo          SOUTH OMO (SNNPR)
Keficho-Shekicho  KEFICHO-SHEKICHO (SNNPR)
Bench-Maji        BENCH-MAJI (SNNPR)
YemWereda         YEM SPECIAL WEREDA (SNNPR)
AmaroWereda       AMARO SPECIAL WEREDA (SNNPR)
BurjiWereda       BURJI SPECIAL WEREDA (SNNPR)
KonsoWereda       KONSO SPECIAL WEREDA (SNNPR)
DerasheWereda     DERASHE SPECIAL WEREDA (SNNPR)
Gambela1          GAMBELA 1 (GAMBELA)
Gambela2          GAMBELA 2 (GAMBELA)
Gambela3          GAMBELA 3 (GAMBELA)
Harari            HARARI (HARARI)
Addis1            ADDIS ABABA 1 (ADDIS ABABA)
Addis2            ADDIS ABABA 2 (ADDIS ABABA)
DireDawa          DIRE DAWA (DIRE DAWA)
/

NAddisZone(zone)
 /
WestTigray        WEST TIGRAY (TIGRAY)
CentralTigray     CENTRAL TIGRAY (TIGRAY)
EastTigray        EAST TIGRAY (TIGRAY)
SouthTigray       SOUTH TIGRAY (TIGRAY)
Afar1             ZONE 1 (AFAR)
Afar3             ZONE 3 (AFAR)
Afar5             ZONE 5 (AFAR)
NorthGonder       NORTH GONDER (AMHARA)
SouthGonder       SOUTH GONDER (AMHARA)
NorthWolo         NORTH WOLO (AMHARA)
SouthWolo         SOUTH WOLO (AMHARA)
NorthShewaA       NORTH SHEWA (AMHARA)
EastGojam         EAST GOJAM (AMHARA)
WestGojam         WEST GOJAM (AMHARA)
Waghamera         WAGHAMERA (AMHARA)
Agewawia          AGEWAWIA (AMHARA)
AmharaOromia      OROMIA (AMHARA)
WestWelega        WEST WELEGA (OROMIA)
EastWelega        EAST WELEGA (OROMIA)
Illibabor         ILLIBABOR (OROMIA)
Jimma             JIMMA (OROMIA)
WestShewa         WEST SHEWA (OROMIA)
NorthShewaO       NORTH SHEWA (OROMIA)
EastShewa         EAST SHEWA (OROMIA)
Arsi              ARSI (OROMIA)
WestHarerge       WEST HARERGE (OROMIA)
EastHarerge       EAST HARERGE (OROMIA)
Bale              BALE (OROMIA)
Borena            BORENA (OROMIA)
Shinele           SHINELE (SOMALE)
Jijiga            JIJIGA (SOMALE)
Moyale            MOYALE (SOMALE)
Metekel           METEKEL (BENSHANGUL-GUMUZ)
Asosa             ASOSA (BENSHANGUL-GUMUZ)
Kemeshi           KEMESHI (BENSHANGUL-GUMUZ)
Gurage            GURAGE (SNNPR)
Hadiya            HADIYA (SNNPR)
KATembaro         KEMBATA ALABA TEMBARO (SNNPR)
Sidama            SIDAMA (SNNPR)
Gedio             GEDIO (SNNPR)
NorthOmo          NORTH OMO (SNNPR)
SouthOmo          SOUTH OMO (SNNPR)
Keficho-Shekicho  KEFICHO-SHEKICHO (SNNPR)
Bench-Maji        BENCH-MAJI (SNNPR)
YemWereda         YEM SPECIAL WEREDA (SNNPR)
AmaroWereda       AMARO SPECIAL WEREDA (SNNPR)
BurjiWereda       BURJI SPECIAL WEREDA (SNNPR)
KonsoWereda       KONSO SPECIAL WEREDA (SNNPR)
DerasheWereda     DERASHE SPECIAL WEREDA (SNNPR)
Gambela1          GAMBELA 1 (GAMBELA)
Gambela2          GAMBELA 2 (GAMBELA)
Gambela3          GAMBELA 3 (GAMBELA)
Harari            HARARI (HARARI)
*Addis1            ADDIS ABABA 1 (ADDIS ABABA)
*Addis2            ADDIS ABABA 2 (ADDIS ABABA)
DireDawa          DIRE DAWA (DIRE DAWA)
/


URBRUR  Urban and rural /RUR, URB /

city(reg)
/AddisAbaba, DireDawa /

* ============= technology SETs =============
TYPE              Area yield and production type according to the use of inputs
/
none              Area where no inputs are used
sfip              Area where fertilizer improved seed irrigation  pesticide
seed              Area where improved seed
fert              Area where fertilizer
irri              Area where irrigation
pest              Area where persticide
s_f               Area where improved seed and fertilizer
s_i               Area where improved seed amd irrigation
s_p               Area where improved seed and pesticide
f_i               Area where fertilizer and irrigation
f_p               Area where fertilizer and pesticide
i_p               Area where irrigation and pesticide
s_fp              Area where improved seed fertilizer and pesticide
s_fi              Area where improved seed fertilizer and irrigation
f_ip              Area where fertilizer irrigation and pesticide
/

INPtype(type)     Area yield and production type according to the use of inputs except 'none'
/
sfip              Area where fertilizer improved seed irrigation pesticide
seed              Area where improved seed
fert              Area where fertilizer
irri              Area where irrigation
pest              Area where pesticide
s_f               Area where improved seed and fertilizer
s_i               Area where improved seed and irrigation
s_p               Area where improved seed and pesticide
f_i               Area where fertilizer and irrigation
f_p               Area where fertilizer and pesticide
i_p               Area where irrigation and pesticide
s_fp              Area where improved seed fertilizer and pesticide
s_fi              Area where improved seed fertilizer and irrigation
f_ip              Area where fertilizer irrigation and pesticide
/

Ftype(type)        use fertilizer
/
sfip               Area where fertilizer improved seed irrigation  pesticide
fert               Area where fertilizer
s_f                Area where improved seed and fertilizer
f_i                Area where fertilizer and irrigation
f_p                Area where fertilizer pesticide
s_fp               Area where improved seed fertilizer and pesticide
s_fi               Area where improved seed fertilizer and irrigation
f_ip               Area where fertilizer irrigation and pesticide
/

Wtype(type)        use irrigation
/
sfip               Area where fertilizer improved seed irrigation  pesticide
irri               Area where irrigation
s_i                Area where improved seed and irrigation
f_i                Area where fertilizer and irrigation
i_p                Area where irrigation and pesticide
s_fi               Area where improved seed fertilizer and irrigation
f_ip               Area where fertilizer irrigation and pesticide
/

NWtype(type)       Area yield and production type according to the use of inputs
/
seed               Area where seed
fert               Area where fertilizer
pest               Area where pesticide
s_f                Area where improved seed and fertilizer
s_p                Area where improved seed and pesticide
f_p                Area where fertilizer and pesticide
s_fp               Area where improved seed fertilizer and pesticide
none               Area where none
/

Stype(type)        use improved seed
/
sfip               Area where improved seed fertilizer irrigation  pesticide
seed               Area where improved seed
s_f                Area where improved seed and fertilizer
s_i                Area where improved seed and irrigation
s_p                Area where improved seed and pesticide
s_fp               Area where improved seed fertilizer and pesticide
s_fi               Area where improved seed fertilizer and irrigation
/

Ptype(type)        use pesticide
/
sfip               Area where improved seed fertilizer irrigation  pesticide
pest               Area where pesticide
s_p                Area where improved seed and pesticide
f_p                Area where fertilizer and pesticide
i_p                Area where irrigation and pesticide
s_fp               Area where improved seed fertilizer and pesticide
f_ip               Area where fertilizer irrigation and pesticide   /


IrriDat
/SS_short,SS_med,SS_long,LMS long med short/

IrriDatSS(irridat)
/SS_short,SS_med,SS_long/

* ============= house-hold survey SETs =============
HHaggData /totexp,foodexp,totexp_pc,foodexp_pc,rurpop,urbpop,totpop,rurHH,urbHH,totHH,RurPopshare/

HHObs        Sample observation /1*1000/

Obsname /totexp,samplewt,hhsize/

HHS          Household income group /group1,group2,group3,group4,group5,group6,group7,group8,group9,group10/

popDendat /AREA_SQKM squared km,POPDENS/

totdat       Set created for bring data /TQS0,TQSgr,TQM0,TQF0,TQL0,TQO0,TAC0,TACgr,TYC0,TYCgr/

domainvar    variables in domain classification
/LGP_count,LGP_MIN,LGP_MAX,LGP_MEAN,LGP_MAJ for majority,LGP_MEDIAN,popwt_LGP,LGP_popwtMean crop population weighted mean
HIGHLND_COUNT,HIGH_LOW,MKT_COUNT,MKT_MIN,MKT_MAX,MKT_MEAN/
;

ALIAS (c,cp),(zone,zonep),(reg,regp),(cereal,cerealp),(cash,cashp),(hhs,hhsp),(smallcereal,smallcerealp),
(pulse,pulsep), (roots,rootsp), (oilseed,oilseedp),(allothfod,allothfodp),(lv,lvp),(nag,nagp),(ag,agp),(urbrur,urbrurp),
(HHobs,HHobsP),(type,typep),(ntradition,ntraditionp)
;

NTR_NAG(c)                        = YES;
NTR_NAG('nagntrade')              = NO;

CR(c)$(NOT NCR(c))                = YES;
NTC(c)$(NOT MC(c) and not EC(c))  = YES;

NAG(c)$(NOT AG(c))                = YES;

display NTC;

PARAMETERS
 PW0(c)              World price (dollars per metric ton)
 PWM0(c)             World cif price (dollars per metric ton)
 PWE0(c)             World fob price (dollars per metric ton)
 PP0(c)              Domestic producer price
 PC0(c)              Domestic consumer price
 PPZ0(reg,zone,c)    Domestic producer price by region
 PCZ0(reg,zone,c)    Domestic consumer price by region
 PCAVGR0(reg,c)      average domestic consumer price by region
 PPAVGR0(reg,c)      average domestic producer price by region
 PCAVG0(c)           average domestic consumer price at national level
 PPAVG0(c)           average domestic producer price at national level

 TQF0(c)              Food demand (thousand metric tons)
 TQL0(c)              Feed demand (thousand metric tons)
 TQO0(c)              Total other demand (thousand metric tons)
 TQD0(c)              Total demand (thousand metric tons)

 QFZ0(reg,zone,c)     regional food demand
 QLZ0(reg,zone,c)     regional feed demand
 QOZ0(reg,zone,c)     regional other demand
 QDZ0(reg,zone,c)     regional total demand

 QFZH0(reg,zone,urbrur,c)     regional food demand
 QFZHsh0(reg,zone,urbrur,c)   regional food demand share
 RurDemand(reg,zone,c)        rural demand data by zone
 UrbDemand(reg,zone,c)        urban demand data by zone
 RurDemandpc(reg,zone,c)      rural demand data by zone
 UrbDemandpc(reg,zone,c)      urban demand data by zone

 Rur2ndLowshare(reg,zone,c)
 Urb2ndLowshare(c)

 QLZshare0(reg,zone,c)           share of feed demand in total production
 QOZshare0(reg,zone,c)           share of other demand in total production

 QLZshare(reg,zone,c)            share of feed demand in total production
 QOZshare(reg,zone,c)            share of other demand in total production

 CONshare0(reg,zone,c)           share of food demand by zone  CON-consumption
 CONHshare0(reg,zone,urbrur,c)   share of food demand by zone

 TQFpc0(c)                       Food demand (kg per capita)
 TQLpc0(c)                       Feed demand (kg per capita)
 TQDpc0(c)                       Total demand (kg per capita)
 TQFHpc0(urbrur,c)               Food demand (kg per capita)
 QFZpc0(reg,zone,c)              regional food demand
 QFZHpc0(reg,zone,urbrur,c)      regional food demand by household group


 ACR0(reg,c)                     Area - for non-exported crop commodities (thousand hectares)
 YCR0(reg,c)                     Yield - for non-exported crop commodities (kg per thousand ha)

 ACZ0(reg,zone,c)                Area - for non-exported crop commodities (thousand hectares)
 YCZ0(reg,zone,c)                Yield - for non-exported crop commodities (kg per thousand ha)
 ACZirr0(reg,zone,c)             Irrigated Area - for non-exported crop commodities (thousand hectares)
 YCZirr0(reg,zone,c)             Yield - for non-exported crop commodities (kg per thousand ha)
 ACZirrSh0(reg,zone,c)           Share of Irrigated Area by crop and zone
 irrinACZ0(reg,zone,c)           Share of Irrigated Area in total area by crop and zone
 irrACZgr0(reg,zone,c,irriDat)   Share of Irrigated Area in total area by crop and zone
 irrACZgr(reg,zone,c,irriDat)    Share of Irrigated Area in total area by crop and zone

 TACZ0(reg,zone)                 Total area by zone
 TYCZ0(reg,zone)                 Average yield for total area by zone
 TACZirr0(reg,zone)              Irrigated Area - for non-exported crop commodities (thousand hectares)
 TACZirrSh0(reg,zone)            Share of Irrigated Area - for non-exported crop commodities (thousand hectares)
 irrinTACZ0(reg,zone)            Share of Irrigated Area - for non-exported crop commodities (thousand hectares)
 irrinTACZ20(c)                  Share of Irrigated Area - for non-exported crop commodities (thousand hectares)

 QSR0(reg,c)                     Total supply by region (thousand metric tons)
 QSZ0(reg,zone,c)                Total supply by zone (thousand metric tons)
 QSZirr0(reg,zone,c)             Total supply by zone (thousand metric tons) for irrigated condition
 QSZfert0(reg,zone,c)            Total supply by zone (thousand metric tons) for fertilizer condition
 QSZnfert0(reg,zone,c)           Total supply by zone (thousand metric tons) for non-fertilizer condition
 QSZseed0(reg,zone,c)            Total supply by zone (thousand metric tons) for improved seed condition
 QSZnseed0(reg,zone,c)           Total supply by zone (thousand metric tons) for non-improved seed condition

AAGG(reg,zone,c)    Area aggregated
ANON(reg,zone,c)    Area where no inputs are used
AALL(reg,zone,c)    Area where all inputs are used -fertilizer(F) improved seed(S) irrigation(W) pesticide(P)
AFSW(reg,zone,c)    Area where fertilizer improved seed irrigation are used
AFSP(reg,zone,c)    Area where fertilizer improved seed persticide are used
AFWP(reg,zone,c)    Area where fertilizer irrigation persticide are used
AF_S(reg,zone,c)    Area where fertilizer improved seed are used
AF_W(reg,zone,c)    Area where fertilizer irrigation are used
AF_P(reg,zone,c)    Area where fertilizer persticide are used
AS_W(reg,zone,c)    Area where improved seed irrigation are used
AS_P(reg,zone,c)    Area where improved seed persticide are used
AP_W(reg,zone,c)    Area where irrigation persticide are used
A_F(reg,zone,c)     Area where fertilizer is used
A_S(reg,zone,c)     Area where improved seed is used
A_W(reg,zone,c)     Area where irrigation is used
A_P(reg,zone,c)     Area where persticide is used

PAGG(reg,zone,c)         Production aggregated
PNON(reg,zone,c)         Production where no inputs are used
PALL(reg,zone,c)
PFSW(reg,zone,c)
PFSP(reg,zone,c)
PFWP(reg,zone,c)
PF_S(reg,zone,c)
PF_W(reg,zone,c)
PF_P(reg,zone,c)
PS_W(reg,zone,c)
PS_P(reg,zone,c)
PP_W(reg,zone,c)
P_F(reg,zone,c)
P_S(reg,zone,c)
P_W(reg,zone,c)
P_P(reg,zone,c)

YNON(reg,zone,c)          Yield where no inputs are used
YALL(reg,zone,c)
YFSW(reg,zone,c)
YFSP(reg,zone,c)
YFWP(reg,zone,c)
YF_S(reg,zone,c)
YF_W(reg,zone,c)
YF_P(reg,zone,c)
YS_W(reg,zone,c)
YS_P(reg,zone,c)
YP_W(reg,zone,c)
Y_F(reg,zone,c)
Y_S(reg,zone,c)
Y_W(reg,zone,c)
Y_P(reg,zone,c)

 ACZ_inputsh0(reg,zone,c,type)   share of Area with each input use only
 ACZ_input0(reg,zone,c,type)     Area with any of input use
 QSZ_inputsh0(reg,zone,c,type)   share of Supply with each input use only
 QSZ_input0(reg,zone,c,type)     Supply with any of input use
 YCZ_input0(reg,zone,c,type)     Yield with any input use
* 'R' stands for 'regional' , 'T' stands for 'total'
 RACZ_input0(reg,c,type)         Area with any of input use
 TACZ_input0(c,type)             Area with any of input use
 RQSZ_input0(reg,c,type)         Supply with any of input use
 TQSZ_input0(c,type)             Supply with any of input use
 RYCZ_input0(reg,c,type)         Yield with any of input use
 TYCZ_input0(c,type)             Yield with any of input use

 RACZ_inputsh0(reg,c,type)       share of Area with any of input use
 TACZ_inputsh0(c,type)           share of Area with any of input use
 RQSZ_inputsh0(reg,c,type)       share of Supply with any of input use
 TQSZ_inputsh0(c,type)           share of Supply with any of input use

 ACZ_inputTypesh0(reg,zone,c,type)       share of Area with each input use only
 ACZ_inputType0(reg,zone,c,type)         Area with each input use only
 QSZ_inputTypesh0(reg,zone,c,type)       share of Supply with each input use only
 QSZ_inputType0(reg,zone,c,type)         Supply with each input use only
 YCZ_inputType0(reg,zone,c,type)         Yield with each input use only

 RACZ_inputType0(reg,c,type)             Area with any of input use
 TACZ_inputType0(c,type)                 Area with any of input use
 RQSZ_inputType0(reg,c,type)             Supply with any of input use
 TQSZ_inputType0(c,type)                 Supply with any of input use
 RYCZ_inputType0(reg,c,type)             Yield with any of input use
 TYCZ_inputType0(c,type)                 Yield with any of input use

 RACZ_inputTypesh0(reg,c,type)           Area with any of input use
 TACZ_inputTypesh0(c,type)               Area with any of input use
 RQSZ_inputTypesh0(reg,c,type)           Supply with any of input use
 TQSZ_inputTypesh0(c,type)               Supply with any of input use

 zoneareashare(reg,zone,c)       share of total area by zone
 zoneoutputshare(reg,zone,c)     share of total output by zone

 ownareashare(reg,zone,c)        share of zonal total area
 ownoutputshare(reg,zone,c)      share of zonal total output

 TQS0(c)                 Total supply
 TAC0(c)                 Total area
 TYC0(c)                 yield at national level
 TQSpc0(c)               Total supply per capita (kg per capita)

 QT0(c)                  Trade volume (thousand metric tons positive is imports)
 QM0(c)                  imports
 QE0(c)                  exports
 AID0(c)                 aid shipment

* 'D' stands for deficit, 'T' total, 'M' import, E 'export'
 DQTZ0(reg,zone,c)       Net balance volume by zone (thousand metric tons)
 DQMZ0(reg,zone,c)       deficit by zone  (domestic import from central market to zone)
 DQEZ0(reg,zone,c)       surplus by zone  (domestic export from zone to central market)

 QSZpc0(reg,zone,c)      Total supply per capita by zone (thousand metric tons)
 TQSpc0(c)               Total supply per capita
 QTpc0(c)                Trade volume per capita (thousand metric tons)
 QTRpc0(c)               Net balance volume per capita (thousand metric tons)

 EXR0                    exchange rate

 income0                                 total income (million dollars)
 incomeR0(reg)                           regional income
 incomeZ0(reg,zone)                      zonal income
 incomeH0(reg,zone,urbrur)               zonal income by urban and rural
 incomeAgH0(reg,zone,urbrur)             zonal income by urban and rural
 incomeHpc0(reg,zone,urbrur)             zonal income by urban and rural
 incomeHsh0(reg,zone,urbrur)             share of zonal income by urban and rural
 Texpend0                                total  expenditure
 expendR0(reg)                           regional  expenditure
 expendZ0(reg,zone)                      zonal  expenditure
 expendZH0(reg,zone,urbrur)              zonal  expenditure
 expendZHsh0(reg,zone,urbrur)            share of zonal expenditure
 Texpendpc0                              per capita expenditure
 Agexpendpc0                             per capita expenditure
 expendRpc0(reg)                         regional  expenditure
 AgexpendRpc0(reg)                       regional  expenditure
 expendZpc0(reg,zone)                    zonal expenditure
 expendZHpc0(reg,zone,urbrur)            zonal expenditure
 AgexpendZpc0(reg,zone)                  zonal expenditure
 expendZshare0(reg,zone,c)               share of zonal expenditure
 expendZHshare0(reg,zone,urbrur,c)       share of zonal expenditure
 expendRshare0(reg,c)                    share of zonal expenditure

 GDP0                    total GDP (WDI million US$ 98_01 avg)
 AgrGDP0                 agriculture GDP (WDI million US$ 98_01 avg)
 IndGDP0                 industry GDP (WDI million US$ 98_01 avg)
 SerGDP0                 service GDP (WDI million US$ 98_01 avg)

 AgGDP0                  agr GDP (WDI million US$ 98_01 avg)
 NAgGDP0                 non-agr GDP (WDI million US$ 98_01 avg)    -ying

 GDPR0(reg)                      regional GDP
 GDPZ0(reg,zone)                 zonal GDP
 AgGDPZ0(reg,zone)               zonal Ag GDP

 NAgGDPZ0(reg,zone)              zonal Non-Ag GDP
 GDPZH0(reg,zone,urbrur)         zonal GDP by urban and rural
 GDPZHsh0(reg,zone,urbrur)       share of zonal GDP by urban and rural
 GDPpc0                          value of per capita GDP for all output at PC price
 GDPRpc0(reg)                    regional per capita GDP
 GDPZpc0(reg,zone)               zonal per capita GDP
 AgGDPZpc0(reg,zone)             zonal per capita Ag GDP
 NAgGDPZpc0(reg,zone)            zonal per capita Non-Ag GDP
 GDPZHpc0(reg,zone,urbrur)       zonal per capita GDP by urban and rural
 AgGDPpc0                        value of per capita Ag GDP for all output at PC price
 AgGDPRpc0(reg)                  regional per capita Ag GDP
 AgGDPZpc0(reg,zone)             zonal per capita Ag GDP
 NAgGDPpc0                       value of per capita Non-Ag GDP for all output at PC price
 NAgGDPRpc0(reg)                 regional per capita Non-Ag GDP
 NAgGDPZpc0(reg,zone)            zonal per capita Non-Ag GDP

 INCOMEag0(reg,zone,urbrur)      total ag income
 INCOMEnag0(reg,zone,urbrur)     total non-ag income
 INCOMEagPC0(reg,zone,urbrur)    per capita ag income
 INCOMEnagPC0(reg,zone,urbrur)   per capita non-ag income

 Tpop0                           Population (million)
 popUrb0                         Urban population (million)
 popRur0                         Rural population (million)
 popR0(reg)                      regional Population (million)
 popRH0(reg,urbrur)              regional urban and rural Population (million)
 popZ0(reg,zone)                 zonal Population (million)
 popH0(reg,zone,urbrur)          zonal Population by urban and rural (million)
 PopRurShare(reg)                Rural population share in total regional pop
 PopZShare(reg,zone)             zonal population share
 PopHShare0(reg,zone,urbrur)     zonal urban and rural population share
 PopHShare(reg,zone,urbrur)      zonal urban and rural population share
 PopRHShare(reg,urbrur)          regional urban and rural population share
 popH(reg,zone,urbrur)           zonal population by urban and rural (million)

 GDP_USD0                value of all output at PC price in US Dollar
 GDPpc_USD0              value of per capita all output at PC price in US Dollar

 edfiL(t,c)                      Income ealsticity of food demand low income
 edfiH(t,c)                      Income ealsticity of food demand high income
 edfiHH(urbrur,c)                Income ealsticity of food demand rural and urban
 edfi0(t,reg,zone,c)             Income elasticity of food demand
 edfiZH0(reg,zone,urbrur,c)      Income elasticity of food demand
 edfp0(t,reg,zone,c,cp)          Price elasticity of food demand
 edfpH0(reg,zone,urbrur,c,cp)    Price elasticity of food demand
 edfi(reg,zone,c)                Income elasticity of food demand
 edfp(reg,zone,c,cp)             Price elasticity of food demand
 edfiZH(reg,zone,urbrur,c)       Income elasticity of food demand
 edfpH(reg,zone,urbrur,c,cp)     Price elasticity of food demand

 eap0(reg,zone,c,cp)             Area own- and cross- price elasticities
 eyp0(reg,zone,c)                Yield own-price elasticity
 esp0(reg,zone,c,cp)             Output own- and cross- price elasticities - ()
*()-for production function with no yield-area distinction (livestock)
 eap(reg,zone,c,cp)              Area own- and cross- price elasticities
 eyp(reg,zone,c)                 Yield own-price elasticity
 esp(reg,zone,c,cp)              Output own- and cross- price elasticities - ()

*esp2 w and w/o '0'
 esp20(reg,zone,c,cp)            Output own- and cross- price elasticities - ()
 esp2(reg,zone,c,cp)             Output own- and cross- price elasticities - ()
 esl(c,cp,reg,zone)              Feed price elasticity of livestock demand

* ying2 - ay over years 1983-2011?
 af0(t,reg,zone,c)               food demand intercept for zone
 afH0(reg,zone,urbrur,c)         food demand intercept for zone
 aa0(reg,zone,c)                 Area intercept
 ay0(reg,zone,c)                 Yield intercept
 aaIrr0(reg,zone,c)              Area intercept
 ayIrr0(reg,zone,c)              Yield intercept

 eapInput0(reg,zone,c,cp,type)   Area own- and cross- price elasticities
 eypInput0(reg,zone,c,type)      Yield own-price elasticity
 espInput0(reg,zone,c,cp,type)   Output own- and cross- price elasticities - ()

 eapInput(reg,zone,c,cp,type)    Area own- and cross- price elasticities
 eypInput(reg,zone,c,type)       Yield own-price elasticity
 espInput(reg,zone,c,cp,type)    Output own- and cross- price elasticities - ()

 aaInput0(reg,zone,c,type)       Area intercept
 ayInput0(reg,zone,c,type)       Yield intercept
 aaInput(reg,zone,c,type)        Area intercept
 ayInput(reg,zone,c,type)        Yield intercept

 as0(reg,zone,c)                 Supply intercept - ()
 al0(reg,zone,c)                 feed demand intercept for zone ('l' for livestock)
 af(reg,zone,c)                  food demand intercept for zone
 afH(reg,zone,urbrur,c)          food demand intercept for zone
 aa(reg,zone,c)                  Area intercept
 aaIrr(reg,zone,c)               Area intercept
 ay(reg,zone,c)                  Yield intercept
 ayIrr(reg,zone,c)               Yield intercept
 as(reg,zone,c)                  Supply intercept - ()
 al(reg,zone,c)                  feed demand intercept for zone ('l' for livestock)

 margZ0(reg,zone,c)              Margin on domestic prices sold in domestic market (between PC and PP)
 margZ(reg,zone,c)               Margin on domestic prices sold in domestic market (between PC and PP)
 gapZ0(reg,zone,c)               Gap between consumer price at zonal level to overall consumer price PC(c)
 gapZ(reg,zone,c)                Gap between consumer price at zonal level to overall consumer price PC(c)
 gapZ2(reg,zone,c)               Gap between consumer price at zonal level to overall consumer price PC(c)
 margW0(c)                       Margin on domestic prices from or to ROW (rest of world)
 margW(c)                        Margin on domestic prices from or to ROW
 margD0(c)                       Margin on domestic prices
 margD(c)                        Margin on domestic prices
 totmargZ0(reg,zone)             Margin on domestic prices sold in domestic market


domain_var0(reg,zone,domainvar)                  domain information

*=== Rainfall information
*Kc is climate yield reduction factor
*Kc=1 means there is no rainfall constraint to yield
Kc_Mean(reg,zone,c)      40 years of mean value of Kc
KcMean0(reg,zone,c)      40 years of mean value of Kc
KcMean(reg,zone,c)       40 years of mean value of Kc

*==== HH survey data
HH                                       household
HHaggDat(reg,zone,HHaggData)             household aggregated data
HHaggDatUS(reg,zone,HHaggData)           household aggregated data
HHtotexpshare0(reg,zone)                 share of household total expenditure
HHfodexpshare0(reg,zone)                 share of household food expenditure
HHnfodexpshare0(reg,zone)                share of household non-food expenditure
HHnfoodexp0(reg,zone)                    share of household food expenditure
HHnfodexpshareH0(reg,zone,urbrur)        share of household non-food expenditure
HHnfoodexpH0(reg,zone,urbrur)            household non-food expenditure
HHnfoodexpHpc0(reg,zone,urbrur)          household non-food expenditure

Rurobs(reg,zone,HHObs,Obsname)           rural obs
Urbobs(reg,zone,HHObs,Obsname)           urban obs
HHobsDat(reg,zone,HHObs,urbrur,Obsname)  household obs
HHobsPop0(reg,zone,HHObs,urbrur)         population
HHobsPopsh0(reg,zone,HHObs,urbrur)       share of population
HHobsIncPC00(reg,zone,HHobs,urbrur)      income per capita 00 for adjusted value based on sample size
HHobsIncPC0(reg,zone,HHobs,urbrur)       income per capita
HHobsInc0(reg,zone,HHobs,urbrur)         income
HHobsIncsh0(reg,zone,HHobs,urbrur)       share of income
HHobsPCsh0(reg,zone,HHobs,urbrur)        share of income per capita

*===Irrigation investment data
IrriNew(reg,irriDat)                     regional irr
IrriZNew(reg,zone,irriDat)               zonal irr
IrriACZNew(reg,zone,c,irriDat)           zonal irr area
IrriACZNewSh(reg,zone,c,irriDat)         share of zonal irr area

 popHH0(urbrur,HHS)                      Population by hh group (million)
 popRHH0(reg,urbrur,HHS)                 regional Population by hh group (million)
 popZHH0(reg,zone,urbrur,HHS)            zonal Population by hh group (million)
 HHIshare(HHS)                           HH income group share in total
 HHI0(urbrur,HHS)                        HH income by group
 HHI00(urbrur,HHS)                       HH income by group
 HHIpc0(urbrur,HHS)                      per capita HH income by group
 HHIpc00(urbrur,HHS)                     per capita HH income by group
 HHIR0(reg,urbrur,HHS)                   HH income by group
 HHIR00(reg,urbrur,HHS)                  HH income by group
 HHIRpc0(reg,urbrur,HHS)                 per capita HH income by group
 HHIRpc00(reg,urbrur,HHS)                per capita HH income by group
 HHIRshare(reg,urbrur,HHS)               HH income group share in total
 HHIZ0(reg,zone,urbrur,HHS)              HH income by group
 HHIZ00(reg,zone,urbrur,HHS)             HH income by group
 HHIZpc0(reg,zone,urbrur,HHS)            per capita HH income by group
 HHIZpc00(reg,zone,urbrur,HHS)           per capita HH income by group
 HHIZpc00(reg,zone,urbrur,HHS)           per capita HH income by group
 HHIZshare0(reg,zone,urbrur,HHS)         HH income group share in total
 HHIshareZ0(reg,zone,urbrur,HHS)         HH income group share in zone total

 HHgroupRur0(reg,zone,HHS)               zonal household group in rural area
 HHgroupUrb0(reg,zone,HHS)               zonal household group in urban area
 HHgroupNation0(HHS,urbrur)              all household group in rural and urban area


 HHI(urbrur,HHS)                         HH income by group
 HHIpc(urbrur,HHS)                       per capita HH income by group
 HHIZshare(reg,zone,urbrur,HHS)          HH income group share in total by zone and urban rural
 HHIshareZ(reg,zone,urbrur,HHS)          HH income group share in total by zone and urban rural


*=== population desensity
PopDen0(reg,zone,PopDenDat)              zonal population density data
PopDenZ0(reg,zone)                       zonal population density

*==== import and export
* ying-CIF:Cost Insurance and Freight; FOB-Free On Board
 PW(c)                   World price (dollars per metric ton)
 PWM(c)                  World cif price (dollars per metric ton)
 PWE(c)                  World fob price (dollars per metric ton)
 margW(c)                Margin on domestic prices

*=== others
 tpop                    Population - updated yearly in loop according to gp
 popHH(urbrur,HHS)       Population by hh group (million)

 popr(reg,zone)          Population - updated yearly in loop according to gp

 KcalRatio               Calories per 0.1 kilogram
 intermal                intercept in malnutriion equation
 ninfant0                number of childran 0_5
 ninfant                 number of childran 0_5
 pmaln0                  percent of malnourished child
 nmaln0         number of malnourished child
 melas                   elasticity in percent of malnourished child equation
 TCALPC0        Calories consumed per capita per day
 CALPC0(c)      Calories consumed by commodity per capita per day
;
* undefined
$onundf
Parameter
 TOTDATA(totdat,c)         total data
;

* ================================== import data =====================================
* use 100-yr avg kcmean
*$CALL 'GDXXRW Input/inputdatafile.xls se=0 index=Index!A1'
* use kcmean for 2003
$CALL 'GDXXRW Input/inputdatafile2.xls se=0 index=Index!A1'

*$gdxin inputdatafile.gdx
$gdxin inputdatafile2.gdx
$LOAD   TOTDATA
$LOAD   Tpop0 PopUrb0
$LOAD   GDP0 AgrGDP0 IndGDP0 SerGDP0
$LOAD   zoneareashare zoneoutputshare
$LOAD   PopZ0
$LOAD   PopRurshare  HHIshare
$LOAD   PW0
$LOAD   edfiL edfiH
$LOAD   eyp0
$LOAD   domain_var0
$LOAD   Kc_Mean
$LOAD   HHaggDat
$LOAD   PopDen0
$LOAD   HHgroupRur0
$LOAD   HHgroupUrb0
$LOAD   HHgroupNation0
$LOAD   margW0
$LOAD   CONshare0
$LOAD   ACZirr0
$LOAD   RurObs
$LOAD   UrbObs
$LOAD   RurDemand
$LOAD   UrbDemand
$LOAD   Rur2ndLowshare
$LOAD   Urb2ndLowshare
$LOAD   KcalRatio ninfant0

$gdxin

* inputfile showing area, production, yield in response to technology input
$CALL 'GDXXRW Input/inputusefile.xls se=0 index=Index!A1'

$gdxin inputusefile.gdx
$LOAD   ANON
$LOAD   PNON
$LOAD   AALL
$LOAD   PALL
$LOAD   AFSW
$LOAD   PFSW
$LOAD   AFSP
$LOAD   PFSP
$LOAD   AFWP
$LOAD   PFWP
$LOAD   AF_S
$LOAD   PF_S
$LOAD   AF_W
$LOAD   PF_W
$LOAD   AF_P
$LOAD   PF_P
$LOAD   AS_W
$LOAD   PS_W
$LOAD   AS_P
$LOAD   PS_P
$LOAD   AP_W
$LOAD   PP_W
$LOAD   A_F
$LOAD   P_F
$LOAD   A_S
$LOAD   P_S
$LOAD   A_W
$LOAD   P_W
$LOAD   A_P
$LOAD   P_P

$gdxin

* =========================================== Calibration =========================================
*==== Input: Population
parameter
chkurbshare              check urban population share
;
chkurbshare = 100*Popurb0/Tpop0  ;
display chkurbshare, Popurb0;

parameter
nonrurpop(reg,zone)      zone with no rural population but only urban pop
nonpopH(reg,zone)        zone with no population agg from urbrur but show up in popZ (which should not happen)
chkTpop                  check total populatin
chkpopH(urbrur)          check urban and rural population
;

PopZShare(reg,zone)$sum((regp,zonep),PopZ0(regp,zonep))  = PopZ0(reg,zone)/sum((regp,zonep),PopZ0(regp,zonep)) ;
PopHShare(reg,zone,'rur')                                = HHaggDat(reg,zone,'RurPopshare');
*PopHShare('AddisAbaba',zone,'rur')                      = 0.0 ;
PopHShare(reg,zone,'urb')$HHaggDat(reg,zone,'totexp')    = 1 - PopHShare(reg,zone,'rur') ;

PopZ0(reg,zone)          = PopZShare(reg,zone)*Tpop0;
PopR0(reg)               = sum(zone,PopZ0(reg,zone)) ;
popH0(reg,zone,urbrur)   = PopHShare(reg,zone,urbrur)*PopZ0(reg,zone)  ;
popRH0(reg,urbrur)       = sum(zone,popH0(reg,zone,urbrur)) ;

popRHshare(reg,urbrur)$sum(urbrurp,popRH0(reg,urbrurp) ) = popRH0(reg,urbrur)/sum(urbrurp,popRH0(reg,urbrurp) ) ;

nonrurpop(reg,zone)$(PopZ0(reg,zone) and PopHShare(reg,zone,'rur') eq 0)         = yes;
nonpopH(reg,zone)$(PopZ0(reg,zone) and sum(urbrur,popH0(reg,zone,urbrur)) eq 0)  = yes;
display nonpopH, nonrurpop, popHshare;

chkTpop          = sum((reg,zone,urbrur),popH0(reg,zone,urbrur)) - Tpop0 ;
chkPopH('urb')   = sum((reg,zone),popH0(reg,zone,'urb')) - PopUrb0 ;
chkPopH('rur')   = sum((reg,zone),popH0(reg,zone,'rur')) - (Tpop0 - Popurb0) ;

display chkTpop, chkPopH ;

PopZShare(reg,zone)$sum((regp,zonep,urbrur),popH0(regp,zonep,urbrur))
                  = sum(urbrur,popH0(reg,zone,urbrur))/sum((regp,zonep,urbrur),popH0(regp,zonep,urbrur));

PopRur0           = sum((reg,zone),popH0(reg,zone,'rur'));
Tpop0             = sum((reg,zone,urbrur),popH0(reg,zone,urbrur));
PopUrb0           = Tpop0 - PopRur0 ;

PopRurShare(reg)  = sum(zone,popH0(reg,zone,'rur'))/sum((zone,urbrur),popH0(reg,zone,urbrur));
chkurbshare       = 100*Popurb0/Tpop0 ;

display chkurbshare;

chkTpop          = sum((reg,zone,urbrur),popH0(reg,zone,urbrur)) - Tpop0 ;
chkPopH('urb')   = sum((reg,zone),popH0(reg,zone,'urb')) - PopUrb0 ;
chkPopH('rur')   = sum((reg,zone),popH0(reg,zone,'rur')) - (Tpop0 - Popurb0) ;

display chkTpop, chkPopH ;

PopDenZ0(reg,zone)$PopZ0(reg,zone)       = PopZ0(reg,zone)/popDen0(reg,zone,'AREA_SQKM') ;
display PopDenZ0;

* ==== Input: totexp, foodexp, zonal Population
*ying-8.746 - currency exchange rate at that time (2003)
HHaggdatUS(reg,zone,HHaggData)     = HHaggdat(reg,zone,HHaggData)/8.746 ;
HHaggdatUS(reg,zone,'rurpop')      = HHaggdat(reg,zone,'rurpop') ;
HHaggdatUS(reg,zone,'urbpop')      = HHaggdat(reg,zone,'urbpop') ;
HHaggdatUS(reg,zone,'totpop')      = HHaggdat(reg,zone,'totpop') ;
HHaggdatUS(reg,zone,'rurpopshare') = HHaggdat(reg,zone,'rurpopshare') ;
display HHaggdatUS;

* ==== Input: zonal Income  HHS:group 1-10
HHIZpc00(reg,zone,'rur',HHS) = HHgroupRur0(reg,zone,HHS)/8.746 ;
HHIZpc00(reg,zone,'urb',HHS) = HHgroupUrb0(reg,zone,HHS)/8.746 ;

incomeH0(reg,zone,'rur')          = sum(HHS,HHIZpc00(reg,zone,'rur',HHS))*0.1*HHaggDatUS(reg,zone,'rurpop') ;
incomeH0(reg,zone,'urb')$HHaggDatUS(reg,zone,'urbpop')
                                  = sum(HHS,HHIZpc00(reg,zone,'urb',HHS))*0.1*HHaggDatUS(reg,zone,'urbpop') ;
* addis ababa has two zones (addis1 and addis2), same income, use the average of two
incomeH0('AddisAbaba',zone,'urb') = 0.5*sum((zonep,HHS),HHIZpc00('AddisAbaba',zonep,'urb',HHS)*0.1*HHaggDatUS('AddisAbaba',zonep,'urbpop')) ;

incomeHpc0(reg,zone,'rur')$HHaggDatUS(reg,zone,'rurpop') = incomeH0(reg,zone,'rur')/HHaggDatUS(reg,zone,'rurpop') ;
incomeHpc0(reg,zone,'urb')$HHaggDatUS(reg,zone,'urbpop') = incomeH0(reg,zone,'urb')/HHaggDatUS(reg,zone,'urbpop') ;
incomeHpc0('AddisAbaba',zone,'urb')$incomeH0('AddisAbaba',zone,'urb')
                                                         = incomeH0('AddisAbaba',zone,'urb')/(0.5*sum(zonep,HHaggDatUS('AddisAbaba',zonep,'urbpop'))) ;
incomeHsh0(reg,zone,urbrur)$incomeH0(reg,zone,urbrur)    = incomeH0(reg,zone,urbrur)/sum(urbrurp,incomeH0(reg,zone,urbrurp)) ;
display incomeHpc0, incomeHsh0;

* ==== Input: zonal Demand for food
RurDemandpc(reg,zone,c)$RurDemand(reg,zone,c) = RurDemand(reg,zone,c)/HHaggDatUS(reg,zone,'rurpop') ;
UrbDemandpc(reg,zone,c)$UrbDemand(reg,zone,c) = UrbDemand(reg,zone,c)/HHaggDatUS(reg,zone,'urbpop') ;
UrbDemandpc('AddisAbaba',zone,c)$UrbDemand('AddisAbaba',zone,c)
                                              = UrbDemand('AddisAbaba',zone,c)/(0.5*sum(zonep,HHaggDatUS('AddisAbaba',zonep,'urbpop'))) ;

* non-foodexp using data sources with rural and urban separation, here income is from agg HH survey
* non-foodexp = income - food demand(unit of $), in this model income is from the supply/yield
HHnfoodexpH0(reg,zone,'rur') = incomeH0(reg,zone,'rur') - sum(c,RurDemand(reg,zone,c)) ;
HHnfoodexpH0(reg,zone,'urb') = incomeH0(reg,zone,'urb') - sum(c,UrbDemand(reg,zone,c)) ;

HHnfoodexpHpc0(reg,zone,'rur')$HHaggDatUS(reg,zone,'rurpop') = HHnfoodexpH0(reg,zone,'rur')/HHaggDatUS(reg,zone,'rurpop') ;
HHnfoodexpHpc0(reg,zone,'urb')$HHaggDatUS(reg,zone,'urbpop') = HHnfoodexpH0(reg,zone,'urb')/HHaggDatUS(reg,zone,'urbpop') ;

HHnfodexpshareH0(reg,zone,urbrur)$incomeH0(reg,zone,urbrur)  = HHnfoodexpH0(reg,zone,urbrur)/incomeH0(reg,zone,urbrur) ;
display HHnfodexpshareH0;

*Demand in $
RurDemand(reg,zone,c)$RurDemandpc(reg,zone,c) = RurDemandpc(reg,zone,c)*PopH0(reg,zone,'rur') ;
UrbDemand(reg,zone,c)$UrbDemandpc(reg,zone,c) = UrbDemandpc(reg,zone,c)*PopH0(reg,zone,'urb') ;

RurDemand(reg,zone,c)$(PopH0(reg,zone,'rur') eq 0) = 0;
UrbDemand(reg,zone,c)$(PopH0(reg,zone,'urb') eq 0) = 0;

RurDemandpc(reg,zone,c)$RurDemand(reg,zone,c) = RurDemand(reg,zone,c)/PopH0(reg,zone,'rur') ;
UrbDemandpc(reg,zone,c)$UrbDemand(reg,zone,c) = UrbDemand(reg,zone,c)/PopH0(reg,zone,'urb') ;


parameter
chknegnfood(reg,zone,urbrur)             negative non-food expenditure
chkzonenfood(reg,zone,urbrur)            has income but non-food exp is zero (spending all income for food) (showing 'yes' if so)
;

chknegnfood(reg,zone,urbrur)$(HHnfoodexpH0(reg,zone,urbrur) lt 0) = HHnfoodexpH0(reg,zone,urbrur);
chkzonenfood(reg,zone,urbrur)$(incomeH0(reg,zone,urbrur) and HHnfoodexpH0(reg,zone,urbrur) eq 0) = yes;

display chknegnfood, chkzonenfood;

* non-food exp using data sources without rural and urban separation
* non-foodexp = totexp - foodexp
HHnfoodexp0(reg,zone)            = HHaggDatUS(reg,zone,'totexp') - HHaggDatUS(reg,zone,'foodexp') ;
HHnfodexpshare0(reg,zone)        = HHnfoodexp0(reg,zone)/sum((regp,zonep),HHnfoodexp0(regp,zonep)) ;
incomeH0(reg,zone,urbrur)        = incomeHpc0(reg,zone,urbrur)*PoPH0(reg,zone,urbrur);

incomeH0(reg,zone,'rur')$(PopH0(reg,zone,'rur') eq 0) = 0 ;
incomeH0(reg,zone,'urb')$(PopH0(reg,zone,'urb') eq 0) = 0 ;

HHnfoodexpH0(reg,zone,urbrur)$HHnfoodexpHpc0(reg,zone,urbrur) = HHnfoodexpHpc0(reg,zone,urbrur)*PoPH0(reg,zone,urbrur);
incomeHsh0(reg,zone,urbrur)$incomeH0(reg,zone,urbrur)         = incomeH0(reg,zone,urbrur)/sum(urbrurp,incomeH0(reg,zone,urbrurp)) ;

Parameter
chkI0(urbrur)                        check income by urban and rural
chkIpc0(urbrur)                      check per capita income by urban and rural
;
HHIZ00(reg,zone,urbrur,HHS)$PoPH0(reg,zone,urbrur)        = 0.1*PoPH0(reg,zone,urbrur)*HHIZpc00(reg,zone,urbrur,HHS) ;
HHIR00(reg,urbrur,HHS)                                    = sum(zone,HHIZ00(reg,zone,urbrur,HHS)) ;
HHI00(urbrur,HHS)                                         = sum((reg,zone),HHIZ00(reg,zone,urbrur,HHS)) ;
HHIRpc00(reg,urbrur,HHS)$sum(zone,PoPH0(reg,zone,urbrur)) = sum(zone,HHIZ00(reg,zone,urbrur,HHS))/(0.1*sum(zone,PoPH0(reg,zone,urbrur))) ;
HHIpc00(urbrur,HHS)                                       = sum((reg,zone),HHIZ00(reg,zone,urbrur,HHS))/(0.1*sum((reg,zone),PoPH0(reg,zone,urbrur))) ;

display HHIpc00 ;

HHIpc00(urbrur,HHS)      = HHgroupNation0(HHS,urbrur)/8.746 ;
HHI00(urbrur,HHS)        = 0.1*HHIpc00(urbrur,HHS)*sum((reg,zone),PoPH0(reg,zone,urbrur) );

chkI0(urbrur)            = sum(HHS,HHI00(urbrur,HHS));
chkIpc0(urbrur)          = sum(HHS,HHI00(urbrur,HHS))/sum((reg,zone),PoPH0(reg,zone,urbrur) );

HHIZshare0(reg,zone,urbrur,HHS)                                          = HHIZ00(reg,zone,urbrur,HHS)/sum(HHSP,HHI00(urbrur,HHSP));
HHIshareZ0(reg,zone,urbrur,HHS)$sum(HHSP,HHIZ00(reg,zone,urbrur,HHSP))   = HHIZ00(reg,zone,urbrur,HHS)/sum(HHSP,HHIZ00(reg,zone,urbrur,HHSP));

display HHIpc00, HHI00, chkI0, chkIpc0 ;

*=== Input: HH data of totexp, hhsize, samplewt to calculate income and poverty
Parameter
HHobsPoPZ0(reg,zone,urbrur)               household obs pop
HHobsPoPZsh0(reg,zone,urbrur)             share of household obs pop
HHobsPoPZdif0(reg,zone,urbrur)            ratio of pop calc by HHobs divided by pop calc by Tpop (should be ~1)

chkobsIncsh(reg,zone,urbrur)
;

HHobsDat(reg,zone,HHObs,'rur','totexp')          = Rurobs(reg,zone,HHObs,'totexp')/8.746 ;
HHobsDat(reg,zone,HHObs,'urb','totexp')          = Urbobs(reg,zone,HHObs,'totexp')/8.746 ;

HHobsDat(reg,zone,HHObs,'rur','hhsize')          = Rurobs(reg,zone,HHObs,'hhsize') ;
HHobsDat(reg,zone,HHObs,'urb','hhsize')          = Urbobs(reg,zone,HHObs,'hhsize') ;

HHobsDat(reg,zone,HHObs,'rur','samplewt')        = Rurobs(reg,zone,HHObs,'samplewt') ;
HHobsDat(reg,zone,HHObs,'urb','samplewt')        = Urbobs(reg,zone,HHObs,'samplewt') ;

*set income equal to total expenditure (no savings)
HHobsInc0(reg,zone,HHobs,urbrur)$HHobsDat(reg,zone,HHObs,urbrur,'hhsize') = HHobsDat(reg,zone,HHObs,urbrur,'totexp') ;
HHobsIncsh0(reg,zone,HHobs,urbrur)$HHobsInc0(reg,zone,HHobs,urbrur)
                 = HHobsInc0(reg,zone,HHobs,urbrur)/sum(HHobsP,HHobsInc0(reg,zone,HHobsP,urbrur) );

HHobsIncPC00(reg,zone,HHobs,urbrur)$HHobsDat(reg,zone,HHObs,urbrur,'hhsize')
                 = HHobsDat(reg,zone,HHObs,urbrur,'totexp')/HHobsDat(reg,zone,HHObs,urbrur,'hhsize') ;

HHobsPCsh0(reg,zone,HHobs,urbrur)$HHobsIncPC00(reg,zone,HHobs,urbrur)
                 = 100*(HHobsDat(reg,zone,HHObs,urbrur,'totexp')*HHobsDat(reg,zone,HHObs,urbrur,'samplewt'))/
                   sum(HHobsP,HHobsDat(reg,zone,HHObsP,urbrur,'totexp')*HHobsDat(reg,zone,HHObsP,urbrur,'samplewt'));

HHobsPCsh0(reg,zone,HHobs,urbrur)$HHobsIncPC00(reg,zone,HHobs,urbrur)
                 = HHobsPCsh0(reg,zone,HHobs,urbrur)/(HHobsDat(reg,zone,HHObs,urbrur,'hhsize')*HHobsDat(reg,zone,HHObs,urbrur,'samplewt')) ;

chkobsIncsh(reg,zone,urbrur)     = sum(HHobs,HHobsDat(reg,zone,HHObs,urbrur,'hhsize')*
                 HHobsDat(reg,zone,HHObs,urbrur,'samplewt')*HHobsPCsh0(reg,zone,HHobs,urbrur));

HHobsPoPZ0(reg,zone,urbrur)      = sum(HHobs$HHobsDat(reg,zone,HHObs,urbrur,'samplewt'),
                 HHobsDat(reg,zone,HHObs,urbrur,'samplewt')*HHobsDat(reg,zone,HHObs,urbrur,'HHsize'));

parameter
chkobsPoPZ0(reg,zone)    zonal pop calc by HHobs data
chkobsPoP0(urbrur)       overall urban and rural pop calc by HHobs data
;

HHobsPoPZ0(reg,zone,urbrur)      = sum(HHobs$HHobsDat(reg,zone,HHObs,urbrur,'samplewt'),
                 HHobsDat(reg,zone,HHObs,urbrur,'samplewt')*HHobsDat(reg,zone,HHObs,urbrur,'HHsize'));

chkobsPoPZ0(reg,zone)            = sum(urbrur,HHobsPoPZ0(reg,zone,urbrur));
chkobsPoP0(urbrur)               = sum((reg,zone),HHobsPoPZ0(reg,zone,urbrur));
display chkobsPoPZ0, chkobsPoP0;

HHobsPoPZdif0(reg,zone,urbrur)$HHobsPoPZ0(reg,zone,urbrur) = HHobsPoPZ0(reg,zone,urbrur)/(1000000*PoPH0(reg,zone,urbrur));
display   HHobsPoPZdif0;
* use the pop calc by Tpop as the correct version for reference
HHobsDat(reg,zone,HHObs,urbrur,'samplewt')$HHobsPoPZdif0(reg,zone,urbrur)
                                 = HHobsDat(reg,zone,HHObs,urbrur,'samplewt')/HHobsPoPZdif0(reg,zone,urbrur) ;

HHobsPoPZ0(reg,zone,urbrur)      = sum(HHobs$HHobsDat(reg,zone,HHObs,urbrur,'samplewt'),
         HHobsDat(reg,zone,HHObs,urbrur,'samplewt')*HHobsDat(reg,zone,HHObs,urbrur,'HHsize'));
chkobsPoPZ0(reg,zone)            = sum(urbrur,HHobsPoPZ0(reg,zone,urbrur));
chkobsPoP0(urbrur)               = sum((reg,zone),HHobsPoPZ0(reg,zone,urbrur));
HHobsPoPZdif0(reg,zone,urbrur)$HHobsPoPZ0(reg,zone,urbrur) = HHobsPoPZ0(reg,zone,urbrur)/(1000000*PoPH0(reg,zone,urbrur));
display chkobsPoPZ0, chkobsPoP0, HHobsPoPZdif0;


parameter
AvgIncomePc(urbrur)        overall average income per capita in US Dollar
AvgIncomePc2(urbrur)       overall average income per capita in Ethiopian Birr
AvgIncomePcAll             overall average income per capita in US Dollar
AvgIncomePcAll2            overall average income per capita in Ethiopian Birr
;

AvgIncomePc(urbrur)  = sum((reg,zone,HHobs),HHobsDat(reg,zone,HHObs,urbrur,'totexp')*HHobsDat(reg,zone,HHObs,urbrur,'samplewt'))/
                       sum((reg,zone,HHobs),HHobsDat(reg,zone,HHObs,urbrur,'hhsize')*HHobsDat(reg,zone,HHObs,urbrur,'samplewt')) ;
AvgIncomePcAll       = sum((reg,zone,HHobs,urbrur),HHobsDat(reg,zone,HHObs,urbrur,'totexp')*HHobsDat(reg,zone,HHObs,urbrur,'samplewt'))/
                       sum((reg,zone,HHobs,urbrur),HHobsDat(reg,zone,HHObs,urbrur,'hhsize')*HHobsDat(reg,zone,HHObs,urbrur,'samplewt')) ;
AvgIncomePc2(urbrur) = 8.746*AvgIncomePc(urbrur) ;
AvgIncomePcAll2      = 8.746*AvgIncomePcAll ;



* ====

Parameter
chkHHIshareZ(reg,zone,urbrur)   should be 1 when add up share of urban and rural
THHIZshare(reg,zone,urbrur)     zonal share of urban or rural in overall urban or rural area
;

chkHHIshareZ(reg,zone,urbrur) = sum(HHS,HHIshareZ0(reg,zone,urbrur,HHS)) ;

display chkHHIshareZ, HHIshareZ0;

THHIZshare(reg,zone,urbrur) = sum(HHS,HHIZ00(reg,zone,urbrur,HHS))/sum((regp,zonep,HHS),HHIZ00(regp,zonep,urbrur,HHS));

display THHIZshare;


* ==== Input: TOTAL supply, area, yield, demand,traded volume
TQS0(c)          = TOTDATA('TQS0',c) ;
TAC0(c)          = TOTDATA('TAC0',c) ;
TYC0(c)          = TOTDATA('TYC0',c) ;
QT0(c)           = TOTDATA('TQM0',c) ;
TQF0(c)          = TOTDATA('TQF0',c) ;
TQL0(c)          = TOTDATA('TQL0',c) ;
TQO0(c)          = TOTDATA('TQO0',c) ;

*==== Input: zonal ouput/area share, multiply total value to get zonal values
Parameter
chkzonearea(c)          check shared area adds up to 100%
chkzoneoutput(c)        check shared ouput adds up to 100%
;

zoneareashare(reg,zone,c)$(zoneoutputshare(reg,zone,c) eq 0)             = 0 ;
zoneareashare(reg,zone,c)$(zoneareashare(reg,zone,c) le 0.00001)         = 0 ;
zoneoutputshare(reg,zone,c)$(zoneoutputshare(reg,zone,c) le 0.00001)     = 0 ;

chkzonearea(c)   = sum((reg,zone), zoneareashare(reg,zone,c) ) ;
chkzoneoutput(c) = sum((reg,zone), zoneoutputshare(reg,zone,c) ) ;
display chkzonearea, chkzoneoutput;

zoneoutputshare(reg,zone,c)$chkzoneoutput(c)                     = zoneoutputshare(reg,zone,c)/chkzoneoutput(c)*100 ;
zoneareashare(reg,zone,c)$(zoneoutputshare(reg,zone,c) eq 0)     = 0 ;
zoneareashare(reg,zone,c)$chkzonearea(c)                         = zoneareashare(reg,zone,c)/chkzonearea(c)*100 ;

chkzonearea(c)   = sum((reg,zone), zoneareashare(reg,zone,c) ) ;
chkzoneoutput(c) = sum((reg,zone), zoneoutputshare(reg,zone,c) ) ;
display chkzonearea, chkzoneoutput;

* total supply of non-import nor export commodities = total food demand + total livestock demand + total other demand
TQS0(NTC)$(QT0(NTC) gt 0) = TQF0(NTC) + TQL0(NTC) + TQO0(NTC) ;

QSZ0(reg,zone,c)  = zoneoutputshare(reg,zone,c)*TQS0(c)/100;
ACZ0(reg,zone,c)  = zoneareashare(reg,zone,c)*TAC0(c)/100 ;

ACZ0(reg,zone,c)$(QSZ0(reg,zone,c) eq 0)         = 0 ;
QSZ0(reg,zone,crop)$(ACZ0(reg,zone,crop) eq 0)   = 0 ;

TAC0(c) = sum((reg,zone),ACZ0(reg,zone,c));
TQS0(c) = sum((reg,zone),QSZ0(reg,zone,c));

TACZ0(reg,zone)          = sum(c,ACZ0(reg,zone,c));

zoneareashare(reg,zone,c)$TAC0(c)        = 100*ACZ0(reg,zone,c)/TAC0(c) ;
zoneoutputshare(reg,zone,c)$TQS0(c)      = 100*QSZ0(reg,zone,c)/TQS0(c) ;

display zoneareashare, zoneoutputshare;

* export parameter 'ACZ0' to excel 'OrigAreas.xls' in tab 'TOTAL'
*$libinclude xldump ACZ0 OrigAreas.xls Total;


*==== Demand and Supply  =============
TQF0(NTC)$QT0(NTC) = TQS0(NTC)- TQL0(NTC) - TQO0(NTC) ;
QT0(NTC)           = 0 ;
QT0(TC)            = TQF0(TC) + TQL0(TC) + TQO0(TC) - TQS0(TC) ;

QM0(c)$(QT0(c) gt 0) = QT0(C);
QE0(c)$(QT0(c) lt 0) = -QT0(C);

QLZ0(reg,zone,c)$sum(lv,QSZ0(reg,zone,lv))       = TQL0(c)*sum(lv,QSZ0(reg,zone,lv))/sum((lv,regp,zonep),QSZ0(regp,zonep,lv)) ;
QLZshare0(reg,zone,c)$sum(lv,QSZ0(reg,zone,lv))  = QLZ0(reg,zone,c)/sum(lv,QSZ0(reg,zone,lv)) ;

QOZ0(reg,zone,c)$QSZ0(reg,zone,c)                = TQO0(c)*QSZ0(reg,zone,c)/sum((regp,zonep),QSZ0(regp,zonep,c)) ;
QOZshare0(reg,zone,c)$QSZ0(reg,zone,c)           = QOZ0(reg,zone,c)/QSZ0(reg,zone,c) ;

display TQS0, QM0, QE0, QLZshare0, QOZshare0;

TQF0(c) =  TQS0(c) + QT0(c) - sum((reg,zone),QLZ0(reg,zone,c) + QOZ0(reg,zone,c)) ;

* use pop to find per capita param.
TQFpc0(c)        = TQF0(c)/Tpop0 ;
TQSpc0(c)        = TQS0(c)/Tpop0 ;

*==== check yield use Demand and Supply
parameter
zeroTQS(c)       zero supply commodity
zeroQF(c)        zero demand food commodity
chkyield(c)      check yield (should =1)
;
zeroTQS(c)$(TQS0(c) eq 0)        = yes;
zeroQF(c)$(TQF0(c) eq 0)         = yes;
chkyield(c)$TAC0(c)              = 1000*(TQS0(c)/TAC0(c))/ TYC0(c) ;
TYC0(c)$TAC0(c)                  = 1000*(TQS0(c)/TAC0(c)) ;

display zeroTQS, zeroQF, chkyield;

chkyield(c)$TAC0(c)              = 1000*(TQS0(c)/TAC0(c))/ TYC0(c) ;
display  chkyield;

*adjust 'nagntrade' and 'nagtrade' food demand values
QFZH0(reg,zone,'rur','nagntrade')$PoPH0(reg,zone,'rur') = incomeH0(reg,zone,'rur') - sum(c,RurDemand(reg,zone,c)) ;
QFZH0(reg,zone,'rur','nagntrade')$(PoPH0(reg,zone,'rur') eq 0) = 0 ;

QFZH0(reg,zone,'rur','nagtrade')$QFZH0(reg,zone,'rur','nagntrade') = 0.2*QFZH0(reg,zone,'rur','nagntrade') ;
QFZH0(reg,zone,'rur','nagntrade') = QFZH0(reg,zone,'rur','nagntrade') - QFZH0(reg,zone,'rur','nagtrade') ;

QFZH0(reg,zone,'urb','nagntrade')$PoPH0(reg,zone,'urb') = incomeH0(reg,zone,'urb') - sum(c,UrbDemand(reg,zone,c)) ;
QFZH0(reg,zone,'urb','nagntrade')$(PoPH0(reg,zone,'urb') eq 0) = 0 ;

QFZH0(reg,zone,'urb','nagtrade')$QFZH0(reg,zone,'urb','nagntrade') = 0.4*QFZH0(reg,zone,'urb','nagntrade') ;
QFZH0(reg,zone,'urb','nagntrade') = QFZH0(reg,zone,'urb','nagntrade') - QFZH0(reg,zone,'urb','nagtrade') ;

parameter
incomeagsh(reg,zone,urbrur)             urban and rural share in each zone over ag income
incomenagsh(reg,zone,urbrur)            urban and rural share in each zone over nag income
incomeagsh2(reg,zone,urbrur)            urban and rural ag income share in each zone over (ag+nag) income
incomenagsh2(reg,zone,urbrur)           urban and rural nag income share in each zone over (ag+nag) income
;
INCOMEag0(reg,zone,'rur')$sum(ag,QSZ0(reg,zone,ag)) = sum(ag,PW0(ag)*(1 + margW0(ag))*QSZ0(reg,zone,ag))/
                                 sum((regp,zonep,ag),PW0(ag)*(1 + margW0(ag))*QSZ0(regp,zonep,ag))*1.3*AgrGDP0 ;

INCOMEag0('AddisAbaba',zone,'urb')  = INCOMEag0('AddisAbaba',zone,'rur') ;
INCOMEag0('AddisAbaba',zone,'rur')  = 0 ;

INCOMEnag0(reg,zone,urbrur)$PoPH0(reg,zone,urbrur) = incomeH0(reg,zone,urbrur) - INCOMEag0(reg,zone,urbrur) ;
INCOMEnag0(reg,zone,urbrur)$(PoPH0(reg,zone,urbrur) eq 0) = 0 ;
INCOMEnag0(reg,zone,'rur')$(PoPH0(reg,zone,'urb') eq 0 and PoPH0(reg,zone,'rur') and incomeH0(reg,zone,'urb') ) =
                  sum(urbrur,incomeH0(reg,zone,urbrur) - INCOMEag0(reg,zone,urbrur)) ;
INCOMEnag0(reg,zone,'urb')$(PoPH0(reg,zone,'urb') and PoPH0(reg,zone,'rur') eq 0 and incomeH0(reg,zone,'rur') ) =
                  sum(urbrur,incomeH0(reg,zone,urbrur) - INCOMEag0(reg,zone,urbrur)) ;
INCOMEnag0(reg,zone,urbrur)$(PoPH0(reg,zone,urbrur) and INCOMEnag0(reg,zone,urbrur) lt 0) = 0.1*INCOMEag0(reg,zone,urbrur) ;

incomeagsh(reg,zone,urbrur)$INCOMEag0(reg,zone,urbrur)   = INCOMEag0(reg,zone,urbrur)/sum(urbrurp,INCOMEag0(reg,zone,urbrurp));
incomenagsh(reg,zone,urbrur)$INCOMEnag0(reg,zone,urbrur) = INCOMEnag0(reg,zone,urbrur)/sum(urbrurp,INCOMEnag0(reg,zone,urbrurp));
incomeagsh2(reg,zone,urbrur)$INCOMEag0(reg,zone,urbrur)  = INCOMEag0(reg,zone,urbrur)/(INCOMEag0(reg,zone,urbrur) + INCOMEnag0(reg,zone,urbrur));
incomenagsh2(reg,zone,urbrur)$INCOMEnag0(reg,zone,urbrur)= INCOMEnag0(reg,zone,urbrur)/(INCOMEag0(reg,zone,urbrur) + INCOMEnag0(reg,zone,urbrur));

parameter
chknegnagincome(reg,zone,urbrur)   check QFZ 'incomenag<0' zones (should not be)
chknegnag(reg,zone,urbrur,c)       check QFZ 'nagtrade'<0 or 'nagntrade'<0 zones (should not be)
GDP_Redef                          redefine GDP based on calculated income valules for all comm (include 'nagtrade' and 'nagntrade')
AgGDP_Redef                        redefine Ag GDP
chkGDP                             ratio of redefined GDP vs original GDP (should not be too different from one)
chkAgGDP                           ratio of redefined AgGDP vs original AgGDP (should not be too different from one)
;

chknegnag(reg,zone,urbrur,'nagntrade')$(QFZH0(reg,zone,urbrur,'nagntrade') lt 0) = QFZH0(reg,zone,urbrur,'nagntrade') ;
chknegnag(reg,zone,urbrur,'nagtrade')$(QFZH0(reg,zone,urbrur,'nagtrade') lt 0)   = QFZH0(reg,zone,urbrur,'nagtrade') ;
chknegnagincome(reg,zone,urbrur)$(INCOMEnag0(reg,zone,urbrur) lt 0)              = INCOMEnag0(reg,zone,urbrur) ;

GDP_Redef   = sum((reg,zone,urbrur),INCOMEnag0(reg,zone,urbrur) + INCOMEag0(reg,zone,urbrur));
AgGDP_Redef = sum((reg,zone,urbrur),INCOMEag0(reg,zone,urbrur));

chkGDP   = GDP_Redef/GDP0 ;
chkAgGDP = AgGDP_Redef/AgrGDP0 ;

display chknegnag, chknegnagincome, GDP_Redef, AgGDP_Redef, chkGDP, chkAgGDP ;

$ontext
INCOMEnag0(reg,zone,'urb') = PopHshare(reg,zone,'urb')*HHnfodexpshare0(reg,zone)*(1.2*GDP0 - 1.2*AgrGDP0) ;
INCOMEnag0(reg,zone,'rur') = (1 - PopHshare(reg,zone,'urb'))*HHnfodexpshare0(reg,zone)*(1.2*GDP0 - 1.2*AgrGDP0) ;
INCOMEnag0(reg,zone,'rur')$(PopHshare(reg,zone,'rur') and INCOMEnag0(reg,zone,'urb') eq 0) =
              HHnfodexpshare0(reg,zone)*(1.2*GDP0 - 1.2*AgrGDP0) ;


chkAgIncome(reg,zone)$INCOMEag0(reg,zone,'rur') = sum(HHS,HHIZ00(reg,zone,'rur',HHS))/INCOMEag0(reg,zone,'rur') ;
chkNAgIncome(reg,zone)$INCOMEnag0(reg,zone,'urb') = sum(HHS,HHIZ00(reg,zone,'urb',HHS))/INCOMEnag0(reg,zone,'urb') ;
display chkAgincome, chkNagincome;

display PopHshare;
$offtext

parameter
chkincomeag          total ag income
chkincomenag         total nag income
;

chkincomeag  = sum((reg,zone,urbrur),INCOMEag0(reg,zone,urbrur) ) ;
chkincomenag = sum((reg,zone,urbrur),INCOMEnag0(reg,zone,urbrur) ) ;

display incomenag0, chkincomeag, chkincomenag;

* redefine GDP
GDPZH0(reg,zone,urbrur)$PopH0(reg,zone,urbrur)    =  INCOMEag0(reg,zone,urbrur) + INCOMEnag0(reg,zone,urbrur) ;
GDPZHsh0(reg,zone,urbrur)$GDPZH0(reg,zone,urbrur) =  GDPZH0(reg,zone,urbrur)/SUM(urbrurp,GDPZH0(reg,zone,urbrurp)) ;

GDPZHPC0(reg,zone,urbrur)$GDPZH0(reg,zone,urbrur) = GDPZH0(reg,zone,urbrur)/PopH0(reg,zone,urbrur) ;

INCOMEagPC0(reg,zone,urbrur)$PopH0(reg,zone,urbrur)  = INCOMEag0(reg,zone,urbrur)/PopH0(reg,zone,urbrur) ;
INCOMEnagPC0(reg,zone,urbrur)$PopH0(reg,zone,urbrur) = INCOMEnag0(reg,zone,urbrur)/PopH0(reg,zone,urbrur) ;

GDPZ0(reg,zone)$sum(urbrur,PopH0(reg,zone,urbrur))   =  sum(urbrur,INCOMEag0(reg,zone,urbrur) + INCOMEnag0(reg,zone,urbrur)) ;
GDPZPC0(reg,zone)$sum(urbrur,PopH0(reg,zone,urbrur)) =  GDPZ0(reg,zone)/sum(urbrur,PopH0(reg,zone,urbrur)) ;
GDPRPC0(reg)$sum((zone,urbrur),PopH0(reg,zone,urbrur))
       =  sum((zone,urbrur),INCOMEag0(reg,zone,urbrur) + INCOMEnag0(reg,zone,urbrur))/sum((zone,urbrur),PopH0(reg,zone,urbrur)) ;
GDPPC0 =  sum((reg,zone,urbrur),INCOMEag0(reg,zone,urbrur) + INCOMEnag0(reg,zone,urbrur))/sum((reg,zone,urbrur),PopH0(reg,zone,urbrur)) ;


QSZ0(reg,zone,nag) = 0 ;
QSZ0(reg,zone,'nagntrade')$sum(urbrur,PopH0(reg,zone,urbrur))   = 0.85*sum(urbrur,INCOMEnag0(reg,zone,urbrur)) ;
QSZ0(city,zone,'nagntrade')$sum(urbrur,PopH0(city,zone,urbrur)) = 0.60*sum(urbrur,INCOMEnag0(city,zone,urbrur)) ;
QSZ0('Benshangul','Kemeshi','nagntrade') = 0.35*sum(urbrur,INCOMEnag0('Benshangul','Kemeshi',urbrur)) ;
QSZ0('AddisAbaba',zone,'nagntrade')$QSZ0('AddisAbaba',zone,'nagntrade') = 2.0*QSZ0('AddisAbaba',zone,'nagntrade') ;
QSZ0(city,zone,'nagtrade')$sum(urbrur,PopH0(city,zone,urbrur)) = 0.5*sum(urbrur,INCOMEnag0(city,zone,urbrur)) ;
QSZ0('AddisAbaba',zone,'nagtrade')$QSZ0('AddisAbaba',zone,'nagntrade') = 0.5*(sum((reg,zonep,urbrur),INCOMEnag0(reg,zonep,urbrur)) -
            sum((reg,zonep,nag),QSZ0(reg,zonep,nag))) + QSZ0('AddisAbaba',zone,'nagtrade') ;

TQS0(nag) = sum((reg,zone),QSZ0(reg,zone,nag));

TQF0(nag) = TQS0(nag) - TQL0(nag) - TQO0(nag) ;

QSZpc0(reg,zone,c)$QSZ0(reg,zone,c) = QSZ0(reg,zone,c)/sum(urbrur,PopH0(reg,zone,urbrur))

display incomenagPC0, QSZpc0, GDPPC0, TQF0;

*balance demand with supply
parameter
negQFZ0(t,reg,zone,c)    check food demand <0 (should not be)
chkTQSBAL(c)             should be zero
;

QFZ0(reg,zone,c) = (CONshare0(reg,zone,c)/100)*TQF0(c) ;

QFZ0(reg,zone,nag) = sum(urbrur,QFZH0(reg,zone,urbrur,nag)) ;

chkTQSBAL(ntc) = sum((reg,zone),QSZ0(reg,zone,ntc)) -
                 sum((reg,zone),QLZ0(reg,zone,ntc) + QOZ0(reg,zone,ntc) + QFZ0(reg,zone,ntc)) ;

chkTQSBAL(mc) = sum((reg,zone),QSZ0(reg,zone,mc)) + QM0(mc) -
                 sum((reg,zone),QLZ0(reg,zone,mc) + QOZ0(reg,zone,mc) + QFZ0(reg,zone,mc)) ;

chkTQSBAL(ec) = sum((reg,zone),QSZ0(reg,zone,ec)) - QE0(ec) -
                 sum((reg,zone),QLZ0(reg,zone,ec) + QOZ0(reg,zone,ec) + QFZ0(reg,zone,ec)) ;

display chkTQSbal, QFZ0 ;

negQFZ0('2003',reg,zone,c)$(QFZ0(reg,zone,c) lt 0) = QFZ0(reg,zone,c) ;

* cal s.t. QSZ(nag) = QFZ(nag) after agg over space
parameter
NEWTQS0(c)
;

NEWTQS0(nag) = sum((reg,zone),QFZ0(reg,zone,nag)) ;
QSZ0(reg,zone,nag) = NEWTQS0(nag)/sum((regp,zonep),QSZ0(regp,zonep,nag))*QSZ0(reg,zone,nag) ;
display QSZ0;
* ===========
TQS0(nag) = sum((reg,zone), QSZ0(reg,zone,nag)) ;
TQF0(nag) = sum((reg,zone),QFZ0(reg,zone,nag)) ;
QM0(nag) = sum((reg,zone),QFZ0(reg,zone,nag) - QSZ0(reg,zone,nag)) ;

chkTQSBAL(ntc) = sum((reg,zone),QSZ0(reg,zone,ntc)) -
                 sum((reg,zone),QLZ0(reg,zone,ntc) + QOZ0(reg,zone,ntc) + QFZ0(reg,zone,ntc)) ;

chkTQSBAL(mc) = sum((reg,zone),QSZ0(reg,zone,mc)) + QM0(mc) -
                 sum((reg,zone),QLZ0(reg,zone,mc) + QOZ0(reg,zone,mc) + QFZ0(reg,zone,mc)) ;

chkTQSBAL(ec) = sum((reg,zone),QSZ0(reg,zone,ec)) - QE0(ec) -
                 sum((reg,zone),QLZ0(reg,zone,ec) + QOZ0(reg,zone,ec) + QFZ0(reg,zone,ec)) ;

display chkTQSbal, negQFZ0, QM0, TQF0 ;
* == all balanced for TQ =======

Parameter
totnag(c)                  total supply for nag
comparIndGDP               total nag-trade supply devided by (1.2*IndGDP0)
comparSerGDP               total nag-ntrade supply divided by (1.2*SerGDP0)
comparNagGDP               total nag supply supply divided by 1.2*(GDP0-AgrGDP0)

DQMZratio(reg,zone,c)      ratio of domestic imported food demand compared to total food demand
DQEZratio(reg,zone,c)      ratio of domestic exported food demand compared to total food demand
;
* GDP calculated using supply
totnag(nag)  = sum((reg,zone),QSZ0(reg,zone,nag));
comparIndGDP = sum((reg,zone),QSZ0(reg,zone,'nagtrade'))/(1.2*IndGDP0);
comparSerGDP = sum((reg,zone),QSZ0(reg,zone,'nagntrade'))/(1.2*SerGDP0);
comparNagGDP = sum((reg,zone,nag),QSZ0(reg,zone,nag))/(1.2*GDP0-1.2*AgrGDP0);

display totnag, comparIndGDP, comparSerGDP, comparNagGDP ;

*using 'QF' same as last 'display' using 'QS' after agg over space
comparIndGDP = sum((reg,zone),QFZ0(reg,zone,'nagtrade'))/(1.2*IndGDP0);
comparSerGDP = sum((reg,zone),QFZ0(reg,zone,'nagntrade'))/(1.2*SerGDP0);
comparNagGDP = sum((reg,zone,nag),QFZ0(reg,zone,nag))/(1.2*GDP0-1.2*AgrGDP0);

display comparIndGDP, comparSerGDP, comparNagGDP ;

* 'D' stands for 'Deficit'
DQTZ0(reg,zone,c)$QFZ0(reg,zone,c)         = QFZ0(reg,zone,c) - (QSZ0(reg,zone,c) - QLZ0(reg,zone,c) - QOZ0(reg,zone,c)) ;
DQMZ0(reg,zone,c)$(DQTZ0(reg,zone,c) gt 0) = DQTZ0(reg,zone,c) ;
DQEZ0(reg,zone,c)$(DQTZ0(reg,zone,c) lt 0) = -DQTZ0(reg,zone,c) ;

DQMZratio(reg,zone,c)$(TQFpc0(c)*sum(urbrur,PopH0(reg,zone,urbrur)) and DQMZ0(reg,zone,c)) =
               100*DQMZ0(reg,zone,c)/(TQFpc0(c)*sum(urbrur,PopH0(reg,zone,urbrur)));
DQEZratio(reg,zone,c)$(QSZ0(reg,zone,c) and DQEZ0(reg,zone,c)) =
               100*DQEZ0(reg,zone,c)/(QSZ0(reg,zone,c) - QLZ0(reg,zone,c) - QOZ0(reg,zone,c)) ;

parameter
zeroQFZ0(reg,zone,c)        check whether there is supply>0 but demand=0 regions  (should not be)(adjusted and checked again)
;
zeroQFZ0(reg,zone,c)$(QFZ0(reg,zone,c) eq 0 and QSZ0(reg,zone,c) gt 0) = QSZ0(reg,zone,c);

display zeroQFZ0;

* QFZ for all 'c'
QFZ0(reg,zone,c)$zeroQFZ0(reg,zone,c) = (QSZ0(reg,zone,c) - QLZ0(reg,zone,c) - QOZ0(reg,zone,c)) ;

* RurUrb Demand calc for 'ag' commodities
* RurDemand in the unit of $
RurDemand(reg,zone,ag)$(zeroQFZ0(reg,zone,ag) and PoPH0(reg,zone,'rur')) = (QSZ0(reg,zone,ag) - QLZ0(reg,zone,ag) - QOZ0(reg,zone,ag)) ;
UrbDemand(reg,zone,ag)$(zeroQFZ0(reg,zone,ag) and PoPH0(reg,zone,'rur') eq 0 and PoPH0(reg,zone,'urb')) =
                                    (QSZ0(reg,zone,ag) - QLZ0(reg,zone,ag) - QOZ0(reg,zone,ag)) ;

* 'fish'
QFZ0(reg,zone,'Fish')$zeroQFZ0(reg,zone,'Fish') = 0.1*(QSZ0(reg,zone,'Fish') - QLZ0(reg,zone,'Fish') - QOZ0(reg,zone,'Fish')) ;

RurDemand(reg,zone,'Fish')$(zeroQFZ0(reg,zone,'Fish') and PoPH0(reg,zone,'rur') and PoPH0(reg,zone,'urb') eq 0) =
                           0.1*(QSZ0(reg,zone,'Fish') - QLZ0(reg,zone,'Fish') - QOZ0(reg,zone,'Fish')) ;
RurDemand(reg,zone,'Fish')$(zeroQFZ0(reg,zone,'Fish') and PoPH0(reg,zone,'rur') and PoPH0(reg,zone,'urb')) =
                           PoPH0(reg,zone,'rur')/sum(urbrur,PoPH0(reg,zone,urbrur))*0.1*
                           (QSZ0(reg,zone,'Fish') - QLZ0(reg,zone,'Fish') - QOZ0(reg,zone,'Fish')) ;
UrbDemand(reg,zone,'Fish')$(zeroQFZ0(reg,zone,'Fish') and PoPH0(reg,zone,'rur') and PoPH0(reg,zone,'urb')) =
                           PoPH0(reg,zone,'urb')/sum(urbrur,PoPH0(reg,zone,urbrur))*0.1*
                           (QSZ0(reg,zone,'Fish') - QLZ0(reg,zone,'Fish') - QOZ0(reg,zone,'Fish')) ;
UrbDemand(reg,zone,'Fish')$(zeroQFZ0(reg,zone,'Fish') and PoPH0(reg,zone,'rur') eq 0 and PoPH0(reg,zone,'urb')) =
                           0.1*(QSZ0(reg,zone,'Fish') - QLZ0(reg,zone,'Fish') - QOZ0(reg,zone,'Fish')) ;
* 'sesame'
QFZ0(reg,zone,'Sesame')$zeroQFZ0(reg,zone,'Sesame') =
        0.1*(QSZ0(reg,zone,'Sesame') - QLZ0(reg,zone,'Sesame') - QOZ0(reg,zone,'Sesame')) ;

RurDemand(reg,zone,'Sesame')$(zeroQFZ0(reg,zone,'Sesame') and PoPH0(reg,zone,'rur') and PoPH0(reg,zone,'urb') eq 0) =
                           0.1*(QSZ0(reg,zone,'Sesame') - QLZ0(reg,zone,'Sesame') - QOZ0(reg,zone,'Sesame')) ;
RurDemand(reg,zone,'Sesame')$(zeroQFZ0(reg,zone,'Sesame') and PoPH0(reg,zone,'rur') and PoPH0(reg,zone,'urb')) =
                           PoPH0(reg,zone,'rur')/sum(urbrur,PoPH0(reg,zone,urbrur))*0.1*
                           (QSZ0(reg,zone,'Sesame') - QLZ0(reg,zone,'Sesame') - QOZ0(reg,zone,'Sesame')) ;
UrbDemand(reg,zone,'Sesame')$(zeroQFZ0(reg,zone,'Sesame') and PoPH0(reg,zone,'rur') and PoPH0(reg,zone,'urb')) =
                           PoPH0(reg,zone,'urb')/sum(urbrur,PoPH0(reg,zone,urbrur))*0.1*
                           (QSZ0(reg,zone,'Sesame') - QLZ0(reg,zone,'Sesame') - QOZ0(reg,zone,'Sesame')) ;
UrbDemand(reg,zone,'Sesame')$(zeroQFZ0(reg,zone,'Sesame') and PoPH0(reg,zone,'rur') eq 0 and PoPH0(reg,zone,'urb')) =
                           0.1*(QSZ0(reg,zone,'Sesame') - QLZ0(reg,zone,'Sesame') - QOZ0(reg,zone,'Sesame')) ;

* 'fish' & 'sesame' at specific zone
QFZ0('Oromia','EastHarerge','Fish')$zeroQFZ0('Oromia','EastHarerge','Fish') =
        0.01*(QSZ0('Oromia','EastHarerge','Fish') - QLZ0('Oromia','EastHarerge','Fish') - QOZ0('Oromia','EastHarerge','Fish')) ;
QFZ0('Oromia','EastHarerge','Sesame')$zeroQFZ0('Oromia','EastHarerge','Sesame') =
        0.01*(QSZ0('Oromia','EastHarerge','Sesame') - QLZ0('Oromia','EastHarerge','Sesame') - QOZ0('Oromia','EastHarerge','Sesame')) ;

RurDemand('Oromia','EastHarerge','Fish')$(zeroQFZ0('Oromia','EastHarerge','Fish') and
                PoPH0('Oromia','EastHarerge','rur') and PoPH0('Oromia','EastHarerge','urb') eq 0) =
                           0.01*(QSZ0('Oromia','EastHarerge','Fish') - QLZ0('Oromia','EastHarerge','Fish') -
                                  QOZ0('Oromia','EastHarerge','Fish')) ;
RurDemand('Oromia','EastHarerge','Fish')$(zeroQFZ0('Oromia','EastHarerge','Fish') and
                PoPH0('Oromia','EastHarerge','rur') and PoPH0('Oromia','EastHarerge','urb')) =
                           PoPH0('Oromia','EastHarerge','rur')/sum(urbrur,PoPH0('Oromia','EastHarerge',urbrur))*0.01*
                           (QSZ0('Oromia','EastHarerge','Fish') - QLZ0('Oromia','EastHarerge','Fish') -
                                QOZ0('Oromia','EastHarerge','Fish')) ;
UrbDemand('Oromia','EastHarerge','Fish')$(zeroQFZ0('Oromia','EastHarerge','Fish') and
                PoPH0('Oromia','EastHarerge','rur') and PoPH0('Oromia','EastHarerge','urb')) =
                           PoPH0('Oromia','EastHarerge','urb')/sum(urbrur,PoPH0('Oromia','EastHarerge',urbrur))*0.01*
                           (QSZ0('Oromia','EastHarerge','Fish') - QLZ0('Oromia','EastHarerge','Fish') -
                                QOZ0('Oromia','EastHarerge','Fish')) ;
UrbDemand('Oromia','EastHarerge','Fish')$(zeroQFZ0('Oromia','EastHarerge','Fish') and
                PoPH0('Oromia','EastHarerge','rur') eq 0 and PoPH0('Oromia','EastHarerge','urb')) =
                           0.01*(QSZ0('Oromia','EastHarerge','Fish') - QLZ0('Oromia','EastHarerge','Fish') -
                                QOZ0('Oromia','EastHarerge','Fish')) ;

* ---
RurDemand('Oromia','EastHarerge','Sesame')$(zeroQFZ0('Oromia','EastHarerge','Sesame') and
                PoPH0('Oromia','EastHarerge','rur') and PoPH0('Oromia','EastHarerge','urb') eq 0) =
                           0.01*(QSZ0('Oromia','EastHarerge','Sesame') - QLZ0('Oromia','EastHarerge','Sesame') -
                                QOZ0('Oromia','EastHarerge','Sesame')) ;
RurDemand('Oromia','EastHarerge','Sesame')$(zeroQFZ0('Oromia','EastHarerge','Sesame') and
                PoPH0('Oromia','EastHarerge','rur') and PoPH0('Oromia','EastHarerge','urb')) =
                           PoPH0('Oromia','EastHarerge','rur')/sum(urbrur,PoPH0('Oromia','EastHarerge',urbrur))*0.01*
                           (QSZ0('Oromia','EastHarerge','Sesame') - QLZ0('Oromia','EastHarerge','Sesame') -
                                QOZ0('Oromia','EastHarerge','Sesame')) ;
UrbDemand('Oromia','EastHarerge','Sesame')$(zeroQFZ0('Oromia','EastHarerge','Sesame') and
                PoPH0('Oromia','EastHarerge','rur') and PoPH0('Oromia','EastHarerge','urb')) =
                           PoPH0('Oromia','EastHarerge','urb')/sum(urbrur,PoPH0('Oromia','EastHarerge',urbrur))*0.01*
                           (QSZ0('Oromia','EastHarerge','Sesame') - QLZ0('Oromia','EastHarerge','Sesame') -
                                QOZ0('Oromia','EastHarerge','Sesame')) ;
UrbDemand('Oromia','EastHarerge','Sesame')$(zeroQFZ0('Oromia','EastHarerge','Sesame') and
                PoPH0('Oromia','EastHarerge','rur') eq 0 and PoPH0('Oromia','EastHarerge','urb')) =
                           0.01*(QSZ0('Oromia','EastHarerge','Sesame') - QLZ0('Oromia','EastHarerge','Sesame') -
                                QOZ0('Oromia','EastHarerge','Sesame')) ;

* 'fish' 'MeatOther' 'sesame' at specific zones
QFZ0('Southern','YemWereda','fish') = 0.5*QFZ0('Southern','YemWereda','fish') ;
QFZ0('Oromia','Arsi','MeatOther') = 0.5*(QFZ0('Oromia','Arsi','MeatOther') - 2*0.346625) ;
QFZ0('Gambella','Gambela2','Sesame') = 0.5*QFZ0('Gambella','Gambela2','Sesame') ;

QFZH0('Southern','YemWereda',urbrur,'fish') = 0.5*QFZH0('Southern','YemWereda',urbrur,'fish') ;
QFZH0('Oromia','Arsi',urbrur,'MeatOther') = 0.5*(QFZH0('Oromia','Arsi',urbrur,'MeatOther') - 0.346625) ;
*QFZH0('Oromia','Arsi','rur','MeatOther') = 0.5*QFZH0('Oromia','Arsi','rur','MeatOther') ;
*QFZH0('Oromia','Arsi','urb','MeatOther') = QFZ0('Oromia','Arsi','MeatOther') - QFZH0('Oromia','Arsi','rur','MeatOther') ;

QFZH0('Gambella','Gambela2',urbrur,'Sesame') = 0.5*QFZH0('Gambella','Gambela2',urbrur,'Sesame') ;

* 'cottonLint'
QFZ0(reg,zone,'cottonLint') = 0 ;
QFZH0(reg,zone,urbrur,'cottonLint') = 0 ;

QLZ0(reg,zone,c)$(QFZ0(reg,zone,c) eq 0 and QSZ0(reg,zone,c) eq 0) = 0 ;
QOZ0(reg,zone,c)$(QFZ0(reg,zone,c) eq 0 and QSZ0(reg,zone,c) eq 0) = 0 ;

* addis ababa for ntc, multiply by 0.5 because there are two zones in addis ababa, summed
QFZ0('AddisAbaba',zone,ntc)$(DQMZratio('AddisAbaba',zone,ntc) gt 0) =
                 0.5*sum((reg,zonep),QSZ0(reg,zonep,ntc) - QLZ0(reg,zonep,ntc) - QOZ0(reg,zonep,ntc)
                                          - QFZ0(reg,zonep,ntc)) + QFZ0('AddisAbaba',zone,ntc) ;
QFZ0('AddisAbaba',zone,mc)$(DQMZratio('AddisAbaba',zone,mc) gt 0) =
                 0.5*(sum((reg,zonep),QSZ0(reg,zonep,mc)) + QM0(mc) -
                                               sum((reg,zonep),QLZ0(reg,zonep,mc) + QOZ0(reg,zonep,mc)+ QFZ0(reg,zonep,mc)))
                                          + QFZ0('AddisAbaba',zone,mc) ;
QFZ0('AddisAbaba',zone,ec)$(DQMZratio('AddisAbaba',zone,ec) gt 0) =
                 0.5*(sum((reg,zonep),QSZ0(reg,zonep,ec)) - QE0(ec) -
                                               sum((reg,zonep),QLZ0(reg,zonep,ec) + QOZ0(reg,zonep,ec)+ QFZ0(reg,zonep,ec)))
                                          + QFZ0('AddisAbaba',zone,ec) ;
QFZH0('AddisAbaba',zone,'urb',ntc)$(DQMZratio('AddisAbaba',zone,ntc) gt 0) =
                 0.5*sum((reg,zonep),QSZ0(reg,zonep,ntc) - QLZ0(reg,zonep,ntc) - QOZ0(reg,zonep,ntc)
                                          - QFZ0(reg,zonep,ntc)) + QFZ0('AddisAbaba',zone,ntc) ;
QFZH0('AddisAbaba',zone,'urb',mc)$(DQMZratio('AddisAbaba',zone,mc) gt 0) =
                 0.5*(sum((reg,zonep),QSZ0(reg,zonep,mc)) + QM0(mc) -
                                               sum((reg,zonep),QLZ0(reg,zonep,mc) + QOZ0(reg,zonep,mc)+ QFZ0(reg,zonep,mc)))
                                          + QFZ0('AddisAbaba',zone,mc) ;
QFZH0('AddisAbaba',zone,'urb',ec)$(DQMZratio('AddisAbaba',zone,ec) gt 0) =
                 0.5*(sum((reg,zonep),QSZ0(reg,zonep,ec)) - QE0(ec) -
                                               sum((reg,zonep),QLZ0(reg,zonep,ec) + QOZ0(reg,zonep,ec)+ QFZ0(reg,zonep,ec)))
                                          + QFZ0('AddisAbaba',zone,ec) ;
* 'MeatOther' for specific zone
QFZ0('Oromia','Arsi','MeatOther') =
         sum((reg,zonep),QSZ0(reg,zonep,'MeatOther') - QLZ0(reg,zonep,'MeatOther') - QOZ0(reg,zonep,'MeatOther')
                                          - QFZ0(reg,zonep,'MeatOther')) + QFZ0('Oromia','Arsi','MeatOther') ;

parameter
zeroQFZH(reg,zone,c)      food demand >0 pop>0 rural and urban expenditure on ag commodity is zero (should not be)
;
zeroQFZH(reg,zone,ag)$(QFZ0(reg,zone,ag) and PoPH0(reg,zone,'rur')
                                         and (RurDemand(reg,zone,ag) + UrbDemand(reg,zone,ag)) eq 0) = yes ;
display zeroQFZH;

QFZH0(reg,zone,'rur',ag)$(QFZ0(reg,zone,ag) and PoPH0(reg,zone,'rur')) =
                QFZ0(reg,zone,ag)*RurDemand(reg,zone,ag)/(RurDemand(reg,zone,ag) + UrbDemand(reg,zone,ag)) ;
QFZH0(reg,zone,'rur',ag)$(PoPH0(reg,zone,'rur') eq 0) = 0 ;
QFZH0(reg,zone,'rur','rice') = 0 ;

QFZH0(reg,zone,'urb',ag)$(QFZ0(reg,zone,ag) and PoPH0(reg,zone,'urb'))  = QFZ0(reg,zone,ag) - QFZH0(reg,zone,'rur',ag) ;
QFZH0(reg,zone,'urb',ag)$(QFZH0(reg,zone,'urb',ag) lt 0 and PoPH0(reg,zone,'urb'))  =
                                0.1*PoPH0(reg,zone,'urb')/sum(urbrur,PoPH0(reg,zone,urbrur))*QFZH0(reg,zone,'rur',ag) ;
QFZH0(reg,zone,'urb',ag)$(PoPH0(reg,zone,'urb') eq 0)  = 0 ;

QFZH0(reg,zone,'rur',ag)$(QFZ0(reg,zone,ag) and PoPH0(reg,zone,'rur'))  = QFZ0(reg,zone,ag) - QFZH0(reg,zone,'urb',ag) ;

QFZH0('AddisAbaba',zone,'urb',ntc)$(DQMZratio('AddisAbaba',zone,ntc) gt 0) =
                 0.5*sum((reg,zonep),QSZ0(reg,zonep,ntc) - QLZ0(reg,zonep,ntc) - QOZ0(reg,zonep,ntc)
                         - sum(urbrur,QFZH0(reg,zonep,urbrur,ntc))) + QFZH0('AddisAbaba',zone,'urb',ntc) ;
QFZH0('AddisAbaba',zone,'urb',mc)$(DQMZratio('AddisAbaba',zone,mc) gt 0) =
                 0.5*(sum((reg,zonep),QSZ0(reg,zonep,mc)) + QM0(mc) -
                         sum((reg,zonep),QLZ0(reg,zonep,mc) + QOZ0(reg,zonep,mc)+ sum(urbrur,QFZH0(reg,zonep,urbrur,mc))))
                                          + QFZH0('AddisAbaba',zone,'urb',mc) ;
QFZH0('AddisAbaba',zone,'urb',ec)$(DQMZratio('AddisAbaba',zone,ec) gt 0) =
                 0.5*(sum((reg,zonep),QSZ0(reg,zonep,ec)) - QE0(ec) -
                             sum((reg,zonep),QLZ0(reg,zonep,ec) + QOZ0(reg,zonep,ec)+ sum(urbrur,QFZH0(reg,zonep,urbrur,ec))))
                                          + QFZH0('AddisAbaba',zone,'urb',ec) ;

QFZ0(reg,zone,c) =  sum(urbrur,QFZH0(reg,zone,urbrur,c));

QFZHsh0(reg,zone,urbrur,c)$QFZ0(reg,zone,c) = QFZH0(reg,zone,urbrur,c)/QFZ0(reg,zone,c) ;

parameter
chkdifQFZ(reg,zone,c)     check sum QF over urbrur should equal to QFZ (should show All-0)
;
chkdifQFZ(reg,zone,c)$(sum(urbrur,QFZH0(reg,zone,urbrur,c)) - QFZ0(reg,zone,c) ne 0) =
                sum(urbrur,QFZH0(reg,zone,urbrur,c)) - QFZ0(reg,zone,c) ;

display chkdifQFZ;

chkTQSBAL(ntc) = sum((reg,zone),QSZ0(reg,zone,ntc)) -
                 sum((reg,zone),QLZ0(reg,zone,ntc) + QOZ0(reg,zone,ntc) + QFZ0(reg,zone,ntc)) ;

chkTQSBAL(mc) = sum((reg,zone),QSZ0(reg,zone,mc)) + QM0(mc) -
                 sum((reg,zone),QLZ0(reg,zone,mc) + QOZ0(reg,zone,mc) + QFZ0(reg,zone,mc)) ;

chkTQSBAL(ec) = sum((reg,zone),QSZ0(reg,zone,ec)) - QE0(ec) -
                 sum((reg,zone),QLZ0(reg,zone,ec) + QOZ0(reg,zone,ec) + QFZ0(reg,zone,ec)) ;

display chkTQSbal;

TQF0(c) = sum((reg,zone),QFZ0(reg,zone,c)) ;

QDZ0(reg,zone,c) = 0 ;
QDZ0(reg,zone,c) = QFZ0(reg,zone,c)  + QLZ0(reg,zone,c)  + QOZ0(reg,zone,c) ;

 DQTZ0(reg,zone,c)  = 0 ;
 DQEZ0(reg,zone,c)  = 0 ;
 DQMZ0(reg,zone,c)  = 0 ;
 DQTZ0(reg,zone,c)  = QDZ0(reg,zone,c) - QSZ0(reg,zone,c) ;
 DQMZ0(reg,zone,c)$(DQTZ0(reg,zone,c) gt 0) =   DQTZ0(reg,zone,c) ;
 DQEZ0(reg,zone,c)$(DQTZ0(reg,zone,c) lt 0) =  -DQTZ0(reg,zone,c) ;

display TQF0, DQTZ0 ;

* ===== gap & margin
*== 1 US$ = 8.746 Birr
* EXR0 = 8.746 ;
 EXR0 = 1 ;

 PW0(c)  = 1.0*PW0(c) ;
* PW0(ag)  = 0.8*PW0(ag) ;

 PW0(nag) =  1000 ;
* PW0('nagtrade') =  500 ;
* PW0('nagntrade') =  300 ;


 PW0('maize') =  0.7*PW0('maize') ;
 PW0(lv) =  1.12*PW0(lv) ;

$ontext
 margW0(c)      = 0.30;
 margW0(mc)    = 0.20;
 margW0(ec)    = 0.20;
 margW0(ntc)    = 0.20;
 margW0('BovineMeat') = 0.15;
 margW0('Mutton_GoatMeat') = 0.15;
* margW0(cereal)$ntc(cereal)    = 0.60;
* margW0('Enset')  = 0.60;
* margW0('SweetPotatoes')  = 0.60;
* margW0('vegetablesOther')  = 0.60;
 margW0('maize')  = 0.10;
 margW0('wheat')  = 0.15;
 margW0('rice')   = 0.20;
$offtext

 margW0(c)   = 1.0*margW0(c) ;
 margW0(mc)  = 0.5*margW0(mc) ;

 margW0(nag)     = 0.20;

 margD0(c)       = 0.25 ;
 margD0(nag)     = 0.0 ;
* all = zero. income = supply, no marg between overall consumer price and producer price
 margD0(c)       = 0.0 ;

 margW(c)      =  margW0(c) ;
 margD(c)      =  margD0(c) ;

 margZ0(reg,zone,c)    = domain_var0(reg,zone,'MKT_MEAN')/100;
 margZ0(reg,zone,nag)$popZ0(reg,zone)  = 0.20;
 margZ0(reg,zone,c)$(DQMZ0(reg,zone,c) and margZ0(reg,zone,c) lt 0.6)   = 0.60;
 margZ0(reg,zone,c)$(DQEZ0(reg,zone,c) and margZ0(reg,zone,c) lt 0.6)   = 0.60;


* gap < margin , gap is the price variablity in each zone with overall reference price PC(c)
gapZ0(reg,zone,c)$(DQTZ0(reg,zone,c) ge 0) = 0.5*margZ0(reg,zone,c);
gapZ0(reg,zone,c)$(DQTZ0(reg,zone,c) lt 0) = -0.5*margZ0(reg,zone,c);

gapZ0(reg,zone,'nagntrade') = 0;
margZ0(reg,zone,c) = 0 ;

display DQMZ0, DQEZ0, gapz0 ;

 PWM0(c) = PW0(c)*(1 +  margW0(c) );
 PWE0(c) = PW0(c)*(1 -  margW0(c) );
* PWE0(ntc) = PW0(ntc)*(1 -  1.0*margW0(ntc) );

 PWE(c) = PWE0(c) ;
 PWM(c) = PWM0(c) ;
*ying5 =========
*PP0(c) = 1;
*PC0(c) = PP0(c);
* =============
 PP0(EC)         =  EXR0*PWE0(EC)*(1 - margW0(EC));
 PC0(EC)         =  PP0(EC)*(1 + margD0(EC)) ;
 PC0(MC)         =  EXR0*PWM0(MC)*(1 + margW0(MC));
 PP0(MC)         =  PC0(MC)/(1 + margD0(MC));

 PP0(NTC)         = EXR0*PWM0(NTC) ;
* PP0(NTC)         = EXR0*PW0(NTC) ;
 PP0(C)$(QM0(c) eq 0 and QE0(c) eq 0 and not NTC(c))   = EXR0*PWM0(c) ;
 PC0(NTC)         =  PP0(NTC)*(1 + margD0(NTC));
 PC0(C)$(QM0(c) eq 0 and QE0(c) eq 0)   =  PP0(C)*(1 + margD0(C));

 QSZ0(reg,zone,nag) = QSZ0(reg,zone,nag)/(2*PC0(nag)/PW0(nag)) ;
 QFZH0(reg,zone,urbrur,nag) = QFZH0(reg,zone,urbrur,nag)/(2*PC0(nag)/PW0(nag)) ;
* QSZ0(reg,zone,nag) = QSZ0(reg,zone,nag)/(PC0(nag)/PW0(nag)) ;
* QFZH0(reg,zone,urbrur,nag) = QFZH0(reg,zone,urbrur,nag)/(PC0(nag)/PW0(nag)) ;
 QFZ0(reg,zone,nag) =  sum(urbrur, QFZH0(reg,zone,urbrur,nag));
* QFZ0(reg,zone,c) =  sum(urbrur, QFZH0(reg,zone,urbrur,c));
* QFZ0(reg,zone,nag) = QFZ0(reg,zone,nag)/(PC0(nag)/PW0(nag)) ;
* QSZ0(reg,zone,nag) = QSZ0(reg,zone,nag)/(PC0(nag)/PW0(nag)) ;

* PCZ0(reg,zone,c)$(QSZ0(reg,zone,c) or QFZ0(reg,zone,c)) = PC0(c) ;

* margin/gap is percentage
 PCZ0(reg,zone,c)$(QSZ0(reg,zone,c) or QFZ0(reg,zone,c)) = (1 + gapZ0(reg,zone,c))*PC0(c) ;
 PPZ0(reg,zone,'nagntrade')$(QSZ0(reg,zone,'nagntrade') or QFZ0(reg,zone,'nagntrade')) =
               PCZ0(reg,zone,'nagntrade')/(1 + margZ0(reg,zone,'nagntrade') ) ;

* margin/PP, use nagntrade PPZ as reference price / numeraire
 margZ0(reg,zone,c)$(QSZ0(reg,zone,c) or QFZ0(reg,zone,c)) = margZ0(reg,zone,c)/PPZ0(reg,zone,'nagntrade') ;
 margZ(reg,zone,c)  =  margZ0(reg,zone,c)  ;

* gapZ0(reg,zone,c)$(QSZ0(reg,zone,c) or QFZ0(reg,zone,c)) = gapZ0(reg,zone,c)/PPZ0(reg,zone,'nagntrade') ;

 PPZ0(reg,zone,c)$(QSZ0(reg,zone,c) or QFZ0(reg,zone,c))  =
          PCZ0(reg,zone,c)/(1 + PPZ0(reg,zone,'nagntrade')*margZ0(reg,zone,c) ) ;


*QFZ0('AddisAbaba',zone,nag)$(DQMZratio('AddisAbaba',zone,nag) gt 0) =
*                 0.5*sum((reg,zonep),QSZ0(reg,zonep,nag) - QLZ0(reg,zonep,nag) - QOZ0(reg,zonep,nag)
*                                          - QFZ0(reg,zonep,nag)) + QFZ0('AddisAbaba',zone,nag) ;

 gapZ0(reg,zone,c)$(QSZ0(reg,zone,c) or QFZ0(reg,zone,c))  =  gapZ0(reg,zone,c)/PPZ0(reg,zone,'nagntrade')  ;
 gapZ(reg,zone,c) =  gapZ0(reg,zone,c);
 gapZ2(reg,zone,c) =  gapZ0(reg,zone,c);
 PCZ0(reg,zone,c)$(QSZ0(reg,zone,c) or QFZ0(reg,zone,c)) = (1 + gapZ0(reg,zone,c)*PPZ0(reg,zone,'nagntrade'))*PC0(c) ;

 display  pcz0;

* margD0(c)      =  margD0(c)/(sum((reg,zone),QSZ0(reg,zone,'nagntrade')*PPZ0(reg,zone,'nagntrade'))/
*                             sum((reg,zone),QSZ0(reg,zone,'nagntrade')) );

 margD(c)      =  margD0(c) ;
 display margw, margD;


* ying ======================================
parameter
tempPNAG(reg,zone)            check PPZ'nagntrade'
chkPCZ0(reg,zone,c)           should be 0
chkmargz(reg,zone,c)          check zonal margin between consumer and producer price
chkmargw(c)                   check word margin between PC(c) and PP(c)
negQFZH0(reg,zone,urbrur,c)   food demand <0 (should not be)
;

tempPNAG(reg,zone) = PPZ0(reg,zone,'nagntrade') ;
display tempPNAG;

negQFZH0(reg,zone,urbrur,c)$(QFZH0(reg,zone,urbrur,c) lt 0) = QFZH0(reg,zone,urbrur,c) ;
display negQFZH0  ;
*display QFZH0;

*QFZHsh0(reg,zone,urbrur,c)$QFZ0(reg,zone,c) = QFZH0(reg,zone,urbrur,c)/QFZ0(reg,zone,c) ;
*QFZH0(reg,zone,urbrur,c)$QFZHsh0(reg,zone,urbrur,c) = QFZHsh0(reg,zone,urbrur,c)*QFZ0(reg,zone,c) ;

zeroQFZ0(reg,zone,c)$(QSZ0(reg,zone,c) gt 0 and QFZ0(reg,zone,c) eq 0) = yes ;

QFZHpc0(reg,zone,urbrur,c)$QFZH0(reg,zone,urbrur,c) = QFZH0(reg,zone,urbrur,c)/(1000*PopH0(reg,zone,urbrur)) ;
*QFZ0(reg,zone,c) = sum(urbrur,QFZHpc0(reg,zone,urbrur,c)*PopH0(reg,zone,urbrur)) ;
QFZpc0(reg,zone,c)$QFZ0(reg,zone,c) = sum(urbrur,QFZH0(reg,zone,urbrur,c))/sum(urbrur,1000*PopH0(reg,zone,urbrur)) ;

chkmargz(reg,zone,c)$PPZ0(reg,zone,c) = PCZ0(reg,zone,c)/PPZ0(reg,zone,c) - 1;
chkmargw(c)$margW0(c) = PC0(c)/PP0(c) - 1;

chkPCZ0(reg,zone,c)$(QSZ0(reg,zone,c) or QFZ0(reg,zone,c)) = PPZ0(reg,zone,c) -
                PCZ0(reg,zone,c)/(1 + PPZ0(reg,zone,'nagntrade')*margZ0(reg,zone,c) ) ;

display zeroQFZ0, chkmargw, chkmargz, chkPCZ0;

parameter
comparPCZ(reg,zone,c)            ratio of PCZ to PWM for zonal deficit commodities (>1 for import c)
comparPPZ(reg,zone,c)            ratio of PPZ to PWE for zonal deficit commodities (>1 for import c)
comparPCZ2(reg,zone,c)           ratio of PCZ to PWM for zonal surplus commodities (<1 for export c)
comparPPZ2(reg,zone,c)           ratio of PPZ to PWE for zonal surplus commodities (<1 for export c)
difPWME(c)                       difference of PWM-PWE
;
 PPAVGR0(reg,c)$sum(zone,QSZ0(reg,zone,c)) = sum(zone,PPZ0(reg,zone,c)*QSZ0(reg,zone,c))/
                                    sum(zone,QSZ0(reg,zone,c)) ;
 PCAVGR0(reg,c)$sum(zone,QFZ0(reg,zone,c)) = sum(zone$QFZ0(reg,zone,c),PCZ0(reg,zone,c)*QFZ0(reg,zone,c))/
                                    sum(zone$QFZ0(reg,zone,c),QFZ0(reg,zone,c)) ;
 PPAVG0(c)$sum((reg,zone),QSZ0(reg,zone,c)) = sum((reg,zone)$QSZ0(reg,zone,c),PPZ0(reg,zone,c)*QSZ0(reg,zone,c))/
                                    sum((reg,zone)$QSZ0(reg,zone,c),QSZ0(reg,zone,c)) ;
 PCAVG0(c)$sum((reg,zone),QFZ0(reg,zone,c)) = sum((reg,zone)$QFZ0(reg,zone,c),PCZ0(reg,zone,c)*QFZ0(reg,zone,c))/
                                    sum((reg,zone)$QFZ0(reg,zone,c),QFZ0(reg,zone,c)) ;

comparPCZ(reg,zone,c)$DQMZ0(reg,zone,c)  = PCZ0(reg,zone,c)/PWM0(c) ;
comparPCZ2(reg,zone,c)$DQEZ0(reg,zone,c) = PCZ0(reg,zone,c)/PWM0(c) ;

comparPPZ(reg,zone,c)$DQMZ0(reg,zone,c)  = PPZ0(reg,zone,c)/PWE0(c) ;
comparPPZ2(reg,zone,c)$DQEZ0(reg,zone,c) = PPZ0(reg,zone,c)/PWE0(c) ;

totmargz0(reg,zone)$sum(c,QFZ0(reg,zone,c)) =
      (sum(c$QFZ0(reg,zone,c),(PCZ0(reg,zone,c) -
*           PPZ0(reg,zone,c))*QFZ0(reg,zone,c))  )/PPZ0(reg,zone,'nagntrade') ;
           PPZ0(reg,zone,c))*QFZ0(reg,zone,c))  ) ;
difPWME(c) = PWM0(c) - PWE(c);
display comparPCZ, comparPPZ, comparPCZ2, comparPPZ2, difPWME;

parameter
chkQSR0(reg,c)        check regional QS
chkQS0(c)             check total QS
;

chkQSR0(reg,c) = sum(zone,QSZ0(reg,zone,c));
chkQS0(c)      = sum((reg,zone),QSZ0(reg,zone,c));

display PP0, PC0, totmargz0, chkQSR0, chkQS0, PPAVGR0, PPAVG0, QSZ0, PPZ0, PCZ0;

*QFZ0(reg,zone,'nagntrade')$(QFZ0(reg,zone,'nagntrade') - totmargz0(reg,zone) gt 0) = QFZ0(reg,zone,'nagntrade') - totmargz0(reg,zone) ;
*QFZ0(reg,zone,'nagntrade')$(QFZ0(reg,zone,'nagntrade') - totmargz0(reg,zone) lt 0) = QFZ0(reg,zone,'nagntrade')  ;

QDZ0(reg,zone,c) = QFZ0(reg,zone,c)  + QLZ0(reg,zone,c)  + QOZ0(reg,zone,c) ;

 DQTZ0(reg,zone,c)                          =  QDZ0(reg,zone,c) - QSZ0(reg,zone,c) ;
 DQMZ0(reg,zone,c)$(DQTZ0(reg,zone,c) gt 0) =  DQTZ0(reg,zone,c) ;
 DQEZ0(reg,zone,c)$(DQTZ0(reg,zone,c) lt 0) =  -DQTZ0(reg,zone,c) ;

TQS0(c) = sum((reg,zone),QSZ0(reg,zone,c)) ;
TQF0(c) = sum((reg,zone),QFZ0(reg,zone,c)) ;
TQL0(c) = sum((reg,zone),QLZ0(reg,zone,c)) ;
TQO0(c) = sum((reg,zone),QOZ0(reg,zone,c)) ;
TQD0(c) = sum((reg,zone),QDZ0(reg,zone,c)) ;
QT0(c)  = TQD0(c) - TQS0(c) ;
QM0(c)$(QT0(c) gt 0) = QT0(c) ;
QE0(c)$(QT0(c) lt 0) = -QT0(c) ;

display QT0;

QLZ0(reg,zone,c)$sum(lv,QSZ0(reg,zone,lv))      = TQL0(c)*sum(lv,QSZ0(reg,zone,lv))/sum((lv,regp,zonep),QSZ0(regp,zonep,lv)) ;
QLZshare0(reg,zone,c)$sum(lv,QSZ0(reg,zone,lv)) = PCZ0(reg,zone,c)*QLZ0(reg,zone,c)/sum(lv,QSZ0(reg,zone,lv)) ;

QOZ0(reg,zone,c)$QSZ0(reg,zone,c)      = TQO0(c)*QSZ0(reg,zone,c)/sum((regp,zonep),QSZ0(regp,zonep,c)) ;
QOZshare0(reg,zone,c)$QSZ0(reg,zone,c) = PCZ0(reg,zone,c)*QOZ0(reg,zone,c)/QSZ0(reg,zone,c) ;

QLZshare(reg,zone,c) = QLZshare0(reg,zone,c) ;
QOZshare(reg,zone,c) = QOZshare0(reg,zone,c) ;

parameter
VTQS0(c)       total volum2 of supply in $
VTQF0(c)       total volume of food demand in $
chkIncomeBAL(reg,zone)
;
VTQS0(c) =  sum((reg,zone),PPZ0(reg,zone,c)*QSZ0(reg,zone,c));
VTQF0(c) =  sum((reg,zone),PCZ0(reg,zone,c)*QFZ0(reg,zone,c));

display VTQF0, VTQS0 ;

negQFZ0(t,reg,zone,c)$(QFZ0(reg,zone,c) lt 0) = QFZ0(reg,zone,c) ;
display negQFZ0;

PopH(reg,zone,urbrur) = PopH0(reg,zone,urbrur) ;
PopHShare0(reg,zone,urbrur)$PopH(reg,zone,urbrur) = PopH(reg,zone,urbrur)/sum(urbrurp,PopH(reg,zone,urbrurp)) ;
PopHShare(reg,zone,urbrur)= PopHShare0(reg,zone,urbrur) ;
display chkTQSBAL, QFZ0, QFZpc0, DQTZ0, poph0 ;

ownareashare(reg,zone,c)$ACZ0(reg,zone,c) = 100*ACZ0(reg,zone,c)/sum(cp,ACZ0(reg,zone,cp)) ;
ownoutputshare(reg,zone,c)$QSZ0(reg,zone,c) = 100*QSZ0(reg,zone,c)/sum(cp,QSZ0(reg,zone,cp)) ;


 EXPENDZ0(reg,zone) = sum(c,PCZ0(reg,zone,c)*QFZ0(reg,zone,c));
 EXPENDZH0(reg,zone,urbrur) = sum(c,PCZ0(reg,zone,c)*QFZH0(reg,zone,urbrur,c));

 GDPZ0(reg,zone) = sum(c,PPZ0(reg,zone,c)*QSZ0(reg,zone,c));

 GDPZH0(reg,zone,urbrur)$GDPZ0(reg,zone)  = incomeagsh(reg,zone,urbrur)*sum(ag,PPZ0(reg,zone,ag)*QSZ0(reg,zone,ag)) +
                             incomenagsh(reg,zone,urbrur)*sum(nag,PPZ0(reg,zone,nag)*QSZ0(reg,zone,nag));
 GDPZHsh0(reg,zone,urbrur)$GDPZH0(reg,zone,urbrur) =  GDPZH0(reg,zone,urbrur)/SUM(urbrurp,GDPZH0(reg,zone,urbrurp)) ;

 GDPZ0(reg,zone) = sum(urbrur,GDPZH0(reg,zone,urbrur)) ;

 EXPENDR0(reg) = sum(zone,EXPENDZ0(reg,zone));
 GDPR0(reg) = sum(zone,GDPZ0(reg,zone));

 EXPENDZpc0(reg,zone)$EXPENDZ0(reg,zone) = EXPENDZ0(reg,zone)/(1000*sum(urbrur,PopH0(reg,zone,urbrur)))  ;
 EXPENDZHpc0(reg,zone,urbrur)$EXPENDZH0(reg,zone,urbrur) = EXPENDZH0(reg,zone,urbrur)/(1000*PopH0(reg,zone,urbrur))  ;

 GDPZpc0(reg,zone)$GDPZ0(reg,zone) = GDPZ0(reg,zone)/(1000*sum(urbrur,PopH0(reg,zone,urbrur)))  ;
 GDPZHpc0(reg,zone,urbrur)$GDPZH0(reg,zone,urbrur) = GDPZH0(reg,zone,urbrur)/(1000*PopH0(reg,zone,urbrur))  ;

 AgEXPENDZpc0(reg,zone)$EXPENDZ0(reg,zone) = sum(ag,PCZ0(reg,zone,ag)*QFZ0(reg,zone,ag))/(1000*sum(urbrur,PopH0(reg,zone,urbrur)))  ;
 AgGDPZpc0(reg,zone)$GDPZ0(reg,zone) = sum(ag,PPZ0(reg,zone,ag)*QSZ0(reg,zone,ag))/(1000*sum(urbrur,PopH0(reg,zone,urbrur)))  ;

 EXPENDRpc0(reg)$EXPENDR0(reg) = EXPENDR0(reg)/(1000*sum((zone,urbrur),PopH0(reg,zone,urbrur)))  ;
 GDPRpc0(reg)$GDPR0(reg) = GDPR0(reg)/(1000*sum((zone,urbrur),PopH0(reg,zone,urbrur)))  ;

 AgEXPENDRpc0(reg) = sum((zone,ag),PCZ0(reg,zone,ag)*QFZ0(reg,zone,ag))/(1000*sum((zone,urbrur),PopH0(reg,zone,urbrur)))  ;
 AgGDPRpc0(reg) = sum((zone,ag),PPZ0(reg,zone,ag)*QSZ0(reg,zone,ag))/(1000*sum((zone,urbrur),PopH0(reg,zone,urbrur)))  ;

 TEXPEND0    = sum(reg,EXPENDR0(reg))  ;
 GDP0        = sum((reg,zone,c),PPZ0(reg,zone,c)*QSZ0(reg,zone,c))  ;
 AgGDP0      = sum((reg,zone,ag),PPZ0(reg,zone,ag)*QSZ0(reg,zone,ag)) ;
 NAgGDP0     = sum((reg,zone,nag),PPZ0(reg,zone,nag)*QSZ0(reg,zone,nag)) ;
 TEXPENDpc0  = sum(reg,EXPENDR0(reg))/(1000*sum((reg,zone,urbrur),PopH0(reg,zone,urbrur)))  ;
 GDPpc0      = GDP0/(1000*sum((reg,zone,urbrur),PopH0(reg,zone,urbrur)))  ;

 AgEXPENDpc0 = sum((reg,zone,ag),PCZ0(reg,zone,ag)*QFZ0(reg,zone,ag))/(1000*sum((reg,zone,urbrur),PopH0(reg,zone,urbrur)))  ;
 AgGDPpc0    = sum((reg,zone,ag),PPZ0(reg,zone,ag)*QSZ0(reg,zone,ag))/(1000*sum((reg,zone,urbrur),PopH0(reg,zone,urbrur)))  ;

 AgGDPZ0(reg,zone)  = sum(ag,PPZ0(reg,zone,ag)*QSZ0(reg,zone,ag)) ;
 NAgGDPZ0(reg,zone) = sum(nag,PPZ0(reg,zone,nag)*QSZ0(reg,zone,nag)) ;

 chkIncomeBAL(reg,zone)$EXPENDZpc0(reg,zone) = EXPENDZpc0(reg,zone)/
             (GDPZpc0(reg,zone) + PPZ0(reg,zone,'nagntrade')*totmargz0(reg,zone)/(1000*sum(urbrur,PopH0(reg,zone,urbrur)))) ;

display GDP0, AgGDP0, GDPpc0, NagGDPZ0;

*===covert poverty line to be consistent with data
*HHIZ0(reg,zone,'urb',HHS) = HHIZshare0(reg,zone,'urb',HHS)*NAgGDP0 ;
*HHIZ0(reg,zone,'rur',HHS) = HHIZshare0(reg,zone,'rur',HHS)*AgGDP0 ;

HHIZ0(reg,zone,'urb',HHS) = HHIshareZ0(reg,zone,'urb',HHS)*sum(nag,PPZ0(reg,zone,nag)*QSZ0(reg,zone,nag)) ;
HHIZ0(reg,zone,'rur',HHS) = HHIshareZ0(reg,zone,'rur',HHS)*sum(ag,PPZ0(reg,zone,ag)*QSZ0(reg,zone,ag)) ;
HHIZ0(reg,zone,'rur',HHS)$(sum(HHSP,HHIshareZ0(reg,zone,'urb',HHSP)) eq 0) =
          HHIshareZ0(reg,zone,'rur',HHS)*sum(c,PPZ0(reg,zone,c)*QSZ0(reg,zone,c)) ;

HHIR0(reg,urbrur,HHS) = sum(zone,HHIZ0(reg,zone,urbrur,HHS)) ;
HHI0(urbrur,HHS)      = sum((reg,zone),HHIZ0(reg,zone,urbrur,HHS)) ;

HHIZpc0(reg,zone,urbrur,HHS)$HHIZ0(reg,zone,urbrur,HHS)  = HHIZ0(reg,zone,urbrur,HHS)/(0.1*1000*PopH0(reg,zone,urbrur));
HHIRpc0(reg,urbrur,HHS)$sum(zone,PoPH0(reg,zone,urbrur)) =
             sum(zone,HHIZ0(reg,zone,urbrur,HHS))/(0.1*sum(zone,1000*PoPH0(reg,zone,urbrur))) ;
HHIpc0(urbrur,HHS)    = sum((reg,zone),HHIZ0(reg,zone,urbrur,HHS))/(0.1*sum((reg,zone),1000*PoPH0(reg,zone,urbrur))) ;

parameter
chkAgIncome(reg,zone)      rural income over agGDP  (~1)    Afar 5 is too large (?)
chkNAgIncome(reg,zone)     urban income over nagGDP (~1)
;

chkAgIncome(reg,zone)$INCOMEag0(reg,zone,'rur') = sum(HHS,HHIZ0(reg,zone,'rur',HHS))/AgGDPZ0(reg,zone) ;
chkNAgIncome(reg,zone)$(INCOMEnag0(reg,zone,'urb') and NagGDPZ0(reg,zone)) = sum(HHS,HHIZ0(reg,zone,'urb',HHS))/NagGDPZ0(reg,zone) ;


display chkAgincome, chkNagincome, GDP0, AgGDP0, NAgGDP0, GDPpc0, AgGDPpc0, HHIRpc0, HHIpc0;


parameter
chkHHIZ0(reg,zone,urbrur)   should be zero after adjusting HHI wrt GDP
chkHHI(urbrur,HHS)          adjustment ratio
chkHHIpc(urbrur,HHS)        adjustment ratio
AvgHHIZpc0(reg,zone,urbrur) average income per capita
;
chkHHIZ0(reg,zone,'urb') = sum(HHS,HHIZ0(reg,zone,'urb',HHS)) - sum(nag,PPZ0(reg,zone,nag)*QSZ0(reg,zone,nag)) ;
chkHHIZ0(reg,zone,'rur') = sum(HHS,HHIZ0(reg,zone,'rur',HHS)) - sum(ag,PPZ0(reg,zone,ag)*QSZ0(reg,zone,ag)) ;
chkHHIZ0(reg,zone,'urb')$(sum(HHSP,HHIshareZ0(reg,zone,'urb',HHSP)) eq 0) = sum(HHS,HHIZ0(reg,zone,'urb',HHS)) ;
chkHHIZ0(reg,zone,'rur')$(sum(HHSP,HHIshareZ0(reg,zone,'urb',HHSP)) eq 0) =
       sum(HHS,HHIZ0(reg,zone,'rur',HHS)) - sum(c,PPZ0(reg,zone,c)*QSZ0(reg,zone,c)) ;
chkHHIZ0(reg,zone,'rur')$(sum(HHSP,HHIshareZ0(reg,zone,'rur',HHSP)) eq 0) = sum(HHS,HHIZ0(reg,zone,'rur',HHS)) ;

chkHHI(urbrur,HHS)   = HHI0(urbrur,HHS)/HHI00(urbrur,HHS);
chkHHIpc(urbrur,HHS) = HHIpc0(urbrur,HHS)/HHIpc00(urbrur,HHS);

AvgHHIZpc0(reg,zone,urbrur)$PoPH0(reg,zone,urbrur)  = sum(HHS,HHIZ0(reg,zone,urbrur,HHS))/(1000*PoPH0(reg,zone,urbrur)) ;

display chkHHIZ0, chkHHI, chkHHIpc, HHIZpc0, HHIZ0, avgHHIZpc0;


HHIZshare(reg,zone,'rur',HHS)$AgGDPZ0(reg,zone)  = HHIZ0(reg,zone,'rur',HHS)/AgGDPZ0(reg,zone);
HHIZshare(reg,zone,'urb',HHS)$NagGDPZ0(reg,zone) = HHIZ0(reg,zone,'urb',HHS)/NAgGDPZ0(reg,zone);
HHIZshare(reg,zone,'rur',HHS)$(NagGDPZ0(reg,zone) and HHIZshare(reg,zone,'urb',HHS) eq 0) =
                        HHIZ0(reg,zone,'rur',HHS)/(AgGDPZ0(reg,zone) + NAgGDPZ0(reg,zone));
HHIZshare(reg,zone,'urb',HHS)$(NagGDPZ0(reg,zone) and HHIZshare(reg,zone,'rur',HHS) eq 0) =
                        HHIZ0(reg,zone,'urb',HHS)/(AgGDPZ0(reg,zone) + NAgGDPZ0(reg,zone)) ;

parameter
chkHHIZhshare(reg,zone,urbrur,hhs)
;

chkHHIZhshare(reg,zone,urbrur,hhs)$HHIZshare(reg,zone,urbrur,HHS)  =
          HHIshareZ0(reg,zone,urbrur,HHS)/ HHIZshare(reg,zone,urbrur,HHS) ;
display chkHHIZhshare;

*======== Income Elasticity ==================================================

parameter
edfipart1(t,reg,zone)          income elas part 1
edfipart2(t,reg,zone)          income elas part 2
largedfipart1(t,reg,zone)      large income elas par1 (>1)
largedfipart2(t,reg,zone)      large income elas par2 (>1)

chkedfi(t,reg,zone)            edfi0*EXPENDZshare0 sum over all c
chktotIncomeBal                expend divided by GDP+ppz*totmargin
chkIncomeBalR(reg)             expend divided by GDP+ppz*totmargin
negedfi0(t,reg,zone,c)         income elas <0
SSouthOmoshare(c)              EXPENDZshare0 for Southern SouthOmo

edfiHpart1(reg,zone,urbrur)         income elas part 1
edfiHpart2(reg,zone,urbrur)         income elas part 2
chkedfiH(reg,zone,urbrur)           edfi0*EXPENDZshare0 sum over all c
negedfiH0(reg,zone,urbrur,c)        income elas <0
negQFZH0(reg,zone,urbrur,c)         QFZH0 <0
;

chkIncomeBalR(reg) = sum(zone,EXPENDZ0(reg,zone))/
             sum(zone,GDPZ0(reg,zone) + PPZ0(reg,zone,'nagntrade')*totmargz0(reg,zone)) ;
chktotIncomeBal = sum((reg,zone),EXPENDZ0(reg,zone))/
             sum((reg,zone),GDPZ0(reg,zone) + PPZ0(reg,zone,'nagntrade')*totmargz0(reg,zone)) ;

display chktotIncomeBal, chkIncomeBalR, chkIncomeBal;

chktotIncomeBal = sum((reg,zone),EXPENDZ0(reg,zone))/
             sum((reg,zone),GDPZ0(reg,zone) + totmargz0(reg,zone)) ;

* growth rate/change of elas over t
edfi0(t,reg,zone,C)$QFZpc0(reg,zone,c)   = edfiL(t,c) ;
edfi0(t,city,zone,C)$QFZpc0(city,zone,c) = edfiH(t,c) ;

edfi0(t,'Gambella',zone,lv) = 0.7*edfi0(t,'Gambella',zone,lv) ;
edfi0(t,'Benshangul','Kemeshi',lv) = 0.9*edfi0(t,'Benshangul','Kemeshi',lv) ;

* ying2 - 2003 as base year for calibration? for year 1983-2011, need values over these yrs (subscript t)-see excel?
edfiZH0(reg,zone,'rur',C)$QFZHpc0(reg,zone,'rur',c) = edfiL('2003',c) ;
edfiZH0(reg,zone,'urb',C)$QFZHpc0(reg,zone,'urb',c) = edfiH('2003',c) ;

edfiZH0('Gambella',zone,'rur',lv) = 0.7*edfiZH0('Gambella',zone,'rur',lv) ;
edfiZH0('Gambella',zone,'urb',lv) = 0.7*edfiZH0('Gambella',zone,'urb',lv) ;
edfiZH0('Benshangul','Kemeshi','rur',lv) = 0.9*edfiZH0('Benshangul','Kemeshi','rur',lv) ;

 EXPENDZshare0(reg,zone,c)$QFZ0(reg,zone,c) = PCZ0(reg,zone,c)*QFZ0(reg,zone,c)/
                      sum(cp,PCZ0(reg,zone,cp)*QFZ0(reg,zone,cp));
 EXPENDZHshare0(reg,zone,urbrur,c)$QFZH0(reg,zone,urbrur,c) = PCZ0(reg,zone,c)*QFZH0(reg,zone,urbrur,c)/
                      sum(cp,PCZ0(reg,zone,cp)*QFZH0(reg,zone,urbrur,cp));
 EXPENDRshare0(reg,c)$sum(zone,QFZ0(reg,zone,c)) = sum(zone,PCZ0(reg,zone,c)*QFZ0(reg,zone,c))/EXPENDR0(reg);

 SSouthOmoshare(c)  = EXPENDZshare0('Southern','SouthOmo',c) ;

edfipart1(t,reg,zone) = sum(ag$QFZ0(reg,zone,ag),edfi0(t,reg,zone,ag)*EXPENDZshare0(reg,zone,ag));
edfipart2(t,reg,zone) = edfipart1(t,reg,zone) + edfi0(t,reg,zone,'nagtrade')*EXPENDZshare0(reg,zone,'nagtrade');
largedfipart1(t,reg,zone)$(edfipart1(t,reg,zone) ge 1) = edfipart1(t,reg,zone) ;
largedfipart2(t,reg,zone)$(edfipart2(t,reg,zone) ge 1) = edfipart2(t,reg,zone) ;

edfi0(t,reg,zone,'Nagntrade')$QFZpc0(reg,zone,'Nagntrade')   =
       (1 - edfipart2(t,reg,zone))/
*       (1 - sum(AG, edfi0(t,reg,zone,ag)*EXPENDZshare0(reg,zone,ag)) -
*         edfi0(t,reg,zone,'Nagtrade')*EXPENDZshare0(reg,zone,'nagtrade'))/
                        EXPENDZshare0(reg,zone,'nagntrade');

edfi0(t,reg,zone,lv)$(edfi0(t,reg,zone,'Nagntrade') lt 0.5) = 0.97*edfi0(t,reg,zone,lv) ;
edfi0(t,reg,zone,oilseed)$(edfi0(t,reg,zone,'Nagntrade') lt 0.5) = 0.97*edfi0(t,reg,zone,oilseed) ;
edfi0(t,reg,zone,'Nagtrade')$(edfi0(t,reg,zone,'Nagntrade') lt 0.5) = 0.97*edfi0(t,reg,zone,'Nagtrade') ;
edfi0(t,reg,zone,ag)$(edfi0(t,reg,zone,'Nagntrade') gt 1.8) = 1.1*edfi0(t,reg,zone,ag) ;
edfi0(t,reg,zone,'Nagtrade')$(edfi0(t,reg,zone,'Nagntrade') gt 1.8) = 1.1*edfi0(t,reg,zone,'Nagtrade') ;
edfi0(t,'Southern','Gedio',ag)$(edfi0(t,'Southern','Gedio','Nagntrade') gt 1.8) = 1.1*edfi0(t,'Southern','Gedio',ag) ;

edfipart1(t,reg,zone) =sum(ag$QFZ0(reg,zone,ag),edfi0(t,reg,zone,ag)*EXPENDZshare0(reg,zone,ag));
edfipart2(t,reg,zone) = edfipart1(t,reg,zone) + edfi0(t,reg,zone,'nagtrade')*EXPENDZshare0(reg,zone,'nagtrade');

edfi0(t,reg,zone,'Nagntrade')$QFZpc0(reg,zone,'Nagntrade')   =
       (1 - edfipart2(t,reg,zone))/
                        EXPENDZshare0(reg,zone,'nagntrade');

chkedfi(t,reg,zone) =sum(c,edfi0(t,reg,zone,c)*EXPENDZshare0(reg,zone,c));
negedfi0(t,reg,zone,c)$(QFZpc0(reg,zone,c) and edfi0(t,reg,zone,C) lt 0) = yes;
negQFZ0('2003',reg,zone,c)$(EXPENDZshare0(reg,zone,c) lt 0) = QFZ0(reg,zone,c) ;

edfiHpart1(reg,zone,urbrur) =sum(ag$QFZH0(reg,zone,urbrur,ag),edfiZH0(reg,zone,urbrur,ag)*EXPENDZHshare0(reg,zone,urbrur,ag));
edfiHpart2(reg,zone,urbrur) = edfiHpart1(reg,zone,urbrur) + edfiZH0(reg,zone,urbrur,'nagtrade')*EXPENDZHshare0(reg,zone,urbrur,'nagtrade');

edfiZH0(reg,zone,urbrur,'Nagntrade')$QFZHpc0(reg,zone,urbrur,'Nagntrade')   =
       (1 - edfiHpart2(reg,zone,urbrur))/
                        EXPENDZHshare0(reg,zone,urbrur,'nagntrade');

edfiZH0(reg,zone,urbrur,lv)$(edfiZH0(reg,zone,urbrur,'Nagntrade') lt 0.5) = 0.97*edfiZH0(reg,zone,urbrur,lv) ;
edfiZH0(reg,zone,urbrur,oilseed)$(edfiZH0(reg,zone,urbrur,'Nagntrade') lt 0.5) = 0.97*edfiZH0(reg,zone,urbrur,oilseed) ;
edfiZH0(reg,zone,urbrur,'Nagtrade')$(edfiZH0(reg,zone,urbrur,'Nagntrade') lt 0.5) = 0.97*edfiZH0(reg,zone,urbrur,'Nagtrade') ;
edfiZH0(reg,zone,urbrur,ag)$(edfiZH0(reg,zone,urbrur,'Nagntrade') gt 1.8) = 1.1*edfiZH0(reg,zone,urbrur,ag) ;
edfiZH0(reg,zone,urbrur,'Nagtrade')$(edfiZH0(reg,zone,urbrur,'Nagntrade') gt 1.8) = 1.1*edfiZH0(reg,zone,urbrur,'Nagtrade') ;
edfiZH0('Southern','Gedio',urbrur,ag)$(edfiZH0('Southern','Gedio',urbrur,'Nagntrade') gt 1.8) = 1.1*edfiZH0('Southern','Gedio',urbrur,ag) ;

edfiHpart1(reg,zone,urbrur) =sum(ag$QFZH0(reg,zone,urbrur,ag),edfiZH0(reg,zone,urbrur,ag)*EXPENDZHshare0(reg,zone,urbrur,ag));
edfiHpart2(reg,zone,urbrur) = edfiHpart1(reg,zone,urbrur) + edfiZH0(reg,zone,urbrur,'nagtrade')*EXPENDZHshare0(reg,zone,urbrur,'nagtrade');

edfiZH0(reg,zone,urbrur,'Nagntrade')$QFZHpc0(reg,zone,urbrur,'Nagntrade')   =
       (1 - edfiHpart2(reg,zone,urbrur))/
                        EXPENDZHshare0(reg,zone,urbrur,'nagntrade');

chkedfiH(reg,zone,urbrur) =sum(c,edfiZH0(reg,zone,urbrur,c)*EXPENDZHshare0(reg,zone,urbrur,c));
negedfiH0(reg,zone,urbrur,c)$(QFZHpc0(reg,zone,urbrur,c) and edfiZH0(reg,zone,urbrur,C) lt 0) = yes;
negQFZH0(reg,zone,urbrur,c)$(QFZH0(reg,zone,urbrur,c) lt 0) = QFZH0(reg,zone,urbrur,c) ;

QFZpc0(reg,zone,c)$QFZ0(reg,zone,c) = QFZ0(reg,zone,c)/sum(urbrur,PopH0(reg,zone,urbrur)) ;
QFZHpc0(reg,zone,urbrur,c)$QFZH0(reg,zone,urbrur,c) = QFZH0(reg,zone,urbrur,c)/PopH0(reg,zone,urbrur) ;

display negQFZ0, negQFZH0, SSouthOmoshare, expendzshare0, negedfi0, negedfiH0, chkedfi, chkedfiH, edfipart1, largedfipart1, largedfipart2;
display edfi0, edfiZH0;

*==== Demand side elasticity
parameter
chkownedfpH(reg,zone,urbrur,c)      own price elas
chkownedfp(t,reg,zone,c)            own price elas
;
edfp0(t,reg,zone,C,CP)$(QFZpc0(reg,zone,c)) = 0.01 ;
edfp0(t,reg,zone,C,CP)$(QFZpc0(reg,zone,c) and edfi0(t,reg,zone,C) le 0.1) = 0.0001 ;
edfp0(t,reg,zone,C,CP)$(QFZpc0(reg,zone,c) and edfi0(t,reg,zone,C) le 0.2) = 0.001 ;
edfp0(t,reg,zone,C,CP)$(QFZpc0(reg,zone,c) and edfi0(t,reg,zone,C) gt 1)   = 0.02 ;
edfp0(t,reg,zone,C,CP)$(QFZpc0(reg,zone,c) and edfi0(t,reg,zone,C) gt 1.5) = 0.04 ;
edfp0(t,reg,zone,cereal,cerealP)$(QFZpc0(reg,zone,cereal)) = 0.03 ;

edfp0(t,reg,zone,cereal,cerealP)$(QFZpc0(reg,zone,cereal) and edfi0(t,reg,zone,cereal) gt 1) = 0.01 ;

*edfp0(t,reg,zone,'maize','wheat')$(QFZpc0(reg,zone,'maize')) = 0.1 ;
*edfp0(t,reg,zone,'teff','wheat')$(QFZpc0(reg,zone,'teff')) = 0.1 ;
edfp0(t,reg,zone,'wheat','maize')$(QFZpc0(reg,zone,'wheat'))   = 0.01 ;
edfp0(t,reg,zone,'wheat','teff')$(QFZpc0(reg,zone,'wheat'))    = 0.01 ;
edfp0(t,reg,zone,'wheat','sorghum')$(QFZpc0(reg,zone,'wheat')) = 0.01 ;
edfp0(t,reg,zone,'wheat','enset')$(QFZpc0(reg,zone,'enset'))   = 0.01 ;

edfp0(t,city,zone,cereal,cerealP)$QFZpc0(city,zone,cereal) = 0.01 ;

edfp0(t,reg,zone,cereal,cerealP)$(QFZpc0(reg,zone,cereal) and edfi0(t,reg,zone,cereal) le 0.1) = 0.00001 ;
edfp0(t,reg,zone,cereal,cerealP)$(QFZpc0(reg,zone,cereal) and edfi0(t,reg,zone,cereal) le 0.2) = 0.001 ;

edfp0(t,reg,zone,lv,lvp)$(QFZpc0(reg,zone,lv)) = 0.01 ;
edfp0(t,reg,zone,lv,lvp)$(QFZpc0(reg,zone,lv) and edfi0(t,reg,zone,lv) gt 1)   = 0.01 ;
edfp0(t,reg,zone,lv,lvp)$(QFZpc0(reg,zone,lv) and edfi0(t,reg,zone,lv) gt 1.5) = 0.01 ;
edfp0(t,reg,zone,cereal,lv) = 0 ;
edfp0(t,reg,zone,lv,cereal) = 0 ;
edfp0(t,reg,zone,C,C) = 0 ;
edfp0(t,reg,zone,C,C)$(QFZpc0(reg,zone,c)) =
             -(edfi0(t,reg,zone,C) + sum(cp,edfp0(t,reg,zone,C,cp)));

edfpH0(reg,zone,urbrur,C,CP)$(QFZHpc0(reg,zone,urbrur,c)) = 0.0 ;
edfpH0(reg,zone,urbrur,C,CP)$(QFZHpc0(reg,zone,urbrur,c) and edfiZH0(reg,zone,urbrur,C) le 0.2) = 0.0 ;
edfpH0(reg,zone,urbrur,C,CP)$(QFZHpc0(reg,zone,urbrur,c) and edfiZH0(reg,zone,urbrur,C) gt 1)   = 0.001 ;
edfpH0(reg,zone,urbrur,C,CP)$(QFZHpc0(reg,zone,urbrur,c) and edfiZH0(reg,zone,urbrur,C) gt 1.5) = 0.0015 ;

edfpH0(reg,zone,urbrur,'wheat','maize')$(QFZHpc0(reg,zone,urbrur,'wheat'))   = 0.001 ;
edfpH0(reg,zone,urbrur,'wheat','teff')$(QFZHpc0(reg,zone,urbrur,'wheat'))    = 0.001 ;
edfpH0(reg,zone,urbrur,'wheat','sorghum')$(QFZHpc0(reg,zone,urbrur,'wheat')) = 0.001 ;
edfpH0(reg,zone,urbrur,'wheat','enset')$(QFZHpc0(reg,zone,urbrur,'enset'))   = 0.001 ;


edfpH0(reg,zone,'urb',C,CP)$(QFZHpc0(reg,zone,'urb',c) and edfiZH0(reg,zone,'urb',C) gt 1)   = 0.001 ;
edfpH0(reg,zone,'urb',C,CP)$(QFZHpc0(reg,zone,'urb',c) and edfiZH0(reg,zone,'urb',C) gt 1.5) = 0.0015 ;
edfpH0(reg,zone,'urb',cereal,cerealP)$(QFZHpc0(reg,zone,'urb',cereal)) = 0.001 ;

edfpH0(reg,zone,urbrur,cereal,cerealP)$(QFZHpc0(reg,zone,urbrur,cereal) and edfiZH0(reg,zone,urbrur,cereal) le 0.5) = 0.00001 ;

edfpH0(reg,zone,urbrur,lv,lvp)$(QFZHpc0(reg,zone,urbrur,lv)) = 0.0001 ;
edfpH0(reg,zone,urbrur,lv,lvp)$(QFZHpc0(reg,zone,urbrur,lv) and edfiZH0(reg,zone,urbrur,lv) gt 1)   = 0.001 ;
edfpH0(reg,zone,urbrur,lv,lvp)$(QFZHpc0(reg,zone,urbrur,lv) and edfiZH0(reg,zone,urbrur,lv) gt 1.5) = 0.001 ;
*edfpH0(reg,zone,urbrur,cereal,lv) = 0 ;
*edfpH0(reg,zone,urbrur,lv,cereal) = 0 ;
edfpH0(reg,zone,urbrur,'enset',roots)$(edfiZH0(reg,zone,urbrur,'enset')) = -edfiZH0(reg,zone,urbrur,'enset')/2 ;
*edfpH0(reg,zone,urbrur,smallcereal,CP) = 0.1*edfpH0(reg,zone,urbrur,smallcereal,CP) ;
edfpH0(reg,zone,urbrur,C,CP) = -edfpH0(reg,zone,urbrur,C,CP) ;

edfpH0(reg,zone,urbrur,C,C) = 0 ;
edfpH0(reg,zone,urbrur,C,C)$(QFZHpc0(reg,zone,urbrur,c)) =
             -(edfiZH0(reg,zone,urbrur,C) + sum(cp,edfpH0(reg,zone,urbrur,C,cp)));

chkownedfp(t,reg,zone,c) = edfp0(t,reg,zone,c,c) ;
chkownedfpH(reg,zone,urbrur,c) = edfpH0(reg,zone,urbrur,c,c) ;

parameter
posownedfp(reg,zone,c)            positive own price elas (should not be)
posownedfpH(reg,zone,urbrur,c)    positive own price elas (should not be)
;
posownedfp(reg,zone,c)$(chkownedfp('2003',reg,zone,c) ge 0) = chkownedfp('2003',reg,zone,c) ;
*posownedfpH(reg,zone,urbrur,c)$(chkownedfpH(reg,zone,urbrur,c) ge 0) = chkownedfpH(reg,zone,urbrur,c) ;

*display posownedfpH;

*chkownedfpH(reg,zone,urbrur,c) = sum(cp,edfpH0(reg,zone,urbrur,c,cp)) + edfiZH0(reg,zone,urbrur,C);
*display chkownedfph;

*====
*Calculate price elasticity according to S-G function
Parameter
alphaH(reg,zone,urbrur,c)
Gamma(reg,zone,urbrur,c)
chkaf0(reg,zone,c)             should be zero
chkafH0(reg,zone,urbrur,c)     should be zero
;

Gamma(reg,zone,urbrur,c)      = 0.001*QFZHpc0(reg,zone,urbrur,c) ;
Gamma(reg,zone,urbrur,ofood)  = 0.005*QFZHpc0(reg,zone,urbrur,ofood) ;
Gamma(reg,zone,'rur',cereal)  = 0.8*QFZHpc0(reg,zone,'rur',cereal) ;
Gamma(reg,zone,'urb',cereal)  = 0.2*QFZHpc0(reg,zone,'urb',cereal) ;
Gamma(reg,zone,'rur',ostaple) = 0.4*QFZHpc0(reg,zone,'rur',ostaple) ;
Gamma(reg,zone,'urb',ostaple) = 0.3*QFZHpc0(reg,zone,'urb',ostaple) ;
Gamma(reg,zone,'rur',lv)      = 0.2*QFZHpc0(reg,zone,'rur',lv) ;
Gamma(reg,zone,'urb',lv)      = 0.7*QFZHpc0(reg,zone,'urb',lv) ;

alphaH(reg,zone,urbrur,c) = edfiZH0(reg,zone,urbrur,c)*EXPENDZHshare0(reg,zone,urbrur,c);
edfpH0(reg,zone,urbrur,C,CP)$(QFZHpc0(reg,zone,urbrur,c) and QFZHpc0(reg,zone,urbrur,cp)) =
           - alphaH(reg,zone,urbrur,c)*(PCZ0(reg,zone,cp)*
             Gamma(reg,zone,urbrur,cp))/(PCZ0(reg,zone,c)*QFZHpc0(reg,zone,urbrur,c)) ;

edfpH0(reg,zone,urbrur,c,c) = 0 ;
*edfpH0(reg,zone,urbrur,C,CP) = 0 ;
edfpH0(reg,zone,urbrur,c,c)$QFZHpc0(reg,zone,urbrur,c) =
           - (edfiZH0(reg,zone,urbrur,c) + sum(cp, edfpH0(reg,zone,urbrur,c,cp))) ;


chkownedfpH(reg,zone,urbrur,c) = edfpH0(reg,zone,urbrur,c,c) ;
posownedfpH(reg,zone,urbrur,c)$(chkownedfpH(reg,zone,urbrur,c) ge 0) = chkownedfpH(reg,zone,urbrur,c) ;

display posownedfpH, chkownedfph;

chkownedfpH(reg,zone,urbrur,c) = sum(cp,edfpH0(reg,zone,urbrur,c,cp)) + edfiZH0(reg,zone,urbrur,c);
display chkownedfph, edfph0;


*Interception of food demand funciton
af0(t,reg,zone,c)$QFZ0(reg,zone,c)
         = QFZpc0(reg,zone,c)/(PROD(CP$QFZ0(reg,zone,cp),PCZ0(reg,zone,cp)**edfp0(t,reg,zone,c,cp)) *
           GDPZpc0(reg,zone)**edfi0(t,reg,zone,c));

* assign value to variable
af(reg,zone,c)$af0('2003',reg,zone,c)            = af0('2003',reg,zone,c) ;
edfi(reg,zone,c)$edfi0('2003',reg,zone,C)        = edfi0('2003',reg,zone,c) ;
edfp(reg,zone,c,cp)$edfp0('2003',reg,zone,c,cp)  = edfp0('2003',reg,zone,c,cp) ;
chkaf0(reg,zone,c)$QFZ0(reg,zone,c)
         = QFZpc0(reg,zone,c) - af(reg,zone,c)*(PROD(CP$QFZ0(reg,zone,cp),PCZ0(reg,zone,cp)**edfp(reg,zone,c,cp)) *
           GDPZpc0(reg,zone)**edfi(reg,zone,c)) ;
afH0(reg,zone,urbrur,c)$QFZH0(reg,zone,urbrur,c)
         = QFZHpc0(reg,zone,urbrur,c)/(PROD(CP$QFZH0(reg,zone,urbrur,cp),PCZ0(reg,zone,cp)**edfpH0(reg,zone,urbrur,c,cp)) *
           GDPZHpc0(reg,zone,urbrur)**edfiZH0(reg,zone,urbrur,c));
afH(reg,zone,urbrur,c)$afH0(reg,zone,urbrur,c)           = afH0(reg,zone,urbrur,c) ;
edfiZH(reg,zone,urbrur,c)$edfiZH0(reg,zone,urbrur,c)     = edfiZH0(reg,zone,urbrur,c) ;
edfpH(reg,zone,urbrur,c,cp)$edfpH0(reg,zone,urbrur,c,cp) = edfpH0(reg,zone,urbrur,c,cp) ;
chkafH0(reg,zone,urbrur,c)$QFZH0(reg,zone,urbrur,c)
         = QFZHpc0(reg,zone,urbrur,c) - afH(reg,zone,urbrur,c)*(PROD(CP$QFZH0(reg,zone,urbrur,cp),PCZ0(reg,zone,cp)**edfpH(reg,zone,urbrur,c,cp)) *
           GDPZHpc0(reg,zone,urbrur)**edfiZH(reg,zone,urbrur,c)) ;

display chkownedfp, chkownedfpH, chkaf0, chkafH0, af0, afH0 ;

* ============== ying 6 ====================
* ==== Input: CYF
parameter
maxKc_Mean(reg,zone)      This is the maximum KcMean (CYF) of all the cereals (by zone)
;

maxKc_Mean(reg,zone)
         = max(Kc_Mean(reg,zone,'maize'),Kc_Mean(reg,zone,'wheat'),Kc_Mean(reg,zone,'millet'),Kc_Mean(reg,zone,'teff'),Kc_Mean(reg,zone,'sorghum'));

* ying6 add $QSZ
KcMean0(reg,zone,c)$QSZ0(reg,zone,c) = 1 ;
KcMean0(reg,zone,raincrop)           = Kc_Mean(reg,zone,raincrop) ;
KcMean0(reg,zone,'Barley')           = Kc_Mean(reg,zone,'Sorghum') ;
* use 100-yr avg kcmean input file (original)
*KcMean0(reg,zone,cash)               = maxKc_Mean(reg,zone) ;
* use 2003 kcmean input file
KcMean0(reg,zone,cash)               = Kc_Mean(reg,zone,'Enset');
* ========= ying5 ==========
*KcMean0(reg,zone,c)$(KcMean0(reg,zone,c) eq 0) = 0.001 ;
* ===========
*$exit;
display
maxKc_Mean;
* ===========================================

*==== Technology Input (irri, improved seed, persticide, fertilizer)
*Bring in disaggregate data of output and area according to input use
parameter
ZeroQSZ_input0(reg,zone,c,type)       supply>0 but area =0 (should not happen)
ZeroACZ_input0(reg,zone,c,type)       area >0 but supply =0 (usually should not happen except yield =0)
;

AAGG(reg,zone,CropInput)$QSZ0(reg,zone,CropInput) =
                   ANON(reg,zone,CropInput) + AALL(reg,zone,CropInput) + AFSW(reg,zone,CropInput) + AFSP(reg,zone,CropInput) + AFWP(reg,zone,CropInput)
                 + AF_S(reg,zone,CropInput) + AF_W(reg,zone,CropInput) + AF_P(reg,zone,CropInput) + AS_W(reg,zone,CropInput) + AS_P(reg,zone,CropInput)
                 + AP_W(reg,zone,CropInput) + A_F(reg,zone,CropInput) + A_S(reg,zone,CropInput) + A_W(reg,zone,CropInput) + A_P(reg,zone,CropInput) ;

PAGG(reg,zone,CropInput)$QSZ0(reg,zone,CropInput) =
                   PNON(reg,zone,CropInput) + PALL(reg,zone,CropInput) + PFSW(reg,zone,CropInput) + PFSP(reg,zone,CropInput) + PFWP(reg,zone,CropInput)
                 + PF_S(reg,zone,CropInput) + PF_W(reg,zone,CropInput) + PF_P(reg,zone,CropInput) + PS_W(reg,zone,CropInput) + PS_P(reg,zone,CropInput)
                 + PP_W(reg,zone,CropInput) + P_F(reg,zone,CropInput) + P_S(reg,zone,CropInput) + P_W(reg,zone,CropInput) + P_P(reg,zone,CropInput) ;

display QSZ0;
*$exit;

 ACZ_inputsh0(reg,zone,CropInput,'none')$AAGG(reg,zone,CropInput) = ANON(reg,zone,CropInput)/AAGG(reg,zone,CropInput) ;
 ACZ_inputsh0(reg,zone,CropInput,'sfip')$AAGG(reg,zone,CropInput) = AALL(reg,zone,CropInput)/AAGG(reg,zone,CropInput) ;
 ACZ_inputsh0(reg,zone,CropInput,'seed')$AAGG(reg,zone,CropInput) = A_S(reg,zone,CropInput)/AAGG(reg,zone,CropInput) ;
 ACZ_inputsh0(reg,zone,CropInput,'fert')$AAGG(reg,zone,CropInput) = A_F(reg,zone,CropInput)/AAGG(reg,zone,CropInput) ;
 ACZ_inputsh0(reg,zone,CropInput,'irri')$AAGG(reg,zone,CropInput) = A_W(reg,zone,CropInput)/AAGG(reg,zone,CropInput) ;
 ACZ_inputsh0(reg,zone,CropInput,'pest')$AAGG(reg,zone,CropInput) = A_P(reg,zone,CropInput)/AAGG(reg,zone,CropInput) ;
 ACZ_inputsh0(reg,zone,CropInput,'s_f')$AAGG(reg,zone,CropInput)  = AF_S(reg,zone,CropInput)/AAGG(reg,zone,CropInput) ;
 ACZ_inputsh0(reg,zone,CropInput,'s_i')$AAGG(reg,zone,CropInput)  = AS_W(reg,zone,CropInput)/AAGG(reg,zone,CropInput) ;
 ACZ_inputsh0(reg,zone,CropInput,'s_p')$AAGG(reg,zone,CropInput)  = AS_P(reg,zone,CropInput)/AAGG(reg,zone,CropInput) ;
 ACZ_inputsh0(reg,zone,CropInput,'f_i')$AAGG(reg,zone,CropInput)  = AF_W(reg,zone,CropInput)/AAGG(reg,zone,CropInput) ;
 ACZ_inputsh0(reg,zone,CropInput,'f_p')$AAGG(reg,zone,CropInput)  = AF_P(reg,zone,CropInput)/AAGG(reg,zone,CropInput) ;
 ACZ_inputsh0(reg,zone,CropInput,'i_p')$AAGG(reg,zone,CropInput)  = AP_W(reg,zone,CropInput)/AAGG(reg,zone,CropInput) ;
 ACZ_inputsh0(reg,zone,CropInput,'s_fp')$AAGG(reg,zone,CropInput) = AFSP(reg,zone,CropInput)/AAGG(reg,zone,CropInput) ;
 ACZ_inputsh0(reg,zone,CropInput,'s_fi')$AAGG(reg,zone,CropInput) = AFSW(reg,zone,CropInput)/AAGG(reg,zone,CropInput) ;
 ACZ_inputsh0(reg,zone,CropInput,'f_ip')$AAGG(reg,zone,CropInput) = AFWP(reg,zone,CropInput)/AAGG(reg,zone,CropInput) ;

 QSZ_inputsh0(reg,zone,CropInput,'none')$PAGG(reg,zone,CropInput) = PNON(reg,zone,CropInput)/PAGG(reg,zone,CropInput) ;
 QSZ_inputsh0(reg,zone,CropInput,'sfip')$PAGG(reg,zone,CropInput) = PALL(reg,zone,CropInput)/PAGG(reg,zone,CropInput) ;
 QSZ_inputsh0(reg,zone,CropInput,'seed')$PAGG(reg,zone,CropInput) = P_S(reg,zone,CropInput)/PAGG(reg,zone,CropInput) ;
 QSZ_inputsh0(reg,zone,CropInput,'fert')$PAGG(reg,zone,CropInput) = P_F(reg,zone,CropInput)/PAGG(reg,zone,CropInput) ;
 QSZ_inputsh0(reg,zone,CropInput,'irri')$PAGG(reg,zone,CropInput) = P_W(reg,zone,CropInput)/PAGG(reg,zone,CropInput) ;
 QSZ_inputsh0(reg,zone,CropInput,'pest')$PAGG(reg,zone,CropInput) = P_P(reg,zone,CropInput)/PAGG(reg,zone,CropInput) ;
 QSZ_inputsh0(reg,zone,CropInput,'s_f')$PAGG(reg,zone,CropInput)  = PF_S(reg,zone,CropInput)/PAGG(reg,zone,CropInput) ;
 QSZ_inputsh0(reg,zone,CropInput,'s_i')$PAGG(reg,zone,CropInput)  = PS_W(reg,zone,CropInput)/PAGG(reg,zone,CropInput) ;
 QSZ_inputsh0(reg,zone,CropInput,'s_p')$PAGG(reg,zone,CropInput)  = PS_P(reg,zone,CropInput)/PAGG(reg,zone,CropInput) ;
 QSZ_inputsh0(reg,zone,CropInput,'f_i')$PAGG(reg,zone,CropInput)  = PF_W(reg,zone,CropInput)/PAGG(reg,zone,CropInput) ;
 QSZ_inputsh0(reg,zone,CropInput,'f_p')$PAGG(reg,zone,CropInput)  = PF_P(reg,zone,CropInput)/PAGG(reg,zone,CropInput) ;
 QSZ_inputsh0(reg,zone,CropInput,'i_p')$PAGG(reg,zone,CropInput)  = PP_W(reg,zone,CropInput)/PAGG(reg,zone,CropInput) ;
 QSZ_inputsh0(reg,zone,CropInput,'s_fp')$PAGG(reg,zone,CropInput) = PFSP(reg,zone,CropInput)/PAGG(reg,zone,CropInput) ;
 QSZ_inputsh0(reg,zone,CropInput,'s_fi')$PAGG(reg,zone,CropInput) = PFSW(reg,zone,CropInput)/PAGG(reg,zone,CropInput) ;
 QSZ_inputsh0(reg,zone,CropInput,'f_ip')$PAGG(reg,zone,CropInput) = PFWP(reg,zone,CropInput)/PAGG(reg,zone,CropInput) ;

 ACZ_input0(reg,zone,CropInput,'none')$AAGG(reg,zone,CropInput)   = ACZ_inputsh0(reg,zone,CropInput,'none')*ACZ0(reg,zone,CropInput) ;
 ACZ_input0(reg,zone,CropInput,'sfip')$AAGG(reg,zone,CropInput)   = ACZ_inputsh0(reg,zone,CropInput,'sfip')*ACZ0(reg,zone,CropInput) ;
 ACZ_input0(reg,zone,CropInput,'seed')$AAGG(reg,zone,CropInput)   = ACZ_inputsh0(reg,zone,CropInput,'seed')*ACZ0(reg,zone,CropInput) ;
 ACZ_input0(reg,zone,CropInput,'fert')$AAGG(reg,zone,CropInput)   = ACZ_inputsh0(reg,zone,CropInput,'fert')*ACZ0(reg,zone,CropInput) ;
 ACZ_input0(reg,zone,CropInput,'irri')$AAGG(reg,zone,CropInput)   = ACZ_inputsh0(reg,zone,CropInput,'irri')*ACZ0(reg,zone,CropInput) ;
 ACZ_input0(reg,zone,CropInput,'pest')$AAGG(reg,zone,CropInput)   = ACZ_inputsh0(reg,zone,CropInput,'pest')*ACZ0(reg,zone,CropInput) ;
 ACZ_input0(reg,zone,CropInput,'s_f')$AAGG(reg,zone,CropInput)    = ACZ_inputsh0(reg,zone,CropInput,'s_f')*ACZ0(reg,zone,CropInput) ;
 ACZ_input0(reg,zone,CropInput,'s_i')$AAGG(reg,zone,CropInput)    = ACZ_inputsh0(reg,zone,CropInput,'s_i')*ACZ0(reg,zone,CropInput) ;
 ACZ_input0(reg,zone,CropInput,'s_p')$AAGG(reg,zone,CropInput)    = ACZ_inputsh0(reg,zone,CropInput,'s_p')*ACZ0(reg,zone,CropInput) ;
 ACZ_input0(reg,zone,CropInput,'f_i')$AAGG(reg,zone,CropInput)    = ACZ_inputsh0(reg,zone,CropInput,'f_i')*ACZ0(reg,zone,CropInput) ;
 ACZ_input0(reg,zone,CropInput,'f_p')$AAGG(reg,zone,CropInput)    = ACZ_inputsh0(reg,zone,CropInput,'f_p')*ACZ0(reg,zone,CropInput) ;
 ACZ_input0(reg,zone,CropInput,'i_p')$AAGG(reg,zone,CropInput)    = ACZ_inputsh0(reg,zone,CropInput,'i_p')*ACZ0(reg,zone,CropInput) ;
 ACZ_input0(reg,zone,CropInput,'s_fp')$AAGG(reg,zone,CropInput)   = ACZ_inputsh0(reg,zone,CropInput,'s_fp')*ACZ0(reg,zone,CropInput) ;
 ACZ_input0(reg,zone,CropInput,'s_fi')$AAGG(reg,zone,CropInput)   = ACZ_inputsh0(reg,zone,CropInput,'s_fi')*ACZ0(reg,zone,CropInput) ;
 ACZ_input0(reg,zone,CropInput,'f_ip')$AAGG(reg,zone,CropInput)   = ACZ_inputsh0(reg,zone,CropInput,'f_ip')*ACZ0(reg,zone,CropInput) ;

 QSZ_input0(reg,zone,CropInput,'none')$PAGG(reg,zone,CropInput)   = QSZ_inputsh0(reg,zone,CropInput,'none')*QSZ0(reg,zone,CropInput) ;
 QSZ_input0(reg,zone,CropInput,'sfip')$PAGG(reg,zone,CropInput)   = QSZ_inputsh0(reg,zone,CropInput,'sfip')*QSZ0(reg,zone,CropInput) ;
 QSZ_input0(reg,zone,CropInput,'seed')$PAGG(reg,zone,CropInput)   = QSZ_inputsh0(reg,zone,CropInput,'seed')*QSZ0(reg,zone,CropInput) ;
 QSZ_input0(reg,zone,CropInput,'fert')$PAGG(reg,zone,CropInput)   = QSZ_inputsh0(reg,zone,CropInput,'fert')*QSZ0(reg,zone,CropInput) ;
 QSZ_input0(reg,zone,CropInput,'irri')$PAGG(reg,zone,CropInput)   = QSZ_inputsh0(reg,zone,CropInput,'irri')*QSZ0(reg,zone,CropInput) ;
 QSZ_input0(reg,zone,CropInput,'pest')$PAGG(reg,zone,CropInput)   = QSZ_inputsh0(reg,zone,CropInput,'pest')*QSZ0(reg,zone,CropInput) ;
 QSZ_input0(reg,zone,CropInput,'s_f')$PAGG(reg,zone,CropInput)    = QSZ_inputsh0(reg,zone,CropInput,'s_f')*QSZ0(reg,zone,CropInput) ;
 QSZ_input0(reg,zone,CropInput,'s_i')$PAGG(reg,zone,CropInput)    = QSZ_inputsh0(reg,zone,CropInput,'s_i')*QSZ0(reg,zone,CropInput) ;
 QSZ_input0(reg,zone,CropInput,'s_p')$PAGG(reg,zone,CropInput)    = QSZ_inputsh0(reg,zone,CropInput,'s_p')*QSZ0(reg,zone,CropInput) ;
 QSZ_input0(reg,zone,CropInput,'f_i')$PAGG(reg,zone,CropInput)    = QSZ_inputsh0(reg,zone,CropInput,'f_i')*QSZ0(reg,zone,CropInput) ;
 QSZ_input0(reg,zone,CropInput,'f_p')$PAGG(reg,zone,CropInput)    = QSZ_inputsh0(reg,zone,CropInput,'f_p')*QSZ0(reg,zone,CropInput) ;
 QSZ_input0(reg,zone,CropInput,'i_p')$PAGG(reg,zone,CropInput)    = QSZ_inputsh0(reg,zone,CropInput,'i_p')*QSZ0(reg,zone,CropInput) ;
 QSZ_input0(reg,zone,CropInput,'s_fp')$PAGG(reg,zone,CropInput)   = QSZ_inputsh0(reg,zone,CropInput,'s_fp')*QSZ0(reg,zone,CropInput) ;
 QSZ_input0(reg,zone,CropInput,'s_fi')$PAGG(reg,zone,CropInput)   = QSZ_inputsh0(reg,zone,CropInput,'s_fi')*QSZ0(reg,zone,CropInput) ;
 QSZ_input0(reg,zone,CropInput,'f_ip')$PAGG(reg,zone,CropInput)   = QSZ_inputsh0(reg,zone,CropInput,'f_ip')*QSZ0(reg,zone,CropInput) ;

 ACZ_input0(reg,zone,CropInput,'none')$(ACZ0(reg,zone,CropInput) and QSZ0(reg,zone,CropInput) and AAGG(reg,zone,CropInput) eq 0) = ACZ0(reg,zone,CropInput) ;
 QSZ_input0(reg,zone,CropInput,'none')$(ACZ0(reg,zone,CropInput) and QSZ0(reg,zone,CropInput) and PAGG(reg,zone,CropInput) eq 0) = QSZ0(reg,zone,CropInput) ;
 display QSZ_input0;

* ===== ying 6 - when kcmean =0, QSZ for non-water-type technology should be zero too =====
 parameter
 chkconsQSZ(reg,zone,CropInput)     check whether sum of QSZ_input still equals to QSZ (should be zero)
 chkconsQSZ2(reg,zone,c)            check whether sum of QSZ_input still equals to QSZ (should be zero)
;
 QSZ_input0(reg,zone,CropInput,nwtype)$(ACZ0(reg,zone,CropInput) and QSZ0(reg,zone,CropInput) and kcmean0(reg,zone,CropInput) eq 0) = 0;
 QSZ_input0(reg,zone,CropInput,wtype)$(ACZ0(reg,zone,CropInput) and QSZ0(reg,zone,CropInput) and kcmean0(reg,zone,CropInput) eq 0)
         = QSZ_input0(reg,zone,CropInput,wtype)* QSZ0(reg,zone,CropInput) / sum( type,QSZ_input0(reg,zone,CropInput,type) );

 chkconsQSZ(reg,zone,CropInput) = QSZ0(reg,zone,CropInput) - sum( type,QSZ_input0(reg,zone,CropInput,type) ) ;
 display chkconsQSZ, QSZ_input0,QSZ_input0;
*$exit;

* =============
 ACZ_input0(reg,zone,CropNone,type) = 0 ;
 QSZ_input0(reg,zone,CropNone,type) = 0 ;

 ACZ_input0(reg,zone,CropNone,'none')$(ACZ0(reg,zone,CropNone) and QSZ0(reg,zone,CropNone)) = ACZ0(reg,zone,CropNone) ;
 QSZ_input0(reg,zone,CropNone,'none')$(ACZ0(reg,zone,CropNone) and QSZ0(reg,zone,CropNone)) = QSZ0(reg,zone,CropNone) ;

 chkconsQSZ2(reg,zone,c)$(QSZ0(reg,zone,c) and ACZ0(reg,zone,c)) = QSZ0(reg,zone,c) - sum( type,QSZ_input0(reg,zone,c,type) ) ;
 display chkconsQSZ2;

 ZeroACZ_input0(reg,zone,Crop,type)$(ACZ_input0(reg,zone,crop,type) and QSZ_input0(reg,zone,crop,type) eq 0) =
                     ACZ_input0(reg,zone,Crop,type) ;
 ZeroQSZ_input0(reg,zone,Crop,type)$(ACZ_input0(reg,zone,crop,type) eq 0 and QSZ_input0(reg,zone,crop,type)) =
                     QSZ_input0(reg,zone,Crop,type) ;

 YCZ_input0(reg,zone,crop,type)$ACZ_input0(reg,zone,crop,type) = 1000*QSZ_input0(reg,zone,crop,type)/ACZ_input0(reg,zone,crop,type);

 RACZ_input0(reg,crop,type) = sum(zone,ACZ_input0(reg,zone,crop,type)) ;
 RQSZ_input0(reg,crop,type) = sum(zone,QSZ_input0(reg,zone,crop,type)) ;
 RYCZ_input0(reg,c,type)$RACZ_input0(reg,c,type) = 1000*RQSZ_input0(reg,c,type)/RACZ_input0(reg,c,type);

 TACZ_input0(crop,type) = sum((reg,zone),ACZ_input0(reg,zone,crop,type)) ;
 TQSZ_input0(crop,type) = sum((reg,zone),QSZ_input0(reg,zone,crop,type)) ;
 TYCZ_input0(c,type)$TACZ_input0(c,type) = 1000*TQSZ_input0(c,type)/TACZ_input0(c,type) ;

 display zeroACZ_input0, zeroQSZ_input0 ;

 parameter
 chkACZ_input(reg,zone,c)        agg ACZ_input minus ACZ (should be zero)
 chkQSZ_input(reg,zone,c)        agg QSZ_input minus QSZ (should be zero)
 chkYCZ_input(reg,zone,c,type)   ratio of YCZ with input over YCZ without any input
 chkTYCZ_input(c,type)           ratio of TYCZ with input over TYCZ without any input
 chkRYCZ_input(reg,c,type)       ratio of RYCZ with input over RYCZ without any input
 AdjYCZ_input0(reg,zone,c,type)  adjust YCZ
 AdjACZ_input0(reg,zone,c,type)  adjust ACZ
 AdjQSZ_input0(reg,zone,c,type)  adjust QSZ
 negQSZ_none(reg,zone,c)         AdjQSZ_input0 < 0 when there is no inputs (should not occur)
 chkYCZ_input0(reg,zone,c,type)  AdjYCZ_input0 > 0 and AdjYCZ_input0 with input < AdjYCZ_input0 without input (should not)
 ;

 chkACZ_input(reg,zone,crop) = sum(type,ACZ_input0(reg,zone,crop,type)) - ACZ0(reg,zone,crop) ;
 chkQSZ_input(reg,zone,crop) = sum(type,QSZ_input0(reg,zone,crop,type)) - QSZ0(reg,zone,crop) ;

 chkYCZ_input(reg,zone,crop,inptype)$YCZ_input0(reg,zone,crop,'none') = YCZ_input0(reg,zone,crop,inptype)/YCZ_input0(reg,zone,crop,'none') ;
 chkRYCZ_input(reg,crop,inptype)$RYCZ_input0(reg,crop,'none')         = RYCZ_input0(reg,crop,inptype)/RYCZ_input0(reg,crop,'none') ;
 chkTYCZ_input(crop,inptype)$TYCZ_input0(crop,'none')                 = TYCZ_input0(crop,inptype)/TYCZ_input0(crop,'none') ;

 display zeroACZ_input0, zeroQSZ_input0, chkACZ_input,  chkQSZ_input, chkTYCZ_input, chkRYCZ_input, TYCZ_input0, RYCZ_input0, YCZ_input0 ;

*=========
 AdjYCZ_input0(reg,zone,Crop,type) = YCZ_input0(reg,zone,Crop,type) ;

 AdjYCZ_input0(reg,zone,CropInput,inptype)$(ACZ_input0(reg,zone,CropInput,inptype) and ACZ_input0(reg,zone,CropInput,'none') and
            YCZ_input0(reg,zone,CropInput,inptype) lt 1.02*YCZ_input0(reg,zone,CropInput,'none')) =
                                  1.02*YCZ_input0(reg,zone,CropInput,'none') ;


 AdjYCZ_input0('southern','Gurage','wheat',inptype)$(ACZ_input0('southern','Gurage','wheat',inptype) and
            YCZ_input0('southern','Gurage','wheat',inptype) lt 1.01*YCZ_input0('southern','Gurage','wheat','none')) =
                                  1.01*YCZ_input0('southern','Gurage','wheat','none') ;
 AdjYCZ_input0('southern',zone,'sorghum',inptype)$(ACZ_input0('southern',zone,'sorghum',inptype) and
            YCZ_input0('southern',zone,'sorghum',inptype) lt 1.03*YCZ_input0('southern',zone,'sorghum','none')) =
                                  1.03*YCZ_input0('southern',zone,'sorghum','none') ;
 AdjYCZ_input0('southern',zone,'barley',inptype)$(ACZ_input0('southern',zone,'barley',inptype) and
            YCZ_input0('southern',zone,'barley',inptype) lt 1.03*YCZ_input0('southern',zone,'barley','none')) =
                                  1.03*YCZ_input0('southern',zone,'barley','none') ;
 AdjYCZ_input0('Oromia',zone,'Millet',inptype)$(ACZ_input0('Oromia',zone,'Millet',inptype) and
            YCZ_input0('Oromia',zone,'Millet',inptype) lt 1.03*YCZ_input0('Oromia',zone,'Millet','none')) =
                                  1.03*YCZ_input0('Oromia',zone,'Millet','none') ;

 AdjYCZ_input0(reg,zone,CropInput,inptype)$(ACZ_input0(reg,zone,CropInput,inptype) and
            YCZ_input0(reg,zone,CropInput,inptype) ge 1.02*YCZ_input0(reg,zone,CropInput,'none')) =
                                  YCZ_input0(reg,zone,CropInput,inptype) ;

 AdjYCZ_input0('southern','Gurage','wheat',inptype)$(ACZ_input0('southern','Gurage','wheat',inptype) and
            YCZ_input0('southern','Gurage','wheat',inptype) ge 1.01*YCZ_input0('southern','Gurage','wheat','none')) =
                                  YCZ_input0('southern','Gurage','wheat',inptype) ;
 AdjYCZ_input0('southern',zone,'sorghum',inptype)$(ACZ_input0('southern',zone,'sorghum',inptype) and
            YCZ_input0('southern',zone,'sorghum',inptype) ge 1.03*YCZ_input0('southern',zone,'sorghum','none')) =
                                  YCZ_input0('southern',zone,'sorghum',inptype) ;
 AdjYCZ_input0('southern',zone,'barley',inptype)$(ACZ_input0('southern',zone,'barley',inptype) and
            YCZ_input0('southern',zone,'barley',inptype) ge 1.03*YCZ_input0('southern',zone,'barley','none')) =
                                  YCZ_input0('southern',zone,'barley',inptype) ;
 AdjYCZ_input0('Oromia',zone,'Millet',inptype)$(ACZ_input0('Oromia',zone,'Millet',inptype) and
            YCZ_input0('Oromia',zone,'Millet',inptype) ge 1.03*YCZ_input0('Oromia',zone,'Millet','none')) =
                                  YCZ_input0('Oromia',zone,'Millet',inptype) ;

*==== Input: irrigation area (old and new for calc irrigation growth rate)
parameter
ACZirr00(reg,zone,c)     intermediate param to adjust irr area
TACZirr00(reg,zone)      intermediate param to adjust irr area
;

ACZirr00(reg,zone,c)$(ACZ0(reg,zone,c) eq 0 and ACZirr0(reg,zone,c)) = ACZirr0(reg,zone,c) ;
TACZirr00(reg,zone) = sum(c,ACZirr00(reg,zone,c)) ;

ACZirr0(reg,zone,c)$(ACZ0(reg,zone,c) and ACZirr0(reg,zone,c))
                    = ACZirr0(reg,zone,c) + ACZirr0(reg,zone,c)/sum(cp,ACZirr0(reg,zone,cp))*TACZirr00(reg,zone) ;

ACZirr0(reg,zone,c)$(ACZ0(reg,zone,c) eq 0) = 0 ;

display TACZirr00, ACZirr00;

* adjusting irrigation area data
irrinACZ0(reg,zone,c)$ACZ0(reg,zone,c)                                            = 100*ACZirr0(reg,zone,c)/ACZ0(reg,zone,c) ;
irrinACZ0(reg,zone,c)$(irrinACZ0(reg,zone,c) ge 90)                               = 0.5*irrinACZ0(reg,zone,c) ;
irrinACZ0(reg,zone,c)$(irrinACZ0(reg,zone,c) ge 50)                               = 50 ;
irrinACZ0(reg,zone,c)$(irrinACZ0(reg,zone,c) gt 0 and irrinACZ0(reg,zone,c) le 1) = 5*irrinACZ0(reg,zone,c) ;
irrinACZ0(reg,zone,c)$(irrinACZ0(reg,zone,c) gt 0 and irrinACZ0(reg,zone,c) le 1) = 5*irrinACZ0(reg,zone,c) ;
irrinACZ0(reg,zone,c)$(irrinACZ0(reg,zone,c) gt 0 and irrinACZ0(reg,zone,c) le 1) = 5*irrinACZ0(reg,zone,c) ;

ACZirr0(reg,zone,c)$ACZ0(reg,zone,c)                             = irrinACZ0(reg,zone,c)*ACZ0(reg,zone,c)/100 ;
ACZirrSh0(reg,zone,c)$(ACZ0(reg,zone,c) and ACZirr0(reg,zone,c)) = 100*ACZirr0(reg,zone,c)/sum(cp,ACZirr0(reg,zone,cp)) ;

TACZirr0(reg,zone)                               = sum(c$ACZ0(reg,zone,c),ACZirr0(reg,zone,c));
TACZirrSh0(reg,zone)$TACZirr0(reg,zone)          = 100*TACZirr0(reg,zone)/sum((regp,zonep), TACZirr0(regp,zonep));
irrinTACZ0(reg,zone)$TACZirr0(reg,zone)          = 100*TACZirr0(reg,zone)/TACZ0(reg,zone) ;
irrinTACZ20(c)$sum((reg,zone),ACZ0(reg,zone,c))  = 100*sum((reg,zone),ACZirr0(reg,zone,c))/sum((reg,zone),ACZ0(reg,zone,c)) ;


*===Adj irrigation such that total irrigated areas reach 200,000ha

AdjACZ_input0(reg,zone,Crop,'irri') = ACZ_input0(reg,zone,Crop,'irri') ;
AdjACZ_input0(reg,zone,Crop,'none') = ACZ_input0(reg,zone,Crop,'none') ;

YCZ0(reg,zone,c)$(QSZ0(reg,zone,c) and ACZ0(reg,zone,c)) = 1000*QSZ0(reg,zone,c)/ACZ0(reg,zone,c) ;

AdjACZ_input0(reg,zone,CropInput,'irri') = ACZ_input0(reg,zone,CropInput,'irri') ;
AdjACZ_input0(reg,zone,CropInput,'none') = ACZ_input0(reg,zone,CropInput,'none') ;

AdjACZ_input0(reg,zone,CropInput,'irri')$(QSZ0(reg,zone,CropInput) and ACZ_input0(reg,zone,CropInput,'none') and ACZirr0(reg,zone,CropInput)gt
             sum(Wtype,ACZ_input0(reg,zone,CropInput,wtype))) =
             ACZ_input0(reg,zone,CropInput,'irri') + ACZirr0(reg,zone,CropInput) - sum(Wtype,ACZ_input0(reg,zone,CropInput,wtype)) ;
AdjACZ_input0(reg,zone,CropInput,'irri')$(QSZ0(reg,zone,CropInput) and ACZirr0(reg,zone,CropInput) le
             sum(Wtype,ACZ_input0(reg,zone,CropInput,wtype))) =
             ACZ_input0(reg,zone,CropInput,'irri')  ;

AdjACZ_input0(reg,zone,CropInput,'none')$(QSZ0(reg,zone,CropInput) and ACZ_input0(reg,zone,CropInput,'none')  and ACZirr0(reg,zone,CropInput) gt
             sum(Wtype,ACZ_input0(reg,zone,CropInput,wtype))) =
             ACZ_input0(reg,zone,CropInput,'none') - (ACZirr0(reg,zone,CropInput) - sum(Wtype,ACZ_input0(reg,zone,CropInput,wtype))) ;
AdjACZ_input0(reg,zone,CropInput,'none')$(QSZ0(reg,zone,CropInput) and ACZirr0(reg,zone,CropInput) le
             sum(Wtype,ACZ_input0(reg,zone,CropInput,wtype))) =
             ACZ_input0(reg,zone,CropInput,'none')  ;

AdjACZ_input0(reg,zone,CropNone,'irri')$(ACZirr0(reg,zone,CropNone) and QSZ0(reg,zone,CropNone))         = ACZirr0(reg,zone,CropNone) ;
AdjACZ_input0(reg,zone,CropNone,'irri')$(ACZirr0(reg,zone,CropNone) eq 0 and QSZ0(reg,zone,CropNone))    = 0 ;
AdjACZ_input0(reg,zone,CropNone,'none')$(ACZirr0(reg,zone,CropNone) and QSZ0(reg,zone,CropNone))         = ACZ0(reg,zone,CropNone) - ACZirr0(reg,zone,CropNone) ;
AdjACZ_input0(reg,zone,CropNone,'none')$(ACZirr0(reg,zone,CropNone) eq 0 and QSZ0(reg,zone,CropNone))    = ACZ0(reg,zone,CropNone) ;

ACZ_input0(reg,zone,Crop,'irri') = AdjACZ_input0(reg,zone,Crop,'irri') ;
ACZ_input0(reg,zone,Crop,'none') = AdjACZ_input0(reg,zone,Crop,'none') ;

AdjYCZ_input0(reg,zone,CropInput,'irri')$(ACZ_input0(reg,zone,CropInput,'irri') and QSZ0(reg,zone,CropInput) and
          ACZ_input0(reg,zone,CropInput,'none') and AdjYCZ_input0(reg,zone,CropInput,'irri'))      = 1.3*AdjYCZ_input0(reg,zone,CropInput,'irri') ;
AdjYCZ_input0(reg,zone,CropInput,'irri')$(ACZ_input0(reg,zone,CropInput,'irri') and QSZ0(reg,zone,CropInput) and
          ACZ_input0(reg,zone,CropInput,'none') and AdjYCZ_input0(reg,zone,CropInput,'irri') eq 0) = 1.3*AdjYCZ_input0(reg,zone,CropInput,'none') ;

AdjYCZ_input0(reg,zone,CropNone,'irri')$(ACZirr0(reg,zone,CropNone) and QSZ0(reg,zone,CropNone))   = 1.4*YCZ0(reg,zone,CropNone) ;

AdjYCZ_input0('Afar','Afar1','maize','irri')                     = YCZ_input0('Afar','Afar1','maize','irri') ;
AdjYCZ_input0('Somali','Shinele','maize','irri')                 = 1.2*YCZ_input0('Somali','Shinele','maize','irri') ;
AdjYCZ_input0('southern','Gurage','oats','fert')                 = 1.7*YCZ_input0('southern','Gurage','oats','fert') ;
AdjYCZ_input0('southern','Gurage','OilcropsOther','fert')        = 1.05*YCZ_input0('southern','Gurage','OilcropsOther','fert') ;
AdjYCZ_input0('Oromia','Arsi','Wheat','s_f')                     = 1.35*YCZ_input0('Oromia','Arsi','Wheat','s_f') ;
AdjYCZ_input0('Oromia','Arsi','Wheat','fert')                    = 1.101*YCZ_input0('Oromia','Arsi','Wheat','fert') ;
AdjYCZ_input0('Oromia','Arsi','Wheat','irri')                    = 1.3*YCZ_input0('Oromia','Arsi','Wheat','irri') ;
AdjYCZ_input0('AddisAbaba','Addis2','Wheat',inptype)             = 1.001*YCZ_input0('AddisAbaba','Addis2','Wheat',inptype) ;
AdjYCZ_input0('AddisAbaba','Addis2','Teff',inptype)              = 1.001*YCZ_input0('AddisAbaba','Addis2','Teff',inptype) ;
AdjYCZ_input0('DireDawa','DireDawa','OilcropsOther',inptype)     = 0.99*YCZ_input0('DireDawa','DireDawa','OilcropsOther',inptype) ;
AdjYCZ_input0('DireDawa','DireDawa','PulsesOther',inptype)       = 1.15*YCZ_input0('DireDawa','DireDawa','PulsesOther',inptype) ;

*==================
 AdjQSZ_input0(reg,zone,crop,type) = QSZ_input0(reg,zone,crop,type) ;
*ying 6 - add kcmean0>0 in the condition
 AdjQSZ_input0(reg,zone,crop,inptype)$(AdjYCZ_input0(reg,zone,crop,inptype) and kcmean0(reg,zone,crop)) =
            AdjYCZ_input0(reg,zone,crop,inptype)*ACZ_input0(reg,zone,crop,inptype)/1000;

 AdjQSZ_input0(reg,zone,crop,'none')$(QSZ_input0(reg,zone,crop,'none') and sum(inptype,AdjQSZ_input0(reg,zone,crop,inptype))) =
            QSZ_input0(reg,zone,crop,'none') - sum(inptype,AdjQSZ_input0(reg,zone,crop,inptype) - QSZ_input0(reg,zone,crop,inptype)) ;

* AdjQSZ_input0(reg,zone,crop,'none')$(QSZ_input0(reg,zone,crop,'none') and sum(inptype,AdjQSZ_input0(reg,zone,crop,inptype)) eq 0) =
*            QSZ_input0(reg,zone,crop,'none') ;

 negQSZ_none(reg,zone,crop)$(AdjQSZ_input0(reg,zone,crop,'none') lt 0) = AdjQSZ_input0(reg,zone,crop,'none');

 display negQSZ_none ;

* assign adjusted values
 QSZ_input0(reg,zone,crop,type) = AdjQSZ_input0(reg,zone,crop,type) ;

* === ying 6 recalc YCZ for all type not just 'none'
* AdjYCZ_input0(reg,zone,crop,'none')$ACZ_input0(reg,zone,crop,'none') =
*              1000*QSZ_input0(reg,zone,crop,'none')/ACZ_input0(reg,zone,crop,'none');

 AdjYCZ_input0(reg,zone,crop,type)$ACZ_input0(reg,zone,crop,type) =
              1000*QSZ_input0(reg,zone,crop,type)/ACZ_input0(reg,zone,crop,type);
* ======

 chkYCZ_input0(reg,zone,c,type)$(AdjYCZ_input0(reg,zone,c,type) and AdjYCZ_input0(reg,zone,c,type) lt AdjYCZ_input0(reg,zone,c,'none'))
         = AdjYCZ_input0(reg,zone,c,type) ;

 display chkYCZ_input0;

 chkYCZ_input(reg,zone,crop,inptype)$AdjYCZ_input0(reg,zone,crop,'none') =
           AdjYCZ_input0(reg,zone,crop,inptype)/AdjYCZ_input0(reg,zone,crop,'none');
 chkYCZ_input(reg,zone,crop,inptype)$(YCZ_input0(reg,zone,crop,inptype) and YCZ_input0(reg,zone,crop,'none')
               and AdjYCZ_input0(reg,zone,crop,'none') eq 0) =
           AdjYCZ_input0(reg,zone,crop,inptype)/YCZ_input0(reg,zone,crop,'none');

 YCZ_input0(reg,zone,crop,type)$AdjYCZ_input0(reg,zone,crop,type) = AdjYCZ_input0(reg,zone,crop,type);

 RACZ_input0(reg,crop,type) = sum(zone,ACZ_input0(reg,zone,crop,type)) ;
 RQSZ_input0(reg,crop,type) = sum(zone,QSZ_input0(reg,zone,crop,type)) ;
 RYCZ_input0(reg,c,type)$RACZ_input0(reg,c,type) = 1000*RQSZ_input0(reg,c,type)/RACZ_input0(reg,c,type);

 TACZ_input0(crop,type) = sum((reg,zone),ACZ_input0(reg,zone,crop,type)) ;
 TQSZ_input0(crop,type) = sum((reg,zone),QSZ_input0(reg,zone,crop,type)) ;
 TYCZ_input0(c,type)$TACZ_input0(c,type) = 1000*TQSZ_input0(c,type)/TACZ_input0(c,type) ;

 chkACZ_input(reg,zone,crop) = sum(type,ACZ_input0(reg,zone,crop,type)) - ACZ0(reg,zone,crop) ;
 chkQSZ_input(reg,zone,crop) = sum(type,QSZ_input0(reg,zone,crop,type)) - QSZ0(reg,zone,crop) ;

 chkRYCZ_input(reg,crop,inptype)$RYCZ_input0(reg,crop,'none') = RYCZ_input0(reg,crop,inptype)/RYCZ_input0(reg,crop,'none') ;
 chkTYCZ_input(crop,inptype)$TYCZ_input0(crop,'none') = TYCZ_input0(crop,inptype)/TYCZ_input0(crop,'none') ;

 ZeroACZ_input0(reg,zone,Crop,type)$(ACZ_input0(reg,zone,Crop,type) and QSZ_input0(reg,zone,Crop,type) eq 0) =
                     ACZ_input0(reg,zone,Crop,type) ;
 ZeroQSZ_input0(reg,zone,Crop,type)$(ACZ_input0(reg,zone,Crop,type) eq 0 and QSZ_input0(reg,zone,Crop,type)) =
                     QSZ_input0(reg,zone,Crop,type) ;

display ZeroACZ_input0, ZeroQSZ_input0, chkACZ_input,  chkQSZ_input, chkTYCZ_input, chkRYCZ_input,
chkYCZ_input, TYCZ_input0, RYCZ_input0, YCZ_input0 ;


*====
*Calculating share after adjustment

 ACZ_inputSh0(reg,zone,c,type)$ACZ_input0(reg,zone,c,type) =
              100*ACZ_input0(reg,zone,c,type)/sum(typep,ACZ_input0(reg,zone,c,typep));
 QSZ_inputSh0(reg,zone,c,type)$QSZ_input0(reg,zone,c,type) =
              100*QSZ_input0(reg,zone,c,type)/sum(typep,QSZ_input0(reg,zone,c,typep));

 RACZ_inputSh0(reg,c,type)$RACZ_input0(reg,c,type) =
              100*RACZ_input0(reg,c,type)/sum((zone,typep),ACZ_input0(reg,zone,c,typep));
 RQSZ_inputSh0(reg,c,type)$RQSZ_input0(reg,c,type) =
              100*RQSZ_input0(reg,c,type)/sum((zone,typep),QSZ_input0(reg,zone,c,typep));

 TACZ_inputSh0(c,type)$TACZ_input0(c,type) =
              100*TACZ_input0(c,type)/sum((reg,zone,typep),ACZ_input0(reg,zone,c,typep));
 TQSZ_inputSh0(c,type)$TQSZ_input0(c,type) =
              100*TQSZ_input0(c,type)/sum((reg,zone,typep),QSZ_input0(reg,zone,c,typep));

 ACZ_inputType0(reg,zone,crop,'fert') = sum(Ftype, ACZ_input0(reg,zone,crop,Ftype));
 ACZ_inputType0(reg,zone,crop,'irri') = sum(Wtype, ACZ_input0(reg,zone,crop,Wtype));
 ACZ_inputType0(reg,zone,crop,'seed') = sum(Stype, ACZ_input0(reg,zone,crop,Stype));
 ACZ_inputType0(reg,zone,crop,'pest') = sum(Ptype, ACZ_input0(reg,zone,crop,Ptype));

 QSZ_inputType0(reg,zone,crop,'fert') = sum(Ftype, QSZ_input0(reg,zone,crop,Ftype));
 QSZ_inputType0(reg,zone,crop,'irri') = sum(Wtype, QSZ_input0(reg,zone,crop,Wtype));
 QSZ_inputType0(reg,zone,crop,'seed') = sum(Stype, QSZ_input0(reg,zone,crop,Stype));
 QSZ_inputType0(reg,zone,crop,'pest') = sum(Ptype, QSZ_input0(reg,zone,crop,Ptype));

 YCZ_inputType0(reg,zone,c,type)$ACZ_inputType0(reg,zone,c,type) =
              1000*QSZ_inputType0(reg,zone,c,type)/ACZ_inputType0(reg,zone,c,type);

 ACZ_inputTypeSh0(reg,zone,c,type)$ACZ_inputType0(reg,zone,c,type) =
              100*ACZ_inputType0(reg,zone,c,type)/sum(typep,ACZ_input0(reg,zone,c,typep));
 QSZ_inputTypeSh0(reg,zone,c,type)$QSZ_inputType0(reg,zone,c,type) =
              100*QSZ_inputType0(reg,zone,c,type)/sum(typep,QSZ_input0(reg,zone,c,typep));

 RACZ_inputType0(reg,crop,'fert') = sum((zone,Ftype), ACZ_input0(reg,zone,crop,Ftype));
 RACZ_inputType0(reg,crop,'irri') = sum((zone,Wtype), ACZ_input0(reg,zone,crop,Wtype));
 RACZ_inputType0(reg,crop,'seed') = sum((zone,Stype), ACZ_input0(reg,zone,crop,Stype));
 RACZ_inputType0(reg,crop,'pest') = sum((zone,Ptype), ACZ_input0(reg,zone,crop,Ptype));

 RQSZ_inputType0(reg,crop,'fert') = sum((zone,Ftype), QSZ_input0(reg,zone,crop,Ftype));
 RQSZ_inputType0(reg,crop,'irri') = sum((zone,Wtype), QSZ_input0(reg,zone,crop,Wtype));
 RQSZ_inputType0(reg,crop,'seed') = sum((zone,Stype), QSZ_input0(reg,zone,crop,Stype));
 RQSZ_inputType0(reg,crop,'pest') = sum((zone,Ptype), QSZ_input0(reg,zone,crop,Ptype));

 RYCZ_inputType0(reg,c,type)$RACZ_inputType0(reg,c,type) =
              1000*RQSZ_inputType0(reg,c,type)/RACZ_inputType0(reg,c,type);

 RACZ_inputTypeSh0(reg,c,type)$RACZ_inputType0(reg,c,type) =
              100*RACZ_inputType0(reg,c,type)/sum((zone,typep),ACZ_input0(reg,zone,c,typep));
 RQSZ_inputTypeSh0(reg,c,type)$RQSZ_inputType0(reg,c,type) =
              100*RQSZ_inputType0(reg,c,type)/sum((zone,typep),QSZ_input0(reg,zone,c,typep));

 TACZ_inputType0(crop,'fert') = sum((reg,zone,Ftype), ACZ_input0(reg,zone,crop,Ftype));
 TACZ_inputType0(crop,'irri') = sum((reg,zone,Wtype), ACZ_input0(reg,zone,crop,Wtype));
 TACZ_inputType0(crop,'seed') = sum((reg,zone,Stype), ACZ_input0(reg,zone,crop,Stype));
 TACZ_inputType0(crop,'pest') = sum((reg,zone,Ptype), ACZ_input0(reg,zone,crop,Ptype));
 TQSZ_inputType0(crop,'fert') = sum((reg,zone,Ftype), QSZ_input0(reg,zone,crop,Ftype));
 TQSZ_inputType0(crop,'irri') = sum((reg,zone,Wtype), QSZ_input0(reg,zone,crop,Wtype));
 TQSZ_inputType0(crop,'seed') = sum((reg,zone,Stype), QSZ_input0(reg,zone,crop,Stype));
 TQSZ_inputType0(crop,'pest') = sum((reg,zone,Ptype), QSZ_input0(reg,zone,crop,Ptype));

 TYCZ_inputType0(c,type)$TACZ_inputType0(c,type) =
              1000*TQSZ_inputType0(c,type)/TACZ_inputType0(c,type);

 TACZ_inputTypeSh0(c,type)$TACZ_inputType0(c,type) =
              100*TACZ_inputType0(c,type)/sum((reg,zone,typep),ACZ_input0(reg,zone,c,typep));

 TQSZ_inputTypeSh0(c,type)$TQSZ_inputType0(c,type) =
              100*TQSZ_inputType0(c,type)/sum((reg,zone,typep),QSZ_input0(reg,zone,c,typep));

*==== Elas - yield, area, supply(output) ==============================
parameter
chkeap(reg,zone,c)            sum(cp eap0(reg zone c cp)) + eyp0(reg zone c)
chkesp(reg,zone,c)            sum(cp esp0(reg zone c cp))
chkland(reg,zone,c)           sum(agp landshare(reg zone agp)*eap0(reg zone agp ag))
voutputshare(reg,zone,c)      volume ($) of output share of c for each zone
landshare(reg,zone,c)         ag area share of ag c for each zone
owneap0(reg,zone,c)           own area elas
ownesp0(reg,zone,c)           own supply eals
chkay0(reg,zone,c)            check yield intercept (should be zero)
chkaa0(reg,zone,c)            check area intercept  (should be zero)
chkas0(reg,zone,c)            check supply intercept(should be zero)
;

voutputshare(reg,zone,ag)$QSZ0(reg,zone,ag) = PPZ0(reg,zone,ag)*QSZ0(reg,zone,ag)/sum(agp,PPZ0(reg,zone,agp)*QSZ0(reg,zone,agp));
landshare(reg,zone,ag)$ACZ0(reg,zone,ag)    = ACZ0(reg,zone,ag)/sum(agp,ACZ0(reg,zone,agp));

eyp0(reg,zone,c)$ACZ0(reg,zone,c)   = eyp0(reg,zone,c) ;
eap0(reg,zone,c,c)$ACZ0(reg,zone,c) = eyp0(reg,zone,c) ;
esp0(reg,zone,c,cp) = 0 ;
esp0(reg,zone,lv,lv)$QSZ0(reg,zone,lv)    = eyp0(reg,zone,lv) ;
esp0(reg,zone,nag,nag)$QSZ0(reg,zone,nag) = eyp0(reg,zone,nag) ;


eap0(reg,zone,c,cp)$(ACZ0(reg,zone,c) and ACZ0(reg,zone,cp)) = -voutputshare(reg,zone,cp)*eyp0(reg,zone,c)/1.0 ;
eap0(reg,zone,cp,c)$(ACZ0(reg,zone,c) and ACZ0(reg,zone,cp)) = -voutputshare(reg,zone,c)*eyp0(reg,zone,cp)/1.0 ;
eap0(reg,zone,cereal,cerealp)$(ACZ0(reg,zone,cereal) and ACZ0(reg,zone,cerealp)) =
            -voutputshare(reg,zone,cerealp)*eyp0(reg,zone,cereal)/1.0 ;
eap0(reg,zone,cerealp,cereal)$(ACZ0(reg,zone,cereal) and ACZ0(reg,zone,cerealp)) =
            -voutputshare(reg,zone,cereal)*eyp0(reg,zone,cerealp)/1.0 ;
eap0(reg,zone,c,cp)$(ACZ0(reg,zone,c) eq 0 or ACZ0(reg,zone,cp) eq 0) = 0 ;
eap0(reg,zone,cereal,lv)$ACZ0(reg,zone,cereal) = voutputshare(reg,zone,cereal)*eyp0(reg,zone,cereal)/56 ;
eap0(reg,zone,c,nag) = 0 ;
eap0(reg,zone,lv,c)  = 0 ;
eap0(reg,zone,nag,c) = 0 ;

eap0(reg,zone,c,c)$ACZ0(reg,zone,c) = eyp0(reg,zone,c) ;

esp0(reg,zone,lv,cereal)  =
      -0.1*sum((regp,zonep),QSZ0(regp,zonep,cereal))/sum((regp,zonep,cerealp),QSZ0(regp,zonep,cerealp))*eyp0(reg,zone,lv) ;

esp0(reg,zone,nag,cereal) =
      -0.1*sum((regp,zonep),QSZ0(regp,zonep,cereal))/sum((regp,zonep,cerealp),QSZ0(regp,zonep,cerealp))*eyp0(reg,zone,nag) ;
esp0(reg,zone,nag,lv)     =
      -0.1*sum((regp,zonep),QSZ0(regp,zonep,lv))/sum((regp,zonep,lvp),QSZ0(regp,zonep,lvp))*eyp0(reg,zone,nag) ;

esp0(reg,zone,nag,ntradition) =
      -0.025*sum((regp,zonep),QSZ0(regp,zonep,ntradition))/sum((regp,zonep,ntraditionp),QSZ0(regp,zonep,ntraditionp))*eyp0(reg,zone,nag) ;
esp0(reg,zone,nag,oilseed)    =
      -0.035*sum((regp,zonep),QSZ0(regp,zonep,oilseed))/sum((regp,zonep,oilseedp),QSZ0(regp,zonep,oilseedp))*eyp0(reg,zone,nag) ;

chkeap(reg,zone,c)$ACZ0(reg,zone,c)      = sum(cp,eap0(reg,zone,c,cp)) + eyp0(reg,zone,c);
*chkeap(reg,zone,c)$ACZ0(reg,zone,c)     = sum(cp,eap0(reg,zone,c,cp)) ;
chkland(reg,zone,ag)$ACZ0(reg,zone,ag)   = sum(agp,landshare(reg,zone,agp)*eap0(reg,zone,agp,ag));

display voutputshare, landshare, chkeap, chkland, eyp0;

eap0(reg,zone,c,c)$ACZ0(reg,zone,c)      = eap0(reg,zone,c,c) - chkland(reg,zone,c) ;
eyp0(reg,zone,c)$ACZ0(reg,zone,c)        = eyp0(reg,zone,c) - 0.5*chkeap(reg,zone,c) ;
eap0(reg,zone,c,c)$ACZ0(reg,zone,c)      = eap0(reg,zone,c,c) - 0.5*chkeap(reg,zone,c) ;
eap0(reg,zone,c,'nagntrade') = 0 ;

chkeap(reg,zone,c)$ACZ0(reg,zone,c)      = sum(cp,eap0(reg,zone,c,cp)) + eyp0(reg,zone,c);
*chkeap(reg,zone,c)$ACZ0(reg,zone,c)     = sum(cp,eap0(reg,zone,c,cp)) ;
chkland(reg,zone,ag)$ACZ0(reg,zone,ag)   = sum(agp,landshare(reg,zone,agp)*eap0(reg,zone,agp,ag));

eap0(reg,zone,c,c)$ACZ0(reg,zone,c)      = eap0(reg,zone,c,c) - chkland(reg,zone,c) ;
chkland(reg,zone,ag)$ACZ0(reg,zone,ag)   = sum(agp,landshare(reg,zone,agp)*eap0(reg,zone,agp,ag));

eap0(reg,zone,c,c)$ACZ0(reg,zone,c)      = eap0(reg,zone,c,c) - chkland(reg,zone,c) ;
chkland(reg,zone,ag)$ACZ0(reg,zone,ag)   = sum(agp,landshare(reg,zone,agp)*eap0(reg,zone,agp,ag));

eap0(reg,zone,c,c)$ACZ0(reg,zone,c)      = eap0(reg,zone,c,c) - chkland(reg,zone,c) ;
chkland(reg,zone,ag)$ACZ0(reg,zone,ag)   = sum(agp,landshare(reg,zone,agp)*eap0(reg,zone,agp,ag));

eyp0(reg,zone,ag)$ACZ0(reg,zone,ag)      =  eyp0(reg,zone,ag) - chkland(reg,zone,ag) ;

chkeap(reg,zone,c)$ACZ0(reg,zone,c)      = sum(cp,eap0(reg,zone,c,cp)) + eyp0(reg,zone,c);

eyp0(reg,zone,c)$ACZ0(reg,zone,c)        =  eyp0(reg,zone,c) - 0.5*chkeap(reg,zone,c) ;
eap0(reg,zone,c,c)$ACZ0(reg,zone,c)      = eap0(reg,zone,c,c) - 0.5*chkeap(reg,zone,c) ;

chkland(reg,zone,ag)$ACZ0(reg,zone,ag)   = sum(agp,landshare(reg,zone,agp)*eap0(reg,zone,agp,ag));

eap0(reg,zone,c,c)$ACZ0(reg,zone,c)      = eap0(reg,zone,c,c) - chkland(reg,zone,c) ;
eap0(reg,zone,c,c)$(ACZ0(reg,zone,c) and eap0(reg,zone,c,c) lt 0) = 0.01 ;

chkland(reg,zone,ag)$ACZ0(reg,zone,ag)   = sum(agp,landshare(reg,zone,agp)*eap0(reg,zone,agp,ag));

eyp0(reg,zone,ag)$ACZ0(reg,zone,ag)      =  eyp0(reg,zone,ag) - chkland(reg,zone,ag) ;
eyp0(reg,zone,ag)$(ACZ0(reg,zone,ag) and eyp0(reg,zone,ag) lt 0) = 0.01 ;

chkeap(reg,zone,c)$ACZ0(reg,zone,c)      = sum(cp,eap0(reg,zone,c,cp)) + eyp0(reg,zone,c);
chkland(reg,zone,ag)$ACZ0(reg,zone,ag)   = sum(agp,landshare(reg,zone,agp)*eap0(reg,zone,agp,ag));

owneap0(reg,zone,c)  = eap0(reg,zone,c,c) ;

esp0(reg,zone,lv,lvp)$(QSZ0(reg,zone,lv) and QSZ0(reg,zone,lvp)) = -voutputshare(reg,zone,lv)*eyp0(reg,zone,lv)/0.5 ;
esp0(reg,zone,lv,lv)$QSZ0(reg,zone,lv)    = eyp0(reg,zone,lv) ;
chkesp(reg,zone,c)$QSZ0(reg,zone,c)       = sum(cp,esp0(reg,zone,c,cp)) ;

esp0(reg,zone,lv,lv)$QSZ0(reg,zone,lv)    = eyp0(reg,zone,lv) - chkesp(reg,zone,lv);
esp0(reg,zone,nag,nag)$QSZ0(reg,zone,nag) = eyp0(reg,zone,nag) - chkesp(reg,zone,nag);
chkesp(reg,zone,c)$QSZ0(reg,zone,c)       = sum(cp,esp0(reg,zone,c,cp)) ;

ownesp0(reg,zone,c) = esp0(reg,zone,c,c) ;

display chkeap, chkland, chkesp, eyp0, owneap0, ownesp0, esp0;

*=== Interception of supply funciton
*=== Bring in rainfall effect on yield
* assign values to variables
eap(reg,zone,c,cp) = eap0(reg,zone,c,cp);
eyp(reg,zone,c)    = eyp0(reg,zone,c);
esp(reg,zone,c,cp) = esp0(reg,zone,c,cp);

esp20(reg,zone,c,cp) = 0 ;
esp2(reg,zone,c,cp)  = esp20(reg,zone,c,cp) ;

eypInput0(reg,zone,c,type)$ACZ_input0(reg,zone,c,type)    = eyp(reg,zone,c) ;
eapInput0(reg,zone,c,cp,type)$ACZ_input0(reg,zone,c,type) = eap0(reg,zone,c,cp) ;

*eypInput0(reg,zone,cropInput,'none')$ACZ_input0(reg,zone,cropInput,'none') = 0.1*eyp(reg,zone,cropInput) ;
*eypInput0(reg,zone,cropInput,type)$ACZ_input0(reg,zone,cropInput,type) = 0.1*eyp(reg,zone,cropInput) ;

eypInput(reg,zone,c,type)    = eypInput0(reg,zone,c,type) ;
eapInput(reg,zone,c,cp,type) = eapInput0(reg,zone,c,cp,type) ;

YCZ0(reg,zone,c)$(QSZ0(reg,zone,c) and ACZ0(reg,zone,c)) = 1000*QSZ0(reg,zone,c)/ACZ0(reg,zone,c) ;

QSZirr0(reg,zone,c)$ACZirr0(reg,zone,c) = 1.50*YCZ0(reg,zone,c)*ACZirr0(reg,zone,c)/1000 ;
YCZirr0(reg,zone,c)$(QSZirr0(reg,zone,c) and ACZirr0(reg,zone,c)) = 1000*QSZirr0(reg,zone,c)/ACZirr0(reg,zone,c) ;

*================================

 aa0(reg,zone,c)$(QSZ0(reg,zone,c) and ACZ0(reg,zone,c)) = ACZ0(reg,zone,c)/
                (PROD(CP$QSZ0(reg,zone,cp),(PPZ0(reg,zone,cp)/PPZ0(reg,zone,'nagntrade'))**eap(reg,zone,c,cp)));
* ay0(reg,zone,c)$(QSZ0(reg,zone,c) and ACZ0(reg,zone,c))  = YCZ0(reg,zone,c)/((PPZ0(reg,zone,c)/PPZ0(reg,zone,'nagntrade'))**eyp(reg,zone,c));

 as0(reg,zone,c)$(QSZ0(reg,zone,c) and ACZ0(reg,zone,c) eq 0) = QSZ0(reg,zone,c)/
                (PROD(CP$QSZ0(reg,zone,cp),(PPZ0(reg,zone,cp)/PPZ0(reg,zone,'nagntrade'))**esp(reg,zone,c,cp)));
 as0(reg,zone,'nagntrade')$QSZ0(reg,zone,'nagntrade') = QSZ0(reg,zone,'nagntrade')/
                (PROD(CP$QSZ0(reg,zone,cp),(PPZ0(reg,zone,cp))**esp(reg,zone,'nagntrade',cp)));

* as0(reg,zone,nag)$QSZ0(reg,zone,nag) = QSZ0(reg,zone,nag)/
*                (PROD(CP$QSZ0(reg,zone,cp),(PPZ0(reg,zone,cp))**esp(reg,zone,nag,cp)));

 aaIrr0(reg,zone,c)$(QSZirr0(reg,zone,c) and ACZirr0(reg,zone,c)) = ACZirr0(reg,zone,c)/
                (PROD(CP$QSZ0(reg,zone,cp),(PPZ0(reg,zone,cp)/PPZ0(reg,zone,'nagntrade'))**eap(reg,zone,c,cp)));
 ayIrr0(reg,zone,c)$(QSZirr0(reg,zone,c) and ACZirr0(reg,zone,c))  = YCZirr0(reg,zone,c)/((PPZ0(reg,zone,c)/PPZ0(reg,zone,'nagntrade'))**eyp(reg,zone,c));

* ay0(reg,zone,c)$(Kcmean0(reg,zone,c) and QSZ0(reg,zone,c) and ACZ0(reg,zone,c)) =
*               ay0(reg,zone,c)/Kcmean0(reg,zone,c) ;

 aaInput0(reg,zone,c,type)$(QSZ_input0(reg,zone,c,type) and ACZ_input0(reg,zone,c,type)) = ACZ_input0(reg,zone,c,type)/
                (PROD(CP$QSZ_input0(reg,zone,cp,type),(PPZ0(reg,zone,cp)/PPZ0(reg,zone,'nagntrade'))**eapInput(reg,zone,c,cp,type)));
 ayInput0(reg,zone,c,type)$(QSZ_input0(reg,zone,c,type) and ACZ_input0(reg,zone,c,type))  =
            YCZ_input0(reg,zone,c,type)/((PPZ0(reg,zone,c)/PPZ0(reg,zone,'nagntrade'))**eypInput(reg,zone,c,type));
*===== ying5b  changed it for nwtype only
 ayInput0(reg,zone,c,nwtype)$(Kcmean0(reg,zone,c) and QSZ_input0(reg,zone,c,nwtype) and ACZ_input0(reg,zone,c,nwtype)) =
               ayInput0(reg,zone,c,nwtype)/Kcmean0(reg,zone,c) ;
* ying 6 deal with zero kcmean situation
 ayInput0(reg,zone,c,nwtype)$(Kcmean0(reg,zone,c) eq 0 and QSZ_input0(reg,zone,c,nwtype) and ACZ_input0(reg,zone,c,nwtype)) = 0;
*============


parameter
chkaairr0(reg,zone,c)                  should be zero
chkayirr0(reg,zone,c)                  should be zero
chkaaInput0(reg,zone,c,type)           check aaInput =0 but ACZinput >0 (should not be)
chkayInput0(reg,zone,c,type)           should be zero
chkKcmean(reg,zone,c)                  check when kcmean =0 but ycz>0 (should not be)
;
chkKcmean(reg,zone,c)$(Kcmean0(reg,zone,c) eq 0  and YCZ0(reg,zone,c)) = YCZ0(reg,zone,c) ;
display chkKcmean;

*assign value to parameter enter the MCP model
Kcmean(reg,zone,c) = Kcmean0(reg,zone,c) ;

chkaaInput0(reg,zone,c,type)$(aaInput0(reg,zone,c,type) eq 0 and ACZ_input0(reg,zone,c,type)) = ACZ_input0(reg,zone,c,type) ;
display chkaaInput0;

chkaaInput0(reg,zone,c,type)$(aaInput0(reg,zone,c,type) eq 0 and ACZ_input0(reg,zone,c,type)) = QSZ_input0(reg,zone,c,type) ;
display chkaaInput0;

aa(reg,zone,c)$aa0(reg,zone,c) = aa0(reg,zone,c);
*ay(reg,zone,c)$ay0(reg,zone,c) = ay0(reg,zone,c);
as(reg,zone,c)$as0(reg,zone,c) = as0(reg,zone,c);

aaIrr(reg,zone,c)$aairr0(reg,zone,c) = aaIrr0(reg,zone,c);
ayIrr(reg,zone,c)$ayirr0(reg,zone,c) = ayIrr0(reg,zone,c);

aaInput(reg,zone,c,type) = aaInput0(reg,zone,c,type) ;
ayInput(reg,zone,c,type) = ayInput0(reg,zone,c,type) ;

chkaa0(reg,zone,c)$ACZ0(reg,zone,c)
 = ACZ0(reg,zone,c) - aa(reg,zone,c)*PROD(CP$QSZ0(reg,zone,cp),(PPZ0(reg,zone,cp)/PPZ0(reg,zone,'nagntrade'))**eap(reg,zone,C,CP)) ;
*chkay0(reg,zone,c)$ACZ0(reg,zone,c)
* = YCZ0(reg,zone,c) - ay(reg,zone,c)*Kcmean(reg,zone,c)*(PPZ0(reg,zone,c)/PPZ0(reg,zone,'nagntrade'))**eyp(reg,zone,C) ;
chkas0(reg,zone,c)$(QSZ0(reg,zone,c) and ACZ0(reg,zone,c) eq 0)
 = QSZ0(reg,zone,c) - as(reg,zone,c)*PROD(CP$QSZ0(reg,zone,cp),(PPZ0(reg,zone,cp)/PPZ0(reg,zone,'nagntrade'))**esp(reg,zone,C,CP)) ;


chkaaIrr0(reg,zone,c)$ACZirr0(reg,zone,c)
  = ACZirr0(reg,zone,c) - aaIrr(reg,zone,c)*PROD(CP$QSZ0(reg,zone,cp),(PPZ0(reg,zone,cp)/PPZ0(reg,zone,'nagntrade'))**eap(reg,zone,C,CP)) ;

chkayIrr0(reg,zone,c)$ACZirr0(reg,zone,c)
  = YCZirr0(reg,zone,c) - ayIrr(reg,zone,c)*(PPZ0(reg,zone,c)/PPZ0(reg,zone,'nagntrade'))**eyp(reg,zone,C) ;

chkaaInput0(reg,zone,c,type)$ACZ_input0(reg,zone,c,type)
  = ACZ_input0(reg,zone,c,type) - aaInput(reg,zone,c,type)*
                (PROD(CP$QSZ_input0(reg,zone,cp,type),(PPZ0(reg,zone,cp)/PPZ0(reg,zone,'nagntrade'))**eapInput(reg,zone,c,cp,type)));
chkayInput0(reg,zone,c,type)$ACZ_input0(reg,zone,c,type)
  = YCZ_input0(reg,zone,c,type) - ayInput(reg,zone,c,type)*Kcmean(reg,zone,c)*((PPZ0(reg,zone,c)/PPZ0(reg,zone,'nagntrade'))**eypInput(reg,zone,c,type));

display aa0, aaIrr0,  ayIrr0, as0, YCZ0, qsz0, acz0, chkaa0, chkaaIrr0, chkayIrr0, chkas0, chkaaInput0, chkayInput0, Kcmean;

parameter
chkWal(reg,zone)      zonal volume($) of demand minus supply
chkTwalR(reg)         regional volume($) of demand minus supply
chkTwal               total volume($) of demand minus supply
chkAgwal              total Ag volume($) of demand minus supply
chkAgWal2             total Ag volume of demand minus supply
chkGrainwal           total cereal volume($) of demand minus supply
chkGrainWal2          total cereal volume of demand minus supply
chkLvwal              total livestock volume($) of demand minus supply
chkLvWal2             total livestock volume of demand minus supply
chkwalComm(c)         total volume($) of demand minus supply for each comm
chkWalComm2(c)        total volume of demand minus supply for each comm
;

*chkWal(reg,zone) = sum(c,PC0(c)*(QFZ0(reg,zone,c) + QLZ0(reg,zone,c) + QOZ0(reg,zone,c) - QSZ0(reg,zone,c)));
*chkWal(reg,zone) = sum(c,PCZ0(reg,zone,c)*(QFZ0(reg,zone,c) + QLZ0(reg,zone,c) + QOZ0(reg,zone,c)) - PPZ0(reg,zone,c)*QSZ0(reg,zone,c));
chkWal(reg,zone) = sum(c,PCZ0(reg,zone,c)*(QFZ0(reg,zone,c) -QSZ0(reg,zone,c)));
chkTWalR(reg)    = sum(zone,chkWal(reg,zone));
chkTWal          = sum(reg,chkTWalR(reg));
chkAgWal         = sum((reg,zone,ag),PCZ0(reg,zone,ag)*(QFZ0(reg,zone,ag) + QLZ0(reg,zone,ag) + QOZ0(reg,zone,ag)- QSZ0(reg,zone,ag)));
chkGrainWal      = sum((reg,zone,cereal),PCZ0(reg,zone,cereal)*(QFZ0(reg,zone,cereal) + QLZ0(reg,zone,cereal) + QOZ0(reg,zone,cereal)- QSZ0(reg,zone,cereal)));
chkLvWal         = sum((reg,zone,lv),PCZ0(reg,zone,lv)*(QFZ0(reg,zone,lv) + QLZ0(reg,zone,lv) + QOZ0(reg,zone,lv)- QSZ0(reg,zone,lv)));
chkWalComm(c)    = sum((reg,zone),PCZ0(reg,zone,c)*(QFZ0(reg,zone,c) + QLZ0(reg,zone,c) + QOZ0(reg,zone,c)- QSZ0(reg,zone,c)));

display chkAgwal, chkGrainwal, chkLvwal, chkTwal, chkTwalR, chkWal, chkWalComm;

chkAgWal2         = sum((reg,zone,ag),(QFZ0(reg,zone,ag) + QLZ0(reg,zone,ag) + QOZ0(reg,zone,ag)- QSZ0(reg,zone,ag)));
chkGrainWal2      = sum((reg,zone,cereal),(QFZ0(reg,zone,cereal) + QLZ0(reg,zone,cereal) + QOZ0(reg,zone,cereal)- QSZ0(reg,zone,cereal)));
chkLvWal2         = sum((reg,zone,lv),(QFZ0(reg,zone,lv) + QLZ0(reg,zone,lv) + QOZ0(reg,zone,lv)- QSZ0(reg,zone,lv)));
chkWalComm2(c)    = sum((reg,zone),(QFZ0(reg,zone,c) + QLZ0(reg,zone,c) + QOZ0(reg,zone,c)- QSZ0(reg,zone,c)));
display chkAgwal2, chkGrainwal2, chkLvwal2, chkWalComm2;

*========== Calories ====================
pmaln0           = 47.0 ;
melas            = -1.5*25.24;
ninfant          = ninfant0;
nmaln0           = pmaln0*ninfant0/100 ;

CALPC0(c)        = 10*KcalRatio(c)*TQFpc0(c)/365 ;
TCALPC0          = sum(c,CALPC0(c) ) ;
intermal         = pmaln0 - melas*log(TCALPC0) ;

*====================

display
texpendpc0, GDPPC0, expendrpc0, GDPrPC0, expendzpc0, GDPZPC0,
Agexpendpc0, AgGDPPC0, Agexpendrpc0, AgGDPrPC0, Agexpendzpc0, AgGDPZPC0,
QFZpc0,totnag,dqmzratio, dqezratio, dqmz0, dqez0
comparPCZ, comparPCZ2
comparPPZ, comparPPZ2
;

display
PW0
HHIshare
chkincomeag, chkincomenag, incomeagPC0, incomenagPC0, GDPZHPC0, GDPRPC0, GDPPC0
Tpop0, PopUrb0, chkUrbshare, PopRurshare
zeroTQS, zeroQF, chkyield
totdata
TQFpc0, TQSpc0
TQS0, TAC0, TYC0, QT0, TQF0, TQL0, TQO0,QM0, QE0
Tpop0, PopUrb0
GDP0, AgrGDP0, IndGDP0, SerGDP0
zoneareashare, zoneoutputshare, chkzonearea, chkzoneoutput
PopZ0, PopRurshare
;

* add by ying
*parameter
*GAPZint(reg,zone,c)
*;
*GAPZint(reg,zone,c) =  gapZ0(reg,zone,c);
*===

*===============================
* Variables and equations

VARIABLES
 PP(c)              Domestic producer prices
 PC(c)              Domestic consumer prices
 PPZ(reg,zone,c)    Domestic producer prices
 PCZ(reg,zone,c)    Domestic consumer prices
 PPAVGR(reg,c)      Average domestic producer prices by region
 PPAVG(c)           Average domestic producer prices at national level

 QFZ(reg,zone,c)            Total Food demand
 QFZH(reg,zone,urbrur,c)    Total Food demand
 QFZpc(reg,zone,c)          per capita Food demand
 QFZHpc(reg,zone,urbrur,c)  per capita Food demand

 QLZ(reg,zone,c)    Total feed demand
 QOZ(reg,zone,c)    Total other demand
 QDZ(reg,zone,c)    Total demand
 ACZ(reg,zone,c)    Area response - non-byproduct crops - by zone
 YCZ(reg,zone,c)    Yield response - non-byproduct crops
 QSZ(reg,zone,c)    Total supply - by zone

 ACZ_input(reg,zone,c,type)    Area response - non-byproduct crops - by zone
 YCZ_input(reg,zone,c,type)    Yield response - non-byproduct crops
 QSZ_input(reg,zone,c,type)    Total supply - by zone

 TQS(c)             total supply
 TAC(c)             total area by crop
 TACZ(reg,zone)     total area by zone
 QT(c)              Volume of net trade positive is imports

 GDPZpc(reg,zone)           per capita income zonal level
 GDPZ(reg,zone)             income zonal level
 GDPZHpc(reg,zone,urbrur)   per capita income zonal level
 GDPZH(reg,zone,urbrur)     income zonal level

 EXR                 exchange rate
 CPI                 consumer price index
 DUMMY(reg,zone,c)   a dummy variable
 ToTmargz(reg,zone)  Total domestic trade margins
 DQTZ(reg,zone,c)    zonal level deficit by crop
*add by ying
* GAPZ(reg,zone,c)    price gap compared to central market in Addis (deficit zone should be positive gap)
*===

POSITIVE VARIABLES
 QM(c)              Volume of net imports
 QE(c)              Volume of net exports
 DQMZ(reg,zone,c)   zonal level deficit by crop
 DQEZ(reg,zone,c)   zonal level surplus by crop


;


 PP.L(c)                = PP0(c);
 PC.L(c)                = PC0(c);
 PPZ.L(reg,zone,c)      = PPZ0(reg,zone,c);
 PCZ.L(reg,zone,c)      = PCZ0(reg,zone,c);
 PPAVGR.L(reg,c)        = PPAVGR0(reg,c);
 PPAVG.L(c)             = PPAVG0(c);

 QFZpc.L(reg,zone,c)             = QFZpc0(reg,zone,c);
 QFZHpc.L(reg,zone,urbrur,c)     = QFZHpc0(reg,zone,urbrur,c);
 QFZ.L(reg,zone,c)               = QFZ0(reg,zone,c);
 QFZH.L(reg,zone,urbrur,c)       = QFZH0(reg,zone,urbrur,c);

 QLZ.L(reg,zone,c)      = QLZ0(reg,zone,c);
 QOZ.L(reg,zone,c)      = QOZ0(reg,zone,c);
 QDZ.L(reg,zone,c)      = QDZ0(reg,zone,c);
 ACZ.L(reg,zone,c)      = ACZ0(reg,zone,c);
 YCZ.L(reg,zone,c)      = YCZ0(reg,zone,c);
 QSZ.L(reg,zone,c)      = QSZ0(reg,zone,c);

 ACZ_input.L(reg,zone,c,type)    = ACZ_input0(reg,zone,c,type);
 YCZ_input.L(reg,zone,c,type)    = YCZ_input0(reg,zone,c,type);
 QSZ_input.L(reg,zone,c,type)    = QSZ_input0(reg,zone,c,type);

 TQS.L(C)               = sum((reg,zone),QSZ0(reg,zone,c));
 TAC.L(C)               = sum((reg,zone),ACZ0(reg,zone,c));
 TACZ.L(reg,zone)       = sum(c,ACZ0(reg,zone,c));
 QM.L(C)                = QM0(C);
 QE.L(C)                = QE0(C);
 QT.L(C)                = QT0(C);

*$libinclude xldump ACZirr0 OrigAreas.xls Irri;

 totmargz.L(reg,zone)$sum(c,QFZ0(reg,zone,c)) = totmargz0(reg,zone) ;

 DQMZ.L(reg,zone,c) = DQMZ0(reg,zone,c);
 DQEZ.L(reg,zone,c) = DQEZ0(reg,zone,c);
 DQTZ.L(reg,zone,c) = DQTZ0(reg,zone,c);

 GDPZ.L(reg,zone)                = GDPZ0(reg,zone) ;
 GDPZH.L(reg,zone,urbrur)        = GDPZH0(reg,zone,urbrur) ;
 GDPZpc.L(reg,zone)              = GDPZpc0(reg,zone) ;
 GDPZHpc.L(reg,zone,urbrur)      = GDPZHpc0(reg,zone,urbrur) ;

 EXR.L                   = EXR0 ;
 DUMMY.L(reg,zone,c)     = 0 ;
 CPI.L$sum((reg,zone,c),QFZ0(reg,zone,c))
                = sum((reg,zone,c),PC0(c)*QFZ0(reg,zone,c))/
                  sum((reg,zone,c),PC0(c)*QFZ0(reg,zone,c)) ;
*add by ying
* GAPZ.L(reg,zone,c) =  gapZ0(reg,zone,c);
*====


EQUATIONS
 CPIEQ
 QFZpcEQ  per capita Food demand equation by zone
 QFZHpcEQ  per capita Food demand equation by zone
 QFZEQ    Total Food demand equation by zone
 QLZEQ    Total Feed demand equation by zone
 QOZEQ    Total Other demand equation by zone
 QDZEQ    Total demand equation  by zone
 QDZEQ2    Total demand equation  by zone
 QDZEQ3    Total demand equation  by zone
 ACZEQ    Area equation by crop and zone
 YCZEQ    Yield equation  by crop and zone
 QSZCREQ  supply equation for crop

 ACZ_inputEQ    Area equation by crop and zone
 YCZ_inputEQ1    Yield equation  by crop and zone For KcMean = 1 (water type)
 YCZ_inputEQ2    Yield equation  by crop and zone For KcMean < 1 (nonwater type)
 QSZ_inputEQ    supply equation for crop

 QSZNCREQ supply equation for noncrop
 QSZNAGEQ supply equation for nagntrade
 TACEQ    Total area by crop
 TACZEQ   total area by zone
 TQSEQ    total supply

 PCEQ      PC equation
 PCZEQ     PCZ equation
 PPZEQ     PPZ equation

 MARGEQ    total marging equation by zone
 GDPZRurPcEQ  per capita GDP equation by zone
 GDPZUrbPcEQ  per capita GDP equation by zone
 GDPZUrbPcEQ2  per capita GDP equation by zone
 GDPZHEQ  per capita GDP equation by zone
 GDPZpcEQ  per capita GDP equation by zone

 EXPTEQ    export define
 IMPTEQ    import define

 TRADEEQ   trade equation
 BALZEQ     commodity balance equation

*add by ying
*GAPZEQ     gap equation
*GAPZEQ2
*===
 ;


*===Equation defined
CPIEQ..
CPI =E= sum((reg,zone,c),PC.L(c)*QFZ0(reg,zone,c))/
         sum((reg,zone,c),PC0(c)*QFZ0(reg,zone,c)) ;

*QFZHpcEQ(reg,zone,urbrur,c)$QFZH0(reg,zone,urbrur,c)..
*   QFZHpc(reg,zone,urbrur,c) =E= afH(reg,zone,urbrur,c)*(PROD(CP$QFZH0(reg,zone,urbrur,cp),PCZ(reg,zone,cp)**edfpH(reg,zone,urbrur,C,CP)) *
*           (GDPZHpc(reg,zone,urbrur)/CPI)**edfiZH(reg,zone,urbrur,c)) ;

* == ying
QFZHpcEQ(reg,zone,urbrur,c)$(QFZH0(reg,zone,urbrur,c) and PCZ0(reg,zone,c) and GDPZHpc0(reg,zone,urbrur))..
   QFZHpc(reg,zone,urbrur,c) =E= afH(reg,zone,urbrur,c)*(PROD(CP$QFZH0(reg,zone,urbrur,cp),PCZ(reg,zone,cp)**edfpH(reg,zone,urbrur,C,CP)) *
           (GDPZHpc(reg,zone,urbrur)/CPI)**edfiZH(reg,zone,urbrur,c)) ;
*===

QFZEQ(reg,zone,c)$QFZ0(reg,zone,c)..
   QFZ(reg,zone,c) =E= sum(urbrur$QFZHpc0(reg,zone,urbrur,c),
     (QFZHpc(reg,zone,urbrur,c))*PopH(reg,zone,urbrur)) ;

 QFZpcEQ(reg,zone,c)$QFZ0(reg,zone,c)..
   QFZpc(reg,zone,c) =E= QFZ(reg,zone,c)/sum(urbrur,PopH(reg,zone,urbrur)) ;

QLZEQ(reg,zone,c)$QLZ0(reg,zone,c)..
   QLZ(reg,zone,c) =E= QLZshare(reg,zone,c)*sum(lv$QSZ0(reg,zone,lv),QSZ(reg,zone,lv))/PCZ(reg,zone,c) ;

QOZEQ(reg,zone,c)$QOZ0(reg,zone,c)..
   QOZ(reg,zone,c) =E= QOZshare(reg,zone,c)*QSZ(reg,zone,c)/PCZ(reg,zone,c) ;


QDZEQ(Naddis,Naddiszone,c)$QDZ0(Naddis,Naddiszone,c)..
   QDZ(Naddis,Naddiszone,c) =E= QFZ(Naddis,Naddiszone,c) + QLZ(Naddis,Naddiszone,c) + QOZ(Naddis,Naddiszone,c) ;

QDZEQ2(c)$QDZ0('addisAbaba','addis1',c)..
   QDZ('addisAbaba','addis1',c) =E= QFZ('addisAbaba','addis1',c) + QLZ('addisAbaba','addis1',c) + QOZ('addisAbaba','addis1',c) ;


QDZEQ3(c)$(QDZ0('addisAbaba','addis2',c))..
   QDZ('addisAbaba','addis2',c) =E= QFZ('addisAbaba','addis2',c) + QLZ('addisAbaba','addis2',c) + QOZ('addisAbaba','addis2',c) ;


ACZ_inputEQ(reg,zone,c,type)$(ACZ_input0(reg,zone,c,type))..
  ACZ_input(reg,zone,c,type) =E= aaInput(reg,zone,c,type)*
   PROD(CP$QSZ_input0(reg,zone,cp,type),(PPZ(reg,zone,cp)/PPZ(reg,zone,'nagntrade'))**eapInput(reg,zone,C,CP,type)) ;
*===== ying5
YCZ_inputEQ1(reg,zone,c,wtype)$(ACZ_input0(reg,zone,c,wtype))..
  YCZ_input(reg,zone,c,wtype) =E= ayInput(reg,zone,c,wtype)*1*
             (PPZ(reg,zone,c)/PPZ(reg,zone,'nagntrade'))**eypInput(reg,zone,c,wtype) ;

*  YCZ_input(reg,zone,c,wtype) =E= ayInput(reg,zone,c,wtype)*Kcmean(reg,zone,c)*
*             (PPZ(reg,zone,c)/PPZ(reg,zone,'nagntrade'))**eypInput(reg,zone,c,wtype) ;
*=============
YCZ_inputEQ2(reg,zone,c,nwtype)$(ACZ_input0(reg,zone,c,nwtype))..
  YCZ_input(reg,zone,c,nwtype) =E= ayInput(reg,zone,c,nwtype)*Kcmean(reg,zone,c)*
             (PPZ(reg,zone,c)/PPZ(reg,zone,'nagntrade'))**eypInput(reg,zone,c,nwtype) ;

QSZ_inputEQ(reg,zone,c,type)$(ACZ_input0(reg,zone,c,type))..
  QSZ_input(reg,zone,c,type) =E= YCZ_input(reg,zone,c,type)*ACZ_input(reg,zone,c,type)/1000;

ACZEQ(reg,zone,c)$(QSZ0(reg,zone,c) and ACZ0(reg,zone,c))..
*  ACZ(reg,zone,c) =E= aa(reg,zone,c)*PROD(CP$QSZ0(reg,zone,cp),(PPZ(reg,zone,cp)/PPZ(reg,zone,'nagntrade'))**eap(reg,zone,C,CP)) ;
*  ACZ(reg,zone,c) =E= ACZdry(reg,zone,c) + ACZirr(reg,zone,c);
  ACZ(reg,zone,c) =E= sum(type$ACZ_input0(reg,zone,c,type),ACZ_input(reg,zone,c,type)) ;

* ying3 - check this * YCZ
YCZEQ(reg,zone,c)$ACZ0(reg,zone,c)..
*  YCZ(reg,zone,c) =E= ay(reg,zone,c)*Kcmean(reg,zone,c)*(PPZ(reg,zone,c)/PPZ(reg,zone,'nagntrade'))**eyp(reg,zone,C) ;
  YCZ(reg,zone,c) =E= 1000*sum(type$QSZ_input0(reg,zone,c,type),QSZ_input(reg,zone,c,type))/
                 sum(type$ACZ_input0(reg,zone,c,type),ACZ_input(reg,zone,c,type)) ;

QSZCREQ(reg,zone,c)$(QSZ0(reg,zone,c) and ACZ0(reg,zone,c))..
  QSZ(reg,zone,c) =E= sum(type$QSZ_input0(reg,zone,c,type),QSZ_input(reg,zone,c,type));

QSZNCREQ(reg,zone,c)$(NTR_NAG(c) and QSZ0(reg,zone,c) and ACZ0(reg,zone,c) eq 0)..
  QSZ(reg,zone,c) =E= as(reg,zone,c)*PROD(CP$QSZ0(reg,zone,cp),
              (PPZ(reg,zone,cp)/PPZ(reg,zone,'nagntrade'))**esp(reg,zone,C,CP)) ;
*  QSZ(reg,zone,c) =E= as(reg,zone,c)*PROD(CP$QSZ0(reg,zone,cp),(PPZ(reg,zone,cp))**esp(reg,zone,C,CP)) ;

QSZNAGEQ(reg,zone)$QSZ0(reg,zone,'nagntrade')..
  QSZ(reg,zone,'nagntrade') =E= as(reg,zone,'nagntrade')*
             PROD(CP$QSZ0(reg,zone,cp),PPZ(reg,zone,cp)**(esp(reg,zone,'nagntrade',CP)-esp2(reg,zone,'nagntrade',CP))) ;

*QSZNAGEQ(reg,zone,nag)$QSZ0(reg,zone,nag)..
*  QSZ(reg,zone,nag) =E= as(reg,zone,nag)*
*             PROD(CP$QSZ0(reg,zone,cp),PPZ(reg,zone,cp)**(esp(reg,zone,nag,CP)-esp2(reg,zone,nag,CP))) ;

TACEQ(c)$TAC0(c)..
  TAC(c) =E= sum((reg,zone)$ACZ0(reg,zone,c),ACZ(reg,zone,c));

TACZEQ(reg,zone)$TACZ0(reg,zone)..
  TACZ(reg,zone) =E= sum(c$ACZ0(reg,zone,c),ACZ(reg,zone,c));

TQSEQ(c)$TQS0(c)..
  TQS(c) =E= sum((reg,zone)$QSZ0(reg,zone,c),QSZ(reg,zone,c));

PCEQ(c)..
*  PC(c) =E= (1 + margD(c)*(sum((reg,zone),QSZ0(reg,zone,'nagntrade')*PPZ(reg,zone,'nagntrade'))/
*                sum((reg,zone),QSZ0(reg,zone,'nagntrade')) ) )*PP(c) ;
  PC(c) =E= (1 + margD(c))*PP(c) ;

PCZEQ(reg,zone,c)$(QSZ0(reg,zone,c) or QFZ0(reg,zone,c))..
   PCZ(reg,zone,c) =E= (1 + PPZ(reg,zone,'nagntrade')*gapZ(reg,zone,c))*PC(c) ;
*   PCZ(reg,zone,c) =E= (1 + PPZ0(reg,zone,'nagntrade')*gapZ(reg,zone,c))*PC(c) ;
*   PCZ(reg,zone,c) =E= (1 + gapZ(reg,zone,c))*PC(c) ;

PPZEQ(reg,zone,c)$(QSZ0(reg,zone,c) or QFZ0(reg,zone,c))..
* PPZ(reg,zone,c) =E= PCZ(reg,zone,c)/(1 + PPZ(reg,zone,'nagntrade')*margZ(reg,zone,c) ) ;
* PPZ(reg,zone,c) =E= (1 + PPZ0(reg,zone,'nagntrade')*gapZ2(reg,zone,c))*PC(c)  ;
* PPZ(reg,zone,c) =E= (1 + PPZ(reg,zone,'nagntrade')*gapZ2(reg,zone,c))*PC(c)  ;
  PPZ(reg,zone,c) =E= (1 + PPZ(reg,zone,'nagntrade')*gapZ2(reg,zone,c))*PC(c)  ;
* because PP = PC in the model setup -Ying

chkPCZ0(reg,zone,c)$(QSZ0(reg,zone,c) or QFZ0(reg,zone,c)) = PPZ0(reg,zone,c) -
                PCZ0(reg,zone,c)/(1 + PPZ0(reg,zone,'nagntrade')*margZ0(reg,zone,c) ) ;

display chkPCZ0;


GDPZUrbPcEQ(Naddis,zone)$(GDPZH0(Naddis,zone,'urb'))..
  GDPZHpc(Naddis,zone,'urb') =E=
         incomenagsh(Naddis,zone,'urb')*sum(nag$QSZ0(Naddis,zone,nag),
                                PPZ0(Naddis,zone,nag)*QSZ(Naddis,zone,nag))/(1000*PopH(Naddis,zone,'urb')) ;
*                                PPZ(Naddis,zone,nag)*QSZ(Naddis,zone,nag))/(1000*PopH(Naddis,zone,'urb')) ;

GDPZUrbPcEQ2(zone)$(GDPZH0('AddisAbaba',zone,'urb'))..
  GDPZHpc('AddisAbaba',zone,'urb') =E=
*         sum(c$QSZ0('AddisAbaba',zone,c),PPZ('AddisAbaba',zone,c)*QSZ('AddisAbaba',zone,c))/(1000*PopH('AddisAbaba',zone,'urb')) ;
         sum(c$QSZ0('AddisAbaba',zone,c),PPZ0('AddisAbaba',zone,c)*QSZ('AddisAbaba',zone,c))/(1000*PopH('AddisAbaba',zone,'urb')) ;

GDPZRurPcEQ(Naddis,zone,'rur')$(GDPZH0(Naddis,zone,'rur'))..
  GDPZHpc(Naddis,zone,'rur') =E=
  (incomenagsh(Naddis,zone,'rur')*sum(nag$QSZ0(Naddis,zone,nag),PPZ0(Naddis,zone,nag)*QSZ(Naddis,zone,nag))
  + sum(ag,PPZ0(Naddis,zone,ag)*QSZ(Naddis,zone,ag)) )/(1000*PopH(Naddis,zone,'rur')) ;


GDPZpcEQ(reg,zone)$GDPZ0(reg,zone)..
  GDPZpc(reg,zone) =E= sum(urbrur$GDPZH0(reg,zone,urbrur),GDPZHpc(reg,zone,urbrur)*(1000*PopH(reg,zone,urbrur)))/
                   (1000*sum(urbrur,PopH(reg,zone,urbrur))) ;


MARGEQ(reg,zone)$totmargz0(reg,zone)..
 TOTMARGZ(reg,zone) =E= (sum(c$QFZ0(reg,zone,c),(PCZ(reg,zone,c) -
*           PPZ(reg,zone,c))*QFZ(reg,zone,c)) )/PPZ(reg,zone,'nagntrade') ;
           PPZ(reg,zone,c))*QFZ(reg,zone,c)) ) ;

BALZEQ(reg,zone,c)$(QSZ0(reg,zone,c) or QDZ0(reg,zone,c))..
*  QSZ(reg,zone,c) - DQEZ(reg,zone,c) + DQMZ(reg,zone,c) =E= QDZ(reg,zone,c) ;
  QSZ(reg,zone,c) + DQTZ(reg,zone,c) =E= QDZ(reg,zone,c) ;

*add by ying
*GAPZEQ(reg,zone,c)$(DQTZ0(reg,zone,c) ne 0)..
*GAPZ(reg,zone,c) =E= DQTZ(reg,zone,c)/abs(DQTZ(reg,zone,c))*abs(gapzint(reg,zone,c));

*GAPZEQ2(reg,zone,c)$(DQTZ0(reg,zone,c) eq 0)..
*GAPZ(reg,zone,c) =E= abs(gapzint(reg,zone,c));
*====

*===MCP equation
EXPTEQ(C)$(not NTC2(c) and TQS0(c))..
 PP(C)/(1 - margW(c)) =G= EXR*pwe(c) ;

 QE.LO(c) = 0;
 QE.FX(ntc2) = 0;

IMPTEQ(C)$(not NTC2(c) and TQD0(c))..
 EXR*pwm(C)*(1 + margW(c)) =G= PC(C);

 QM.LO(c) = 0;
 QM.FX(ntc2) = 0;

TRADEEQ(c)$(TQS0(c) or TQD0(c))..
sum((reg,zone),QSZ(reg,zone,c)) + QM(C) - QE(c) =E= sum((reg,zone),QDZ(reg,zone,c)) ;


*=====================================================

 QFZHpc.FX(reg,zone,urbrur,c)$(QFZHpc0(reg,zone,urbrur,c) eq 0) = 0 ;
 QFZpc.FX(reg,zone,c)$(QFZpc0(reg,zone,c) eq 0) = 0 ;
 QFZ.FX(reg,zone,c)$(QFZ0(reg,zone,c) eq 0) = 0 ;
 QDZ.FX(reg,zone,c)$(QSZ0(reg,zone,c) eq 0 and QDZ0(reg,zone,c) eq 0) = 0 ;
 QSZ.FX(reg,zone,c)$(QSZ0(reg,zone,c) eq 0) = 0 ;
 ACZ.FX(reg,zone,crop)$(QSZ0(reg,zone,crop) eq 0) = 0 ;
 YCZ.FX(reg,zone,crop)$(ACZ0(reg,zone,crop) eq 0) = 0 ;
 QLZ.FX(reg,zone,c)$(QLZ0(reg,zone,c) eq 0) = 0 ;
 QOZ.FX(reg,zone,c)$(QOZ0(reg,zone,c) eq 0) = 0 ;
 PCZ.FX(reg,zone,c)$(QSZ0(reg,zone,c) eq 0 and QFZ0(reg,zone,c) eq 0) = PCZ0(reg,zone,c) ;
 PPZ.FX(reg,zone,c)$(QSZ0(reg,zone,c) eq 0 and QFZ0(reg,zone,c) eq 0) = PPZ0(reg,zone,c) ;
 PP.FX(c)$(TQS0(c) eq 0 or TQD0(c) eq 0)           = PP0(c) ;
 DQEZ.FX(reg,zone,c)$(DQEZ0(reg,zone,c) eq 0) = 0 ;
 DQMZ.FX(reg,zone,c)$(DQMZ0(reg,zone,c) eq 0) = 0 ;

 QSZ_input.FX(reg,zone,c,type)$(QSZ_input0(reg,zone,c,type) eq 0) = 0 ;
 ACZ_input.FX(reg,zone,c,type)$(ACZ_input0(reg,zone,c,type) eq 0) = 0 ;
 YCZ_input.FX(reg,zone,c,type)$(YCZ_input0(reg,zone,c,type) eq 0) = 0 ;

 GDPZHpc.FX(reg,zone,urbrur)$(GDPZH0(reg,zone,urbrur) eq 0) = 0 ;

 QE.FX(c)$(TQS0(c) eq 0) = 0 ;
 QM.FX(c)$(TQD0(c) eq 0) = 0 ;

*CPI.FX                  = CPI.L ;
 DUMMY.FX(reg,zone,c) = 0 ;
*DUMMY.L('AddisAbaba','Addis2','nagtrade') = 0.0001 ;
*DUMMY.UP('AddisAbaba','Addis2','nagtrade') = +INF ;
*DUMMY.LO('AddisAbaba','Addis2','nagtrade') = -INF ;

*PP.FX('nagtrade') = PP0('nagtrade');

*=====================================================
*display edfpH, PCZ0;
*$exit  ;
MODEL  MultiMkt  Multi market model for Ethiopia
/
*ALL
 CPIEQ
 QFZHpcEQ.QFZHpc
 QFZpcEQ.QFZpc
 QFZEQ.QFZ
 QLZEQ.QLZ
 QOZEQ.QOZ
 QDZEQ
 QDZEQ2
 QDZEQ3
 ACZEQ.ACZ
 YCZEQ.YCZ
 QSZ_inputEQ.QSZ_input
 ACZ_inputEQ.ACZ_input
 YCZ_inputEQ1.YCZ_input
 YCZ_inputEQ2.YCZ_input
 QSZCREQ
 QSZNCREQ
 QSZNAGEQ
 TACEQ.TAC
 TACZEQ.TACZ
 TQSEQ.TQS
 PCEQ.PC
 PCZEQ.PCZ
 PPZEQ.PPZ
 BALZEQ
 MARGEQ.ToTMARGZ
 GDPZUrbPcEQ
 GDPZUrbPcEQ2
 GDPZRurPcEQ
 GDPZpcEQ
 EXPTEQ.QE
 IMPTEQ.QM
 TRADEEQ
*add by ying
*GAPZEQ.GAPZ
*GAPZEQ2.GAPZ
*===
/;

OPTIONS  ITERLIM =100000, RESLIM = 1000000,

LIMROW = 100,
LIMCOL = 30,
*SOLPRINT = Off ,
SOLPRINT = On ,
DOMLIM=0 ;

multimkt.holdfixed = 1;
*multimkt.optfile    = 1;


* ying3 - remove '*' below
SOLVE MULTIMKT USING MCP;
display QM.L, QE.L,PWE0,PWM0,PP0, PC0 ;

*ying3
display CPI.L, QFZHpc.L, PCZ.L;

parameter
chkTQFNEW(c)
chkTQSNEW(c)
chkPPNEW(c)
chkBAL(c)
chkQFZHNEW(reg,zone,urbrur,c)
;
chkPPNEW(c)$PP0(c) = PP.L(c)/PP0(c);
chkTQFNEW(c) = TQF0(c) - sum((reg,zone),QFZ.L(reg,zone,c));
chkTQSNEW(c) = TQS0(c) - sum((reg,zone),QSZ.L(reg,zone,c));
chkBAL(c) = SUM((reg,zone),QSZ.L(reg,zone,c)) - QE.L(c) + QM.L(c) - sum((reg,zone), QFZ.L(reg,zone,c) + QLZ.L(reg,zone,c) + QOZ.L(reg,zone,c)) ;
chkQFZHNEW(reg,zone,urbrur,c) = QFZHpc0(reg,zone,urbrur,c) - QFZHpc.L(reg,zone,urbrur,c) ;


display chkPPNEW,chkTQFNEW, chkTQSNEW, chkBAL, chkQFZHnew;

Execute_Unload 'tmp.gdx',PC,PP,PPZ,PCZ,QFZ,QFZpc,QFZHpc,QLZ,QOZ,QDZ,ACZ,YCZ,QSZ,ACZ_input,YCZ_input,QSZ_input,TQS,TAC,TACZ,
GDPZpc,GDPZHpc,CPI,EXR,DQTZ,QM,QE;
Execute 'GDXXRW.EXE tmp.gdx O=caliouputBASE.xls index=INDEX!a1';







