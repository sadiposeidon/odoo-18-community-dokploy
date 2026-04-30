FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-venv python3-dev \
    build-essential git curl wget \
    libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev \
    libpq-dev libjpeg-dev liblcms2-dev \
    libblas-dev libatlas-base-dev \
    libssl-dev libffi-dev \
    node-less npm \
    fonts-dejavu fonts-courier-prime \
    ttf-mscorefonts-installer python3-ldap fontconfig \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /opt/odoo -U -r -s /bin/bash odoo

RUN git clone https://github.com/odoo/odoo --depth 1 --branch 18.0 /opt/odoo/odoo

WORKDIR /opt/odoo/odoo

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --no-cache-dir -r requirements.txt

RUN mkdir -p /var/lib/odoo /etc/odoo /var/log/odoo \
    && chown -R odoo:odoo /var/lib/odoo /etc/odoo /var/log/odoo

COPY odoo.conf /etc/odoo/odoo.conf

USER odoo

EXPOSE 8069

CMD ["python3", "odoo-bin", "-c", "/etc/odoo/odoo.conf"]