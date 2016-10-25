model Ethiopia_MCP /

* Analysis Equations
* health
r_labour_eqn.r_labour

* distribution
C_labour_eqn.C_labour

* utilization
nu_working_eqn.nu_working

* MCP equations
* crop producer
L_A_crop.A_crop
L_q_crop_store_C.q_crop_store_C
g_crop_2.p_crop
g_crop_3.p_land
h_food_store.p_food_store

* livestock producer
L_q_milk_store_L.q_milk_store_L
L_q_beef_store_L.q_beef_store_L
L_q_cattle_transp_buy_L.q_cattle_transp_buy_L
L_q_cattle_transp_sell_L.q_cattle_transp_sell_L
L_N_cattle.N_cattle
g_livestock_1.p_milk
g_livestock_2.p_herd
h_cattle_transp_buy.p_cattle_transp_buy
h_cattle_transp_sell.p_cattle_transp_sell
h_livestock_1.p_cattle

* distribution
L_q_food_transp_sell_D.q_food_transp_sell_D
L_q_food_transfer_buy_D.q_food_transfer_buy_D
L_q_cattle_transp_buy_D.q_cattle_transp_buy_D
L_q_cattle_transp_sell_D.q_cattle_transp_sell_D
g_distribution_1.p_transp_eff
g_distribution_2.p_transp
g_distribution_4.p_transp_cattle
h_food_transfer_buy.p_food_transfer_buy
h_food_transp_sell.p_food_transp_sell

* storage/retail
L_q_food_market_S.q_food_market_S
L_q_food_transp_sell_S.q_food_transp_sell_S
L_q_food_transfer_buy_S.q_food_transfer_buy_S
L_q_food_store_S.q_food_store_S
L_Q_food.Q_food
g_storage_1.p_storage_food
g_storage_3.p_storage_empty
g_storage_4.p_clear
h_food_market.p_food_market
h_storage_1.p_storage_food_eff

* consumers
U_q_food_market_A.q_food_market_A/;
