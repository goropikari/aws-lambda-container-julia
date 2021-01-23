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

# Use a special depot path to store precompiled binaries
ENV JULIA_DEPOT_PATH $LAMBDA_TASK_ROOT/.julia

# Copy application code
COPY *.toml $LAMBDA_TASK_ROOT/
COPY src $LAMBDA_TASK_ROOT/src

# Instantiate project and precompile packages
RUN /usr/local/julia/bin/julia --project=. -e "using Pkg; Pkg.instantiate(); Pkg.API.precompile()"

# Uncomment this line to allow more precompilation in lamdbda just in case.
# That's because /var/task is a read-only path during runtime.
ENV JULIA_DEPOT_PATH /tmp/.julia:/$LAMBDA_TASK_ROOT/.julia

# Install bootstrap script
COPY runtime $LAMBDA_RUNTIME_DIR

# Create an empty extensions directory
RUN mkdir /opt/extensions

WORKDIR $LAMBDA_TASK_ROOT

# Which module/function to call?
CMD [ "JuliaLambdaExample.handle_event"]
