# 補完機能有効にする
# autoload -U compinit
# compinit -u

fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit
compinit

# 補完候補に色つける
autoload -U colors
colors
zstyle ':completion:*' list-colors "${LS_COLORS}"

# 単語の入力途中でもTab補完を有効化
setopt complete_in_word
# 補完候補をハイライト
zstyle ':completion:*:default' menu select=1
# キャッシュの利用による補完の高速化
zstyle ':completion::complete:*' use-cache true
# 大文字、小文字を区別せず補完する
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完リストの表示間隔を狭くする
setopt list_packed

# コマンドの打ち間違いを指摘してくれる
setopt correct
SPROMPT="correct: $RED%R$DEFAULT -> $GREEN%r$DEFAULT ? [Yes/No/Abort/Edit] => "

export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=100000
setopt hist_ignore_dups
setopt EXTENDED_HISTORY

alias zrc='vim ~/.zshrc'
alias szrc='source ~/.zshrc'
alias vrc='vim ~/.vimrc'
alias vstar='vim ~/.config/starship.toml'

alias posh='poetry shell'
alias gist='git status'
alias gips='git push origin'
alias gipl='git pull origin'
alias gibr='git branch'
alias giad='git add'
alias gich='git checkout'
alias giff='git diff'
alias giffc='git diff --cached'
alias gilg='git log'
alias gicm='git commit -m'
alias rm='trash-put'

if type eza > /dev/null 2>&1; then
  # 標準の ls を eza に置き換え（色付き、アイコン表示）
  alias ls='eza --icons --color=always --group-directories-first'

  # ll: 詳細リスト表示（パーミッション、サイズ、Gitステータスなど）
  alias ll='eza -hl --icons --color=always --group-directories-first --git'

  # la: 隠しファイルも含めてすべて表示
  alias la='eza -ahl --icons --color=always --group-directories-first --git'

  # lt: ディレクトリ構造をツリー状に表示（標準の tree コマンドの代わり）
  alias lt='eza --tree --icons --level=2'
else
  # もし eza がインストールされていない環境のためのフォールバック
  alias ll='ls -l'
  alias la='ls -la'
fi

eval "$(zoxide init zsh)"
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

fbr() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# fcd - cd to selected directory
fcd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# keybind
bindkey \^U backward-kill-line

fzf-select-history() {
    BUFFER=$(history -n -r 1 | fzf --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N fzf-select-history
bindkey '^r' fzf-select-history

function center-of-line() {
    CURSOR=$((${#BUFFER} / 2))
    zle redisplay
}
zle -N center-of-line
bindkey "^x" center-of-line

eval "$(starship init zsh)"
