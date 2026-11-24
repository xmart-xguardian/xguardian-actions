# XGuardian — DAST API

Executa análise dinâmica de APIs REST (DAST) com autenticação via Bearer token.

> **Importante:** `api_token` é o Bearer token da **API alvo** — não da plataforma XGuardian.

## Uso

```yaml
- uses: xguardian-actions/actions/dast-api@v26.6.1
  with:
    token: ${{ secrets.XGUARDIAN_TOKEN }}
    app_name: "minha-api"
    team_id: "[1]"
    languages: '["JavaScript"]'
    site_url: "https://api.minha-app.exemplo.com"
    api_token: ${{ secrets.API_BEARER_TOKEN }}
```

## Inputs obrigatórios

| Input | Descrição |
|-------|-----------|
| `token` | PAT gerado na plataforma XGuardian |
| `app_name` | Nome da aplicação no XGuardian |
| `team_id` | ID(s) da equipe em JSON. Ex: `[1]` |
| `languages` | Linguagens em JSON array. Ex: `["JavaScript"]` |
| `site_url` | URL base da API a ser escaneada |
| `api_token` | Bearer token para autenticação na API alvo |

## Inputs opcionais

| Input | Padrão | Descrição |
|-------|--------|-----------|
| `translate` | `"false"` | Gera relatório em português do Brasil |
| `pdf` | `"false"` | Gera relatório em PDF |
| `policy_dast` | `"0"` | ID da política DAST (0 = padrão) |
| `is_development` | `"false"` | Usa ambiente de desenvolvimento |

## Outputs

| Output | Descrição |
|--------|-----------|
| `app_id` | ID da aplicação no XGuardian |
| `scan_id` | ID do scan iniciado |
| `scan_url` | URL para visualizar os resultados |

Veja o exemplo completo em [pipeline.yml](./pipeline.yml).
