* Encoding: UTF-8.
DATASET ACTIVATE DataSet1.
RECODE ID ('ID_28'=0) (ELSE=1) INTO ID_included.
EXECUTE.

USE ALL.
FILTER BY ID_included.
EXECUTE.

FREQUENCIES VARIABLES=weight 
  /ORDER=ANALYSIS.

SPSSINC CREATE DUMMIES VARIABLE=sex 
ROOTNAME1=Sex_dummy 
/OPTIONS ORDER=A USEVALUELABELS=YES USEML=YES OMITFIRST=NO.

REGRESSION 
  /MISSING LISTWISE 
  /STATISTICS COEFF OUTS CI(95) BCOV R ANOVA CHANGE COLLIN TOL SELECTION
  /CRITERIA=PIN(.05) POUT(.10) 
  /NOORIGIN 
  /DEPENDENT pain 
  /METHOD=ENTER Sex_dummy_1 age STAI_trait pain_cat mindfulness cortisol_serum weight 
  /SCATTERPLOT=(*ZRESID ,*ZPRED) 
  /RESIDUALS HISTOGRAM(ZRESID) 
  /SAVE PRED COOK RESID.

EXAMINE VARIABLES=RES_1 
  /PLOT BOXPLOT STEMLEAF HISTOGRAM NPPLOT 
  /COMPARE GROUPS 
  /STATISTICS DESCRIPTIVES 
  /CINTERVAL 95 
  /MISSING LISTWISE 
  /NOTOTAL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=weight pain MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: weight=col(source(s), name("weight"))
  DATA: pain=col(source(s), name("pain"))
  GUIDE: axis(dim(1), label("weight"))
  GUIDE: axis(dim(2), label("pain"))
  GUIDE: text.title(label("Simple Scatter of pain by weight"))
  ELEMENT: point(position(weight*pain))
  ELEMENT: line(position(smooth.loess(weight*pain)))
END GPL.

COMPUTE weight_squared=weight * weight. 
EXECUTE. 
REGRESSION 
  /MISSING LISTWISE 
  /STATISTICS COEFF OUTS CI(95) BCOV R ANOVA CHANGE COLLIN TOL SELECTION 
  /CRITERIA=PIN(.05) POUT(.10) 
  /NOORIGIN 
  /DEPENDENT pain 
  /METHOD=ENTER age Sex_dummy_1 STAI_trait pain_cat mindfulness cortisol_serum  
    weight_squared 
  /SCATTERPLOT=(*ZRESID ,*ZPRED) 
  /SAVE PRED COOK RESID.

COMPUTE Unstandardized_residual_squared_with_weight=RES_1*RES_1. 
EXECUTE.
REGRESSION 
  /MISSING LISTWISE 
  /STATISTICS COEFF OUTS CI(95) BCOV R ANOVA CHANGE COLLIN TOL SELECTION 
  /CRITERIA=PIN(.05) POUT(.10) 
  /NOORIGIN 
  /DEPENDENT Unstandardized_residual_squared_with_weight 
  /METHOD=ENTER age Sex_dummy_1 STAI_trait pain_cat mindfulness cortisol_serum weight 
  /SCATTERPLOT=(*ZRESID ,*ZPRED)
  /RESIDUALS HISTOGRAM(ZRESID)  
  /SAVE PRED COOK RESID.

REGRESSION 
  /MISSING LISTWISE 
  /STATISTICS COEFF OUTS CI(95) BCOV R ANOVA CHANGE COLLIN TOL SELECTION
  /CRITERIA=PIN(.05) POUT(.10) 
  /NOORIGIN 
  /DEPENDENT pain 
  /METHOD=ENTER age Sex_dummy_1 STAI_trait pain_cat mindfulness cortisol_serum weight
  /SCATTERPLOT=(*ZRESID ,*ZPRED)
  /RESIDUALS HISTOGRAM(ZRESID)  
  /SAVE PRED COOK RESID.

REGRESSION 
  /MISSING LISTWISE 
  /STATISTICS COEFF OUTS CI(95) BCOV R ANOVA CHANGE COLLIN TOL SELECTION
  /CRITERIA=PIN(.05) POUT(.10) 
  /NOORIGIN 
  /DEPENDENT pain 
  /METHOD=BACKWARD Sex_dummy_1 age STAI_trait pain_cat mindfulness cortisol_serum weight 
  /SCATTERPLOT=(*ZRESID ,*ZPRED) 
  /RESIDUALS HISTOGRAM(ZRESID) 
  /SAVE PRED COOK RESID.

REGRESSION 
  /MISSING LISTWISE 
  /STATISTICS COEFF OUTS CI(95) BCOV R ANOVA CHANGE COLLIN TOL SELECTION
  /CRITERIA=PIN(.05) POUT(.10) 
  /NOORIGIN 
  /DEPENDENT pain 
  /METHOD=ENTER Sex_dummy_1 age pain_cat mindfulness cortisol_serum 
  /SCATTERPLOT=(*ZRESID ,*ZPRED) 
  /RESIDUALS HISTOGRAM(ZRESID) 
  /SAVE PRED COOK RESID.

DATASET ACTIVATE DataSet2.
SPSSINC CREATE DUMMIES VARIABLE=sex 
ROOTNAME1=Sex_dummy 
/OPTIONS ORDER=A USEVALUELABELS=YES USEML=YES OMITFIRST=NO.

COMPUTE Predicted_Backward_Model=4.762 - 0.326 * Sex_dummy_1 - 0.079 * age + 0.017 * STAI_trait + 0.057 
    * pain_cat - 0.282 * mindfulness + 0.392 * cortisol_serum.
EXECUTE.

COMPUTE Predicted_Theory_based_Model=4.761 - 0.079 * age - 0.326 * Sex_dummy_1 + 0.017 * STAI_trait + 
    0.057 * pain_cat - 0.282 * mindfulness + 0.392 * cortisol_serum.
EXECUTE.

COMPUTE Sq_Residual_Backward_Model=(pain - Predicted_Backward_Model) * (pain - Predicted_Backward_Model).
EXECUTE.

COMPUTE Sq_Residual_Theory_based_Model=(pain - Predicted_Theory_based_Model) * (pain - Predicted_Theory_based_Model).    
EXECUTE.

DESCRIPTIVES VARIABLES=Sq_Residual_Backward_Model Sq_Residual_Theory_based_Model
  /STATISTICS=MEAN SUM STDDEV MIN MAX.


