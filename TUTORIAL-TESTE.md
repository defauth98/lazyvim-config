# Experimento LazyVim Part 3

Backup anterior a todas as mudanças: `/home/defauth/.local/state/nvim-config-backups/20261020-230332`.

Extras adicionados: `editor.inc-rename`, `editor.dial`, `editor.outline`, `ai.codeium`, `util.mini-hipatterns`.
TypeScript/vtsls, Tailwind, Biome, ESLint, snippets e Prettier já estavam habilitados.
O modo cowboy foi removido. Tema: Tokyo Night transparente (configuração original).
Codeium precisa de autenticação pessoal com `:Codeium Auth`.

## Testar

Leader é Espaço.

| Atalho | Ação |
| --- | --- |
| `<leader><space>` / `<leader>/` | Buscar arquivos / texto com Snacks Picker |
| `<leader>,` | Listar buffers com Snacks Picker |
| `<leader>cs` | Outline de símbolos |
| `<leader>cr` | Renomear com prévia via LSP |
| `Ctrl+a` / `Ctrl+x` | Incrementar/decrementar com Dial |
| `]n` / `[n` | Navegar nós Tree-sitter |
| `<leader>z` | Zen Mode |
| `<leader>yr` / `<leader>yR` | Copiar caminho relativo / com linha |
| `<leader>r` | Converter hex para HSL na linha |
| `<leader>i` | Alternar inlay hints no buffer |
| `<leader>go` | Abrir arquivo no remoto Git |
| `<leader>gb` | Blame já fornecido pelo LazyVim |
| `<leader>th` / `<leader>tu` | Fechar buffers ocultos / sem nome |
| `<leader>1` a `<leader>6` | Ir para buffer listado |
| `Ctrl+j` (normal) | Próximo diagnóstico |
| `Ctrl+j` (inserção) | Próxima sugestão de completion |

Os extras podem ser inspecionados em `:LazyExtras`.
O realce de cores usa mini.hipatterns (hex e Tailwind).
Prettier exige configuração do projeto para evitar disputar formatação com Biome.
Bufferline exibe abas; os atalhos numéricos selecionam buffers.

## Restaurar

Feche o Neovim e execute no terminal. O experimento será preservado em outro diretório:

```bash
mv ~/.config/nvim ~/.config/nvim-tutorial-$(date +%Y%m%d-%H%M%S)
cp -a ~/.local/state/nvim-config-backups/20261020-230332 ~/.config/nvim
```

A restauração recupera a configuração e o lockfile anteriores. Plugins baixados permanecem no cache de dados do Neovim.
