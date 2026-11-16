# 🚀 Minha Configuração LazyVim

Configuração pessoal do Neovim baseada no [LazyVim](https://www.lazyvim.org/). A lista exata de extras fica em
`lazyvim.json` e pode ser inspecionada com `:LazyExtras`.

---

## 📦 Extras do LazyVim Ativos

- `ai.supermaven`: sugestões de IA no autocomplete.
- `coding.mini-comment`, `coding.mini-snippets`, `coding.yanky`: comentários, snippets e histórico de clipboard.
- `editor.neo-tree`, `editor.inc-rename`, `editor.dial`, `editor.outline`: explorador, rename com prévia,
  incremento inteligente e outline de símbolos.
- `formatting.prettier`, `linting.eslint`: formatação e lint.
- `lang.json`, `lang.tailwind`, `lang.typescript`, `lang.typescript.biome`: linguagens.
- `ui.indent-blankline`, `ui.mini-indentscope`, `ui.treesitter-context`: guias de indentação e contexto sticky.
- `util.mini-hipatterns`, `util.startuptime`: realce de cores e medição de inicialização.

---

## ⌨️ Keymaps Personalizados

Leader é Espaço; localleader é `\`.

### Navegação

- `<C-d>` / `<C-u>`: rolar meia página e centralizar o cursor.
- `n` / `N`: próximo/anterior resultado de busca, centralizado.
- `<leader><space>`: buscar arquivos e abrir o escolhido numa nova aba (se já estiver aberto em outra aba, ela é
  focada). Toda aba nova aberta com um arquivo (este atalho, `:tabedit` etc.) já mostra o Neo-tree com o arquivo
  revelado, mantendo o foco no arquivo.
- `<C-p>`: buscar arquivos e abrir na aba/janela atual.

### Pickers com `;`

Abrem o resultado na janela atual. Como `;` também repete o último `f`/`t`, ele espera um instante antes de agir
sozinho.

- `;f`: buscar arquivos, incluindo ocultos (substitui o `<leader>ff` do LazyVim, que foi removido).
- `;r`: buscar texto no projeto, incluindo arquivos ocultos.
- `;;`: reabrir o picker anterior, com a mesma busca.
- `;b`: listar buffers; se o arquivo já está visível numa janela (em qualquer aba), vai para ela.
- `;e`: listar diagnósticos do projeto.
- `;n`: histórico de notificações.
- `;h`: listar trechos alterados pelo Git (hunks).
- `;c`: chamadas recebidas da função sob o cursor (LSP). Com um único resultado, salta direto para ele.
- `<C-f>`: buscar texto no projeto (live grep).
- `<leader>j`: Flash (pular para qualquer posição visível). O `s` do Flash fica livre para os atalhos de janela.
- `te`: nova aba já com o Neo-tree aberto na raiz do projeto do arquivo atual (ou no cwd fora de Git); `<Tab>` /
  `<C-Tab>`: próxima/anterior aba.
- `ss` / `sv`: dividir horizontal/verticalmente; `sh`, `sj`, `sk`, `sl`: mover entre janelas.
- `<leader>1` a `<leader>6`: ir para o buffer listado correspondente.
- `]n` / `[n`: navegar nós Tree-sitter (mini.bracketed).

Observação: `<Tab>` e `<C-i>` são a mesma tecla na maioria dos terminais, então `<C-i>` (avançar no histórico de
saltos) fica indisponível. O mouse está ativado em todos os modos (`mouse = "a"`).

### Edição

- `<leader>p` (visual): colar sem sobrescrever o registro.
- `<C-/>` (ou `<C-_>`), em normal/visual/inserção: alternar comentário.
- `<leader>yr`: copiar o caminho relativo do arquivo.
- `<leader>yf`: copiar caminho relativo e linha, por exemplo `src/app.ts:42`.
- `<leader>r`: converter cores hex para HSL na linha atual.
- `+` / `-` (normal/visual): incrementar/decrementar com Dial (números, datas, booleanos etc.).

### Buffers, Git e diagnósticos

- `<leader>th` / `<leader>tu`: fechar buffers ocultos / sem nome.
- `<leader>go`: abrir o arquivo no remoto Git (navegador).
- `<leader>gn`: Neogit.
- `<leader>gF`: `git fetch origin` no diretório atual.
- `<leader>sd` / `<leader>sD`: diagnósticos do projeto / do arquivo atual.
- `<leader>uv`: alternar diagnósticos inline (virtual text), mantendo sinais e sublinhados.
- `<leader>cy`: copiar para o clipboard as mensagens de diagnóstico da linha do cursor.
- `<leader>uh`: alternar inlay hints (atalho padrão do LazyVim).
- `<leader>z`: Zen Mode.

### Navegação Tmux (`vim-tmux-navigator`)

- `<M-h>`, `<M-j>`, `<M-k>`, `<M-l>`: navegar para o painel à esquerda, abaixo, acima e à direita.
- `<M-\>`: voltar ao painel anterior.

### IA

- `<leader>ac`: abrir/fechar o popup do Codex.
- `<C-a>` (normal/visual): perguntar ao OpenCode com o contexto atual.
- `<C-x>` (normal/visual): selecionar ação do OpenCode.
- `<C-.>` (normal/terminal): abrir/fechar o OpenCode.
- `go` (operador) / `goo`: adicionar um range / a linha atual ao OpenCode.
- `<S-C-u>` / `<S-C-d>`: rolar o OpenCode para cima/baixo.
- `<Alt-a>` no picker do Snacks: enviar a seleção ao OpenCode.

### Octo (GitHub no Neovim)

- `<leader>oi`: listar issues; `<leader>op`: listar pull requests.
- `<leader>og`: listar discussions; `<leader>on`: listar notificações.
- `<leader>o/`: pesquisar no GitHub.
- `<leader>or` / `<leader>oR`: iniciar / retomar review de PR.
- `<leader>ob`: abrir review no navegador; `<leader>oc`: ver comentários pendentes.
- `<leader>os` / `<leader>ox`: submeter / descartar review.
- `<leader>oe`: revelar arquivos no Neo-tree.

Durante o review (atalhos padrão do Octo, com localleader `\`):

- `\ca`: adicionar comentário; `\sa`: adicionar sugestão.
- `\e`: focar no painel de arquivos; `\b`: mostrar/ocultar o painel.
- `\<Space>`: marcar arquivo como visto.
- `]t` / `[t`: próxima/anterior thread; `]q` / `[q`: próximo/anterior arquivo.
- `<C-c>`: fechar a aba de review.
- Na janela de submissão: `<C-a>` aprova, `<C-m>` comenta, `<C-r>` solicita mudanças.

---

## 🎨 Aparência

- Tema TokyoNight `night` com fundo transparente, inclusive sidebars e floats.
- Statusline global (lualine) transparente (`StatusLine`/`StatusLineNC` sem fundo; só o bloco do modo é colorido), com
  modo, branch, caminho, gravação de macro, diagnósticos e diff.
- Barra superior (bufferline) em modo abas, transparente (sem faixa de fundo), sempre visível, sem ícones de fechar. Cada aba leva o nome do arquivo da
  janela focada; o Neo-tree e outros painéis laterais nunca dão nome à aba. Arquivos `index` e `styles` mostram a
  pasta pai.
- O nome do arquivo aparece no winbar de cada janela apenas quando há mais de um arquivo dividido na aba; com um único
  arquivo, a barra superior já o identifica. O Neo-tree e outros painéis não têm winbar. O winbar também é transparente (`WinBar`/`WinBarNC` sem fundo).
- Diagnósticos sem virtual text por padrão (use `<leader>uv` para ativar). Ao parar o cursor por 500 ms numa linha com erro, a
  mensagem abre numa janela flutuante com borda arredondada e 50 colunas (~450 px, com quebra de linha; alarga se a mensagem inteira não couber acima nem abaixo do cursor), que
  fecha ao mover o cursor; ela não abre por cima de
  hover ou assinatura.
- Markdown abre com `conceallevel = 0`, para não esconder cercas de código e links (o que quebrava a numeração e a
  quebra de linhas). Notas do vault Obsidian voltam a usar `conceallevel = 2`.

---

## 🔧 Opções Gerais (`options.lua`)

- `mouse = "a"`: mouse ativado em todos os modos.
- `swapfile = false`: sem arquivos de swap.
- `laststatus = 3` e `cmdheight = 0`: statusline global e linha de comando oculta (o Noice exibe os comandos).
- `diffopt` com algoritmo histogram e `linematch:60`.
- `lazyvim_ts_lsp = "vtsls"`, `lazyvim_prettier_needs_config = true`, `lazyvim_mini_snippets_in_completion = false`.

O spell check fica desativado também nos tipos de arquivo em que o LazyVim o ativa (`autocmds.lua`).

O Noice exibe o progresso dos servidores de linguagem somente após 10 segundos de execução. Operações rápidas e suas
mensagens de conclusão ficam ocultas; erros, avisos e diagnósticos continuam visíveis (`lua/plugins/noice.lua`).

---

## 🔌 Plugins Adicionais

### [`obsidian.nvim`](https://github.com/obsidian-nvim/obsidian.nvim) — Notas do Obsidian

- Configuração em `lua/plugins/obsidian.lua`, usando o vault `~/obsidian/obsidian-vault-pessoal`.
- Carrega ao abrir Markdown, executar `:Obsidian` ou usar um dos atalhos abaixo.
- Busca pelo Snacks; autocomplete de links `[[` e tags `#` pelo LSP integrado ao blink.cmp.
- Em vaults identificados pela pasta `.obsidian`, o Marksman não inicia; os links ficam a cargo do `obsidian-ls`.
- Fora dos vaults, o Marksman usa a raiz do projeto, mas nunca a home: como `~/.git` existe, um arquivo sem projeto
  usaria a home inteira como workspace. Nesse caso ele usa a pasta do arquivo (e não inicia para arquivos na própria
  home).
- Notas diárias em `TODOLIST`, templates em `Templates` e imagens coladas em `anexos`, seguindo o aplicativo.
- Novas notas usam nomes derivados do título; propriedades não são acrescentadas automaticamente ao frontmatter.
- `<leader>nf`: buscar nota pelo nome; `<leader>ns`: buscar texto nas notas.
- `<leader>nn`: criar nota; `<leader>nd`: abrir ou criar a nota de hoje.
- `<leader>nb`: backlinks; `<leader>nl`: links; `<leader>nt`: tags.
- `<leader>ni`: inserir template; `<leader>nx`: alternar checkbox; `<leader>no`: abrir no aplicativo.
- Dentro das notas: `Enter` segue links ou alterna checkboxes; `]o` / `[o` navegam entre links. `<C-a>` / `<C-x>`
  continuam disponíveis para o OpenCode.
- `:Obsidian` abre o menu de comandos; `:checkhealth obsidian` verifica a integração.

### [`blink.cmp`](https://github.com/saghen/blink.cmp) — Autocompletar

- Configuração única em `lua/plugins/autocomplete.lua`.
- Fontes: `lsp`, `path` e `supermaven`. Buffers e snippets ficam fora da lista.
- Snippets enviados pelos servidores são inseridos como texto simples, sem sessão de snippet.
- Ghost text, documentação automática e pré-seleção desativados; parênteses automáticos desativados.
- Preset `enter`: `<CR>` e `<C-y>` aceitam; `<C-j>` / `<C-k>` navegam.

### [`diffview-plus.nvim`](https://github.com/dlyongemallo/diffview-plus.nvim) — Diff Git

- Fork mantido do `diffview.nvim`, fixado na última versão publicada (`version = "*"`).
- `<leader>gd` ou `:GitDiff` abre `:DiffviewOpen` na raiz do repositório, reutilizando a aba de diff de cada
  repositório.
- Lista plana dos arquivos com alterações (staged, unstaged e novos), diff lado a lado (`diff2_horizontal`) com
  realce aprimorado.
- Os dois lados herdam o `wrap` global: o plugin não força `nowrap`, então não há personalização extra.
- `t` no painel de arquivos ou `g<C-x>` alterna entre lado a lado e inline (`diff1_inline`).
- `]c` / `[c` ou `<leader>hh` / `<leader>hp` navegam entre hunks no diff. Nos buffers normais, `<leader>hh` /
  `<leader>hp` fazem o mesmo via GitSigns.
- `q` fecha a visualização; `g?` mostra os atalhos. `:DiffviewFileHistory %` abre o histórico do arquivo.
- O Neogit usa o diffview-plus como integração de diff.

### [`vim-flog`](https://github.com/rbong/vim-flog) — Log visual do Git

- Comandos `:Flog`, `:Flogsplit` e `:Floggit`, com `vim-fugitive` como dependência.

### [`neo-tree.nvim`](https://github.com/nvim-neo-tree/neo-tree.nvim) — Explorador de arquivos

- `<leader>e` / `<leader>fe`: abre a raiz do projeto reconhecido pelo Git; fora de um repositório válido, usa o
  diretório atual, sem status Git e mostrando arquivos ignorados.
- Uma pasta `.git` vazia ou inválida não faz o explorador subir para uma raiz incorreta.
- Pastas vazias não são agrupadas; abas de fonte (winbar/statusline) ocultas.
- `o`: abrir; `Y`: copiar caminho com menu (absoluto, relativo ao cwd ou à home, nome, nome sem extensão, extensão).

### [`octo.nvim`](https://github.com/pwntester/octo.nvim) — GitHub integrado

- Picker do Snacks.
- Patch personalizado no painel de arquivos do review: exibe os arquivos em árvore de diretórios, em vez de lista
  plana.

### Outros

- [`scope.nvim`](https://github.com/tiagovla/scope.nvim): buffers com escopo por aba.
- [`nvim-treesitter-context`](https://github.com/nvim-treesitter/nvim-treesitter-context): até 5 linhas de contexto,
  modo `cursor`, corte pelo escopo externo.
- [`marks.nvim`](https://github.com/chentoast/marks.nvim): marcas visíveis na coluna de sinais.
- [`auto-indent.nvim`](https://github.com/vidocqh/auto-indent.nvim): posiciona o cursor na indentação correta.
- [`vim-tmux-navigator`](https://github.com/christoomey/vim-tmux-navigator), [`vim-be-good`](https://github.com/ThePrimeagen/vim-be-good)
  e [`vim-wakatime`](https://github.com/wakatime/vim-wakatime).

---

## 🛠️ LSP — Configurações Personalizadas

### Desempenho em projetos JS/TS

- O vtsls verifica os arquivos abertos; o diagnóstico experimental de arquivos fechados fica desativado.
- O autocomplete TypeScript retorna até 200 sugestões por resposta, filtradas por relevância no servidor.
- O Tailwind LSP inicia quando encontra configuração Tailwind ou uma dependência `tailwindcss` no pacote ou workspace,
  inclusive em projetos Tailwind v4 sem `tailwind.config.*`.
- O plugin TypeScript de styled-components carrega apenas em workspaces ou pacotes que declaram `styled-components`.

### ESLint (`lua/plugins/eslint.lua`)

- Toda a configuração do ESLint fica neste arquivo: settings, atalho, raiz e formatação.
- Diagnósticos dos arquivos abertos enquanto você digita. Use `:EslintProject` para atualizar os diagnósticos do
  projeto inteiro manualmente.
- `<leader>ce`: aplicar todas as correções do ESLint no arquivo.
- Ao formatar, o "fix all" do ESLint roda depois do Prettier e espera as correções antes de salvar.
- Quando o ESLint está ativo, o Prettier formata mesmo sem arquivo de configuração próprio, porque as regras do ESLint
  não cuidam da formatação geral. Em projetos sem ESLint, o Prettier continua exigindo configuração.
- O backend Kolab e suas worktrees usam Biome, sem iniciar ESLint.

### TypeScript (`vtsls`)

- Heap do tsserver limitado a 8192 MiB (8 GiB), em vez do padrão de 3072 MiB, para projetos grandes. É um teto por
  processo, não uma reserva imediata de RAM. Após alterar esse limite, reinicie o Neovim.
- Inlay hints desativados por padrão (`<leader>uh` alterna).
