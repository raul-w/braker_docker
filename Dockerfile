FROM ubuntu:18.04

# install essentials
RUN apt-get -y update && apt-get -y install \
    build-essential curl gcc g++ make zlib1g-dev \
    perl autoconf cmake time git

# install required CPAN modules for Braker
RUN cpan App::cpanminus \
	&& cpanm File::Spec::Functions \
	&& cpanm File::HomeDir \
	&& cpanm File::Which \
	&& cpanm Hash::Merge \
	&& cpanm Class::Data::Inheritable \
	&& cpanm Exception::Class \
	&& cpanm Test::Pod \
	&& cpanm List::Util \
	&& cpanm List::MoreUtils \
	&& cpanm Logger::Simple \
	&& cpanm Module::Load::Conditional \
	&& cpanm Parallel::ForkManager \
	&& cpanm POSIX \
	&& cpanm Scalar::Util::Numeric \
	&& cpanm YAML \
	&& cpanm MCE::Mutex \
	&& cpanm threads

# install AUGUSTUS dependencies
RUN apt-get install -y libsqlite3-dev libmysql++-dev libgsl-dev libboost-all-dev libsuitesparse-dev liblpsolve55-dev \
	&& apt-get install -y libboost-iostreams-dev \
	&& apt-get install -y libbamtools-dev \
	&& apt-get install -y libbz2-dev liblzma-dev \
	&& apt-get install -y libncurses5-dev \
	&& apt-get install -y libssl-dev libcurl3-dev \
	&& apt-get install -y libboost-all-dev

# copy source files
COPY src/* /opt/src/
WORKDIR /opt/src

# compile htslib
RUN echo 'b352eabed6392869dbdea0fe6db10a736a226d1f90036a724a49798f7e81cab7  htslib-1.10.2.tar.gz' | sha256sum -c \
	&& tar -xzf htslib-1.10.2.tar.gz \
	&& mv htslib-1.10.2 htslib \
	&& cd htslib \
	&& autoheader \
	&& autoconf \
	&& ./configure && make && make install \
	&& make clean

# compile samtools
RUN echo '382843e85fdb55868cebaaf2585c43776762d099581341b5803677de5ed117a9  samtools-1.10.tar.gz' | sha256sum -c \
	&& tar -xzf samtools-1.10.tar.gz \
	&& mv samtools-1.10 samtools \
	&& cd samtools \
	&& autoheader \
	&& autoconf -Wno-syntax \
	&& ./configure && make && make install

# compile bcftools
RUN echo '13277c17047152951e0bfe4467adc7768571b18e26610d206cab5560de5a395a  bcftools-1.10.2.tar.gz' | sha256sum -c \
	&& tar -xzf bcftools-1.10.2.tar.gz \
	&& mv bcftools-1.10.2 bcftools \
	&& cd bcftools \
	&& autoheader \
	&& autoconf \
	&& ./configure && make && make install \
	&& make clean

# set TOOLDIR for AUGUSTUS compiling
ENV TOOLDIR=/opt/src

# compile AUGUSTUS
# RUN echo '4cc4d32074b18a8b7f853ebaa7c9bef80083b38277f8afb4d33c755be66b7140  augustus-3.3.3.tar.gz' | sha256sum -c \
#	&& tar -xzf augustus-3.3.3.tar.gz \
RUN git clone https://github.com/Gaius-Augustus/Augustus.git \
	&& cd Augustus \
	&& git checkout cc4350a \
	&& make clean && make && make install \
	&& make clean
RUN echo '5ed6ce6106303b800c5e91d37a250baff43b20824657b853ae04d11ad8bdd686  augustus-3.5.0.tar.gz' | sha256sum -c
	&& tar -xzf augustus-3.5.0.tar.gz
	&& cd Augustus \
	&& make clean && make && make install \
	&& make clean 

# compile bamtools
RUN echo '4abd76cbe1ca89d51abc26bf43a92359e5677f34a8258b901a01f38c897873fc  bamtools-v2.5.1.tar.gz' | sha256sum -c \
	&& tar -xzf bamtools-v2.5.1.tar.gz \
	&& cd bamtools-2.5.1 \
	&& mkdir build && cd build \
	&& cmake .. && make && make install

# install biopython and cdbfasta
RUN apt-get install -y python3-pip cdbfasta \
	&& pip3 install biopython

# extract diamond
RUN echo '977e2bdd14cdb843e686b4e45af0ecbd754cb471ef0f238d9c47e2c5451ae8b0  diamond-0.9.30.tar.gz' | sha256sum -c \
	&& tar -xzf diamond-0.9.30.tar.gz \
	&& cp diamond /usr/local/bin/

# extract braker
# RUN echo '528507c4fe3335865ead5421341f6e77959d2d327183b6c59d0858e6869d7ace  braker-v2.1.5.tar.gz' | sha256sum -c \
# 	&& tar -xzf braker-v2.1.5.tar.gz
RUN echo 'eef3c4037364472988a010322cbd79b5171158f9c016f4383809adade4866c06  braker-v2.1.6.tar.gz' | sha256sum -c \
 	&& tar -xzf braker-v2.1.6.tar.gz


# set environmental variables for braker
ENV PATH=/opt/src/BRAKER-2.1.6/scripts:/opt/gmes_linux_64:/opt/gmes_linux_64/ProtHint/bin:/opt/gmes_linux_64/ProtHint/dependencies:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV AUGUSTUS_CONFIG_PATH=/opt/augustus-3.5.0/config

# set permissions for braker
RUN chmod 777 /opt/augustus-3.5.0/config/*

# fix issue with utf-8 encoding
RUN apt-get update --fix-missing && apt-get install locales \
	&& locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
