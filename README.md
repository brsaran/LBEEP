# LBEEP V1.0
Linear B-Cell Exact Epitope Predictor

1. Introduction
   =============
   LBEEP (Linear B-Cell Exact Epitope Predictor) is a perl based open source tool for the prediction of Linear B-cell epitopes.
   Please refer the article tilted "A Novel Dipeptide-based Feature Descriptor for Exact Linear B-cell Epitope Prediction" for more deatils.

2. Installation
   ============
   Linux OS
   (a) Download LBEEP from github.
   (b) Extract the files to the desired location.
   (c) Provide executable permission to LBEEP file (if it doesn't have executable rights).
   (d) Provide read and write permission to "temp" folder (if it doesn't have read and write permission).
   (e) make sure java 1.6 or higher is installed in your system.
   (f) make sure PERL 5.0 or higher version is installed in your system.
   
   Windows and other operating system
   (a) The source code has been writtern in PERL and hence it can be executed as perl script in other operating system. Note: The program is not tested in any other operating system (except Linux based OS) and hence not advised to execute in other OS.

3. Command line options
   ====================
   
   -i : input file in fasta format (mandatory). 
        Note: The option does not validate the FASTA format and hence make sure the input sequence is in fasta format.
   -m : mode either 'pep' for peptide or 'pro' for protein  (mandatory).
   -M : Model to be used 'B' for balanced model and 'O' for original model (default Balanced model).
   -t : threshold for predcition; integer ranging between 0.0 and 1.0 (default 0.6).
   -o : output file (if not mentioned output will be stored in LBEEP_out file).

4. Output Interpretation          
   =====================
   
   (a) A CSV (comma seperated values) file will be generated as output for both peptide and protein mode, which contans serial number, peptideheader|input peptide|, and probability score for the peptide mode and Position of peptide in protein, |peptide|, and probability score for protein mode.
   (b) In case of protein mode, the program queries the user whether to save the result in HTML format or NOT, if opted yes a HTML file will be saved in the name of filename mentione in -o option with the extension of .html. The result in the html file is self explanatory.
   (c) The peptides having score greater than threshold mentioned in -t is considered epitopes.

5. Limitations
   ============
   
   (a) Since the model is trained using epitopes and non-epitopes of length >5 and <=15, prediction made for peptides other than these length will be undesirable. Hence, it is advised not to mention window size less than 6 and > 15 in protein mode.

6. Example
   =======
   
   (a) ./LBEEP -i test_input_peptides -m pep -M B -o Test_peptide 
   (b) ./LBEEP -i test_input_protein -m pro -M B -t 0.6 -o Test_protein

7. License
   =======
   LBEEP V1.0 is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation version 3.0 of the License.
   This software is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License contained in the file LICENSE for more details.
