# Gerenciamento de Infraestrutura com Terraform e GitHub Actions

Este documento descreve o pipeline de CI/CD para gerenciar nossa infraestrutura como código (IaC) usando Terraform e GitHub Actions. O processo é automatizado para garantir consistência, segurança e agilidade nos deploys dos ambientes de desenvolvimento (`dev`) e produção (`prod`).

## Visão Geral

O sistema é composto por dois tipos de workflows:

1.  **Workflows Principais**: Acionados por eventos no repositório (push, pull request, manual).
2.  **Workflows Reutilizáveis**: Contêm a lógica do Terraform (`init`, `plan`, `apply`, `destroy`) e são chamados pelos workflows principais.

-----

## Workflows Principais

### 1\. Pipeline de CI/CD Automático (`ci-cd-pipeline.yml`)

Este é o workflow principal que automatiza a validação e o deploy da infraestrutura. Ele é acionado por pushes e pull requests em branches específicas.

#### Como Funciona

O comportamento do pipeline depende do evento e da branch:

| Evento | Branch | Ação Executada | Ambiente Alvo |
| :--- | :--- | :--- | :--- |
| `Pull Request` | `main` ou `develop` | **Validação**: `terraform init`, `validate` e `plan` | `prod` ou `dev` |
| `Push` | `feature/**` | **Validação**: `terraform init`, `validate` e `plan` | `dev` |
| `Push` (merge) | `develop` | **Deploy**: `terraform init`, `plan` e `apply` | `dev` |
| `Push` (merge) | `main` | **Deploy**: `terraform init`, `plan` e `apply` | `prod` |

**Objetivo**:

  - **Segurança**: Nenhuma alteração é aplicada sem antes ser validada (`plan`) em um Pull Request.
  - **Agilidade**: Desenvolvedores recebem feedback rápido sobre suas alterações em branches de `feature`.
  - **Consistência**: O deploy para `dev` e `prod` é automatizado e padronizado após o merge.

### 2\. Destruição Manual de Infraestrutura (`manual-destroy-infra.yml`)

Para evitar a exclusão acidental, a destruição de um ambiente é uma ação **crítica e manual**, que só pode ser iniciada através da interface do GitHub.

#### Passos para Execução

1.  **Acesse a Aba "Actions"**: No repositório do GitHub, navegue até a aba **Actions**.

2.  **Selecione o Workflow**: Na lista de workflows à esquerda, clique em **"MANUAL - Destroy Terraform Infra"**.

3.  **Inicie a Execução**: Clique no botão **"Run workflow"** que aparece no lado direito da tela.

4.  **Preencha os Parâmetros**: Um formulário será exibido. Preencha os campos obrigatórios:

      * **Use workflow from**: Selecione a branch que contém o código do workflow (geralmente `main` ou `develop`).
      * **Ambiente que será destruído**: Escolha no menu suspenso o ambiente que deseja destruir (`dev` ou `prod`).
      * **Digite "destruir" para confirmar a operação.**: No campo de texto, digite a palavra `destruir`. **Esta é uma trava de segurança obrigatória.** Se a palavra estiver incorreta, a ação será cancelada.

5.  **Confirme a Ação**: Clique no botão verde **"Run workflow"** para iniciar o processo de destruição. Você poderá acompanhar o log de execução em tempo real.

-----

## Configuração Necessária

Para que os workflows funcionem corretamente, a seguinte configuração deve estar presente no repositório.

### 1\. GitHub Secrets

Acesse `Settings > Secrets and variables > Actions` no seu repositório e configure os seguintes segredos:

  - `DEV_AWS_ASSUME_ROLE_ARN`: Contém o ARN do IAM Role que o GitHub usará para autenticar na conta AWS de **desenvolvimento**.
  - `PROD_AWS_ASSUME_ROLE_ARN`: Contém o ARN do IAM Role para autenticar na conta AWS de **produção**.

### 2\. Permissões na AWS

As IAM Roles especificadas nos segredos acima devem ter:

1.  **Permissões Suficientes**: para criar, alterar e remover todos os recursos gerenciados pelo Terraform.
2.  **Política de Confiança (Trust Policy)**: configurada para permitir que o provedor OIDC do GitHub (`sts.amazonaws.com:sub`) assuma a role.

-----

## Estrutura dos Arquivos

Todos os workflows estão localizados no diretório `.github/workflows/`:

```
.github/
└── workflows/
    ├── ci-cd-pipeline.yml         # Workflow principal de CI/CD
    ├── manual-destroy-infra.yml   # Workflow para destruição manual
    ├── terraform-apply.yml        # Ação reutilizável de Apply
    ├── terraform-destroy.yml      # Ação reutilizável de Destroy
    └── terraform-validate.yml     # Ação reutilizável de Validate
```