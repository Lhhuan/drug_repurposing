USE QTLdb;
CREATE TABLE `meta` (
    `id` int(11) NOT NULL,
    `pmid` varchar(255) NOT NULL,
    `tissue` int(5) NOT NULL,
    `popu` int(2) DEFAULT NULL,
    `sample_size` int(10) DEFAULT NULL,
    `asso_type` int(2) DEFAULT NULL,
    `genome` int(2) DEFAULT NULL,
    `confounding` varchar(255) DEFAULT NULL,
    `repli` tinyint(1) DEFAULT NULL,
    `tissue_state` varchar(255) DEFAULT NULL,
    `allele_spec` tinyint(1) DEFAULT NULL,
    `title` text DEFAULT NULL,
    `xqtl` int(2) NOT NULL,
    INDEX (`pmid`,`tissue`,`xqtl`),
    PRIMARY KEY (`id`)
)


USE QTLdb_bak;
CREATE TABLE `meta` (
    `id` int(11) NOT NULL,
    `pmid` varchar(255) NOT NULL,
    `tissue` int(5) NOT NULL,
    `popu` int(2) DEFAULT NULL,
    `sample_size` int(10) DEFAULT NULL,
    `asso_type` int(2) DEFAULT NULL,
    `genome` int(2) DEFAULT NULL,
    `confounding` varchar(255) DEFAULT NULL,
    `repli` tinyint(1) DEFAULT NULL,
    `tissue_state` varchar(255) DEFAULT NULL,
    `allele_spec` tinyint(1) DEFAULT NULL,
    `title` text DEFAULT NULL,
    `xqtl` int(2) NOT NULL,
    INDEX (`pmid`,`tissue`,`xqtl`),
    PRIMARY KEY (`id`)
)



USE QTLdb;
CREATE TABLE `trait` (
    `id` int(11) AUTO_INCREMENT,
    `chr` int(2) NOT NULL,
    `start` int(20) NOT NULL,
    `end` int(20) NOT NULL,
    `trait_name` varchar(255) DEFAULT NULL,
    `symbol` varchar(255) DEFAULT NULL,
    `encodeid` varchar(255) DEFAULT NULL,
    `label` int(2) DEFAULT NULL,
    `xqtl` int(2) NOT NULL,
    INDEX (`chr`,`start`,`end`,`symbol`,`encodeid`,`trait_name`),
    PRIMARY KEY (`id`)
)


##  Select
use QTLdb;
select snpdata.*,snptrait.*,trait.*,qtl.*,meta.* from snpdata
inner join snptrait on snpdata.id = snptrait.snpid
inner join trait on snptrait.traitid = trait.id
inner join qtl on qtl.snptraitid = snptrait.id
inner join meta on meta.id = qtl.metaid
where snpdata.rsid=4728142 ;