;
; "Zero-Delay State Variable Filter Test file"
; by Steven Yi 
;
; 
;
; Generated by blue 2.6.1_test1 (http://blue.kunstmusik.com)
;

<CsoundSynthesizer>

<CsInstruments>
sr=44100
ksmps=1
nchnls=2
0dbfs=1

#include "../zdf_svf.udo"

ga_bluemix_0_0	init	0
ga_bluemix_0_1	init	0
ga_bluesub_Master_0	init	0
ga_bluesub_Master_1	init	0


gk_blue_auto0 init 20
gk_blue_auto1 init 0
gk_blue_auto2 init 0
gk_blue_auto3 init 0
gk_blue_auto4 init 0.8399999738
gk_blue_auto5 init -22.7000007629
gk_blue_auto6 init 2405.6000976562
gk_blue_auto7 init 0.9499800205
gk_blue_auto8 init 0.8099700212
gk_blue_auto9 init 0

	opcode blueEffect0,aa,aa ; Chorus-02

ain1,ain2	xin
isin		ftgentmp	0, 0, 65537, 10, 1

ilevl		=		0.3		; Output level
idelay		=		0.01		; Delay in ms
idpth		=		0.002		; Depth in ms
imax		=		0.25		; Maximum LFO rate
imin		=		0.5		; Minimum LFO rate
iwave		=		isin		; LFO waveform

kwet		=		gk_blue_auto4

ain             =               ain1 + ain2 * .5

ain             =               ain * ilevl
i01             =               rnd(imax)
i02             =               rnd(imax)
i03             =               rnd(imax)
i04             =               rnd(imax)
i05             =               rnd(imax)
i06             =               rnd(imax)
i07             =               rnd(imax)
i08             =               rnd(imax)
i09             =               rnd(imax)
i10             =               rnd(imax)
i11             =               rnd(imax)
i12             =               rnd(imax)
alfo01          oscil           idpth, i01 + imin, iwave
alfo02          oscil           idpth, i02 + imin, iwave, .08
alfo03          oscil           idpth, i03 + imin, iwave, .17
alfo04          oscil           idpth, i04 + imin, iwave, .25
alfo05          oscil           idpth, i05 + imin, iwave, .33
alfo06          oscil           idpth, i06 + imin, iwave, .42
alfo07          oscil           idpth, i07 + imin, iwave, .50
alfo08          oscil           idpth, i08 + imin, iwave, .58
alfo09          oscil           idpth, i09 + imin, iwave, .67
alfo10          oscil           idpth, i10 + imin, iwave, .75
alfo11          oscil           idpth, i11 + imin, iwave, .83
alfo12          oscil           idpth, i12 + imin, iwave, .92
atemp           delayr          idelay + idpth +.1
a01             deltapi         idelay + alfo01
a02             deltapi         idelay + alfo02
a03             deltapi         idelay + alfo03
a04             deltapi         idelay + alfo04
a05             deltapi         idelay + alfo05
a06             deltapi         idelay + alfo06
a07             deltapi         idelay + alfo07
a08             deltapi         idelay + alfo08
a09             deltapi         idelay + alfo09
a10             deltapi         idelay + alfo10
a11             deltapi         idelay + alfo11
a12             deltapi         idelay + alfo12
                delayw          ain
achorusl        sum		a01, a02, a03, a04, a05, a06
achorusr        sum             a07, a08, a09, a10, a11, a12

aout1		=		ain1 * (1-kwet) + achorusl * kwet
aout2		=		ain2 * (1-kwet) + achorusr * kwet

xout	aout1,aout2


	endop
	opcode blueEffect1,aa,aa ; ReverbSC

ain1,ain2	xin
aout1, aout2  reverbsc ain1, ain2, gk_blue_auto7, gk_blue_auto6

aout1 = (ain1 * gk_blue_auto8) + (aout1 * (1 - gk_blue_auto8))
aout2 = (ain2 * gk_blue_auto8) + (aout2 * (1 - gk_blue_auto8))


xout	aout1,aout2


	endop


	instr 1	;ZDF Test Instrument
kfilterType = gk_blue_auto2

iamp = ampdbfs(p5)
ipch = cps2pch(p4, 12)

asig vco2 iamp, ipch

alp, abp, ahp zdf_svf asig, gk_blue_auto0, gk_blue_auto1

if kfilterType == 0 then
  aout = alp
elseif kfilterType == 1 then
  aout = abp
else
  aout = ahp
endif

aout *= madsr:a(0.05, 0.025, 0.05, 0.05)

aout limit aout, -1.0, 1.0
ga_bluemix_0_0 +=  aout
ga_bluemix_0_1 +=  aout

	endin

	instr 2	;Blue Mixer Instrument
ga_bluemix_0_0, ga_bluemix_0_1	blueEffect0	ga_bluemix_0_0, ga_bluemix_0_1
ktempdb = ampdb(gk_blue_auto5)
ga_bluemix_0_0 *= ktempdb
ga_bluemix_0_1 *= ktempdb
ga_bluesub_Master_0	+=	ga_bluemix_0_0
ga_bluesub_Master_1	+=	ga_bluemix_0_1
ga_bluesub_Master_0, ga_bluesub_Master_1	blueEffect1	ga_bluesub_Master_0, ga_bluesub_Master_1
ktempdb = ampdb(gk_blue_auto9)
ga_bluesub_Master_0 *= ktempdb
ga_bluesub_Master_1 *= ktempdb
outc ga_bluesub_Master_0, ga_bluesub_Master_1
ga_bluemix_0_0 = 0
ga_bluemix_0_1 = 0
ga_bluesub_Master_0 = 0
ga_bluesub_Master_1 = 0

	endin

	instr 3	;Param: cutoff
if (p4 == p5) then
gk_blue_auto0 init p4
turnoff
else
gk_blue_auto0 line p4, p3, p5
endif
	endin

	instr 4	;Param: damping
if (p4 == p5) then
gk_blue_auto1 init p4
turnoff
else
gk_blue_auto1 line p4, p3, p5
endif
	endin

	instr 5	;Param: filterType
gk_blue_auto2 init p4
turnoff
	endin


</CsInstruments>

<CsScore>




t 0 120.0



i1	0.0	0.25	7.00	-10
i1	0.25	0.25	7.03	-10
i1	0.5	0.25	7.07	-10
i1	0.75	0.25	7.10	-10
i1	1.0	0.25	7.07	-10
i1	1.25	0.25	7.03	-10
i1	1.5	0.25	7.00	-10
i1	1.75	0.25	7.03	-10
i1	2.0	0.25	7.07	-10
i1	2.25	0.25	7.03	-10
i1	2.5	0.25	6.07	-10
i1	2.75	0.25	6.10	-10
i1	3.0	0.25	7.02	-10
i1	3.25	0.25	7.00	-10
i1	3.5	0.25	6.10	-10
i1	3.75	0.25	6.07	-9
i1	4.0	0.25	7.00	-10
i1	4.25	0.25	7.03	-10
i1	4.5	0.25	7.07	-10
i1	4.75	0.25	7.10	-10
i1	5.0	0.25	7.07	-10
i1	5.25	0.25	7.03	-10
i1	5.5	0.25	7.00	-10
i1	5.75	0.25	7.03	-10
i1	6.0	0.25	7.07	-10
i1	6.25	0.25	7.03	-10
i1	6.5	0.25	6.07	-10
i1	6.75	0.25	6.10	-10
i1	7.0	0.25	7.02	-10
i1	7.25	0.25	7.00	-10
i1	7.5	0.25	6.10	-10
i1	7.75	0.25	6.07	-9
i1	8.0	0.25	7.00	-10
i1	8.25	0.25	7.03	-10
i1	8.5	0.25	7.07	-10
i1	8.75	0.25	7.10	-10
i1	9.0	0.25	7.07	-10
i1	9.25	0.25	7.03	-10
i1	9.5	0.25	7.00	-10
i1	9.75	0.25	7.03	-10
i1	10.0	0.25	7.07	-10
i1	10.25	0.25	7.03	-10
i1	10.5	0.25	6.07	-10
i1	10.75	0.25	6.10	-10
i1	11.0	0.25	7.02	-10
i1	11.25	0.25	7.00	-10
i1	11.5	0.25	6.10	-10
i1	11.75	0.25	6.07	-9
i1	12.0	0.25	7.00	-10
i1	12.25	0.25	7.03	-10
i1	12.5	0.25	7.07	-10
i1	12.75	0.25	7.10	-10
i1	13.0	0.25	7.07	-10
i1	13.25	0.25	7.03	-10
i1	13.5	0.25	7.00	-10
i1	13.75	0.25	7.03	-10
i1	14.0	0.25	7.07	-10
i1	14.25	0.25	7.03	-10
i1	14.5	0.25	6.07	-10
i1	14.75	0.25	6.10	-10
i1	15.0	0.25	7.02	-10
i1	15.25	0.25	7.00	-10
i1	15.5	0.25	6.10	-10
i1	15.75	0.25	6.07	-9
i1	16.0	0.25	7.00	-10
i1	16.25	0.25	7.03	-10
i1	16.5	0.25	7.07	-10
i1	16.75	0.25	7.10	-10
i1	17.0	0.25	7.07	-10
i1	17.25	0.25	7.03	-10
i1	17.5	0.25	7.00	-10
i1	17.75	0.25	7.03	-10
i1	18.0	0.25	7.07	-10
i1	18.25	0.25	7.03	-10
i1	18.5	0.25	6.07	-10
i1	18.75	0.25	6.10	-10
i1	19.0	0.25	7.02	-10
i1	19.25	0.25	7.00	-10
i1	19.5	0.25	6.10	-10
i1	19.75	0.25	6.07	-9
i1	20.0	0.25	7.00	-10
i1	20.25	0.25	7.03	-10
i1	20.5	0.25	7.07	-10
i1	20.75	0.25	7.10	-10
i1	21.0	0.25	7.07	-10
i1	21.25	0.25	7.03	-10
i1	21.5	0.25	7.00	-10
i1	21.75	0.25	7.03	-10
i1	22.0	0.25	7.07	-10
i1	22.25	0.25	7.03	-10
i1	22.5	0.25	6.07	-10
i1	22.75	0.25	6.10	-10
i1	23.0	0.25	7.02	-10
i1	23.25	0.25	7.00	-10
i1	23.5	0.25	6.10	-10
i1	23.75	0.25	6.07	-9
i1	24.0	0.25	7.00	-10
i1	24.25	0.25	7.03	-10
i1	24.5	0.25	7.07	-10
i1	24.75	0.25	7.10	-10
i1	25.0	0.25	7.07	-10
i1	25.25	0.25	7.03	-10
i1	25.5	0.25	7.00	-10
i1	25.75	0.25	7.03	-10
i1	26.0	0.25	7.07	-10
i1	26.25	0.25	7.03	-10
i1	26.5	0.25	6.07	-10
i1	26.75	0.25	6.10	-10
i1	27.0	0.25	7.02	-10
i1	27.25	0.25	7.00	-10
i1	27.5	0.25	6.10	-10
i1	27.75	0.25	6.07	-9
i1	28.0	0.25	7.00	-10
i1	28.25	0.25	7.03	-10
i1	28.5	0.25	7.07	-10
i1	28.75	0.25	7.10	-10
i1	29.0	0.25	7.07	-10
i1	29.25	0.25	7.03	-10
i1	29.5	0.25	7.00	-10
i1	29.75	0.25	7.03	-10
i1	30.0	0.25	7.07	-10
i1	30.25	0.25	7.03	-10
i1	30.5	0.25	6.07	-10
i1	30.75	0.25	6.10	-10
i1	31.0	0.25	7.02	-10
i1	31.25	0.25	7.00	-10
i1	31.5	0.25	6.10	-10
i1	31.75	0.25	6.07	-9
i1	32.0	0.25	7.00	-10
i1	32.25	0.25	7.03	-10
i1	32.5	0.25	7.07	-10
i1	32.75	0.25	7.10	-10
i1	33.0	0.25	7.07	-10
i1	33.25	0.25	7.03	-10
i1	33.5	0.25	7.00	-10
i1	33.75	0.25	7.03	-10
i1	34.0	0.25	7.07	-10
i1	34.25	0.25	7.03	-10
i1	34.5	0.25	6.07	-10
i1	34.75	0.25	6.10	-10
i1	35.0	0.25	7.02	-10
i1	35.25	0.25	7.00	-10
i1	35.5	0.25	6.10	-10
i1	35.75	0.25	6.07	-9
i1	36.0	0.25	7.00	-10
i1	36.25	0.25	7.03	-10
i1	36.5	0.25	7.07	-10
i1	36.75	0.25	7.10	-10
i1	37.0	0.25	7.07	-10
i1	37.25	0.25	7.03	-10
i1	37.5	0.25	7.00	-10
i1	37.75	0.25	7.03	-10
i1	38.0	0.25	7.07	-10
i1	38.25	0.25	7.03	-10
i1	38.5	0.25	6.07	-10
i1	38.75	0.25	6.10	-10
i1	39.0	0.25	7.02	-10
i1	39.25	0.25	7.00	-10
i1	39.5	0.25	6.10	-10
i1	39.75	0.25	6.07	-9
i1	40.0	0.25	7.00	-10
i1	40.25	0.25	7.03	-10
i1	40.5	0.25	7.07	-10
i1	40.75	0.25	7.10	-10
i1	41.0	0.25	7.07	-10
i1	41.25	0.25	7.03	-10
i1	41.5	0.25	7.00	-10
i1	41.75	0.25	7.03	-10
i1	42.0	0.25	7.07	-10
i1	42.25	0.25	7.03	-10
i1	42.5	0.25	6.07	-10
i1	42.75	0.25	6.10	-10
i1	43.0	0.25	7.02	-10
i1	43.25	0.25	7.00	-10
i1	43.5	0.25	6.10	-10
i1	43.75	0.25	6.07	-9
i1	44.0	0.25	7.00	-10
i1	44.25	0.25	7.03	-10
i1	44.5	0.25	7.07	-10
i1	44.75	0.25	7.10	-10
i1	45.0	0.25	7.07	-10
i1	45.25	0.25	7.03	-10
i1	45.5	0.25	7.00	-10
i1	45.75	0.25	7.03	-10
i1	46.0	0.25	7.07	-10
i1	46.25	0.25	7.03	-10
i1	46.5	0.25	6.07	-10
i1	46.75	0.25	6.10	-10
i1	47.0	0.25	7.02	-10
i1	47.25	0.25	7.00	-10
i1	47.5	0.25	6.10	-10
i1	47.75	0.25	6.07	-9
i1	48.0	0.25	7.00	-10
i1	48.25	0.25	7.03	-10
i1	48.5	0.25	7.07	-10
i1	48.75	0.25	7.10	-10
i1	49.0	0.25	7.07	-10
i1	49.25	0.25	7.03	-10
i1	49.5	0.25	7.00	-10
i1	49.75	0.25	7.03	-10
i1	50.0	0.25	7.07	-10
i1	50.25	0.25	7.03	-10
i1	50.5	0.25	6.07	-10
i1	50.75	0.25	6.10	-10
i1	51.0	0.25	7.02	-10
i1	51.25	0.25	7.00	-10
i1	51.5	0.25	6.10	-10
i1	51.75	0.25	6.07	-9
i1	52.0	0.25	7.00	-10
i1	52.25	0.25	7.03	-10
i1	52.5	0.25	7.07	-10
i1	52.75	0.25	7.10	-10
i1	53.0	0.25	7.07	-10
i1	53.25	0.25	7.03	-10
i1	53.5	0.25	7.00	-10
i1	53.75	0.25	7.03	-10
i1	54.0	0.25	7.07	-10
i1	54.25	0.25	7.03	-10
i1	54.5	0.25	6.07	-10
i1	54.75	0.25	6.10	-10
i1	55.0	0.25	7.02	-10
i1	55.25	0.25	7.00	-10
i1	55.5	0.25	6.10	-10
i1	55.75	0.25	6.07	-9
i1	56.0	0.25	7.00	-10
i1	56.25	0.25	7.03	-10
i1	56.5	0.25	7.07	-10
i1	56.75	0.25	7.10	-10
i1	57.0	0.25	7.07	-10
i1	57.25	0.25	7.03	-10
i1	57.5	0.25	7.00	-10
i1	57.75	0.25	7.03	-10
i1	58.0	0.25	7.07	-10
i1	58.25	0.25	7.03	-10
i1	58.5	0.25	6.07	-10
i1	58.75	0.25	6.10	-10
i1	59.0	0.25	7.02	-10
i1	59.25	0.25	7.00	-10
i1	59.5	0.25	6.10	-10
i1	59.75	0.25	6.07	-9
i1	60.0	0.25	7.00	-10
i1	60.25	0.25	7.03	-10
i1	60.5	0.25	7.07	-10
i1	60.75	0.25	7.10	-10
i1	61.0	0.25	7.07	-10
i1	61.25	0.25	7.03	-10
i1	61.5	0.25	7.00	-10
i1	61.75	0.25	7.03	-10
i1	62.0	0.25	7.07	-10
i1	62.25	0.25	7.03	-10
i1	62.5	0.25	6.07	-10
i1	62.75	0.25	6.10	-10
i1	63.0	0.25	7.02	-10
i1	63.25	0.25	7.00	-10
i1	63.5	0.25	6.10	-10
i1	63.75	0.25	6.07	-9
i1	64.0	0.25	7.00	-10
i1	64.25	0.25	7.03	-10
i1	64.5	0.25	7.07	-10
i1	64.75	0.25	7.10	-10
i1	65.0	0.25	7.07	-10
i1	65.25	0.25	7.03	-10
i1	65.5	0.25	7.00	-10
i1	65.75	0.25	7.03	-10
i1	66.0	0.25	7.07	-10
i1	66.25	0.25	7.03	-10
i1	66.5	0.25	6.07	-10
i1	66.75	0.25	6.10	-10
i1	67.0	0.25	7.02	-10
i1	67.25	0.25	7.00	-10
i1	67.5	0.25	6.10	-10
i1	67.75	0.25	6.07	-9
i1	68.0	0.25	7.00	-10
i1	68.25	0.25	7.03	-10
i1	68.5	0.25	7.07	-10
i1	68.75	0.25	7.10	-10
i1	69.0	0.25	7.07	-10
i1	69.25	0.25	7.03	-10
i1	69.5	0.25	7.00	-10
i1	69.75	0.25	7.03	-10
i1	70.0	0.25	7.07	-10
i1	70.25	0.25	7.03	-10
i1	70.5	0.25	6.07	-10
i1	70.75	0.25	6.10	-10
i1	71.0	0.25	7.02	-10
i1	71.25	0.25	7.00	-10
i1	71.5	0.25	6.10	-10
i1	71.75	0.25	6.07	-9
i1	72.0	0.25	7.00	-10
i1	72.25	0.25	7.03	-10
i1	72.5	0.25	7.07	-10
i1	72.75	0.25	7.10	-10
i1	73.0	0.25	7.07	-10
i1	73.25	0.25	7.03	-10
i1	73.5	0.25	7.00	-10
i1	73.75	0.25	7.03	-10
i1	74.0	0.25	7.07	-10
i1	74.25	0.25	7.03	-10
i1	74.5	0.25	6.07	-10
i1	74.75	0.25	6.10	-10
i1	75.0	0.25	7.02	-10
i1	75.25	0.25	7.00	-10
i1	75.5	0.25	6.10	-10
i1	75.75	0.25	6.07	-9
i1	76.0	0.25	7.00	-10
i1	76.25	0.25	7.03	-10
i1	76.5	0.25	7.07	-10
i1	76.75	0.25	7.10	-10
i1	77.0	0.25	7.07	-10
i1	77.25	0.25	7.03	-10
i1	77.5	0.25	7.00	-10
i1	77.75	0.25	7.03	-10
i1	78.0	0.25	7.07	-10
i1	78.25	0.25	7.03	-10
i1	78.5	0.25	6.07	-10
i1	78.75	0.25	6.10	-10
i1	79.0	0.25	7.02	-10
i1	79.25	0.25	7.00	-10
i1	79.5	0.25	6.10	-10
i1	79.75	0.25	6.07	-9
i1	80.0	0.25	7.00	-10
i1	80.25	0.25	7.03	-10
i1	80.5	0.25	7.07	-10
i1	80.75	0.25	7.10	-10
i1	81.0	0.25	7.07	-10
i1	81.25	0.25	7.03	-10
i1	81.5	0.25	7.00	-10
i1	81.75	0.25	7.03	-10
i1	82.0	0.25	7.07	-10
i1	82.25	0.25	7.03	-10
i1	82.5	0.25	6.07	-10
i1	82.75	0.25	6.10	-10
i1	83.0	0.25	7.02	-10
i1	83.25	0.25	7.00	-10
i1	83.5	0.25	6.10	-10
i1	83.75	0.25	6.07	-9
i1	84.0	0.25	7.00	-10
i1	84.25	0.25	7.03	-10
i1	84.5	0.25	7.07	-10
i1	84.75	0.25	7.10	-10
i1	85.0	0.25	7.07	-10
i1	85.25	0.25	7.03	-10
i1	85.5	0.25	7.00	-10
i1	85.75	0.25	7.03	-10
i1	86.0	0.25	7.07	-10
i1	86.25	0.25	7.03	-10
i1	86.5	0.25	6.07	-10
i1	86.75	0.25	6.10	-10
i1	87.0	0.25	7.02	-10
i1	87.25	0.25	7.00	-10
i1	87.5	0.25	6.10	-10
i1	87.75	0.25	6.07	-9
i1	88.0	0.25	7.00	-10
i1	88.25	0.25	7.03	-10
i1	88.5	0.25	7.07	-10
i1	88.75	0.25	7.10	-10
i1	89.0	0.25	7.07	-10
i1	89.25	0.25	7.03	-10
i1	89.5	0.25	7.00	-10
i1	89.75	0.25	7.03	-10
i1	90.0	0.25	7.07	-10
i1	90.25	0.25	7.03	-10
i1	90.5	0.25	6.07	-10
i1	90.75	0.25	6.10	-10
i1	91.0	0.25	7.02	-10
i1	91.25	0.25	7.00	-10
i1	91.5	0.25	6.10	-10
i1	91.75	0.25	6.07	-9
i1	92.0	0.25	7.00	-10
i1	92.25	0.25	7.03	-10
i1	92.5	0.25	7.07	-10
i1	92.75	0.25	7.10	-10
i1	93.0	0.25	7.07	-10
i1	93.25	0.25	7.03	-10
i1	93.5	0.25	7.00	-10
i1	93.75	0.25	7.03	-10
i1	94.0	0.25	7.07	-10
i1	94.25	0.25	7.03	-10
i1	94.5	0.25	6.07	-10
i1	94.75	0.25	6.10	-10
i1	95.0	0.25	7.02	-10
i1	95.25	0.25	7.00	-10
i1	95.5	0.25	6.10	-10
i1	95.75	0.25	6.07	-9
i1	0.0	0.25	8.00	-10
i1	0.25	0.25	8.00	-10
i1	4.0	0.25	8.00	-10
i1	4.25	0.25	8.00	-10
i1	8.0	0.25	8.00	-10
i1	8.25	0.25	8.00	-10
i1	12.0	0.25	8.00	-10
i1	12.25	0.25	8.00	-10
i1	16.0	0.25	8.00	-10
i1	16.25	0.25	8.00	-10
i1	20.0	0.25	8.00	-10
i1	20.25	0.25	8.00	-10
i1	24.0	0.25	8.00	-10
i1	24.25	0.25	8.00	-10
i1	28.0	0.25	8.00	-10
i1	28.25	0.25	8.00	-10
i1	32.0	0.25	8.00	-10
i1	32.25	0.25	8.00	-10
i1	36.0	0.25	8.00	-10
i1	36.25	0.25	8.00	-10
i1	40.0	0.25	8.00	-10
i1	40.25	0.25	8.00	-10
i1	44.0	0.25	8.00	-10
i1	44.25	0.25	8.00	-10
i1	48.0	0.25	8.00	-10
i1	48.25	0.25	8.00	-10
i1	52.0	0.25	8.00	-10
i1	52.25	0.25	8.00	-10
i1	56.0	0.25	8.00	-10
i1	56.25	0.25	8.00	-10
i1	60.0	0.25	8.00	-10
i1	60.25	0.25	8.00	-10
i1	64.0	0.25	8.00	-10
i1	64.25	0.25	8.00	-10
i1	68.0	0.25	8.00	-10
i1	68.25	0.25	8.00	-10
i1	72.0	0.25	8.00	-10
i1	72.25	0.25	8.00	-10
i1	76.0	0.25	8.00	-10
i1	76.25	0.25	8.00	-10
i1	80.0	0.25	8.00	-10
i1	80.25	0.25	8.00	-10
i1	84.0	0.25	8.00	-10
i1	84.25	0.25	8.00	-10
i1	88.0	0.25	8.00	-10
i1	88.25	0.25	8.00	-10
i1	92.0	0.25	8.00	-10
i1	92.25	0.25	8.00	-10
i1	0.0	0.25	9.00	-8
i1	0.25	0.25	9.00	-8
i1	4.0	0.25	9.00	-8
i1	4.25	0.25	9.00	-8
i1	8.0	0.25	9.00	-8
i1	8.25	0.25	9.00	-8
i1	12.0	0.25	9.00	-8
i1	12.25	0.25	9.00	-8
i1	16.0	0.25	9.00	-8
i1	16.25	0.25	9.00	-8
i1	20.0	0.25	9.00	-8
i1	20.25	0.25	9.00	-8
i1	24.0	0.25	9.00	-8
i1	24.25	0.25	9.00	-8
i1	28.0	0.25	9.00	-8
i1	28.25	0.25	9.00	-8
i1	32.0	0.25	9.00	-8
i1	32.25	0.25	9.00	-8
i1	36.0	0.25	9.00	-8
i1	36.25	0.25	9.00	-8
i1	40.0	0.25	9.00	-8
i1	40.25	0.25	9.00	-8
i1	44.0	0.25	9.00	-8
i1	44.25	0.25	9.00	-8
i1	48.0	0.25	9.00	-8
i1	48.25	0.25	9.00	-8
i1	52.0	0.25	9.00	-8
i1	52.25	0.25	9.00	-8
i1	56.0	0.25	9.00	-8
i1	56.25	0.25	9.00	-8
i1	60.0	0.25	9.00	-8
i1	60.25	0.25	9.00	-8
i1	64.0	0.25	9.00	-8
i1	64.25	0.25	9.00	-8
i1	68.0	0.25	9.00	-8
i1	68.25	0.25	9.00	-8
i1	72.0	0.25	9.00	-8
i1	72.25	0.25	9.00	-8
i1	76.0	0.25	9.00	-8
i1	76.25	0.25	9.00	-8
i1	80.0	0.25	9.00	-8
i1	80.25	0.25	9.00	-8
i1	84.0	0.25	9.00	-8
i1	84.25	0.25	9.00	-8
i1	88.0	0.25	9.00	-8
i1	88.25	0.25	9.00	-8
i1	92.0	0.25	9.00	-8
i1	92.25	0.25	9.00	-8
i1	0.0	1	9.00	-8
i1	1.0	1	9.00	-8
i1	2.0	1	9.05	-8
i1	3.0	1	9.03	-8
i1	4.0	1	9.00	-8
i1	5.0	1	9.00	-8
i1	6.0	1	9.05	-8
i1	7.0	1	9.03	-8
i1	8.0	1	9.00	-8
i1	9.0	1	9.00	-8
i1	10.0	1	9.05	-8
i1	11.0	1	9.03	-8
i1	12.0	1	9.00	-8
i1	13.0	1	9.00	-8
i1	14.0	1	9.05	-8
i1	15.0	1	9.03	-8
i1	16.0	1	9.00	-8
i1	17.0	1	9.00	-8
i1	18.0	1	9.05	-8
i1	19.0	1	9.03	-8
i1	20.0	1	9.00	-8
i1	21.0	1	9.00	-8
i1	22.0	1	9.05	-8
i1	23.0	1	9.03	-8
i1	24.0	1	9.00	-8
i1	25.0	1	9.00	-8
i1	26.0	1	9.05	-8
i1	27.0	1	9.03	-8
i1	28.0	1	9.00	-8
i1	29.0	1	9.00	-8
i1	30.0	1	9.05	-8
i1	31.0	1	9.03	-8
i1	32.0	1	9.00	-8
i1	33.0	1	9.00	-8
i1	34.0	1	9.05	-8
i1	35.0	1	9.03	-8
i1	36.0	1	9.00	-8
i1	37.0	1	9.00	-8
i1	38.0	1	9.05	-8
i1	39.0	1	9.03	-8
i1	40.0	1	9.00	-8
i1	41.0	1	9.00	-8
i1	42.0	1	9.05	-8
i1	43.0	1	9.03	-8
i1	44.0	1	9.00	-8
i1	45.0	1	9.00	-8
i1	46.0	1	9.05	-8
i1	47.0	1	9.03	-8
i1	48.0	1	9.00	-8
i1	49.0	1	9.00	-8
i1	50.0	1	9.05	-8
i1	51.0	1	9.03	-8
i1	52.0	1	9.00	-8
i1	53.0	1	9.00	-8
i1	54.0	1	9.05	-8
i1	55.0	1	9.03	-8
i1	56.0	1	9.00	-8
i1	57.0	1	9.00	-8
i1	58.0	1	9.05	-8
i1	59.0	1	9.03	-8
i1	60.0	1	9.00	-8
i1	61.0	1	9.00	-8
i1	62.0	1	9.05	-8
i1	63.0	1	9.03	-8
i1	64.0	1	9.00	-8
i1	65.0	1	9.00	-8
i1	66.0	1	9.05	-8
i1	67.0	1	9.03	-8
i1	68.0	1	9.00	-8
i1	69.0	1	9.00	-8
i1	70.0	1	9.05	-8
i1	71.0	1	9.03	-8
i1	72.0	1	9.00	-8
i1	73.0	1	9.00	-8
i1	74.0	1	9.05	-8
i1	75.0	1	9.03	-8
i1	76.0	1	9.00	-8
i1	77.0	1	9.00	-8
i1	78.0	1	9.05	-8
i1	79.0	1	9.03	-8
i1	80.0	1	9.00	-8
i1	81.0	1	9.00	-8
i1	82.0	1	9.05	-8
i1	83.0	1	9.03	-8
i1	84.0	1	9.00	-8
i1	85.0	1	9.00	-8
i1	86.0	1	9.05	-8
i1	87.0	1	9.03	-8
i1	88.0	1	9.00	-8
i1	89.0	1	9.00	-8
i1	90.0	1	9.05	-8
i1	91.0	1	9.03	-8
i1	92.0	1	9.00	-8
i1	93.0	1	9.00	-8
i1	94.0	1	9.05	-8
i1	95.0	1	9.03	-8
i2	0	104	
i3	0	16	20	6000
i3	16	16	6000	100
i3	32	16	100	6000
i3	48	16	6000	20
i3	64	16	20	6000
i3	80	16	6000	20
i3	96	0.0001	20	20
i4	0	16	0	1
i4	16	16	1	0
i4	32	16	0	1
i4	48	16	1	0
i4	64	16	0	1
i4	80	16	1	0
i4	96	0.0001	0	0
i5	64	0.0001	2
e

</CsScore>

</CsoundSynthesizer>