option solvelink=5;
* please look at Excel file 'Parameters and Variables' for parameter/variable descriptions
$include "Set_Declarations_small"

* watch out for parameters that show up here and in GAMS
$include "Parameter_Declarations_small"
$include "Table_Declarations_small"
$include "Parameter_Calculations_small"
$include "Scenario_Parameters_small"
$include "Variable_Declarations_small"

parameters
* node/year specific parameters
p_fuel_ave_y(adv),m_crop_y(c,s_active,n_active,m,adv),
         eta_production_y(n_active,m,adv),
         C_fuel_y(n_from,n_to,m,adv),r_loss_storage_y(f,n_active,m,adv),
         r_loss_transp_y(f,n_from,n_to,m,adv),q_food_aid_y(f,n_active,m,adv)
         sub_consumers_y(f,n_active,m,adv),sub_producers_y(f,n_active,m,adv),
         a_food_y(f,n_active,I,m,adv),transp_exp_y(n_from,n_to,adv),
         m_clear_y(n_active,adv);

parameters
* record important values from year to year
r_labour_rec(n_active,m,y_active),N_cattle_rec(n_active,m,y_active),
         q_food_market_S_rec(f,n_active,m,y_active),
         q_food_store_rec(f,n_active,m,y_active),
         Q_food_rec(f,n_active,m,y_active),
         q_food_market_A_rec(f,n_active,I,m,y_active),
         p_food_market_rec(f,n_active,m,y_active),A_crop_rec(c,s_active,n_active,y_active),
         q_food_transp_rec(f,n_from,n_to,m,y_active,adv),
         q_cattle_transp_rec(n_from,n_to,m,y_active,adv);


r_labour_rec(n_active,m,y_active) = 0;
N_cattle_rec(n_active,m,y_active) = 0;
q_food_market_S_rec(f,n_active,m,y_active) = 0;
q_food_market_A_rec(f,n_active,I,m,y_active) = 0;
q_food_store_rec(f,n_active,m,y_active) = 0;
Q_food_rec(f,n_active,m,y_active) = 0;
p_food_market_rec(f,n_active,m,y_active) = 0;
A_crop_rec(c,s_active,n_active,y_active) = 0;
q_food_transp_rec(f,n_from,n_to,m,y_active,adv) = 0;
q_cattle_transp_rec(n_from,n_to,m,y_active,adv) = 0;

$include "Equations_Calculations_small"
$include "MCP_Definition_small"


OPTION RESLIM = 1e5;
Ethiopia_MCP.tolInfRep = 1e-6;
OPTION mcp = path;


**** Sriram's modifications to fix months - delete this




Set mfix(m) /2*11/;
r_labour.fx(n_active,mfix,adv) = 0;
q_crop_store_C.fx(c,n_active,mfix,adv)=0;
q_milk_store_L.fx(n_active,mfix,adv)=0;
q_beef_store_L.fx(n_active,mfix,adv)=0;
q_cattle_transp_buy_L.fx(n_from,n_to,mfix,adv)=0;
q_cattle_transp_sell_L.fx(n_from,n_to,mfix,adv)=0;
N_cattle.fx(n_active,mfix,adv)=0;
q_food_transp_sell_D.fx(f,n_from,n_to,mfix,adv)=0;
C_labour.fx(n_from,n_to,mfix,adv)=0;
q_cattle_transp_sell_D.fx(n_from,n_to,mfix,adv)=0;
q_food_store_S.fx(f,n_active,mfix,adv)=0;
q_food_transfer_buy_S.fx(f,n_from,n_to,mfix,adv)=0;
q_food_transp_sell_S.fx(f,n_from,n_to,mfix,adv)=0;
q_food_market_S.fx(f,n_active,mfix,adv)=0;
Q_food.fx(f,n,mfix,adv)=0;
nu_working.fx(nut,n_active,mfix,adv)=0;
p_cattle_transp_buy.fx(n_from,n_to,mfix,adv)=0;
p_cattle_transp_sell.fx(n_from,n_to,mfix,adv)=0;
p_food_store.fx(f,n_active,mfix,adv)=0;
p_food_market.fx(f,n_active,mfix,adv)=0;
p_food_transp_sell.fx(f,n_from,n_to,mfix,adv)=0;
p_food_transfer_buy.fx(f,n_from,n_to,mfix,adv)=0;
q_cattle_transp_buy_D.fx(n_from,n_to,mfix,adv)=0;
q_food_transfer_buy_D.fx(f,n_from,n_to,mfix,adv)=0;
q_food_market_A.fx(f,n_active,I,mfix,adv)=0;
p_crop.fx(c,n_active,mfix,adv)=0;
p_milk.fx(n_active,mfix,adv)=0;
p_herd.fx(n_active,mfix,adv)=0;
p_cattle.fx(n_active,mfix,adv)=0;
p_transp_eff.fx(f,n_from,n_to,mfix,adv)=0;
p_transp.fx(n_from,n_to,mfix,adv)=0;
p_transp_cattle.fx(n_from,n_to,mfix,adv)=0;
p_storage_food.fx(f,n_active,mfix,adv)=0;
p_storage_empty.fx(f,n,mfix,adv)=0;
p_storage_food_eff.fx(f,n_active,mfix,adv)=0;



**** Sriram's modifications end






loop(y_active,

*        extract the year-specific versions of certain parameters

         C_fuel_y(n_from,n_to,m,adv) = C_fuel(n_from,n_to,m,y_active,adv);
         p_fuel_ave_y(adv) = p_fuel_ave(y_active,adv);
         m_crop_y(c,s_active,n_active,m,adv) = m_crop(c,s_active,n_active,m,y_active,adv);
         eta_production_y(n_active,m,adv) = eta_production(n_active,m,y_active,adv);
         r_loss_storage_y(f,n_active,m,adv) = r_loss_storage(f,n_active,m,y_active,adv);
         r_loss_transp_y(f,n_from,n_to,m,adv) = r_loss_transp(f,n_from,n_to,m,y_active,adv);
         m_clear_y(n_active,adv) = m_clear(n_active,y_active,adv);
         q_food_aid_y(f,n_active,m,adv) = q_food_aid(f,n_active,m,y_active,adv);
         sub_consumers_y(f,n_active,m,adv) = sub_consumers(f,n_active,m,y_active,adv);
         sub_producers_y(f,n_active,m,adv) = sub_producers(f,n_active,m,y_active,adv);
         a_food_y(f,n_active,I,m,adv) = a_food(f,n_active,I,m,y_active,adv);
         transp_exp_y(n_from,n_to,adv) = transp_exp(n_from,n_to,y_active,adv);

*        initialize the starting number of cattle and total food stored for each year
         if((not yfirst(y_active)),
                 N_cattle_init(n_active) = N_cattle_rec(n_active,'12',y_active-1);
                 Q_food_init(f,n_active) = Q_food_rec(f,n_active,'12',y_active-1);
         );

         solve Ethiopia_MCP using MCP;

         r_labour_rec(n_active,m,y_active) = r_labour.l(n_active,m,'1');
         N_cattle_rec(n_active,m,y_active) = N_cattle.l(n_active,m,'1');
         q_food_market_S_rec(f,n_active,m,y_active) = q_food_market_S.l(f,n_active,m,'1');
         q_food_market_A_rec(f,n_active,I,m,y_active) = q_food_market_A.l(f,n_active,I,m,'1');
         q_food_store_rec(f,n_active,m,y_active) = q_food_store_S.l(f,n_active,m,'1');
         Q_food_rec(f,n_active,m,y_active) = Q_food.l(f,n_active,m,'1');
         p_food_market_rec(f,n_active,m,y_active) = p_food_market.l(f,n_active,m,'1');
         A_crop_rec(c,s_active,n_active,y_active) = A_crop.l(c,s_active,n_active,'1');
         q_food_transp_rec(f,n_from,n_to,m,y_active,adv) = q_food_transfer_buy_D.l(f,n_from,n_to,m,'1');
         q_cattle_transp_rec(n_from,n_to,m,y_active,adv) = q_cattle_transp_buy_D.l(n_from,n_to,m,'1');


);

* export data to Matlab for postprocessing

Execute_Unload 'Ethiopia_small_MCP.gdx',q_food_market_A_rec,p_food_market_rec,Q_food_rec,
         q_food_store_rec,q_food_market_S_rec,N_cattle_rec,
         A_crop_rec,q_food_transp_rec,q_cattle_transp_rec;


