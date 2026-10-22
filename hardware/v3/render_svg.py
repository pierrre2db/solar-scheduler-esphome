#!/usr/bin/env python3
"""Dessine hardware/v3/schema_v3.svg : schema lisible (symboles + fils + etiquettes de net).
Brochages des modules generiques, a verifier sur fiches. Non valide electriquement."""
import os
from xml.sax.saxutils import escape

o = []
def add(s): o.append(s)
def line(x1, y1, x2, y2, c="#222", w=1.6): add(f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{c}" stroke-width="{w}"/>')
def poly(pts, c="#222", w=1.6): add(f'<polyline points="{" ".join(f"{x},{y}" for x, y in pts)}" fill="none" stroke="{c}" stroke-width="{w}"/>')
def text(x, y, s, size=11, anchor="start", c="#222", bold=False):
    add(f'<text x="{x}" y="{y}" font-size="{size}" text-anchor="{anchor}" fill="{c}"{" font-weight=\'bold\'" if bold else ""}>{escape(s)}</text>')
def dot(x, y): add(f'<circle cx="{x}" cy="{y}" r="3" fill="#222"/>')
def frame(x, y, w, h, title):
    add(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" fill="none" stroke="#aaa" stroke-dasharray="6 4"/>')
    text(x + 8, y + 16, title, 13, bold=True, c="#555")
def gnd(x, y):
    line(x, y, x, y + 8); line(x - 9, y + 8, x + 9, y + 8); line(x - 6, y + 12, x + 6, y + 12); line(x - 3, y + 16, x + 3, y + 16)
def flag(x, y, name, side="r", c="#1a5276"):
    text(x + (4 if side == "r" else -4), y + 4, name, 11, "start" if side == "r" else "end", c, True)
def box(x, y, w, h, ref, val, left=(), right=()):
    add(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" fill="#fdfdf2" stroke="#222" stroke-width="1.6"/>')
    text(x + w / 2, y - 6, f"{ref}  {val}", 11, "middle", bold=True)
    for yy, n in left: line(x - 20, yy, x, yy); text(x + 4, yy + 4, n, 9, c="#666")
    for yy, n in right: line(x + w, yy, x + w + 20, yy); text(x + w - 4, yy + 4, n, 9, "end", "#666")
def res_v(x, y, ref, val):  # y = haut, hauteur 40
    line(x, y, x, y + 8); add(f'<rect x="{x-6}" y="{y+8}" width="12" height="24" fill="white" stroke="#222" stroke-width="1.6"/>'); line(x, y + 32, x, y + 40)
    text(x + 10, y + 18, ref, 11, bold=True); text(x + 10, y + 31, val, 10, c="#444")
def res_h(x, y, ref, val):  # x = gauche, largeur 40
    line(x, y, x + 8, y); add(f'<rect x="{x+8}" y="{y-6}" width="24" height="12" fill="white" stroke="#222" stroke-width="1.6"/>'); line(x + 32, y, x + 40, y)
    text(x + 4, y - 10, f"{ref} {val}", 10)
def cap_v(x, y, ref, val, side="r"):  # haut y, hauteur 30
    line(x, y, x, y + 12); line(x - 10, y + 12, x + 10, y + 12); line(x - 10, y + 18, x + 10, y + 18); line(x, y + 18, x, y + 30)
    tx, an = (x + 14, "start") if side == "r" else (x - 14, "end")
    text(tx, y + 14, ref, 11, an, bold=True); text(tx, y + 27, val, 10, an, "#444")
def diode_v(x, y, ref, val):  # cathode en haut, hauteur 30
    line(x, y, x, y + 8); add(f'<polygon points="{x-8},{y+22} {x+8},{y+22} {x},{y+8}" fill="white" stroke="#222" stroke-width="1.6"/>'); line(x - 8, y + 8, x + 8, y + 8); line(x, y + 22, x, y + 30)
    text(x + 14, y + 16, ref, 11, bold=True); text(x + 14, y + 29, val, 10, c="#444")
def nmos(x, y, ref, val):  # drain en (x, y), source en (x, y+60), gate en (x-30, y+30)
    line(x, y, x, y + 14); line(x, y + 14, x - 10, y + 14); line(x - 10, y + 6, x - 10, y + 54); line(x - 10, y + 46, x, y + 46); line(x, y + 46, x, y + 60)
    line(x - 10, y + 30, x, y + 30); line(x, y + 30, x, y + 46); line(x - 16, y + 6, x - 16, y + 54); line(x - 30, y + 30, x - 16, y + 30)
    text(x + 12, y + 28, ref, 11, bold=True); text(x + 12, y + 41, val, 10, c="#444")

W, H = 1500, 820
add(f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}" font-family="monospace">')
add('<rect width="100%" height="100%" fill="white"/>')
text(30, 28, "Solar Scheduler v3 - batterie + relais bistable (brochages generiques, NON valide)", 17, bold=True)

# ---------- A. ALIMENTATION ----------
frame(20, 45, 740, 295, "A. ALIMENTATION (panneau solaire + Li-ion 1S)")
box(50, 135, 100, 60, "PV1", "Panneau 6V 1W", right=[(150, "+"), (185, "-")])
box(230, 115, 140, 100, "U1", "Chargeur solaire", left=[(150, "PV+"), (185, "PV-")], right=[(150, "BAT+"), (185, "BAT-")])
text(240, 232, "Li-ion 1S, coupure <0 C (a verifier)", 9, c="#c0392b")
box(450, 125, 100, 80, "BT1", "Li-ion 18650 1S", left=[(150, "+"), (185, "-")])
poly([(170, 150), (210, 150)]); poly([(170, 185), (210, 185)])
poly([(390, 150), (430, 150)]); poly([(390, 185), (430, 185)]); gnd(410, 185); dot(410, 185)
dot(410, 150); poly([(410, 150), (410, 85), (500, 85)])
add('<rect x="500" y="75" width="60" height="20" fill="white" stroke="#222" stroke-width="1.6"/>'); text(530, 71, "F1 PTC 750mA", 10, "middle", bold=True)
poly([(560, 85), (740, 85)]); text(745, 80, "VBAT", 12, c="#d35400", bold=True)
dot(190, 185); gnd(190, 185)
# C1 sur VBAT
dot(570, 85); poly([(570, 85), (570, 120)]); cap_v(570, 120, "C1", "470uF"); line(570, 150, 570, 158); gnd(570, 158)
# diviseur
dot(660, 85); poly([(660, 85), (660, 110)]); res_v(660, 110, "R5", "1M"); dot(660, 160); poly([(660, 150), (660, 160)])
poly([(660, 160), (660, 175)]); res_v(660, 175, "R6", "1M"); line(660, 215, 660, 225); gnd(660, 225)
poly([(660, 162), (700, 162)]); flag(702, 162, "ADC_BAT"); dot(660, 162); poly([(660, 162), (640, 162)]); dot(640, 162); line(640, 162, 640, 180); cap_v(640, 180, "C3", "100nF", "l"); line(640, 210, 640, 225); gnd(640, 225)
text(40, 320, "Pic Wi-Fi sur C1. Mesure batterie par diviseur 2x1M (~2 uA).", 10, c="#555")

# ---------- B. MCU ----------
frame(780, 45, 700, 295, "B. MICROCONTROLEUR (carte ESP32-C3 Mini)")
box(910, 90, 150, 200, "U2", "ESP32-C3 Mini", left=[(125, "5V"), (165, "GND"), (205, "3V3")], right=[(125, "GPIO1"), (160, "GPIO3"), (195, "GPIO6"), (230, "GPIO7"), (265, "GPIO10")])
flag(886, 125, "VBAT", "l", "#d35400"); gnd(890, 165); flag(886, 205, "V3V3", "l", "#2471a3")
flag(1084, 125, "ADC_BAT"); flag(1084, 195, "GPIO6"); flag(1084, 230, "GPIO7"); flag(1084, 265, "EN_BOOST")
poly([(1080, 160), (1160, 160)]); dot(1130, 160)
poly([(1130, 160), (1130, 120)]); res_v(1130, 80, "R9", "100k") if False else None
res_v(1130, 80, "R9", "100k"); flag(1118, 72, "V3V3", "l", "#2471a3")
dot(1180, 160);  line(1180, 160, 1180, 185); cap_v(1180, 185, "C4", "100nF"); line(1180, 215, 1180, 225); gnd(1180, 225)
poly([(1220, 160), (1260, 160)]); line(1260, 160, 1260, 190); add('<circle cx="1260" cy="192" r="3" fill="white" stroke="#222"/>'); line(1252, 200, 1268, 186); add('<circle cx="1260" cy="208" r="3" fill="white" stroke="#222"/>'); line(1260, 211, 1260, 225); gnd(1260, 225)
text(1274, 195, "SW1 reveil", 11, bold=True); text(1274, 210, "(GPIO3 -> GND)", 10, c="#444")
text(1180, 150, "BTN", 10, "middle", "#2471a3")
text(800, 320, "GPIO6/7: impulsions SET/RESET. GPIO10: coupe/allume l'elevateur 5V. GPIO3: reveil (GPIO0-5 seulement).", 10, c="#555")

# ---------- C. ELEVATEUR ----------
frame(20, 360, 740, 310, "C. ELEVATEUR 5V (allume seulement pendant les impulsions)")
box(110, 405, 150, 100, "U3", "Elevateur Li-ion>5V", left=[(440, "VIN+"), (485, "VIN-")], right=[(440, "VOUT+"), (485, "VOUT-")])
flag(86, 440, "VBAT", "l", "#d35400")
poly([(280, 440), (400, 440)]); dot(340, 440); flag(404, 440, "V5", "r", "#c0392b")
line(340, 440, 340, 465); cap_v(340, 465, "C5", "100uF"); line(340, 495, 340, 505); gnd(340, 505)
poly([(90, 485), (60, 485), (60, 555)]); poly([(280, 485), (310, 485), (310, 555)]); poly([(60, 555), (310, 555)]); dot(185, 555); line(185, 555, 185, 570)
text(62, 575, "BOOST_GND", 9, c="#555")
nmos(185, 570, "Q3", "AO3400A"); line(185, 630, 185, 640) if False else None; gnd(185, 630)
flag(30, 600, "EN_BOOST", "r") if False else None
text(30, 604, "EN_BOOST", 11, c="#1a5276", bold=True); res_h(95, 600, "R7", "1k"); poly([(135, 600), (155, 600)]); dot(145, 600); line(145, 600, 145, 620); res_v(145, 620, "R8", "100k") if False else None
text(250, 650, "", 8)
text(30, 640, "R8 100k : gate -> GND", 10, c="#444"); dot(145, 600); line(145, 600, 145, 612); gnd(145, 612)
poly([(155, 600), (155, 600)])
text(30, 660, "Q3 coupe la masse de l'elevateur : pas de broche EN requise.", 10, c="#555")

# ---------- D. RELAIS ----------
frame(780, 360, 700, 440, "D. PILOTAGE DU RELAIS BISTABLE (2 bobines)")
def chan(ox, name, gpio, low):
    flag(ox - 4, 400, "V5", "l", "#c0392b"); poly([(ox, 400), (ox, 425)]); diode_v(ox, 425, "D1" if name == "SET" else "D2", "SS14")
    poly([(ox, 455), (ox, 485)]); dot(ox, 485); poly([(ox, 485), (ox + 50, 485)]); flag(ox + 52, 485, low, "r")
    poly([(ox, 485), (ox, 520)]); nmos(ox, 520, "Q1" if name == "SET" else "Q2", "AO3400A"); gnd(ox, 580)
    poly([(ox - 30, 550), (ox - 70, 550)]); dot(ox - 70, 550); line(ox - 70, 550, ox - 70, 575); res_v(ox - 70, 575, "R3" if name == "SET" else "R4", "100k")
    gnd(ox - 70, 615) if False else None; line(ox - 70, 615, ox - 70, 622); gnd(ox - 70, 622)
    flag(ox - 190, 550, gpio, "r"); res_h(ox - 150, 550, "R1" if name == "SET" else "R2", "1k"); poly([(ox - 110, 550), (ox - 70, 550)])
    text(ox - 190, 520, f"Impulsion {name}", 11, c="#555", bold=True)
chan(1010, "SET", "GPIO6", "SET_LOW")
chan(1330, "RESET", "GPIO7", "RESET_LOW")
box(880, 690, 170, 90, "K1", "HFE20 bistable 2 bobines 5V", left=[(720, "COM"), (755, "NO")], right=[(705, "SET_A"), (725, "SET_B"), (750, "RESET_A"), (770, "RESET_B")])
flag(860, 720, "L_IN", "l", "#8e44ad"); flag(860, 755, "L_OUT", "l", "#8e44ad")
flag(1074, 705, "V5", "r", "#c0392b"); flag(1074, 725, "SET_LOW", "r"); flag(1074, 750, "V5", "r", "#c0392b"); flag(1074, 770, "RESET_LOW", "r")
box(1240, 700, 110, 70, "J1", "Bornier charge", left=[(725, "1"), (755, "2")])
flag(1216, 725, "L_IN", "l", "#8e44ad"); flag(1216, 755, "L_OUT", "l", "#8e44ad")
text(800, 800, "Polarite des bobines A/B: hypothese. Diodes D1/D2 en roue libre sur chaque bobine (cathode cote +5V).", 10, c="#555")
text(1240, 672, "SECTEUR", 12, c="#8e44ad", bold=True)
add('</svg>')
out = os.path.join(os.path.dirname(os.path.abspath(__file__)), "schema_v3.svg")
open(out, "w", encoding="utf-8").write("\n".join(o))
print("OK", out)
