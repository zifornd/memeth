# memeth <img align="right" width="200" src="images/roundel.png">

A Snakemake workflow to analyse Illumina methylation arrays

[![Snakemake](https://img.shields.io/badge/snakemake-≥6.3.0-brightgreen.svg)](https://snakemake.github.io)
![GitHub Actions: CI](https://github.com/zifornd/arrays/actions/workflows/main.yml/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg)](https://opensource.org/licenses/MIT)
[![DOI](https://zenodo.org/badge/413935149.svg)](https://zenodo.org/badge/latestdoi/413935149)

## Contents

* [Overview](#overview)
* [Installation](#installation)
* [Usage](#usage)
* [Documentation](#documentation)
* [Contributing](#contributing)
* [Authors](#authors)
* [Citation](#citation)
* [Acknowledgements](#acknowledgements)
* [License](#license)

## Overview

This workflow is used to analyse Illumina methylation arrays at the probe level. It performs quality control, filtering, normalization, data exploration and differential methylation testing.

## Installation

Install Snakemake using the conda package manager:

```console
$ conda create -c bioconda -c conda-forge --name snakemake snakemake
```

Deploy the workflow to your project directory:

```console
$ git pull https://github.com/zifornd/arrays projects/arrays
```

## Usage

Configure the workflow by editing the `config.yaml` file:

```console
$ nano config/config.yaml
```

Define the samples by editing the `samples.tsv` file:

```console
$ nano config/samples.tsv
```

Execute the workflow and install dependencies:

```console
$ snakemake --cores all --use-conda 
```

## Documentation

See the [Documentation](workflow/documentation.md) file for all configuration, execution, and output information.

## Contributing

See the [Contributing](CONTRIBUTING.md) file for ways to get started.

Please adhere to this project's [Code of Conduct](CODE_OF_CONDUCT.md).

## Authors

This workflow was developed by:

- [Benjamin Southgate](https://github.com/bensouthgate)
- [James Ashmore](https://github.com/jma1991)

## Citation

See the [Citation](CITATION.cff) file for ways to cite this workflow.

## Acknowledgements

This workflow is based on the following research article:

```
Maksimovic J, Phipson B and Oshlack A. A cross-package Bioconductor workflow for analysing methylation array data [version 3; peer review: 4 approved]. F1000Research 2017, 5:1281 (https://doi.org/10.12688/f1000research.8839.3)
```

## License

This workflow is licensed under the [MIT](LICENSE.md) license.  
Copyright &copy; 2021, Zifo RnD Solutions
