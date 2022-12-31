# Contributing

Thank you for reading this guide and contributing to the workflow!

## Table of Contents

* [Support](#support)
* [Feedback](#feedback)
* [Testing](#testing)
* [Linting](#linting)
* [Formatting](#formatting)
* [Conduct](#conduct)

## Support

If you need any help getting started or solving an error:

1. Read the documentation for the relevant section
2. Check the issues trackers for similar problems and solutions
3. Open an issue with one of the following labels:
    - `help wanted` for when extra attention is needed
    - `question` for when further information is requested

## Feedback

If you have any suggestions or enhancements you would like:

1. Read the documentation to confirm the feature is not available
2. Search the issues tracker for similar suggestions and outcomes
3. Open an issue with one of the following labels:
    - `documentation` for improvements or additions to documentation
    - `enhancement` for new features or requests

## Testing

Run the workflow on the bundled test data using the command shown below:

```console
$ snakemake --snakefile workflow/Snakefile --cores 4 --directory .test --show-failed-logs --use-conda --conda-cleanup-pkgs cache
```

You can also generate unit tests for your code:

```console
$ snakemake --snakefile workflow/Snakefile --directory .test snakemake --generate-unit-tests
```

## Linting

This project uses the Snakemake linter to analyse the workflow and highlight
issues that should be solved in order to follow best practices. The linter can
be invoked as shown below:

```console
$ snakemake --lint
```

Contributions must pass all linting checks before a pull request will be
considered.

## Formatting

This project uses [snakefmt](https://github.com/snakemake/snakefmt) to enforce a
consistent coding style. Follow the instructions below to install and run the
formatter on your Snakemake files:

Install snakefmt via conda:

```console
$ conda install -c bioconda -n snakefmt snakefmt
```

Format a single file:

```console
$ snakefmt Snakefile
```

Format multiple files:

```
$ snakefmt workflow/
```

Contributions must pass all formatting checks before a pull request will be
considered. 

## Conduct

Contributors must adhere to our [Code of Conduct](CODE_OF_CONDUCT.md) and
violations should be reported to [James Ashmore](james.ashmore@zifornd.com) as soon as possible.