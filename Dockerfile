# AWS provided base image (Amazon Linux 2)
# It includes Lambda Runtime Emulator for testing locally.
FROM public.ecr.aws/lambda/provided:al2

# Download and install Julia
WORKDIR /usr/local
RUN yum install -y tar gzip \
    && curl -LO https://julialang-s3.julialang.org/bin/linux/x64/1.5/julia-1.5.3-linux-x86_64.tar.gz \
    && tar xf julia-1.5.3-linux-x86_64.tar.gz \
    && rm julia-1.5.3-linux-x86_64.tar.gz \
    && ln -s julia-1.5.3 julia

ENV PATH=$PATH:/usr/local/julia/bin

# Use a special depot path to store precompiled binaries
ENV JULIA_DEPOT_PATH $LAMBDA_TASK_ROOT/.julia

# Install bootstrap script
COPY runtime $LAMBDA_RUNTIME_DIR

# Create an empty extensions directory
RUN mkdir /opt/extensions

WORKDIR $LAMBDA_TASK_ROOT
