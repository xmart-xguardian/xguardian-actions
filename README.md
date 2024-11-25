# Workflow de Scanning com XGuardian

Este workflow é configurado para executar uma varredura de segurança usando o XGuardian sempre que houver um push na branch `main`. Ele verifica o código fonte, faz login na API do XGuardian, cria ou verifica a existência de uma aplicação, e realiza o upload dos arquivos para análise.

## Pré-requisitos

- **GitHub Secrets**: Certifique-se de que os seguintes segredos estão configurados no repositório:
  - `API_TOKEN`: Token de autenticação para a API do XGuardian.
  - `GH_TOKEN`: Token de autenticação do GitHub.
  - `API_EMAIL`: Email para login na API do XGuardian.
  - `API_PASSWORD`: Senha para login na API do XGuardian.

## Configuração

1. **Node.js**: O workflow utiliza a versão mais recente do Node.js. Certifique-se de que todas as dependências do projeto são compatíveis com a versão mais recente.

2. **Linguagens e Políticas**: No bloco de criação da aplicação, você pode definir as linguagens suportadas e as políticas de segurança (SAST, SCA, DAST, Container). Ajuste conforme necessário.

3. **Microserviços**: Se o projeto utiliza microserviços, ajuste a variável `MICROSERVICES` para `true` e forneça os dados dos microserviços em `MICROSERVICES_DATA`.

## Execução

- **Trigger**: O workflow é acionado automaticamente em cada push na branch `main`.
- **Passos**:
  1. Configura o ambiente Node.js.
  2. Faz checkout do código fonte.
  3. Faz login na API do XGuardian e obtém um token de autenticação.
  4. Verifica ou cria a aplicação no XGuardian.
  5. Obtém a URL de upload para o scan.
  6. Zipa os arquivos do projeto, excluindo diretórios e arquivos desnecessários.
  7. Faz o upload do arquivo zipado para a URL de upload.

## Debugging

- Mensagens de debug são impressas durante a execução para ajudar na identificação de problemas.
- Verifique os logs do GitHub Actions para detalhes sobre falhas ou erros.

## Notas

- Certifique-se de que o repositório possui permissões adequadas para acessar os segredos e realizar as operações necessárias.
- Ajuste as configurações de exclusão de arquivos e diretórios conforme necessário para o seu projeto.
