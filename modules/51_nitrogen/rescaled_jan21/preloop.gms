*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

vm_emissions_reg.fx(i,emis_source,n_pollutants) = 0;
vm_emissions_reg.lo(i,emis_source_n51,n_pollutants) = -Inf;
vm_emissions_reg.up(i,emis_source_n51,n_pollutants) = Inf; 
