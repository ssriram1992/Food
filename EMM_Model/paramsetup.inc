parameter

* ================================ 1 parameters for simLoopSave.inc =======================
* === additional ===

TVQS0X(C,sim,y)
TVQS0irrX(C,sim,y)
TVQS0dryX(C,sim,y)
GrainVQS0X(sim,y)
GrainTVQSZ0_inputFertX(sim,y)
CashVQS0X(sim,y)
GRAINVQS0irrX(sim,y)
CASHVQS0irrX(sim,y)
GRAINVQS0dryX(sim,y)
CASHVQS0dryX(sim,y)
PPIX(sim,y)
AGCPIX(sim,y)
AGPPIX(sim,y)
AGCPIRX(reg,sim,y)
AGPPIRX(reg,sim,y)
AGCPIZX(reg,zone,sim,y)
AGPPIZX(reg,zone,sim,y)
ToTQSX(sim,y)
ToTVQSX(sim,y)
ToTAgQSX(sim,y)
ToTAgVQSX(sim,y)
ToTAgVQS0X(sim,y)
GDPZHX(reg,zone,urbrur,sim,y)
GDPZHpcX(REG,zone,urbrur,sim,y)
GDPpcX(sim,y)
AgGDPRpcX(REG,sim,y)
NAgGDPRpcX(REG,sim,y)
PoPRX(REG,sim,y)
PoPHRX(REG,urbrur,sim,y)
PoPZX(REG,ZONE,sim,y)


* ============= Export percentage =============
QEinQSX(ag,sim,y)                                       percentage (%) of export ag comm in total supply ag comm

* ================= Demand ===============
TQFX(c,sim,y)                                           total food demand for each comm
GrainQFX(sim,y)                                         total food cereal demand
LVQFX(sim,y)                                            total livestock demand
TQLX(c,sim,y)                                           total livestock demand for each livestock
TQOX(c,sim,y)                                           total other demand for each
TQDX(c,sim,y)                                           total demand for each comm

* ================= Supply ===============
* ==== Total
TQSX(c,sim,y)                                           total supply for each comm
TVQSX(c,sim,y)                                          total supply in $ for each comm

TQSirrX(c,sim,y)                                        total supply with wtype input technology
TVQSirrX(c,sim,y)                                       total supply with wtype input technology in $
TQSdryX(c,sim,y)                                        total supply with non-wtype input technology
TVQSdryX(c,sim,y)                                       total supply with non-wtype input technology in $

* ==== Grain & Cash
GrainQSX(sim,y)                                         total cereal supply
GrainVQSX(sim,y)                                        total cereal supply in $

GrainTQSZ_inputFertX(sim,y)                             total cereal supply with fertilizer type input
GrainTACZ_inputFertX(sim,y)                             total cereal area with fertilizer type input
GrainTVQSZ_inputFertX(sim,y)                            total cereal supply with fertilizer type input in $
GrainTYCZ_inputFertX(sim,y)                             total cereal yield with fertilizer type supply

CashQSX(sim,y)                                          total cash crop supply
CashVQSX(sim,y)                                         total cash crop supply in $

GrainQSirrX(sim,y)                                      total cereal supply with watertype input
GrainVQSirrX(sim,y)                                     total cereal supply with watertype input in $
CashQSirrX(sim,y)                                       total cash crop supply with watertype input
CashVQSirrX(sim,y)                                      total cash crop supply with watertype input in $

GrainVQSdryX(sim,y)                                     total cereal supply with non-watertype input in $
GrainQSdryX(sim,y)                                      total cereal supply with non-watertype input
CashVQSdryX(sim,y)                                      total cash crop supply with watertype input in $
CashQSdryX(sim,y)                                       total cash crop supply with watertype input

* ================ per capita Demand & Supply ===================
TQFpcX(c,sim,y)                                         total food demand per capita
GrainQFpcX(sim,y)                                       total cereal demand per capita
LVQFpcX(sim,y)                                          total livestock demand per capita
TQSpcX(c,sim,y)                                         total supply per capita
GrainQSpcX(sim,y)                                       total grain supply per capita
LVQSpcX(sim,y)                                          total livestock supply per capita

* =============== Consumption, GDP, Supply at national level ===============
CONX(sim,y)                              total food demand in $ (food consumption)
AgCONX(sim,y)                            total ag food consumption

CONpcX(sim,y)                            total consumption per capita
AgCONpcX(sim,y)                          total ag food consumption per capita

AgGDPX(sim,y)                            total ag supply in $ (GDP)
NAgGDPX(sim,y)                           total nag GDP
GDPX(sim,y)                              total GDP

ToTVQSX(sim,y)                           total supply in $ (should be same with GDPX)

AgGDPpcX(sim,y)                          total Ag GDP per capita
NAgGDPpcX(sim,y)                         total nonAg GDP per capita

* =============== Deficit & Surplus ==========
TDQTZX(c,sim,y)                                         total deficit aggregated in each zone
GrainDQTZX(sim,y)                                       total cereal deficit

* ================ Area & Yield =============
TYCX(c,sim,y)                                           total yield
TACirrX(c,sim,y)                                        total area with irrigation (wtype)
TACdryX(c,sim,y)                                        total area without irrigaiton (nwtype)
TYCirrX(c,sim,y)                                        total yield with irrigation
TYCdryX(c,sim,y)                                        total yield without irrigation

ALLACX(sim,y)                                           total area
ALLACirrX(sim,y)                                        total irrigation area
ALLACdryX(sim,y)                                        total non-irrigated area

GrainACX(sim,y)                                         total area for cereals
CashACX(sim,y)                                          total area for cash crops

GrainACirrX(sim,y)                                      total area for cereals with irri
GrainACdryX(sim,y)                                      total area for cereals without irri
CashACirrX(sim,y)                                       total area for cash crops with irri
CashACdryX(sim,y)                                       total area for cash crops without irri

GrainTYCX(sim,y)                                        total yield for cereal
CashTYCX(sim,y)                                         total yield for cash crop

GrainTYCirrX(sim,y)                                     total yield for cereal with irrigation
GrainTYCdryX(sim,y)                                     total yield for cereal without irrigaion
CashTYCirrX(sim,y)                                      total yield for cash crops with irrigation
CashTYCdryX(sim,y)                                      total yield for cash crops without irrigation

* =============== Calories ================
CALpcX(c,sim,y)                                  caleries per capita for each comm
TCALpcX(sim,y)                                   total caleries per capita

CALpc_DefX(c,sim,y)                              caleries per capita deficit
CALpc_SurX(c,sim,y)                              caleries per capita surplus

TCALpc_DefX(sim,y)                               caleries per capita deficit
TCALpc_SurX(sim,y)                               caleries per capita surplus

PMALNX(sim,y)                                    percentage of malnourished children
NMALNX(sim,y)                                    number of malnorished children

PMALN_defX(sim,y)                                percentage of malnourished children for deficit zones
NMALN_defX(sim,y)                                number of malnorished children for deficit zones

PMALN_surX(sim,y)                                percentage of malnourished children for surplus zones
NMALN_surX(sim,y)                                number of malnorished children for surplus zones

demshr(c,sim,y)                                  ratio of food demand for c ($) over total demand ($)
TIncomeBalX(sim,y)                               ratio of total food demand ($) over total supply ($)

* ============== REGIONAL RESULTS ====================
PPRX(reg,c,sim,y)                                regional producer price
PCRX(reg,c,sim,y)                                regional consumer price
QFRX(reg,c,sim,y)                                regional food demand
GrainQFRX(reg,sim,y)                             regional cereal demand
LVQFRX(reg,sim,y)                                regional lv demand
QSRX(reg,c,sim,y)                                regional supply
GrainQSRX(reg,sim,y)                             regional cereal supply
LVQSRX(reg,sim,y)                                regional lv supply
CashQSRX(reg,sim,y)                              regional cash crop supply
ACRX(reg,c,sim,y)                                regional area
YCRX(reg,c,sim,y)                                regional yield

GrainACRX(reg,sim,y)                             regional cereal area
CashACRX(reg,sim,y)                              regional cash crop area
GrainYCRX(reg,sim,y)                             regional cereal yield
CashYCRX(reg,sim,y)                              regional cash crop yield

QFRpcX(reg,c,sim,y)                              regional food demand per capita
GrainQFRpcX(reg,sim,y)                           regional grain demand per capita
LVQFRpcX(reg,sim,y)                              regional lv demand per capita
QSRpcX(reg,c,sim,y)                              regional supply per capita
GrainQSRpcX(reg,sim,y)                           regional grain supply per capita
LVQSRpcX(reg,sim,y)                              regional lv supply per capita

GrainDefRX(reg,sim,y)                            regional grain deficit (demand -supply)
GrainDefshRX(reg,sim,y)                          regional grain deficit divided by regional graind demand

ALLACRX(reg,sim,y)                               regional total area
GDPRX(reg,sim,y)                                 regional GDP
GDPRpcX(reg,sim,y)                               regional per capita GDP
AgGDPRX                                          regional Ag GDP
NAgGDPRX                                         regional NAg GDP

CONRX(reg,sim,y)                                 regional food consumption ($)
AgCONRX(reg,sim,y)                               regional ag consumption ($)

CONRpcX(reg,sim,y)                               regional food consumption per capita ($)
AgCONRpcX(reg,sim,y)                             regional ag consumption per capita

CALRpcX(reg,c,sim,y)                             regional caleries per capita for each c
TCALRpcX(reg,sim,y)                              regional total caleries per capita

demshrR(reg,c,sim,y)                             regional food demand ($) divided by total food supply
IncomeBalRX(reg,sim,y)                           regional food demand ($) divided by total food supply

* ================== ZONAL RESULTS =======================
GrainQFZX(reg,zone,sim,y)                        zonal total cereal demand
LVQFZX(reg,zone,sim,y)                           zonal total lv demand

GrainQSZX(reg,zone,sim,y)                        zonal total cereal supply
LVQSZX(reg,zone,sim,y)                           zonal total lv supply
CashQSZX(reg,zone,sim,y)                         zonal total cash crop supply

GrainACZX(reg,zone,sim,y)                        zonal total grain area
CashACZX(reg,zone,sim,y)                         zonal total cash crop area

QFZpcX(reg,zone,c,sim,y)                         zonal food demand per capita
GrainQFZpcX(reg,zone,sim,y)                      zonal grain demand per capita
LVQFZpcX(reg,zone,sim,y)                         zonal lv demand per capita
QSZpcX(reg,zone,c,sim,y)                         zonal food supply per capita
GrainQSZpcX(reg,zone,sim,y)                      zonal grain supply per capita
LVQSZpcX(reg,zone,sim,y)                         zonal lv supply per capita

GrainDefZX(reg,zone,sim,y)                       zonal grain deficit
GrainDefshZX(reg,zone,sim,y)                     zonal grain deficit divided by zonal grain demand

ALLACZX(reg,zone,sim,y)                          zonal all area

CONZX(reg,zone,sim,y)                            zonal total consumption
AgCONZX(reg,zone,sim,y)                          zonal ag consumption

CONZpcX(reg,zone,sim,y)                          zonal total consimption per capita
AgCONZpcX(reg,zone,sim,y)                        zonal ag consumption per capita

GDPZX(reg,zone,sim,y)                            zonal GDP
NAgGDPZX(reg,zone,sim,y)                         zonal nag GDP
AgGDPZX(reg,zone,sim,y)                          zonel ag GDP

AgGDPZpcX(reg,zone,sim,y)                        zonal ag GDP per capita
NAgGDPZpcX(reg,zone,sim,y)                       zonal nag GDP per captia

CALZpcX(reg,zone,c,sim,y)                        zonal calories per capita
TCALZpcX(reg,zone,sim,y)                         zonal calories per capita

IncomeBalZX(reg,zone,sim,y)                      zonal demand divided by zonal supply
demshrZ(reg,zone,c,sim,y)                        zonal demand share

* ================ Income ===============
HHIZX(reg,zone,urbrur,HHS,sim,y)                 zonal household income
HHIZpcX(reg,zone,urbrur,HHS,sim,y)               zonal household income per capita

HHpoorX(reg,zone,urbrur,HHS,sim,y)               zonal income of poor household

PoPHZX(reg,zone,urbrur,sim,y)

PoPpoorZX(reg,zone,urbrur,sim,y)                 zonal population under poverty line
PoPpoorHX(urbrur,sim,y)                          national total population under poverty line for urban and rural
PoPpoorX(sim,y)                                  national total population under poverty line
PoorLineAllX(sim,y)                              ratio of poor pop over all
PoorLineHX(urbrur,sim,y)                         ratio of poor pop over all rural or all urban pop
PoorLineRuR_DEFX(sim,y)                          ratio of poor pop over all for cereal deficit zones in rural area
PoorLineRuR_SURX(sim,y)                          ratio of poor pop over all for cereal surplus zones in rural area
* ================ Inputtype ================
GrainACZ_inputTypeX(reg,zone,type,sim,y)                          zonal grain area for diff input types
GrainTACZ_inputTypeX(type,sim,y)                                  total grain area for diff input types
GrainTQSZ_inputTypeX(type,sim,y)                                  total grain supply for diff input types
GrainTYCZ_inputTypeX(type,sim,y)                                  total grain yield for diff input types

TACZ_inputTypeX(type,sim,y)                                       total area for diff input types
TQSZ_inputTypeX(type,sim,y)                                       total supply for diff input types
TYCZ_inputTypeX(type,sim,y)                                       total yield for diff input types

TYC_inputTypeX(crop,type,sim,y)                                   total yield for each crop and diff input types

TAC_inputX(c,type,sim,y)                                          total area for each crop and diff input types


* ================================ 2 parameters for simScDif.inc =======================

* ========================= (1) Absolute change from BASE Scenario ============================

* == Consumption (demand) and GDP (supply) =====
 CONCHX(sim,y)                    consumption  abs change from base sc
 AgCONCHX(sim,y)                  ag consumption  abs change from base sc
 GDPCHX(sim,y)                    GDP  abs change from base sc
 AgGDPCHX(sim,y)                  agGDP  abs change from base sc

 CONpcCHX(sim,y)                  consumption pc  abs change from base sc
 AgCONpcCHX(sim,y)                ag consumption  abs change from base sc
* GDPpcCHX(sim,y)                  GDP pc  abs change from base sc
 AgGDPpcCHX(sim,y)                agGDP pc  abs change from base sc

* ==== area, supply, value of supply ======

 ACCHX(sim,y)                     total area  abs change from base sc
 GrainACCHX(sim,y)                grain area  abs change from base sc
 CashACCHX(sim,y)                 cash crop area  abs change from base sc

 CROPQSCHX(sim,y)                 crop supply  abs change from base sc
 GrainQSCHX(sim,y)                grain supply  abs change from base sc
 CashQSCHX(sim,y)                 cash crop supply  abs change from base sc

 CROPVQSCHX(sim,y)                total value of crop supply  abs change from base sc
 GrainVQSCHX(sim,y)               total value of grain supply  abs change from base sc
 CashVQSCHX(sim,y)                total value of cash crop supply  abs change from base sc

 ACirrCHX(sim,y)                  total irri area  abs change from base sc
 GrainACirrCHX(sim,y)             irri grain area  abs change from base sc
 CashACirrCHX(sim,y)              irri cash crop area  abs change from base sc

 CROPQSirrCHX(sim,y)              supply from irri crops  abs change from base sc
 GrainQSirrCHX(sim,y)             supply from irri grain  abs change from base sc
 CashQSirrCHX(sim,y)              supply from irri cash crop  abs change from base sc

 CROPVQSirrCHX(sim,y)             total value of irri crop supply  abs change from base sc
 GrainVQSirrCHX(sim,y)            total value of irri grain supply  abs change from base sc
 CashVQSirrCHX(sim,y)             total value of irri cash crop supply  abs change from base sc

 ACdryCHX(sim,y)                  total non-irri area  abs change from base sc
 GrainACdryCHX(sim,y)             non-irri area of grain  abs change from base sc
 CashACdryCHX(sim,y)              non-irri area of cash crop  abs change from base sc

 CROPQSdryCHX(sim,y)              supply of non-irri crop  abs change from base sc
 GrainQSdryCHX(sim,y)             supply of non-irri grain  abs change from base sc
 CashQSdryCHX(sim,y)              supply of non-irri cash crop  abs change from base sc

 CROPVQSdryCHX(sim,y)             value of non-irri crop supply  abs change from base sc
 GrainVQSdryCHX(sim,y)            value of non-irri grain supply  abs change from base sc
 CashVQSdryCHX(sim,y)             value of non-irri cash crop supply  abs change from base sc


* ==== Demand and Supply =====
 TQFCHX(c,sim,y)                  food demand  abs change from base sc
 GRAINQFCHX(sim,y)                grain demand  abs change from base sc
 LVQFCHX(sim,y)                   livestock demand  abs change from base sc
 TQLCHX(c,sim,y)                  feed demand  abs change from base sc
 TQOCHX(c,sim,y)                  other demand  abs change from base sc
 TQDCHX(c,sim,y)                  total demand  abs change from base sc

 TQSCHX(c,sim,y)                  total supply  abs change from base sc
 TVQSCHX(c,sim,y)                 total value of supply  abs change from base sc
 TQFpcCHX(c,sim,y)                total food demand pc  abs change from base sc
 TQSpcCHX(c,sim,y)                total supply pc  abs change from base sc

 GrainQSpcCHX(sim,y)              grain supply pc  abs change from base sc
 GrainQFpcCHX(sim,y)              grain demand pc  abs change from base sc
 LVQSpcCHX(sim,y)                 livestock supply pc  abs change from base sc
 LVQFpcCHX(sim,y)                 livestock demand pc  abs change from base sc
* LVVQSCHX(sim,y)
* LVQSCHX(sim,y)

 TQSirrCHX(c,sim,y)               supply of irri crops  abs change from base sc
 TVQSirrCHX(c,sim,y)              value of irri crop supply  abs change from base sc
 TQSdryCHX(c,sim,y)               supply of non-irri crops  abs change from base sc
 TVQSdryCHX(c,sim,y)              value of non-irri crop supply  abs change from base sc

* === area & yield ===
 TACCHX(c,sim,y)                  total area  abs change from base sc  for each c
 TYCCHX(c,sim,y)                  total yield   abs change from base sc for each c
 GrainTYCCHX(sim,y)               total grain yield   abs change from base sc
 CashTYCCHX(sim,y)                total cash crop  yield   abs change from base sc

 TYCirrCHX(c,sim,y)               total yield of irri crops   abs change from base sc
 GrainTYCirrCHX(sim,y)            total irri grain yield  abs change from base sc
 CashTYCirrCHX(sim,y)             total irri cash crop yield   abs change from base sc

 TACdryCHX(c,sim,y)               total non-irri area   abs change from base sc
 TYCdryCHX(c,sim,y)               total non-irri  yield   abs change from base sc
 GrainTYCdryCHX(sim,y)            total non-irri grain yield   abs change from base sc
 CashTYCdryCHX(sim,y)             total non-irri cash crop yield   abs change from base sc

 ALLACirrCHX(sim,y)               total irri area   abs change from base sc
 ALLACdryCHX(sim,y)               total non-irri area   abs change from base sc


* === price ===
 PPCHX(c,sim,y)                   producer price   abs change from base sc  for each c
 PCCHX(c,sim,y)                   consumer price   abs change from base sc  for each c

* === import/export ===
 QECHX(c,sim,y)                   export   abs change from base sc
 QMCHX(c,sim,y)                   import   abs change from base sc


*==== input type =====
 GrainTACZ_inputFertCHX(sim,y)           fertilized grain area   abs change from base sc
 GrainTQSZ_inputFertCHX(sim,y)           fertilized grain supply   abs change from base sc
 GrainTyCZ_inputFertCHX(sim,y)           fertilized grain yield   abs change from base sc

 GrainTACZ_inputTypeCHX(type,sim,y)      grain area   abs change from base sc  for input types
 GrainTYCZ_inputTypeCHX(type,sim,y)      grain yield   abs change from base sc  for input types
 GrainTQSZ_inputTypeCHX(type,sim,y)      grain supply   abs change from base sc  for input types

 TACZ_inputTypeCHX(type,sim,y)           total area   abs change from base sc  for input types
 TYCZ_inputTypeCHX(type,sim,y)           total yield   abs change from base sc  for input types
 TQSZ_inputTypeCHX(type,sim,y)           total supply   abs change from base sc  for input types

 TYC_inputTypeCHX(crop,type,sim,y)       total yield   abs change from base sc for input types and crops types

* ==== Calories ====
CALPCCHX(c,sim,y)                        cal pc   abs change from base sc  for each c
TCALPCCHX(sim,y)                         total cal pc   abs change from base sc
TCALpc_DefCHX(sim,y)                     total cal pc   abs change from base sc  for cereal deficit zones
TCALpc_SurCHX(sim,y)                     total cal pc   abs change from base sc  for cereal surplus zones

* === poverty ====
PoPpoorHCHX(urbrur,sim,y)                Poor pop   abs change from base sc
PoPpoorCHX(sim,y)                        Poor pop   abs change from base sc
PoorLineAllCHX(sim,y)                    Poor pop percentage   abs change from base sc
PoorLineHCHX(urbrur,sim,y)               Poor pop percentage   abs change from base sc
PoorLineRuR_DEFCHX(sim,y)                rural Poor pop percentage   abs change from base sc  for cereal deficit zones
PoorLineRuR_SURCHX(sim,y)                rural Poor pop percentage   abs change from base sc  for cereal surplus zones

* === for maize and teff (mt)====
mtPPCHX(RAINcrop,sim,y)                  maize and teff producer price   abs change from base sc
mtTQSCHX(RAINcrop,sim,y)                 maize and teff supply   abs change from base sc
mtTVQSCHX(RAINcrop,sim,y)                maize and teff value of supply  abs change from base sc
mtTYCCHX(RAINcrop,sim,y)                 maize and teff yield   abs change from base sc
mtTACCHX(RAINcrop,sim,y)                 maize and teff area   abs change from base sc

mtTCALpcCHX(RAINcrop,sim,y)              maize and teff cal pc   abs change from base sc

mtTVQSCHCX(sim)                 maize and teff cummulative   abs change from base sc  over yrs

$ontext
* ========= (2) percente change from calibrated BASE yr '2003' ==================

* == Consumption (demand) and GDP (supply) =====
 CONXPBASE(sim,y)                        consumption   percente change from calibrated BASE yr '2003'
 AgCONXPBASE(sim,y)                      ag consumption  percente change from calibrated BASE yr '2003'
 CONpcXPBASE(sim,y)                      consumption pc  percente change from calibrated BASE yr '2003'
 AgCONpcXPBASE(sim,y)                    ag consumnption  percente change from calibrated BASE yr '2003'

 GDPXPBASE(sim,y)                        GDP   percente change from calibrated BASE yr '2003'
 AgGDPXPBASE(sim,y)                      agGDP  percente change from calibrated BASE yr '2003'
 NAgGDPXPBASE(sim,y)                     NAgGDP  percente change from calibrated BASE yr '2003'

* === price percentage change ===
 PPXPBASE(c,sim,y)                       producer price   percente change from calibrated BASE yr '2003'
 PCXPBASE(c,sim,y)                       consumer price   percente change from calibrated BASE yr '2003'

* === import/export percentage change ===
 QEXPBASE(c,sim,y)                       export    percente change from calibrated BASE yr '2003'
 QMXPBASE(c,sim,y)                       import    percente change from calibrated BASE yr '2003'

* === demand & supply percemtage change ===
 TQFXPBASE(c,sim,y)                      food demand   percente change from calibrated BASE yr '2003'
 GRAINQFXPBASE(sim,y)                    grain demand   percente change from calibrated BASE yr '2003'
 LVQFXPBASE(sim,y)                       livestock demand   percente change from calibrated BASE yr '2003'
 TQLXPBASE(c,sim,y)                      feed demand    percente change from calibrated BASE yr '2003'
 TQOXPBASE(c,sim,y)                      other demand   percente change from calibrated BASE yr '2003'
 TQDXPBASE(c,sim,y)                      total demand   percente change from calibrated BASE yr '2003'

 TQSXPBASE(c,sim,y)                      total supply   percente change from calibrated BASE yr '2003'
 TVQSXPBASE(c,sim,y)                     total value of supply     percente change from calibrated BASE yr '2003'


*        === per capita ====
 TQFpcXPBASE(c,sim,y)                    food demand pc    percente change from calibrated BASE yr '2003'
 TQSpcXPBASE(c,sim,y)                    total supply pc   percente change from calibrated BASE yr '2003'

 GrainQSpcXPBASE(sim,y)                  grain supply pc   percente change from calibrated BASE yr '2003'
 GrainQFpcXPBASE(sim,y)                  grain demand pc   percente change from calibrated BASE yr '2003'
 LVQSpcXPBASE(sim,y)                     livestock supply pc   percente change from calibrated BASE yr '2003'
 LVQFpcXPBASE(sim,y)                     livestock demand pc   percente change from calibrated BASE yr '2003'
*        ====

 GRAINVQSXPBASE(sim,y)                   total value of grain supply   percente change from calibrated BASE yr '2003'
 GRAINQSXPBASE(sim,y)                    total grain supply   percente change from calibrated BASE yr '2003'

 LVVQSXPBASE(sim,y)                      total value of livestock supply   percente change from calibrated BASE yr '2003'
 LVQSXPBASE(sim,y)                       total livestock supply   percente change from calibrated BASE yr '2003'

 CashVQSXPBASE(sim,y)                    total value of cash crop supply   percente change from calibrated BASE yr '2003'
 CashQSXPBASE(sim,y)                     total cash crop supply   percente change from calibrated BASE yr '2003'

 TQSirrXPBASE(c,sim,y)                   total value of irri crop supply   percente change from calibrated BASE yr '2003'
 TVQSirrXPBASE(c,sim,y)                  total irri crop supply   percente change from calibrated BASE yr '2003'

 GRAINVQSirrXPBASE(sim,y)                total value of irri grain supply   percente change from calibrated BASE yr '2003'
 GRAINQSirrXPBASE(sim,y)                 total irri grain supply   percente change from calibrated BASE yr '2003'

 CashVQSirrXPBASE(sim,y)                 total value of irri cash crop supply   percente change from calibrated BASE yr '2003'
 CashQSirrXPBASE(sim,y)                  total irri cash crop supply   percente change from calibrated BASE yr '2003'

 TQSdryXPBASE(c,sim,y)                   total value of non-irri crop supply   percente change from calibrated BASE yr '2003'
 TVQSdryXPBASE(c,sim,y)                  total non-irri crop supply   percente change from calibrated BASE yr '2003'

 GRAINVQSdryXPBASE(sim,y)                total value of non-irri grain supply   percente change from calibrated BASE yr '2003'
 GRAINQSdryXPBASE(sim,y)                 total non-irri grain supply   percente change from calibrated BASE yr '2003'

 CashVQSdryXPBASE(sim,y)                 total value of non-irri cash crop supply   percente change from calibrated BASE yr '2003'
 CashQSdryXPBASE(sim,y)                  total non-irri cash crop supply   percente change from calibrated BASE yr '2003'

* === area & yield percent change ===
 TACXPBASE(c,sim,y)                      total area     percente change from calibrated BASE yr '2003'
 TYCXPBASE(c,sim,y)                      total yield    percente change from calibrated BASE yr '2003'
 GrainACXPBASE(sim,y)                    grain area     percente change from calibrated BASE yr '2003'
 CashACXPBASE(sim,y)                     cash crop area     percente change from calibrated BASE yr '2003'
 GrainTYCXPBASE(sim,y)                   grain yield    percente change from calibrated BASE yr '2003'
 CashTYCXPBASE(sim,y)                    cash crop yield    percente change from calibrated BASE yr '2003'

 TACirrXPBASE(c,sim,y)                   total irri area    percente change from calibrated BASE yr '2003'
 TYCirrXPBASE(c,sim,y)                   total irri yield   percente change from calibrated BASE yr '2003'
 GrainACirrXPBASE(sim,y)                 irri grain area    percente change from calibrated BASE yr '2003'
 CashACirrXPBASE(sim,y)                  irri cash crop area     percente change from calibrated BASE yr '2003'
 GrainTYCirrXPBASE(sim,y)                irri grain yield   percente change from calibrated BASE yr '2003'
 CashTYCirrXPBASE(sim,y)                 irri cash crop yield    percente change from calibrated BASE yr '2003'

 TACdryXPBASE(c,sim,y)                   total non-irri area    percente change from calibrated BASE yr '2003'
 TYCdryXPBASE(c,sim,y)                   total non-irri yield   percente change from calibrated BASE yr '2003'
 GrainACdryXPBASE(sim,y)                 non-irri grain area    percente change from calibrated BASE yr '2003'
 CashACdryXPBASE(sim,y)                  non-irri cash crop area     percente change from calibrated BASE yr '2003'
 GrainTYCdryXPBASE(sim,y)                non-irri grain yield   percente change from calibrated BASE yr '2003'
 CashTYCdryXPBASE(sim,y)                 non-irri cash crop yield    percente change from calibrated BASE yr '2003'

 ALLACXPBASE(sim,y)                      total area   percente change from calibrated BASE yr '2003'
 ALLACirrXPBASE(sim,y)                   total irri area     percente change from calibrated BASE yr '2003'
 ALLACdryXPBASE(sim,y)                   total non-irri area     percente change from calibrated BASE yr '2003'

*==== input type =====
 GrainTACZ_inputFertXPBASE(sim,y)        fertilized grain area     percente change from calibrated BASE yr '2003'
 GrainTQSZ_inputFertXPBASE(sim,y)        fertilized grain supply     percente change from calibrated BASE yr '2003'
 GrainTyCZ_inputFertXPBASE(sim,y)        fertilized grain yield     percente change from calibrated BASE yr '2003'

 GrainTACZ_inputTypeXPBASE(type,sim,y)   grain area     percente change from calibrated BASE yr '2003'    for input types
 GrainTYCZ_inputTypeXPBASE(type,sim,y)   grain yield     percente change from calibrated BASE yr '2003'   for input types
 GrainTQSZ_inputTypeXPBASE(type,sim,y)   grain supply     percente change from calibrated BASE yr '2003'  for input types

 TACZ_inputTypeXPBASE(type,sim,y)        total area     percente change from calibrated BASE yr '2003'     for input types
 TYCZ_inputTypeXPBASE(type,sim,y)        total yield     percente change from calibrated BASE yr '2003'    for input types
 TQSZ_inputTypeXPBASE(type,sim,y)        total supply     percente change from calibrated BASE yr '2003'   for input types

 TYC_inputTypeXPBASE(crop,type,sim,y)    total area     percente change from calibrated BASE yr '2003'     for input types and crop types

* ==== Calories ====
CALPCXPBASE(c,sim,y)                    cal pc      percente change from calibrated BASE yr '2003'     for each c
TCALPCXPBASE(sim,y)                     total cal pc    percente change from calibrated BASE yr '2003'
$offtext

;
