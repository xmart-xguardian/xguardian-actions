Lukin<div align="center">
  <img src="XGuardian.png" alt="XGuardian Logo" width="200"/>

  # XGuardian Security Action

  **Análises de segurança automatizadas direto do seu pipeline GitHub Actions**

  ![Versão](https://img.shields.io/badge/versão-v26.6.2-purple)
  ![GitHub Marketplace](https://img.shields.io/badge/GitHub-Marketplace-blue?logo=github)
  ![GitHub Actions](https://img.shields.io/badge/GitHub-Actions-2088FF?logo=github-actions&logoColor=white)
</div>

---

## Tipos de scan

| Scan | Descrição | README | Pipeline |
|------|-----------|--------|----------|
| **SAST + SCA** | Análise estática + dependências (um único upload) | [sast-sca/](sast-sca/README.md) | [pipeline.yml](sast-sca/pipeline.yml) |
| **SAST** | Análise estática de código-fonte | [sast/](sast/README.md) | [pipeline.yml](sast/pipeline.yml) |
| **SCA** | Análise de composição de software (dependências) | [sca/](sca/README.md) | [pipeline.yml](sca/pipeline.yml) |
| **DAST Web** | Análise dinâmica de aplicações web | [dast-web/](dast-web/README.md) | [pipeline.yml](dast-web/pipeline.yml) |
| **DAST API** | Análise dinâmica de APIs REST | [dast-api/](dast-api/README.md) | [pipeline.yml](dast-api/pipeline.yml) |
| **Container** | Scan de segurança em imagens Docker | [container/](container/README.md) | [pipeline.yml](container/pipeline.yml) |

---

## Requisitos

- **Runner:** `ubuntu-latest`
- **Dependências instaladas automaticamente:** `curl`, `jq`, `zip`
- **Para Container scan:** Docker deve estar disponível no runner e a imagem deve estar construída antes de chamar a action

---

## Credenciais

| Secret | Onde configurar | Usado por |
|--------|----------------|-----------|
| `XGUARDIAN_TOKEN` | Settings → Secrets → Actions | Todos os scans |
| `SITE_USER` / `SITE_PASSWORD` | Settings → Secrets → Actions | DAST Web (login por formulário) |
| `API_BEARER_TOKEN` | Settings → Secrets → Actions | DAST API (Bearer token da API alvo) |

> Gere o `XGUARDIAN_TOKEN` em: **XGuardian → Perfil → Tokens de Acesso**

---

## Uso rápido

```yaml
- uses: xguardian-actions/actions/sast-sca@v26.6.1
  with:
    token: ${{ secrets.XGUARDIAN_TOKEN }}
    app_name: "minha-app"
    team_id: "[1]"
    languages: '["JavaScript"]'
```

Para exemplos completos, acesse o README de cada scan na tabela acima.

### Fixando a versão (recomendado)

Sempre referencie uma versão estável, nunca `@main` (que muda a cada atualização):

```yaml
- uses: xguardian-actions/actions/sast-sca@v26.6.1   # tag estável (recomendado)
# - uses: xguardian-actions/actions/sast-sca@b526c5d  # SHA do commit (máxima imutabilidade)
```

Para a maior garantia de supply chain, fixe pelo SHA do commit da release — assim sua pipeline executa sempre exatamente o mesmo código auditado.

---

## Integrações externas

Pipelines de ingestão de ferramentas externas (ex: Sonatype IQ) estão disponíveis em:

**[xguardian-actions/integrations](https://github.com/xguardian-actions/integrations)**

---

## Licença

© 2026 XMART SOLUTIONS SEGURANCA DIGITAL LTDA - EPP. Todos os direitos reservados.

Software proprietário. O uso destas GitHub Actions é permitido **exclusivamente**
para integração com a plataforma XGuardian. É proibido copiar, redistribuir,
modificar ou utilizar a lógica destas actions para desenvolver produto ou serviço
concorrente. Consulte o arquivo [LICENSE](LICENSE) para os termos completos.
