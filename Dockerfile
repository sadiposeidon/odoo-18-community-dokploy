FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# System dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    build-essential \
    git \
    curl \
    wget \
    libxml2-dev \
    libxslt1-dev \
    libldap2-dev \
    libsasl2-dev \
    libpq-dev \
    libjpeg-dev \
    liblcms2-dev \
    libblas-dev \
    libatlas-base-dev \
    libssl-dev \
    libffi-dev \
    node-less \
    npm \
    fonts-dejavu \
    fonts-courier-prime \
    ttf-mscorefonts-installer \
    python3-ldap \
    && fc-cache -f -v \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create odoo user
RUN useradd -m -d /opt/odoo -U -r -s /bin/bash odoo

# Clone Odoo 18 Community
RUN git clone https://github.com/odoo/odoo --depth 1 --branch 18.0 /opt/odoo/odoo

WORKDIR /opt/odoo/odoo

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Create directories
RUN mkdir -p /var/lib/odoo /etc/odoo /odoo_models \
    && chown -R odoo:odoo /var/lib/odoo /etc/odoo /opt/odoo /odoo_models

USER odoo

EXPOSE 8069

CMD ["python3", "odoo-bin", "-c", "/etc/odoo/odoo.conf"]