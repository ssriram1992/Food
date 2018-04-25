$ontext
Parameters
p_area_crop(Adapt, Season)
p_q_food(Adapt, Season)
p_q_city_Start(Node, Season)
p_q_city_End(Node, Season)
p_consm(Adapt, Season)
;



Positive Variable P_TRANSP(NodeFrom, Node, Season), P_STOR(Node);
Variable P_obj;

Equations
P_E_BAL(Node, Season)
P_E_STOR(Node)
P_E_obj
;

P_E_BAL(Node, Season).. p_q_city_End(Node, Season) 
							=l= 
						p_q_city_Start(Node, Season) + P_STOR(Node)$SAMEAS(Season, "Belg")
						+ sum(NodeFrom, P_TRANSP(NodeFrom, Node, Season)) 
						- sum(NodeTo, P_TRANSP(Node, NodeTo, Season));
P_E_OBJ.. P_OBJ =e= sum((NodeFrom, Node, Season), P_TRANSP(NodeFrom, Node, Season) + P_STOR(Node)) ;

Model EstimTransp/
P_E_BAL
P_E_obj
/
;
$offtext
