FROM ubuntu:20.04

COPY requirements.txt /tmp/requirements.txt

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y git python3 python3-pip wget unzip curl jq && \
    wget https://releases.hashicorp.com/terraform/0.14.6/terraform_0.14.6_linux_amd64.zip && \
    wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.29.2/terragrunt_linux_amd64 && \
    chmod +x terragrunt_linux_amd64 && \
    mv terragrunt_linux_amd64 /bin/terragrunt && \
    unzip terraform_0.14.6_linux_amd64.zip && \
    mv terraform /bin/terraform && \
    pip3 install -r /tmp/requirements.txt && \
    mkdir -p /tmp/terraform/{plugins,modules} && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.2.7.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    curl -o /usr/bin/kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.13/2022-10-31/bin/linux/amd64/kubectl && chmod 0777 /usr/bin/kubectl && \
    curl -o /usr/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.7/2020-07-08/bin/linux/amd64/aws-iam-authenticator && chmod 0777 /usr/bin/aws-iam-authenticator && \
    #curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash && \
    #chmod 700 get_helm.sh && \
    #./get_helm.sh && \
    wget https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash && \
    mv get-helm-3 get_helm.sh && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh && \
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp && \
    mv /tmp/eksctl /usr/local/bin && \
    git clone https://github.com/ahmetb/kubectx /opt/kubectx && \
    ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx && \
    ln -s /opt/kubectx/kubens /usr/local/bin/kubens

ADD ansible_import.sh /usr/bin/ansible_import

RUN chmod +x /usr/bin/ansible_import