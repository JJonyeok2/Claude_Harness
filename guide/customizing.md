# 내 프로젝트에 맞추기

## 작성자 이름

기본값은 `JJonyeok`입니다. 다른 이름을 쓰려면 아래 네 곳을 바꿉니다.

| 파일 | 바꿀 곳 |
|---|---|
| `scripts/install.sh` | `git config user.name "JJonyeok"` |
| `scripts/claude-git-guard.sh` | `if [ "$name" != "JJonyeok" ]` |
| `.githooks/pre-commit` | `if [ "$name" != "JJonyeok" ]` |
| `CLAUDE.md`, `.claude/commands/ship.md` | 문서 속 `JJonyeok` |

한 번에 바꾸기:

```bash
grep -rl "JJonyeok" CLAUDE.md .claude scripts .githooks | xargs sed -i '' 's/JJonyeok/새이름/g'   # macOS
grep -rl "JJonyeok" CLAUDE.md .claude scripts .githooks | xargs sed -i 's/JJonyeok/새이름/g'      # Linux
```

## 검증 명령

`.claude/agents/verify-agent.md`와 `CLAUDE.md` 5장의 명령을 프로젝트에 맞게 바꿉니다.

| 스택 | 테스트 | 타입 | 린트 | E2E |
|---|---|---|---|---|
| Node, TypeScript (기본) | `npm test` | `npx tsc --noEmit` | `npx eslint . --max-warnings=0` | `npx playwright test` |
| Python, Django | `pytest` | `mypy .` | `ruff check .` | `pytest --browser chromium` (pytest-playwright) |
| React Native | `npm test` | `npx tsc --noEmit` | `npx eslint .` | Detox 또는 Maestro |

## 시크릿 패턴 추가

`scripts/check-secrets.sh`의 `patterns=( ... )` 배열에 한 줄을 추가합니다.

```bash
patterns=(
  ...
  'tvly-[A-Za-z0-9]{20,}'      # 예: 다른 서비스 키
)
```

추가한 뒤 확인:

```bash
echo 'k = "tvly-abcdefghijklmnopqrstu"' > secret-test.js
git add secret-test.js && bash scripts/check-secrets.sh --staged   # 차단되면 정상
git rm --cached -q secret-test.js && rm secret-test.js
```

## 커밋 메시지 금지어

`.githooks/commit-msg`의 `banned=` 정규식과 `scripts/claude-git-guard.sh`의 `banned=` 정규식을 함께 바꿉니다.

## 병렬 한도와 Task 크기

| 항목 | 파일 | 기본값 |
|---|---|---|
| 동시 실행 Task 수 | `.claude/commands/run.md` | 3 |
| FIX 자동 반복 횟수 | `.claude/commands/run.md`, `.claude/commands/impl.md` | 2 |
| Task 크기 기준 | `.claude/agents/task-agent.md` | 파일 5개 이하, 테스트 3~8개 |
| 멈춤 의심 기준 | `.claude/agents/status-agent.md` | 30분 |
| 피어 리뷰 답변 대기 한도 | `.claude/commands/peer-review.md` | 10분 |

## 헤더/푸터 주석 형식

`docs/conventions/file-header-footer.md`를 고치면 QA 에이전트가 그 형식을 따릅니다.

## 대화 언어

`CLAUDE.md` 0장 "대화 규칙"과 각 에이전트 파일 끝의 "답변은 한국어로 한다"를 바꿉니다.

## 이미 설치한 프로젝트에 업데이트 반영

`install.sh`는 이미 있는 파일을 덮어쓰지 않습니다. 새 버전을 반영하려면 바꾸고 싶은 파일을 지운 뒤 다시 설치하거나, 직접 비교해서 합칩니다.

```bash
diff -r Claude_Harness/.claude /path/to/my-project/.claude
```
