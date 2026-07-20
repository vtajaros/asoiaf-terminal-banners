# archgot

Display a random A Song of Ice and Fire / Game of Thrones house coat-of-arms and house words whenever you open a new terminal!

<img width="1920" height="1162" alt="image" src="https://github.com/user-attachments/assets/789c0597-cd50-466a-9442-a248a30b4f5a" />
<img width="1920" height="1159" alt="image" src="https://github.com/user-attachments/assets/1b3332ae-4f9d-4bdd-8eb0-9a10008927d3" />
<img width="1920" height="1161" alt="image" src="https://github.com/user-attachments/assets/8b3641c7-74b0-4ff0-9e56-f83c329611a0" />
<img width="1920" height="1165" alt="image" src="https://github.com/user-attachments/assets/480a259f-e478-40f1-abfc-5fbbc4c2ae7b" />



Like `pokescript`, this runs a lightweight, pre-rendered script in your `~/.bashrc` to show high-quality ANSI block art without any runtime processing or image dependencies.

## Installation

There are two ways to install archgot:

### 1. Arch Linux Native (Recommended for Arch users)

Available on the Arch User Repository as [`archgot-git`](https://aur.archlinux.org/packages/archgot-git). You can install it using an AUR helper like `yay` or `paru`:

```bash
yay -S archgot-git
# or
paru -S archgot-git
```

Or build it manually using `makepkg` directly from the repository:

```bash
git clone https://github.com/vtajaros/archgot-asoiaf-terminal-banners.git archgot
cd archgot
makepkg -si
```

Then, add this to your `~/.bashrc`:

```bash
[ -f /usr/share/archgot/archgot ] && source /usr/share/archgot/archgot
```

### 2. Local Installation (Other Linux Distros, macOS, WSL, Git Bash)

Works out-of-the-box on **Debian, Ubuntu, Fedora, Alpine, macOS (Bash/Zsh), WSL, and Git Bash for Windows**.

Clone the repository and run the installer:

```bash
git clone https://github.com/vtajaros/archgot-asoiaf-terminal-banners.git archgot
cd archgot
./install.sh
```

This script automatically generates the banners, copies them to `~/.local/share/archgot/`, installs the `archgot` command to `~/.local/bin`, and hooks into your `~/.bashrc` and `~/.zshrc`.

### 3. Native Windows PowerShell (Optional)

If you use Windows Terminal / PowerShell outside of WSL or Git Bash, modern Windows Terminal supports ANSI colors natively!

You can load a random banner in PowerShell by adding this line to your PowerShell `$PROFILE`:

```powershell
Get-Content "$HOME\.local\share\archgot\(Get-ChildItem $HOME\.local\share\archgot\*.txt | Where-Object Name -NE 'pool.txt' | Get-Random).Name"
```

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
cat /usr/share/archgot/banners/stark.txt
```

**Local Installation:**
```bash
cat ~/.local/share/archgot/stark.txt
```

### Automatic Startup (MOTD)
When installed, `archgot` automatically runs upon opening any interactive shell tab via your `~/.bashrc`.

## Included Houses

archgot includes 124 canon and extended houses from the world of Ice and Fire.
*(Note: Houses marked with an asterisk `*` do not have canon house words, so placeholder words closely relating to their house's lore have been given to them).*

<details>
<summary>View all 124 houses</summary>

Allyrion, Appleton, Arryn, Ashford, Baelish, Ball, Bar Emmon, Baratheon, Beesbury, Blackmont, Blacktyde, Blackwood, Bolton, Bracken, Brax, Brune of Brownhollow, Buckwell, Bulwer, Butterwell, Cargyll, Cassel, Celtigar, Cerwyn, Chelsted, Clegane, Codd, Connington, Corbray, Crakehall, Crane, Darklyn, Darry, Dayne, Dondarrion, Drumm, Dustin, Estermont, Farman, Farring, Farwynd, Fell, Flint of Widow's Watch, Florent, Fossoway of Cider Hall, Fossoway of New Barrel, Fowler, Frey, Gardener, Gargalen, Glover, Goodbrother, Graceford, Grafton, Grandison, Greyjoy, Harlaw, Hayford, Hightower, Hornwood, Jordayne, Karstark, Lannister, Locke, Lonmouth, Lynderly, Mallister, Manderly, Manwoody, Marbrand, Martell, Massey, Merryweather, Mooton, Mormont, Oakheart, Payne, Peake, Penrose, Piper, Plumm, Redfort, Redwyne, Reed, Reyne, Rosby, Rowan, Roxton, Royce, Ryswell, Seaworth, Selmy, Smallwood, Stark, Staunton, Stokeworth, Stonehouse, Strong, Swann, Swyft, Tallhart, Targaryen, Tarly, Tarth, Templeton, Thorne, Trant, Tully, Tyrell, Uller, Umber, Vance of Wayfarer's Rest, Velaryon, Volmark, Vyrwel, Waxley, Waynwood, Webber, Wendwater, Westerling, Whent, Whitehill, Wyl, Wylde, Yronwood.

</details>

### 🎲 Weighted Lore Probability

Not all houses appear with equal frequency! `archgot` uses a 3-tier lore-weighted selection algorithm so iconic houses appear regularly while lesser-known houses remain as fun, rare surprises:

- **Great Houses (5x Weight):** The 9 Great Houses (Stark, Targaryen, Lannister, Tyrell, Baratheon, Martell, Greyjoy, Arryn, Tully) are **5x more likely** to appear.
- **Important Houses (3x Weight):** 20 major vassal houses with prominent lore (e.g., Velaryon, Hightower, Dayne, Bolton, Tarth, Blackwood, Frey, Royce, Reed) are **3x more likely** to appear.
- **Minor Houses (1x Weight):** The remaining 95 noble houses appear at default frequency for occasional discovery.

## Adding Your Own Houses

archgot is completely open source and modular! You can easily add new houses or edit the words of existing ones.

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

Instead of rendering raw image files on-the-fly, **archgot** uses pre-rendered ANSI block art for key architectural reasons:

- **Instant Performance (<1ms):** Displays instantly via a simple `cat` execution at startup with zero CPU overhead or lag.
- **Native Background Transparency:** Standard ANSI block sequences leave background cells untouched, letting your terminal's native background, colors, or glassmorphism shine through cleanly.
- **Universal Compatibility:** Works reliably across virtually all terminal emulators, `tmux` sessions, and SSH connections without relying on fragmented graphics protocols (like Sixel or Kitty graphics).
- **Zero Runtime Dependencies:** End-users only need basic `bash` to display banners—image tools like `chafa` are only needed when generating new banners.

## Uninstallation

To remove archgot, simply delete the source line from your `~/.bashrc` and remove the local banners directory:

```bash
rm -rf ~/.local/share/archgot
```
