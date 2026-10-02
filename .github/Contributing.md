# Contribuindo

Ao contribuir para este repositório, primeiro discuta a alteração que deseja fazer por meio de uma issue,
e-mail ou qualquer outro método com os proprietários deste repositório antes de fazer uma mudança.

Observe que temos um código de conduta; siga-o em todas as suas interações com o projeto.

## Processo de Pull Request

1. Atualize o README.md com detalhes das alterações, incluindo blocos de exemplo em HCL e arquivos de exemplo, quando apropriado.
2. Execute os hooks do pre-commit `pre-commit run -a`.
3. Quando todos os comentários pendentes e itens da checklist forem resolvidos, sua contribuição será mesclada! Pull requests mesclados serão incluídos no próximo lançamento. Os mantenedores do dokuwiki-iac cuidam de atualizar o CHANGELOG.md conforme mesclam.

## Listas de verificação para contribuições

- [ ] Adicione o [prefixo semântico](#pull-requests-semânticos) ao seu PR ou commits (pelo menos um dos grupos de commits)
- [ ] Os testes de CI estão passando
- [ ] O README.md foi atualizado após qualquer alteração em variáveis e saídas.
- [ ] Execute os hooks do pre-commit `pre-commit run -a`

## Pull Requests Semânticos

Para gerar o changelog, os Pull Requests ou Commits devem ser semânticos e seguir as especificações convencionais abaixo:

- `feat:` para novas funcionalidades
- `fix:` para correções de bugs
- `improvement:` para melhorias
- `docs:` para documentação e exemplos
- `refactor:` para refatoração de código
- `test:` para testes
- `ci:` para fins de CI
- `cd:` para fins de CD
- `chore:` para tarefas gerais

O prefixo `chore` é ignorado durante a geração do changelog. Pode ser usado em mensagens de commit como `chore: update changelog` por exemplo.
