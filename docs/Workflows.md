# Workflows

## Visão geral

Os workflows do GitHub Actions automatizam a validação, a análise de vulnerabilidades, os testes de integração, a publicação da imagem Docker e a criação de release deste projeto DokuWiki. A execução é organizada em workflows principais e workflows reutilizáveis, com gatilhos condicionados por eventos do repositório e por caminhos relevantes do projeto.

## Fluxo principal

### `push_main.yml` — Full CI/CD

Este workflow é acionado em pushes na branch `main` quando há alteração em `app/**`, `docker/**` ou `release_notes`.

- `changes`: executa `./.github/workflows/changes.yml` para verificar se houve alteração relevante em `app/**` ou `docker/**`
- `build`: depende de `changes` e só roda quando o valor de `changed` é `true`
- `scan`: depende de `build` e usa a imagem gerada no job anterior
- `test`: depende de `build` e `scan` e valida a aplicação em um container Docker
- `publish`: depende de `build` e `test` e envia a imagem para o GitHub Container Registry (GHCR)
- `release`: depende de `changes` e `publish` e cria uma release quando o pipeline não foi cancelado e não falhou

Permissões:

- `contents: read` para a execução principal
- `packages: write` para o job de publicação
- `contents: write` para o job de release

Os jobs usam `concurrency` para controlar a execução em sequência do pipeline, com `cancel-in-progress: false` no fluxo principal.

### `pull_request.yml` — Pull request validation

Este workflow é acionado em pull requests para qualquer branch, desde que existam alterações em `app/**` ou `docker/**`.

- `build`: executa `./.github/workflows/build.yml`
- `scan`: depende de `build` e usa a imagem montada no job anterior
- `test`: depende de `build` e `scan` e valida a aplicação em um container de teste

Também há controle de concorrência por PR, com `cancel-in-progress: true` para interromper execuções anteriores do mesmo pull request.

## Workflows reutilizáveis

### `changes.yml` — verificação de alterações

Este workflow usa `dorny/paths-filter` para detectar se qualquer alteração relevante ocorreu em:

- `app/**`
- `docker/**`

A saída `changed` é usada para decidir se o pipeline principal deve continuar com a etapa de build.
Essa configuração permite que alterações que não tenham relação com a aplicação (testes e documentação, por exemplo), não gerem ações de build e validação de imagem.

### `build.yml` — construção da imagem

Workflow chamado por outros jobs via `workflow_call`.

- checkout do repositório
- leitura da versão em `app/VERSION`
- preparação do tag da imagem
- setup do Docker Buildx
- build da imagem localmente com `docker/build-push-action`
- exportação da imagem para um artifact chamado `image-${{ github.run_id }}`

Saídas:

- `tag`: tag gerada pela versão do projeto
- `artifact`: nome do artifact da imagem

### `scan.yml` — varredura de vulnerabilidades

Workflow executado por `workflow_call` ou manualmente via `workflow_dispatch`.

- baixa a imagem do artifact quando a execução é disparada por outro workflow
- carrega a imagem em memória
- se executado manualmente, faz login no GHCR e realiza pull da imagem
- executa o Trivy com:
  - `image-ref`: imagem informada ou `ghcr.io/<owner>/<repo>:latest`
  - `format: table`
  - `exit-code: 0`
  - `ignore-unfixed: true`
  - `vuln-type: os,library`
  - `severity: CRITICAL,HIGH`

### `test.yml` — testes de integração

Workflow executado por `workflow_call` ou manualmente via `workflow_dispatch`.

- checkout do repositório
- download e carga da imagem do artifact, quando aplicável
- login no GHCR e pull da imagem para execução manual
- inicialização do container com montagem do arquivo de configuração local em `tests/conf/local.php`
- aguarda o container ficar pronto com `tests/container_status.sh`
- verifica a saúde da aplicação com `tests/health_check_app.sh`
- remove recursos temporários com `docker rm -f` em caso de falha ou conclusão

### `publish.yml` — publicação no GHCR

Workflow reutilizável que recebe:

- `tag`
- `artifact_name`

Ele:

- baixa o artifact da imagem
- carrega a imagem localmente
- autentica no `ghcr.io` com `GITHUB_TOKEN`
- cria tags `tag` e `latest`
- publica as imagens no GHCR
- coleta `name` e `digest` do manifest para uso no pipeline de release

Saídas:

- `image_name`
- `image_digest`

### `release.yml` — criação de release

Workflow reutilizável responsável por criar uma release no GitHub com base em `release_notes`.

- verifica a versão da release lendo a primeira linha do arquivo `release_notes` no formato `# vX.Y.Z`
- verifica se a release ainda não existe com `gh release view`
- se não existir, prepara o corpo da release removendo o cabeçalho inicial do arquivo
- coleta o nome e o digest da imagem publicada no GHCR
- adiciona uma seção `## Imagem` com os dados do manifest
- cria a release com `ncipollo/release-action`

O workflow usa o valor de `github.sha` como commit associado à release e só executa quando a condição `!cancelled() && !failure()` for atendida no pipeline principal.

## Resumo do pipeline

A sequência de execução pode ser resumida da seguinte forma:

```text
changes -> build -> scan -> test -> publish -> release
```

No fluxo de pull request, a etapa de `publish` não é executada; o pipeline fica restrito à validação de imagem, análise de vulnerabilidade e testes de integração.
