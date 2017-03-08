set
sim        simulation scenarios
 /base,croparea5,croparea10,croparea15,croparea20,croparea25,croparea30,croparea35,croparea40
croparea45,croparea50,croparea55,croparea60,croparea65,croparea70,croparea75,croparea80,croparea85,
croparea90,croparea95/
y          year     /1983*2011/
;

parameter
cyf(reg,zone,c,y)
cyf83(reg,zone,c),cyf84(reg,zone,c),cyf85(reg,zone,c),cyf86(reg,zone,c),cyf87(reg,zone,c)
cyf88(reg,zone,c),cyf89(reg,zone,c),cyf90(reg,zone,c),cyf91(reg,zone,c),cyf92(reg,zone,c)
cyf93(reg,zone,c),cyf94(reg,zone,c),cyf95(reg,zone,c),cyf96(reg,zone,c),cyf97(reg,zone,c)
cyf98(reg,zone,c),cyf99(reg,zone,c),cyf00(reg,zone,c),cyf01(reg,zone,c),cyf02(reg,zone,c)
cyf03(reg,zone,c),cyf04(reg,zone,c),cyf05(reg,zone,c),cyf06(reg,zone,c),cyf07(reg,zone,c)
cyf08(reg,zone,c),cyf09(reg,zone,c),cyf10(reg,zone,c),cyf11(reg,zone,c) climate yield factor 1983-2011

PPX(c,sim,y)                            producer price
PCX(c,sim,y)                            consumer price
PPZX(reg,zone,c,sim,y)                  zonal producer price
PCZX(reg,zone,c,sim,y)                  zonal consumer price
QFZX(reg,zone,c,sim,y)                  zonal food demand
QFZpcX(reg,zone,c,sim,y)                zonal per capita food demand
QFZHpcX(reg,zone,urbrur,c,sim,y)        zonal per capita food demand urban or rural
QLZX(reg,zone,c,sim,y)                  zonal livestock demand
QOZX(reg,zone,c,sim,y)                  zonal other demand
QDZX(reg,zone,c,sim,y)                  zonal total demand
ACZX(reg,zone,c,sim,y)                  zonal crop area
YCZX(reg,zone,c,sim,y)                  zonal crop yield
QSZX(reg,zone,c,sim,y)                  zonal supply
ACZ_inputX(reg,zone,c,type,sim,y)       with technology input
YCZ_inputX(reg,zone,c,type,sim,y)       with technology input
QSZ_inputX(reg,zone,c,type,sim,y)       with technology input
TQSX(c,sim,y)                           total supply
TACX(c,sim,y)                           total area
TACZX(reg,zone,sim,y)                   total area by zone
GDPZpcX(reg,zone,sim,y)                 zonal per capita GDP
GDPZHpcX(reg,zone,urbrur,sim,y)         zonal per capita GDP urban or rural
CPIX(sim,y)                             consumer price index
EXRX (sim,y)                            exchange rate
DQTZX(reg,zone,c,sim,y)                 net balance volume by zone
QMX(c,sim,y)                            imports
QEX(c,sim,y)                            exports

QFZHX(reg,zone,urbrur,c,sim,y)
QTX(c,sim,y)
DQMZX(reg,zone,c,sim,y)
DQEZX(reg,zone,c,sim,y)
GDPZHX(reg,zone,urbrur,sim,y)
;
$include paramsetup.inc

$CALL 'GDXXRW Input/newcyf2.xls se=0 index=Index!A1'

$gdxin  newcyf2.gdx
$LOAD   cyf83,cyf84,cyf85,cyf86,cyf87,cyf88,cyf89,cyf90,cyf91,cyf92,cyf93
$LOAD   cyf94,cyf95,cyf96,cyf97,cyf98,cyf99,cyf00,cyf01,cyf02,cyf03,cyf04,cyf05
$LOAD   cyf06,cyf07,cyf08,cyf09,cyf10,cyf11
$gdxin

cyf(reg,zone,c,'1983')= cyf83(reg,zone,c);
cyf(reg,zone,c,'1984')= cyf84(reg,zone,c);
cyf(reg,zone,c,'1985')= cyf85(reg,zone,c);
cyf(reg,zone,c,'1986')= cyf86(reg,zone,c);
cyf(reg,zone,c,'1987')= cyf87(reg,zone,c);
cyf(reg,zone,c,'1988')= cyf88(reg,zone,c);
cyf(reg,zone,c,'1989')= cyf89(reg,zone,c);
cyf(reg,zone,c,'1990')= cyf90(reg,zone,c);
cyf(reg,zone,c,'1991')= cyf91(reg,zone,c);
cyf(reg,zone,c,'1992')= cyf92(reg,zone,c);
cyf(reg,zone,c,'1993')= cyf93(reg,zone,c);
cyf(reg,zone,c,'1994')= cyf94(reg,zone,c);
cyf(reg,zone,c,'1995')= cyf95(reg,zone,c);
cyf(reg,zone,c,'1996')= cyf96(reg,zone,c);
cyf(reg,zone,c,'1997')= cyf97(reg,zone,c);
cyf(reg,zone,c,'1998')= cyf98(reg,zone,c);
cyf(reg,zone,c,'1999')= cyf99(reg,zone,c);
cyf(reg,zone,c,'2000')= cyf00(reg,zone,c);
cyf(reg,zone,c,'2001')= cyf01(reg,zone,c);
cyf(reg,zone,c,'2002')= cyf02(reg,zone,c);
cyf(reg,zone,c,'2003')= cyf03(reg,zone,c);
cyf(reg,zone,c,'2004')= cyf04(reg,zone,c);
cyf(reg,zone,c,'2005')= cyf05(reg,zone,c);
cyf(reg,zone,c,'2006')= cyf06(reg,zone,c);
cyf(reg,zone,c,'2007')= cyf07(reg,zone,c);
cyf(reg,zone,c,'2008')= cyf08(reg,zone,c);
cyf(reg,zone,c,'2009')= cyf09(reg,zone,c);
cyf(reg,zone,c,'2010')= cyf10(reg,zone,c);
cyf(reg,zone,c,'2011')= cyf11(reg,zone,c);

loop(y,

KcMean(reg,zone,c)$QSZ0(reg,zone,c) = 1 ;
KcMean(reg,zone,raincrop)           = cyf(reg,zone,raincrop,y) ;
KcMean(reg,zone,'Barley')           = cyf(reg,zone,'Sorghum',y) ;
KcMean(reg,zone,cash)               = cyf(reg,zone,'Enset',y) ;

SOLVE MULTIMKT USING MCP;
*display CPI.L;
$BATINCLUDE simLoopSave.inc  "'base'" 'y'

*Reset values
 PP.L(c)                = PP0(c);
 PC.L(c)                = PC0(c);
 PPZ.L(reg,zone,c)      = PPZ0(reg,zone,c);
 PCZ.L(reg,zone,c)      = PCZ0(reg,zone,c);

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
* GAPZ.L(reg,zone,c) =  gapZ0(reg,zone,c);
);


*Execute_Unload 'tmp1.gdx',PCX,PPX,PPZX,PCZX,QFZX,QFZpcX,QFZHpcX,QLZX,QOZX,QDZX,ACZX,YCZX,QSZX,ACZ_inputX,YCZ_inputX,QSZ_inputX,TQSX,TACX,TACZX,
*GDPZpcX,GDPZHpcX,CPIX,EXRX,DQTZX,QMX,QEX;
*Execute 'GDXXRW.EXE tmp1.gdx O=simoutputY.xls index=INDEX!a1';
