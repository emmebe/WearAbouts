# WearAbouts Website

This folder contains a static website version of the WearAbouts app.

## What is included

- `index.html` — the website shell with navigation for Style, Destinations, and Profile.
- `styles.css` — layout and brand styling inspired by the SwiftUI app.
- `app.js` — application logic for Unsplash photo search, destination lookup, weather, local storage, and profile management.
- `config.js` — API key configuration for Unsplash.

## Setup

### Option 1: Use the same app key from your environment

If you already have `UNSPLASH_ACCESS_KEY` set for the app, run this from the repo root:

```bash
cd website
python3 generate-config.py
```

If the key is present in the environment or in `WearAbouts/Secrets.plist`, this script will write it into `website/config.js`.

### Option 2: Set the key manually

Open `website/config.js` and set:

```js
window.UNSPLASH_ACCESS_KEY = "YOUR_ACCESS_KEY_HERE";
```

If no key is provided, the website will show sample images from Picsum Photos.

## Run

### Quick Start
```bash
cd website
./run.sh
```

Or manually:
```bash
cd website
python3 -m http.server 8080
```

Then open `http://localhost:8080` in your browser.

### With API Key
If you have an Unsplash API key, set it first:

```bash
# Option 1: Set environment variable
export UNSPLASH_ACCESS_KEY="your_key_here"
cd website
python3 generate-config.py

# Option 2: Edit config.js directly
echo 'window.UNSPLASH_ACCESS_KEY = "your_key_here";' > config.js
```

### Testing
The website should load with sample fashion photos. Try searching for destinations like "Tokyo" or "Paris" to see different style inspiration.
