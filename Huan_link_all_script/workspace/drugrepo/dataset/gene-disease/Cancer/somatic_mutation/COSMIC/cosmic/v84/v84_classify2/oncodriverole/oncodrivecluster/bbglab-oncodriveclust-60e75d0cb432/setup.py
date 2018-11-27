"""
OncodriveCLUST
==============

OncodriveCLUST is a method aimed to identify genes whose mutations are biased towards a large spatial clustering. This method is designed to exploit the feature that mutations in cancer genes, especially oncogenes, often cluster in particular positions of the protein. We consider this as a sign that mutations in these regions change the function of these proteins in a manner that provides an adaptive advantage to cancer cells and consequently are positively selected during clonal evolution of tumours, and this property can thus be used to nominate novel candidate driver genes.

The method does not assume that the baseline mutation probability is homogeneous across all gene positions but it creates a background model using silent mutations. Coding silent mutations are supposed to be under no positive selection and may reflect the baseline clustering of somatic mutations. Given recent evidences of non-random mutation processes along the genome, the assumption of homogenous mutation probabilities is likely an oversimplication introducing bias in the detection of meaningful events.
"""

import distribute_setup
distribute_setup.use_setuptools()

from setuptools import setup, find_packages

from oncodriveclust import VERSION, AUTHORS, AUTHORS_EMAIL

setup(
	name = "oncodriveclust",
	version = VERSION,
	packages = ["oncodriveclust"],
	scripts = [],

	install_requires = [
		#"numpy==1.6.1",
		#"scipy==0.9.0",
		#"pandas==0.10.1",
		#"statsmodels==0.4",
	],

	include_package_data = True,

	entry_points = {
		'console_scripts': [
			'oncodriveclust = oncodriveclust.command:main'
		]
	},

	# metadata for upload to PyPI
	author = AUTHORS,
	author_email = AUTHORS_EMAIL,
	description = "OncodriveCLUST",
	license = "AGPL 3.0",
	keywords = "",
	url = "https://bitbucket.org/bbglab/oncodriveclust",
	long_description = __doc__,

	classifiers = [
		"Development Status :: 4 - Beta",
		"Intended Audience :: Bioinformatics",
		"License :: OSI Approved :: GNU Affero General Public License (AGPL)",
		"Environment :: Console",
		"Intended Audience :: Science/Research",
		"Natural Language :: English",
		"Operating System :: OS Independent",
		"Programming Language :: Python",
		"Programming Language :: Python :: 2.7",
		"Topic :: Scientific/Engineering",
		"Topic :: Scientific/Engineering :: Bio-Informatics"
	]
)
