FROM ubuntu:20.04
MAINTAINER "sudheer reddy duba<sudheer.reddy.duba@gmail.com>"
RUN apt update && apt install -y curl zip \
    && rm -rf /var/cache/apt/*
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv ./kubectl /usr/local/bin/kubectl
CMD ["kubectl", "version", "--client"]
#FROM alpine
#MAINTAINER "sudheer reddy duba<sudheer.reddy.duba@gmail.com>"
#RUN apk add --no-cache \
#        curl \
#        zip \
#    && rm -rf /var/cache/apk/*
#RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
#    && unzip awscliv2.zip \
#    && ./aws/install --bin-dir /usr/local/bin --update
#RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
#    && chmod +x kubectl \
#    && mv ./kubectl /usr/local/bin/kubectl
#CMD ["aws", "--help"]