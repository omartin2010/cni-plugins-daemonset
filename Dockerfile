FROM alpine:3.20 as builder

RUN apk add --no-cache git curl
RUN curl -SLO https://go.dev/dl/go1.24.2.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.24.2.linux-amd64.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"
RUN git clone https://github.com/omartin2010/plugins.git /src/plugins

WORKDIR /src/plugins
ENV GO111MODULE=on
RUN go mod download

# Build the CNI plugins using the provided script
RUN ./build_linux.sh

# STEP 2
FROM alpine:3.20
RUN mkdir -p /opt/cni/bin
COPY --from=builder /src/plugins/bin /opt/cni/bin