# XGuardian — DAST Web

Executa análise dinâmica de aplicações web (DAST) com suporte a autenticação via formulário de login.

> **Importante:** `user_login` e `password_login` são as credenciais do **site alvo** — não da plataforma XGuardian.

## Uso

```yaml
- uses: xguardian-actions/actions/dast-web@v26.6.1
  with:
    token: ${{ secrets.XGUARDIAN_TOKEN }}
    app_name: "minha-app"
    team_id: "[1]"
    languages: '["JavaScript"]'
    site_url: "https://minha-app.exemplo.com"
    user_login: ${{ secrets.SITE_USER }}
    password_login: ${{ secrets.SITE_PASSWORD }}
```

## Inputs obrigatórios

| Input | Descrição |
|-------|-----------|
| `token` | PAT gerado na plataforma XGuardian |
| `app_name` | Nome da aplicação no XGuardian |
| `team_id` | ID(s) da equipe em JSON. Ex: `[1]` |
| `languages` | Linguagens em JSON array. Ex: `["JavaScript"]` |
| `site_url` | URL da aplicação web a ser escaneada |

## Inputs opcionais

| Input | Padrão | Descrição |
|-------|--------|-----------|
| `auth_exist` | `"false"` | Se `"true"`, usa login com formulário |
| `user_login` | `""` | Usuário do site alvo (quando `auth_exist: "true"`) |
| `password_login` | `""` | Senha do site alvo (quando `auth_exist: "true"`) |
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
