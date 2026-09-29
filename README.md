# xhimalaya

Model weights for [Himalaya](https://lognjais.github.io/himalaya-ide/), and nothing else.
Himalaya's first-run setup downloads its model from this repository's releases, checks
every byte, and then runs with no network at all.

## What is here

| Release | Model | Size | Parts |
|---|---|---|---|
| `gemma-4-26b-a4b-qat-q4_0-v1` | Gemma 4 26B A4B, instruction tuned, Google's official QAT Q4_0 GGUF | 14,439,363,584 bytes | 29 |

Each part is under GitHub's 2 GiB limit for a release asset: four of 1,992,294,400 bytes,
then 25 smaller ones of 256 MiB, cut small so an upload or download over a slow link
restarts cheaply. `SHA256SUMS` lists every part and the joined file.

## Get the model

```bash
./assemble.sh ~/models
```

It resumes a dropped download, checks each part, joins them, checks the whole file
against `3eca3b8f6d7baf218a7dd6bba5fb59a56ee25fe2d567b6f5f589b4f697eca51d`, and deletes
the parts. By hand: download every `.part-` file from the release, then
`cat gemma-4-26B_q4_0-it.gguf.part-* > gemma-4-26B_q4_0-it.gguf` and
`shasum -a 256 -c SHA256SUMS`.

## Why a copy here

- **Pinned.** The exact bytes Himalaya was measured with, from Hugging Face commit
  `d1c082be9cf3c8a514acf63b8761f4b41935842e`, so an upstream change cannot alter them.
- **One place.** The app, its sky and its model all come from the same owner.
- **Offline after one download.** Nothing here, and nothing in Himalaya, calls a model
  API. Copy the joined file between machines by USB or AirDrop and check its SHA-256.

## Licence

Gemma 4 is released by Google under the Apache License 2.0 (`LICENSE`). The weights
are unchanged; only split into parts (`NOTICE`).

## Measured on a MacBook Pro M5 Pro, 24 GB, 2026-09-26

With llama.cpp b11200: prefill 1,670 to 2,004 tokens a second, decode 74 to 82 tokens
a second, and the next turn of a conversation starts in about 0.1 s because the
history stays cached.
