library(Matrix)
transitionMat<-function(a,b,c){
    
    #sequence similairty matrix normalized between 0 and 1 
    #a<-as.matrix(read.csv("Norm_SW.csv",header=TRUE,row.names=1))
    #b<-as.matrix(read.csv("db_prot.csv",header=TRUE,row.names=1)) 
    #c<-as.matrix(read.csv("727maccs.sim.csv",header=TRUE,row.names=1))
    seq<-Matrix(a)
    
    #drug target matrix
    drugProt<-(Matrix(b))
    
    #drug similarity matrix normalized between 0 and 1
    sim<-Matrix(c)
    
    new.drug_drug<-as.matrix(t(drugProt)%*%drugProt)
        
    
    new.prot_prot<-as.matrix(drugProt%*%t(drugProt))
    d<-mat.or.vec(nrow(seq),nrow(seq))
    
    #Normalizing sequence similarity
    #for (i in 1:nrow(seq)){
    #    for (j in 1:nrow(seq)){
            
    #        d[i,j] = seq[i,j]/(sqrt(seq[i,i])%*%sqrt(seq[j,j]))
    #    }
    # }
    
    norm_drug<-mat.or.vec(ncol(drugProt),ncol(drugProt))
    norm_prot<-mat.or.vec(nrow(seq),nrow(seq))
    rD<-rowSums(t(drugProt))
    rP<-rowSums(drugProt)
    #since its is binary just add the row values.
    #prot<-as.matrix(read.csv("E:/ying/norm_prot.csv",header=T,row.names=1))
    
    #calculate drug-drug similarity based on shared proteins
    for (i in 1:ncol(drugProt)){
        for (j in 1:ncol(drugProt)){
            
            norm_drug[i,j]<-(2*(new.drug_drug[i,j])/(rD[i]+rD[j]))
            
        }
    }
    
    for (i in 1:nrow(seq)){
        for (j in 1:nrow(seq)){
           # print("Error here")
            norm_prot[i,j]<-(2*(new.prot_prot[i,j])/(rP[i]+rP[j]))    
        }
    }
   
    
    norm_drug[is.na(norm_drug)]<-0
    norm_prot[is.na(norm_prot)]<-0
    drug.similarity.final<-0.5*(sim)+0.5*(norm_drug)
    prot.similarity.final<-0.5*(seq)+0.5*(norm_prot)
    
    MTT<-mat.or.vec(nrow(seq),nrow(seq))
    MDD<-mat.or.vec(ncol(drugProt),ncol(drugProt))
    MDT<-mat.or.vec(ncol(drugProt),nrow(seq))
    MTD<-mat.or.vec(nrow(seq),ncol(drugProt))
    Sd<-rowSums(drug.similarity.final)
    St<-rowSums(prot.similarity.final)
    ADT<-colSums(drugProt)
    ATD<-rowSums(drugProt)
    A<-t(drugProt)
    
    
    
    for (i in 1:nrow(seq)){
        for (j in 1:nrow(seq)){
            if (ATD[i]==0){
                
                MTT[i,j]<-prot.similarity.final[i,j]/St[i]
            }
            else{
                MTT[i,j]<-(0.8*(prot.similarity.final[i,j])/St[i])
            }
        }
    }
    
    
    for (i in 1:ncol(drugPort) & j in 1:ncol(drugProt)){
        if (ADT[i]==0){
            MDD[i,j]<-drug.similarity.final[i,j]/Sd[i]
        }
        else{
            MDD[i,j]<-(0.8*(drug.similarity.final[i,j])/Sd[i])
        }
    }
        
    
    for (i in 1:ncol(drugProt) & ){
        for (j in 1:ncol(drugProt)){
            if (ADT[i]==0){
                MDD[i,j]<-drug.similarity.final[i,j]/Sd[i]
            }
            else{
                MDD[i,j]<-(0.8*(drug.similarity.final[i,j])/Sd[i])
            }
        }
    }
    
    
    
    for (i in 1:ncol(drugProt)){
        for (j in 1:nrow(seq)){
            if (ADT[i]!=0){
                MDT[i,j]<- (0.2*A[i,j])/ADT[i]
            }
            else{
                MDT[i,j]<-0
            }
        }
    }
    for (i in 1:nrow(seq)){
        for (j in 1:ncol(drugProt)){
            if (ATD[i]!=0){
                MTD[i,j]<- (0.2*A[j,i])/ATD[i]
            }
            else{
                MTD[i,j]<-0
            }
        }
    }
    
    M1<-cbind(MTT,MTD)
    M2<-cbind(MDD,MDT)
    M<-rbind(M1,M2)
    return(M)
 #return (list("MTT"=MTT,"MDD"=MDD,"MDT"=MDT,"MTD"=MTD))
}    

rwr<-function(mat,dt){
    require(Matrix)
    M1<-Matrix(mat)
    M<-Matrix(dt)
    M2<-0.99*t(M)
    d<-Matrix(0.01*diag(3519))
    #po<-mat.or.vec(3519,727)
    PO<-rBind(M2,d)
    PT<-rBind(M2,d)
    #count=0
    for (i in 1:3519){
        while (TRUE){
            a<-PT[,i]
            PT[,i]<-0.3*t(M1)%*%PT[,i]+0.7*PO[,i]
            l1<-norm(as.matrix(a))-norm(as.matrix(PT[,i]))
            #count=count+1
            if (l1 < 1e-10){print (l1) ; break;}
             }
        
    }
    #print(count)
   return(as.matrix(PT))
}
