{% set java = pillar.get('java', {}) -%}
{% set jre = java.get('jre') -%}
{% set home = jre.get('home', '/opt') -%}

server_jre_tar:
  file.managed:
{% if jre['source'] is defined %}
    - name: {{ home }}/server_jre.tgz
    - source: {{ jre['source'] }}
    - source_hash: {{ jre['source_hash'] }}
{% else %}
    - name: {{ home }}/server_jre.tgz
    - source: salt://java/files/server_jre.tgz
{% endif %}
  cmd.run:
    - name: tar xvf {{ home }}/server_jre.tgz -C {{ home }}
    - require:
      - file: server_jre_tar
  alternatives.install:
    - name: java
    - link: /usr/bin/java
    - path: {{ home }}/jdk1.8.0_201/bin/java
    - priority: 30
    - require:
      - cmd: server_jre_tar
