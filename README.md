# Scan Automático com XGuardian 🔍

Este Action é configurado para executar uma varredura de segurança usando o XGuardian sempre que houver um push na branch `main`. Ele verifica o código fonte, faz login na API do XGuardian, cria/verifica a existência de uma aplicação e realiza o upload dos arquivos para análise.

## Tópicos 📚

- [Pré-requisitos](#pré-requisitos-)
  - [Segredos](#segredos)
  - [Variáveis de Ambiente](#variáveis-de-ambiente)
- [Configuração](configura%C3%A7%C3%A3o-%EF%B8%8F)
- [Execução](#execução-)
- [Debugging](#debugging-)
- [Notas](#notas-)

## Pré-requisitos 📋

> ℹ️ Caso possua dúvidas sobre como adicionar os **segredos** e/ou **variáveis de ambiente**, acesse: [Creating secrets for a repository](https://docs.github.com/pt/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-a-repository) ou [Creating configuration variables for a repository](https://docs.github.com/pt/actions/writing-workflows/choosing-what-your-workflow-does/store-information-in-variables#creating-configuration-variables-for-a-repository)

### Segredos

Certifique-se de que os seguintes segredos estão configurados no repositório:

| Nome do Segredo | Descrição                                                                                                                                                                                                                                                                           | Obrigatório |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| `API_TOKEN`     | Token de autenticação para a API do XGuardian; criar um segredo com qualquer valor, será sobrescrito durante a execução.                                                                                                                                                            | ✔️          |
| `GH_TOKEN`      | Token de autenticação do GitHub; para mais informações, acesse: [creating a fine-grained personal access token](https://docs.github.com/pt/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token). | ✔️          |
| `API_EMAIL`     | Email para login na API; o mesmo utilizado na plataforma do XGuardian.                                                                                                                                                                                                              | ✔️          |
| `API_PASSWORD`  | Senha para login na API; a mesma utilizada na plataforma do XGuardian.                                                                                                                                                                                                              | ✔️          |

### Variáveis de Ambiente

| Variável             | Descrição                                                  | Obrigatório | Padrão                                                                                                                                |
| -------------------- | ---------------------------------------------------------- | ----------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `APP_NAME`           | O nome da aplicação.                                       | ✔️          | Nome do repositório do GitHub                                                                                                         |
| `TEAM_ID`            | O(s) ID(s) da(s) equipe(s).                                | ✔️          | `[1]`                                                                                                                                 |
| `LANGUAGES`          | A(s) linguagem(ns) da aplicação.                           | ✔️          | `["JavaScript"]`                                                                                                                      |
| `DESCRIPTION`        | A descrição da aplicação.                                  | ✔️          | `"Aplicação criada através do GitHub Actions - XGuardian"`                                                                            |
| `POLICY_SAST`        | O ID da política de SAST.                                  | ❌          | `0`                                                                                                                                   |
| `POLICY_SCA`         | O ID da política de SCA.                                   | ❌          | `0`                                                                                                                                   |
| `POLICY_DAST`        | O ID da política de DAST.                                  | ❌          | `0`                                                                                                                                   |
| `POLICY_CONTAINER`   | O ID da política de Container.                             | ❌          | `0`                                                                                                                                   |
| `MICROSERVICES`      | A aplicação possui microserviços?                          | ❌          | `false`                                                                                                                               |
| `MICROSERVICES_DATA` | O(s) dados do(s) microserviço(s): Nome(s) e linguagem(ns). | ❌          | `[{"name": "MS1", "language": ["JavaScript"]}, {"name": "MS2", "language": ["TypeScript"]}, {"name": "MS3", "language": ["Python"]}]` |
| `SAST`               | Vai ser feito o scan SAST?                                 | ✔️          | `"true"`                                                                                                                              |
| `SCA`                | Vai ser feito o scan SCA?                                  | ✔️          | `"true"`                                                                                                                              |
| `TRANSLATE`          | O relatório será traduzido para o português do Brasil?     | ❌          | `"false"`                                                                                                                             |
| `EXCLUDE`            | Diretórios ou arquivos a serem excluídos do scan.          | ❌          | `""`                                                                                                                                  |
| `PDF`                | O relatório será gerado em PDF detalhado?                  | ❌          | `"false"`                                                                                                                             |

## Configuração ⚙️

1. **Node.js**: O workflow utiliza a versão mais recente do Node.js. Certifique-se de que todas as dependências do projeto são compatíveis com a versão mais recente.

2. **Linguagens e Políticas**: No bloco de criação da aplicação, você pode definir as linguagens suportadas e as políticas de segurança (SAST, SCA, DAST, Container). Ajuste conforme necessário.

3. **Microserviços**: Se o projeto utiliza microserviços, ajuste a variável `MICROSERVICES` para `true` e forneça os dados dos microserviços em `MICROSERVICES_DATA`.

## Execução 🚀

- **Trigger**: O workflow é acionado automaticamente em cada push na branch `main`.
- **Passos**:
  1. Configura o ambiente Node.js.
  2. Faz checkout do código fonte.
  3. Faz login na API do XGuardian e obtém um token de autenticação.
  4. Verifica ou cria a aplicação no XGuardian.
  5. Obtém a URL de upload para o scan.
  6. Zipa os arquivos do projeto, excluindo diretórios e arquivos desnecessários.
  7. Faz o upload do arquivo zipado para a URL de upload.

## Debugging 🐞

- Mensagens de debug são impressas durante a execução para ajudar na identificação de problemas.
- Verifique os logs do GitHub Actions para detalhes sobre falhas ou erros.

## Notas 📝

- Certifique-se de que o repositório possui permissões adequadas para acessar os segredos e realizar as operações necessárias.
- Ajuste as configurações de exclusão de arquivos e diretórios conforme necessário para o seu projeto.
