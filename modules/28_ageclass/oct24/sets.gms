*** |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

sets
ac_gfad Forest age classes in GFAD data set
/ class1, class2, class3, class4, class5,
class6, class7, class8, class9, class10,
class11, class12, class13, class14, class15 /

ac_young(ac) Young age classes
/ ac0, ac5, ac10, ac15, ac20, ac25, ac30 /

ac_gfad_to_ac(ac_gfad,ac) mapping between ac and ac_gfad
/
class1   .  (ac5,ac10)
class2   .  (ac15,ac20)
class3   .  (ac25,ac30)
class4   .  (ac35,ac40)
class5   .  (ac45,ac50)
class6   .  (ac55,ac60)
class7   .  (ac65,ac70)
class8   .  (ac75,ac80)
class9   .  (ac85,ac90)
class10  .  (ac95,ac100)
class11  .  (ac105,ac110)
class12  .  (ac115,ac120)
class13  .  (ac125,ac130)
class14  .  (ac135,ac140)
/

;

alias(ac_gfad,ac_gfad2);
alias(ac,ac2);
