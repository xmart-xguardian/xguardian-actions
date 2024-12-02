# Scan Automático com XGuardian 🔍

Este Action é configurado para executar uma varredura de segurança usando o XGuardian sempre que houver um push na branch `main`. Ele verifica o código fonte, faz login na API do XGuardian, cria/verifica a existência de uma aplicação e realiza o upload dos arquivos para análise.

## Tópicos 📚

- [Pré-requisitos](#pré-requisitos-)
  - [Segredos Necessários](#segredos-necessários)
  - [Permissões do GitHub Token](#permissões-do-github-token)
  - [Parâmetros de Configuração](#parâmetros-de-configuração)
- [Outputs Disponíveis](#outputs-disponíveis-)
  - [Exemplo de Uso dos Outputs](#exemplo-de-uso-dos-outputs)
  - [Exemplo de Integração com Microsoft Teams](#exemplo-de-integração-com-microsoft-teams)
- [Execução](#execução-)
  - [Exemplo de Workflow Completo](#exemplo-de-workflow-completo)
- [Debugging](#debugging-)
- [Notas](#notas-)

## Pré-requisitos 📋

> ℹ️ Caso possua dúvidas sobre como adicionar os **segredos** e/ou **variáveis de ambiente**, acesse: [Creating secrets for a repository](https://docs.github.com/pt/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-a-repository)

### Segredos Necessários

| Nome do Segredo | Descrição                                                             | Obrigatório |
| --------------- | --------------------------------------------------------------------- | ----------- |
| `API_EMAIL`     | Email para login na API do XGuardian                                  | ✅          |
| `API_PASSWORD`  | Senha para login na API do XGuardian                                  | ✅          |
| `API_TOKEN`     | Token de autenticação da API (será gerado/atualizado automaticamente) | ✅          |
| `GH_TOKEN`      | Token de acesso fino do GitHub (deve começar com 'github*pat*')       | ✅          |

### Permissões do GitHub Token

O token do GitHub (`GH_TOKEN`) deve ser um fine-grained Personal Access Token (PAT) com as seguintes permissões mínimas:

| Escopo   | Permissão | Motivo                                                      |
| -------- | --------- | ----------------------------------------------------------- |
| Contents | Read      | Para acessar o código fonte do repositório                  |
| Metadata | Read      | Para acessar metadados do repositório (nome, SHA do commit) |
| Secrets  | Write     | Para atualizar o segredo `API_TOKEN` automaticamente        |

> **Importante**:
>
> - O token deve começar com `github_pat_`
> - Tokens clássicos não são suportados
> - Para criar um novo fine-grained PAT, acesse: [New fine-grained PAT](https://github.com/settings/personal-access-tokens/new)

### Parâmetros de Configuração

| Parâmetro            | Descrição                        | Obrigatório | Valor Padrão                                               |
| -------------------- | -------------------------------- | ----------- | ---------------------------------------------------------- |
| `app_name`           | Nome da aplicação                | ✅          | -                                                          |
| `scan_directory`     | Diretório a ser analisado        | ❌          | `.`                                                        |
| `team_id`            | ID(s) da(s) equipe(s)            | ❌          | `[1]`                                                      |
| `languages`          | Linguagem(ns) da aplicação       | ❌          | `["JavaScript"]`                                           |
| `description`        | Descrição da aplicação           | ❌          | `"Aplicação criada através do GitHub Actions - XGuardian"` |
| `policy_sast`        | ID da política SAST              | ❌          | `0`                                                        |
| `policy_sca`         | ID da política SCA               | ❌          | `0`                                                        |
| `policy_dast`        | ID da política DAST              | ❌          | `0`                                                        |
| `policy_container`   | ID da política Container         | ❌          | `0`                                                        |
| `microservices`      | Possui microserviços?            | ❌          | `false`                                                    |
| `microservices_data` | Dados dos microserviços          | ❌          | `[{"name": "MS1", "language": ["JavaScript"]}]`            |
| `sast`               | Executar scan SAST               | ❌          | `"true"`                                                   |
| `sca`                | Executar scan SCA                | ❌          | `"false"`                                                  |
| `translate`          | Traduzir relatório para PT-BR    | ❌          | `"false"`                                                  |
| `exclude`            | Padrões a serem excluídos        | ❌          | `""`                                                       |
| `pdf`                | Gerar relatório PDF detalhado    | ❌          | `"false"`                                                  |
| `save_vulns`         | Salvar vulnerabilidades no banco | ❌          | `false`                                                    |

## Outputs Disponíveis 📤

| Output         | Descrição                                                       |
| -------------- | --------------------------------------------------------------- |
| `app_id`       | ID da aplicação no XGuardian                                    |
| `scan_id`      | ID do scan executado                                            |
| `scan_url`     | URL para visualizar os resultados do scan                       |
| `scan_version` | Versão do scan (baseada no nome do repositório e SHA do commit) |

### Exemplo de Uso dos Outputs

```yaml
- name: Executar scan de segurança
  id: xguardian
  uses: xmart-xguardian/xguardian-actions@v24.12.0
  with:
    api_email: ${{ secrets.API_EMAIL }}
    api_password: ${{ secrets.API_PASSWORD }}
    api_token: ${{ secrets.API_TOKEN }}
    gh_token: ${{ secrets.GH_TOKEN }}
    app_name: ${{ github.event.repository.name }}
    # ... outros parâmetros de configuração (opcional)...

- name: Verificar resultados
  run: |
    echo "ID da Aplicação: ${{ steps.xguardian.outputs.app_id }}"
    echo "ID do Scan: ${{ steps.xguardian.outputs.scan_id }}"
    echo "URL dos Resultados: ${{ steps.xguardian.outputs.scan_url }}"
    echo "Versão do Scan: ${{ steps.xguardian.outputs.scan_version }}"
```

> **Nota**: Os outputs podem ser utilizados em steps subsequentes para integração com outras ferramentas ou para notificações personalizadas.

### Exemplo de Integração com Microsoft Teams

```yaml
- name: Notificar no Microsoft Teams
  uses: aliencube/microsoft-teams-actions@v0.8.0
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
            "value": "${{ steps.xguardian.outputs.app_id }}"
          },
          {
            "name": "Scan ID",
            "value": "${{ steps.xguardian.outputs.scan_id }}"
          },
          {
            "name": "Versão",
            "value": "${{ steps.xguardian.outputs.scan_version }}"
          }
        ],
        "potentialAction": [
          {
            "@type": "OpenUri",
            "name": "Ver Resultados",
            "targets": [
              {
                "os": "default",
                "uri": "${{ steps.xguardian.outputs.scan_url }}"
              }
            ]
          }
        ]
      }]
```

> **Nota**: Para utilizar esta integração, é necessário configurar um webhook no Microsoft Teams e adicioná-lo como segredo no repositório (`MS_TEAMS_WEBHOOK_URI`). [Saiba mais sobre webhooks do Microsoft Teams](https://learn.microsoft.com/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhook).

## Execução 🚀

Esta action pode ser utilizada em qualquer workflow do GitHub Actions. Para executá-la, você precisa referenciá-la em seu arquivo de workflow (`.github/workflows/seu-workflow.yml`).

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
        uses: xmart-xguardian/xguardian-actions@v24.12.0
        with:
          api_email: ${{ secrets.API_EMAIL }}
          api_password: ${{ secrets.API_PASSWORD }}
          api_token: ${{ secrets.API_TOKEN }}
          gh_token: ${{ secrets.GH_TOKEN }}
          app_name: ${{ github.event.repository.name }}
          # ... outros parâmetros de configuração (opcional)...
```

A action executa os seguintes passos:

1. Valida os inputs sensíveis (email, senha, tokens)
2. Instala dependências necessárias (curl, jq, zip, GitHub CLI)
3. Faz login na API do XGuardian e gerencia o token de autenticação
4. Verifica/cria a aplicação no XGuardian
5. Obtém URL de upload para o scan
6. Zipa os arquivos do projeto (excluindo .git, node_modules, etc.)
7. Faz upload do arquivo zipado
8. Obtém e valida o ID do scan
9. Salva vulnerabilidades no banco de dados (opcional)

### Exemplo de Workflow Completo

```yaml
name: Build and Security Scan

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:

jobs:
  build-and-scan:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      security-events: write

    steps:
      # Exemplo de como checar o código-fonte do repositório
      - name: Checar o código-fonte do repositório
        uses: actions/checkout@v4

      # Exemplo de como instalar e configurar o Node.js
      # - name: Setup Node.js
      #   uses: actions/setup-node@v4
      #   with:
      #     node-version: '20'
      #     cache: 'npm'

      # Exemplo de como instalar as dependências de uma aplicação Node.js
      # - name: Install dependencies
      #   run: npm ci

      # Exemplo de como buildar uma aplicação Node.js
      # - name: Build application
      #   run: npm run build
      # Assumindo que isso gera os arquivos em ./dist

      # Exemplo de como executar o XGuardian Security Scan
      - name: Executar scan de segurança
        id: xguardian
        uses: xmart-xguardian/xguardian-actions@v24.12.0
        with:
          api_email: ${{ secrets.API_EMAIL }}
          api_password: ${{ secrets.API_PASSWORD }}
          api_token: ${{ secrets.API_TOKEN }}
          gh_token: ${{ secrets.GH_TOKEN }}
          app_name: ${{ github.event.repository.name }}
          scan_directory: "." # Analisando todo o código-fonte por padrão
          # scan_directory: 'dist' # Descomente e ajuste se quiser analisar apenas o código buildado
          team_id: "[1]"
          languages: '["JavaScript"]'
          description: "Aplicação criada através do GitHub Actions - XGuardian"
          policy_sast: "0"
          policy_sca: "0"
          policy_dast: "0"
          policy_container: "0"
          microservices: "false"
          microservices_data: '[{"name": "MS1", "language": ["JavaScript"]}]'
          sast: "true"
          sca: "false"
          translate: "false"
          exclude: ".vtt"
          pdf: "false"
          save_vulns: "true"

      - name: Debug outputs
        run: |
          echo "app_id: ${{ steps.xguardian.outputs.app_id }}"
          echo "scan_id: ${{ steps.xguardian.outputs.scan_id }}"
          echo "scan_url: ${{ steps.xguardian.outputs.scan_url }}"

      # Exemplo de como checar os resultados do scan
      - name: Verificar status do scan
        if: always()
        env:
          APP_ID: ${{ steps.xguardian.outputs.app_id }}
          SCAN_ID: ${{ steps.xguardian.outputs.scan_id }}
          SCAN_URL: ${{ steps.xguardian.outputs.scan_url }}
        run: |
          if [ "${{ steps.xguardian.outcome }}" == "success" ]; then
            # Verificar se as variáveis estão definidas
            if [ -n "$APP_ID" ] && [ -n "$SCAN_ID" ] && [ -n "$SCAN_URL" ]; then
              echo "✅ Scan iniciado com sucesso!"
              echo "🆔 App ID: $APP_ID"
              echo "📝 Scan ID: $SCAN_ID"
              echo "📊 Resultados ficarão disponíveis em: $SCAN_URL"
            else
              echo "⚠️ Scan iniciado, mas algumas informações do output estão faltando:"
              echo "APP_ID: ${APP_ID:-'não definido'}"
              echo "SCAN_ID: ${SCAN_ID:-'não definido'}"
              echo "SCAN_URL: ${SCAN_URL:-'não definido'}"
              exit 1
            fi
          else
            echo "❌ Falha no scan de segurança"
            exit 1
          fi

      # Exemplo de como utilizar o Slack para notificar o resultado do scan
      # - name: Notificar no Slack
      #   uses: rtCamp/action-slack-notify@v2
      #   env:
      #     SLACK_WEBHOOK: secrets.SLACK_WEBHOOK
      #     SLACK_MESSAGE: |
      #       Build e Scan concluídos
      #       Repositório: github.repository
      #       Branch: github.ref_name
      #       Resultados: steps.xguardian.outputs.scan_url

      # Exemplo de como utilizar o Zoom Chat para notificar o resultado do scan
      # - name: Notificar no Zoom Chat
      #   run: |
      #     curl -X POST "https://zoom.us/v2/im/chat/messages" \
      #     -H "Authorization: Bearer ${{ secrets.ZOOM_CHAT_TOKEN " \
      #     -H "Content-Type: application/json" \
      #     -d '{
      #       "to_channel": "security-channel",
      #       "message": "🔒 Security Scan completed\nRepository: ${{ github.repository \nResults: ${{ steps.xguardian.outputs.scan_url "
      #     }'
```

## Debugging 🐞

- Mensagens de debug são impressas durante a execução para ajudar na identificação de problemas:
  - Validação de inputs (email, senha, tokens)
  - Estrutura do diretório e arquivos antes do zip
  - Tamanho e localização do arquivo zip
  - Payloads das requisições à API
  - Status das tentativas de obtenção do scan ID
  - Valores dos outputs finais
- Use o log do GitHub Actions para acompanhar o progresso e identificar erros
- Mensagens de erro específicas são exibidas com o prefixo `::error::`
- Notificações importantes são exibidas com o prefixo `::notice::`

## Notas 📝

- Certifique-se de que o repositório possui permissões adequadas para:
  - Acessar os segredos necessários (API_EMAIL, API_PASSWORD, API_TOKEN, GH_TOKEN)
  - Executar comandos com sudo para instalação de dependências
  - Criar e manipular arquivos temporários
- O token do GitHub deve ser um fine-grained PAT (começando com 'github*pat*')
- Por padrão, são excluídos do scan: `.git/`, `node_modules/`, `.env`, `*.zip`
- O parâmetro `exclude` pode ser usado para configurar exclusões adicionais
- O scan SAST é habilitado por padrão, enquanto SCA é desabilitado
- O tempo máximo de espera para obtenção do scan ID é de 5 minutos (30 tentativas)
