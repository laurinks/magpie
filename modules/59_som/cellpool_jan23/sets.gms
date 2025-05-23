*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

sets

noncropland59(land) Soil carbon conserving landuse types
/past, forestry, primforest, secdforest, other, urban/

tillage59 Tillage categories of IPCC
/full_tillage,reduced_tillage,no_tillage/

inputs59 Input management categories of IPCC
/low_input,medium_input,high_input_nomanure,high_input_manure/

climate59_2019 Climate classes of IPCC 2019
/temperate_dry,temperate_moist,tropical_dry,tropical_moist,boreal_dry,boreal_moist/

climate59(climate59_2019) Climate classes of IPCC 2006
/temperate_dry,temperate_moist,tropical_dry,tropical_moist/

*** Csa, Dwa should be dry (maybe others as well)

clcl_climate59(clcl,climate59) Climate classification types
           /
           Af .(tropical_moist) "equatorial fully humid"
           Am .(tropical_moist) "equatorial monsoonal"
           As .(tropical_moist) "equatorial summer dry"
           Aw .(tropical_moist) "equatorial winter dry"
           BSh .(tropical_dry) "arid steppe hot arid"
           BSk .(temperate_dry) "arid steppe cold arid"
           BWh .(tropical_dry) "arid desert hot arid"
           BWk .(temperate_dry) "arid desert cold arid"
           Cfa .(temperate_moist) "warm temperate fully humid hot summer"
           Cfb .(temperate_moist) "warm temperate fully humid warm summer"
           Cfc .(temperate_moist) "warm temperate fully humid cool summer"
           Csa .(temperate_moist) "warm temperate winter dry hot summer"
           Csb .(temperate_moist) "warm temperate winter dry warm summer"
           Csc .(temperate_moist) "warm temperate winter dry cool summer"
           Cwa .(temperate_moist) "warm temperate winter dry hot summer"
           Cwb .(temperate_moist) "warm temperate winter dry warm summer"
           Cwc .(temperate_moist) "warm temperate winter dry cool summer"
           Dfa .(temperate_moist) "snow fully humid hot summer"
           Dfb .(temperate_moist) "snow fully humid warm summer"
           Dfc .(temperate_moist) "snow fully humid cool summer"
           Dfd .(temperate_moist) "snow fully humid extremely continental"
           Dsa .(temperate_moist) "snow winter dry hot summer"
           Dsb .(temperate_moist) "snow winter dry warm summer"
           Dsc .(temperate_moist) "snow winter dry cool summer"
           Dsd .(temperate_dry) "snow winder dry extremely continental"
           Dwa .(temperate_moist) "snow winter dry hot summer"
           Dwb .(temperate_moist) "snow winter dry warm summer"
           Dwc .(temperate_moist) "snow winter dry cool summer"
           Dwd .(temperate_dry) "snow winter dry extremely continental"
           EF .(temperate_dry) "polar polar frost"
           ET .(temperate_moist) "polar polar tundra"
           /
;

alias(noncropland59,noncropland59_2);
