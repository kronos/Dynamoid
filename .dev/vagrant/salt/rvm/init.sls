# https://docs.saltstack.com/en/latest/ref/states/all/salt.states.rvm.html
rvm-deps:
  pkg.installed:
    - pkgs:
      - bash
      - coreutils
      - gzip
      - bzip2
      - gawk
      - sed
      - curl
      - git-core
      - subversion
      - gnupg2

mri-deps:
  pkg.installed:
    - pkgs:
      - build-essential
      - openssl
      - libreadline6
      - libreadline6-dev
      - curl
      - git-core
      - zlib1g
      - zlib1g-dev
      - libssl-dev
      - libyaml-dev
      - libsqlite3-0
      - libsqlite3-dev
      - sqlite3
      - libxml2-dev
      - libxslt1-dev
      - autoconf
      - libc6-dev
      - libncurses5-dev
      - automake
      - libtool
      - bison
      - subversion
      - ruby

gpg-trust:
  cmd.run:
    - name: command curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
    - user: vagrant

ruby-{{ pillar['ruby']['version'] }}:
  rvm.installed:
    - name: {{ pillar['ruby']['version'] }}
    - default: True
    - user: vagrant
    - require:
      - pkg: rvm-deps
      - pkg: mri-deps

# Disable Documentation Installation
/home/vagrant/.gemrc:
  file.managed:
    - user: vagrant
    - group: vagrant
    - name: /home/vagrant/.gemrc
    - source: salt://rvm/.gemrc
    - makedirs: True

# Bundler
bundler.install:
  gem.installed:
    - user: vagrant
    - name: bundler
    - ruby: ruby-{{ pillar['ruby']['version'] }}
    - rdoc: false
    - ri: false

bundle:
  cmd.run:
    - name: (cd /vagrant && bundle install)
    - user: vagrant
