# 🚀 Minha Configuração LazyVim

Configuração pessoal do Neovim baseada no [LazyVim](https://www.lazyvim.org/).

---

## 📦 Extras do LazyVim Ativos

| Extra                   | Descrição                                     |
| ----------------------- | --------------------------------------------- |
| `ai.copilot`            | GitHub Copilot                                |
| `coding.yanky`          | Histórico de clipboard avançado               |
| `editor.neo-tree`       | Explorador de arquivos Neo-tree               |
| `lang.typescript`       | Suporte completo a TypeScript/JavaScript      |
| `lang.typescript.biome` | Formatter/linter Biome para TS                |
| `lang.typescript.tsgo`  | LSP tsgo (TypeScript Go) como servidor padrão |
| `util.gh`               | Integração com GitHub CLI                     |
| `util.mini-hipatterns`  | Destaque de padrões no código (ex: cores hex) |
| `linting.eslint`        | Linting com ESLint                            |
| `formatting.prettier`   | Formatação com Prettier                       |

---

## ⌨️ Keymaps Personalizados

### Navegação

| Tecla   | Modo   | Ação                                     |
| ------- | ------ | ---------------------------------------- |
| `<C-d>` | Normal | Scroll para baixo + centraliza cursor    |
| `<C-u>` | Normal | Scroll para cima + centraliza cursor     |
| `n`     | Normal | Próximo resultado de busca + centraliza  |
| `N`     | Normal | Resultado anterior de busca + centraliza |
| `<C-p>` | Normal | Buscar arquivos (picker)                 |
| `<C-f>` | Normal | Buscar texto no projeto (live grep)      |

### Edição

- `Espaço y f` copia o caminho do arquivo relativo ao diretório atual e a linha para o clipboard, por exemplo: `src/app.ts:42`.

| Tecla       | Modo                 | Ação                                          |
| ----------- | -------------------- | --------------------------------------------- |
| `<leader>p` | Visual               | Colar sem sobrescrever o registro             |
| `<C-/>`     | Normal/Visual/Insert | Alternar comentário de linha                  |
| `<C-_>`     | Normal/Visual/Insert | Alternar comentário (fallback para terminais) |

### Navegação Tmux (`vim-tmux-navigator`)

| Tecla   | Ação                         |
| ------- | ---------------------------- |
| `<M-h>` | Navegar para painel esquerdo |
| `<M-j>` | Navegar para painel abaixo   |
| `<M-k>` | Navegar para painel acima    |
| `<M-l>` | Navegar para painel direito  |
| `<M-\>` | Navegar para painel anterior |

### Octo (GitHub no Neovim)

| Tecla        | Ação                             |
| ------------ | -------------------------------- |
| `<leader>oi` | Listar Issues                    |
| `<leader>op` | Listar Pull Requests             |
| `<leader>og` | Listar Discussions               |
| `<leader>on` | Listar Notificações              |
| `<leader>o/` | Pesquisar no GitHub              |
| `<leader>or` | Iniciar review de PR             |
| `<leader>oR` | Retomar review de PR             |
| `<leader>ob` | Abrir review no browser          |
| `<leader>oc` | Ver comentários pendentes        |
| `<leader>os` | Submeter review                  |
| `<leader>ox` | Descartar review                 |
| `<leader>oe` | Abrir arquivos do PR no Neo-tree |
| `<leader>of` | Listar arquivos alterados no PR  |
| `<leader>od` | Ver diff do PR                   |

#### Durante o review (diff)

| Tecla        | Ação                               |
| ------------ | ---------------------------------- |
| `<leader>ca` | Adicionar comentário de review     |
| `<leader>sa` | Adicionar sugestão de review       |
| `<leader>e`  | Focar no painel de arquivos        |
| `<leader>b`  | Mostrar/ocultar painel de arquivos |
| `<Space>`    | Marcar arquivo como visto          |
| `]t` / `[t`  | Próxima/anterior thread            |
| `]q` / `[q`  | Próximo/anterior arquivo alterado  |
| `<C-c>`      | Fechar aba de review               |

#### Submissão de review

| Tecla   | Ação               |
| ------- | ------------------ |
| `<C-a>` | Aprovar review     |
| `<C-m>` | Comentar review    |
| `<C-r>` | Solicitar mudanças |

### OpenCode (AI Coding Assistant)

| Tecla     | Modo            | Ação                                   |
| --------- | --------------- | -------------------------------------- |
| `<C-a>`   | Normal/Visual   | Perguntar ao opencode com contexto     |
| `<C-x>`   | Normal/Visual   | Selecionar no opencode                 |
| `<C-.>`   | Normal/Terminal | Abrir/fechar opencode                  |
| `go`      | Normal/Visual   | Adicionar range ao opencode (operador) |
| `goo`     | Normal          | Adicionar linha atual ao opencode      |
| `<S-C-u>` | Normal          | Scroll para cima no opencode           |
| `<S-C-d>` | Normal          | Scroll para baixo no opencode          |
| `+`       | Normal          | Incrementar número (substitui `<C-a>`) |
| `-`       | Normal          | Decrementar número (substitui `<C-x>`) |

---

## 🎨 Aparência

- **Tema:** TokyoNight `night` com fundo **transparente**
  - Sidebars e floats também transparentes
- **Diagnósticos:** via [`tiny-inline-diagnostic`](https://github.com/rachartier/tiny-inline-diagnostic.nvim) — exibidos inline, sem `virtual_text` padrão

---

## 🔧 Opções Gerais (`options.lua`)

| Opção            | Valor    | Efeito                                      |
| ---------------- | -------- | ------------------------------------------- |
| `swapfile`       | `false`  | Sem arquivos de swap                        |
| `undofile`       | `true`   | Histórico de undo persistente               |
| `autoread`       | `true`   | Recarrega arquivos modificados externamente |
| `virtual_text`   | `false`  | Diagnósticos sem texto no fim da linha      |
| `lazyvim_ts_lsp` | `"tsgo"` | Usa tsgo como LSP padrão para TypeScript    |

### Plugins desativados

- `nvim-notify` — notificações padrão desativadas
- `folke/noice.nvim` — UI de mensagens desativada
- `folke/flash.nvim` — navegação por flash desativada

---

## 🔌 Plugins Adicionais

### [`obsidian.nvim`](https://github.com/obsidian-nvim/obsidian.nvim) — Notas do Obsidian

- Configuração em `lua/plugins/obsidian.lua`, usando o vault `~/obsidian/obsidian-vault-pessoal`.
- Carrega ao abrir Markdown, executar `:Obsidian` ou usar um dos atalhos abaixo.
- Busca pelo Snacks; autocomplete de links `[[` e tags `#` pelo LSP integrado ao blink.cmp.
- Em vaults identificados pela pasta `.obsidian`, o Marksman não inicia; os links ficam a cargo do `obsidian-ls`, evitando diagnósticos incompatíveis com o Obsidian. Markdown fora dos vaults continua usando Marksman.
- Notas diárias em `TODOLIST`, templates em `Templates` e imagens coladas em `anexos`, seguindo o aplicativo.
- Novas notas usam nomes derivados do título; propriedades não são acrescentadas automaticamente ao frontmatter.
- `Espaço n f`: buscar nota pelo nome.
- `Espaço n s`: buscar texto nas notas.
- `Espaço n n`: criar nota.
- `Espaço n d`: abrir ou criar a nota de hoje.
- `Espaço n b`: ver backlinks; `Espaço n l`: listar links; `Espaço n t`: buscar tags.
- `Espaço n i`: inserir template; `Espaço n x`: alternar checkbox.
- `Espaço n o`: abrir a nota no aplicativo Obsidian.
- Dentro das notas: `Enter` segue links ou alterna checkboxes; `]o` / `[o` navegam entre links. `<C-a>` / `<C-x>` continuam disponíveis para o OpenCode.
- `:Obsidian` abre o menu de comandos; `:checkhealth obsidian` verifica a integração.

### [`blink.cmp`](https://github.com/saghen/blink.cmp) — Autocompletar

- Fontes: `lsp`, `path`, `snippets` (buffers removidos)
- Ghost text **desativado**
- Documentação automática **desativada**
- Assinatura de função (signature help) **desativada**
- Keymaps de navegação: `<C-j>` / `<C-k>` para navegar, `<CR>` para aceitar

### [`codediff.nvim`](https://github.com/esmuellert/codediff.nvim) — Diff Git estilo VS Code

- `<leader>gd` (`Espaço g d`) ou `:GitDiff` abre a visualização, sem acesso fixo na barra de abas.
- Reutiliza a aba de diff de cada repositório, com árvore de arquivos e diff lado a lado.
- Compacta pastas com um único subdiretório em uma linha, como `apps/back/src/app`.
- Scroll vertical e horizontal sincronizado entre os dois lados do diff.
- Atualiza as alterações automaticamente e mostra arquivos staged, unstaged e novos.
- `q` fecha a visualização; use `:GitDiff` para reabrir.
- `:CodeDiff` também está disponível para comparações avulsas. `diffview.nvim` permanece desativado.
- `<leader>gF` (`Espaço g F`, com `F` maiúsculo) executa `git fetch origin` no diretório atual.

### [`vim-flog`](https://github.com/rbong/vim-flog) — Log visual do Git

- Comandos: `:Flog`, `:Flogsplit`, `:Floggit`
- Dependência: `vim-fugitive`

### [`neo-tree.nvim`](https://github.com/nvim-neo-tree/neo-tree.nvim) — Explorador de arquivos

- Segue o arquivo atual automaticamente
- Mostra dotfiles e arquivos gitignored
- Oculta: `.git`, `node_modules`, `dist`
- Largura: 54 colunas
- Tecla `Y` — copiar caminho do arquivo com menu de opções (absoluto, relativo, nome, extensão)
- Ícones de expansão customizados: `/`

### [`octo.nvim`](https://github.com/pwntester/octo.nvim) — GitHub integrado

- Picker: `snacks`
- **Patch personalizado** no painel de arquivos de review: exibe os arquivos em **formato de árvore de diretórios** (ao invés de lista plana)

### [`opencode.nvim`](https://github.com/nickjvandyke/opencode.nvim) — AI assistant integrado

- Integração com `snacks.nvim` para picker e input
- Atalho `<Alt-a>` no picker para enviar ao opencode

### [`scope.nvim`](https://github.com/tiagovla/scope.nvim) — Tabs com escopo por buffer

### [`nvim-treesitter-context`](https://github.com/nvim-treesitter/nvim-treesitter-context) — Contexto sticky

- Máx. 5 linhas de contexto
- Modo: `cursor`
- Escopo removido: `outer`

### [`vim-tmux-navigator`](https://github.com/christoomey/vim-tmux-navigator) — Navegação Neovim ↔ Tmux

### [`vim-be-good`](https://github.com/ThePrimeagen/vim-be-good) — Prática de movimentos Vim

### [`vim-wakatime`](https://github.com/wakatime/vim-wakatime) — Tracking de tempo de código

---

## 🛠️ LSP — Configurações Personalizadas

### TypeScript (`tsgo`)

- Todos os **inlay hints desativados** (tipos de retorno, parâmetros, variáveis, etc.)
- Suporte a: `js`, `jsx`, `ts`, `tsx`

### Bash LSP (`bashls`)

- Diagnósticos ignorados em arquivos `.env*`

---
