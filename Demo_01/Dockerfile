# SQL Server Command Line Tools - custom image
# From Ubuntu 16.04 as base image
FROM ubuntu:16.04 as base

# Installing system utilities
RUN apt-get update && \
    apt-get install -y \
	apt-transport-https curl debconf-utils locales \
    && rm -rf /var/lib/apt/lists/*
# Adding custom MS repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# From base image
FROM base as release

# Installing SQL Server drivers and tools
RUN apt-get update && \
    ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
    msodbcsql mssql-tools
# Adding SQL Server tools to $PATH
ENV PATH=$PATH:/opt/mssql-tools/bin
# Set locale
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8
CMD /bin/bash