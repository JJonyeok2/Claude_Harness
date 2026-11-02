#!/usr/bin/env bash
# 하네스를 대상 프로젝트에 설치한다.
# 사용법: bash scripts/install.sh /path/to/my-project

set -e
src="$(cd "$(dirname "$0")/.." && pwd)"
dst="${1:?설치할 프로젝트 경로를 넣어 주세요}"
cd "$dst"
git rev-parse --git-dir >/dev/null 2>&1 || { echo "git 저장소가 아닙니다: $dst"; exit 1; }

copy() { # 이미 있으면 덮어쓰지 않고 알려 준다
  if [ -e "$dst/$1" ]; then echo "  건너뜀(이미 있음): $1"; else mkdir -p "$(dirname "$dst/$1")"; cp -R "$src/$1" "$dst/$1"; echo "  복사: $1"; fi
}

echo "하네스 파일 복사"
copy CLAUDE.md
copy .claude/settings.json
for f in "$src"/.claude/agents/*.md;   do copy ".claude/agents/$(basename "$f")"; done
for f in "$src"/.claude/commands/*.md; do copy ".claude/commands/$(basename "$f")"; done
copy .githooks/pre-commit
copy .githooks/commit-msg
copy scripts/check-secrets.sh
copy scripts/claude-git-guard.sh
for f in "$src"/docs/templates/*.md;   do copy "docs/templates/$(basename "$f")"; done
copy docs/conventions/file-header-footer.md
mkdir -p docs/spec docs/tasks docs/qa docs/review docs/feedback docs/status

echo ".gitignore 보강"
touch .gitignore
while IFS= read -r line; do
  [ -z "$line" ] && continue
  grep -qxF "$line" .gitignore || echo "$line" >> .gitignore
done < "$src/gitignore.snippet"

echo "git 설정"
chmod +x .githooks/* scripts/*.sh
git config core.hooksPath .githooks
git config user.name "JJonyeok"

echo "완료. git config user.email 은 기존 값을 그대로 씁니다: $(git config user.email || echo '(미설정)')"
