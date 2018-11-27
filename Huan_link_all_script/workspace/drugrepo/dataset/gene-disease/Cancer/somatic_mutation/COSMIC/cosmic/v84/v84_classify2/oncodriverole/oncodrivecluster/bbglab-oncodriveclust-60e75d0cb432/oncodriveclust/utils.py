import math

import scipy

from operator import itemgetter

from statsmodels.sandbox.stats.multicomp import fdrcorrection0

###################################################
##
##   Statistics
###################################################

def factorial(n):
	if n < 2: return 1
	return reduce(lambda x, y: x*y, xrange(2, int(n)+1))

def get_binom_prob(s, n, p):
	x = 1.0 - p
	a = n - s
	b = s + 1.0
	c = a + b - 1.0
	prob = 0
	for j in xrange(a, int(c) + 1):
		prob += factorial(c) / (factorial(j)*factorial(c-j)) * x**j * (1 - x)**(c-j)
	return prob

def calculate_mean_and_sd(values_list):
	final_values_list = []
	for value in values_list:
		try:
			final_values_list.append(float(value))
		except:
			continue
	n = len(final_values_list)
	mean = sum(final_values_list)/n
	sd = math.sqrt(sum((x-mean)**2 for x in final_values_list) / n)
	return mean, sd

def get_z(value, mean, sd):
	return (float(value) - mean) / sd

def get_p_from_z(z_l, tail = 'right'):
	if tail == 'right':
		z_l = [z * -1 for z in z_l]
	p_l = scipy.stats.norm.sf(z_l)
	return p_l

def get_fdr_from_p(p_l):
	q_l = fdrcorrection0(p_l)[1]
	return q_l

###################################################3
##
##   Auxiliar
###################################################3
def f2dict(f_p, k_position, v_position):
	'''
	convert a file with a key-value to a dict
	'''

	dict = {}
	f = open(f_p, 'r')
	h_s = f.readline().rstrip().split("\t")
	for l in f:
		try:
			l_s = l.rstrip().split("\t")
			key, value = l_s[k_position], l_s[v_position]
			dict[key] = value
		except:
			continue
	f.close()
	return dict

def get_binomial_minimum_mut_per_position_threshold(gene_len, gene_muts, sig_cutoff,minimum_mut_per_position_threshold):
	'''
	Given a len of gene and a number of gene mutations, I find the minimum number of mutations having a prob of occurring
	in a position <= 1%

	I assume that the probability of having n muts in a single position is like having n succceses in gene_muts trials,
	  where the prob_success is 1/gene_len
	'''

	prob_success = 1/float(gene_len)
	num_trials = int(gene_muts)

	#pbinom = robjects.r['pbinom']
	minimum_mut_per_position_threshold = 2

	for num_success in range(2, gene_muts):
		#binom_p = pbinom(num_success, num_trials, prob_success)[0]
		binom_p = get_binom_prob(num_success, num_trials, prob_success)
		if 1-binom_p <= sig_cutoff:
			minimum_mut_per_position_threshold = num_success
			break
	return minimum_mut_per_position_threshold



def add_fdr(matrix, pos=-1, sense='OVER'):
	'''
	add a column with P value and another with FDR values to
	the output_matrix (already ordered by Z)
	'''

	#pnorm = robjects.r['pnorm']
	#padj = robjects.r['p.adjust']
	if sense == 'OVER':
		z = [float(row[pos]) * -1 for row in matrix]
	else: # UNDER
		z = [float(row[pos]) for row in matrix]

	#rz = robjects.FloatVector(z)
	#rp = pnorm(rz)
	#rf = padj(rp, method = 'fdr')
	p = get_p_from_z(z)
	q = get_fdr_from_p(p)

	#add the calculated p and fdr values to the output matrix
	for i in range(0, len(matrix)):
		matrix[i] += [p[i], q[i]]
	return matrix


def sort_matrix(matrix, position, order = 'DEC'):
	if order == 'DEC':
		matrix.sort(key=itemgetter(position), reverse = True)
	else:
		matrix.sort(key=itemgetter(position), reverse = False)
	return matrix


###################################################3
##
##   Auxiliar
###################################################3

def get_cluster_coordinates_output(gene, non_syn_cluster_coordinates_dict, non_syn_cluster_muts_dict):
	out_l = []
	for cluster_id in non_syn_cluster_coordinates_dict[gene]:
		cluster_coordinates = "[{0}]".format(",".join([str(x) for x in non_syn_cluster_coordinates_dict[gene][cluster_id]]))
		n_muts = str(non_syn_cluster_muts_dict[gene][cluster_id])
		out_l.append(cluster_coordinates + ':' + n_muts)
	return ','.join(out_l)