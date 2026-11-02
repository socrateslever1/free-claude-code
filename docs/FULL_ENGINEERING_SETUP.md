# Integração híbrida — configuração inicial

## Estado
A Skill em `skills/full-engineering/SKILL.md` é uma política de trabalho, não uma integração automática com todos os agentes. O FCC já fornece lançadores Codex e Claude (`fcc-codex`, `fcc-claude`); a compatibilidade deve ser testada com versões instaladas.

## Instalação segura no Windows
1. Clone este fork com Git, selecionando a branch `feat/full-engineering-hybrid`.
2. Leia `scripts/install.ps1` antes de executá-lo. O instalador original pode baixar dependências e agentes externos.
3. Execute `powershell -NoProfile -File scripts/install.ps1 -DryRun` a partir da raiz do clone para inspecionar ações, sem instalar.
4. Não presuma que o instalador original instalará automaticamente o código desta branch: seu fluxo utiliza versões de lançamento e recursos externos. Uma adaptação explícita e testada ainda é necessária.
5. Use Codex e Claude com autenticação própria, respeitando os limites de cada provedor.

## Provedores adicionais
`https://github.com/topics/free-llm-api` é um índice de projetos, não uma API. Selecionar provedores requer documentação oficial, disponibilidade real, termos, autenticação, limites, privacidade e testes de compatibilidade. Não inserir chaves no repositório.

## Critérios de aceitação antes de distribuir instalador personalizado
- Teste de instalação limpa e reinstalação no Windows.
- Teste de inicialização e fallback com provedores indisponíveis.
- Teste de preservação das credenciais e configurações existentes.
- Teste de carregamento efetivo da Skill por Codex e Claude.
- Teste de idempotência e tratamento de erros do instalador.
- Verificação de hash e proveniência dos binários distribuídos.
