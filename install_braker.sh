# create conda environment for braker and install all dependencies within this environment

conda create -y --name braker_env python=3.6

conda activate braker_env

# install all perl dependencies
conda install -y -c anaconda perl
conda install -y -c bioconda perl-app-cpanminus
conda install -y -c bioconda perl-hash-merge
conda install -y -c bioconda perl-parallel-forkmanager
conda install -y -c bioconda perl-scalar-util-numeric
conda install -y -c bioconda perl-yaml
conda install -y -c bioconda perl-class-data-inheritable
conda install -y -c bioconda perl-exception-class
conda install -y -c bioconda perl-test-pod
conda install -y -c anaconda biopython
conda install -y -c bioconda perl-file-homedir
conda install -y -c bioconda perl-file-which
conda install -y -c bioconda perl-mce
conda install -y -c bioconda perl-threaded 
cpanm Logger::Simple

# get BRAKER itself and make all its files executable
git clone https://github.com/Gaius-Augustus/BRAKER.git
chmod 744 BRAKER/scripts/*.pl

# add BRAKER scripts to PATH (copy following line to startup script (e.g. ~/.profile))
# export PATH=$PATH:/dir_with_braker/BRAKER/scripts

# get GeneMark-ES from http://exon.gatech.edu/GeneMark/license_download.cgi and move them to an appropriate folder
# unpack GeneMark-ES
tar -xzf gmes_linux_64.tar.gz
rm gmes_linux_64.tar.gz
# add GeneMark-ES path to PATH 
# export GENEMARK_PATH=/your_path_to_GeneMark-ET/gmes_linux_64

# move GeneMark-ES key to home directory
gunzip gm_key_64.gz
mv gm_key_64 ~/.gm_key

# a new release with a new key needs to be re-downloaded after 200 days

# get AUGUSTUS
git clone https://github.com/Gaius-Augustus/Augustus.git

# try to compile it
cd Augustus
make
cd ..

# add augustus config path and executable to $PATH
# export AUGUSTUS_CONFIG_PATH=/your_path_to_AUGUSTUS/Augustus/config
# export PATH=$PATH:/your_path_to_AUGUSTUS/Augustus/bin:/your_path_to_AUGUSTUS/Augustus/scripts

# get bamtools and install it
git clone https://github.com/pezmaster31/bamtools.git
cd bamtools 
mkdir build 
cd build 
cmake .. 
make

# add bamtools to PATH
# export BAMTOOLS_PATH=/your_path_to_bamtools/bin/

# install Diamond 
wget http://github.com/bbuchfink/diamond/releases/download/v0.9.24/diamond-linux64.tar.gz
    tar xzf diamond-linux64.tar.gz


