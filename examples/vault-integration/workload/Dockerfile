FROM golang:1.17.1-alpine as builder
RUN apk add build-base git curl

RUN git clone https://github.com/spiffe/spiffe-helper
RUN cd spiffe-helper && make

FROM python:3.10.0-alpine3.14

USER root

COPY --from=builder /go/spiffe-helper/spiffe-helper /opt/spire/bin/
COPY --from=builder /go/spiffe-helper/helper.conf /opt/spire/config/

COPY ca.pem /usr/local/share/ca-certificates/vault-ca.pem
RUN cat /usr/local/share/ca-certificates/vault-ca.pem >> /etc/ssl/certs/ca-certificates.crt

COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

WORKDIR /app

COPY app .

EXPOSE 8443
USER 10001

ENTRYPOINT ["/opt/spire/bin/spiffe-helper"]
CMD ["-config", "/opt/spire/config/helper.conf"]
