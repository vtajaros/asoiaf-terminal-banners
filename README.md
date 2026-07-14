# asoiaf-terminal-banners (archgot)

Display a random A Song of Ice and Fire / Game of Thrones house coat-of-arms and house words whenever you open a new terminal (powered by `archgot`)!

<img width="1920" height="1162" alt="image" src="https://github.com/user-attachments/assets/789c0597-cd50-466a-9442-a248a30b4f5a" />
<img width="1920" height="1159" alt="image" src="https://github.com/user-attachments/assets/1b3332ae-4f9d-4bdd-8eb0-9a10008927d3" />
<img width="1920" height="1161" alt="image" src="https://github.com/user-attachments/assets/8b3641c7-74b0-4ff0-9e56-f83c329611a0" />

Like `pokescript`, this runs a lightweight, pre-rendered script in your `~/.bashrc` to show high-quality ANSI block art without any runtime processing or image dependencies.

## Installation

There are two ways to install asoiaf-terminal-banners:

### 1. Arch Linux Native (Recommended for Arch users)

Available on the Arch User Repository as [`asoiaf-terminal-banners-git`](https://aur.archlinux.org/packages/asoiaf-terminal-banners-git). You can install it using an AUR helper like `yay`:

```bash
yay -S asoiaf-terminal-banners-git
```

Or build it manually using `makepkg` directly from this repository:

```bash
makepkg -si
```

Then, add this to your `~/.bashrc`:

```bash
[ -f /usr/share/asoiaf-terminal-banners/archgot ] && source /usr/share/asoiaf-terminal-banners/archgot
```

### 2. Local Installation (For any distro or quick setup)

You can install it locally to your user profile by running:

```bash
./install.sh
```

This script will automatically generate the banners, copy them to `~/.local/share/asoiaf-terminal-banners/`, install the `archgot` command, and append the correct line to your `~/.bashrc`.

Run `archgot` in your terminal or open a new terminal tab to see it in action!

## Usage

### Display a Random Banner
Run the `archgot` command anywhere in your terminal to output a random house coat-of-arms and motto on demand:

```bash
archgot
```

### Display a Specific House Banner
You can view a specific house's banner directly by outputting its text file:

**System-wide Installation (Arch/AUR):**
```bash
cat /usr/share/asoiaf-terminal-banners/banners/stark.txt
```

**Local Installation:**
```bash
cat ~/.local/share/asoiaf-terminal-banners/stark.txt
```

### Automatic Startup (MOTD)
When installed, `archgot` automatically runs upon opening any interactive shell tab via your `~/.bashrc`.

## Included Houses

asoiaf-terminal-banners includes 93 canon and extended houses from the world of Ice and Fire.
*(Note: Houses marked with an asterisk `*` do not have canon house words, so placeholder words closely relating to their house's lore have been given to them).*

<details>
<summary>View all 93 houses</summary>

Allyrion, Appleton, Arryn, Ashford, Baelish, Ball, Bar Emmon, Baratheon, Beesbury, Blackmont, Blacktyde, Blackwood, Bolton, Bracken, Butterwell, Celtigar, Clegane, Connington, Corbray, Crakehall, Crane, Darklyn, Darry, Dayne, Dondarrion, Drumm, Dustin, Estermont, Farman, Farwynd, Fell, Florent, Frey, Gardener, Gargalen, Glover, Goodbrother, Grafton, Grandison, Greyjoy, Harlaw, Hayford, Hightower, Hornwood, Karstark, Lannister, Locke, Lynderly, Mallister, Manderly, Manwoody, Marbrand, Martell, Massey, Mormont, Peake, Penrose, Plumm, Redfort, Redwyne, Reyne, Rosby, Rowan, Roxton, Royce, Ryswell, Seaworth, Selmy, Stark, Stokeworth, Strong, Swann, Swyft, Tallhart, Targaryen, Tarly, Tarth, Templeton, Thorne, Trant, Tully, Tyrell, Umber, Vance of Wayfarer's Rest, Velaryon, Vyrwel, Waynwood, Webber, Westerling, Whent, Wyl, Wylde, Yronwood.

</details>

## Adding Your Own Houses

asoiaf-terminal-banners is completely open source and modular! You can easily add new houses or edit the words of existing ones.

1. **Add your image**: Place your house's `.webp` or `.png` coat-of-arms image inside the `banners/` directory.
   - For example: `banners/MyHouse.webp`

2. **Update the Manifest**: Open `data/houses.json` and add an entry for your new house.
   - `house`: The exact name of your house (e.g. "MyHouse")
   - `words`: The motto to display under the banner
   - `region` & `source`: For metadata purposes

   ```json
   {
     "house": "MyHouse",
     "region": "The Reach",
     "words": "Our Custom Words",
     "source": "invented"
   }
   ```

3. **Regenerate and Reinstall**: Run the installer script again to generate the ANSI text file and move it to your system directory!
   ```bash
   ./install.sh
   ```

_(Note: Re-generation requires `chafa` and `jq` to be installed on your system)._

## Why Pre-rendered ANSI?

Instead of rendering raw image files on-the-fly, **asoiaf-terminal-banners** uses pre-rendered ANSI block art for key architectural reasons:

- **Instant Performance (<1ms):** Displays instantly via a simple `cat` execution at startup with zero CPU overhead or lag.
- **Native Background Transparency:** Standard ANSI block sequences leave background cells untouched, letting your terminal's native background, colors, or glassmorphism shine through cleanly.
- **Universal Compatibility:** Works reliably across virtually all terminal emulators, `tmux` sessions, and SSH connections without relying on fragmented graphics protocols (like Sixel or Kitty graphics).
- **Zero Runtime Dependencies:** End-users only need basic `bash` to display banners—image tools like `chafa` are only needed when generating new banners.

## Uninstallation

To remove asoiaf-terminal-banners, simply delete the source line from your `~/.bashrc` and remove the local banners directory:

```bash
rm -rf ~/.local/share/asoiaf-terminal-banners
```
