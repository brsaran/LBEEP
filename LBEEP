#!/usr/bin/perl
use strict;
use Cwd qw(abs_path);
use lib abs_path().'/dependency/module/';
use brsaran::DDE; 


##########################

my $path2WEKA = abs_path().'/dependency/'; #change only if weka.jar is in some other location;

#########################

#######   DO not change anyhting beyond this line ###############

###Argument Check~~~~~~~~~~~~
my ($i, $mode, $inFile, $outFile,$Thresh,$MODEL);
for($i=0;$i<@ARGV;$i++){
	if($ARGV[$i] eq "-m"){
		$mode = $ARGV[$i+1];
		$mode=~s/\s//g;
		if(($mode ne 'pep') && ($mode ne 'pro')){ print "-m $mode invalid option! use 'pro' or 'pep' Exiting !\n"; exit;}
	}
	if($ARGV[$i] eq "-i"){
		$inFile = $ARGV[$i+1];
		$inFile=~s/\s//g;
		unless(open(INFILE,"$inFile")){die "Invalid Input file or file doesn't Exist ! Exiting";}
	}
	if($ARGV[$i] eq "-o"){
		$outFile = $ARGV[$i+1];
		$outFile=~s/\s//g;
		unless(open(OUTFILE,">$outFile")){die "Invalid Output file name or No permission to write the file ! Exiting";}
		#close(OUTFILE);
	}
	if($ARGV[$i] eq "-M"){
		$MODEL = $ARGV[$i+1];
		$MODEL=~s/\s//g;
		if(($MODEL ne 'B') && ($MODEL ne 'O')){ print "-M $MODEL invalid option! use 'B' or 'O' Exiting !\n"; exit;}
	}
	if($ARGV[$i] eq "-t"){
		$Thresh = $ARGV[$i+1];
		$Thresh=~s/\s//g;
		if(($Thresh!~m/\d\.\d+/g)){ print "-t:($Thresh) should be greater than 0 and less than 1! Exiting !\n"; exit;}
	}
}
if($inFile eq ''){print "-i: cannot be null; Input file missing ! Exiting !\n"; `rm $outFile`; exit;}
if($mode eq ''){print "-m: cannot be null ! use 'pro' or 'pep' ! Exiting !\n"; `rm $outFile`; exit;}
if($outFile eq ''){print "\n-o: empty ! saving results to file LBEEP_out\n"; $outFile = "LBEEP_out";unless(open(OUTFILE,">$outFile")){die "Invalid Output file name or No permission to write the file ! Exiting";}}
if($MODEL eq ''){print "-M: model set to balanced\n";$MODEL = 'B';}
if($Thresh eq ''){print "-t: Threshold set to 0.6\n"; $Thresh = 0.6;}

#Argument Check Ends~~~~~~~~~~~~~~


##################### PEPTIDE MODE BEGINS #####################################
my (@FHead,@PEP,@PRO,@Result,$Pep_DDE,$j,$line1,$line2,$temp,$Arff_header,$Pro_Out,$Pep_Out,$FinalOutPep);
$FinalOutPep = 'Sno,ID|Peptide|,Score'."\n";
$j=0;

if($mode eq "pep"){
	$FinalOutPep = 'Sno,ID|Peptide|,Score'."\n";
	print "\nProcessing Input...........";
	while(($line1 = <INFILE>) && ($line2 = <INFILE>)){
		$line1=~s/\s//g;		
		$FHead[$j] = $line1; #Store Header
		$line2=~s/\s//g;		
		$PEP[$j]=$line2; #Store Peptide
		if((length($PEP[$j]))>15){print "\nInput peptide $FHead[$j] has length greater than 15. May obtain undesired result ! ";}
		if((length($PEP[$j]))<6){print "\nInput peptide $FHead[$j] has length less than 6 ! May obtain undesired result !";}
		$Pep_DDE.= DDE($line2).",P\n"; #Compute DDE
		$j++;
	}
	close (INFILE);
	$temp = './temp/'.generate_random_string(6).'.arff';
	for($i=1;$i<=400;$i++){
		$Arff_header .= "\@attribute $i numeric\n";
	}
	$Arff_header = "\@relation Epitope\n".$Arff_header.'@attribute LABEL {P,N}'."\n"."\@data\n";
	open(TEMP,">$temp");
	print TEMP $Arff_header.$Pep_DDE;
	close(TEMP);
	print "Done\n";
	$Pep_DDE=""; #Release memory	
	print "Prediction.................";
	$Pep_Out = Epi_Predict_pep($temp,$path2WEKA,$MODEL);	#Make prediction
	$Pep_Out=~s/^(?:.*\n){1,5}//; #Remove line 1-5
	$Pep_Out=~s/(?:.*\n){1,1}\z//; #Remove last line
	`rm $temp`; #remove ARFF file
	print "Done\n";
	
	##########Result Organization################
	print "Generating Output..............";
	@Result = split("\n",$Pep_Out);
	for($j=0;$j<@Result;$j++){
		if($Result[$j]=~m/\+/g){
			$Result[$j]=substr($Result[$j],-6);
			$Result[$j]= 1-$Result[$j];
		}else{
			$Result[$j]=substr($Result[$j],-6);
		}
		$Result[$j]=~s/\s//g;
		$FinalOutPep.= ($j+1).",".$FHead[$j].'|'.$PEP[$j].'|,'. $Result[$j]."\n";
	}
	print OUTFILE $FinalOutPep;
	close(OUTFILE);	
	print "Done\n";
}
######		PEPTIDE MODE ENDS ###########################

############################# Protein Mode Begins ##########################
$j=0;
my ($PFhead, $protein,@Position);

if($mode eq "pro"){
	$FinalOutPep = 'Position,|Peptide|,Score'."\n";
	print "\nEnter the Window size to be scanned (6-15):";
	my $Window = <STDIN>;
	chop($Window);
		$line1 = <INFILE>;
		$line2 = <INFILE>;
		$line1=~s/\s//g;
		$line2=~s/\s//g;				
		$PFhead = $line1; #Store Header
		$protein=$line2; #Store Protein
				
	if(($Window < 6) && ($Window >15)){
		print "\nWindow size not between 6 and 15 ! May obtain undesired result !\n"; 
	}
	close (INFILE);
	######## Split the protein into mentioned window size and ARFF #################
	print "\nSplitting the Sequence into the mentioned Window Size........";
	my $Length_Protein = length($protein);
	for($j=0;$j<($Length_Protein - ($Window-1));$j++){
		$PRO[$j] = substr($protein,$j,$Window);
		$Pep_DDE.= DDE($PRO[$j]).",P\n"; #Compute DDE
		$Position[$j]= ($j+1)."-".($j+$Window);
	}
	$temp = './temp/'.generate_random_string(6).'.arff';
	for($i=1;$i<=400;$i++){
		$Arff_header .= "\@attribute $i numeric\n";
	}
	$Arff_header = "\@relation Epitope\n".$Arff_header.'@attribute LABEL {P,N}'."\n"."\@data\n";
	open(TEMP,">$temp");
	print TEMP $Arff_header.$Pep_DDE;
	close(TEMP);
	$Pep_DDE = "";
	print "Done\n";
	print "Prediction............";
	$Pro_Out = Epi_Predict_pep($temp,$path2WEKA,$MODEL);	#Make prediction	
	$Pro_Out=~s/^(?:.*\n){1,5}//; #Remove line 1-5
	$Pro_Out=~s/(?:.*\n){1,1}\z//; #Remove last line
	`rm $temp`; #remove ARFF file
	print "Done\n";
	print "Generating Output..............";
	
	@Result = split("\n",$Pro_Out);
	for($j=0;$j<@Result;$j++){
		if($Result[$j]=~m/\+/g){
			$Result[$j]=substr($Result[$j],-6);
			$Result[$j]=~s/\s//g;
			$Result[$j]= 1-$Result[$j];
		}else{
			$Result[$j]=substr($Result[$j],-6);
		}
		$Result[$j]=~s/\s//g;
		$FinalOutPep.= $Position[$j].",".'|'.$PRO[$j].'|,'. $Result[$j]."\n";
	}
	print OUTFILE $FinalOutPep;
	close(OUTFILE);	
	print "Done\n";
	############# Splitting & Prediction Ends #####################
	
	########### Generating HTML outputs ##############################
	my (@EE);
	print "Want to generate HTML output? (y/n):";
	my $Ht = <STDIN>;
	chop($Ht);
	while (uc $Ht eq 'Y'){
		print "Generating HTML Output......................";
		my $HTML_head = '<!DOCTYPE html><html><body><body bgcolor="#E6E6FA"><H1><center>L-BEEP V1.0</H1><br><H2> <center>Results for the Input Protein: <font color = "blue">'. substr($PFhead,1,10).'</font></H2><br><br>'."<H4><font color = 'red'>Parameters: -i: $inFile\; -m: $mode\; -M: $MODEL\; -t: $Thresh\; Window_size: $Window</font></h4>".'<hr><br><pre>';
		for($j=0;$j<@Result;$j++){
			if($Result[$j]>= $Thresh){
				$EE[$j] = '<a href=" " title="'. $Position[$j].'|'.$PRO[$j].'|'. $Result[$j].'" style="background-color:#FFFFFF;color:#000000;text-decoration:none"><font color="green">E</font></a>';	
			}else{	
				$EE[$j] = '<a href=" " title="'. $Position[$j].'|'.$PRO[$j].'|'. $Result[$j].'" style="background-color:#FFFFFF;color:#000000;text-decoration:none"><font color="red">.</font></a>';	
			}
		}
		$Ht=""; #Criteria to exit while
		
		################## Splitting 50 ##########
		my (@split_50, $i50);
		$i50 = (length($protein)/50);
		if($i50<1){$i50 = 1;}elsif($i50 > int($i50)){$i50=int($i50)+1;}
		my $k = 0;
		my $l=0;
		my $junk = 0;
		if(($Window%2)== 0){ $junk = int ($Window/2);}else{$junk = (int($Window/2)+1);} 
		for($j=0;$j<$i50;$j++){
			$split_50[$j] = substr($protein,$k,50);
			$HTML_head.= "Sequence:      ".$split_50[$j]."<br>Prediction:    ";
			if($j==0){
				$HTML_head.=  " " x ($junk-1);
				for($i=$l;$i<(($l+50)-($junk-1));$i++){
					$HTML_head.= $EE[$i];
				}
				$l=($l+50)-($junk-1);
				$HTML_head.= "<br>";
				$k=($k+50);
			}else{
				for($i=$l;$i<($l+50);$i++){
					$HTML_head.= $EE[$i];
				}
				$HTML_head.= "<br>";
				$l=$l+50;
				$k=($k+50);
			}
			
		}
		$HTML_head.= "<br><br>Legend: <font color='green'>'E' -> Epitope\;</font> <font color = 'red'>'.' -> Non-Epitope <br><hr></pre></body></html>";
		$outFile = $outFile.'.html';
		open(OUTFILE,">$outFile");
		print OUTFILE $HTML_head;
		close(OUTFILE);
		print "Done\n";
		#################### Splitting 50 ends###########
		#print "$HTML_head @EE";
	}
	############## HTML Output ENDS #################################
}
################## Protein Mode Ends ########################

