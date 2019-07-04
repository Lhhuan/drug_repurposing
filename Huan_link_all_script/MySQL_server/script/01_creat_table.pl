USE OncoRepo;
CREATE TABLE `Cancer_gene_role` (
  `id` int(11) AUTO_INCREMENT,
  `symbol` varchar(255) NOT NULL,
  `Role_in_cancer` varchar(255) NOT NULL,
  `Source` varchar(255) NOT NULL,
  `ENSG_ID` varchar(255) DEFAULT NULL,
  INDEX (`ENSG_ID`),
  PRIMARY KEY (`id`)
);

CREATE TABLE `Drug_chembl_id` (
  `id` int(11) AUTO_INCREMENT,
  `Unique_drug_name` varchar(255) NOT NULL,
  `Drug_chembl_id` varchar(255) DEFAULT NULL,
  INDEX (`Unique_drug_name`,`Drug_chembl_id`),
  PRIMARY KEY (`id`)
);

CREATE TABLE `Drug_claim_primary_name` (
  `id` int(11) AUTO_INCREMENT,
  `Unique_drug_name` varchar(255) NOT NULL,
  `Drug_claim_primary_name` varchar(255) DEFAULT NULL,
  INDEX (`Unique_drug_name`,`Drug_claim_primary_name`),
  PRIMARY KEY (`id`)
);


CREATE TABLE `Drug_indication` (
  `id` int(11) AUTO_INCREMENT,
  `Unique_drug_name` varchar(255) NOT NULL,
  `Max_phase` varchar(3072) DEFAULT NULL,
  `First_approval` varchar(3072) DEFAULT NULL,
  `Indication_class` varchar(3072) DEFAULT NULL,
  `Drug_indication` varchar(3072) DEFAULT NULL,
  `Drug_indication_Indication_class` varchar(3072) DEFAULT NULL,
  `Indication_ID` int(11) NOT NULL,
  `Drug_indication_source` varchar(255) DEFAULT NULL,
  INDEX (`Indication_ID`, `Unique_drug_name`),
  PRIMARY KEY (`id`)
);

CREATE TABLE `Drug_indication_map_information` (
  `id` int(11) AUTO_INCREMENT,
  `Indication_ID` int(11) NOT NULL,
  `DOID` varchar(255) DEFAULT NULL,
  `DO_term` varchar(255) DEFAULT NULL,
  `HPO_ID` varchar(255) DEFAULT NULL,
  `HPO_term` varchar(255) DEFAULT NULL,
  `indication_OncoTree_term_detail` varchar(255) DEFAULT NULL,
  `indication_OncoTree_IDs_detail` varchar(255) DEFAULT NULL,
  `indication_OncoTree_main_term` varchar(255) DEFAULT NULL,
  `indication_OncoTree_main_ID` varchar(255) DEFAULT NULL,
  INDEX (`Indication_ID`),
  PRIMARY KEY (`id`)
);

CREATE TABLE `Drug_indication_type` (
  `id` int(11) AUTO_INCREMENT,
  `Unique_drug_name` varchar(255) NOT NULL,
  `drug_type` varchar(255) NOT NULL,
  `indication_type` varchar(255) NOT NULL,
  INDEX (`Unique_drug_name`),
  PRIMARY KEY (`id`)
);

CREATE TABLE `Drug_max_phase` (
  `id` int(11) AUTO_INCREMENT,
  `Unique_drug_name` varchar(255) NOT NULL,
  `Max_phase` varchar(255) DEFAULT NULL,
  `First_approval` varchar(255) DEFAULT NULL,
  INDEX (`Unique_drug_name`),
  PRIMARY KEY (`id`)
);


CREATE TABLE `Drug_target_information` (
  `id` int(11) AUTO_INCREMENT,
  `Unique_drug_name` varchar(255) NOT NULL,
  `Gene_symbol` varchar(255)  DEFAULT NULL,
  `Entrez_id` int(11) DEFAULT NULL,
  `ENSG_ID` varchar(255) DEFAULT NULL,
  `Interaction_types` varchar(255)DEFAULT NULL,
  `Drug_type` varchar(255) NOT NULL,
  `Final_source` varchar(255) DEFAULT NULL,
  `Drug_target_score` int(11) DEFAULT NULL,
  `Drug_target_PACTIVITY_median` double DEFAULT NULL,
  INDEX (`Unique_drug_name`,`Entrez_id`,`ENSG_ID`),
  PRIMARY KEY (`id`)
);

CREATE TABLE `Gene_and_network_data_used_to_count_features` (
  `id` int(11) AUTO_INCREMENT,
  `Unique_drug_name` varchar(255) NOT NULL,
  `drug_entrze` int(11)  DEFAULT NULL,
  `drug_ENSG` varchar(255) DEFAULT NULL,
  `drug_target_score` varchar(255) DEFAULT NULL,
  `end_entrze` int(11) DEFAULT NULL,
  `the_shortest_path` varchar(255) DEFAULT NULL,
  `path_length` int(11) DEFAULT NULL,
  `normal_score_P` double NOT NULL,
  `Mutation_ID` varchar(255)  NOT NULL,
  `cancer_specific_affected_donors` int(11) NOT NULL,
  `original_cancer_ID` varchar(255) NOT NULL,
  `CADD_MEANPHRED` double NOT NULL,
  `cancer_ENSG` varchar(255) DEFAULT NULL,
  `oncotree_ID_detail` varchar(255) NOT NULL,
  `oncotree_ID_main_tissue` varchar(255) NOT NULL,
  `the_final_logic` varchar(255) NOT NULL,
  `Map_to_gene_level` varchar(255) NOT NULL,
  `project` varchar(255) NOT NULL,
  `map_to_gene_level_score` int(11) NOT NULL,
  `data_source` varchar(255) NOT NULL,
  INDEX (`Unique_drug_name`),
  PRIMARY KEY (`id`)
);


map_to_gene_level_score

CREATE TABLE `Gene_based_drug_cancer_pairs_information` (
  `id` int(11) AUTO_INCREMENT,
  `Mutation_ID` varchar(255) NOT NULL,
  `Map_to_gene_level` varchar(255)  NOT NULL,
  `entrezgene` int(11) DEFAULT NULL,
  `ENSG_ID` varchar(255) DEFAULT NULL,
  `project` varchar(255) NOT NULL,
  `cancer_specific_affected_donors` int(11) NOT NULL,
  `gene_role_in_cancer` varchar(255) DEFAULT NULL,
  `Unique_drug_name` varchar(255) NOT NULL,
  `Drug_type` varchar(255) NOT NULL,
  `logic` varchar(255) NOT NULL,
  INDEX (`Unique_drug_name`,`Mutation_ID`,`entrezgene`,`ENSG_ID`),
  PRIMARY KEY (`id`)
);

CREATE TABLE `Network_based_drug_cancer_pairs_information_logic_conflict` (
  `id` int(11) AUTO_INCREMENT,
  `the_shortest_path` varchar(255) NOT NULL,
  `path_logic` varchar(255) NOT NULL,
  `path_length` int(11) NOT NULL,
  `drug_name_network` varchar(255) NOT NULL,
  `start_id` varchar(3072) NOT NULL,
  `start_entrez` varchar(3072) NOT NULL,
  `random_overlap_fact_end_id` varchar(255) NOT NULL,
  `normal_score_P` varchar(255) NOT NULL,
  `end_entrze` varchar(255) NOT NULL,
  `Mutation_ID` varchar(255) NOT NULL,
  `Cancer_ENSG_ID` varchar(255) DEFAULT NULL,
  `Map_to_gene_level` varchar(255) NOT NULL,
  `project` varchar(255) NOT NULL,
  `cancer_specific_affected_donors` varchar(255) NOT NULL,
  `gene_role_in_cancer` varchar(255) DEFAULT NULL,
  `Unique_drug_name` varchar(255) NOT NULL,
  `Entrez_id_drug_target` int(11) DEFAULT NULL,
  `ENSG_ID_target` varchar(255) DEFAULT NULL,
  `Drug_type` varchar(255) NOT NULL,
  `drug_target_score` int(11) DEFAULT NULL,
  `drug_target_network_id` int(11) NOT NULL, 
  `the_final_logic` varchar(255) NOT NULL,
  INDEX (`Unique_drug_name`,`Mutation_ID`,`random_overlap_fact_end_id`,`end_entrze`,`Cancer_ENSG_ID`,`project`,
  `Entrez_id_drug_target`,`ENSG_ID_target`),
  PRIMARY KEY (`id`)
);

CREATE TABLE `Network_based_drug_cancer_pairs_information_logic_no` (
  `id` int(11) AUTO_INCREMENT,
  `the_shortest_path` varchar(255) NOT NULL,
  `path_logic` varchar(255) NOT NULL,
  `path_length` int(11) NOT NULL,
  `drug_name_network` varchar(255) NOT NULL,
  `start_id` varchar(3072) NOT NULL,
  `start_entrez` varchar(3072) NOT NULL,
  `random_overlap_fact_end_id` varchar(255) NOT NULL,
  `normal_score_P` varchar(255) NOT NULL,
  `end_entrze` varchar(255) NOT NULL,
  `Mutation_ID` varchar(255) NOT NULL,
  `Cancer_ENSG_ID` varchar(255) DEFAULT NULL,
  `Map_to_gene_level` varchar(255) NOT NULL,
  `project` varchar(255) NOT NULL,
  `cancer_specific_affected_donors` varchar(255) NOT NULL,
  `gene_role_in_cancer` varchar(255) DEFAULT NULL,
  `Unique_drug_name` varchar(255) NOT NULL,
  `Entrez_id_drug_target` int(11) DEFAULT NULL,
  `ENSG_ID_target` varchar(255) DEFAULT NULL,
  `Drug_type` varchar(255) NOT NULL,
  `drug_target_score` int(11) DEFAULT NULL,
  `drug_target_network_id` int(11) NOT NULL, 
  `the_final_logic` varchar(255) NOT NULL,
  INDEX (`Unique_drug_name`,`Mutation_ID`,`random_overlap_fact_end_id`,`end_entrze`,`Cancer_ENSG_ID`,`project`,
  `Entrez_id_drug_target`,`ENSG_ID_target`),
  PRIMARY KEY (`id`)
);

CREATE TABLE `Network_based_drug_cancer_pairs_information_logic_true` (
  `id` int(11) AUTO_INCREMENT,
  `the_shortest_path` varchar(255) NOT NULL,
  `path_logic` varchar(255) NOT NULL,
  `path_length` int(11) NOT NULL,
  `drug_name_network` varchar(255) NOT NULL,
  `start_id` varchar(3072) NOT NULL,
  `start_entrez` varchar(3072) NOT NULL,
  `random_overlap_fact_end_id` varchar(255) NOT NULL,
  `normal_score_P` varchar(255) NOT NULL,
  `end_entrze` varchar(255) NOT NULL,
  `Mutation_ID` varchar(255) NOT NULL,
  `Cancer_ENSG_ID` varchar(255) DEFAULT NULL,
  `Map_to_gene_level` varchar(255) NOT NULL,
  `project` varchar(255) NOT NULL,
  `cancer_specific_affected_donors` varchar(255) NOT NULL,
  `gene_role_in_cancer` varchar(255) DEFAULT NULL,
  `Unique_drug_name` varchar(255) NOT NULL,
  `Entrez_id_drug_target` int(11) DEFAULT NULL,
  `ENSG_ID_target` varchar(255) DEFAULT NULL,
  `Drug_type` varchar(255) NOT NULL,
  `drug_target_score` int(11) DEFAULT NULL,
  `drug_target_network_id` int(11) NOT NULL, 
  `the_final_logic` varchar(255) NOT NULL,
  INDEX (`Unique_drug_name`,`Mutation_ID`,`random_overlap_fact_end_id`,`end_entrze`,`Cancer_ENSG_ID`,`project`,
  `Entrez_id_drug_target`,`ENSG_ID_target`),
  PRIMARY KEY (`id`)
);


CREATE TABLE `Pathogenicity_mutation_id_cadd_score` (
  `id` int(11) AUTO_INCREMENT,
  `Mutation_ID` varchar(255) NOT NULL,
  `CADD_PHRED` double NOT NULL,
  INDEX (`Mutation_ID`),
  PRIMARY KEY (`id`)
);

CREATE TABLE `Pathogenicity_mutation_position` (
  `id` int(11) AUTO_INCREMENT,
  `Mutation_ID` varchar(255) NOT NULL,
  `Chr`varchar(255) NOT NULL,
  `Pos` int(11) NOT NULL,
  `ref` varchar(255) NOT NULL,
  `alt` varchar(255) NOT NULL,
  INDEX (`Mutation_ID`),
  PRIMARY KEY (`id`)
);

CREATE TABLE `Pathogenicity_snv_indel_map_to_gene_project` (
  `id` int(11) AUTO_INCREMENT,
  `Mutation_ID` varchar(255) NOT NULL,
  `ENSG_ID`varchar(255) NOT NULL,
  `Map_to_gene_level` varchar(255) NOT NULL,
  `entrezgene` int(11) DEFAULT NULL,
  `project` varchar(255) NOT NULL,
  `cancer_specific_affected_donors` int(11) NOT NULL,
  INDEX (`Mutation_ID`),
  PRIMARY KEY (`id`)
);

CREATE TABLE `Project_oncotree` (
  `id` int(11) AUTO_INCREMENT,
  `project` varchar(255) NOT NULL,
  `cancer_ID`varchar(255) NOT NULL,
  `project_full_name` varchar(255) NOT NULL,
  `project_full_name_from_project` varchar(255) NOT NULL,
  `oncotree_term_detail` varchar(255) NOT NULL,
  `oncotree_ID_detail` varchar(255) NOT NULL,
  `oncotree_term_main_tissue` varchar(255) NOT NULL,
  `oncotree_ID_main_tissue` varchar(255) NOT NULL,
  INDEX (`cancer_ID`,`project`),
  PRIMARY KEY (`id`)
);

CREATE TABLE `Pathogenicity_snv_CNV` (
  `id` int(11) AUTO_INCREMENT,
  `sv_id` varchar(255) NOT NULL,
  `chr` varchar(255) NOT NULL,
  `start_pos` int(11) NOT NULL,
  `end_pos` int(11) NOT NULL,
  `project` varchar(255) NOT NULL,
  `occurance` int(11) NOT NULL,
  `CADD_score` double NOT NULL,
  INDEX (`project`,`sv_id`),
  PRIMARY KEY (`id`)
);

CREATE TABLE `Pathogenicity_snv_Deletion` (
  `id` int(11) AUTO_INCREMENT,
  `sv_id` varchar(255) NOT NULL,
  `chr` varchar(255) NOT NULL,
  `start_pos` int(11) NOT NULL,
  `end_pos` int(11) NOT NULL,
  `project` varchar(255) NOT NULL,
  `occurance` int(11) NOT NULL,
  `CADD_score` double NOT NULL,
  INDEX (`project`,`sv_id`),
  PRIMARY KEY (`id`)
);

CREATE TABLE `Pathogenicity_snv_Duplication` (
  `id` int(11) AUTO_INCREMENT,
  `sv_id` varchar(255) NOT NULL,
  `chr` varchar(255) NOT NULL,
  `start_pos` int(11) NOT NULL,
  `end_pos` int(11) NOT NULL,
  `project` varchar(255) NOT NULL,
  `occurance` int(11) NOT NULL,
  `CADD_score` double NOT NULL,
  INDEX (`project`,`sv_id`),
  PRIMARY KEY (`id`)
);

CREATE TABLE `Pathogenicity_snv_Translocation` (
  `id` int(11) AUTO_INCREMENT,
  `sv_id` varchar(255) NOT NULL,
  `chr1` varchar(255) NOT NULL,
  `start_pos1` int(11) NOT NULL,
  `end_pos1` int(11) NOT NULL,
  `chr2` varchar(255) NOT NULL,
  `start_pos2` int(11) NOT NULL,
  `end_pos2` int(11) NOT NULL,
  `project` varchar(255) NOT NULL,
  `occurance` int(11) NOT NULL,
  `CADD_score` double NOT NULL,
  INDEX (`project`,`sv_id`),
  PRIMARY KEY (`id`)
);

CREATE TABLE `Pathogenicity_snv_Inversion` (
  `id` int(11) AUTO_INCREMENT,
  `sv_id` varchar(255) NOT NULL,
  `chr1` varchar(255) NOT NULL,
  `start_pos1` int(11) NOT NULL,
  `end_pos1` int(11) NOT NULL,
  `chr2` varchar(255) NOT NULL,
  `start_pos2` int(11) NOT NULL,
  `end_pos2` int(11) NOT NULL,
  `project` varchar(255) NOT NULL,
  `occurance` int(11) NOT NULL,
  `CADD_score` double NOT NULL,
  INDEX (`project`,`sv_id`),
  PRIMARY KEY (`id`)
);