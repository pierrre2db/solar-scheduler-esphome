#!/usr/bin/env python3
"""Genere hardware/v3/solar_scheduler_v3.sch (format EAGLE XML, importable dans
Fusion Electronics) et hardware/v3/netlist.txt a partir de la description ci-dessous.

Symboles generiques (boites). Le SCHEMA N'A PAS ETE OUVERT DANS FUSION : verifier.
Brochages du relais et des modules : valeurs generiques, a corriger sur fiche.
"""
import os
from xml.sax.saxutils import escape

HERE = os.path.dirname(os.path.abspath(__file__))
LIB = "solar_v3"
STEP = 2.54

# deviceset -> (prefix, gauche, droite)  (noms de broches)
DEVICES = {
    "R":     ("R", ["1"], ["2"]),
    "C":     ("C", ["1"], ["2"]),
    "DIODE": ("D", ["A"], ["K"]),
    "NMOS":  ("Q", ["G"], ["D", "S"]),
    "BTN":   ("SW", ["1"], ["2"]),
    "FUSE":  ("F", ["1"], ["2"]),
    "BATT":  ("BT", ["NEG"], ["POS"]),
    "PANEL": ("PV", ["NEG"], ["POS"]),
    "CHG":   ("U", ["PV_POS", "PV_NEG"], ["BAT_POS", "BAT_NEG"]),
    "BOOST": ("U", ["VIN_POS", "VIN_NEG"], ["VOUT_POS", "VOUT_NEG"]),
    "ESP32": ("U", ["5V", "GND", "3V3"], ["GPIO1", "GPIO3", "GPIO6", "GPIO7", "GPIO10"]),
    "RELAY": ("K", ["SET_A", "SET_B", "RESET_A", "RESET_B"], ["COM", "NO"]),
    "TERM2": ("J", ["1"], ["2"]),
}

# (ref, deviceset, valeur, x, y)  -- en mm, multiples de 2.54
PARTS = [
    ("PV1", "PANEL", "Panneau 6V 1W", 25.4, 190.5),
    ("U1", "CHG", "Chargeur solaire Li-ion 1S (CN3791 6V ?)", 76.2, 190.5),
    ("BT1", "BATT", "Li-ion 18650 1S protegee", 127.0, 190.5),
    ("F1", "FUSE", "PTC 750mA (a calculer)", 177.8, 190.5),
    ("C1", "C", "470uF (VBAT)", 228.6, 190.5),
    ("R5", "R", "1M", 279.4, 190.5),
    ("R6", "R", "1M", 330.2, 190.5),
    ("C3", "C", "100nF (ADC)", 381.0, 190.5),

    ("U2", "ESP32", "ESP32-C3 Mini", 76.2, 127.0),
    ("C2", "C", "100nF (3V3)", 127.0, 139.7),
    ("R9", "R", "100k (rappel)", 177.8, 139.7),
    ("C4", "C", "100nF (anti-rebond)", 228.6, 139.7),
    ("SW1", "BTN", "Bouton reveil", 279.4, 139.7),

    ("U3", "BOOST", "Elevateur Li-ion -> 5V", 76.2, 76.2),
    ("Q3", "NMOS", "AO3400A (coupe GND elevateur)", 127.0, 76.2),
    ("R7", "R", "1k", 177.8, 76.2),
    ("R8", "R", "100k", 228.6, 76.2),
    ("C5", "C", "100uF (+5V)", 279.4, 76.2),

    ("K1", "RELAY", "Hongfa HFE20 2 bobines 5V", 76.2, 12.7),
    ("Q1", "NMOS", "AO3400A (SET)", 127.0, 12.7),
    ("Q2", "NMOS", "AO3400A (RESET)", 177.8, 12.7),
    ("D1", "DIODE", "SS14", 228.6, 12.7),
    ("D2", "DIODE", "SS14", 279.4, 12.7),
    ("R1", "R", "1k", 330.2, 12.7),
    ("R2", "R", "1k", 381.0, 12.7),
    ("R3", "R", "100k", 330.2, -12.7),
    ("R4", "R", "100k", 381.0, -12.7),
    ("J1", "TERM2", "Charge SECTEUR (L entree/sortie)", 25.4, 12.7),
]

# net -> liste de "REF.PIN"
NETS = {
    "GND": ["PV1.NEG", "U1.PV_NEG", "U1.BAT_NEG", "BT1.NEG", "U2.GND", "C1.2", "R6.2",
            "C3.2", "C2.2", "C4.2", "SW1.2", "Q3.S", "R8.2", "Q1.S", "Q2.S", "R3.2",
            "R4.2", "C5.2"],
    "PV_POS": ["PV1.POS", "U1.PV_POS"],
    "BAT_POS": ["U1.BAT_POS", "BT1.POS", "F1.1"],
    "VBAT": ["F1.2", "C1.1", "U2.5V", "U3.VIN_POS", "R5.1"],
    "ADC_BAT": ["R5.2", "R6.1", "C3.1", "U2.GPIO1"],
    "V3V3": ["U2.3V3", "C2.1", "R9.1"],
    "BTN": ["U2.GPIO3", "R9.2", "C4.1", "SW1.1"],
    "BOOST_GND": ["U3.VIN_NEG", "U3.VOUT_NEG", "Q3.D"],
    "EN_BOOST": ["U2.GPIO10", "R7.1"],
    "EN_BOOST_G": ["R7.2", "Q3.G", "R8.1"],
    "V5": ["U3.VOUT_POS", "C5.1", "D1.K", "D2.K", "K1.SET_A", "K1.RESET_A"],
    "SET_LOW": ["K1.SET_B", "Q1.D", "D1.A"],
    "RESET_LOW": ["K1.RESET_B", "Q2.D", "D2.A"],
    "GPIO6": ["U2.GPIO6", "R1.1"],
    "GATE_SET": ["R1.2", "Q1.G", "R3.1"],
    "GPIO7": ["U2.GPIO7", "R2.1"],
    "GATE_RESET": ["R2.2", "Q2.G", "R4.1"],
    "L_IN": ["J1.1", "K1.COM"],
    "L_OUT": ["J1.2", "K1.NO"],
}


def pin_layout(dev):
    _, left, right = DEVICES[dev]
    n = max(len(left), len(right))
    ys = {}
    # pins du haut vers le bas, centres sur 0
    top = (n - 1) * STEP / 2
    pins = {}
    for i, p in enumerate(left):
        pins[p] = (-7.62, round(top - i * STEP, 2), "R0")
    for i, p in enumerate(right):
        pins[p] = (7.62, round(top - i * STEP, 2), "R180")
    half = max(top + STEP, 2.54)
    return pins, half


def symbol_xml(dev):
    pins, half = pin_layout(dev)
    w = 5.08
    out = [f'<symbol name="{dev}">']
    for (x1, y1, x2, y2) in [(-w, -half, w, -half), (w, -half, w, half),
                             (w, half, -w, half), (-w, half, -w, -half)]:
        out.append(f'<wire x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" width="0.254" layer="94"/>')
    out.append(f'<text x="{-w}" y="{half + 1.27}" size="1.778" layer="95">&gt;NAME</text>')
    out.append(f'<text x="{-w}" y="{-half - 3.0}" size="1.778" layer="96">&gt;VALUE</text>')
    for name, (x, y, rot) in pins.items():
        out.append(f'<pin name="{escape(name)}" x="{x}" y="{y}" length="short" '
                   f'direction="pas" rot="{rot}"/>')
    out.append('</symbol>')
    return "\n".join(out)


def deviceset_xml(dev):
    prefix = DEVICES[dev][0]
    return (f'<deviceset name="{dev}" prefix="{prefix}" uservalue="yes">\n'
            f'<gates><gate name="G$1" symbol="{dev}" x="0" y="0"/></gates>\n'
            f'<devices><device name=""/></devices>\n</deviceset>')


def build():
    pos = {ref: (dev, val, x, y) for ref, dev, val, x, y in PARTS}
    pin_of = {}  # "REF.PIN" -> (x, y, side)
    for ref, (dev, val, x, y) in pos.items():
        pins, _ = pin_layout(dev)
        for name, (px, py, rot) in pins.items():
            pin_of[f"{ref}.{name}"] = (round(x + px, 2), round(y + py, 2), -1 if px < 0 else 1)

    # verification
    used = {}
    for net, refs in NETS.items():
        for r in refs:
            if r not in pin_of:
                raise SystemExit(f"broche inconnue: {r} (net {net})")
            if r in used:
                raise SystemExit(f"broche {r} dans deux nets: {used[r]} et {net}")
            used[r] = net
    libres = sorted(set(pin_of) - set(used))

    lines = ['<?xml version="1.0" encoding="utf-8"?>',
             '<!DOCTYPE eagle SYSTEM "eagle.dtd">',
             '<eagle version="9.6.2">', '<drawing>',
             '<settings><setting alwaysvectorfont="no"/><setting verticaltext="up"/></settings>',
             '<grid distance="0.1" unitdist="inch" unit="inch" style="lines" multiple="1" '
             'display="no" altdistance="0.01" altunitdist="inch" altunit="inch"/>',
             '<layers>']
    for n, name, color in [(1, "Top", 4), (16, "Bottom", 1), (17, "Pads", 2), (18, "Vias", 2),
                           (20, "Dimension", 15), (21, "tPlace", 7), (22, "bPlace", 7),
                           (25, "tNames", 7), (26, "bNames", 7), (27, "tValues", 7),
                           (28, "bValues", 7), (51, "tDocu", 7), (52, "bDocu", 7),
                           (91, "Nets", 2), (92, "Busses", 1), (93, "Pins", 2),
                           (94, "Symbols", 4), (95, "Names", 7), (96, "Values", 7),
                           (97, "Info", 7), (98, "Guide", 6)]:
        lines.append(f'<layer number="{n}" name="{name}" color="{color}" fill="1" visible="yes" active="yes"/>')
    lines.append('</layers>')
    lines.append('<schematic xreflabel="%F%N/%S.%C%R" xrefpart="/%S.%C%R">')
    lines.append(f'<libraries>\n<library name="{LIB}">\n<symbols>')
    for dev in DEVICES:
        lines.append(symbol_xml(dev))
    lines.append('</symbols>\n<devicesets>')
    for dev in DEVICES:
        lines.append(deviceset_xml(dev))
    lines.append('</devicesets>\n</library>\n</libraries>')
    lines.append('<attributes/>\n<variantdefs/>\n<classes><class number="0" name="default" width="0" drill="0"/></classes>')
    lines.append('<parts>')
    for ref, dev, val, x, y in PARTS:
        lines.append(f'<part name="{ref}" library="{LIB}" deviceset="{dev}" device="" value="{escape(val)}"/>')
    lines.append('</parts>')
    lines.append('<sheets>\n<sheet>\n<description language="fr">Solar Scheduler v3 - batterie + relais bistable (non teste dans Fusion)</description>\n<plain>')
    lines.append('<text x="25.4" y="-30" size="2.54" layer="97">ATTENTION: partie SECTEUR (J1, K1) - isolation, fusible, boitier a valider par un professionnel</text>')
    lines.append('<text x="25.4" y="-35" size="2.54" layer="97">Brochages relais et modules generiques: a corriger sur fiche constructeur</text>')
    lines.append('</plain>\n<instances>')
    for ref, dev, val, x, y in PARTS:
        lines.append(f'<instance part="{ref}" gate="G$1" x="{x}" y="{y}"/>')
    lines.append('</instances>\n<busses/>\n<nets>')
    for net, refs in NETS.items():
        lines.append(f'<net name="{net}" class="0">')
        for r in refs:
            ref, pin = r.split(".", 1)
            x, y, side = pin_of[r]
            xe = round(x + side * 5.08, 2)
            lines.append('<segment>')
            lines.append(f'<pinref part="{ref}" gate="G$1" pin="{escape(pin)}"/>')
            lines.append(f'<wire x1="{x}" y1="{y}" x2="{xe}" y2="{y}" width="0.1524" layer="91"/>')
            rot = "R0" if side > 0 else "R180"
            lines.append(f'<label x="{xe}" y="{y}" size="1.27" layer="95" rot="{rot}" xref="no"/>')
            lines.append('</segment>')
        lines.append('</net>')
    lines.append('</nets>\n</sheet>\n</sheets>\n</schematic>\n</drawing>\n</eagle>')

    with open(os.path.join(HERE, "solar_scheduler_v3.sch"), "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")

    with open(os.path.join(HERE, "netlist.txt"), "w", encoding="utf-8") as f:
        f.write("# Netlist v3 (generee par generate_schematic.py)\n")
        for net, refs in NETS.items():
            f.write(f"{net}: {', '.join(refs)}\n")
        if libres:
            f.write("\n# Broches non connectees: " + ", ".join(libres) + "\n")
    return libres


if __name__ == "__main__":
    libres = build()
    print("OK. Broches libres:", libres)
