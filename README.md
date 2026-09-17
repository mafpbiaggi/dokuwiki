# DokuWiki

> **ATENÇÃO**: Este repositório não é oficial do projeto DokuWiki. Consulte [mais informações aqui](#dados-oficiais).

O DokuWiki é um sistema de wiki leve, sem banco de dados, desenvolvido em PHP. Ele é amplamente utilizado para documentação, conhecimento interno, wikis pessoais e sites colaborativos, mantendo uma instalação simples e de baixa manutenção.

Este repositório corresponde à árvore principal do projeto DokuWiki e inclui a versão publicada no release atual, identificada em `app/VERSION` e em `release_notes`.

## Estrutura do projeto

```
├── .github/workflows/   # arquivos de integração e entrega contínua
├── app/                 # código-fonte principal, arquivos de configuração e assets da aplicação
├── docker/              # configuração para criação da imagem Docker
├── tests/               # scripts de validação e verificação de saúde da aplicação
├── README.md            # documentação do projeto
└── release_notes        # informações de publicação de versão
```

## Requisitos mínimos

- Docker

## Instalação rápida

1. Execute o container:

```bash
docker run -d --name dokuwiki -p 80:80 ghcr.io/mafpbiaggi/dokuwiki:<tag-version>
```

2. Finalize a instalação no assistente em `http://localhost/install.php` (ou no endereço do host em que o container está sendo executado).

> Para mais informações, consulte a documentação oficial de [instalação](https://www.dokuwiki.org/installer).

3. Remova o arquivo `install.php` do container para evitar que ele sobrescreva as configurações:

```bash
docker exec -i dokuwiki rm -f /var/www/html/install.php
```

## Configuração adicional

Caminhos relevantes para persistência de dados:

- `/conf/` — configurações locais
- `/data/` — dados de páginas, cache, logs, etc.

### Instalação com persistência de dados

1. Antes de executar o container, crie a estrutura de diretórios:

```bash
mkdir $(pwd)/persist/ && \
    cp -r app/conf persist/ && \
    cp -r app/data persist/ && \
    sudo chgrp www-data persist/ -R && \
    find persist/ -type f -exec chmod 660 '{}' \; && \
    find persist/ -type d -exec chmod 770 '{}' \;
``` 
2. Execute o container com os parâmetros de persistência:

```bash
docker run -d --name dokuwiki \
  -v "$(pwd)/persist/conf:/var/www/html/conf" \
  -v "$(pwd)/persist/data:/var/www/html/data" \
  -p 80:80 \
  ghcr.io/mafpbiaggi/dokuwiki:<tag-version>
```
Em caso de uma instalação nova, siga os passos 2 e 3 da seção [Instalação rápida](#instalação-rápida).

## Licença

O DokuWiki é distribuído sob a GNU General Public License, versão 2. Consulte `app/COPYING` para detalhes completos.

## Dados oficiais

- Site oficial: https://www.dokuwiki.org
- Documentação: https://www.dokuwiki.org/dokuwiki
- Suporte e comunidade: https://www.dokuwiki.org/support
