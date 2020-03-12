
*NLFD (2017) REPLICATIONS

****************
****************
**ANES 2008
****************
****************

**

/*  RELEVANT LIST OF VARIABLES
keep  V082425 V083112 V083113 V083114a V083114b V083115 V083115a V083116 V083117 ///
V083117a V083118 V083118a ///
FTmccain partyID ideology servicespendingFULL REPmuchlessspend REPlessspend /// 
REPmorespend REPmuchmorespend ///
FTobama partyID ideology  DEMmuchlessspend DEMlessspend DEMmorespend DEMmuchmorespend ///
V083105 V083108x servicespending servicespending2 servicespendingFULL V083069 ///
V080101a V083037a V083037b
*/


****************
*Table 1 Models
****************

* Obama Model (1)
reg  FTobama partyID ideology servicespendingFULL DEMmuchlessspend DEMlessspend DEMmorespend DEMmuchmorespend [aweight=V080101a]

*McCain Model (2)
reg  FTmccain partyID ideology servicespendingFULL REPmuchlessspend REPlessspend REPmorespend REPmuchmorespend [aweight=V080101a]



****************
****************
**ANES 2012
****************
****************

**************************************************
* Differences with candidates on defense spending
**************************************************
gen def_spend_demC=defsppr_dpc if defsppr_dpc>=1 // dem pres candidate
gen def_spend_repC=defsppr_rpc if defsppr_rpc>=1 // rep pres candidate

// self vs. democratic candidate
gen demCMinusself= def_spend_demC-def_spend_r
replace demCMinusself= demCMinusself/6

gen demCMuchMorehawk=1 if demCMinusself>=.6 & demCMinusself<=1
replace  demCMuchMorehawk=0 if demCMuchMorehawk!=1

gen demCMorehawk=1 if demCMinusself>=.1 & demCMinusself<=.6
replace demCMorehawk=0 if demCMorehawk!=1

gen demCMoredove=1 if demCMinusself<=-.1 & demCMinusself>=-.6
replace demCMoredove=0 if demCMoredove!=1

gen demCMuchMoredove=1 if demCMinusself<=-.6 & demCMinusself>=-1
replace demCMuchMoredove=0 if demCMuchMoredove!=1

gen demCEqualself=1 if demCMinusself==0
replace demCEqualself=0 if demCEqualself!=1

// self vs. replublican candidate

gen repCMinusself= def_spend_repC-def_spend_r
replace repCMinusself= repCMinusself/6

gen repCMuchMorehawk=1 if repCMinusself>=.6 & repCMinusself<=1
replace  repCMuchMorehawk=0 if repCMuchMorehawk!=1

gen repCMorehawk=1 if repCMinusself>=.1 & repCMinusself<=.6
replace repCMorehawk=0 if repCMorehawk!=1

gen repCMoredove=1 if repCMinusself<=-.1 & repCMinusself>=-.6
replace repCMoredove=0 if repCMoredove!=1

gen repCMuchMoredove=1 if repCMinusself<=-.6 & repCMinusself>=-1
replace repCMuchMoredove=0 if repCMuchMoredove!=1

gen repCEqualself=1 if repCMinusself==0
replace repCEqualself=0 if repCEqualself!=1


*************
*Covariates
*************
// ideology
gen ideo01=libcpre_self if libcpre_self>=-8
replace ideo01=4 if libcpre_self==-2 | libcpre_self==-8
replace ideo01=(ideo01-1)/6

// feeling therm toward obama
gen obamaTherm=ft_dpc if ft_dpc>=0

// feeling therm toward romney
gen romneyTherm=ft_rpc if ft_rpc>=0

//services
gen services01=spsrvpr_ssself if spsrvpr_ssself>=1
replace services01=(services01-1)/6

//pid
gen PID=pid_x if pid_x!=-2
gen pid01=(PID-1)/6

****************
*Table 2 Models
****************

*Mod 1
reg obamaTherm pid01 ideo01 demCMuchMoredove demCMoredove demCMorehawk demCMuchMorehawk services01 [aweight=weight_full] // results still hold
*Mod 2
reg romneyTherm pid01 ideo01 repCMuchMoredove repCMoredove repCMorehawk repCMuchMorehawk  services01 [aweight=weight_full]  // punishment for slightly more dovish
*Mod 3
gen voteObama=1 if presvote2012_x==1
replace voteObama=0 if presvote2012_x==2

gen voteObama2=1 if presvote2012_x==1
replace voteObama2=0 if presvote2012_x==2 | presvote2012_x==5 // people who voted for Other are coded 0

logit voteObama2 pid01 ideo01 demCMuchMoredove demCMoredove demCMorehawk demCMuchMorehawk services01 [pweight=weight_full]
mean pid01 ideo01 services01 if voteObama2==1 | voteObama2==0 // displays means for CLARIFY input

*install clarify package:  
search clarify  // download "clarify from https://gking.harvard.edu/clarify"
estsimp logit voteObama2 pid01 ideo01 demCMuchMoredove demCMoredove demCMorehawk demCMuchMorehawk services01 [pweight=weight_full]
setx pid01 .4294593 ideo01 .5284376 services01 .4708387
setx demCMuchMoredove 0 demCMoredove 0 demCMorehawk 0 demCMuchMorehawk 0
simqi

/*

      Quantity of Interest |     Mean       Std. Err.    [95% Conf. Interval]
---------------------------+--------------------------------------------------
            Pr(voteOb~2=0) |   .2552866     .0264769     .2087617    .3120345
            Pr(voteOb~2=1) |   .7447134     .0264769     .6879655    .7912383

*/
			
setx demCMorehawk 1  // change in pr(vote Obama) going from same position==>Obama more hawkish: -.091616 
simqi

/*
     Quantity of Interest |     Mean       Std. Err.    [95% Conf. Interval]
---------------------------+--------------------------------------------------
            Pr(voteOb~2=0) |   .3469026     .0303158     .2902409    .4146213
            Pr(voteOb~2=1) |   .6530974     .0303158     .5853787    .7097591

*/
			
setx demCMorehawk 0 demCMuchMorehawk 1  // change in pr(vote Obama) going from same position==>Obama more hawkish: -.4313022
simqi

