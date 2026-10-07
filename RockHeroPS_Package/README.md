# ROCK HERO — PowerShell

A Guitar-Hero-style rhythm game that runs in nothing but PowerShell 5.1 on Windows.

**One file. No samples, no downloads, no dependencies.**
Every note you hear — guitar, bass, drums, melody — is synthesised from scratch at
runtime by a C# synthesiser that is embedded in the script and compiled on the fly
with `Add-Type`.

```
rockhero.ps1          the whole game
```

## Running it

```powershell
.\rockhero.ps1
```

Needs a real console (Windows Terminal or the classic conhost), **not** a redirected
pipe. Minimum window is 72x24; 104x40 is comfortable. The game enlarges the window
itself if it can, and asks you to resize it if it cannot.

| Switch | What it does |
|---|---|
| *(none)* | play |
| `-SelfTest` | run the full 156-test suite and exit (code 0 = all passed) |
| `-ListSongs` | print the catalogue and exit |
| `-Benchmark` | render every song and report the timing |
| `-DumpWav <file> -DumpSong <n>` | synthesise song *n* to a 16-bit mono WAV |
| `-NoAudio` | silent mode (for very slow machines) |
| `-Ascii` | force the plain ASCII look, no ANSI colour or Unicode |
| `-Volume <0-100>` | start volume (default 78) |
| `-SpeedScale <0.5-2.0>` | start note speed (default 1.0) |

## Controls

| Key | Action |
|---|---|
| `1` `2` `3` `4` `5` | strike fret lane 1 to 5 |
| `A` `S` `D` `F` `G` | the same five lanes, for the left hand |
| numpad `1`-`5` | also mapped |
| `SPACE` | activate Overdrive when the ROCK meter is full |
| `ESC` | pause / go back |
| `ENTER` | confirm |
| `R` | retry, from the results screen |

Hold notes need the lane **kept pressed** for the whole tail. Let go and the combo dies.

## Scoring

| Judgement | Window | Points |
|---|---|---|
| PERFECT | ±48 ms | 300 |
| GREAT | ±90 ms | 200 |
| GOOD | ±140 ms | 100 |
| MISS | past ±170 ms | 0 |

Combo multiplier: x1 (0-9), x2 (10-24), x3 (25-49), x4 (50-99), x5 (100+).
A PERFECT struck dead on gets a small timing bonus on top.

Ranks from accuracy: S+ 97%, S 93%, A 88%, B 80%, C 70%, D below.
Stars are `floor(accuracy x 5)`.

The ROCK meter fills on hits and drains on misses. Fill it, hit `SPACE`: Overdrive
doubles every point for eight seconds. Let the meter hit zero and you rock out
(the song ends early).

## Difficulties

| | Notes | Scroll | Extra stream |
|---|---|---|---|
| Easy | 8th-note skeleton only | 0.72x | — |
| Normal | the riff exactly as written | 1.00x | — |
| Hard | riff + lead melody | 1.25x | lead |
| Expert | riff + lead + drums | 1.52x | lead + drums |

Two notes in the same lane closer than 48 ms cannot both be hit, so the chart builder
drops the later one — the riff always wins over the drum stream.

## The music

29 songs across 16 bands, credited so you know what you are hearing:

Black Sabbath (7), Led Zeppelin, Guns N' Roses, Metallica, Nirvana, AC/DC,
Deep Purple, Queen, Ozzy Osbourne, Motorhead, The Who, Lynyrd Skynyrd,
Jimi Hendrix, Rush, ZZ Top, Aerosmith.

**Every riff is an original composition written in the style of the band it is
credited to.** This is a playable tribute — not a recording, and not a transcription
of anyone else's music. Nothing here reproduces a copyrighted performance or melody.

A song is four moving parts over a chord progression:

```
Riff   16 chars per bar   0-4 = fret mapped onto chord tones, . = rest, - = let ring
Drums  16 chars per bar   K crash, k kick, s snare, h hat, H open hat, x accent
Lead   16 chars per bar   0-9 = degree in the scale
Prog   one semitone offset per riff bar
```

The chart for the player is generated from the riff: each fret becomes a lane, a
repeated fret in the same lane becomes a hold note, and on Hard/Expert the lead and
drum streams are added as extra notes.

### Synthesis

`RockHero.Synth` renders at 32 kHz mono 16-bit:

- **Guitar** — three detuned saw oscillators through a one-pole lowpass, with a
  filtered noise transient for the pick attack.
- **Bass** — saw plus a sub-square, heavily smoothed.
- **Kick** — sine with an exponential pitch drop plus noise.
- **Snare / hats / crash** — shaped white noise with one-pole filters.
- **Lead** — vibrato sine pair with a one-second slapback delay.

The mix goes through a two-pass chain: normalise to 0.55, Padé `tanh` saturation for
grit, then normalise to 0.93. Nothing clips.

A ~40 second song renders in about 350 ms — roughly 100x real time — so there is no
loading screen; the song is finished before the band screen comes up.

### Playback

`RockHero.Player` P/Invokes `winmm.dll` `waveOut` and tracks the device position,
which gives sample-accurate sync for the chart. If the device cannot be opened it
falls back to a `Stopwatch` clock and the game still plays (silently, with `-NoAudio`,
or audibly-but-unsynced if the fallback still has a usable device). A paused game
compensates for the wall-clock time spent in the pause menu.

## Where files go

High scores are stored in `%LOCALAPPDATA%\RockHeroPS\highscores.xml`, falling back to
`%TEMP%\RockHeroPS` if that is not writable. A corrupted file is silently discarded
rather than crashing the game. Everything else lives in memory.

## Self-test

`.\rockhero.ps1 -SelfTest` runs 156 checks in about 17 seconds and prints each
failure with its value:

- the C# engine compiles, every voice renders, no NaN samples, WAV header is exact
- the player clamps volume, never rewinds, tolerates a null buffer, disposes twice
- all 29 songs: 16-character bars, valid characters, parseable progression,
  matching bar counts, no duplicate titles, sane tempo and key
- all 29 songs render loud, clean and unclipped audio, each in under 6 seconds
- all 116 song/difficulty charts are non-empty, sorted, in range, and playable
- judgement windows, multipliers, accuracy, ranks and stars at every boundary
- the full rule set driven head-less: double-hits, wrong lanes, missed notes, the
  miss cursor, overdrive timing and doubling, holds completed, dropped and timed out
- the renderer at 40x12, 72x24, 104x40 and 300x100, with and without colour, with an
  empty chart
- high scores survive a save/load round trip, a corrupted file, and an unwritable path
- extreme tempos (30 and 400 BPM) and unknown difficulty names
- key mapping for letters, digits and numpad; function keys correctly ignored

Exit code is 0 when everything passes, 1 otherwise.

## Notes

- The script is assembled from `p01.ps1`-`p08.ps1` plus `RockEngine.cs` by
  `build.ps1`, which injects the C# source and parses the result before writing.
  `rockhero.ps1` is the only file you need to run the game.
- `Set-StrictMode -Version 2.0` and `$ErrorActionPreference = 'Stop'` are on, so
  anything sloppy fails loudly rather than silently.
- Nothing is written to the working directory and nothing is downloaded.
