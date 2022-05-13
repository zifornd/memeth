# Author: Ben Southgate
# Copyright: Copyright 2020, Ben Southgate
# Email: ben.southgate@zifornd.com
# License: MIT

rule manifest:
    output:
        manifest = expand("resources/{array}.{organism}.manifest.rds", array = config["array"], organism = config["organism"])
    params:
        array = config["array"], 
        organism = config["organism"],
    log:
        out = "logs/manifest.out",
        err = "logs/manifest.err"
    message:
        "Install manifest rds: {params.array} {params.organism}"
    shell:
        "wget https://zhouserver.research.chop.edu/InfiniumAnnotation/current/{params.array}/{params.array}.{params.organism}.manifest.rds -O resources/{params.array}.{params.organism}.manifest.rds"

rule probes:
    output:
        probes = "resources/48639-non-specific-probes-Illumina450k.csv"
    params:
        # path = lambda wc, output: Path(output[0]).parents[3]
    log:
        out = "logs/probes.out",
        err = "logs/probes.err"
    message:
        "Install non spec probe details"
    shell:
        "wget https://github.com/sirselim/illumina450k_filtering/blob/master/48639-non-specific-probes-Illumina450k.csv -O {output.probes}"


rule chain:
    output:
        chainfile = expand("resources/{chainfile}", chainfile = config["chain"])
    params:
        chainfile = config["chain"],
    log:
        out = "logs/chain.out",
        err = "logs/chain.err"
    message:
        "Install chain file"
    shell:
        #"wget https://hgdownload.soe.ucsc.edu/goldenPath/hg19/liftOver/{params.chainfile}.gz -O resources/{params.chainfile}.gz | gunzip"
        #gunzip resources/{params.chainfile}.gz"
        "wget -O - https://hgdownload.soe.ucsc.edu/goldenPath/hg19/liftOver/{params.chainfile}.gz | gunzip -c > resources/{params.chainfile}"


