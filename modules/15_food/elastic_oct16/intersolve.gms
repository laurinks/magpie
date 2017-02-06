
* retrieving interfaces from MAgPIE
*calculate prices for providing 1 kcal per day of one commodity

if (s15_standalone=1,
    display "Standalone: taking exogenous demand shock";
    p15_prices_kcal(t,iso,kfo)=i15_prices_initial_kcal(iso,kfo)*f15_price_index(t);

else
    display "Coupling: Reading out Marginal Costs from MAgPIE as shock to demand model";
    o15_prices_kcal(t,iso,kall)=0;
    o15_prices_kcal(t,iso,kfo)=sum(i_to_iso(i,iso), q15_food_demand.m(i,kfo));
    o15_prices_kcal(t,iso,kfo)$(f15_nutrition_attributes("y1995",kfo,"kcal")>0)=o15_prices_kcal(t,iso,kfo) / f15_nutrition_attributes("y1995",kfo,"kcal")*365/10**6;
    p15_prices_kcal(t,iso,kfo)=o15_prices_kcal(t,iso,kfo);
);

p15_iteration_counter(t)= p15_iteration_counter(t) + 1;

display "starting demand model....";

solve m15_food_demand USING nlp MAXIMIZING v15_objective ;
p15_modelstat(t) = m15_food_demand.modelstat;

display "Food Demand Model finished with modelstat ";
display p15_modelstat;

if(( p15_modelstat(t)) > 2 and (p15_modelstat(t) ne 7 ),
  m15_food_demand.solprint = 1
  Execute_Unload "fulldata.gdx";
  abort "Food Demand Model became unfeasible. Should not be the case.";
);


* estimate regional indicators from demand model
 p15_kcal_pc(t,i,kfo)$(
     sum(i_to_iso(i,iso),
       i15_pop_iso(t,iso)
     ) >0 ) =
                             sum(i_to_iso(i,iso),
                                 v15_demand_quantity.l(iso,kfo)* i15_pop_iso(t,iso)
                             ) / sum(i_to_iso(i,iso),
                                 i15_pop_iso(t,iso)
                             );


* as regional indicators are not yet calibrated, just apply the delta

 p15_delta_kcal_pc(t,i,kall)$(p15_kcal_pc_initial(t,i,kall)>0) = p15_kcal_pc(t,i,kall)/p15_kcal_pc_initial(t,i,kall) ;

* Convergence Measure: Quadratic deviations of per-capita consumption between 2 iterations

 p15_convergence_measure(t) =sum((i,kfo),
                              abs(p15_delta_kcal_pc(t,i,kfo) / p15_lastiteration_delta_kcal_pc(i,kfo)- 1)**2
                            )/card(i);


* keeping current deltas for estimating convergence in next timestep
 p15_lastiteration_delta_kcal_pc(i,kall) = p15_delta_kcal_pc(t,i,kall);



display "finished iteration number ", p15_iteration_counter;
display "convergence measure:",p15_convergence_measure;

if (p15_convergence_measure(t) > 0.4,


      display "convergence between MAgPIE and Food Demand Model not yet reached";
      sm_intersolve=0;

      if((p15_iteration_counter(t) >= s15_maxiter),
        m15_food_demand.solprint = 1
        Execute_Unload "fulldata.gdx";
        abort "no convergence between food demand model and magpie reached";
      else
        display "Food Demand Model results are returned to MAgPIE";
      );
       v15_kcal_pc.fx(i,kall)=0;
       v15_kcal_pc.fx(i,kfo)=i15_kcal_pc_initial(t,i,kfo)*p15_delta_kcal_pc(t,i,kfo);

      if (p15_modelstat(t) < 3,
         put_utility 'shell' / 'mv m15_food_demand_p.gdx m15_food_demand_' t.tl:0'.gdx';
      );

else

     sm_intersolve=1;
     display "Success: convergence between MAgPIE and Food Demand Model reached after ",p15_iteration_counter," iterations";
* set back convergence indicators for next timestep
);