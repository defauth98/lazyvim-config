# Guia para agent: diff view por tipo de arquivo no LazyVim

Referência opcional: a configuração atual usa diff inline para todos os arquivos, conforme o `README.md`.
Aplicar este guia substitui esse comportamento pela seleção automática de layout por extensão.

Este guia ensina um agent a configurar, numa instalação LazyVim, um diff view que escolhe o layout pela extensão do arquivo. Arquivos de texto (`.md`, `.markdown`, `.mdx`, `.txt`, `.text`) abrem em layout `inline`, com tudo numa coluna só; o resto (código) abre em `side-by-side`. O guia documenta essa alternativa e traz o código completo de cada arquivo, a spec do plugin com as opções comentadas e uma explicação de como o código interno do plugin se comporta.

Fica de fora, de propósito, toda a configuração da árvore de arquivos: o painel explorer do CodeDiff (`explorer = {...}` e `keymaps.explorer`) e o Neo-tree. Os defaults do plugin para o explorer já batem com o que o usuário usa (`view_mode = "list"`, `auto_refresh = true`), então omitir esse bloco não muda o comportamento.

## 1. Premissas

- Neovim 0.12 ou superior, LazyVim e lazy.nvim.
- Plugin de diff: `esmuellert/codediff.nvim`, branch `main`, commit de referência `09d9ebef2cc5a5c04db7a349cd6c61bdf84ecc8e` (veja `lazy-lock.json`). O plugin usa uma biblioteca nativa; se ela faltar, rode `:CodeDiff install`.
- `sindrets/diffview.nvim` fica desativado para não haver dois diff views concorrendo.
- Estrutura do repositório:
  - `lua/config/options.lua`: opções do editor.
  - `lua/plugins/<assunto>.lua`: uma spec por assunto, cada arquivo retorna uma tabela.
  - `lua/insideee-dev/<helper>.lua`: helpers próprios, cada um retorna uma tabela `M`.
- Estilo: 2 espaços, 120 colunas (`stylua.toml`), `snake_case`, keymaps sempre com `desc`. Comentários em português e só quando o comportamento não for óbvio.

Arquivos que o agent vai criar ou editar:

- `lua/config/options.lua` (editar)
- `lua/plugins/diffview.lua` (criar)
- `lua/plugins/codediff.lua` (criar)
- `lua/plugins/git.lua` (criar ou editar)
- `lua/insideee-dev/utils.lua` (garantir a função `git_toplevel`)
- `lua/insideee-dev/git-diff.lua` (criar)
- `lua/insideee-dev/codediff-layout.lua` (criar)

## 2. Opções globais de diff

Em `lua/config/options.lua`, junto das outras opções:

```lua
vim.opt.diffopt = {
  "internal",
  "filler",
  "closeoff",
  "algorithm:histogram",
  "indent-heuristic",
  "linematch:60",
}
```

O que cada item faz:

- `internal`: usa o diff interno do Neovim, sem chamar programa externo.
- `filler`: insere linhas de preenchimento para manter os dois lados alinhados.
- `closeoff`: ao fechar uma das janelas de diff, desliga o modo diff na que sobra.
- `algorithm:histogram`: algoritmo que gera hunks mais legíveis em código.
- `indent-heuristic`: posiciona melhor o início e o fim dos hunks em blocos indentados.
- `linematch:60`: alinha linhas parecidas dentro de hunks de até 60 linhas.

O CodeDiff tem motor próprio, mas essas opções valem para qualquer `:diffthis` e para os buffers que o plugin coloca em modo diff.

## 3. Desativar o diffview.nvim

`lua/plugins/diffview.lua`:

```lua
return {
  "sindrets/diffview.nvim",
  enabled = false,
}
```

## 4. Spec completa do CodeDiff

`lua/plugins/codediff.lua`. A versão abaixo tem os valores que o usuário usa e, explícitos, os defaults relevantes para diff e layout, para o agent saber o que pode ajustar. Opções do explorer e do painel de histórico ficam de fora.

```lua
return {
  "esmuellert/codediff.nvim",
  lazy = true,
  cmd = "CodeDiff",
  init = function()
    -- O CodeDiff ativa scrollbind nos dois painéis; sincronize ambos os eixos.
    vim.opt.scrollopt:append({ "ver", "hor", "jump" })
    require("insideee-dev.git-diff").setup()
    require("insideee-dev.codediff-layout").setup()
  end,
  opts = {
    highlights = {
      line_insert = "DiffAdd",
      line_delete = "DiffDelete",
      char_insert = nil,
      char_delete = nil,
      char_brightness = nil,
    },
    diff = {
      layout = "side-by-side",
      filler_text = "╱",
      disable_inlay_hints = true,
      max_computation_time_ms = 5000,
      ignore_trim_whitespace = false,
      original_position = "left",
      cycle_next_hunk = true,
      cycle_next_file = true,
      jump_to_first_change = true,
      highlight_added_deleted_files = false,
      highlight_priority = 100,
      gutter_signs = false,
      compute_moves = false,
      compact = false,
      compact_context_lines = 3,
      compact_sync_folds = true,
    },
    keymaps = {
      view = {
        quit = "q",
        next_hunk = { "]c", "<leader>hh" },
        prev_hunk = { "[c", "<leader>hp" },
        next_file = "]f",
        prev_file = "[f",
        diff_get = "do",
        diff_put = "dp",
        open_in_prev_tab = "gf",
        toggle_stage = "-",
        stage_hunk = "<leader>hs",
        unstage_hunk = "<leader>hu",
        discard_hunk = "<leader>hr",
        hunk_textobject = "ih",
        toggle_layout = "t",
        toggle_compact = "gc",
        show_help = "g?",
      },
    },
  },
}
```

Na config real do usuário só estes valores diferem dos defaults, então a versão mínima equivalente é:

```lua
opts = {
  diff = { layout = "side-by-side" },
  keymaps = {
    view = {
      next_hunk = { "]c", "<leader>hh" },
      prev_hunk = { "[c", "<leader>hp" },
    },
  },
},
```

O agent pode usar qualquer uma das duas. A versão completa documenta melhor; a mínima acompanha os defaults quando o plugin for atualizado.

Detalhes da spec:

- `lazy = true` com `cmd = "CodeDiff"`: o plugin só carrega quando `:CodeDiff` roda (o `:GitDiff` do passo 6 chama esse comando).
- `init` roda na inicialização, antes de o plugin carregar. Isso é necessário porque os autocmds dos helpers precisam existir antes do primeiro `CodeDiffOpen`. Os helpers só chamam `require("codediff...")` dentro dos callbacks, então não forçam o carregamento antecipado.
- `scrollopt` com `ver`, `hor` e `jump` faz o scroll vertical e horizontal e os saltos ficarem sincronizados entre os dois painéis no modo side-by-side.
- `diff.layout` é o layout inicial de cada sessão. O helper do passo 7 corrige o layout depois, por arquivo. Trocar o default para `"inline"` inverte a lógica: aí a tabela do helper teria de listar os tipos que vão para `side-by-side`.
- Os keymaps de `view` aceitam string ou lista de strings. `<leader>hh` e `<leader>hp` repetem os atalhos do GitSigns (passo 8), para a navegação ser a mesma dentro e fora do diff.
- `toggle_layout = "t"` alterna o layout na mão. O helper respeita essa escolha até o usuário trocar de arquivo.
- `<leader>hs`, `<leader>hu` e `<leader>hr` também existem no GitSigns do LazyVim, mas os do CodeDiff são locais aos buffers do diff, então não há conflito.

Opções de merge e conflito (`diff.conflict_*` e `keymaps.conflict`) ficam nos defaults. O helper não mexe em sessões de conflito.

## 5. Função `git_toplevel` em `utils.lua`

`lua/insideee-dev/utils.lua` precisa exportar esta função (ela já existe na config do usuário; se o arquivo não existir, crie com `local M = {}` no topo e `return M` no fim):

```lua
-- Returns the Git top-level directory, or nil when the directory is not inside a valid repository.
function M.git_toplevel(directory, timeout)
  local result = vim.system({ "git", "-C", directory, "rev-parse", "--show-toplevel" }, { text = true }):wait(timeout)
  if result.code == 0 then
    return vim.trim(result.stdout)
  end
end
```

## 6. Helper `git-diff.lua`: um diff por repositório

`lua/insideee-dev/git-diff.lua` cria o comando `:GitDiff`. Ele:

- Descobre a raiz Git do arquivo atual; se o buffer for especial ou não tiver nome, usa o cwd.
- Se já houver uma aba de diff daquele repositório (marcada com `vim.t.git_diff_root`), só muda para ela.
- Senão, roda `:CodeDiff --repo <raiz>`. Como o CodeDiff cria a aba de forma assíncrona, guarda um `pending` e marca a aba quando o evento `CodeDiffOpen` chegar com `mode == "explorer"`.
- Se o repositório estiver limpo ou der erro, o `CodeDiffOpen` não chega; o `pending` expira em 5 s.
- Rodar `:GitDiff` dentro da própria aba de diff reaproveita `vim.t.git_diff_root`, sem recalcular a raiz.

```lua
local M = {}
local pending

function M.open()
  if pending then
    return
  end

  local root = vim.t.git_diff_root
  if not root then
    local file = vim.api.nvim_buf_get_name(0)
    local cwd = vim.bo.buftype == "" and file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()
    root = require("insideee-dev.utils").git_toplevel(cwd)
    if not root then
      vim.notify("O arquivo ou diretório atual não pertence a um repositório Git.", vim.log.levels.WARN)
      return
    end
  end

  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    if vim.t[tab].git_diff_root == root then
      vim.api.nvim_set_current_tabpage(tab)
      return
    end
  end

  -- CodeDiff abre a aba de forma assíncrona. O evento identifica a aba criada.
  local request = { root = root }
  pending = request
  local ok, err = pcall(vim.cmd, "CodeDiff --repo " .. vim.fn.fnameescape(root))
  if not ok then
    pending = nil
    vim.notify(tostring(err), vim.log.levels.ERROR)
  end
  -- Repositórios limpos e erros não emitem CodeDiffOpen.
  vim.defer_fn(function()
    if pending == request then
      pending = nil
    end
  end, 5000)
end

function M.setup()
  vim.api.nvim_create_user_command("GitDiff", M.open, { desc = "Abrir diff Git" })
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("FixedGitDiff", { clear = true }),
    pattern = { "CodeDiffOpen", "CodeDiffClose" },
    callback = function(event)
      local tab = event.data and event.data.tabpage
      if not tab or not vim.api.nvim_tabpage_is_valid(tab) then
        return
      end
      if event.match == "CodeDiffOpen" and pending and event.data.mode == "explorer" then
        vim.t[tab].git_diff_root = pending.root
        pending = nil
      elseif event.match == "CodeDiffClose" then
        vim.t[tab].git_diff_root = nil
      end
    end,
  })
end

return M
```

## 7. Helper `codediff-layout.lua`: layout por tipo de arquivo

Esta é a parte principal. Antes do código, o que o agent precisa saber do funcionamento interno do plugin (conferido no commit de referência):

### 7.1 Eventos que o plugin emite

O CodeDiff dispara autocmds `User` com `event.data`:

- `CodeDiffOpen`: quando a aba de diff é criada. Dados: `tabpage` e `mode` (`"explorer"`, `"standalone"` ou `"history"`). Vem de `ui/view/side_by_side/create.lua` e `ui/view/inline_view/create.lua`.
- `CodeDiffFileSelect`: quando um arquivo é escolhido na lista de arquivos alterados. Dados: `tabpage`, `path` (relativo à raiz) e `status`. Vem de `ui/refresh/init.lua`. Esse evento dispara antes de o conteúdo do arquivo ser lido.
- `CodeDiffClose`: antes da limpeza da sessão. Dados: `tabpage` e `mode`.

Só esses três eventos e a função `toggle_layout` são documentados no README. O resto (`codediff.ui.*`) é interno e pode mudar.

### 7.2 Sessão interna

`require("codediff.ui.lifecycle").get_session(tab)` devolve a tabela da sessão da aba (ou `nil`). Campos usados:

- `session.layout`: `"side-by-side"` ou `"inline"`. Toda sessão nasce `"side-by-side"` e é atualizada pelo toggle.
- `session.original.absolute` e `session.modified.absolute`: caminhos absolutos dos dois lados. Em arquivo apagado o lado `modified` fica vazio, por isso o helper cai no `original`.
- `session.refresh`: controlador de atualização. `session.refresh.loading` fica `true` entre o início da leitura de um arquivo e o fim da montagem dos painéis.
- `session.merge` e `session.result_win`: presentes em sessões de conflito de merge (3 painéis).

### 7.3 Como o toggle funciona

`require("codediff.ui.view").toggle_layout(tab)` chama `ui/view/toggle.lua`:

- Recusa trocar em modo conflito (avisa "Cannot toggle layout in conflict mode").
- Desliga o modo compacto, se estiver ativo, e religa depois.
- Para `inline`, fecha um dos dois painéis e mantém o `modified`. Para `side-by-side`, marca a sessão como painel único e deixa o render abrir o segundo.
- Re-renderiza o arquivo atual (`refresh.reopen`), o que liga `loading` de novo.

Ou seja, é um toggle (não recebe o layout de destino). Por isso o helper compara `session.layout` com o layout desejado antes de chamar.

### 7.4 Lógica do helper

- Escuta `CodeDiffOpen`, `CodeDiffFileSelect` e `CodeDiffClose`.
- A cada evento cria um objeto `request` novo por aba. Se outro evento chegar enquanto o anterior ainda espera, o antigo é abandonado (`requests[tab] ~= request`). Isso evita corrida quando o usuário troca de arquivo rápido.
- Espera `session.refresh.loading` ficar falso, testando a cada 20 ms por até 5 s.
- Pega o caminho absoluto e a extensão em minúsculas.
- Guarda o último caminho tratado por aba (`selected_paths`). Se o arquivo for o mesmo, não faz nada. É isso que preserva a escolha manual feita com `t`, e também impede loop: o re-render causado pelo próprio toggle não reaplica o layout.
- Ignora sessões de conflito.
- No `CodeDiffClose`, limpa o estado da aba.

### 7.5 Código

`lua/insideee-dev/codediff-layout.lua`:

```lua
local M = {}

local text_extensions = { md = true, markdown = true, mdx = true, txt = true, text = true }

function M.setup()
  local requests = {}
  local selected_paths = {}
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("CodeDiffFileLayout", { clear = true }),
    pattern = { "CodeDiffOpen", "CodeDiffFileSelect", "CodeDiffClose" },
    callback = function(event)
      local tab = event.data and event.data.tabpage
      if not tab then
        return
      end
      requests[tab] = nil
      if event.match == "CodeDiffClose" then
        selected_paths[tab] = nil
        return
      end

      local request = {}
      requests[tab] = request
      local deadline = vim.uv.now() + 5000
      local function apply_layout()
        if requests[tab] ~= request or not vim.api.nvim_tabpage_is_valid(tab) then
          return
        end
        local session = require("codediff.ui.lifecycle").get_session(tab)
        if not session then
          return
        end
        -- A seleção chega antes da leitura assíncrona e da criação dos painéis.
        if session.refresh and session.refresh.loading then
          if vim.uv.now() < deadline then
            vim.defer_fn(apply_layout, 20)
          end
          return
        end
        local path = session.modified and session.modified.absolute
        if not path or path == "" then
          path = session.original and session.original.absolute
        end
        if not path or path == "" or selected_paths[tab] == path then
          return
        end
        selected_paths[tab] = path
        if session.merge or session.result_win then
          return
        end
        local extension = path:lower():match("%.([^./]+)$")
        local layout = text_extensions[extension] and "inline" or "side-by-side"
        if session.layout ~= layout then
          require("codediff.ui.view").toggle_layout(tab)
        end
      end
      vim.schedule(apply_layout)
    end,
  })
end

return M
```

### 7.6 Variações

Para mudar quais extensões usam `inline`, edite só `text_extensions` (chaves em minúsculas, sem ponto). Exemplo incluindo reStructuredText e AsciiDoc:

```lua
local text_extensions = { md = true, markdown = true, mdx = true, txt = true, text = true, rst = true, adoc = true }
```

Para decidir por filetype em vez de extensão (útil para arquivos sem extensão, como `README` ou `LICENSE`), troque as duas linhas finais de `apply_layout` por:

```lua
local text_filetypes = { markdown = true, mdx = true, text = true, rst = true, asciidoc = true }
local filetype = vim.filetype.match({ filename = path })
local layout = text_filetypes[filetype] and "inline" or "side-by-side"
```

Coloque `text_filetypes` no topo do módulo, ao lado de `text_extensions`, e não dentro da função.

Para mais de dois grupos (por exemplo, forçar `side-by-side` em `.json` mesmo se o default mudar), use uma tabela de extensão para layout:

```lua
local layouts = { md = "inline", markdown = "inline", mdx = "inline", txt = "inline", json = "side-by-side" }
-- ...
local layout = layouts[extension] or "side-by-side"
```

## 8. Atalhos (`lua/plugins/git.lua`)

`<leader>gd` abre o `:GitDiff`. O `<leader>gD` do LazyVim é desligado. No GitSigns, os atalhos `<leader>ghd`/`<leader>ghD` do LazyVim saem (o diff agora é o CodeDiff) e entram `<leader>hh`/`<leader>hp` para navegar hunks, iguais aos do CodeDiff.

```lua
return {
  {
    "folke/snacks.nvim",
    opts = {
      lazygit = {
        win = { width = 0.98, height = 0.95 },
      },
    },
    keys = {
      { "<leader>gd", "<cmd>GitDiff<cr>", desc = "Git Diff" },
      { "<leader>gD", false },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      local on_attach = opts.on_attach
      opts.on_attach = function(buffer)
        local result = on_attach and on_attach(buffer)
        -- O LazyVim cria estes atalhos a cada buffer anexado ao GitSigns.
        for _, key in ipairs({ "<leader>ghd", "<leader>ghD" }) do
          pcall(vim.keymap.del, "n", key, { buffer = buffer })
        end
        vim.keymap.set("n", "<leader>hh", function()
          require("gitsigns").nav_hunk("next")
        end, { buffer = buffer, desc = "Próximo hunk" })
        vim.keymap.set("n", "<leader>hp", function()
          require("gitsigns").nav_hunk("prev")
        end, { buffer = buffer, desc = "Hunk anterior" })
        return result
      end
    end,
  },
}
```

O bloco `lazygit` não tem relação com o diff; está aqui porque faz parte do mesmo arquivo do usuário. Se o arquivo já existir, o agent deve mesclar só o que falta.

Opcional: com Neogit instalado, coloque `"esmuellert/codediff.nvim"` em `dependencies` do spec do Neogit para ele usar o CodeDiff como visualizador.

## 9. Comandos úteis do CodeDiff

O layout por tipo vale para qualquer sessão, não só para o `:GitDiff`:

- `:CodeDiff`: alterações do working tree contra o index/HEAD.
- `:CodeDiff main` ou `:CodeDiff HEAD~5`: contra uma revisão.
- `:CodeDiff main...`: alterações da branch atual desde o ponto em que saiu da `main`.
- `:CodeDiff --staged`: só o que está no stage.
- `:CodeDiff file HEAD`: só o arquivo atual.
- `:CodeDiff --inline` ou `--side-by-side`: força o layout inicial da sessão. O helper ainda corrige pelo tipo do arquivo depois.
- `:CodeDiff --repo <caminho>`: outro repositório (é o que o `:GitDiff` usa).

## 10. Validação

1. Formatação: `stylua --check init.lua lua/`.
2. Inicialização: `nvim --headless '+qa'` sem erros.
3. API interna ainda presente na versão instalada:

```sh
grep -rn "CodeDiffFileSelect\|function M.toggle_layout\|function M.get_session" ~/.local/share/nvim/lazy/codediff.nvim/lua
grep -n "loading = \|session.refresh = " ~/.local/share/nvim/lazy/codediff.nvim/lua/codediff/ui/refresh/init.lua
```

Se algum desses nomes sumir, o helper precisa ser adaptado antes de qualquer outra coisa.

4. Teste manual num repositório com um `.md` e um `.ts` alterados:
   - `<leader>gd` abre o diff.
   - Selecionar o `.md` mostra layout inline (um painel só).
   - Selecionar o `.ts` mostra side-by-side (dois painéis).
   - Apertar `t` no `.ts` muda para inline, e o layout continua assim até trocar de arquivo.
   - Voltar para o `.md` e depois para o `.ts` reaplica o layout por tipo.
   - `<leader>gd` de novo volta para a mesma aba em vez de abrir outra.
   - `q` fecha o diff, e um novo `<leader>gd` abre uma aba nova.
5. Navegação: `]c`/`[c` e `<leader>hh`/`<leader>hp` dentro do diff e num buffer normal.
6. Conflito: num merge com conflito, o layout não deve ser alterado nem gerar aviso.

## 11. O que não fazer

- Não configurar o painel explorer do CodeDiff, o painel de histórico nem o Neo-tree neste trabalho.
- Não reativar o diffview.nvim.
- Não rodar `:Lazy sync` nem mexer no `lazy-lock.json` sem pedido explícito.
- Não chamar `toggle_layout` sem comparar `session.layout` antes: ele alterna, não define.
