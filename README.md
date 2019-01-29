B-SMART
=======

Brian-System for Multivariate AutoRegressive Time series (B-SMART)

We have developed a Matlab/C toolbox, Brain-SMART (System for Multivariate AutoRegressive Time series, or BSMART), for spectral analysis of continuous neural time series data recorded simultaneously from multiple sensors. Available functions include time series data importing/exporting, preprocessing (normalization and trend removal), AutoRegressive (AR) modeling (multivariate/bivariate model estima-tion and validation), spectral quantity estimation (auto power, coherence and Granger causality spectra), network analysis (including coherence and causality networks) and visualization (including data, power, coherence and causality views). The tools for investigating causal network structures in respect of frequency bands are unique functions provided by this toolbox. All functionality has been integrated into a simple and user-friendly graphical user interface (GUI) environment designed for easy accessibility. Although we have tested the toolbox only on Windows and Linux operating systems, BSMART itself is system independent. This toolbox is freely available (http://www.brain-smart.org) under the GNU public license for open source development.

**B-SMART** is licensed by GNU Version 2 of June 1991.

The code repository for **B-SMART** is hosted on GitHub at https://github.com/jiecui/b-smart.

Installation
------------
1. Copy the files to the directory of your choice, e.g. ~/bsmart/
1. Within Matlab, go the directory where you have copied the files e.g. >> cd(‘~/bsmart/’);
1. Add the directory and its subdirectories into MatLab search path.
1. Type bsmart at MatLab prompt, i.e. >> bsmart

References
----------
* Cui, J., Xu, L., Bressler, S. L., Ding, M., & Liang, H. (2008). BSMART: A MATLAB/C toolbox for analysis of multichannel neural time series. Neural Networks, 21(8), 1094-1104. doi:DOI 10.1016/j.neunet.2008.05.007
