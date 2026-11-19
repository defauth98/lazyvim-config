# Checklist de testes manuais

Use esta lista para conferir o comportamento depois de mudar a configuração. Leader é Espaço. O backup do experimento
original ("LazyVim Part 3") está em `/home/defauth/.local/state/nvim-config-backups/20261020-230332`.

## Inicialização

- `nvim --headless '+qa'` termina sem erros.
- `:Lazy` não mostra plugins com erro; `:LazyExtras` lista os extras de `lazyvim.json`.
- `:checkhealth vim.lsp` não aponta servidores duplicados.

## Layout do CodeDiff

- Em `:GitDiff`, qualquer arquivo (Markdown ou código) abre em diff inline, num painel só.
- `t` alterna para lado a lado; conflitos mantêm o layout do plugin.

## Atalhos

- `<leader>hd`: num hunk com linhas longas, a prévia inline quebra tanto as linhas atuais quanto as removidas.
  Redimensionar o split recalcula a quebra; mover o cursor fecha a prévia sem modificar o arquivo.
- `<leader><space>`: buscar arquivo e abrir numa nova aba; `<C-p>` / `;f`: abrir na aba atual (`<leader>ff` não existe mais).
- `;f` encontra arquivos ocultos (ex.: `.prettierrc.json`); `;r` busca texto também neles.
- `;;` reabre o último picker; `;b` buffers (vai à janela que já mostra o arquivo); `;e` diagnósticos; `;n` notificações;
  `;h` hunks do Git; `;c` chamadas recebidas pelo LSP.
- `<leader>/`: buscar texto com o Snacks Picker.
- `<leader>,`: listar buffers.
- `<leader>cs`: outline de símbolos.
- `<leader>cr`: renomear com prévia via LSP.
- `+` / `-`: incrementar/decrementar com Dial (`<C-a>` / `<C-x>` pertencem ao OpenCode).
- `]n` / `[n`: navegar nós Tree-sitter.
- `<leader>j`: Flash.
- `<leader>z`: Zen Mode.
- `<leader>yr` / `<leader>yf`: copiar caminho relativo / com linha.
- `<leader>r`: converter hex para HSL na linha.
- `<leader>uh`: alternar inlay hints; `<leader>uv`: alternar diagnósticos inline.
- `<leader>cy`: numa linha com erro, copia a mensagem; cole em outro app para conferir.
- `]d` / `[d`: próximo/anterior diagnóstico (padrão do LazyVim).
- `<leader>go`: abrir arquivo no remoto Git; `<leader>gn`: Neogit; `<leader>gb`: blame do LazyVim.
- `<leader>ga`: em um arquivo Git alterado ou novo, colocar todas as alterações do buffer em stage;
  conferir no Neogit ou em `git diff --cached`. Com a prévia inline (`<leader>hd`) e o Neo-tree abertos,
  verificar que a prévia desaparece e o indicador Git da árvore muda para staged sem mover o cursor.
- `<leader>ac`: popup do Codex.
- `<leader>th` / `<leader>tu`: fechar buffers ocultos / sem nome.
- `<leader>1` a `<leader>6`: ir para buffer listado.
- `<C-j>` / `<C-k>` (inserção): navegar sugestões do autocomplete.

## LSP

- Em um arquivo `.tsx` de projeto com ESLint, `:lua =vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({ bufnr = 0 }))`
  mostra apenas `vtsls` e `eslint` (mais `tailwindcss` em projetos Tailwind).
- `<leader>ce` aplica as correções do ESLint; salvar formata com Prettier e depois aplica o "fix all".
- Em um projeto com Biome (Kolab), o ESLint não inicia.
- Em um Markdown fora de projeto, o Marksman não usa a home como raiz.

## Interface

- Em um arquivo JS/TS com blocos aninhados, aparecem guias finas em cinza, inclusive nas linhas vazias entre
  blocos. Ao mover o cursor, a guia do bloco atual fica cinza mais clara, sem animação ou sublinhado.
  Confira também splits e janelas flutuantes: o destaque acompanha a janela atual; os sinais do Git continuam
  visíveis na margem ao alterar linhas de um arquivo rastreado.
- Markdown: números de linha contínuos e cercas de código visíveis (`conceallevel = 0`).
- Com um único arquivo não há winbar; ao dividir (`sv`), cada janela de arquivo mostra o nome à direita.
- Com o foco no Neo-tree, a aba no topo continua mostrando o arquivo, não "neo-tree filesystem".
- Statusline e winbar transparentes; o mini.hipatterns realça cores hex e classes Tailwind.

## Restaurar o experimento original

Feche o Neovim e execute no terminal. A configuração atual será preservada em outro diretório:

```bash
mv ~/.config/nvim ~/.config/nvim-tutorial-$(date +%Y%m%d-%H%M%S)
cp -a ~/.local/state/nvim-config-backups/20261020-230332 ~/.config/nvim
```
