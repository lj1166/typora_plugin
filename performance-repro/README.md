# Performance reproduction evidence for issue #1279

## Environment

- Windows 10 Enterprise LTSC, 64-bit, build 19044
- Intel Core i7-12700 (12 cores / 20 logical processors), 31.75 GB RAM
- Typora 1.13.6
- Typora-Plugin 1.19.13

## Method

Each run used an isolated copy of the existing Typora installation and a separate Typora user-data directory. The live installation and its configuration were not changed. The document was opened, allowed to warm up for 20 seconds, then all Typora processes belonging to the isolated copy were sampled once per second for 20 seconds.

CPU is aggregate process CPU time delta divided by wall-clock time, expressed as a percentage of one logical core. Samples describe the idle post-load state; scrolling was not automated, so this does not establish or rule out a scrolling-only regression.

## Inputs

1. `Generate-MinimalRepro.ps1` deterministically generates `minimal-repro.md`: 6,000 lines, 138 fenced code blocks, including 3 Mermaid blocks, no images, and no external assets.
2. A local tutorial document (not included): 10,159 lines, 270 fenced code blocks, 6 Mermaid blocks, 41 table lines, and no images.

## Results

| Input | Enabled optional plugins | Average CPU (one core = 100%) | Peak CPU | Average working set |
| --- | --- | ---: | ---: | ---: |
| Synthetic minimal document | None; core enabled | 1.08% | 9.51% | 438.03 MB |
| Synthetic minimal document | window_tab, command_palette, md_padding, slash_commands, cjk_symbol_pairing, right_click_menu, preferences, hotkeys | 1.43% | 14.95% | 444.09 MB |
| Real long document | None; core enabled | 1.69% | 19.50% | 598.16 MB |
| Real long document | Same eight plugins | 2.00% | 19.95% | 624.33 MB |

Binary split of the eight remaining default-enabled plugins:

| Group | Average CPU | Peak CPU |
| --- | ---: | ---: |
| window_tab, command_palette, md_padding, slash_commands | 2.61% | 25.46% |
| cjk_symbol_pairing, right_click_menu, preferences, hotkeys | 5.25% | 17.23% |
| cjk_symbol_pairing, right_click_menu | 1.09% | 9.52% |
| preferences, hotkeys | 0.88% | 10.87% |

## Conclusion

This run did not reproduce the previous sustained near-one-core CPU usage in the idle post-load state, and it did not identify one of the eight remaining default-enabled plugins as a persistent bottleneck. The original symptom may depend on active scrolling, a specific document construct, theme state, or a previous Typora process state.
