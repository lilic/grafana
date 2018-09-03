FROM openshift/origin-base

ENV GOPATH="/go"
ENV GOBIN="${GOPATH}/bin"
ENV PATH="${GOBIN}:${PATH}"
RUN mkdir -p $GOBIN

COPY . $GOPATH/src/github.com/grafana/grafana

RUN yum install -y golang make && \
    cd $GOPATH/src/github.com/grafana/grafana && \
    go run build.go build && \
    yum erase -y golang make && yum clean all

LABEL io.k8s.display-name="Grafana" \
      io.k8s.description="" \
      io.openshift.tags="openshift" \
      maintainer="Frederic Branczyk <fbranczy@redhat.com>"

# doesn't require a root user.
USER 1001

WORKDIR $GOPATH/src/github.com/grafana/grafana
ENTRYPOINT ["/go/src/github.com/grafana/grafana/bin/linux-amd64/grafana-server"]
