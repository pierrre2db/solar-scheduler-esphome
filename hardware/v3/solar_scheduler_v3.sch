<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE eagle SYSTEM "eagle.dtd">
<eagle version="9.6.2">
<drawing>
<settings><setting alwaysvectorfont="no"/><setting verticaltext="up"/></settings>
<grid distance="0.1" unitdist="inch" unit="inch" style="lines" multiple="1" display="no" altdistance="0.01" altunitdist="inch" altunit="inch"/>
<layers>
<layer number="1" name="Top" color="4" fill="1" visible="yes" active="yes"/>
<layer number="16" name="Bottom" color="1" fill="1" visible="yes" active="yes"/>
<layer number="17" name="Pads" color="2" fill="1" visible="yes" active="yes"/>
<layer number="18" name="Vias" color="2" fill="1" visible="yes" active="yes"/>
<layer number="20" name="Dimension" color="15" fill="1" visible="yes" active="yes"/>
<layer number="21" name="tPlace" color="7" fill="1" visible="yes" active="yes"/>
<layer number="22" name="bPlace" color="7" fill="1" visible="yes" active="yes"/>
<layer number="25" name="tNames" color="7" fill="1" visible="yes" active="yes"/>
<layer number="26" name="bNames" color="7" fill="1" visible="yes" active="yes"/>
<layer number="27" name="tValues" color="7" fill="1" visible="yes" active="yes"/>
<layer number="28" name="bValues" color="7" fill="1" visible="yes" active="yes"/>
<layer number="51" name="tDocu" color="7" fill="1" visible="yes" active="yes"/>
<layer number="52" name="bDocu" color="7" fill="1" visible="yes" active="yes"/>
<layer number="91" name="Nets" color="2" fill="1" visible="yes" active="yes"/>
<layer number="92" name="Busses" color="1" fill="1" visible="yes" active="yes"/>
<layer number="93" name="Pins" color="2" fill="1" visible="yes" active="yes"/>
<layer number="94" name="Symbols" color="4" fill="1" visible="yes" active="yes"/>
<layer number="95" name="Names" color="7" fill="1" visible="yes" active="yes"/>
<layer number="96" name="Values" color="7" fill="1" visible="yes" active="yes"/>
<layer number="97" name="Info" color="7" fill="1" visible="yes" active="yes"/>
<layer number="98" name="Guide" color="6" fill="1" visible="yes" active="yes"/>
</layers>
<schematic xreflabel="%F%N/%S.%C%R" xrefpart="/%S.%C%R">
<libraries>
<library name="solar_v3">
<symbols>
<symbol name="R">
<wire x1="-5.08" y1="-2.54" x2="5.08" y2="-2.54" width="0.254" layer="94"/>
<wire x1="5.08" y1="-2.54" x2="5.08" y2="2.54" width="0.254" layer="94"/>
<wire x1="5.08" y1="2.54" x2="-5.08" y2="2.54" width="0.254" layer="94"/>
<wire x1="-5.08" y1="2.54" x2="-5.08" y2="-2.54" width="0.254" layer="94"/>
<text x="-5.08" y="3.81" size="1.778" layer="95">&gt;NAME</text>
<text x="-5.08" y="-5.54" size="1.778" layer="96">&gt;VALUE</text>
<pin name="1" x="-7.62" y="0.0" length="short" direction="pas" rot="R0"/>
<pin name="2" x="7.62" y="0.0" length="short" direction="pas" rot="R180"/>
</symbol>
<symbol name="C">
<wire x1="-5.08" y1="-2.54" x2="5.08" y2="-2.54" width="0.254" layer="94"/>
<wire x1="5.08" y1="-2.54" x2="5.08" y2="2.54" width="0.254" layer="94"/>
<wire x1="5.08" y1="2.54" x2="-5.08" y2="2.54" width="0.254" layer="94"/>
<wire x1="-5.08" y1="2.54" x2="-5.08" y2="-2.54" width="0.254" layer="94"/>
<text x="-5.08" y="3.81" size="1.778" layer="95">&gt;NAME</text>
<text x="-5.08" y="-5.54" size="1.778" layer="96">&gt;VALUE</text>
<pin name="1" x="-7.62" y="0.0" length="short" direction="pas" rot="R0"/>
<pin name="2" x="7.62" y="0.0" length="short" direction="pas" rot="R180"/>
</symbol>
<symbol name="DIODE">
<wire x1="-5.08" y1="-2.54" x2="5.08" y2="-2.54" width="0.254" layer="94"/>
<wire x1="5.08" y1="-2.54" x2="5.08" y2="2.54" width="0.254" layer="94"/>
<wire x1="5.08" y1="2.54" x2="-5.08" y2="2.54" width="0.254" layer="94"/>
<wire x1="-5.08" y1="2.54" x2="-5.08" y2="-2.54" width="0.254" layer="94"/>
<text x="-5.08" y="3.81" size="1.778" layer="95">&gt;NAME</text>
<text x="-5.08" y="-5.54" size="1.778" layer="96">&gt;VALUE</text>
<pin name="A" x="-7.62" y="0.0" length="short" direction="pas" rot="R0"/>
<pin name="K" x="7.62" y="0.0" length="short" direction="pas" rot="R180"/>
</symbol>
<symbol name="NMOS">
<wire x1="-5.08" y1="-3.81" x2="5.08" y2="-3.81" width="0.254" layer="94"/>
<wire x1="5.08" y1="-3.81" x2="5.08" y2="3.81" width="0.254" layer="94"/>
<wire x1="5.08" y1="3.81" x2="-5.08" y2="3.81" width="0.254" layer="94"/>
<wire x1="-5.08" y1="3.81" x2="-5.08" y2="-3.81" width="0.254" layer="94"/>
<text x="-5.08" y="5.08" size="1.778" layer="95">&gt;NAME</text>
<text x="-5.08" y="-6.8100000000000005" size="1.778" layer="96">&gt;VALUE</text>
<pin name="G" x="-7.62" y="1.27" length="short" direction="pas" rot="R0"/>
<pin name="D" x="7.62" y="1.27" length="short" direction="pas" rot="R180"/>
<pin name="S" x="7.62" y="-1.27" length="short" direction="pas" rot="R180"/>
</symbol>
<symbol name="BTN">
<wire x1="-5.08" y1="-2.54" x2="5.08" y2="-2.54" width="0.254" layer="94"/>
<wire x1="5.08" y1="-2.54" x2="5.08" y2="2.54" width="0.254" layer="94"/>
<wire x1="5.08" y1="2.54" x2="-5.08" y2="2.54" width="0.254" layer="94"/>
<wire x1="-5.08" y1="2.54" x2="-5.08" y2="-2.54" width="0.254" layer="94"/>
<text x="-5.08" y="3.81" size="1.778" layer="95">&gt;NAME</text>
<text x="-5.08" y="-5.54" size="1.778" layer="96">&gt;VALUE</text>
<pin name="1" x="-7.62" y="0.0" length="short" direction="pas" rot="R0"/>
<pin name="2" x="7.62" y="0.0" length="short" direction="pas" rot="R180"/>
</symbol>
<symbol name="FUSE">
<wire x1="-5.08" y1="-2.54" x2="5.08" y2="-2.54" width="0.254" layer="94"/>
<wire x1="5.08" y1="-2.54" x2="5.08" y2="2.54" width="0.254" layer="94"/>
<wire x1="5.08" y1="2.54" x2="-5.08" y2="2.54" width="0.254" layer="94"/>
<wire x1="-5.08" y1="2.54" x2="-5.08" y2="-2.54" width="0.254" layer="94"/>
<text x="-5.08" y="3.81" size="1.778" layer="95">&gt;NAME</text>
<text x="-5.08" y="-5.54" size="1.778" layer="96">&gt;VALUE</text>
<pin name="1" x="-7.62" y="0.0" length="short" direction="pas" rot="R0"/>
<pin name="2" x="7.62" y="0.0" length="short" direction="pas" rot="R180"/>
</symbol>
<symbol name="BATT">
<wire x1="-5.08" y1="-2.54" x2="5.08" y2="-2.54" width="0.254" layer="94"/>
<wire x1="5.08" y1="-2.54" x2="5.08" y2="2.54" width="0.254" layer="94"/>
<wire x1="5.08" y1="2.54" x2="-5.08" y2="2.54" width="0.254" layer="94"/>
<wire x1="-5.08" y1="2.54" x2="-5.08" y2="-2.54" width="0.254" layer="94"/>
<text x="-5.08" y="3.81" size="1.778" layer="95">&gt;NAME</text>
<text x="-5.08" y="-5.54" size="1.778" layer="96">&gt;VALUE</text>
<pin name="NEG" x="-7.62" y="0.0" length="short" direction="pas" rot="R0"/>
<pin name="POS" x="7.62" y="0.0" length="short" direction="pas" rot="R180"/>
</symbol>
<symbol name="PANEL">
<wire x1="-5.08" y1="-2.54" x2="5.08" y2="-2.54" width="0.254" layer="94"/>
<wire x1="5.08" y1="-2.54" x2="5.08" y2="2.54" width="0.254" layer="94"/>
<wire x1="5.08" y1="2.54" x2="-5.08" y2="2.54" width="0.254" layer="94"/>
<wire x1="-5.08" y1="2.54" x2="-5.08" y2="-2.54" width="0.254" layer="94"/>
<text x="-5.08" y="3.81" size="1.778" layer="95">&gt;NAME</text>
<text x="-5.08" y="-5.54" size="1.778" layer="96">&gt;VALUE</text>
<pin name="NEG" x="-7.62" y="0.0" length="short" direction="pas" rot="R0"/>
<pin name="POS" x="7.62" y="0.0" length="short" direction="pas" rot="R180"/>
</symbol>
<symbol name="CHG">
<wire x1="-5.08" y1="-3.81" x2="5.08" y2="-3.81" width="0.254" layer="94"/>
<wire x1="5.08" y1="-3.81" x2="5.08" y2="3.81" width="0.254" layer="94"/>
<wire x1="5.08" y1="3.81" x2="-5.08" y2="3.81" width="0.254" layer="94"/>
<wire x1="-5.08" y1="3.81" x2="-5.08" y2="-3.81" width="0.254" layer="94"/>
<text x="-5.08" y="5.08" size="1.778" layer="95">&gt;NAME</text>
<text x="-5.08" y="-6.8100000000000005" size="1.778" layer="96">&gt;VALUE</text>
<pin name="PV_POS" x="-7.62" y="1.27" length="short" direction="pas" rot="R0"/>
<pin name="PV_NEG" x="-7.62" y="-1.27" length="short" direction="pas" rot="R0"/>
<pin name="BAT_POS" x="7.62" y="1.27" length="short" direction="pas" rot="R180"/>
<pin name="BAT_NEG" x="7.62" y="-1.27" length="short" direction="pas" rot="R180"/>
</symbol>
<symbol name="BOOST">
<wire x1="-5.08" y1="-3.81" x2="5.08" y2="-3.81" width="0.254" layer="94"/>
<wire x1="5.08" y1="-3.81" x2="5.08" y2="3.81" width="0.254" layer="94"/>
<wire x1="5.08" y1="3.81" x2="-5.08" y2="3.81" width="0.254" layer="94"/>
<wire x1="-5.08" y1="3.81" x2="-5.08" y2="-3.81" width="0.254" layer="94"/>
<text x="-5.08" y="5.08" size="1.778" layer="95">&gt;NAME</text>
<text x="-5.08" y="-6.8100000000000005" size="1.778" layer="96">&gt;VALUE</text>
<pin name="VIN_POS" x="-7.62" y="1.27" length="short" direction="pas" rot="R0"/>
<pin name="VIN_NEG" x="-7.62" y="-1.27" length="short" direction="pas" rot="R0"/>
<pin name="VOUT_POS" x="7.62" y="1.27" length="short" direction="pas" rot="R180"/>
<pin name="VOUT_NEG" x="7.62" y="-1.27" length="short" direction="pas" rot="R180"/>
</symbol>
<symbol name="ESP32">
<wire x1="-5.08" y1="-7.62" x2="5.08" y2="-7.62" width="0.254" layer="94"/>
<wire x1="5.08" y1="-7.62" x2="5.08" y2="7.62" width="0.254" layer="94"/>
<wire x1="5.08" y1="7.62" x2="-5.08" y2="7.62" width="0.254" layer="94"/>
<wire x1="-5.08" y1="7.62" x2="-5.08" y2="-7.62" width="0.254" layer="94"/>
<text x="-5.08" y="8.89" size="1.778" layer="95">&gt;NAME</text>
<text x="-5.08" y="-10.620000000000001" size="1.778" layer="96">&gt;VALUE</text>
<pin name="5V" x="-7.62" y="5.08" length="short" direction="pas" rot="R0"/>
<pin name="GND" x="-7.62" y="2.54" length="short" direction="pas" rot="R0"/>
<pin name="3V3" x="-7.62" y="0.0" length="short" direction="pas" rot="R0"/>
<pin name="GPIO1" x="7.62" y="5.08" length="short" direction="pas" rot="R180"/>
<pin name="GPIO3" x="7.62" y="2.54" length="short" direction="pas" rot="R180"/>
<pin name="GPIO6" x="7.62" y="0.0" length="short" direction="pas" rot="R180"/>
<pin name="GPIO7" x="7.62" y="-2.54" length="short" direction="pas" rot="R180"/>
<pin name="GPIO10" x="7.62" y="-5.08" length="short" direction="pas" rot="R180"/>
</symbol>
<symbol name="RELAY">
<wire x1="-5.08" y1="-6.35" x2="5.08" y2="-6.35" width="0.254" layer="94"/>
<wire x1="5.08" y1="-6.35" x2="5.08" y2="6.35" width="0.254" layer="94"/>
<wire x1="5.08" y1="6.35" x2="-5.08" y2="6.35" width="0.254" layer="94"/>
<wire x1="-5.08" y1="6.35" x2="-5.08" y2="-6.35" width="0.254" layer="94"/>
<text x="-5.08" y="7.619999999999999" size="1.778" layer="95">&gt;NAME</text>
<text x="-5.08" y="-9.35" size="1.778" layer="96">&gt;VALUE</text>
<pin name="SET_A" x="-7.62" y="3.81" length="short" direction="pas" rot="R0"/>
<pin name="SET_B" x="-7.62" y="1.27" length="short" direction="pas" rot="R0"/>
<pin name="RESET_A" x="-7.62" y="-1.27" length="short" direction="pas" rot="R0"/>
<pin name="RESET_B" x="-7.62" y="-3.81" length="short" direction="pas" rot="R0"/>
<pin name="COM" x="7.62" y="3.81" length="short" direction="pas" rot="R180"/>
<pin name="NO" x="7.62" y="1.27" length="short" direction="pas" rot="R180"/>
</symbol>
<symbol name="TERM2">
<wire x1="-5.08" y1="-2.54" x2="5.08" y2="-2.54" width="0.254" layer="94"/>
<wire x1="5.08" y1="-2.54" x2="5.08" y2="2.54" width="0.254" layer="94"/>
<wire x1="5.08" y1="2.54" x2="-5.08" y2="2.54" width="0.254" layer="94"/>
<wire x1="-5.08" y1="2.54" x2="-5.08" y2="-2.54" width="0.254" layer="94"/>
<text x="-5.08" y="3.81" size="1.778" layer="95">&gt;NAME</text>
<text x="-5.08" y="-5.54" size="1.778" layer="96">&gt;VALUE</text>
<pin name="1" x="-7.62" y="0.0" length="short" direction="pas" rot="R0"/>
<pin name="2" x="7.62" y="0.0" length="short" direction="pas" rot="R180"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="R" prefix="R" uservalue="yes">
<gates><gate name="G$1" symbol="R" x="0" y="0"/></gates>
<devices><device name=""/></devices>
</deviceset>
<deviceset name="C" prefix="C" uservalue="yes">
<gates><gate name="G$1" symbol="C" x="0" y="0"/></gates>
<devices><device name=""/></devices>
</deviceset>
<deviceset name="DIODE" prefix="D" uservalue="yes">
<gates><gate name="G$1" symbol="DIODE" x="0" y="0"/></gates>
<devices><device name=""/></devices>
</deviceset>
<deviceset name="NMOS" prefix="Q" uservalue="yes">
<gates><gate name="G$1" symbol="NMOS" x="0" y="0"/></gates>
<devices><device name=""/></devices>
</deviceset>
<deviceset name="BTN" prefix="SW" uservalue="yes">
<gates><gate name="G$1" symbol="BTN" x="0" y="0"/></gates>
<devices><device name=""/></devices>
</deviceset>
<deviceset name="FUSE" prefix="F" uservalue="yes">
<gates><gate name="G$1" symbol="FUSE" x="0" y="0"/></gates>
<devices><device name=""/></devices>
</deviceset>
<deviceset name="BATT" prefix="BT" uservalue="yes">
<gates><gate name="G$1" symbol="BATT" x="0" y="0"/></gates>
<devices><device name=""/></devices>
</deviceset>
<deviceset name="PANEL" prefix="PV" uservalue="yes">
<gates><gate name="G$1" symbol="PANEL" x="0" y="0"/></gates>
<devices><device name=""/></devices>
</deviceset>
<deviceset name="CHG" prefix="U" uservalue="yes">
<gates><gate name="G$1" symbol="CHG" x="0" y="0"/></gates>
<devices><device name=""/></devices>
</deviceset>
<deviceset name="BOOST" prefix="U" uservalue="yes">
<gates><gate name="G$1" symbol="BOOST" x="0" y="0"/></gates>
<devices><device name=""/></devices>
</deviceset>
<deviceset name="ESP32" prefix="U" uservalue="yes">
<gates><gate name="G$1" symbol="ESP32" x="0" y="0"/></gates>
<devices><device name=""/></devices>
</deviceset>
<deviceset name="RELAY" prefix="K" uservalue="yes">
<gates><gate name="G$1" symbol="RELAY" x="0" y="0"/></gates>
<devices><device name=""/></devices>
</deviceset>
<deviceset name="TERM2" prefix="J" uservalue="yes">
<gates><gate name="G$1" symbol="TERM2" x="0" y="0"/></gates>
<devices><device name=""/></devices>
</deviceset>
</devicesets>
</library>
</libraries>
<attributes/>
<variantdefs/>
<classes><class number="0" name="default" width="0" drill="0"/></classes>
<parts>
<part name="PV1" library="solar_v3" deviceset="PANEL" device="" value="Panneau 6V 1W"/>
<part name="U1" library="solar_v3" deviceset="CHG" device="" value="Chargeur solaire Li-ion 1S (CN3791 6V ?)"/>
<part name="BT1" library="solar_v3" deviceset="BATT" device="" value="Li-ion 18650 1S protegee"/>
<part name="F1" library="solar_v3" deviceset="FUSE" device="" value="PTC 750mA (a calculer)"/>
<part name="C1" library="solar_v3" deviceset="C" device="" value="470uF (VBAT)"/>
<part name="R5" library="solar_v3" deviceset="R" device="" value="1M"/>
<part name="R6" library="solar_v3" deviceset="R" device="" value="1M"/>
<part name="C3" library="solar_v3" deviceset="C" device="" value="100nF (ADC)"/>
<part name="U2" library="solar_v3" deviceset="ESP32" device="" value="ESP32-C3 Mini"/>
<part name="C2" library="solar_v3" deviceset="C" device="" value="100nF (3V3)"/>
<part name="R9" library="solar_v3" deviceset="R" device="" value="100k (rappel)"/>
<part name="C4" library="solar_v3" deviceset="C" device="" value="100nF (anti-rebond)"/>
<part name="SW1" library="solar_v3" deviceset="BTN" device="" value="Bouton reveil"/>
<part name="U3" library="solar_v3" deviceset="BOOST" device="" value="Elevateur Li-ion -&gt; 5V"/>
<part name="Q3" library="solar_v3" deviceset="NMOS" device="" value="AO3400A (coupe GND elevateur)"/>
<part name="R7" library="solar_v3" deviceset="R" device="" value="1k"/>
<part name="R8" library="solar_v3" deviceset="R" device="" value="100k"/>
<part name="C5" library="solar_v3" deviceset="C" device="" value="100uF (+5V)"/>
<part name="K1" library="solar_v3" deviceset="RELAY" device="" value="Hongfa HFE20 2 bobines 5V"/>
<part name="Q1" library="solar_v3" deviceset="NMOS" device="" value="AO3400A (SET)"/>
<part name="Q2" library="solar_v3" deviceset="NMOS" device="" value="AO3400A (RESET)"/>
<part name="D1" library="solar_v3" deviceset="DIODE" device="" value="SS14"/>
<part name="D2" library="solar_v3" deviceset="DIODE" device="" value="SS14"/>
<part name="R1" library="solar_v3" deviceset="R" device="" value="1k"/>
<part name="R2" library="solar_v3" deviceset="R" device="" value="1k"/>
<part name="R3" library="solar_v3" deviceset="R" device="" value="100k"/>
<part name="R4" library="solar_v3" deviceset="R" device="" value="100k"/>
<part name="J1" library="solar_v3" deviceset="TERM2" device="" value="Charge SECTEUR (L entree/sortie)"/>
</parts>
<sheets>
<sheet>
<description language="fr">Solar Scheduler v3 - batterie + relais bistable (non teste dans Fusion)</description>
<plain>
<text x="25.4" y="-30" size="2.54" layer="97">ATTENTION: partie SECTEUR (J1, K1) - isolation, fusible, boitier a valider par un professionnel</text>
<text x="25.4" y="-35" size="2.54" layer="97">Brochages relais et modules generiques: a corriger sur fiche constructeur</text>
</plain>
<instances>
<instance part="PV1" gate="G$1" x="25.4" y="190.5"/>
<instance part="U1" gate="G$1" x="76.2" y="190.5"/>
<instance part="BT1" gate="G$1" x="127.0" y="190.5"/>
<instance part="F1" gate="G$1" x="177.8" y="190.5"/>
<instance part="C1" gate="G$1" x="228.6" y="190.5"/>
<instance part="R5" gate="G$1" x="279.4" y="190.5"/>
<instance part="R6" gate="G$1" x="330.2" y="190.5"/>
<instance part="C3" gate="G$1" x="381.0" y="190.5"/>
<instance part="U2" gate="G$1" x="76.2" y="127.0"/>
<instance part="C2" gate="G$1" x="127.0" y="139.7"/>
<instance part="R9" gate="G$1" x="177.8" y="139.7"/>
<instance part="C4" gate="G$1" x="228.6" y="139.7"/>
<instance part="SW1" gate="G$1" x="279.4" y="139.7"/>
<instance part="U3" gate="G$1" x="76.2" y="76.2"/>
<instance part="Q3" gate="G$1" x="127.0" y="76.2"/>
<instance part="R7" gate="G$1" x="177.8" y="76.2"/>
<instance part="R8" gate="G$1" x="228.6" y="76.2"/>
<instance part="C5" gate="G$1" x="279.4" y="76.2"/>
<instance part="K1" gate="G$1" x="76.2" y="12.7"/>
<instance part="Q1" gate="G$1" x="127.0" y="12.7"/>
<instance part="Q2" gate="G$1" x="177.8" y="12.7"/>
<instance part="D1" gate="G$1" x="228.6" y="12.7"/>
<instance part="D2" gate="G$1" x="279.4" y="12.7"/>
<instance part="R1" gate="G$1" x="330.2" y="12.7"/>
<instance part="R2" gate="G$1" x="381.0" y="12.7"/>
<instance part="R3" gate="G$1" x="330.2" y="-12.7"/>
<instance part="R4" gate="G$1" x="381.0" y="-12.7"/>
<instance part="J1" gate="G$1" x="25.4" y="12.7"/>
</instances>
<busses/>
<nets>
<net name="GND" class="0">
<segment>
<pinref part="PV1" gate="G$1" pin="NEG"/>
<wire x1="17.78" y1="190.5" x2="12.7" y2="190.5" width="0.1524" layer="91"/>
<label x="12.7" y="190.5" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
<segment>
<pinref part="U1" gate="G$1" pin="PV_NEG"/>
<wire x1="68.58" y1="189.23" x2="63.5" y2="189.23" width="0.1524" layer="91"/>
<label x="63.5" y="189.23" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
<segment>
<pinref part="U1" gate="G$1" pin="BAT_NEG"/>
<wire x1="83.82" y1="189.23" x2="88.9" y2="189.23" width="0.1524" layer="91"/>
<label x="88.9" y="189.23" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="BT1" gate="G$1" pin="NEG"/>
<wire x1="119.38" y1="190.5" x2="114.3" y2="190.5" width="0.1524" layer="91"/>
<label x="114.3" y="190.5" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
<segment>
<pinref part="U2" gate="G$1" pin="GND"/>
<wire x1="68.58" y1="129.54" x2="63.5" y2="129.54" width="0.1524" layer="91"/>
<label x="63.5" y="129.54" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
<segment>
<pinref part="C1" gate="G$1" pin="2"/>
<wire x1="236.22" y1="190.5" x2="241.3" y2="190.5" width="0.1524" layer="91"/>
<label x="241.3" y="190.5" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="R6" gate="G$1" pin="2"/>
<wire x1="337.82" y1="190.5" x2="342.9" y2="190.5" width="0.1524" layer="91"/>
<label x="342.9" y="190.5" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="C3" gate="G$1" pin="2"/>
<wire x1="388.62" y1="190.5" x2="393.7" y2="190.5" width="0.1524" layer="91"/>
<label x="393.7" y="190.5" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="C2" gate="G$1" pin="2"/>
<wire x1="134.62" y1="139.7" x2="139.7" y2="139.7" width="0.1524" layer="91"/>
<label x="139.7" y="139.7" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="C4" gate="G$1" pin="2"/>
<wire x1="236.22" y1="139.7" x2="241.3" y2="139.7" width="0.1524" layer="91"/>
<label x="241.3" y="139.7" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="SW1" gate="G$1" pin="2"/>
<wire x1="287.02" y1="139.7" x2="292.1" y2="139.7" width="0.1524" layer="91"/>
<label x="292.1" y="139.7" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="Q3" gate="G$1" pin="S"/>
<wire x1="134.62" y1="74.93" x2="139.7" y2="74.93" width="0.1524" layer="91"/>
<label x="139.7" y="74.93" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="R8" gate="G$1" pin="2"/>
<wire x1="236.22" y1="76.2" x2="241.3" y2="76.2" width="0.1524" layer="91"/>
<label x="241.3" y="76.2" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="Q1" gate="G$1" pin="S"/>
<wire x1="134.62" y1="11.43" x2="139.7" y2="11.43" width="0.1524" layer="91"/>
<label x="139.7" y="11.43" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="Q2" gate="G$1" pin="S"/>
<wire x1="185.42" y1="11.43" x2="190.5" y2="11.43" width="0.1524" layer="91"/>
<label x="190.5" y="11.43" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="R3" gate="G$1" pin="2"/>
<wire x1="337.82" y1="-12.7" x2="342.9" y2="-12.7" width="0.1524" layer="91"/>
<label x="342.9" y="-12.7" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="R4" gate="G$1" pin="2"/>
<wire x1="388.62" y1="-12.7" x2="393.7" y2="-12.7" width="0.1524" layer="91"/>
<label x="393.7" y="-12.7" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="C5" gate="G$1" pin="2"/>
<wire x1="287.02" y1="76.2" x2="292.1" y2="76.2" width="0.1524" layer="91"/>
<label x="292.1" y="76.2" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
</net>
<net name="PV_POS" class="0">
<segment>
<pinref part="PV1" gate="G$1" pin="POS"/>
<wire x1="33.02" y1="190.5" x2="38.1" y2="190.5" width="0.1524" layer="91"/>
<label x="38.1" y="190.5" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="U1" gate="G$1" pin="PV_POS"/>
<wire x1="68.58" y1="191.77" x2="63.5" y2="191.77" width="0.1524" layer="91"/>
<label x="63.5" y="191.77" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
</net>
<net name="BAT_POS" class="0">
<segment>
<pinref part="U1" gate="G$1" pin="BAT_POS"/>
<wire x1="83.82" y1="191.77" x2="88.9" y2="191.77" width="0.1524" layer="91"/>
<label x="88.9" y="191.77" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="BT1" gate="G$1" pin="POS"/>
<wire x1="134.62" y1="190.5" x2="139.7" y2="190.5" width="0.1524" layer="91"/>
<label x="139.7" y="190.5" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="F1" gate="G$1" pin="1"/>
<wire x1="170.18" y1="190.5" x2="165.1" y2="190.5" width="0.1524" layer="91"/>
<label x="165.1" y="190.5" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
</net>
<net name="VBAT" class="0">
<segment>
<pinref part="F1" gate="G$1" pin="2"/>
<wire x1="185.42" y1="190.5" x2="190.5" y2="190.5" width="0.1524" layer="91"/>
<label x="190.5" y="190.5" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="C1" gate="G$1" pin="1"/>
<wire x1="220.98" y1="190.5" x2="215.9" y2="190.5" width="0.1524" layer="91"/>
<label x="215.9" y="190.5" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
<segment>
<pinref part="U2" gate="G$1" pin="5V"/>
<wire x1="68.58" y1="132.08" x2="63.5" y2="132.08" width="0.1524" layer="91"/>
<label x="63.5" y="132.08" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
<segment>
<pinref part="U3" gate="G$1" pin="VIN_POS"/>
<wire x1="68.58" y1="77.47" x2="63.5" y2="77.47" width="0.1524" layer="91"/>
<label x="63.5" y="77.47" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
<segment>
<pinref part="R5" gate="G$1" pin="1"/>
<wire x1="271.78" y1="190.5" x2="266.7" y2="190.5" width="0.1524" layer="91"/>
<label x="266.7" y="190.5" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
</net>
<net name="ADC_BAT" class="0">
<segment>
<pinref part="R5" gate="G$1" pin="2"/>
<wire x1="287.02" y1="190.5" x2="292.1" y2="190.5" width="0.1524" layer="91"/>
<label x="292.1" y="190.5" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="R6" gate="G$1" pin="1"/>
<wire x1="322.58" y1="190.5" x2="317.5" y2="190.5" width="0.1524" layer="91"/>
<label x="317.5" y="190.5" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
<segment>
<pinref part="C3" gate="G$1" pin="1"/>
<wire x1="373.38" y1="190.5" x2="368.3" y2="190.5" width="0.1524" layer="91"/>
<label x="368.3" y="190.5" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
<segment>
<pinref part="U2" gate="G$1" pin="GPIO1"/>
<wire x1="83.82" y1="132.08" x2="88.9" y2="132.08" width="0.1524" layer="91"/>
<label x="88.9" y="132.08" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
</net>
<net name="V3V3" class="0">
<segment>
<pinref part="U2" gate="G$1" pin="3V3"/>
<wire x1="68.58" y1="127.0" x2="63.5" y2="127.0" width="0.1524" layer="91"/>
<label x="63.5" y="127.0" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
<segment>
<pinref part="C2" gate="G$1" pin="1"/>
<wire x1="119.38" y1="139.7" x2="114.3" y2="139.7" width="0.1524" layer="91"/>
<label x="114.3" y="139.7" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
<segment>
<pinref part="R9" gate="G$1" pin="1"/>
<wire x1="170.18" y1="139.7" x2="165.1" y2="139.7" width="0.1524" layer="91"/>
<label x="165.1" y="139.7" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
</net>
<net name="BTN" class="0">
<segment>
<pinref part="U2" gate="G$1" pin="GPIO3"/>
<wire x1="83.82" y1="129.54" x2="88.9" y2="129.54" width="0.1524" layer="91"/>
<label x="88.9" y="129.54" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="R9" gate="G$1" pin="2"/>
<wire x1="185.42" y1="139.7" x2="190.5" y2="139.7" width="0.1524" layer="91"/>
<label x="190.5" y="139.7" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="C4" gate="G$1" pin="1"/>
<wire x1="220.98" y1="139.7" x2="215.9" y2="139.7" width="0.1524" layer="91"/>
<label x="215.9" y="139.7" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
<segment>
<pinref part="SW1" gate="G$1" pin="1"/>
<wire x1="271.78" y1="139.7" x2="266.7" y2="139.7" width="0.1524" layer="91"/>
<label x="266.7" y="139.7" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
</net>
<net name="BOOST_GND" class="0">
<segment>
<pinref part="U3" gate="G$1" pin="VIN_NEG"/>
<wire x1="68.58" y1="74.93" x2="63.5" y2="74.93" width="0.1524" layer="91"/>
<label x="63.5" y="74.93" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
<segment>
<pinref part="U3" gate="G$1" pin="VOUT_NEG"/>
<wire x1="83.82" y1="74.93" x2="88.9" y2="74.93" width="0.1524" layer="91"/>
<label x="88.9" y="74.93" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="Q3" gate="G$1" pin="D"/>
<wire x1="134.62" y1="77.47" x2="139.7" y2="77.47" width="0.1524" layer="91"/>
<label x="139.7" y="77.47" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
</net>
<net name="EN_BOOST" class="0">
<segment>
<pinref part="U2" gate="G$1" pin="GPIO10"/>
<wire x1="83.82" y1="121.92" x2="88.9" y2="121.92" width="0.1524" layer="91"/>
<label x="88.9" y="121.92" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="R7" gate="G$1" pin="1"/>
<wire x1="170.18" y1="76.2" x2="165.1" y2="76.2" width="0.1524" layer="91"/>
<label x="165.1" y="76.2" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
</net>
<net name="EN_BOOST_G" class="0">
<segment>
<pinref part="R7" gate="G$1" pin="2"/>
<wire x1="185.42" y1="76.2" x2="190.5" y2="76.2" width="0.1524" layer="91"/>
<label x="190.5" y="76.2" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="Q3" gate="G$1" pin="G"/>
<wire x1="119.38" y1="77.47" x2="114.3" y2="77.47" width="0.1524" layer="91"/>
<label x="114.3" y="77.47" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
<segment>
<pinref part="R8" gate="G$1" pin="1"/>
<wire x1="220.98" y1="76.2" x2="215.9" y2="76.2" width="0.1524" layer="91"/>
<label x="215.9" y="76.2" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
</net>
<net name="V5" class="0">
<segment>
<pinref part="U3" gate="G$1" pin="VOUT_POS"/>
<wire x1="83.82" y1="77.47" x2="88.9" y2="77.47" width="0.1524" layer="91"/>
<label x="88.9" y="77.47" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="C5" gate="G$1" pin="1"/>
<wire x1="271.78" y1="76.2" x2="266.7" y2="76.2" width="0.1524" layer="91"/>
<label x="266.7" y="76.2" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
<segment>
<pinref part="D1" gate="G$1" pin="K"/>
<wire x1="236.22" y1="12.7" x2="241.3" y2="12.7" width="0.1524" layer="91"/>
<label x="241.3" y="12.7" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="D2" gate="G$1" pin="K"/>
<wire x1="287.02" y1="12.7" x2="292.1" y2="12.7" width="0.1524" layer="91"/>
<label x="292.1" y="12.7" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="K1" gate="G$1" pin="SET_A"/>
<wire x1="68.58" y1="16.51" x2="63.5" y2="16.51" width="0.1524" layer="91"/>
<label x="63.5" y="16.51" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
<segment>
<pinref part="K1" gate="G$1" pin="RESET_A"/>
<wire x1="68.58" y1="11.43" x2="63.5" y2="11.43" width="0.1524" layer="91"/>
<label x="63.5" y="11.43" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
</net>
<net name="SET_LOW" class="0">
<segment>
<pinref part="K1" gate="G$1" pin="SET_B"/>
<wire x1="68.58" y1="13.97" x2="63.5" y2="13.97" width="0.1524" layer="91"/>
<label x="63.5" y="13.97" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
<segment>
<pinref part="Q1" gate="G$1" pin="D"/>
<wire x1="134.62" y1="13.97" x2="139.7" y2="13.97" width="0.1524" layer="91"/>
<label x="139.7" y="13.97" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="D1" gate="G$1" pin="A"/>
<wire x1="220.98" y1="12.7" x2="215.9" y2="12.7" width="0.1524" layer="91"/>
<label x="215.9" y="12.7" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
</net>
<net name="RESET_LOW" class="0">
<segment>
<pinref part="K1" gate="G$1" pin="RESET_B"/>
<wire x1="68.58" y1="8.89" x2="63.5" y2="8.89" width="0.1524" layer="91"/>
<label x="63.5" y="8.89" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
<segment>
<pinref part="Q2" gate="G$1" pin="D"/>
<wire x1="185.42" y1="13.97" x2="190.5" y2="13.97" width="0.1524" layer="91"/>
<label x="190.5" y="13.97" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="D2" gate="G$1" pin="A"/>
<wire x1="271.78" y1="12.7" x2="266.7" y2="12.7" width="0.1524" layer="91"/>
<label x="266.7" y="12.7" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
</net>
<net name="GPIO6" class="0">
<segment>
<pinref part="U2" gate="G$1" pin="GPIO6"/>
<wire x1="83.82" y1="127.0" x2="88.9" y2="127.0" width="0.1524" layer="91"/>
<label x="88.9" y="127.0" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="R1" gate="G$1" pin="1"/>
<wire x1="322.58" y1="12.7" x2="317.5" y2="12.7" width="0.1524" layer="91"/>
<label x="317.5" y="12.7" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
</net>
<net name="GATE_SET" class="0">
<segment>
<pinref part="R1" gate="G$1" pin="2"/>
<wire x1="337.82" y1="12.7" x2="342.9" y2="12.7" width="0.1524" layer="91"/>
<label x="342.9" y="12.7" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="Q1" gate="G$1" pin="G"/>
<wire x1="119.38" y1="13.97" x2="114.3" y2="13.97" width="0.1524" layer="91"/>
<label x="114.3" y="13.97" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
<segment>
<pinref part="R3" gate="G$1" pin="1"/>
<wire x1="322.58" y1="-12.7" x2="317.5" y2="-12.7" width="0.1524" layer="91"/>
<label x="317.5" y="-12.7" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
</net>
<net name="GPIO7" class="0">
<segment>
<pinref part="U2" gate="G$1" pin="GPIO7"/>
<wire x1="83.82" y1="124.46" x2="88.9" y2="124.46" width="0.1524" layer="91"/>
<label x="88.9" y="124.46" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="R2" gate="G$1" pin="1"/>
<wire x1="373.38" y1="12.7" x2="368.3" y2="12.7" width="0.1524" layer="91"/>
<label x="368.3" y="12.7" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
</net>
<net name="GATE_RESET" class="0">
<segment>
<pinref part="R2" gate="G$1" pin="2"/>
<wire x1="388.62" y1="12.7" x2="393.7" y2="12.7" width="0.1524" layer="91"/>
<label x="393.7" y="12.7" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="Q2" gate="G$1" pin="G"/>
<wire x1="170.18" y1="13.97" x2="165.1" y2="13.97" width="0.1524" layer="91"/>
<label x="165.1" y="13.97" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
<segment>
<pinref part="R4" gate="G$1" pin="1"/>
<wire x1="373.38" y1="-12.7" x2="368.3" y2="-12.7" width="0.1524" layer="91"/>
<label x="368.3" y="-12.7" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
</net>
<net name="L_IN" class="0">
<segment>
<pinref part="J1" gate="G$1" pin="1"/>
<wire x1="17.78" y1="12.7" x2="12.7" y2="12.7" width="0.1524" layer="91"/>
<label x="12.7" y="12.7" size="1.27" layer="95" rot="R180" xref="no"/>
</segment>
<segment>
<pinref part="K1" gate="G$1" pin="COM"/>
<wire x1="83.82" y1="16.51" x2="88.9" y2="16.51" width="0.1524" layer="91"/>
<label x="88.9" y="16.51" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
</net>
<net name="L_OUT" class="0">
<segment>
<pinref part="J1" gate="G$1" pin="2"/>
<wire x1="33.02" y1="12.7" x2="38.1" y2="12.7" width="0.1524" layer="91"/>
<label x="38.1" y="12.7" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
<segment>
<pinref part="K1" gate="G$1" pin="NO"/>
<wire x1="83.82" y1="13.97" x2="88.9" y2="13.97" width="0.1524" layer="91"/>
<label x="88.9" y="13.97" size="1.27" layer="95" rot="R0" xref="no"/>
</segment>
</net>
</nets>
</sheet>
</sheets>
</schematic>
</drawing>
</eagle>
