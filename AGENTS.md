# Diretrizes e Skills de IA - NotifyUploadComplete

> **Contexto:** Python (Serviço de Confirmação de Upload)  
> Este repositório está configurado com skills modulares de engenharia para orientar agentes de Inteligência Artificial (Claude Code, Antigravity, Cursor, Copilot, Codex, etc.) em manutenções corretivas e evolutivas.

---

## 📌 Regras de Engajamento para Agentes de IA

1. **Consulte as Skills antes de codificar:** Antes de realizar alterações estruturais, correções de bugs ou novas implementações, carregue e siga as instruções contidas no diretório `.agents/skills/<nome-da-skill>/SKILL.md`.
2. **Desenvolvimento Orientado a Testes (TDD):** Para qualquer correção de bug, utilize a skill `diagnosing-bugs` criando primeiro um teste reprodutor que falhe antes de tocar na lógica de produção.
3. **Design e Qualidade:** Mantenha os módulos desacoplados seguindo a skill `codebase-design`.
4. **Continuidade de Sessão:** Ao concluir ou pausar uma sessão de trabalho complexa, gere o resumo estruturado utilizando a skill `handoff`.

---

## 🛠️ Skills Instaladas no Repositório

As skills abaixo estão localizadas em `.agents/skills/` (com link simbólico compatível em `.claude/skills/`):

* **`wayfinder`**: **Mapeamento de Decisões:** Navegação de caminhos arquiteturais e tratamento de fluxos de exceção complexos. (`.agents/skills/wayfinder/SKILL.md`)
* **`wait-what`**: **Recalibragem de Alucinação:** Interrupção e correção imediata quando a IA cometer desvios ou suposições inválidas. (`.agents/skills/wait-what/SKILL.md`)
* **`research`**: **Pesquisa em Fontes Confiáveis:** Investigação de documentações oficiais, RFCs e especificações antes de aplicar. (`.agents/skills/research/SKILL.md`)
* **`diagnosing-bugs`**: **Diagnóstico Científico de Bugs:** Exige a escrita de um teste que falha reproduzindo o defeito antes de qualquer correção. (`.agents/skills/diagnosing-bugs/SKILL.md`)
* **`implement`**: **Construção Disciplinada:** Implementação guiada por especificações e testes unitários/integrados. (`.agents/skills/implement/SKILL.md`)
* **`codebase-design`**: **Arquitetura de Módulos:** Diretrizes para módulos profundos, interfaces enxutas e baixo acoplamento. (`.agents/skills/codebase-design/SKILL.md`)
* **`improve-codebase-architecture`**: **Auditoria e Refatoração:** Varredura de acoplamento excessivo e propostas de refatoração estruturada. (`.agents/skills/improve-codebase-architecture/SKILL.md`)
* **`code-review`**: **Revisão de Código:** Checklist de validação contra os padrões do repositório antes de merge/commit. (`.agents/skills/code-review/SKILL.md`)
* **`ask-matt`**: **Roteador de Decisão:** Analisa a situação atual e indica qual skill ou fluxo executar a seguir. (`.agents/skills/ask-matt/SKILL.md`)
* **`handoff`**: **Continuidade de Contexto:** Documentação padronizada do estado do trabalho para a próxima sessão ou outro agente. (`.agents/skills/handoff/SKILL.md`)
* **`retro`**: **Retrospectiva pós-sessão:** Análise dos pontos onde o agente teve dificuldades para sugerir melhorias de contexto. (`.agents/skills/retro/SKILL.md`)

---

## 🚀 Como Invocar as Skills

* Em agentes com suporte a slash commands (como Claude Code ou Antigravity): utilize `/<nome-da-skill>` (ex: `/diagnosing-bugs`, `/ask-matt`).
* Em outros agentes (Cursor, Copilot, Windsurf): instrua o agente explicitamente: *"Consulte e siga as diretrizes de .agents/skills/<nome-da-skill>/SKILL.md para executar esta tarefa."*
