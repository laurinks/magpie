*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

*' @equations

*' Nitrogeneous emissions stem from manure applied to croplands, inorganic fertilizers,
*' crop residues decaying on fields, the burning of agricultural residues,
*' soil organic matter loss, animal waste management, and manure excreted on pasture land.
*' Additionally,  part of the NH3 and NOx emissions as well as leached NO3 later result
*' in indirect emissions of N2O when they are redeposited, nitrified and dinitrified.
*'
*' Emissions are rescaled using the nitrogen uptake efficiency. This is done to keep consistency
*' of emissions with nitrogen surplus and take account for improved emission factors when NUE increases.
*' The marginal abatement cost curves (MACCs) are already applied at the estimation
*' of the NUE in module 50_nr_soil_budget.
*'
*' Manure applied to croplands:
 q51_emissions_man_crop(i2,n_pollutants_direct)..
                 vm_emissions_reg(i2,"man_crop",n_pollutants_direct)
                 =e=
                 vm_manure_recycling(i2,"nr")
                 / (1-s51_snupe_base) * (1-vm_nr_eff(i2))
                 * sum(ct, i51_ef_n_soil(ct,i2,n_pollutants_direct,"man_crop"));

*' inorganic fertilizers:
 q51_emissions_inorg_fert(i2,n_pollutants_direct)..
                 vm_emissions_reg(i2,"inorg_fert",n_pollutants_direct)
                 =e=
                 vm_nr_inorg_fert_reg(i2,"crop")
                 / (1-s51_snupe_base) * (1-vm_nr_eff(i2))
                 * sum(ct, i51_ef_n_soil(ct,i2,n_pollutants_direct,"inorg_fert"))
                 + vm_nr_inorg_fert_reg(i2,"past")
                 / (1-s51_nue_pasture_base) * (1-vm_nr_eff_pasture(i2))
                 * sum(ct, i51_ef_n_soil(ct,i2,n_pollutants_direct,"inorg_fert"))
                ;

*' crop residues decaying on fields:
 q51_emissions_resid(i2,n_pollutants_direct)..
                 vm_emissions_reg(i2,"resid",n_pollutants_direct)
                 =e=
                 vm_res_recycling(i2,"nr") * sum(ct, i51_ef_n_soil(ct,i2,n_pollutants_direct,"resid"))
                 / (1-s51_snupe_base) * (1-vm_nr_eff(i2));

*' emissions from burning crop residues, N2O and NOx
 q51_emissions_resid_burn(i2,n_pollutants_direct)..
                 vm_emissions_reg(i2,"resid_burn",n_pollutants_direct)
                 =e=
                 sum(kcr, vm_res_ag_burn(i2,kcr,"dm")) * f51_ef_resid_burn(n_pollutants_direct);

*' soil organic matter loss:
 q51_emissions_som(i2,n_pollutants_direct)..
                 vm_emissions_reg(i2,"som",n_pollutants_direct)
                 =e=
                 sum(cell(i2,j2),vm_nr_som(j2)) * sum(ct, i51_ef_n_soil(ct,i2,n_pollutants_direct,"som"))
                 / (1-s51_snupe_base) * (1-vm_nr_eff(i2));

*' animal waste management
*' Here we apply the marginal abatement cost curves to the emissions of all
*' N pollutants. The measures (e.g. decreased storage time, coverage) are not
*' specific to N2O and assumed to apply also to NH3 and other losses.
 q51_emissionbal_awms(i2,n_pollutants_direct) ..
                 vm_emissions_reg(i2,"awms",n_pollutants_direct)
                 =e=
                 sum((kli,awms_conf),
                    vm_manure_confinement(i2,kli,awms_conf,"nr")
                    * f51_ef3_confinement(i2,kli,awms_conf,n_pollutants_direct))
                    * (1-sum(ct, im_maccs_mitigation(ct,i2,"awms","n2o_n_direct")));

*' and manure excreted on pasture land:
 q51_emissionbal_man_past(i2,n_pollutants_direct) ..
                 vm_emissions_reg(i2,"man_past",n_pollutants_direct)
                 =e=
                 sum((awms_prp,kli),
                     vm_manure(i2, kli, awms_prp, "nr")
                     * f51_ef3_prp(i2,n_pollutants_direct,kli))
                 / (1-s51_nue_pasture_base) * (1-vm_nr_eff_pasture(i2));

*' Indirect emissions from NH3, NOx and NO3:
 q51_emissions_indirect_n2o(i2,emis_source_n51) ..
                 vm_emissions_reg(i2,emis_source_n51,"n2o_n_indirect")
                 =e=
                 sum(pollutant_nh3no2_51,vm_emissions_reg(i2,emis_source_n51,pollutant_nh3no2_51))
                    * f51_ipcc_ef("ef_4","best")
                 + vm_emissions_reg(i2,emis_source_n51,"no3_n")
                   * f51_ipcc_ef("ef_5","best");

*** EOF constraints.gms ***
