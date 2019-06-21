import os
import argparse
import re



#!/usr/bin/env python

def pick_misssense(vcf_file,out_dir):
    
    o=open(out_dir+'/missense_varient.txt','w')
    with open(vcf_file) as f:
        for line in f:
            if '#' in line:
                continue
            if 'missense_variant' not in line:
                continue
            o.write(line)
    o.close()
    
    return(out_dir+'/missense_varient.txt')
    
def get_protein_varient(missense_file,protein_varient,subst_dir):
    pro={}
    #pro_re={}
    with open(missense_file) as f:
        for line in f:
            ls1=line.strip().split('\t')
            infos=ls1[-1]
            if 'UNIPARC' in line:
                items=infos.split('UNIPARC=')[1].split(';')[0]
                for item in items.split(','):
                    if item in pro:
                        if ls1[10].replace('/',ls1[9]) in pro[item]:
                            continue
                        else:
                            pro[item]=pro[item]+'\n'+ls1[10].replace('/',ls1[9])
                    else:
                           #pro_re[item+'_re']=pro_re[item+'_re']+'\n'+ls1[10].replace('/',ls1[9])[-1]+ls1[10].replace('/',ls1[9])[1:-1]+ls1[10].replace('/',ls1[9])[0]
                        pro[item]=ls1[10].replace('/',ls1[9])
                        #pro_re[item+'_re']=ls1[10].replace('/',ls1[9])[-1]+ls1[10].replace('/',ls1[9])[1:-1]+ls1[10].replace('/',ls1[9])[0]
            elif 'SWISSPROT' in line:
                items=infos.split('SWISSPROT=')[1].split(';')[0]
                for item in items.split(','):
                    if item in pro:
                        if ls1[10].replace('/',ls1[9]) in pro[item]:
                            continue
                        else:
                            pro[item]=pro[item]+'\n'+ls1[10].replace('/',ls1[9])
                            #pro_re[item+'_re']=pro_re[item+'_re']+'\n'+ls1[10].replace('/',ls1[9])[-1]+ls1[10].replace('/',ls1[9])[1:-1]+ls1[10].replace('/',ls1[9])[0]
                    else:
                        pro[item]=ls1[10].replace('/',ls1[9])
                        #pro_re[item+'_re']=ls1[10].replace('/',ls1[9])[-1]+ls1[10].replace('/',ls1[9])[1:-1]+ls1[10].replace('/',ls1[9])[0]
            elif 'TREMBL=' in line:
                
                items=infos.split('TREMBL=')[1].split(';')[0]
                for item in items.split(','):
                    if item in pro:
                        if ls1[10].replace('/',ls1[9]) in pro[item]:
                            continue
                        else:
                            pro[item]=pro[item]+'\n'+ls1[10].replace('/',ls1[9])
                            #pro_re[item+'_re']=ls1[10].replace('/',ls1[9])[-1]+ls1[10].replace('/',ls1[9])[1:-1]+ls1[10].replace('/',ls1[9])[0]
                    else:
                        pro[item]=ls1[10].replace('/',ls1[9])
                        #pro_re[item+'_re']=ls1[10].replace('/',ls1[9])[-1]+ls1[10].replace('/',ls1[9])[1:-1]+ls1[10].replace('/',ls1[9])[0]
    o1=open(tmp_dir+'/'+protein_varient,'w')
    for key in pro:
       o1.write(key+'\t'+pro[key].replace('\n',';')+'\n')
    o1.close()
          
    f.close()
    
    return(os.path.abspath(tmp_dir+'/'+protein_varient))
def cut_text(text,lenth): 
    textArr = re.findall('.{'+str(lenth)+'}', text) 
    textArr.append(text[(len(textArr)*lenth):]) 
    return textArr    
def query_pro(pro_name,site,pro_fasta,pro_query,subst):
    
    if pro_name in pro_fasta:
        
        try:
            seq=list(pro_fasta[pro_name])
        
            seq1=list(pro_fasta[pro_name])
            
                
            seq1[int(site[1:-1])-1]=site[0]
            seq[int(site[1:-1])-1]=site[-1]
                
            
                
            
            seq1=''.join(seq1)
            seq1=cut_text(seq1,60)
            seq=''.join(seq)
            seq=cut_text(seq,60)
            o=open(tmp_dir+'/'+pro_query,'w')
            o.write('>'+pro_name+'_re'+'\n'+'\n'.join(seq).strip()+'\n')
            o.write('>'+pro_name+'\n'+'\n'.join(seq1).strip()+'\n')
            o.close()
        
            o=open(subst_dir+'/'+pro_name+'.subst','w')
            o.write(site)
            o.close()
        
            o=open(subst_dir+'/'+pro_name+'_re'+'.subst','w')
            o.write(site[-1]+site[1:-1]+site[0])
            o.close()
            return(os.path.abspath(tmp_dir+'/'+pro_query))
        except:
            print('the site out of seq')
            return('no')
    else:
        print('the protein is not in the db')
        return('no')
       
    
    
      

def sift4g(query_pro,subst,db,outdir,sift4g_path):
    if not os.path.exists(outdir):
        os.mkdir(outdir)

    b=os.system('%s -q %s --subst %s -d %s --out %s'%(sift4g_path,query_pro,subst,db,outdir))
    return(b)

def count_Bsift_score(outdir,result_file,temp_dir):

    filenames=os.listdir(outdir)
    #print(filenames)
    for filename in os.listdir(outdir):
        if filename.endswith('SIFTprediction') and '_re' not in filename:
            protein=filename.split('.')[0]
            
            if protein+'_re.SIFTprediction' in filenames:
                #print(protein)

                dict1={}

                with open(outdir+'/'+protein+'_re.SIFTprediction') as f:
                    for line in f:
                        if 'WARNING!' in line:
                            continue
                        ls1=line.strip().split('\t')
                        dict1[ls1[0][-1]+ls1[0][1:-1]+ls1[0][0]]=ls1
                
                
                f.close()   
                print(dict1)

                with open(outdir+'/'+filename) as f:
                    for line in f:
                        if 'WARNING!' in line:
                            continue
                        ls1=line.strip().split('\t')
                        if ls1[0] in dict1:
                            pos=ls1[0][1:-1]
                            mut_allele=ls1[0][-1]
                            wild_allele=ls1[0][0]
                            m_sift_score=ls1[2]
                            w_sift_score=dict1[ls1[0]][2]
                            B_sift=str(float(m_sift_score)-float(w_sift_score))
                            re=[protein,pos,mut_allele,m_sift_score,wild_allele,w_sift_score,B_sift]
                            re='\t'.join(re)
                            os.system('echo "%s" >> %s'%(re,temp_dir+'/'+result_file))
                                                         
                
    
    return(os.path.abspath(tmp_dir+'/'+result_file))    
                    
    
def re_to_missense(re,missense_file):
    print(re,missense_file)
    o=open(tmp_dir+'/'+'missense_match_bscore.txt','w')
    with open(tmp_dir+'/'+missense_file) as f:
        for line1 in f:
            ls1=line1.strip().split('\t')
            acid_sub1=ls1[10].replace('/',ls1[9])  
            with open(tmp_dir+'/'+re) as f1:
                for line2 in f1:
                    ls2=line2.strip().split('\t')
                    acid_sub2=ls2[4]+ls2[1]+ls2[2]
                    
                    if ls2[0] in line1 and acid_sub1==acid_sub2:
                        #print(acid_sub1,acid_sub2)
                        o.write(line1.strip()+'\t'+line2)
            f1.close()
        f.close()
    o.close()
                



if __name__=='__main__':
    parser = argparse.ArgumentParser(description='count B sift score')
    parser.add_argument('--vcf', type=str, 
                    help='the vep varient file')
    # parser.add_argument('--q', type=str
    #                 ,help='the query protein fasta')
    parser.add_argument('--subst', type=str, 
                    help='the subst file dir')
    parser.add_argument('--db', type=str, 
                    help='protein fasta db')
    parser.add_argument('--query_name', type=str, default='query_pro.fa',
                    help='the name of the query pro file would be generated')
    parser.add_argument('--out',type=str,default='./sift_out',
                    help='the output dir of the sift')
    parser.add_argument('--result_file',type=str,default='B-sfit_score.txt',
                    help='the filename of the B-sift score')

    
    sift4g_path='/f/mulinlab/cuihui/software/sift4g/bin/sift4g'


    tmp_dir='B_sift_tmp'
    if not os.path.exists(tmp_dir):
        os.makedirs(tmp_dir)
    args = parser.parse_args()
    subst_dir=args.subst
    pro_db=args.db
    vcf_file=args.vcf
    query_file=args.query_name
    outdir=args.out
    result_file=args.result_file
    if not os.path.exists(subst_dir):
        os.makedirs(subst_dir)
    print('***************************')
    print('Start parsing file:%s'%os.path.abspath(vcf_file))
    missense_file=pick_misssense(vcf_file,tmp_dir)
    print('successful parsing.')
    print('***************************')
    print('Start parsing file:%s'%os.path.abspath(missense_file))
    protein_varient=get_protein_varient(missense_file,'protein_mutinfos.txt',subst_dir)
    print('***************************')
    print(protein_varient)
    print('Start load db')
    pro_fasta={}
    with open(pro_db) as f:
        
        for line in f:
            
            if '>' in line:
                ls1=line.strip().split()[0]
                name=ls1[9:]
                pro_fasta[name]=''
            else:
                pro_fasta[name]+=line.strip()
    f.close()
    o=open(tmp_dir+'/'+result_file,'w')
    title=['pro','pos','mut_allele','m_sift_score','wild_allele','w_sift_score','B_sift']
    o.write('\t'.join(title)+'\n')
    o.close()
    print('Start parsing file:%s'%os.path.abspath(protein_varient))
    with open (protein_varient) as f:
        for line in f:
            ls1=line.strip().split('\t')
            protein_name=ls1[0]
            sites=ls1[1].split(';')
            for site in sites:
                print(protein_name,site)
                pro_query=query_pro(protein_name,site,pro_fasta,query_file,subst_dir)
                print('***************************')
                if pro_query=='no':
                    continue
                print(pro_query)
                print('Start run sift')
                b=sift4g(pro_query,subst_dir,pro_db,outdir,sift4g_path)
                if str(b)!='0':
                    print('There was wrong in run sift')
                else:
                    print('Successful run sift.')
                print('***************************')
                print('Start count B-sift score.')
                result=count_Bsift_score(outdir,result_file,tmp_dir)
                print('the result is be stored in ',result)
                print('Successful count B-sift.')
                os.system('rm ./sift_out/*')
                os.system('rm ./subst_file/*')
                

    
    re_to_missense(result_file,'missense_varient.txt')
    




    
    
    




