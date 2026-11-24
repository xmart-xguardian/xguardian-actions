# XGuardian — Container Scan

Executa análise de segurança de imagens Docker. A action salva a imagem como `.tar` internamente e faz o upload para o XGuardian — nenhuma etapa extra é necessária.

## Pré-requisito

A imagem Docker deve estar disponível no runner antes de chamar esta action. Execute o `docker build` (ou `docker pull`) antes:

```yaml
- name: Build da imagem
  run: docker build -t minha-app:${{ github.sha }} .

- uses: xguardian-actions/actions/container@v26.6.1
  with:
    token: ${{ secrets.XGUARDIAN_TOKEN }}
    app_name: "minha-app"
    team_id: "[1]"
    languages: '["JavaScript"]'
    container_image: "minha-app:${{ github.sha }}"
```

## Inputs obrigatórios

| Input | Descrição |
|-------|-----------|
| `token` | PAT gerado na plataforma XGuardian |
| `app_name` | Nome da aplicação no XGuardian |
| `team_id` | ID(s) da equipe em JSON. Ex: `[1]` |
| `languages` | Linguagens em JSON array. Ex: `["JavaScript"]` |
| `container_image` | Nome e tag da imagem Docker. Ex: `minha-app:latest` |

## Inputs opcionais

| Input | Padrão | Descrição |
|-------|--------|-----------|
| `translate` | `"false"` | Gera relatório em português do Brasil |
| `pdf` | `"false"` | Gera relatório em PDF |
| `policy_container` | `"0"` | ID da política de container (0 = padrão) |
| `is_development` | `"false"` | Usa ambiente de desenvolvimento |

## Outputs

| Output | Descrição |
|--------|-----------|
| `app_id` | ID da aplicação no XGuardian |
| `scan_url` | URL para visualizar os resultados |

Veja o exemplo completo em [pipeline.yml](./pipeline.yml).
