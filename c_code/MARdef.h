#ifndef MARDEF_H
#define MARDEF_H

void MARgetpfpb(double *x[], int m, int n[], int k, int order, double Pf[], double Pb[], double Pfb[], double **A, double **B);
void MARfit(double *x[], int m, int n[], int k, int Order, double tildeA[]);
void MARgetaic(double tildA[], int nchns, int Order, int sampleno, double aic[]);
void MAR_residual(double **xin, double **rout, double **A, int nchns, int order, int xinlength);

#endif
