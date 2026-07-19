TERMINIDLE — PRESS KIT
======================

This folder is a complete press kit in the standard presskit() format
(the layout journalists and curators expect). Everything text/art is DONE;
a short checklist below covers the few things only you can provide.

WHAT'S IN HERE
--------------
  index.html                  The press page itself — self-contained, styled,
                              ready to host (GitHub Pages, itch, anywhere).
  PRESS-KIT.md                Same content as markdown (repos, Discord, docs).
  fact-sheet.txt              Quick-copy factsheet for emails.
  press-email-template.txt    Outreach email you can adapt per recipient.
  steam-page-copy.txt         Short + long description ready for the Steam
                              store page form.
  media/
    logo.png                  Transparent-background wordmark (use on any color).
    logo-dark.png             Wordmark on black with scanlines (social headers).
    icon-512.png, icon-256.png  App/store icon (">_" terminal mark).
    keyart-1920x1080.png      Key art / capsule base / video thumbnail.
    logo-ascii.txt            The wordmark as ASCII (fun for emails/readmes).
    screenshots/
      SHOT-LIST.txt           EXACTLY which 10 screenshots to take, with the
                              in-game commands to stage each one. Drop the
                              PNGs in this folder using the listed filenames
                              and index.html picks them up automatically.
  tools/
    generate-media.ps1        Regenerates every PNG above. Tweak colors/text
                              and re-run:  powershell -File tools\generate-media.ps1

YOUR CHECKLIST (the parts I can't do for you)
---------------------------------------------
  [ ] Take the 10 screenshots per media/screenshots/SHOT-LIST.txt
      (1920x1080, no FPS counters/overlays).
  [ ] Record a 60-90s trailer. Suggested beat sheet:
        0-5s   black screen, blinking cursor, someone types 'mine'
        5-20s  numbers start moving: bots, combo, flux stream, goal bar dings
        20-40s hacks typed fast, firewall breach klaxon, rig overheats & a part
               BURNS, crypto chart spikes
        40-55s the ascension: terminal shrinks into the OS desktop; apps montage
               (snake, pong, hub chat, network map spreading)
        55-70s QUANTUM LAB: ASCEND armed -> TOTAL SYSTEM WIPE -> back to the
               bare cursor... which now mines 100x faster. Title card.
      Upload to YouTube, then paste the link where index.html and
      PRESS-KIT.md say [TRAILER-LINK].
  [ ] Fill the [TODO] fields: release date, price, website/store link,
      your location, social links, build file size.
  [ ] Confirm the press contact email (currently your gmail) or swap it.
  [ ] Host index.html — easiest: push this repo to GitHub, enable
      GitHub Pages on the /presskit folder (Settings -> Pages), done.

HOUSE RULES BAKED INTO THE KIT
------------------------------
  - No fabricated quotes, awards, or numbers — those sections say
    "none yet" until real ones exist. Never fake these; press notices.
  - Monetization permission for streamers/YouTubers is granted by default
    (industry standard, curators check for it). Edit index.html if you
    want different terms.
