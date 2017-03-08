* ============== Direct variables output ====================
PPX(c,%1,%2)                        = PP.L(c);
PCX(c,%1,%2)                        = PC.L(c);
PPZX(reg,zone,c,%1,%2)              = PPZ.L(reg,zone,c);
PCZX(reg,zone,c,%1,%2)              = PCZ.L(reg,zone,c);
QFZX(reg,zone,c,%1,%2)              = QFZ.L(reg,zone,c);
QFZpcX(reg,zone,c,%1,%2)            = QFZpc.L(reg,zone,c);
QFZHpcX(reg,zone,urbrur,c,%1,%2)    = QFZHpc.L(reg,zone,urbrur,c);
QLZX(reg,zone,c,%1,%2)              = QLZ.L(reg,zone,c);
QOZX(reg,zone,c,%1,%2)              = QOZ.L(reg,zone,c);
QDZX(reg,zone,c,%1,%2)              = QDZ.L(reg,zone,c);
ACZX(reg,zone,c,%1,%2)              = ACZ.L(reg,zone,c);
YCZX(reg,zone,c,%1,%2)              = YCZ.L(reg,zone,c);
QSZX(reg,zone,c,%1,%2)              = QSZ.L(reg,zone,c);
ACZ_inputX(reg,zone,c,type,%1,%2)   = ACZ_input.L(reg,zone,c,type);
YCZ_inputX(reg,zone,c,type,%1,%2)   = YCZ_input.L(reg,zone,c,type);
QSZ_inputX(reg,zone,c,type,%1,%2)   = QSZ_input.L(reg,zone,c,type);
TQSX(c,%1,%2)                       = TQS.L(c);
TACX(c,%1,%2)                       = TAC.L(c);
TACZX(reg,zone,%1,%2)               = TACZ.L(reg,zone);
GDPZpcX(reg,zone,%1,%2)             = GDPZpc.L(reg,zone);
GDPZHpcX(reg,zone,urbrur,%1,%2)     = GDPZHpc.L(reg,zone,urbrur);
EXRX(%1,%2)                         = EXR.L;
DQTZX(reg,zone,c,%1,%2)             = DQTZ.L(reg,zone,c);
QMX(c,%1,%2)                        = QM.L(c);
QEX(c,%1,%2)                        = QE.L(c);

* ===
QFZHX(reg,zone,urbrur,c,%1,%2)      = QFZH.L(reg,zone,urbrur,c);
QTX(c,%1,%2)                        = QT.L(c);

DQMZX(reg,zone,c,%1,%2)             = DQMZ.L(reg,zone,c);
DQEZX(reg,zone,c,%1,%2)             = DQEZ.L(reg,zone,c);

GDPZHX(reg,zone,urbrur,%1,%2)       = GDPZH.L(reg,zone,urbrur) ;


* ============= Export percentage =============
QEinQSX(ag,%1,%2)$TQS.L(ag)                              = 100*QE.L(ag)/TQS.L(ag);

* ================= Demand ===============
TQFX(c,%1,%2)                                           = sum((reg,zone),QFZ.L(reg,zone,c));
GrainQFX(%1,%2)                                         = sum((reg,zone,cereal),QFZ.L(reg,zone,cereal));
LVQFX(%1,%2)                                            = sum((reg,zone,lv),QFZ.L(reg,zone,lv));
TQLX(c,%1,%2)                                           = sum((reg,zone),QLZ.L(reg,zone,c));
TQOX(c,%1,%2)                                           = sum((reg,zone),QOZ.L(reg,zone,c));
TQDX(c,%1,%2)                                           = sum((reg,zone),QDZ.L(reg,zone,c));

* ================= Supply ===============
* ==== Total
TQSX(C,%1,%2)                                            = SUM((reg,zone),QSZ.L(reg,zone,c));
TVQSX(C,%1,%2)                                           = SUM((reg,zone),PPZ.L(reg,zone,c)*QSZ.L(reg,zone,c));
TVQS0X(C,%1,%2)                                          = SUM((reg,zone),PPZ0(reg,zone,c)*QSZ.L(reg,zone,c));

TQSX(C,%1,%2)                                            = SUM((reg,zone,type),QSZ_input.L(reg,zone,c,type));
TVQSX(C,%1,%2)                                            = SUM((reg,zone,type),PPZ.L(reg,zone,c)*QSZ_input.L(reg,zone,c,type));
TVQS0X(C,%1,%2)                                            = SUM((reg,zone,type),PPZ0(reg,zone,c)*QSZ_input.L(reg,zone,c,type));

TQSX(lv,%1,%2)                                            = SUM((reg,zone),QSZ.L(reg,zone,lv));
TVQSX(lv,%1,%2)                                           = SUM((reg,zone),PPZ.L(reg,zone,lv)*QSZ.L(reg,zone,lv));
TVQS0X(lv,%1,%2)                                          = SUM((reg,zone),PPZ0(reg,zone,lv)*QSZ.L(reg,zone,lv));

TQSX(NAG,%1,%2)                                            = SUM((reg,zone),QSZ.L(reg,zone,nag));
TVQSX(NAG,%1,%2)                                           = SUM((reg,zone),PPZ.L(reg,zone,nag)*QSZ.L(reg,zone,nag));
TVQS0X(NAG,%1,%2)                                          = SUM((reg,zone),PPZ0(reg,zone,nag)*QSZ.L(reg,zone,nag));

 TQSirrX(C,%1,%2)                                            = SUM((reg,zone,wtype),QSZ_input.L(reg,zone,c,wtype));
 TVQSirrX(C,%1,%2)                                           = SUM((reg,zone,wtype),PPZ.L(reg,zone,c)*QSZ_input.L(reg,zone,c,wtype));
 TVQS0irrX(C,%1,%2)                                          = SUM((reg,zone,wtype),PPZ0(reg,zone,c)*QSZ_input.L(reg,zone,c,wtype));

 TQSdryX(C,%1,%2)                                            = SUM((reg,zone,nwtype),QSZ_input.L(reg,zone,c,nwtype));
 TVQSdryX(C,%1,%2)                                           = SUM((reg,zone,nwtype),PPZ.L(reg,zone,c)*QSZ_input.L(reg,zone,c,nwtype));
 TVQS0dryX(C,%1,%2)                                          = SUM((reg,zone,nwtype),PPZ0(reg,zone,c)*QSZ_input.L(reg,zone,c,nwtype));

* ==== Grain & Cash

GrainQSX(%1,%2)                                         = SUM((reg,zone,cereal,type),QSZ_input.L(reg,zone,cereal,type));
GrainVQSX(%1,%2)                                         = SUM((reg,zone,cereal,type),PPZ.L(reg,zone,cereal)*QSZ_input.L(reg,zone,cereal,type));
GrainVQS0X(%1,%2)                                         = SUM((reg,zone,cereal,type),PPZ0(reg,zone,cereal)*QSZ_input.L(reg,zone,cereal,type));

 GrainTACZ_inputFertX(%1,%2)                              = SUM((reg,zone,cereal,Ftype),ACZ_input.L(reg,zone,cereal,Ftype));
 GrainTQSZ_inputFertX(%1,%2)                              = SUM((reg,zone,cereal,Ftype),QSZ_input.L(reg,zone,cereal,Ftype));
 GrainTVQSZ_inputFertX(%1,%2)                              = SUM((reg,zone,cereal,Ftype),PPZ.L(reg,zone,cereal)*QSZ_input.L(reg,zone,cereal,Ftype));
 GrainTVQSZ0_inputFertX(%1,%2)                              = SUM((reg,zone,cereal,Ftype),PPZ0(reg,zone,cereal)*QSZ_input.L(reg,zone,cereal,Ftype));
 GrainTYCZ_inputFertX(%1,%2)$GrainTACZ_inputFertX(%1,%2)  =  1000*GrainTQSZ_inputFertX(%1,%2)/GrainTACZ_inputFertX(%1,%2) ;

CashQSX(%1,%2)                                          = SUM((reg,zone,cash,type),QSZ_input.L(reg,zone,cash,type));
 CashVQSX(%1,%2)                                         = SUM((reg,zone,cash,type),PPZ.L(reg,zone,cash)*QSZ_input.L(reg,zone,cash,type));
 CashVQS0X(%1,%2)                                        = SUM((reg,zone,cash,type),PPZ0(reg,zone,cash)*QSZ_input.L(reg,zone,cash,type));

 GRAINVQSirrX(%1,%2)                                          = SUM((reg,zone,cereal,wtype),PPZ.L(reg,zone,cereal)*QSZ_input.L(reg,zone,cereal,wtype));
 GRAINVQS0irrX(%1,%2)                                         = SUM((reg,zone,cereal,wtype),PPZ0(reg,zone,cereal)*QSZ_input.L(reg,zone,cereal,wtype));
 GRAINQSirrX(%1,%2)                                          = SUM((reg,zone,cereal,wtype),QSZ_input.L(reg,zone,cereal,wtype));

 CASHVQSirrX(%1,%2)                                          = SUM((reg,zone,cash,wtype),PPZ.L(reg,zone,cash)*QSZ_input.L(reg,zone,cash,wtype));
 CASHVQS0irrX(%1,%2)                                         = SUM((reg,zone,cash,wtype),PPZ0(reg,zone,cash)*QSZ_input.L(reg,zone,cash,wtype));
 CashQSirrX(%1,%2)                                          = SUM((reg,zone,cash,wtype),QSZ_input.L(reg,zone,cash,wtype));

 GRAINVQSdryX(%1,%2)                                          = SUM((reg,zone,cereal,nwtype),PPZ.L(reg,zone,cereal)*QSZ_input.L(reg,zone,cereal,nwtype));
 GRAINVQS0dryX(%1,%2)                                         = SUM((reg,zone,cereal,nwtype),PPZ0(reg,zone,cereal)*QSZ_input.L(reg,zone,cereal,nwtype));
 GRAINQSdryX(%1,%2)                                          = SUM((reg,zone,cereal,nwtype),QSZ_input.L(reg,zone,cereal,nwtype));

 CASHVQSdryX(%1,%2)                                          = SUM((reg,zone,cash,nwtype),PPZ.L(reg,zone,cash)*QSZ_input.L(reg,zone,cash,nwtype));
 CASHVQS0dryX(%1,%2)                                         = SUM((reg,zone,cash,nwtype),PPZ0(reg,zone,cash)*QSZ_input.L(reg,zone,cash,nwtype));
 CashQSdryX(%1,%2)                                          = SUM((reg,zone,cash,nwtype),QSZ_input.L(reg,zone,cash,nwtype));

* ================ per capita Demand & Supply ===================
TQFpcX(c,%1,%2)                                         = sum((reg,zone),QFZ.L(reg,zone,c))/sum((reg,zone,urbrur),PopH(reg,zone,urbrur));
GrainQFpcX(%1,%2)                                       = sum((reg,zone,cereal),QFZ.L(reg,zone,cereal))/sum((reg,zone,urbrur),PopH(reg,zone,urbrur));
LVQFpcX(%1,%2)                                          = sum((reg,zone,lv),QFZ.L(reg,zone,lv))/sum((reg,zone,urbrur),PopH(reg,zone,urbrur));
TQSpcX(c,%1,%2)                                         = sum((reg,zone),QSZ.L(reg,zone,c))/sum((reg,zone,urbrur),PopH(reg,zone,urbrur));
GrainQSpcX(%1,%2)                                       = sum((reg,zone,cereal),QSZ.L(reg,zone,cereal))/sum((reg,zone,urbrur),PopH(reg,zone,urbrur));
LVQSpcX(%1,%2)                                          = sum((reg,zone,lv),QSZ.L(reg,zone,lv))/sum((reg,zone,urbrur),PopH(reg,zone,urbrur));

* =============== Consumption, GDP, Supply at national level ===============

 CPIX(%1,%2)           = sum((reg,zone,c),PC.L(c)*QFZ0(reg,zone,C))/sum((reg,zone,c),PC0(c)*QFZ0(reg,zone,C));
 PPIX(%1,%2)           = sum((reg,zone,c),PPZ.L(reg,zone,c)*QSZ0(reg,zone,C))/sum((reg,zone,c),PPZ0(reg,zone,c)*QSZ0(reg,zone,C));

 AGCPIX(%1,%2)           = sum((reg,zone,ag),PCZ.L(reg,zone,ag)*QFZ0(reg,zone,ag))/sum((reg,zone,ag),PCZ0(reg,zone,ag)*QFZ0(reg,zone,ag));
 AGPPIX(%1,%2)           = sum((reg,zone,ag),PPZ.L(reg,zone,ag)*QSZ0(reg,zone,ag))/sum((reg,zone,ag),PPZ0(reg,zone,ag)*QSZ0(reg,zone,ag));

 AGCPIRX(reg,%1,%2)$sum((zone,ag),PCZ0(reg,zone,ag)*QFZ0(reg,zone,ag))
               = sum((zone,ag),PCZ.L(reg,zone,ag)*QFZ0(reg,zone,ag))/sum((zone,ag),PCZ0(reg,zone,ag)*QFZ0(reg,zone,ag));
 AGPPIRX(reg,%1,%2)$sum((zone,ag),PPZ0(reg,zone,ag)*QSZ0(reg,zone,ag))
              = sum((zone,ag),PPZ.L(reg,zone,ag)*QSZ0(reg,zone,ag))/sum((zone,ag),PPZ0(reg,zone,ag)*QSZ0(reg,zone,ag));

 AGCPIZX(reg,zone,%1,%2)$sum(ag,PCZ0(reg,zone,ag)*QFZ0(reg,zone,ag))
               = sum(ag,PCZ.L(reg,zone,ag)*QFZ0(reg,zone,ag))/sum(ag,PCZ0(reg,zone,ag)*QFZ0(reg,zone,ag));
 AGPPIZX(reg,zone,%1,%2)$sum(ag,PPZ0(reg,zone,ag)*QSZ0(reg,zone,ag))
              = sum(ag,PPZ.L(reg,zone,ag)*QSZ0(reg,zone,ag))/sum(ag,PPZ0(reg,zone,ag)*QSZ0(reg,zone,ag));


 CONX(%1,%2)$PPIX(%1,%2)     = sum((reg,zone,c),PCZ0(reg,zone,c)*QFZ.L(reg,zone,C)) ;
 AgCONX(%1,%2)$PPIX(%1,%2)   = sum((reg,zone,ag),PCZ0(reg,zone,ag)*QFZ.L(reg,zone,ag)) ;

 CONpcX(%1,%2)$CONX(%1,%2)           = CONX(%1,%2)/(1000*sum((reg,zone,urbrur),PopH(reg,zone,urbrur)));
 AgCONpcX(%1,%2)$AgCONX(%1,%2)       = AgCONX(%1,%2)/(1000*sum((reg,zone,urbrur),PopH(reg,zone,urbrur)));

 AgGDPX(%1,%2)$PPIX(%1,%2)   = sum((reg,zone,ag),PPZ0(reg,zone,ag)*QSZ.L(reg,zone,ag)) ;
 NAgGDPX(%1,%2)$CPIX(%1,%2)   = sum((reg,zone,nag),PPZ0(reg,zone,nag)*QSZ.L(reg,zone,nag)) ;

 GDPX(%1,%2)                  = AgGDPX(%1,%2) + NAgGDPX(%1,%2) ;

 ToTQSX(%1,%2)$PPIX(%1,%2)   = sum((reg,zone,c),PPZ0(reg,zone,c)*QSZ.L(reg,zone,c)) ;
 ToTVQSX(%1,%2)$PPIX(%1,%2)   = sum((reg,zone,c),PPZ.L(reg,zone,c)*QSZ.L(reg,zone,c)) ;
 ToTAgQSX(%1,%2)$PPIX(%1,%2)   = sum((reg,zone,ag),PPZ0(reg,zone,ag)*QSZ.L(reg,zone,ag)) ;
 ToTAgVQSX(%1,%2)$PPIX(%1,%2)   = sum((reg,zone,ag),PPZ.L(reg,zone,ag)*QSZ.L(reg,zone,ag)) ;
 ToTAgVQS0X(%1,%2)$PPIX(%1,%2)   = sum((reg,zone,ag),PPZ0(reg,zone,ag)*QSZ.L(reg,zone,ag)) ;

 GDPpcX(%1,%2)$GDPX(%1,%2)           = GDPX(%1,%2)/(1000*sum((reg,zone,urbrur),PopH(reg,zone,urbrur)));
 AgGDPpcX(%1,%2)$AgGDPX(%1,%2)       = AgGDPX(%1,%2)/(1000*sum((reg,zone,urbrur),PopH(reg,zone,urbrur)));
 NAgGDPpcX(%1,%2)$NAgGDPX(%1,%2)     = NAgGDPX(%1,%2)/(1000*sum((reg,zone,urbrur),PopH(reg,zone,urbrur)));


* =============== Deficit & Surplus ==========
TDQTZX(c,%1,%2)                                         = sum((reg,zone)$(DQTZ.L(reg,zone,c) gt 0),DQTZ.L(reg,zone,c));
GrainDQTZX(%1,%2)                                       = sum((reg,zone,cereal)$(DQTZ.L(reg,zone,cereal) gt 0),DQTZ.L(reg,zone,cereal));

* ================ Area & Yield =============
TYCX(c,%1,%2)$TACX(c,%1,%2)                             = 1000*TQSX(c,%1,%2)/TACX(c,%1,%2);
TACirrX(c,%1,%2)                                        = sum((reg,zone,wtype),ACZ_input.L(reg,zone,c,wtype));
TACdryX(c,%1,%2)                                        = sum((reg,zone,nwtype),ACZ_input.L(reg,zone,c,nwtype));
TYCirrX(c,%1,%2)$TACirrX(c,%1,%2)                       = 1000*TQSirrX(c,%1,%2)/TACirrX(c,%1,%2);
TYCdryX(c,%1,%2)$TACdryX(c,%1,%2)                       = 1000*TQSdryX(c,%1,%2)/TACdryX(c,%1,%2);

ALLACX(%1,%2)                                           = sum((reg,zone,c),ACZ.L(reg,zone,c));
ALLACirrX(%1,%2)                                        = sum((reg,zone,c,wtype),ACZ_input.L(reg,zone,c,wtype));
ALLACdryX(%1,%2)                                        = sum((reg,zone,c,nwtype),ACZ_input.L(reg,zone,c,nwtype));

GrainACX(%1,%2)                                         = sum((reg,zone,cereal),ACZ.L(reg,zone,cereal));
CashACX(%1,%2)                                          = sum((reg,zone,cash),ACZ.L(reg,zone,cash));

GrainACirrX(%1,%2)                                      = sum((reg,zone,cereal,wtype),ACZ_input.L(reg,zone,cereal,wtype));
GrainACdryX(%1,%2)                                      = sum((reg,zone,cereal,nwtype),ACZ_input.L(reg,zone,cereal,nwtype));
CashACirrX(%1,%2)                                       = sum((reg,zone,cash,wtype),ACZ_input.L(reg,zone,cash,wtype));
CashACdryX(%1,%2)                                       = sum((reg,zone,cash,nwtype),ACZ_input.L(reg,zone,cash,nwtype));

GrainTYCX(%1,%2)$GrainACX(%1,%2)                        = 1000*sum(cereal,TQSX(cereal,%1,%2))/GrainACX(%1,%2);
CashTYCX(%1,%2)$CashACX(%1,%2)                          = 1000*sum(cash,TQSX(cash,%1,%2))/CashACX(%1,%2);

GrainTYCirrX(%1,%2)$GrainACirrX(%1,%2)                  = 1000*sum(cereal,TQSirrX(cereal,%1,%2))/GrainACirrX(%1,%2);
GrainTYCdryX(%1,%2)$GrainACdryX(%1,%2)                  = 1000*sum(cereal,TQSdryX(cereal,%1,%2))/GrainACdryX(%1,%2);
CashTYCirrX(%1,%2)$CashACirrX(%1,%2)                    = 1000*sum(cash,TQSirrX(cash,%1,%2))/CashACirrX(%1,%2);
CashTYCdryX(%1,%2)$CashACdryX(%1,%2)                    = 1000*sum(cash,TQSdryX(cash,%1,%2))/CashACdryX(%1,%2);

* =============== Calories ================
CALpcX(c,%1,%2)          = 10*KcalRatio(c)*sum( (reg,zone),QFZ.L(reg,zone,c) ) / (365*sum((reg,zone,urbrur),PopH(reg,zone,urbrur))) ;
TCALpcX(%1,%2)           = sum(c,CALpcX(c,%1,%2) ) ;

*CALpc_DefX(c,%1,%2)      = 10*KcalRatio(c)*sum( (reg,zone)$(sum(cereal,QFZ0(reg,zone,cereal) - QSZ0(reg,zone,cereal)) gt 0),QFZ.L(reg,zone,c) )/
*                          (365*sum((reg,zone,urbrur)$(sum(cereal,QFZ0(reg,zone,cereal) - QSZ0(reg,zone,cereal)) gt 0),PopH(reg,zone,urbrur))) ;
*CALpc_SurX(c,%1,%2)      = 10*KcalRatio(c)*sum((reg,zone)$(sum(cereal,QFZ0(reg,zone,cereal) - QSZ0(reg,zone,cereal)) le 0),QFZ.L(reg,zone,c))/
*                          (365*sum((reg,zone,urbrur)$(sum(cereal,QFZ0(reg,zone,cereal) - QSZ0(reg,zone,cereal)) le 0),PopH(reg,zone,urbrur))) ;

CALpc_DefX(c,%1,%2)      = 10*KcalRatio(c)*sum( (reg,zone)$(sum(cereal,QFZ.L(reg,zone,cereal) - QSZ.L(reg,zone,cereal)) gt 0),QFZ.L(reg,zone,c) )/
                          (365*sum((reg,zone,urbrur)$(sum(cereal,QFZ.L(reg,zone,cereal) - QSZ.L(reg,zone,cereal)) gt 0),PopH(reg,zone,urbrur))) ;
CALpc_SurX(c,%1,%2)      = 10*KcalRatio(c)*sum((reg,zone)$(sum(cereal,QFZ.L(reg,zone,cereal) - QSZ.L(reg,zone,cereal)) le 0),QFZ.L(reg,zone,c))/
                          (365*sum((reg,zone,urbrur)$(sum(cereal,QFZ.L(reg,zone,cereal) - QSZ.L(reg,zone,cereal)) le 0),PopH(reg,zone,urbrur))) ;


TCALpc_DefX(%1,%2)       = sum(c,CALpc_DefX(c,%1,%2) ) ;
TCALpc_SurX(%1,%2)       = sum(c,CALpc_SurX(c,%1,%2) ) ;

pmalnX(%1,%2)$log(TCALpcX(%1,%2))                          = intermal + melas*log(TCALpcX(%1,%2)) ;
nmalnX(%1,%2)$pmalnX(%1,%2)                                = pmalnX(%1,%2)*Ninfant/100 ;

pmaln_defX(%1,%2)$log(TCALpc_defX(%1,%2))                  = intermal + melas*log(TCALpc_defX(%1,%2)) ;
nmaln_defX(%1,%2)$pmaln_defX(%1,%2)                        = 0.63*pmaln_defX(%1,%2)*Ninfant/100 ;

pmaln_surX(%1,%2)$log(TCALpc_surX(%1,%2))                  = intermal + melas*log(TCALpc_surX(%1,%2)) ;
nmaln_surX(%1,%2)$pmaln_surX(%1,%2)                        = 0.37*pmaln_surX(%1,%2)*Ninfant/100 ;

demshr(C,%1,%2)$sum((reg,zone,cp),QFZ0(reg,zone,cp))      =
                 sum((reg,zone),PCZ.L(reg,zone,C)*QFZ.L(reg,zone,C))/sum((reg,zone,cp),PCZ.L(reg,zone,cp)*QFZ.L(reg,zone,cp)) * 100;

 TIncomeBalX(%1,%2)$sum((reg,zone,c),PPZ.L(reg,zone,c)*QSZ.L(reg,zone,c)) =
                   sum((reg,zone,c),PCZ.L(reg,zone,c)*QFZ.L(reg,zone,c))/
                   sum((reg,zone,c),PPZ.L(reg,zone,c)*QSZ.L(reg,zone,c)) ;

* ============== REGIONAL RESULTS ====================
 PPRX(REG,C,%1,%2)$SUM(ZONE,QSZ0(reg,zone,c))  = SUM(ZONE,PPZ.L(REG,ZONE,C)*QSZ0(reg,zone,c))/SUM(ZONE,QSZ0(reg,zone,c));
 PCRX(REG,C,%1,%2)$SUM(ZONE,QFZ0(reg,zone,c))  = SUM(ZONE,PCZ.L(REG,ZONE,C)*QFZ0(reg,zone,c))/SUM(ZONE,QFZ0(reg,zone,c));

 QFRX(REG,C,%1,%2)                            = SUM(ZONE,QFZ.L(reg,zone,c));
 GRAINQFRX(REG,%1,%2)                         = SUM((zone,cereal),QFZ.L(reg,zone,cereal));
 LVQFRX(REG,%1,%2)                            = SUM((zone,lv),QFZ.L(reg,zone,lv));
 QSRX(REG,C,%1,%2)                            = SUM((zone),QSZ.L(reg,zone,c));
 GRAINQSRX(REG,%1,%2)                         = SUM((zone,cereal),QSZ.L(reg,zone,cereal));
 LVQSRX(REG,%1,%2)                            = SUM((zone,lv),QSZ.L(reg,zone,lv));
 CashQSRX(REG,%1,%2)                          = SUM((zone,cash),QSZ.L(reg,zone,cash));
 ACRX(REG,C,%1,%2)                            = SUM((zone),ACZ.L(reg,zone,c));
 YCRX(REG,C,%1,%2)$ACrX(REG,C,%1,%2)             = 1000*QSRX(REG,C,%1,%2)/ACRX(REG,C,%1,%2);

GrainACRX(reg,%1,%2)                          = sum((zone,cereal),ACZ.L(reg,zone,cereal));
CashACRX(reg,%1,%2)                           = sum((zone,cash),ACZ.L(reg,zone,cash));
GrainYCRX(reg,%1,%2)$GrainACrX(reg,%1,%2)     = 1000*sum(cereal,QSRX(reg,cereal,%1,%2))/GrainACRX(reg,%1,%2);
CashYCRX(reg,%1,%2)$CashACrX(reg,%1,%2)       = 1000*sum(cash,QSRX(reg,cash,%1,%2))/CashACRX(reg,%1,%2);

QFRpcX(reg,c,%1,%2)                      = sum((zone),QFZ.L(reg,zone,c))/sum((zone,urbrur),PopH(reg,zone,urbrur));
GrainQFRpcX(reg,%1,%2)                   = sum((zone,cereal),QFZ.L(reg,zone,cereal))/sum((zone,urbrur),PopH(reg,zone,urbrur));
LVQFRpcX(reg,%1,%2)                      = sum((zone,lv),QFZ.L(reg,zone,lv))/sum((zone,urbrur),PopH(reg,zone,urbrur));
QSRpcX(reg,c,%1,%2)                      = sum((zone),QSZ.L(reg,zone,c))/sum((zone,urbrur),PopH(reg,zone,urbrur));
GrainQSRpcX(reg,%1,%2)                   = sum((zone,cereal),QSZ.L(reg,zone,cereal))/sum((zone,urbrur),PopH(reg,zone,urbrur));
LVQSRpcX(reg,%1,%2)                      = sum((zone,lv),QSZ.L(reg,zone,lv))/sum((zone,urbrur),PopH(reg,zone,urbrur));

GrainACRX(reg,%1,%2)                          = sum((zone,cereal),ACZ.L(reg,zone,cereal));
CashACRX(reg,%1,%2)                           = sum((zone,cash),ACZ.L(reg,zone,cash));
GrainYCRX(reg,%1,%2)$GrainACrX(reg,%1,%2)     = 1000*sum(cereal,QSRX(reg,cereal,%1,%2))/GrainACRX(reg,%1,%2);
CashYCRX(reg,%1,%2)$CashACrX(reg,%1,%2)       = 1000*sum(cash,QSRX(reg,cash,%1,%2))/CashACRX(reg,%1,%2);

QFRpcX(reg,c,%1,%2)                      = sum((zone),QFZ.L(reg,zone,c))/sum((zone,urbrur),PopH(reg,zone,urbrur));
GrainQFRpcX(reg,%1,%2)                   = sum((zone,cereal),QFZ.L(reg,zone,cereal))/sum((zone,urbrur),PopH(reg,zone,urbrur));
LVQFRpcX(reg,%1,%2)                      = sum((zone,lv),QFZ.L(reg,zone,lv))/sum((zone,urbrur),PopH(reg,zone,urbrur));
QSRpcX(reg,c,%1,%2)                      = sum((zone),QSZ.L(reg,zone,c))/sum((zone,urbrur),PopH(reg,zone,urbrur));
GrainQSRpcX(reg,%1,%2)                   = sum((zone,cereal),QSZ.L(reg,zone,cereal))/sum((zone,urbrur),PopH(reg,zone,urbrur));
LVQSRpcX(reg,%1,%2)                      = sum((zone,lv),QSZ.L(reg,zone,lv))/sum((zone,urbrur),PopH(reg,zone,urbrur));

 GRAINDEFRX(REG,%1,%2)$GRAINQFRX(REG,%1,%2)  = GRAINQFRX(REG,%1,%2) - GRAINQSRX(REG,%1,%2) ;
 GRAINDEFshRX(REG,%1,%2)$GRAINQFRX(REG,%1,%2)  = 100*GRAINDEFRX(REG,%1,%2)/GRAINQFRX(REG,%1,%2) ;

 ALLACRX(REG,%1,%2)                   = SUM((zone,c),ACZ.L(REG,zone,c));

 GDPRX(REG,%1,%2)                     = sum((zone),GDPZpc.L(reg,zone)*1000*sum((urbrur),PopH(reg,zone,urbrur))) ;

 AgGDPRX(REG,%1,%2)                   = sum((zone,ag)$(QSZ0(reg,zone,ag) and not cereal(ag)),PPZ.L(reg,zone,ag)*QSZ.L(reg,zone,ag))
                                      + sum((zone,cereal)$(QSZ0(reg,zone,cereal) and DQTZ0(reg,zone,cereal) gt 0),
                                  PPZ0(reg,zone,cereal)*PopHShare(reg,zone,'rur')*QSZ.L(reg,zone,cereal) +
                                  PPZ.L(reg,zone,cereal)*(1 - PopHShare(reg,zone,'rur'))*QSZ.L(reg,zone,cereal))
                                      + sum((zone,cereal)$(QSZ0(reg,zone,cereal) and DQTZ0(reg,zone,cereal) le 0),
                                  PPZ0(reg,zone,cereal)*PopHShare(reg,zone,'rur')*QFZ.L(reg,zone,cereal) +
                                  PPZ.L(reg,zone,cereal)*(QSZ.L(reg,zone,cereal) - PopHShare(reg,zone,'rur')*QFZ.L(reg,zone,cereal)));


 NAgGDPRX(REG,%1,%2)                  = sum((zone,nag),PPZ0(reg,zone,nag)*QSZ.L(reg,zone,nag)) ;


 GDPRpcX(REG,%1,%2)$GDPRX(REG,%1,%2)           = GDPRX(REG,%1,%2)/(1000*sum((zone,urbrur),PopH(reg,zone,urbrur)));
 AgGDPRpcX(REG,%1,%2)$AgGDPRX(REG,%1,%2)       = AgGDPRX(REG,%1,%2)/(1000*sum((zone,urbrur),PopH(reg,zone,urbrur)));
 NAgGDPRpcX(REG,%1,%2)$NAgGDPRX(REG,%1,%2)     = NAgGDPRX(REG,%1,%2)/(1000*sum((zone,urbrur),PopH(reg,zone,urbrur)));

 CONRX(reg,%1,%2)     = sum((zone,c),PCZ0(reg,zone,c)*QFZ.L(reg,zone,C)) ;
 AgCONRX(reg,%1,%2)   = sum((zone,ag),PCZ0(reg,zone,ag)*QFZ.L(reg,zone,ag)) ;

 CONRpcX(reg,%1,%2)$CONRX(reg,%1,%2)           = CONRX(reg,%1,%2)/(1000*sum((zone,urbrur),PopH(reg,zone,urbrur)));
 AgCONRpcX(reg,%1,%2)$AgCONRX(reg,%1,%2)       = AgCONRX(reg,%1,%2)/(1000*sum((zone,urbrur),PopH(reg,zone,urbrur)));

*Population
 PoPRX(REG,%1,%2)                      = sum((zone,urbrur),PopH(reg,zone,urbrur));
 PoPHRX(REG,urbrur,%1,%2)              = sum((zone),PopH(reg,zone,urbrur));
 PoPHZX(REG,zone,urbrur,%1,%2)         = PopH(reg,zone,urbrur);
 PoPZX(REG,ZONE,%1,%2)$sum(urbrur,PopH(reg,zone,urbrur))           = sum(urbrur,PopH(reg,zone,urbrur));

CALRPCX(REG,C,%1,%2) = 10*KcalRatio(C)*sum((zone),QFZ.L(reg,zone,c))/(365*sum((zone,urbrur),PopH(reg,zone,urbrur))) ;

TCALRPCX(REG,%1,%2) = sum(C,CALRPCX(REG,C,%1,%2) ) ;

IncomeBalRX(reg,%1,%2)$sum((zone,c),PPZ.L(reg,zone,c)*QSZ.L(reg,zone,c)) =
                        sum((zone,c),PCZ.L(reg,zone,c)*QFZ.L(reg,zone,c))/
                        sum((zone,c),PPZ.L(reg,zone,c)*QSZ.L(reg,zone,c)) ;


 demshrR(REG,C,%1,%2)$sum((zone,cp),QFZ0(reg,zone,cp))      =
                 sum((zone),PCZ.L(reg,zone,C)*QFZ.L(reg,zone,C))/sum((zone,cp),PCZ.L(reg,zone,cp)*QFZ.L(reg,zone,cp)) * 100;


* ================== ZONAL RESULTS =======================
CONZX(reg,zone,%1,%2)     = sum((c),PCZ0(reg,zone,c)*QFZ.L(reg,zone,C)) ;
 AgCONZX(reg,zone,%1,%2)   = sum((ag),PCZ0(reg,zone,ag)*QFZ.L(reg,zone,ag)) ;

 CONZpcX(reg,zone,%1,%2)$CONZX(reg,zone,%1,%2)           = CONZX(reg,zone,%1,%2)/(1000*sum((urbrur),PopH(reg,zone,urbrur)));
 AgCONZpcX(reg,zone,%1,%2)$AgCONZX(reg,zone,%1,%2)       = AgCONZX(reg,zone,%1,%2)/(1000*sum((urbrur),PopH(reg,zone,urbrur)));

 GDPZX(REG,ZONE,%1,%2)                     = GDPZpc.L(reg,zone)*1000*sum((urbrur),PopH(reg,zone,urbrur)) ;
*$ontext
 AgGDPZX(REG,ZONE,%1,%2)                   = sum(ag$(QSZ0(reg,zone,ag) and not cereal(ag)),PPZ.L(reg,zone,ag)*QSZ.L(reg,zone,ag))
                                      + sum(cereal$(QSZ0(reg,zone,cereal) and DQTZ0(reg,zone,cereal) gt 0),
                                  PPZ0(reg,zone,cereal)*PopHShare(reg,zone,'rur')*QSZ.L(reg,zone,cereal) +
                                  PPZ.L(reg,zone,cereal)*(1 - PopHShare(reg,zone,'rur'))*QSZ.L(reg,zone,cereal))
                                      + sum(cereal$(QSZ0(reg,zone,cereal) and DQTZ0(reg,zone,cereal) le 0),
                                  PPZ0(reg,zone,cereal)*PopHShare(reg,zone,'rur')*QFZ.L(reg,zone,cereal) +
                                  PPZ.L(reg,zone,cereal)*(QSZ.L(reg,zone,cereal) - PopHShare(reg,zone,'rur')*QFZ.L(reg,zone,cereal)));
*$offtext
* AgGDPZX(REG,ZONE,%1,%2)                  = sum(ag,PPZ.L(reg,zone,ag)*QSZ.L(reg,zone,ag)) ;
 NAgGDPZX(REG,ZONE,%1,%2)                  = sum(nag,PPZ.L(reg,zone,nag)*QSZ.L(reg,zone,nag)) ;
* NAgGDPZX(REG,ZONE,%1,%2)                  = sum(nag,PPZ0(reg,zone,nag)*QSZ.L(reg,zone,nag)) ;

 GDPZpcX(REG,ZONE,%1,%2)$sum(urbrur,PopH(reg,zone,urbrur))        = GDPZpc.L(reg,zone);
 AgGDPZpcX(REG,ZONE,%1,%2)$sum(urbrur,PopH(reg,zone,urbrur))      = AgGDPZX(REG,ZONE,%1,%2)/(1000*sum(urbrur,PopH(reg,zone,urbrur)));
 NAgGDPZpcX(REG,ZONE,%1,%2)$sum(urbrur,PopH(reg,zone,urbrur))     = NAgGDPZX(REG,ZONE,%1,%2)/(1000*sum(urbrur,PopH(reg,zone,urbrur)));


CALZPCX(REG,ZONE,C,%1,%2)$sum(urbrur,PopH(reg,zone,urbrur)) = 10*KcalRatio(C)*QFZ.L(reg,zone,c)/(365*sum(urbrur,PopH(reg,zone,urbrur))) ;
TCALZPCX(REG,ZONE,%1,%2)$SUM(URBRUR,PopH(reg,zone,urbrur))  = sum(C,CALZPCX(REG,ZONE,C,%1,%2) ) ;

IncomeBalZX(reg,zone,%1,%2)$sum(c,PPZ.L(reg,zone,c)*QSZ.L(reg,zone,c)) =
          sum(c,PCZ.L(reg,zone,c)*QFZ.L(reg,zone,c))/sum(c,PPZ.L(reg,zone,c)*QSZ.L(reg,zone,c)) ;


* ================ Income (from GDP) ===============
HHIZX(reg,zone,'urb',HHS,%1,%2)          = HHIZshare(reg,zone,'urb',HHS)*NAgGDPZX(reg,zone,%1,%2);
HHIZX(reg,zone,'rur',HHS,%1,%2)          = HHIZshare(reg,zone,'rur',HHS)*AgGDPZX(reg,zone,%1,%2);

HHIZX(reg,zone,'rur',HHS,%1,%2)$(sum(HHSP,HHIZshare(reg,zone,'urb',HHSP)) eq 0)
          = HHIZshare(reg,zone,'rur',HHS)*(AgGDPZX(reg,zone,%1,%2) + NAgGDPZX(reg,zone,%1,%2));

HHIZX(reg,zone,'urb',HHS,%1,%2)$(sum(HHSP,HHIZshare(reg,zone,'rur',HHSP)) eq 0)
          = HHIZshare(reg,zone,'urb',HHS)*(AgGDPZX(reg,zone,%1,%2) + NAgGDPZX(reg,zone,%1,%2));

PoPHZX(reg,zone,urbrur,%1,%2)            = PopH(reg,zone,urbrur);
HHIZpcX(reg,zone,urbrur,HHS,%1,%2)$HHIZX(reg,zone,urbrur,HHS,%1,%2) =
                    HHIZX(reg,zone,urbrur,HHS,%1,%2)/(0.1*1000*PopHZX(reg,zone,urbrur,%1,%2));

HHpoorX(reg,zone,'rur',HHS,%1,%2)$(HHIZpcX(reg,zone,'rur',HHS,%1,%2) gt 0 and HHIZpcX(reg,zone,'rur',HHS,%1,%2) le 0.7531*97.54) =
                    HHIZpcX(reg,zone,'rur',HHS,%1,%2);
HHpoorX(reg,zone,'urb',HHS,%1,%2)$(HHIZpcX(reg,zone,'urb',HHS,%1,%2) gt 0 and HHIZpcX(reg,zone,'urb',HHS,%1,%2) le 1.2427*115.26) =
                    HHIZpcX(reg,zone,'urb',HHS,%1,%2) ;

PoPpoorZX(reg,zone,urbrur,%1,%2)$sum(HHS,HHpoorX(reg,zone,urbrur,HHS,%1,%2)) =
                sum(HHS$HHpoorX(reg,zone,urbrur,HHS,%1,%2),HHIZX(reg,zone,urbrur,HHS,%1,%2)/
                                         HHIZpcX(reg,zone,urbrur,HHS,%1,%2)) ;

PoPpoorHX(urbrur,%1,%2)  = sum((reg,zone),PoPpoorZX(reg,zone,urbrur,%1,%2));
PoPpoorX(%1,%2)          = sum((reg,zone,urbrur),PoPpoorZX(reg,zone,urbrur,%1,%2));

PoorLineAllX(%1,%2)$sum(urbrur,PoPpoorHX(urbrur,%1,%2)) =
       100*sum(urbrur,PoPpoorHX(urbrur,%1,%2))/sum((reg,zone,urbrur),1000*PoPHZX(reg,zone,urbrur,%1,%2)) ;

PoorLineHX(urbrur,%1,%2)$PoPpoorHX(urbrur,%1,%2) =
       100*PoPpoorHX(urbrur,%1,%2)/sum((reg,zone),1000*PoPHZX(reg,zone,urbrur,%1,%2)) ;

PoorLineRuR_DEFX(%1,%2) =
          100*sum((reg,zone)$(sum(cereal,QFZ.L(reg,zone,cereal) - QSZ.L(reg,zone,cereal)) gt 0),
          PoPpoorZX(reg,zone,'rur',%1,%2))/sum((reg,zone)$(sum(cereal,QFZ.L(reg,zone,cereal) - QSZ.L(reg,zone,cereal)) gt 0),
          1000*PoPHZX(reg,zone,'rur',%1,%2)) ;

PoorLineRuR_SURX(%1,%2) =
          100*sum((reg,zone)$(sum(cereal,QFZ.L(reg,zone,cereal) - QSZ.L(reg,zone,cereal)) le 0),
          PoPpoorZX(reg,zone,'rur',%1,%2))/sum((reg,zone)$(sum(cereal,QFZ.L(reg,zone,cereal) - QSZ.L(reg,zone,cereal)) le 0),
          1000*PoPHZX(reg,zone,'rur',%1,%2)) ;



GDPZHX(Naddis,zone,'urb',%1,%2)        = incomenagsh(Naddis,zone,'urb')*sum(nag$QSZ0(Naddis,zone,nag),
                                       PPZ0(Naddis,zone,nag)*QSZ.L(Naddis,zone,nag)) ;

GDPZHX('addisAbaba',zone,'urb',%1,%2)  = sum(c$QSZ0('AddisAbaba',zone,c),PPZ0('AddisAbaba',zone,c)*QSZ.L('AddisAbaba',zone,c)) ;

GDPZHX(Naddis,zone,'rur',%1,%2)$(GDPZH0(Naddis,zone,'rur') and AGCPIX(%1,%2))        = (incomenagsh(Naddis,zone,'rur')*
             sum(nag$QSZ0(Naddis,zone,nag),PPZ0(Naddis,zone,nag)*QSZ.L(Naddis,zone,nag))
           + sum(ag,PPZ0(Naddis,zone,ag)*QSZ.L(Naddis,zone,ag)) ) ;

GDPZHpcX(REG,zone,urbrur,%1,%2)$GDPZHX(REG,zone,urbrur,%1,%2)         = GDPZHX(REG,zone,urbrur,%1,%2)/(1000*PopH(reg,zone,urbrur)) ;



* ================ Inputtype ================
GrainACZ_inputTypeX(reg,zone,type,%1,%2)                          = sum(cereal,ACZ_input.L(reg,zone,cereal,type));
GrainTACZ_inputTypeX(type,%1,%2)                                  = sum((reg,zone,cereal),ACZ_input.L(reg,zone,cereal,type));
GrainTQSZ_inputTypeX(type,%1,%2)                                  = sum((reg,zone,cereal),QSZ_input.L(reg,zone,cereal,type));
GrainTYCZ_inputTypeX(type,%1,%2)$GrainTACZ_inputTypeX(type,%1,%2) = 1000*GrainTQSZ_inputTypeX(type,%1,%2)/GrainTACZ_inputTypeX(type,%1,%2);

TACZ_inputTypeX(type,%1,%2)                                       = sum((reg,zone,c),ACZ_input.L(reg,zone,c,type));
TQSZ_inputTypeX(type,%1,%2)                                       = sum((reg,zone,c),QSZ_input.L(reg,zone,c,type));
TYCZ_inputTypeX(type,%1,%2)$TACZ_inputTypeX(type,%1,%2)           = 1000*TQSZ_inputTypeX(type,%1,%2)/TACZ_inputTypeX(type,%1,%2);

TYC_inputTypeX(crop,type,%1,%2)$sum((reg,zone),ACZ_input.L(reg,zone,crop,type))
                                                                  = 1000*sum((reg,zone),QSZ_input.L(reg,zone,crop,type))/sum((reg,zone),ACZ_input.L(reg,zone,crop,type));
TAC_inputX(c,type,%1,%2)                                          = sum((reg,zone),ACZ_input.L(reg,zone,c,type));


