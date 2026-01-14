#!/usr/bin/env bash
set -euo pipefail

# Helper instructions for producing a short demo GIF or screencast.
# This script does not attempt to auto-record (requires desktop permissions).
# Use one of the following recommended methods depending on your OS/tools.

cat <<'DOC'
Recommended recording options:

1) macOS (QuickTime -> Export -> 720p)
   - Open QuickTime Player -> File -> New Screen Recording
   - Record the demo (run scripts/start-all.sh, run curl, open consumer UI), stop
   - File -> Export As -> 720p (smaller file)
   - Convert to GIF (optional): install ffmpeg and run:
       ffmpeg -i Demo.mov -vf "fps=15,scale=800:-1:flags=lanczos" -loop 0 demo.gif

2) Terminal demo (asciinema)
   - Install asciinema (https://asciinema.org)
   - Record: asciinema rec demo.cast --command "scripts/start-all.sh"
   - Convert to GIF: asciicast2gif demo.cast demo.gif

3) Linux (ffmpeg x11grab)
   - Record (example):
       ffmpeg -video_size 1280x720 -framerate 15 -f x11grab -i :0.0+100,100 -codec:v libx264 demo.mp4
   - Convert to GIF:
       ffmpeg -i demo.mp4 -vf "fps=15,scale=800:-1:flags=lanczos" -loop 0 demo.gif

Notes:
- Keep GIFs small (under 10 MB) for GitHub README usage — trim length and reduce fps/size.
- Prefer MP4 for high-quality playback; GIF is convenient for inline README but large.
- After you record a GIF, place it under /docs/demo.gif and update the README to embed it.

DOC
