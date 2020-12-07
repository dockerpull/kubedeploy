FROM alpine

RUN apk -Uuv add python3 py3-pip bash wget curl && \
    python3 -m pip install awscli && \
	apk --purge -v del py-pip && \
	rm /var/cache/apk/* && \
	aws --version

RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"

RUN chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl && kubectl version --client

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
