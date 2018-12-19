"""
The MIT License

Copyright (c) 2015
The University of Texas MD Anderson Cancer Center
Wanding Zhou, Tenghui Chen, Ken Chen (kchen3@mdanderson.org)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

"""
from __future__ import division
from .transcripts import *
from .utils import *
from .record import *
from .describe import *
from .proteinseqs import *

def tnuc_coding_ins_frameshift(args, tnuc_ins, t, r):

    insseq = tnuc_ins.insseq
    tnuc_pos = tnuc_ins.beg.pos

    beg_codon_index = (tnuc_pos + 2) // 3
    beg_codon_beg = beg_codon_index*3 - 2
    if beg_codon_beg+2 > len(t.seq):
        raise IncompatibleTranscriptError('truncated_refseq_at_boundary_codon_end_%d;transcript_length_%d' % (beg_codon_beg+3, len(t.seq)))

    old_seq = t.seq[beg_codon_beg-1:]
    new_seq = t.seq[beg_codon_beg-1:tnuc_pos]+insseq+t.seq[tnuc_pos:]
    aae = t.extend_taa_seq(beg_codon_index, old_seq, new_seq)
    if aae:
        if aae.taa_alt == '*':
            r.csqn.append('Nonsense')
        else:
            r.csqn.append("Frameshift")
        variant_protein_seq_fs(r, t, aae, args)
        r.taa_range = aae.format(args)
    else:
        r.csqn.append('Synonymous')
        r.taa_range = '(=)'

def tnuc_coding_ins(args, tnuc_ins, t, r, db):

    """ assuming insertion does not affect splicing """

    insseq = tnuc_ins.insseq
    tnuc_pos = tnuc_ins.beg.pos

    if len(insseq) % 3 == 0:
        if tnuc_pos % 3 == 0:
            # in frame
            # insertion is after the 3rd base of a codon
            # check stop codon
            stop_codon_seen = False
            taa_insseq = ''
            for i in range(len(insseq)//3):
                if codon2aa(insseq[i*3:i*3+3]) == '*':
                    tnuc_coding_ins_frameshift(args, tnuc_ins, t, r)
                    stop_codon_seen = True
                    break
                taa_insseq += codon2aa(insseq[i*3:i*3+3])

            if not stop_codon_seen:
                # otherwise, a pure insertion
                c1 = t.cpos2codon((tnuc_pos+2)//3)
                c2 = t.cpos2codon((tnuc_pos+3)//3)
                if not c1 or not c2:
                    raise IncompatibleTranscriptError('codon_nonexistent_at_cDNA_%d' % tnuc_pos)
                r.csqn.append("InFrameInsertion")
                taa_set_ins(r, t, c1.index, taa_insseq, args)
                r.append_info('phase=0')
        else:
            # insertion is after 1st or 2nd base of a codon
            codon_index = (tnuc_pos+2)//3
            codon = t.cpos2codon(codon_index)
            if not codon:
                raise IncompatibleTranscriptError('codon_nonexistent_at_cDNA_%d' % codon_index)

            codon_beg = codon_index*3-2
            codon_end = codon_index*3
            codon_subseq1 = t.seq[codon_beg-1:tnuc_pos]
            codon_subseq2 = t.seq[tnuc_pos:codon_end]
            new_seq = codon_subseq1+insseq+codon_subseq2
            taa_insseq = ''
            for i in range(len(new_seq)//3):
                if codon2aa(new_seq[i*3:i*3+3]) == '*':
                    tnuc_coding_ins_frameshift(args, tnuc_ins, t, r)
                    return
                taa_insseq += codon2aa(new_seq[i*3:i*3+3])

            taa_ref = codon2aa(codon.seq)
            if taa_ref == taa_insseq[0]:
                # SdelinsSH becomes a pure insertion [current_codon]_[codon_after]insH
                r.csqn.append("InFrameInsertion")
                taa_ref_after = codon2aa(t.seq[codon.index*3:codon.index*3+3])
                taa_set_ins(r, t, codon.index, taa_insseq[1:], args)
            elif taa_ref == taa_insseq[-1]:
                # SdelinsHS becomes a pure insertion [codon_before]_[current_codon]insH
                r.csqn.append("InFrameInsertion")
                taa_ref_before = codon2aa(t.seq[codon.index*3-6:codon.index*3-3])
                taa_set_ins(r, t, codon.index-1, taa_insseq[:-1], args)
            else:
                r.csqn.append("MultiAAMissense")
                r.taa_range = '%s%ddelins%s' % (aaf(taa_ref, args), codon.index, aaf(taa_insseq, args))
            # 0, 1,2 indicating insertion happen after 3rd, 1st or 2nd base of the codon
            r.append_info('phase=%d' % (tnuc_pos - codon_beg + 1,))

    else:                       # frameshift
        tnuc_coding_ins_frameshift(args, tnuc_ins, t, r)

def annotate_insertion_cdna(args, q, tpts, db):

    records = []
    for t in tpts:

        try:
            if q.tpt and t.name != q.tpt:
                raise IncompatibleTranscriptError("Transcript_name_unmatched")
            t.ensure_seq()

            r = Record(is_var=True)
            r.chrm = t.chrm
            r.tname = t.format()
            r.gene = t.gene_name
            r.strand = t.strand
            if t.strand == '+':
                gnuc_beg = t.tnuc2gnuc(q.pos)
                gnuc_end = gnuc_beg+1
                tnuc_beg = q.pos
                c, tnuc_end = t.gpos2codon(gnuc_end)
                gnuc_insseq = q.insseq
            else:
                gnuc_end = t.tnuc2gnuc(q.pos)
                gnuc_beg = gnuc_end-1
                tnuc_beg = q.pos
                c, tnuc_end = t.gpos2codon(gnuc_beg)
                gnuc_insseq = reverse_complement(q.insseq)

            r.pos = gnuc_beg
            gnuc_ins = gnuc_set_ins(t.chrm, gnuc_beg, gnuc_insseq, r)
            tnuc_ins = tnuc_set_ins(gnuc_ins, t, r, beg=tnuc_beg, end=tnuc_end, insseq=q.insseq)
            r.reg = describe_genic(args, t.chrm, gnuc_beg, gnuc_end, t, db)
            if not r.set_splice("affected", "Insertion"):
                if r.reg.entirely_in_cds() and t.transcript_type=='protein_coding':
                    tnuc_coding_ins(args, tnuc_ins, t, r, db)
                else:
                    r.set_csqn_byreg("Insertion")
        except IncompatibleTranscriptError as e:
            continue
        except SequenceRetrievalError as e:
            continue

        records.append(r)
    # format_one(r, rs, q.op, args)
    # format_all(rs, q.op, args)
    format_records(records, q.op, args)

    # if not found:
    #     wrap_exception(Exception('no_valid_transcript_found_(from_%s_candidates)' % len(tpts)), q.op, args)

    return records


def codon_mutation_ins(args, q, t, db):

    if q.tpt and t.name != q.tpt:
        raise IncompatibleTranscriptError("Transcript name unmatched")
    t.ensure_seq()

    r = Record(is_var=True)
    taa_set_ins(r, t, q.beg, q.insseq, args)
    r.reg = RegCDSAnno(t)
    r.reg.from_cindex(q.beg)
    if q.beg*3 > t.cdslen() or q.end*3 > t.cdslen():
        raise IncompatibleTranscriptError('codon nonexistent')

    tnuc_beg = q.beg*3-2
    tnuc_end = q.end*3
    if hasattr(q, 'beg_aa') and q.beg_aa and q.beg_aa != t.taa2aa(q.beg):
        raise IncompatibleTranscriptError('Unmatched reference amino acid')
    if hasattr(q, 'end_aa') and q.end_aa and q.end_aa != t.taa2aa(q.end):
        raise IncompatibleTranscriptError('Unmatched reference amino acid')
    gnuc_beg, gnuc_end = t.tnuc_range2gnuc_range(tnuc_beg, tnuc_end)
    _tnuc_insseq = aaseq2nuc1(q.insseq)
    _gnuc_insseq = reverse_complement(_tnuc_insseq) if t.strand == '-' else _tnuc_insseq

    gnuc_ins = gnuc_set_ins(t.chrm, gnuc_beg+2, _gnuc_insseq, r)
    tnuc_ins = tnuc_set_ins(gnuc_ins, t, r)

    # r.gnuc_range = '%dins%s' % (gnuc_beg-1, tnuc_insseq)
    # c, p1 = t.gpos2codon(gnuc_beg-1)
    # r.tnuc_range = '(%s_%sins%d)' % (p1, tnuc_beg, len(q.insseq)*3)
    # tnuc_insseq = aaseq2nuc(q.insseq)
    # r.append_info('insertion_cDNA='+tnuc_insseq)
    # r.append_info('insertion_gDNA=%s' % (tnuc_insseq if t.strand == '+' else reverse_complement(tnuc_insseq)))
    r.csqn.append('InFrameInsertion')
    r.append_info('%d_CandidatesOmitted' % (aaseq_redundancy(q.insseq)))

    return r

def annotate_insertion_protein(args, q, tpts, db):

    records = []
    for t in tpts:
        try:
            r = codon_mutation_ins(args, q, t, db)
            r.chrm = t.chrm
            r.tname = t.format()
            r.gene = t.gene_name
            r.strand = t.strand
        except IncompatibleTranscriptError:
            continue
        except SequenceRetrievalError:
            continue
        records.append(r)

    format_records(records, q.op, args)
    # format_one(r, rs, q.op, args)
    # format_all(rs, q.op, args)

    # if not found:
    #     r = Record(is_var=True)
    #     r.taa_range = '%s%s_%s%sins%s' % (aaf(q.beg_aa, args), str(q.beg), aaf(q.end_aa, args), str(q.end), aaf(q.insseq, args))
    #     r.append_info('no_valid_transcript_found_(from_%s_candidates)' % len(tpts))
    #     r.format(q.op)

    return records

def annotate_insertion_gdna(args, q, db):

    """ annotate_duplication_gdna is also delegated by this """
    records = []
    for reg in describe(args, q, db):

        r = Record(is_var=True)
        r.reg = reg
        r.chrm = q.tok
        r.pos = q.pos

        gnuc_ins = gnuc_set_ins(q.tok, q.pos, q.insseq, r)
        # TODO check q.insseq exists

        if hasattr(reg, 't'):

            t = reg.t

            r.tname = t.format()
            r.gene = t.gene_name
            r.strand = t.strand

            tnuc_ins = tnuc_set_ins(gnuc_ins, t, r)

            # TODO: check if insertion hits start codon

            # infer protein level mutation if in cds
            # this skips insertion that occur to sites next to donor or acceptor splicing site.

            if not r.set_splice("affected", "Insertion"):
                if reg.cds and t.transcript_type=='protein_coding':
                    try:
                        tnuc_coding_ins(args, tnuc_ins, t, r, db)
                    except IncompatibleTranscriptError:
                        r.append_info("Exception=IncompatibleTranscript")
                else:
                    r.set_csqn_byreg("Insertion")

                # c1 = t.cpos2codon((tnuc_ins.beg.pos+2)//3)
                # p1 = tnuc_ins.beg
                # if len(tnuc_ins.insseq) % 3 == 0:
                #     ins_gene_coding_inframe(t, r, c1, p1, tnuc_ins.insseq)
                # else:
                #     ins_gene_coding_frameshift(t, r, c1, p1, tnuc_ins.insseq)
        else:
            r.set_csqn_byreg("Insertion")

        records.append(r)

    format_records(records, q.op, args)
    return records


def annotate_duplication_cdna(args, q, tpts, db):

    """Annotation cDNA duplication on all transcripts

    Print or return records

    Args:
        args (argparse.Namespace): command line arguments
        q (record.QueryDUP): query of duplication
        tpts (lists of transcript.Transcript): transcripts
        db (annodb.AnnoDB): annotation database

    Returns:
        records (list of record.Record): a list of records
    """

    records = []
    for t in tpts:
        try:

            if q.tpt and t.name != q.tpt:
                raise IncompatibleTranscriptError("Transcript name unmatched")
            t.ensure_seq()

            r = Record(is_var=True)
            r.chrm = t.chrm
            r.tname = t.format()
            r.gene = t.gene_name
            r.strand = t.strand

            if q.beg.pos > t.cdslen() or q.end.pos > t.cdslen():
                raise IncompatibleTranscriptError('codon nonexistent')

            t.check_exon_boundary(q.beg)
            t.check_exon_boundary(q.end)

            _gnuc_beg = t.tnuc2gnuc(q.beg)
            _gnuc_end = t.tnuc2gnuc(q.end)
            gnuc_beg = min(_gnuc_beg, _gnuc_end)
            gnuc_end = max(_gnuc_beg, _gnuc_end)
            gnuc_dupseq = faidx.getseq(t.chrm, gnuc_beg, gnuc_end)
            tnuc_dupseq = gnuc_dupseq if t.strand == '+' else reverse_complement(gnuc_dupseq)
            if q.dupseq and tnuc_dupseq != q.dupseq:
                raise IncompatibleTranscriptError('unmatched reference')

            if t.strand == '+':
                gnuc_ins = gnuc_set_ins(t.chrm, gnuc_end, gnuc_dupseq, r)
            else:
                gnuc_ins = gnuc_set_ins(t.chrm, gnuc_beg-1, gnuc_dupseq, r)

            r.pos = gnuc_ins.beg_r
            tnuc_ins = tnuc_set_ins(gnuc_ins, t, r)
            r.reg = describe_genic(args, t.chrm, gnuc_ins.beg_r, gnuc_ins.end_r, t, db)
            if not r.set_splice("affected", "Insertion"):
                if r.reg.entirely_in_cds() and t.transcript_type=='protein_coding':
                    tnuc_coding_ins(args, tnuc_ins, t, r, db)
                else:
                    r.set_csqn_byreg("Insertion")

        except IncompatibleTranscriptError:
            continue
        except SequenceRetrievalError:
            continue
        r.tnuc_range = '%s_%sdup%s' % (q.beg, q.end, q.dupseq)
        records.append(r)

    format_records(records, q.op, args)
    return records

def taa_ins_id(t, index, taa_insseq, args):

    aa = t.cpos2aa(index)
    aa2 = t.cpos2aa(index+1)
    n = len(taa_insseq)
    if index-n+1 > 0:
        flank5_seq = t.taa_range2aa_seq(index-n+1, index)
    else:
        flank5_seq = None

    # if index+n < len(self.seq)//3:
    #     flank3_seq = self.taa_range2aa_seq(index+1, index+n)
    # else:
    #     flank3_seq = None
    if flank5_seq is not None and flank5_seq == taa_insseq:
        if len(flank5_seq) == 1:
            s = '%s%ddup%s' % (aaf(aa, args), index, aaf(flank5_seq, args))
        else:
            s = '%s%d_%s%ddup%s' % (aaf(flank5_seq[0], args), index-n+1, aaf(flank5_seq[-1], args), index, aaf(flank5_seq, args))
    else:
        s = '%s%d_%s%dins%s' % (aaf(aa, args), index, aaf(aa2, args), index+1, aaf(taa_insseq, args))

    return s

def taa_set_ins(r, t, index, taa_insseq, args):
    i1r, taa_insseq_r = t.taa_roll_right_ins(index, taa_insseq)
    try:
        r.taa_range = taa_ins_id(t, i1r, taa_insseq_r, args)
        i1l, taa_insseq_l = t.taa_roll_left_ins(index, taa_insseq)
        r.append_info('left_align_protein=p.%s' %
                      taa_ins_id(t, i1l, taa_insseq_l, args))
        r.append_info('unalign_protein=p.%s' %
                      taa_ins_id(t, index, taa_insseq, args))
        variant_protein_seq_ins(r, t, args, i1r, taa_insseq_r)
    except IncompatibleTranscriptError:
        r.append_info("truncated_refseq_at_boundary")
