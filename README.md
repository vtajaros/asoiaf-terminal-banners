# ArchGot

Display a random Game of Thrones house coat-of-arms and house words whenever you open a new terminal!

Like `pokescript`, this runs a lightweight, pre-rendered script in your `~/.bashrc` to show high-quality ANSI block art without any runtime processing or image dependencies.

## Installation

You can install it directly by running:

```bash
./install.sh
```

This will:
1. Generate the banners if they aren't generated yet (requires `chafa` and `jq`).
2. Copy the pre-rendered `.txt` files and the dispatcher script to `~/.local/share/got-banners/`.
3. Add a line to your `~/.bashrc` so a random banner shows up on new interactive shell sessions.

Open a new terminal tab to see it in action!

## Included Houses

ArchGot includes 74 canon and extended houses from the world of Ice and Fire:

<details>
<summary>View all 74 houses</summary>

Allyrion, Appleton, Arryn, Ashford, Baelish, Ball, Bar Emmon, Baratheon, Beesbury, Blackmont, Blacktyde, Blackwood, Bolton, Bracken, Celtigar, Clegane, Connington, Corbray, Crakehall, Darry, Dayne, Dondarrion, Drumm, Dustin, Estermont, Farman, Farwynd, Florent, Frey, Gardener, Gargalen, Glover, Goodbrother, Grafton, Grandison, Greyjoy, Harlaw, Hightower, Hornwood, Karstark, Lannister, Mallister, Manderly, Manwoody, Marbrand, Martell, Mormont, Peake, Penrose, Plumm, Redfort, Redwyne, Reyne, Rowan, Roxton, Royce, Seaworth, Selmy, Stark, Swann, Swyft, Targaryen, Tarly, Tarth, Tully, Tyrell, Umber, Velaryon, Waynwood, Webber, Westerling, Whent, Wylde, Yronwood.

</details>

## Adding Your Own Houses

ArchGot is completely open source and modular! You can easily add new houses or edit the words of existing ones.

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

*(Note: Re-generation requires `chafa` and `jq` to be installed on your system).*

## Uninstallation

To remove ArchGot, simply delete the source line from your `~/.bashrc` and remove the local banners directory:

```bash
rm -rf ~/.local/share/got-banners
```
