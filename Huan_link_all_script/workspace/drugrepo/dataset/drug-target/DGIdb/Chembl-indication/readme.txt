step1:将interactions_v3中的来自于Chembl的部分筛出来，得interactions_v3-Chembl.txt，共7610行。
step2:将interactions_v3-Chembl和chembl_indications-17_13-38-29.txt通过chembl-id联系起来，得到step2-result.txt
共22499行。(2716个药物中有1491个药物有indication,有1225个没有indication)手动添加题头
没有匹配到indication的chembl得文件step2_result_unmatch.txt，共有文件3381行，对应药物1494个。收到添加题头

 

drug-indication.txt和molecule_dictionary.txt是由postgresql里的数据转成的txt,导进postgresql的数据是chembl23的数据。
molecule_dictionary.txt的题头是(molregno, pref_name, chembl_id, max_phase, therapeutic_flag, dosed_ingredient, structure_type, chebi_par_id, molecule_type, first_approval, oral, parenteral, topical, black_box_warning, natural_product, first_in_class, chirality, prodrug, inorganic_flag, usan_year, availability_type, usan_stem, polymer_flag, usan_substem, usan_stem_definition, indication_class, withdrawn_flag, withdrawn_year, withdrawn_country, withdrawn_reason)
step3: 将chembl数据库中下载的数据，将chembl_id 和drug-indication 联系起来，得到文件step3_result.txt得13504行，收到添加题头
step4: 将step2中没有匹配drug的step2_result_unmatch.txt，通过chembl_id与step3_result.txt联系。
  得到没有匹配到indication的drug文件是step4-unmatch-chembl，共855行。
  得到匹配到indication的drug文件是step4-result.txt，共3850行，匹配到370个drug。手动添加题头

  即 step2—result.txt和step4-result.txt为drug匹配到的indication文件。有
  step4-unmatch-chembl为drug未匹配到的indication文件。有855个drug


  statistic.pl : 将chembl中所有的drug_indication进行提取，得statistic.txt。
  用 statistic1.pl得  chembl_statistic_uni_drug_indication.txt 共863个  chembl_statistic_uni_drug.txt共1861个  chembl_statistic_uni_indication.txt共8327个
  