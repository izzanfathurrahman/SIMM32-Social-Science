* Encoding: UTF-8.

DATASET ACTIVATE DataSet1.
FREQUENCIES VARIABLES=pain sex age STAI_trait pain_cat mindfulness cortisol_serum cortisol_saliva
  /ORDER=ANALYSIS.

RECODE ID ('ID_28'=0) (ELSE=1) INTO ID_included.
EXECUTE.

USE ALL.
FILTER BY ID_included.
EXECUTE.

SPSSINC CREATE DUMMIES VARIABLE=sex 
ROOTNAME1=Sex_dummy 
/OPTIONS ORDER=A USEVALUELABELS=YES USEML=YES OMITFIRST=NO.

REGRESSION 
  /MISSING LISTWISE 
  /STATISTICS COEFF OUTS CI(95) BCOV R ANOVA COLLIN TOL SELECTION
  /CRITERIA=PIN(.05) POUT(.10) 
  /NOORIGIN 
  /DEPENDENT pain 
  /METHOD=ENTER age Sex_dummy_1 STAI_trait pain_cat mindfulness cortisol_serum cortisol_saliva 
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
  /GRAPHDATASET NAME="graphdataset" VARIABLES=age pain MISSING=LISTWISE REPORTMISSING=NO 
  /GRAPHSPEC SOURCE=INLINE 
  /FITLINE TOTAL=NO. 
BEGIN GPL 
  SOURCE: s=userSource(id("graphdataset")) 
  DATA: age=col(source(s), name("age")) 
  DATA: pain=col(source(s), name("pain")) 
  GUIDE: axis(dim(1), label("age")) 
  GUIDE: axis(dim(2), label("pain")) 
  GUIDE: text.title(label("Simple Scatter of pain by age")) 
  ELEMENT: point(position(age*pain))
  ELEMENT: line(position(smooth.loess(age*pain)))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=STAI_trait pain MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: STAI_trait=col(source(s), name("STAI_trait"))
  DATA: pain=col(source(s), name("pain"))
  GUIDE: axis(dim(1), label("STAI_trait"))
  GUIDE: axis(dim(2), label("pain"))
  GUIDE: text.title(label("Simple Scatter of pain by STAI_trait"))
  ELEMENT: point(position(STAI_trait*pain))
  ELEMENT: line(position(smooth.loess(STAI_trait*pain)))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=pain_cat pain MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: pain_cat=col(source(s), name("pain_cat"))
  DATA: pain=col(source(s), name("pain"))
  GUIDE: axis(dim(1), label("pain_cat"))
  GUIDE: axis(dim(2), label("pain"))
  GUIDE: text.title(label("Simple Scatter of pain by pain_cat"))
  ELEMENT: point(position(pain_cat*pain))
  ELEMENT: line(position(smooth.loess(pain_cat*pain)))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=mindfulness pain MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: mindfulness=col(source(s), name("mindfulness"))
  DATA: pain=col(source(s), name("pain"))
  GUIDE: axis(dim(1), label("mindfulness"))
  GUIDE: axis(dim(2), label("pain"))
  GUIDE: text.title(label("Simple Scatter of pain by mindfulness"))
  ELEMENT: point(position(mindfulness*pain))
  ELEMENT: line(position(smooth.loess(mindfulness*pain)))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=cortisol_serum pain MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: cortisol_serum=col(source(s), name("cortisol_serum"))
  DATA: pain=col(source(s), name("pain"))
  GUIDE: axis(dim(1), label("cortisol_serum"))
  GUIDE: axis(dim(2), label("pain"))
  GUIDE: text.title(label("Simple Scatter of pain by cortisol_serum"))
  ELEMENT: point(position(cortisol_serum*pain))
   ELEMENT: line(position(smooth.loess(cortisol_serum*pain)))
END GPL.

* Chart Builder. 
GGRAPH 
  /GRAPHDATASET NAME="graphdataset" VARIABLES=cortisol_saliva pain MISSING=LISTWISE REPORTMISSING=NO 
  /GRAPHSPEC SOURCE=INLINE 
  /FITLINE TOTAL=NO. 
BEGIN GPL 
  SOURCE: s=userSource(id("graphdataset")) 
  DATA: cortisol_saliva=col(source(s), name("cortisol_saliva")) 
  DATA: pain=col(source(s), name("pain")) 
  GUIDE: axis(dim(1), label("cortisol_saliva")) 
  GUIDE: axis(dim(2), label("pain")) 
  GUIDE: text.title(label("Simple Scatter of pain by cortisol_saliva")) 
  ELEMENT: point(position(cortisol_saliva*pain)) 
  ELEMENT: line(position(smooth.loess(cortisol_saliva*pain)))
END GPL.

COMPUTE age_squared=age * age. 
EXECUTE. 
REGRESSION 
  /MISSING LISTWISE 
  /STATISTICS COEFF OUTS CI(95) BCOV R ANOVA COLLIN TOL SELECTION 
  /CRITERIA=PIN(.05) POUT(.10) 
  /NOORIGIN 
  /DEPENDENT pain 
  /METHOD=ENTER age Sex_dummy_1 STAI_trait pain_cat mindfulness cortisol_serum cortisol_saliva 
    age_squared 
  /SCATTERPLOT=(*ZRESID ,*ZPRED) 
  /SAVE PRED COOK RESID.

COMPUTE STAI_squared=STAI_trait * STAI_trait. 
EXECUTE. 
REGRESSION 
  /MISSING LISTWISE 
  /STATISTICS COEFF OUTS CI(95) BCOV R ANOVA COLLIN TOL SELECTION
  /CRITERIA=PIN(.05) POUT(.10) 
  /NOORIGIN 
  /DEPENDENT pain 
  /METHOD=ENTER age Sex_dummy_1 STAI_trait pain_cat mindfulness cortisol_serum cortisol_saliva 
    STAI_squared 
  /SCATTERPLOT=(*ZRESID ,*ZPRED) 
  /SAVE PRED COOK RESID.

COMPUTE pain_cat_squared=pain_cat * pain_cat. 
EXECUTE. 
REGRESSION 
  /MISSING LISTWISE 
  /STATISTICS COEFF OUTS CI(95) BCOV R ANOVA COLLIN TOL SELECTION
  /CRITERIA=PIN(.05) POUT(.10) 
  /NOORIGIN 
  /DEPENDENT pain 
  /METHOD=ENTER age Sex_dummy_1 STAI_trait pain_cat mindfulness cortisol_serum cortisol_saliva 
    pain_cat_squared 
  /SCATTERPLOT=(*ZRESID ,*ZPRED) 
  /SAVE PRED COOK RESID.

COMPUTE cortisol_serum_squared=cortisol_serum * cortisol_serum. 
EXECUTE. 
REGRESSION 
  /MISSING LISTWISE 
  /STATISTICS COEFF OUTS CI(95) BCOV R ANOVA COLLIN TOL SELECTION
  /CRITERIA=PIN(.05) POUT(.10) 
  /NOORIGIN 
  /DEPENDENT pain 
  /METHOD=ENTER age Sex_dummy_1 STAI_trait pain_cat mindfulness cortisol_serum cortisol_saliva 
    cortisol_serum_squared 
  /SCATTERPLOT=(*ZRESID ,*ZPRED) 
  /SAVE PRED COOK RESID.

COMPUTE cortisol_saliva_squared=cortisol_saliva*cortisol_saliva. 
EXECUTE. 
REGRESSION 
  /MISSING LISTWISE 
  /STATISTICS COEFF OUTS CI(95) BCOV R ANOVA COLLIN TOL SELECTION
  /CRITERIA=PIN(.05) POUT(.10) 
  /NOORIGIN 
  /DEPENDENT pain 
  /METHOD=ENTER age Sex_dummy_1 STAI_trait pain_cat mindfulness cortisol_serum cortisol_saliva 
    cortisol_saliva_squared 
  /SCATTERPLOT=(*ZRESID ,*ZPRED) 
  /SAVE PRED COOK RESID.

COMPUTE mindfulness_squared=mindfulness*mindfulness. 
EXECUTE. 
REGRESSION 
  /MISSING LISTWISE 
  /STATISTICS COEFF OUTS CI(95) BCOV R ANOVA COLLIN TOL SELECTION
  /CRITERIA=PIN(.05) POUT(.10) 
  /NOORIGIN 
  /DEPENDENT pain 
  /METHOD=ENTER age Sex_dummy_1 STAI_trait pain_cat mindfulness cortisol_serum cortisol_saliva 
    mindfulness_squared 
  /SCATTERPLOT=(*ZRESID ,*ZPRED) 
  /SAVE PRED COOK RESID.

COMPUTE Unstandardized_residual_squared=RES_1*RES_1. 
EXECUTE.
REGRESSION 
  /MISSING LISTWISE 
  /STATISTICS COEFF OUTS CI(95) BCOV R ANOVA COLLIN TOL SELECTION 
  /CRITERIA=PIN(.05) POUT(.10) 
  /NOORIGIN 
  /DEPENDENT Unstandardized_residual_squared 
  /METHOD=ENTER age Sex_dummy_1 STAI_trait pain_cat mindfulness cortisol_serum cortisol_saliva 
  /SCATTERPLOT=(*ZRESID ,*ZPRED) 
  /SAVE PRED COOK RESID.

REGRESSION 
  /MISSING LISTWISE 
  /STATISTICS COEFF OUTS CI(95) BCOV R ANOVA COLLIN TOL SELECTION
  /CRITERIA=PIN(.05) POUT(.10) 
  /NOORIGIN 
  /DEPENDENT pain 
  /METHOD=ENTER age Sex_dummy_1 STAI_trait pain_cat mindfulness cortisol_serum 
  /SCATTERPLOT=(*ZRESID ,*ZPRED) 
  /SAVE PRED COOK RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) BCOV R ANOVA CHANGE COLLIN TOL SELECTION
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT pain
  /METHOD=ENTER age Sex_dummy_1
  /METHOD=ENTER STAI_trait pain_cat mindfulness cortisol_serum
  /SCATTERPLOT=(*ZRESID ,*ZPRED)
  /SAVE PRED COOK RESID.

