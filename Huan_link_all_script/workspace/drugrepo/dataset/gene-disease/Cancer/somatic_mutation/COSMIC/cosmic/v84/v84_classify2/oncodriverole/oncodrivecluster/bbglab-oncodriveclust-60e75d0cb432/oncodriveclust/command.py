import os
import argparse
import logging

from . import VERSION
from analysis import OncodriveClustAnalysis
from utils import *

_LOG_LEVELS = {
	"debug" : logging.DEBUG,
	"info" : logging.INFO,
	"warn" : logging.WARN,
	"error" : logging.ERROR,
	"critical" : logging.CRITICAL,
	"notset" : logging.NOTSET }

class Command(object):
	def __init__(self, prog=None, desc=""):
		parser = argparse.ArgumentParser(prog=prog, description=desc)

		self._add_arguments(parser)

		parser.add_argument("-L", "--log-level", dest="log_level", metavar="LEVEL", default="info",
							choices=["debug", "info", "warn", "error", "critical", "notset"],
							help="Define the loggging level")

		self.args = parser.parse_args()

		logging.basicConfig(
			format = "%(asctime)s %(name)s %(levelname)-5s : %(message)s",
			datefmt = "%Y-%m-%d %H:%M:%S")

		self.args.log_level = self.args.log_level.lower()

		logging.getLogger("oncodriveclust").setLevel(_LOG_LEVELS[self.args.log_level])

		self.log = logging.getLogger("oncodriveclust")

	def _add_arguments(self, parser):
		pass

	def _check_args(self):
		pass

	def run(self):

		# Check arguments

		self._check_args()

class OncodriveClustCommand(Command):
	def __init__(self):
		Command.__init__(self, prog="oncodriveclust", desc="Run OncodriveCLUST analysis")

		#self.root_path = os.path.normpath(os.path.join(os.path.dirname(os.path.realpath(__file__)), ".."))

		#self.cds_fp = os.path.join(self.root_path, 'data', 'max_len_transcript.tsv')

		#self.cancer_census_fp = os.path.join(self.root_path, 'data','CGC_phenotype.tsv')

	def _add_arguments(self, parser):
		Command._add_arguments(self, parser)

		parser.add_argument('--version', action='version', version='%(prog)s ' + VERSION)

		parser.add_argument("non_syn_path", metavar="NON-SYN-PATH",
				help="The path to the NON-Synonymous mutations file to be checked")

		parser.add_argument("syn_path", metavar="SYN-PATH",
				help="The path to the Synonymous mutations file to construct the background model")

		parser.add_argument("gene_transcripts_path", metavar="GENE-TRANSCRIPTS",
				help="The path of a file containing transcripts length for genes")

		parser.add_argument("-o", "--out", dest="output_path", metavar="PATH",
							help="Define the output file path")

		parser.add_argument("--cgc", dest="cgc_path", metavar="PATH",
				help="The path of a file containing CGC data")

		parser.add_argument("-m", "--muts", dest="min_gene_mutations", type=int, default=5, metavar="INT",
				help="Minimum number of mutations of a gene to be included in the analysis ('5' by default)")

		parser.add_argument("-c", "--coord", dest="print_coord", action = "store_true",
		        help="Use this argument for printing cluster coordinates in the output file")

		parser.add_argument("-p", "--pos", dest="pos_index", type=int, default=-1, metavar="INT",
							help="AA position column index ('-1' by default)")

	def _check_args(self):
		if not os.path.exists(self.args.syn_path) or not os.path.exists(self.args.non_syn_path):
			self.log.error("Please specify a valid path for both Syn and Nonsyn mutations files by using the corresponding"
					 " arguments. Use --help for further details.")
			exit(-1)

		if not self.args.output_path:
			self.args.output_path = os.path.join(os.getcwd(), "oncodriveclust-results.tsv")

	def create_output_file(self, cds_len, cgc,
						   non_syn_accum_mut_pos, non_syn_cluster_coordinates,
						   syn_gene_cluster_scores, non_syn_gene_cluster_scores,
						   non_syn_cluster_muts, non_syn_gene_cluster_scores_external_z):

		out_path = self.args.output_path

		self.log.debug("> {0}".format(out_path))

		hdr = ['GENE', 'CGC', 'GENE_LEN', 'GENE_NUM_MUTS', 'MUTS_IN_CLUST', 'NUM_CLUSTERS']
		if self.args.print_coord:
			hdr += ['CLUST_COORDS']
		hdr += ['GENE_SCORE', 'ZSCORE', 'PVALUE', 'QVALUE']

		outf = open(out_path, 'w')
		outf.write('\t'.join(hdr))

		output = []
		output_tail = []
		for gene in non_syn_gene_cluster_scores:
			cgc_phen = cgc[gene] if gene in cgc else ''
			gene_len = int(cds_len[gene]) / 3
			gene_muts = sum([non_syn_accum_mut_pos[gene][pos] for pos in non_syn_accum_mut_pos[gene].keys()])
			num_clusters = len(non_syn_cluster_coordinates[gene].keys())

			if num_clusters > 0:
				muts_clusters = sum(non_syn_cluster_muts[gene].values())
				gene_additive_cluster_score = non_syn_gene_cluster_scores[gene]
				zscore = non_syn_gene_cluster_scores_external_z[gene] if gene in non_syn_gene_cluster_scores_external_z else 'NA'
				row = [gene, cgc_phen, gene_len, gene_muts, muts_clusters, num_clusters]
				if self.args.print_coord:
					cluster_coordinates = get_cluster_coordinates_output(gene, non_syn_cluster_coordinates, non_syn_cluster_muts)
					row += [cluster_coordinates]
				row += [gene_additive_cluster_score, zscore]
				output.append(row)
			else:
				row = [gene, cgc_phen, gene_len, gene_muts, 'NA', 'NA', 'NA', 'NA', 'NA', 'NA']
				if self.args.print_coord:
					row += ['NA']
				output_tail.append(row)

		output = sort_matrix(output, -1)
		output = add_fdr(output, -1)
		output += output_tail

		for row in output:
			outf.write('\n' + '\t'.join([str(v) for v in row]))
		outf.close()

		self.log.info("Output file created: {0}".format(os.path.basename(out_path)))

	def load_map_from_resource(self, resource_path, key_index=0, value_index=1):
		from pkg_resources import resource_stream
		map = {}
		f = resource_stream(__name__, resource_path)
		for line in f:
			fields = line.rstrip("\n").split("\t")
			map[fields[key_index]] = fields[value_index]
		f.close()
		return map

	def load_map(self, path):
		map = {}
		with open(path, "r") as f:
			f.readline() #discard header
			for line in f:
				if line.lstrip().startswith("#"):
					continue
				line = line.rstrip("\n")
				if len(line) == 0:
					continue
				fields = line.split("\t")
				if len(fields) != 2:
					self.log.warn("Expected 2 columns (gene, info) but found: {0}".format(line))
					continue
				map[fields[0]] = fields[1]
		return map

	def load_gene_max_len_transcript(self, path):
		cds_len = {}
		with open(path, "r") as f:
			f.readline() #discard header
			for line in f:
				if line.lstrip().startswith("#"):
					continue
				line = line.rstrip("\n")
				if len(line) == 0:
					continue
				fields = line.split("\t")
				if len(fields) != 3:
					self.log.warn("Expected 3 columns (gene, transcript, CDS length) but found: {0}".format(line))
					continue
				gene, trs, length = fields
				if gene in cds_len:
					if length > cds_len[gene]:
						cds_len[gene] = length
				else:
					cds_len[gene] = length
		return cds_len

	def load_gene_acum_positions(self, mut_fp, pos_index):
		'''
		returns a dict with the number (absolute) of mutations
		in each position of each gene: {gene: {pos:accumulated_mutations}}
		'''

		accum_pos = {}
		with open(mut_fp, 'r') as f:
			f.readline() # discard header
			for line in f:
				if line.lstrip().startswith("#"):
					continue

				fields = line.rstrip("\n").split('\t')
				try:
					gene, pos = fields[0], int(fields[pos_index])
				except:
					#the position entry contains a non valid value (i.e. a non integer)
					continue

				if gene not in accum_pos:
					accum_pos[gene] = {pos: 1}
				elif pos not in accum_pos[gene]:
					accum_pos[gene][pos] = 1
				else:
					accum_pos[gene][pos] += 1

		return accum_pos

	def run(self):
		'''
		Note that I need as input two tdm files, in which each entry is a mutation.
		I assume that the gene position is the first field, and I work with HUGO_symbols.
		I assume that the AA_position of the mutation is the last field (this can be stated differently by user, see parser options)
		'''

		Command.run(self)

		analysis = OncodriveClustAnalysis()

		self.log.info("Loading Gene CDS length ...")

		cds_len = self.load_gene_max_len_transcript(self.args.gene_transcripts_path)

		if self.args.cgc_path is not None:
			self.log.info("Loading CGC data ...")
			cgc = self.load_map(self.args.cgc_path)
		else:
			cgc = {}

		#dict = {gene: {pos: num_mutations}}

		self.log.info("Loading non synonymous mutations ...")
		self.log.debug("> {0}".format(self.args.non_syn_path))
		non_syn_accum_mut_pos = self.load_gene_acum_positions(self.args.non_syn_path, self.args.pos_index)
		self.log.debug("  {0} genes".format(len(non_syn_accum_mut_pos)))

		self.log.info("Loading synonymous mutations ...")
		self.log.debug("> {0}".format(self.args.syn_path))
		syn_accum_mut_pos = self.load_gene_acum_positions(self.args.syn_path, self.args.pos_index)
		self.log.debug("  {0} genes".format(len(syn_accum_mut_pos)))
		
		self.log.info("Running analysis ...")

		results = analysis.run(
			non_syn_accum_mut_pos, syn_accum_mut_pos,
			self.args.min_gene_mutations, cds_len)

		self.log.info("Saving results ...")

		self.create_output_file(cds_len, cgc, *results)


def main():
	"""
	Main entry point
	"""
	OncodriveClustCommand().run()

if __name__ == "__main__":
	main()