# xguardian-actions
Github Actions Implementation Repository

#This repository is being used to store the implementation script for the login, application verification/creation, and vulnerability scanning processes of XGuardian for Github Actions.

Este fluxo de trabalho do GitHub Actions automatiza o processo de login na API do XGuardian, armazenamento do token de usuário, verificação e criação de uma aplicação, e upload de um arquivo .zip para scan de vulnerabilidades SAST/SCA.

Autor: XGuardian
Versão: v1.0.0

- Entradas
  
API_EMAIL
Descrição: O e-mail para autenticação na API do XGuardian.
Obrigatório: true

API_PASSWORD
Descrição: A senha para autenticação na API do XGuardian.
Obrigatório: true

API_TOKEN
Descrição: O token de autenticação obtido durante o login.
Obrigatório: true

GH_TOKEN
Descrição: Token de acesso ao GitHub.
Obrigatório: true

APP_NAME
Descrição: Nome da aplicação.
Obrigatório: true

TEAM_ID
Descrição: ID da equipe.
Obrigatório: true

SCAN_VERSION
Descrição: Versão do scan.
Obrigatório: true

FILE_TYPE
Descrição: Tipo de arquivo para upload.
Obrigatório: true

UPLOAD_URL
Descrição: URL para upload do scan.
Obrigatório: true

- Acionadores do Fluxo de Trabalho
  
O fluxo de trabalho é acionado em pushes para a branch main (ou qualquer outra que o usuário preferir).

- Etapas do Fluxo de Trabalho

Verificar Código
Usa as GitHub Actions para verificar o repositório.

Script de Ações XGuardian
Usa o script de Ações XGuardian fornecido pelo usuário.

Login na API do XGuardian e Armazenar Token
Realiza o login na API usando curl e armazena o token como um segredo no GitHub.

Verificar e Criar Aplicação
Verifica se a aplicação existe; se não existir, a cria.

Obter ID da Aplicação
Recupera o ID da aplicação usando uma solicitação GET.

Usar ID da Aplicação em Outra Etapa
Define o ID da aplicação como uma variável de ambiente para etapas futuras.

Obter URL de Upload
Obtém a URL de upload para o scan de vulnerabilidades.

Compactar Arquivos
Compacta os arquivos da aplicação.

Upload da Aplicação para Scan
Usa curl para fazer o upload da aplicação para o scan SAST/SCA.
