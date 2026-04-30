FROM ubuntu:24.04


LABEL maintainer="you@example.com"
ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    python3-setuptools \
    python3-wheel \
    build-essential \
    git \
    curl \
    wget \
    ca-certificates \
    gnupg \
    libxml2-dev \
    libxslt1-dev \
    libjpeg-dev \
    liblcms2-dev \
    libjpeg8-dev \
    libtiff5-dev \
    libopenjp2-7 \
    libwebp-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libxcb1-dev \
    libpq-dev \
    libldap2-dev \
    libsasl2-dev \
    python3-ldap \
    libblas-dev \
    libatlas-base-dev \
    libssl-dev \
    libffi-dev \
    xz-utils \
    zlib1g-dev \
    nodejs \
    npm \
    node-less \
    fonts-dejavu \
    fonts-liberation \
    ttf-mscorefonts-installer \
    fontconfig \
    procps \
    net-tools \
    supervisor \
    lsb-release \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


# =========================
# User
# =========================
RUN useradd -m -d /opt/odoo -U -r -s /bin/bash odoo


# =========================
# Odoo source
# =========================
RUN git clone https://github.com/odoo/odoo --depth 1 --branch 18.0 /opt/odoo/odoo

WORKDIR /opt/odoo/odoo


# =========================
# Virtual env
# =========================
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"


# =========================
# Python deps (FIXED)
# =========================
# RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir --upgrade pip setuptools wheel \
    && pip install --no-cache-dir -r requirements.txt


# =========================
# Directories (FIXED permissions)
# =========================
RUN mkdir -p /var/lib/odoo /etc/odoo /var/log/odoo \
    && chown -R odoo:odoo /var/lib/odoo /etc/odoo /var/log/odoo /opt/odoo


# =========================
# User
# =========================
USER odoo

EXPOSE 8069

CMD ["python3", "odoo-bin", "-c", "/etc/odoo/odoo.conf"]