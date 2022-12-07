# BRAKER container

Docker container which should provide an easy and portable method to run BRAKER. Inspired by <https://github.com/Dfam-consortium/TETools>

## Using the container

### Requirements

* A 64-bit Linux operating system. 
* `docker` installed with permission to run containers.
* GeneMark-ES. The license terms of GeneMark-ES does not allow me to redistribute it inside the
  container directly, but you can obtain it free of charge from
  <http://exon.gatech.edu/GeneMark/license_download.cgi>. The container has been tested
  with GeneMark-ES 4.* ("Last modified: January, 2020").

### Building the container

You'll need:

* `curl`
* `docker`, with permissions to build containers

```bash
# Download dependencies
$ ./getsrc.sh

# Build a docker container
$ docker build -t org/name:tag .
```

Replace org/name:tag with a custom tag of your own (e.g. braker_docker:latest). 

### Running the container

The complete folder of Genemark-ES must be bind-mounted into the container at
`/opt/gmes_linux_64`. You will also need to set the UID/GID,
directories to mount, and so on according to your specific situation.

E.g. to run BRAKER in working directory /mnt/scratch/braker_results on soft-masked genome `genome.fa` with RNA-seq alignments `RNAseq.bam`:

```bash
mkdir -p workdir_braker_docker && \
docker run -it --mount type=bind,source=/mnt/scratch/braker_results,target=/work --mount type=bind,source=/path/to/gmes_linux_64,target=/opt/gmes_linux_64,ro --mount type=bind,source=~/.gm_key,target=~/.gm_key,ro --user "$(id -u):$(id -g)" --workdir "/work" --env "HOME=/work" braker_docker:latest braker.pl --genome=genome.fa --bam=RNAseq.bam --softmasking --workingdir=workdir_braker_docker &> braker_output.log
```

Replace `/path/to/gmes_linux_64` with the path to `gmes_linux_64` on your system accordingly. All output files will be found in /mnt/scratch/braker_results, which was mounted to the container. 

### Testing the container

The following commands will test BRAKER with RNA-seq data example command:

```bash
mkdir -p test_braker_docker && \
cd test_braker_docker && mkdir work_test \
wget http://bioinf.uni-greifswald.de/bioinf/braker/RNAseq.bam && \
docker run -it --mount type=bind,source="$PWD",target=/work --mount type=bind,source=/path/to/gmes_linux_64,target=/opt/gmes_linux_64,ro --mount type=bind,source=~/.gm_key,target=~/.gm_key,ro --user "$(id -u):$(id -g)" --workdir "/work" --env "HOME=/work" braker_docker:latest /usr/bin/time -v braker.pl --genome=/opt/src/BRAKER-2.1.5/examples/genome.fa --bam=RNAseq.bam --softmasking --workingdir=work_test &> test1.log
```

Replace `/path/to/gmes_linux_64` with the path to `gmes_linux_64` on your system and other directories accordingly.