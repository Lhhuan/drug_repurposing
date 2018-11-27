OMIM FTP Site Readme
====================

Updated: March 23, 2015


OMIM genemap file:
------------------

Each entry is a list of fields, separated by the '|' character. 

The fields are, in order :

1  - Numbering system, in the format  Chromosome.Map_Entry_Number
2  - Month entered
3  - Day     "
4  - Year    "
5  - Cytogenetic location
6  - Gene Symbol(s)
7  - Gene Status (see below for codes)
8  - Title
9  - Title, cont.
10 - MIM Number
11 - Method (see below for codes)
12 - Comments
13 - Comments, cont.
14 - Disorders (each disorder is followed by its MIM number, if
	different from that of the locus, and phenotype mapping method (see
	below).  Allelic disorders are separated by a semi-colon.
15 - Disorders, cont.
16 - Disorders, cont.
17 - Mouse correlate
18 - Reference


OMIM genemap2.txt file:
-----------------------

Each entry is a list of fields, separated by the '|' character. 

The fields are, in order :

1  - Numbering system, in the format  Chromosome.Map_Entry_Number
2  - Month entered
3  - Day     "
4  - Year    "
5  - Cytogenetic location
6  - Gene Symbol(s)
7  - Gene Status (see below for codes)
8  - Title
9 - MIM Number
10 - Method (see below for codes)
11 - Comments
12 - Disorders (each disorder is followed by its MIM number, if
	different from that of the locus, and phenotype mapping method (see
	below).  Allelic disorders are separated by a semi-colon.
13 - Mouse correlate
14 - Reference


OMIM morbidmap file:
--------------------

Each entry is a list of fields, separated by the '|' character. 

The fields are, in order :

1  - Disorder, <disorder MIM no.> (<phene mapping key>)
2  - Gene/locus symbols
3  - Gene/locus MIM no.
4  - cytogenetic location


Phenotype mapping method - appears in parentheses after a disorder:
--------------------------------------------------------------------

1 - the disorder is placed on the map based on its association with
a gene, but the underlying defect is not known.
2 - the disorder has been placed on the map by linkage; no mutation has
been found.
3 - the molecular basis for the disorder is known; a mutation has been
found in the gene.
4 - a contiguous gene deletion or duplication syndrome, multiple genes
are deleted or duplicated causing the phenotype.


Status codes:
-------------

The certainty with which assignment of loci to chromosomes or the linkage 
between two loci has been established has been graded into the following 
classes:
C = confirmed - observed in at least two laboratories or in several families.
P = provisional - based on evidence from one laboratory or one family.
I = inconsistent - results of different laboratories disagree.
L = limbo - evidence not as strong as that provisional, but included for 
	heuristic reasons. (Same as `tentative'.)


Method codes :
--------------

The methods for mapping genes are symbolized as follows:

A = in situ DNA-RNA or DNA-DNA annealing (`hybridization'); e.g., ribosomal RNA
genes to acrocentric chromosomes;
kappa light chain genes to chromosome 2.

AAS = deductions from the amino acid sequence of proteins; e.g., linkage of 
delta and beta hemoglobin loci from study of hemoglobin Lepore.
(Includes deductions of hybrid protein  
structure by monoclonal antibodies; e.g., close linkage of MN and SS from 
study of Lepore-like MNSs blood group antigen.)
Also includes examples of hybrid genes as in one form of hypertrophic
cardiomyopathy and in apolipoprotein (Detroit).

C = chromosome mediated gene transfer (CMGT); e.g., cotransfer of galactokinase
and thymidine kinase.
(In conjunction with this approach fluorescence-activated flow sorting 
can be used for transfer of specific chromosomes.)

Ch = chromosomal change associated with particular phenotype and not proved to 
represent linkage (Fc), deletion (D), or virus effect (V);  e.g., loss of 
13q14 band in some cases of retinoblastoma.
(`Fragile sites,' observed in cultured cells with or without
folate-deficient medium or BrdU treatment, fall into this class of method; 
e.g., fragile site at Xq27.3 in one form of X-linked mental retardation.
Fragile sites have been used as markers in family linkage studies; e.g., 
FS16q22 and haptoglobin.)

D = deletion or dosage mapping (concurrence of chromosomal deletion and 
phenotypic evidence of hemizygosity), trisomy mapping (presence of three 
alleles in the case of a highly
polymorphic locus), or gene dosage effects (correlation of trisomic state of 
part or all of a chromosome with 50% more gene product).
Includes "loss of heterozygosity" (loss of alleles) in malignancies.
Examples:  glutathione reductase to chromosome 8.
Includes DNA dosage; e.g., fibrinogen loci to 4q2.
Dosage mapping also includes coamplification in tumor cells.

EM = exclusion mapping, i.e., narrowing the possible location of loci by 
exclusion of parts of the map by deletion mapping, extended to include 
negative lod scores from families with marker chromosomes and negative lod 
scores with other assigned loci; e.g., support for assignment of MNSs to 4q.

F = linkage study in families; e.g., linkage of ABO blood group and
nail-patella syndrome.
(When a chromosomal heteromorphism or rearrangement is one trait, Fc
is used; e.g., Duffy blood group locus on chromosome 1.
When 1 or both of the linked loci are identified by a DNA polymorphism,
Fd is used; e.g., Huntington disease on chromosome 4.  F = L in
the HGM workshops.)

H = based on presumed homology; e.g., proposed assignment of TF to 3q.
Includes Ohno's law of evolutionary conservatism of X chromosome in mammals.
Mainly heuristic or confirmatory.

HS = DNA/cDNA molecular hybridization in solution (`Cot analysis'); e.g., 
assignment of Hb beta to chromosome 11 in derivative hybrid cells.

L = lyonization; e.g., OTC to X chromosome.  (L = family linkage study in the 
HGM workshops.)

LD = linkage disequilibrium; e.g., beta and delta globin genes (HBB, HBD).

M = Microcell mediated gene transfer (MMGT); e.g., a collagen gene (COL1A1) to 
chromosome l7.

OT = ovarian teratoma (centromere mapping); e.g., PGM3 and centromere of 
chromosome 6.

Pcm = PCR of microdissected chromosome segments (see REl).

Psh = PCR of somatic cell hybrid DNA.

R = irradiation of cells followed by `rescue' through fusion with 
nonirradiated (nonhuman) cells (Goss-Harris method of radiation-induced gene 
segregation); e.g., order of genes on  Xq.
(Also called cotransference. The complement of cotransference = recombination.)

RE = Restriction endonuclease techniques; e.g., fine structure map of the 
beta-globin cluster (HBBC) on 11p; physical linkage of 3 fibrinogen genes 
(on 4q) and APOA1 and APOC3 (on 11p).

REa = combined with somatic cell hybridization; e.g., NAG (HBBC) to 11p.

REb = combined with chromosome sorting; e.g., insulin to 11p.
Includes Lebo's adaptation (dual laser chromosome sorting and spot blot DNA
analysis); e.g., MGP to 11q.  (For this method, using flow sorted
chromosomes, W is the symbol adopted by the HGM workshops.)

REc = hybridization of cDNA to genomic fragment (by YAC, PFGE,
microdissection, etc.), e.g., A11 on Xq.

REf = isolation of gene from genomic DNA; includes 'exon trapping'

REl = isolation of gene from chromosome-specific genomic 
library (see Pcm).

REn = neighbor analysis in restriction fragments, e.g., in PFGE.

S = `segregation' (cosegregation) of human cellular traits and human 
chromosomes (or segments of chromosomes) in particular clones from interspecies
somatic cell hybrids; e.g., thymidine kinase to chromosome 17.
When with restriction enzyme, REa; with hybridization in solution, HS.

T = TACT = telomere-associated chromosome fragmentation; e.g., 
interferon-inducible protein 6-16.

V = induction of microscopically evident chromosomal change by a virus; e.g., 
adenovirus 12 changes on chromosomes 1 and 17.

X/A = X-autosome translocation in female with X-linked recessive disorder; 
e.g., assignment of Duchenne muscular dystrophy to Xp21.



OMIM mim2gene.txt file:
-----------------------

Each entry is a list of fields, separated by the tab character. 

The fields are, in order :

1  - MIM number 
2  - MIM entry type (see FAQ 1.3 at http://omim.org/help/faq)
3  - Entrez gene ID (NCBI)
4  - Approved gene symbol (HGNC)
5  - Ensembl gene ID
