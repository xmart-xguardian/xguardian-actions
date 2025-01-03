# Scan Automático com XGuardian 🔍

Este Action é configurado para executar uma varredura de segurança usando o XGuardian. Ele verifica o código fonte, faz login na API do XGuardian, cria/verifica a existência de uma aplicação e realiza o upload dos arquivos para análise.

> O Action suporta diferentes tipos de scans, incluindo SAST (Static Application Security Testing), SCA (Software Composition Analysis) e DAST (Dynamic Application Security Testing), permitindo uma análise abrangente da segurança do seu código. O usuário pode personalizar o workflow conforme suas necessidades, incluindo o step de varredura do XGuardian em qualquer ponto do seu workflow.

## Tópicos 📚

- [Pré-requisitos](#pré-requisitos-)
  - [Permissões do GitHub Token](#permissões-do-github-token)
  - [Segredos Necessários](#segredos-necessários)
  - [Parâmetros de Configuração](#parâmetros-de-configuração)
    - [Configurações para a criação da aplicação](#configurações-para-a-criação-da-aplicação)
    - [Scan SAST (Static Application Security Testing)](#scan-sast-static-application-security-testing)
    - [Scan SCA (Software Composition Analysis)](#scan-sca-software-composition-analysis)
    - [Scan DAST (Dynamic Application Security Testing)](#scan-dast-dynamic-application-security-testing)
    - [Outros](#outros)
- [Execução](#execução-)
  - [Exemplo de Scan SAST](#exemplo-de-scan-sast)
  - [Exemplo de Scan SCA](#exemplo-de-scan-sca)
  - [Exemplo de Scan DAST](#exemplo-de-scan-dast)
- [Outputs Disponíveis](#outputs-disponíveis-)
  - [Exemplo de uso dos outputs](#exemplo-de-uso-dos-outputs)
  - [Exemplo para notificar no Microsoft Teams](#exemplo-para-notificar-no-microsoft-teams)
  - [Exemplo para notificar no Slack](#exemplo-para-notificar-no-slack)

## Pré-requisitos 📋

### Permissões do GitHub Token

> **Importante**:
>
> - O token deve começar com `github_pat_`
> - Tokens clássicos não são suportados
> - Para criar um novo fine-grained PAT, acesse: [New fine-grained PAT](https://github.com/settings/personal-access-tokens/new)

O token do GitHub (`GH_TOKEN`) deve ser um fine-grained Personal Access Token (PAT) com as seguintes permissões mínimas:

| Escopo   | Permissão | Motivo                                                      |
| -------- | --------- | ----------------------------------------------------------- |
| Contents | Read      | Para acessar o código fonte do repositório                  |
| Metadata | Read      | Para acessar metadados do repositório (nome, SHA do commit) |
| Secrets  | Write     | Para atualizar o segredo `API_TOKEN` automaticamente        |

### Segredos Necessários

> ℹ️ Caso possua dúvidas sobre como adicionar os **segredos** e/ou **variáveis de ambiente**, acesse: [Creating secrets for a repository](https://docs.github.com/pt/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-a-repository)

| Nome do Segredo | Descrição                                                             | Obrigatório |
| --------------- | --------------------------------------------------------------------- | ----------- |
| `API_EMAIL`     | Email para login na API do XGuardian                                  | ✅          |
| `API_PASSWORD`  | Senha para login na API do XGuardian                                  | ✅          |
| `API_TOKEN`     | Token de autenticação da API (será gerado/atualizado automaticamente) | ✅          |
| `GH_TOKEN`      | Token de acesso fino do GitHub (deve começar com 'github*pat*')       | ✅          |

### Parâmetros de Configuração

> ℹ️ Os parâmetros são opcionais e podem ser configurados conforme a necessidade do usuário. Caso não sejam informados, serão utilizados valores padrão (default).

#### Configurações para a criação da aplicação

| Parâmetro            | Descrição                  | Valor Padrão                                               |
| -------------------- | -------------------------- | ---------------------------------------------------------- |
| `app_name`           | Nome da aplicação          | Nome do repositório                                        |
| `team_id`            | ID(s) da(s) equipe(s)      | `[1]`                                                      |
| `languages`          | Linguagem(ns) da aplicação | `["JavaScript"]`                                           |
| `description`        | Descrição da aplicação     | `"Aplicação criada através do GitHub Actions - XGuardian"` |
| `microservices`      | Possui microserviços?      | `false`                                                    |
| `microservices_data` | Dados dos microserviços    | `[{"name": "MS1", "language": ["JavaScript"]}]`            |

#### Scan SAST (Static Application Security Testing)

| Parâmetro     | Descrição           | Valor Padrão |
| ------------- | ------------------- | ------------ |
| `sast`        | Executar scan SAST  | `"true"`     |
| `policy_sast` | ID da política SAST | `0`          |

#### Scan SCA (Software Composition Analysis)

| Parâmetro    | Descrição          | Valor Padrão |
| ------------ | ------------------ | ------------ |
| `sca`        | Executar scan SCA  | `"false"`    |
| `policy_sca` | ID da política SCA | `0`          |

#### Scan DAST (Dynamic Application Security Testing)

| Parâmetro        | Descrição                     | Valor Padrão |
| ---------------- | ----------------------------- | ------------ |
| `dast`           | Executar scan DAST            | `"false"`    |
| `policy_dast`    | ID da política DAST           | `0`          |
| `site_url`       | URL do site para o scan DAST  | `""`         |
| `auth_url`       | URL de autenticação para DAST | `""`         |
| `logout_url`     | URL de logout para DAST       | `""`         |
| `auth_exist`     | O site possui autenticação?   | `false`      |
| `user_login`     | Usuário para autenticação     | `""`         |
| `password_login` | Senha para autenticação       | `""`         |

#### Outros

| Parâmetro        | Descrição                         | Valor Padrão                        |
| ---------------- | --------------------------------- | ----------------------------------- |
| `translate`      | Traduzir relatório para PT-BR     | `"false"`                           |
| `exclude`        | Padrões a serem excluídos         | `".log", ".git"`                    |
| `pdf`            | Gerar relatório PDF detalhado     | `"false"`                           |
| `save_vulns`     | Salvar vulnerabilidades no banco  | `false`                             |
| `scan_directory` | Diretório a ser analisado         | `.` (diretório raiz do repositório) |
| `get_scan_id`    | Buscar o ID do Scan após o upload | `"false"`                           |

## Execução 🚀

Essa action pode ser utilizada em qualquer workflow do GitHub Actions. Para executá-la, você precisa referenciá-la em seu arquivo de workflow (`.github/workflows/seu-workflow.yml`).

Por exemplo, para executar em pushes na branch main:

```yaml
name: Security Scan
on:
  push:
    branches:
      - main

jobs:
  security-scan:
    runs-on: ubuntu-latest
    steps:
      # Checkout do código fonte
      - uses: actions/checkout@v4

      # Execução do scan
      - name: XGuardian Security Scan
        uses: xmart-xguardian/xguardian-actions@main
        with:
          api_email: ${{ secrets.API_EMAIL }}
          api_password: ${{ secrets.API_PASSWORD }}
          api_token: ${{ secrets.API_TOKEN }}
          gh_token: ${{ secrets.GH_TOKEN }}
          app_name: ${{ github.event.repository.name }}
          # ... outros parâmetros de configuração ...
```

### Exemplo de Scan SAST

```yaml
name: Security SAST Scan
on:
  push:
    branches:
      - main

jobs:
  security-sast-scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checar o código-fonte do repositório
        uses: actions/checkout@v4

      # Execução do scan
      - name: XGuardian Security Scan
        uses: xmart-xguardian/xguardian-actions@main
        with:
          api_email: ${{ secrets.API_EMAIL }}
          api_password: ${{ secrets.API_PASSWORD }}
          api_token: ${{ secrets.API_TOKEN }}
          gh_token: ${{ secrets.GH_TOKEN }}
          app_name: ${{ github.event.repository.name }}
          scan_directory: "." # Analisando todo o código-fonte por padrão
          # scan_directory: 'dist' # Descomente e ajuste se quiser analisar apenas o código buildado
          team_id: "[1]" # Time/equipe número um (1)
          languages: '["TypeScript", "JavaScript"]' # Linguagens do aplicação
          description: "Exemplo de Scan SAST" # Descrição da aplicação
          policy_sast: "0" # ID da politica para scan SAST; "0" = nenhuma politica definida
          microservices: "false" # Caso a aplicação possua microserviços
          microservices_data: '[{"name": "Server Node.js", "language": ["JavaScript"]}]' # Dados dos microserviços (nome e linguagem)
          sast: "true"
```

### Exemplo de Scan SCA

```yaml
name: Security SCA Scan
on:
  push:
    branches:
      - main

jobs:
  security-sast-scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checar o código-fonte do repositório
        uses: actions/checkout@v4

      # Execução do scan
      - name: XGuardian Security Scan
        uses: xmart-xguardian/xguardian-actions@main
        with:
          api_email: ${{ secrets.API_EMAIL }}
          api_password: ${{ secrets.API_PASSWORD }}
          api_token: ${{ secrets.API_TOKEN }}
          gh_token: ${{ secrets.GH_TOKEN }}
          app_name: ${{ github.event.repository.name }}
          scan_directory: "." # Analisando todo o código-fonte por padrão; raiz do projeto/repositório
          # scan_directory: 'dist' # Descomente e ajuste se quiser analisar apenas o código buildado
          team_id: "[1]" # Time/equipe número um (1)
          languages: '["TypeScript", "JavaScript"]' # Linguagens do aplicação
          description: "Exemplo de Scan SCA" # Descrição da aplicação
          policy_sca: "0" # ID da politica para scan SCA; "0" = nenhuma politica definida
          microservices: "false" # Caso a aplicação possua microserviços
          microservices_data: '[{"name": "Server Node.js", "language": ["JavaScript"]}]' # Dados dos microserviços (nome e linguagem)
          sca: "true"
```

### Exemplo de Scan DAST

```yaml
name: Security DAST Scan
on:
  push:
    branches:
      - main

jobs:
  security-sast-scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checar o código-fonte do repositório
        uses: actions/checkout@v4

      # Execução do scan
      - name: XGuardian Security Scan
        uses: xmart-xguardian/xguardian-actions@main
        with:
          api_email: ${{ secrets.API_EMAIL }}
          api_password: ${{ secrets.API_PASSWORD }}
          api_token: ${{ secrets.API_TOKEN }}
          gh_token: ${{ secrets.GH_TOKEN }}
          app_name: ${{ github.event.repository.name }}
          dast: "true"
          policy_dast: "0" # ID da politica para scan DAST; "0" = nenhuma politica definida
          site_url: "https://example.com" # URL do site para o scan DAST
          auth_url: "https://example.com/login" # URL de autenticação para DAST
          logout_url: "https://example.com/logout" # URL de logout para DAST
          auth_exist: "true" # O site possui autenticação?
          user_login: "user" # Usuário para autenticação
          password_login: "password" # Senha para autenticação
```

## Outputs Disponíveis 📤

| Output         | Descrição                                                           |
| -------------- | ------------------------------------------------------------------- |
| `app_id`       | ID da aplicação no XGuardian                                        |
| `scan_id`      | ID do scan executado                                                |
| `scan_url`     | URL para visualizar os resultados do scan                           |
| `scan_version` | Versão/Nome do scan (template: nome do repositório + SHA do commit) |

### Exemplo de uso dos outputs

```yaml
- name: Executar scan de segurança
  id: xguardian
  uses: xmart-xguardian/xguardian-actions@main
  with:
    api_email: ${{ secrets.API_EMAIL }}
    api_password: ${{ secrets.API_PASSWORD }}
    api_token: ${{ secrets.API_TOKEN }}
    gh_token: ${{ secrets.GH_TOKEN }}
    app_name: ${{ github.event.repository.name }}
    # ... outros parâmetros de configuração ...

- name: Debugando outputs
  run: |
    echo "app_id: ${{ steps.xguardian.outputs.app_id }}"
    echo "scan_id: ${{ steps.xguardian.outputs.scan_id }}"
    echo "scan_url: ${{ steps.xguardian.outputs.scan_url }}"
    echo "scan_version: ${{ steps.xguardian.outputs.scan_version }}"

# Exemplo de como checar os resultados do scan
- name: Verificar status do scan
  if: always()
  env:
    APP_ID: ${{ steps.xguardian.outputs.app_id }}
    SCAN_ID: ${{ steps.xguardian.outputs.scan_id }}
    SCAN_URL: ${{ steps.xguardian.outputs.scan_url }}
    SCAN_VERSION: ${{ steps.xguardian.outputs.scan_version }}
  run: |
    if [ "${{ steps.xguardian.outcome }}" == "success" ]; then
      # Verificar se as variáveis estão definidas
      if [ -n "$APP_ID" ] && [ -n "$SCAN_ID" ] && [ -n "$SCAN_URL" ]; then
        echo "✅ Scan iniciado com sucesso!"
        echo "🆔 App ID: $APP_ID"
        echo "📝 Scan ID: $SCAN_ID"
        echo "🔖 Nome do Scan: $SCAN_VERSION"
        echo "📊 Resultados ficarão disponíveis em: $SCAN_URL"
      else
        echo "⚠️ Scan iniciado, mas algumas informações do output estão faltando:"
        echo "APP_ID: ${APP_ID:-'não definido'}"
        echo "SCAN_ID: ${SCAN_ID:-'não definido'}"
        echo "SCAN_URL: ${SCAN_URL:-'não definido'}"
        echo "SCAN_VERSION: ${SCAN_VERSION:-'não definido'}"
        exit 1
      fi
    else
      echo "❌ Falha no scan de segurança"
      exit 1
    fi
```

> **Nota**: Os outputs podem ser utilizados em steps subsequentes para integração com outras ferramentas ou para notificações personalizadas.

### Exemplo para notificar no Microsoft Teams

```yaml
- name: Notificar no Microsoft Teams
  uses: aliencube/microsoft-teams-actions@v0.8.0
  env:
    APP_ID: ${{ steps.xguardian.outputs.app_id }}
    SCAN_ID: ${{ steps.xguardian.outputs.scan_id }}
    SCAN_URL: ${{ steps.xguardian.outputs.scan_url }}
    SCAN_VERSION: ${{ steps.xguardian.outputs.scan_version }}
  with:
    webhook_uri: ${{ secrets.MS_TEAMS_WEBHOOK_URI }}
    title: "Scan de Segurança XGuardian"
    summary: "Resultados do scan de segurança concluído"
    theme_color: "0076D7"
    sections: |
      [{
        "activityTitle": "Scan de Segurança Finalizado",
        "activitySubtitle": "${{ github.repository }} - ${{ github.ref_name }}",
        "facts": [
          {
            "name": "Status",
            "value": "${{ job.status }}"
          },
          {
            "name": "Aplicação",
            "value": "${{ APP_ID }}"
          },
          {
            "name": "Scan ID",
            "value": "${{ SCAN_ID }}"
          },
          {
            "name": "Versão",
            "value": "${{ SCAN_VERSION }}"
          }
        ],
        "potentialAction": [
          {
            "@type": "OpenUri",
            "name": "Ver Resultados",
            "targets": [
              {
                "os": "default",
                "uri": "${{ SCAN_URL }}"
              }
            ]
          }
        ]
      }]
```

> **Nota**: Para utilizar esta integração, é necessário configurar um webhook no Microsoft Teams e adicioná-lo como segredo no repositório (`MS_TEAMS_WEBHOOK_URI`). [Saiba mais sobre webhooks do Microsoft Teams](https://learn.microsoft.com/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhook).

### Exemplo para notificar no Slack

```yaml
- name: Notificar no Slack
  uses: rtCamp/action-slack-notify@v2
  env:
    SLACK_WEBHOOK: secrets.SLACK_WEBHOOK
    SLACK_MESSAGE: |
      Build e Scan concluídos
      Repositório: github.repository
      Branch: github.ref_name
      Resultados: steps.xguardian.outputs.scan_url
```
