# dandi-t261-compression-study

STAMPED-style research object bundling:

- `code/compression-comparisons-tools/` — the compbench toolkit (this repo's `dandi/compression-comparisons`)
- `sourcedata/aind-ephys-compression/` — the AIND ephys-compression benchmark data
  (mirror of `s3://aind-benchmark-data/ephys-compression/`, subdataset of
  `///aind-benchmark-data/ephys-compression`)
- `derivatives/compbench-*/` — one subtree per benchmark run, containing
  Snakemake outputs (per-cell `metrics.json` + `duct-*.jsonl` + `report.parquet`)

## Reproducing

```bash
# 1. Clone with subdatasets
datalad clone <this-repo-url> study
cd study
datalad get code/compression-comparisons-tools  # get the tool code
datalad get sourcedata/aind-ephys-compression/ibl-np1/CSHZAD026_2020-09-04_probe00/traces_cached_seg0.raw

# 2. Build the tool environment (from code/compression-comparisons-tools/)
cd code/compression-comparisons-tools
uv venv && source .venv/bin/activate && uv pip install -e '.[devel,ephys]'
cmake -S src/bwc -B src/bwc/build -DCMAKE_CXX_FLAGS="-Wno-restrict" && cmake --build src/bwc/build -j

# 3. Run the sweep
cd ../..
datalad run -m 'reproduction sweep on CSHZAD026' \
    --input sourcedata/aind-ephys-compression/ibl-np1/CSHZAD026_2020-09-04_probe00/ \
    --output derivatives/compbench-YYYY-MM-DD/ \
    snakemake -s code/compression-comparisons-tools/src/compbench/pipeline/Snakefile \
        --configfile code/compression-comparisons-tools/configs/profiles/paper-real.yaml \
        --config results_dir=derivatives/compbench-YYYY-MM-DD/ \
        --cores 4
```

The `datalad run` records the tool version, input hashes, and command line so
the derivative subtree can be regenerated verbatim.
