# XGuardian Actions

Github Actions Implementation Repository

🇺🇸 This repository is being used to store the implementation script for the login, application verification/creation, and vulnerability scanning processes of XGuardian for Github Actions.

🇧🇷 Este fluxo de trabalho do GitHub Actions automatiza o processo de login na API do XGuardian, armazenamento do token de usuário, verificação e criação de uma aplicação, e upload de um arquivo .zip para scan de vulnerabilidades SAST/SCA.

- **Autor:** XGuardian
- **Versão:** v24.11.0

## Entradas

### `API_EMAIL`

- **Descrição:** O e-mail para autenticação na API do XGuardian.
- **Obrigatório:** Sim
- **Observações:** É necessário armazenar esse dado (seu e-mail de login na plataforma do XGuardian) no secrets do Github. Se necessário, veja a documentação do Github em <https://docs.github.com/pt/actions/security-guides/using-secrets-in-github-actions>

### `API_PASSWORD`

- **Descrição:** A senha para autenticação na API do XGuardian.
- **Obrigatório:** Sim
- **Observações:** É necessário armazenar esse dado (sua senha de login na plataforma do XGuardian) no secrets do Github. Se necessário, veja a documentação do Github em <https://docs.github.com/pt/actions/security-guides/using-secrets-in-github-actions>

### `API_TOKEN`

- **Descrição:** O token de autenticação obtido durante o login.
- **Obrigatório:** Sim
- **Observações:** É necessário armazenar esse dado no secrets do Github, com o valor vazio (ou um espaço), para que o XGuardian possa armazenar o token de autenticação. Se necessário, veja a documentação do Github em <https://docs.github.com/pt/actions/security-guides/using-secrets-in-github-actions>

### `GH_TOKEN`

- **Descrição:** Token de acesso ao GitHub.
- **Obrigatório:** Sim
- **Observações:** Crie previamente um token de acesso a seus repositórios. Se necessário, veja a documentação do Github em <https://docs.github.com/en/enterprise-server@3.6/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens>

### `APP_NAME`

- **Descrição:** Nome da aplicação na qual o scan será gerado.
- **Obrigatório:** Sim

### `TEAM_ID`

- **Descrição:** ID da equipe na qual a aplicação será criada.
- **Obrigatório:** Sim

### `SCAN_VERSION`

- **Descrição:** Versão do scan.
- **Obrigatório:** Sim
- **Observações:** A cada push realizado em seu repositório, é necessário alterar esse dado, pois o XGuardian valida se o nome do scan já existe ou não. Caso ele já exista, ocorrerá um erro e o scan não poderá ser criado.

### `FILE_TYPE`

- **Descrição:** Tipo de arquivo para upload.
- **Obrigatório:** Sim
- **Observações:** O padrão .zip que o XGuardian aceita já está configurado no script, não é necessárioo alterá-lo.

### `UPLOAD_URL`

- **Descrição:** URL para upload do scan.
- **Obrigatório:** Sim
- **Observações:** Variável criada previamente para atribuição da URL de upload do scan, pode-se atribuir qualquer valor, pois ela será sobrescrita posteriormente. Faz parte do processo de upload do arquivo.

## Acionadores do Fluxo de Trabalho

O fluxo de trabalho é acionado em pushes para a branch main (ou qualquer outra que o usuário preferir).

## Etapas do Fluxo de Trabalho

### Verificar Código

Usa as GitHub Actions para verificar o repositório.

### Script de Ações XGuardian

Usa o script de Ações XGuardian fornecido pelo usuário.

### Login na API do XGuardian e Armazenar Token

Realiza o login na API usando curl e armazena o token como um segredo no GitHub.

### Verificar e Criar Aplicação

Verifica se a aplicação existe; se não existir, a cria.

### Obter ID da Aplicação

Recupera o ID da aplicação usando uma solicitação GET.

### Usar ID da Aplicação em Outra Etapa

Define o ID da aplicação como uma variável de ambiente para etapas futuras.

### Obter URL de Upload

Obtém a URL de upload para o scan de vulnerabilidades.

### Compactar Arquivos

Compacta os arquivos da aplicação.

### Upload da Aplicação para Scan

Usa curl para fazer o upload da aplicação para o scan SAST/SCA.
