*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

positive variables
 v71_feed_forage(j, kforage)                       Production of forage within a cell (mio. tDM per yr)
 v71_additional_mon(j, kli_mon)                    Additional punished production of monogastric livestock (mio. tDM per yr)
 vm_costs_additional_mon(i)                        Punishment cost for additionally transported monogastric livst_egg (mio. USD17MER per yr)
;

variables
 v71_feed_balanceflow(j, kforage)                  Cellular feed balanceflow for forage feed for ruminant livestock (mio. tDM per yr)
;

equations
 q71_feed_rum_liv(j, kforage)                      Production constraint for ruminant livestock products (mio. tDM per yr)
 q71_feed_forage(j)                                Forage feed constraint (mio. tDM per yr)
 q71_feed_balanceflow_nlp(j)                       Non-linear balanceflow constraint for forage feed products (mio. tDM per yr)
 q71_feed_balanceflow_lp(i)                        Linear balanceflow constraint for forage feed products (mio. tDM per yr)
 q71_prod_mon_liv(j,kli_mon)                       Production constraint for monogastric livestock products (mio. tDM per yr)
 q71_punishment_mon(i)                             Punishment for additional monogastrics (mio. USD17MER per yr)
;

parameters
 i71_urban_area_share(j)                           Share of urban area within a region (1)
;

scalars
 s71_lp_fix                                        Switch to fix equations to linear relation (Logical)
 s71_scale_mon                                     Scalar for flexible distribution of monogastrics (1)
 s71_punish_additional_mon                         Scaling factor for transport punishment (USD17MER per tDM)
;

*#################### R SECTION START (OUTPUT DECLARATIONS) ####################
parameters
 ov71_feed_forage(t,j,kforage,type)      Production of forage within a cell (mio. tDM per yr)
 ov71_additional_mon(t,j,kli_mon,type)   Additional punished production of monogastric livestock (mio. tDM per yr)
 ov_costs_additional_mon(t,i,type)       Punishment cost for additionally transported monogastric livst_egg (mio. USD17MER per yr)
 ov71_feed_balanceflow(t,j,kforage,type) Cellular feed balanceflow for forage feed for ruminant livestock (mio. tDM per yr)
 oq71_feed_rum_liv(t,j,kforage,type)     Production constraint for ruminant livestock products (mio. tDM per yr)
 oq71_feed_forage(t,j,type)              Forage feed constraint (mio. tDM per yr)
 oq71_feed_balanceflow_nlp(t,j,type)     Non-linear balanceflow constraint for forage feed products (mio. tDM per yr)
 oq71_feed_balanceflow_lp(t,i,type)      Linear balanceflow constraint for forage feed products (mio. tDM per yr)
 oq71_prod_mon_liv(t,j,kli_mon,type)     Production constraint for monogastric livestock products (mio. tDM per yr)
 oq71_punishment_mon(t,i,type)           Punishment for additional monogastrics (mio. USD17MER per yr)
;
*##################### R SECTION END (OUTPUT DECLARATIONS) #####################
