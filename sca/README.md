# XGuardian — SCA

Executa exclusivamente análise de composição de software (SCA), verificando vulnerabilidades em dependências e bibliotecas de terceiros.

## Uso

```yaml
- uses: xguardian-actions/actions/sca@v26.6.1
  with:
    token: ${{ secrets.XGUARDIAN_TOKEN }}
    app_name: "minha-app"
    team_id: "[1]"
    languages: '["JavaScript"]'
```

## Inputs obrigatórios

| Input | Descrição |
|-------|-----------|
| `token` | PAT gerado na plataforma XGuardian |
| `app_name` | Nome da aplicação no XGuardian |
| `team_id` | ID(s) da equipe em JSON. Ex: `[1]` |
| `languages` | Linguagens em JSON array. Ex: `["JavaScript"]` |

## Inputs opcionais

| Input | Padrão | Descrição |
|-------|--------|-----------|
| `scan_directory` | `"."` | Diretório a ser zipado |
| `exclude` | `""` | Arquivos/diretórios a excluir. Ex: `"node_modules/,dist/"` |
| `translate` | `"false"` | Gera relatório em português do Brasil |
| `pdf` | `"false"` | Gera relatório em PDF |
| `policy_sca` | `"0"` | ID da política SCA (0 = padrão) |
| `get_scan_id` | `"false"` | Aguarda e retorna o ID do scan |
| `is_development` | `"false"` | Usa ambiente de desenvolvimento |

## Outputs

| Output | Descrição |
|--------|-----------|
| `app_id` | ID da aplicação no XGuardian |
| `scan_id` | ID do scan (requer `get_scan_id: "true"`) |
| `scan_url` | URL para visualizar os resultados |
| `scan_version` | Versão do scan (`app_name` + short SHA) |

Veja o exemplo completo em [pipeline.yml](./pipeline.yml).
