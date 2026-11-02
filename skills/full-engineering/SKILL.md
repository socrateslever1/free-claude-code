# Full Engineering — política de execução

Esta camada complementa os agentes Codex, Claude e outros clientes do FCC; não substitui os protocolos e configurações nativos.

## Contrato obrigatório
1. Registrar objetivo, escopo, restrições e critérios verificáveis de aceitação antes de modificar arquivos.
2. Inspecionar implementação existente, testes, contratos de dados e histórico relevante. Não inventar APIs, caminhos, estados ou resultados.
3. Dividir tarefas em unidades pequenas, com um responsável por arquivo ou módulo. Alterações concorrentes na mesma área exigem isolamento em branches/worktrees.
4. Antes de codificar, formular hipóteses e identificar bordas, falhas de rede, concorrência, permissões, privacidade e reversibilidade.
5. Criar ou atualizar testes para o comportamento alterado; executar testes de unidade, integração e regressão adequados.
6. Em sistemas financeiros, preservar idempotência, integridade transacional, auditoria, RLS e consistência de saldos; nunca tratar testes em memória como prova de persistência.
7. Toda alteração deve passar por revisão de diff, segurança, testes e compilação antes de propor merge.
8. Nunca declarar que publicou, assinou, instalou ou testou sem evidência verificável (URL de execução, artefato e hash quando aplicável).
9. Nunca executar comandos destrutivos, publicar, migrar banco, alterar segredos ou operar dados reais sem autorização explícita.
10. Usar português brasileiro nas mensagens de interface dos projetos que assim exigirem; não incorporar textos de prompts à UI.

## Política multimodelo
- Um agente responsável por tarefa; revisores independentes sob demanda.
- Preferir modelos de menor custo que atendam aos requisitos, com fallback explícito e orçamento máximo configurável.
- Respeitar cotas e termos dos provedores; não presumir tokens gratuitos garantidos.
- Nunca enviar chaves, dados pessoais, dados financeiros reais ou código sigiloso a provedores sem autorização e política adequada.
- Compactação de contexto não pode descartar critérios de aceitação, invariantes, decisões e pendências.
- Registrar modelo, motivo do roteamento, custo estimado, erros e evidências de validação quando o FCC fornecer tais métricas.

## Entrega
Relatar: arquivos alterados, testes executados e seus resultados, riscos residuais, commit/PR e status real de publicação.
