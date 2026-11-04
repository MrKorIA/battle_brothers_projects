# -*- coding: utf-8 -*-
# Генератор иконок перков и бэкграундов (56x56) из иконок скиллов.
# Использует шаблоны обводки пользователя:
#   Z:/GameMods/Battle Brothers/mods/perk.png      — тонкое кольцо для иконок перков
#   Z:/GameMods/Battle Brothers/mods/background.png — тёмная подложка с золотым ободом для бэкграундов
# Исходники: gfx/ui/xx*.png. Запуск: python make_icons.py  (нужен Pillow)
from PIL import Image, ImageDraw, ImageOps

GFX = r"Z:/GameMods/Battle Brothers/mods/battle_brothers_projects/bb_vanilla_plus/gfx"
TPL_BG = Image.open(r"Z:/GameMods/Battle Brothers/mods/background.png").convert("RGBA")
TPL_PERK = Image.open(r"Z:/GameMods/Battle Brothers/mods/perk.png").convert("RGBA")

# имя иконки перка -> исходник скилла (gfx/ui/...)
jobs = {
    "perk_vp_demon":        "xx27.png",
    "perk_vp_pull":         "xx72.png",
    "perk_vp_maso":         "xxp11.png",
    "perk_vp_frenzy":       "xx73.png",
    "perk_vp_bloodletting": "xx64.png",
    "perk_vp_bloodlust":    "xx38.png",
    "perk_vp_drainblood":   "xx63.png",
    "perk_vp_counter":      "xxp15.png",
    "perk_vp_sumfiend":     "xx16.png",
}

def circle_mask(size, r):
    m = Image.new("L", (size, size), 0)
    d = ImageDraw.Draw(m)
    c = size / 2
    d.ellipse((c - r, c - r, c + r, c + r), fill=255)
    return m

def outer_radius(tpl):
    bbox = tpl.split()[-1].point(lambda a: 255 if a > 128 else 0).getbbox()
    return (bbox[2] - bbox[0]) / 2.0 - 0.5

def make(icon_path, tpl, inner_trim, is_plate):
    size = 56
    icon = Image.open(icon_path).convert("RGBA").resize((size, size), Image.LANCZOS)
    out = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    mask = circle_mask(size, outer_radius(tpl) - inner_trim)
    if is_plate:
        out.alpha_composite(tpl)      # подложка с ободом
        out.paste(icon, (0, 0), mask)
    else:
        out.paste(icon, (0, 0), mask) # иконка в круге
        out.alpha_composite(tpl)      # обод сверху
    return out

def sw_variant(img):
    r, g, b, a = img.split()
    gray = ImageOps.autocontrast(Image.merge("RGB", (r, g, b)).convert("L"), cutoff=1)
    gray = gray.point(lambda p: int(p * 0.6))
    return Image.merge("RGBA", (gray, gray, gray, a))

if __name__ == "__main__":
    for name, src in jobs.items():
        icon = make(GFX + "/ui/" + src, TPL_PERK, inner_trim=2.0, is_plate=False)
        icon.save(GFX + "/perks/" + name + ".png")
        sw_variant(icon).save(GFX + "/perks/" + name + "_sw.png")
    # иконка бэкграунда демонолога (поменяй xx73.png при смене класса)
    make(GFX + "/ui/xx73.png", TPL_BG, inner_trim=4.0, is_plate=True).save(
        GFX + "/ui/backgrounds/backgrounds_demon.png")
    print("DONE")
