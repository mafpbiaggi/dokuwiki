# DokuWiki

[![Full CI/CD](https://github.com/mafpbiaggi/dokuwiki/actions/workflows/push_main.yml/badge.svg?branch=main)](https://github.com/mafpbiaggi/dokuwiki/actions/workflows/push_main.yml)
[![Release](https://img.shields.io/badge/Release-v1.2.0-blue?logo)](https://github.com/mafpbiaggi/dokuwiki/releases/tag/v1.2.0)

> **ATENÇÃO**: Este repositório não é oficial do projeto DokuWiki. Consulte [mais informações aqui](#dados-oficiais).

O DokuWiki é um sistema de wiki leve, sem banco de dados, desenvolvido em PHP. Ele é amplamente utilizado para documentação, conhecimento interno, wikis pessoais e sites colaborativos, mantendo uma instalação simples e de baixa manutenção.

Este repositório corresponde à árvore principal do projeto DokuWiki e inclui a versão publicada no release atual, identificada em `app/VERSION` e em `release_notes`.

## Estrutura do projeto

```
├── .github/workflows/   # arquivos de integração e entrega contínua
├── app/                 # código-fonte principal, arquivos de configuração e assets da aplicação
├── docker/              # configuração para criação da imagem Docker
├── docs/                # documentação específica
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

## Workflows

Os workflows do GitHub Actions automatizam a validação de alterações em `app/` e `docker/`, a varredura de vulnerabilidades, os testes de integração, a publicação da imagem Docker no GHCR e a criação de release. Consulte a [documentação completa dos workflows](docs/Workflows.md) para detalhes sobre:

- Gatilhos e filtros de execução em `push`, `pull_request` e `workflow_call`
- Jobs reutilizáveis de build, scan, test, publish e release
- Dependências entre jobs e publicação condicional para o pipeline de CI/CD

## Relação com o repositório `dokuwiki-iac`

Este repositório concentra a base de código e a imagem Docker do projeto DokuWiki, enquanto o repositório [mafpbiaggi/dokuwiki-iac](https://github.com/mafpbiaggi/dokuwiki-iac) cuida da infraestrutura e da automação de provisionamento relacionadas à execução da aplicação em ambientes cloud e de desenvolvimento.

Em termos práticos, a relação entre os dois repositórios é complementar:

- `dokuwiki` define o conteúdo da aplicação, seus artefatos e sua publicação;
- `dokuwiki-iac` define os recursos de infraestrutura, as configurações de ambiente e as automatizações de deploy;
- a imagem gerada por este repositório é consumida pela infraestrutura descrita em `dokuwiki-iac`.

Assim, o fluxo de trabalho fica dividido entre a entrega da aplicação e o provisionamento da estrutura necessária para executá-la e operá-la.

## Licença

O DokuWiki é distribuído sob a GNU General Public License, versão 2. Consulte `app/COPYING` para detalhes completos.

## Dados oficiais

- Site oficial: https://www.dokuwiki.org
- Documentação: https://www.dokuwiki.org/dokuwiki
- Suporte e comunidade: https://www.dokuwiki.org/support
