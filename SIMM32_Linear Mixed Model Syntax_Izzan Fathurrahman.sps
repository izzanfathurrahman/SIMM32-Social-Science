* Encoding: UTF-8.
* Encoding: .
* Encoding: .
* Encoding: .
* Encoding: .
* Encoding: .
* Encoding: .
* Encoding: .
* Encoding: .
* Encoding: .

DATASET ACTIVATE DataSet1.
DESCRIPTIVES VARIABLES=pain age STAI_trait pain_cat cortisol_serum cortisol_saliva mindfulness 
    weight 
  /STATISTICS=MEAN STDDEV MIN MAX.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=hospital pain MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: hospital=col(source(s), name("hospital"), unit.category())
  DATA: pain=col(source(s), name("pain"))
  DATA: id=col(source(s), name("$CASENUM"), unit.category())
  GUIDE: axis(dim(1), label("hospital"))
  GUIDE: axis(dim(2), label("pain"))
  GUIDE: text.title(label("Simple Boxplot of pain by hospital"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: schema(position(bin.quantile.letter(hospital*pain)), label(id))
END GPL.

SPSSINC CREATE DUMMIES VARIABLE=sex 
ROOTNAME1=Sex_dummy 
/OPTIONS ORDER=A USEVALUELABELS=YES USEML=YES OMITFIRST=NO.

RECODE Sex_dummy_1 (0=1) (1=0) INTO Sex_female.
EXECUTE.

MIXED pain BY Sex_female WITH age STAI_trait pain_cat cortisol_serum mindfulness
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=Sex_female age STAI_trait pain_cat cortisol_serum mindfulness | SSTYPE(3)
  /METHOD=REML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT | SUBJECT(hospital) COVTYPE(VC)
  /SAVE=FIXPRED  PRED RESID.

EXAMINE VARIABLES=RESID_1
  /PLOT BOXPLOT STEMLEAF HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=PRED_1 RESID_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: PRED_1=col(source(s), name("PRED_1"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("Predicted Values"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Simple Scatter of Residuals by Predicted Values"))
  ELEMENT: point(position(PRED_1*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=age RESID_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: age=col(source(s), name("age"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("age"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Simple Scatter of Residuals by age"))
  ELEMENT: point(position(age*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=STAI_trait RESID_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: STAI_trait=col(source(s), name("STAI_trait"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("STAI_trait"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Simple Scatter of Residuals by STAI_trait"))
  ELEMENT: point(position(STAI_trait*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=pain_cat RESID_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: pain_cat=col(source(s), name("pain_cat"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("pain_cat"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Simple Scatter of Residuals by pain_cat"))
  ELEMENT: point(position(pain_cat*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=cortisol_serum RESID_1 MISSING=LISTWISE 
    REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: cortisol_serum=col(source(s), name("cortisol_serum"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("cortisol_serum"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Simple Scatter of Residuals by cortisol_serum"))
  ELEMENT: point(position(cortisol_serum*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=mindfulness RESID_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: mindfulness=col(source(s), name("mindfulness"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("mindfulness"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Simple Scatter of Residuals by mindfulness"))
  ELEMENT: point(position(mindfulness*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=PRED_1 RESID_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: PRED_1=col(source(s), name("PRED_1"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("Predicted Values"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Simple Scatter of Residuals by Predicted Values"))
  ELEMENT: point(position(PRED_1*RESID_1))
END GPL.

SPSSINC CREATE DUMMIES VARIABLE=hospital 
ROOTNAME1=hospital_dummy 
/OPTIONS ORDER=A USEVALUELABELS=YES USEML=YES OMITFIRST=NO.

COMPUTE RESID_1_sq=RESID_1*RESID_1.
EXECUTE.

REGRESSION
/MISSING LISTWISE
/STATISTICS COEFF OUTS R ANOVA
/CRITERIA=PIN(.05) POUT(.10)
/NOORIGIN
/DEPENDENT RESID_1_sq
/METHOD=ENTER Hospital_dummy_2 Hospital_dummy_3 Hospital_dummy_4 Hospital_dummy_5 Hospital_dummy_6 Hospital_dummy_7
Hospital_dummy_8 Hospital_dummy_9 Hospital_dummy_10

CORRELATIONS
  /VARIABLES=age STAI_trait pain_cat cortisol_serum mindfulness
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

DESCRIPTIVES VARIABLES=FXPRED_1
  /STATISTICS=MEAN VARIANCE.

DATASET ACTIVATE DataSet2.
SPSSINC CREATE DUMMIES VARIABLE=sex 
ROOTNAME1=Sex_dummy 
/OPTIONS ORDER=A USEVALUELABELS=YES USEML=YES OMITFIRST=NO.

SPSSINC CREATE DUMMIES VARIABLE=Sex_dummy_1 
ROOTNAME1=Sex_female 
/OPTIONS ORDER=A USEVALUELABELS=YES USEML=YES OMITFIRST=NO.


COMPUTE Pred_pain=2.233026 - 0.382297 * Sex_dummy_1 - 0.026097 * age - 0.014313 * STAI_trait + 
    0.081692 * pain_cat + 0.533073 * cortisol_serum - 0.239227 * mindfulness.
EXECUTE.

COMPUTE Sq_Residual_Pain=(pain - Pred_pain) * (pain - Pred_pain).
EXECUTE.

DESCRIPTIVES VARIABLES=pain
  /STATISTICS=MEAN VARIANCE.

COMPUTE TS=(pain - 4.99210399) * (pain - 4.99210399).
EXECUTE.

DESCRIPTIVES VARIABLES=Sq_Residual_Pain TS
  /STATISTICS=SUM.
