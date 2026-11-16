# Checklist de testes manuais

Use esta lista para conferir o comportamento depois de mudar a configuração. Leader é Espaço. O backup do experimento
original ("LazyVim Part 3") está em `/home/defauth/.local/state/nvim-config-backups/20261020-230332`.

## Inicialização

- `nvim --headless '+qa'` termina sem erros.
- `:Lazy` não mostra plugins com erro; `:LazyExtras` lista os extras de `lazyvim.json`.
- `:checkhealth vim.lsp` não aponta servidores duplicados.

## Atalhos

- `<leader><space>`: buscar arquivo e abrir numa nova aba; `<C-p>` / `;f`: abrir na aba atual (`<leader>ff` não existe mais).
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
- `]d` / `[d`: próximo/anterior diagnóstico (padrão do LazyVim).
- `<leader>go`: abrir arquivo no remoto Git; `<leader>gn`: Neogit; `<leader>gb`: blame do LazyVim.
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
