# 시작하기

## 1. 요구 사항

| 항목 | 필수 | 용도 |
|---|---|---|
| Claude Code | 필수 | 하네스를 실행하는 환경 |
| Git, Bash | 필수 | 훅과 설치 스크립트 |
| Python 3 또는 Node.js | 필수 | Git 가드 훅이 Claude Code 입력(JSON)을 읽을 때 사용 |
| 테스트 도구 (Jest, Vitest, pytest 등) | 권장 | Impl 단계 TDD |
| ESLint, TypeScript | 권장 | 자동 검증 |
| Playwright | 권장 | E2E 자동 검증 |
| `gitleaks` | 선택 | 시크릿 검사를 한 겹 더 |
| Sentry MCP 또는 `sentry-cli` | 선택 | 개발 환경 새 이슈 확인 |
| Codex(앱 또는 CLI), Antigravity | 선택 | 피어 리뷰 |
| Claude Code Computer Use | 선택 | 피어 리뷰 앱 자동 조작 |

## 2. 설치

설치할 프로젝트는 Git 저장소여야 합니다.

```bash
git clone https://github.com/JJonyeok2/Claude_Harness.git
bash Claude_Harness/scripts/install.sh /path/to/my-project
```

설치 스크립트가 하는 일:

1. `CLAUDE.md`, `.claude/`, `.githooks/`, `scripts/`, `docs/templates/`, `docs/conventions/`를 복사합니다. 이미 같은 파일이 있으면 덮어쓰지 않고 건너뜁니다.
2. `docs/spec`, `docs/tasks`, `docs/qa`, `docs/review`, `docs/feedback`, `docs/status` 폴더를 만듭니다.
3. `.gitignore`에 `.env` 계열, 키 파일, Playwright 결과물을 추가합니다. 이미 있는 줄은 중복으로 넣지 않습니다.
4. `git config core.hooksPath .githooks`로 Git 훅을 켭니다.
5. `git config user.name JJonyeok`을 이 저장소에만 설정합니다. 이메일은 기존 값을 그대로 씁니다.

> 다른 사람이 쓰거나 다른 이름으로 커밋하려면 [내 프로젝트에 맞추기](customizing.md#작성자-이름)를 먼저 보세요.

### 검증 도구 설치 (처음 한 번)

```bash
npm init @eslint/config@latest
npm init playwright@latest
brew install gitleaks        # 선택
```

## 3. 첫 사이클 따라 하기

예시로 "할 일 목록에 마감일 표시"를 만든다고 가정합니다.

### 3-1. 요청

```
/run 할 일 목록에 마감일을 표시하고, 지난 항목은 빨간색으로 보이게 해 줘
```

오케스트레이터가 먼저 단계를 밝힙니다.

```
> 단계: Spec (새 화면 요소와 표시 규칙 추가) | 다음: Task
```

### 3-2. Spec 승인

`spec-agent`가 `docs/spec/SPEC.md`를 쓰고 질문을 돌려줍니다.

```
확인이 필요한 것
1. 마감일이 없는 항목은 어떻게 표시할까요?
2. "지난 항목"의 기준은 오늘 0시인가요, 현재 시각인가요?

이 Spec으로 Task를 나눠도 될까요?
```

답하고 승인하면 다음 단계로 넘어갑니다. **승인 전에는 절대 넘어가지 않습니다.**

### 3-3. Task 분해

`task-agent`가 `docs/tasks/`에 Task 파일과 `INDEX.md`를 만듭니다.

```
| 순서 | Task | 실행 방식 | 그룹 | 선행 Task |
|---|---|---|---|---|
| 1 | TASK-01 마감일 필드와 타입 | 순차 | - | - |
| 2 | TASK-02 마감일 포맷 함수 | 병렬 | G1 | 01 |
| 2 | TASK-03 지남 여부 판정 함수 | 병렬 | G1 | 01 |
| 3 | TASK-04 목록 화면에 표시 | 순차 | - | 02, 03 |
```

### 3-4. 구현과 QA (자동)

오케스트레이터가 순서대로 진행합니다. 사람이 할 일은 없습니다.

```
> 단계: IMPL (TASK-01) | 다음: QA
> 단계: QA (TASK-01) | 판정: PASS | 다음: IMPL 병렬 G1
> 단계: IMPL 병렬 G1 (TASK-02, 03) | 02 완료, 03 진행 중
> 단계: QA (TASK-03) | 판정: FIX 1회차 | 다음: IMPL
...
```

중간에 상태가 궁금하면 `/status`를 칩니다.

### 3-5. 자동 검증과 최종 확인

모든 Task가 PASS면 `verify-agent`가 테스트, 타입 검사, ESLint, Playwright를 돌리고, 통과하면 로컬 서버를 띄웁니다.

```
http://localhost:3000 에서 확인해 주세요.
- [ ] 마감일이 있는 항목에 날짜가 보인다
- [ ] 어제 마감 항목이 빨간색이다
- [ ] 마감일이 없는 항목은 "마감일 없음"으로 보인다
```

직접 써 보고 부족한 점을 말하면, 오케스트레이터가 어느 단계 문제인지 분류해 되돌립니다.

```
> 단계: 사용자 최종 검증 → Impl (TASK-04 색상이 다크 모드에서 안 보임)
```

### 3-6. 커밋

"통과"라고 말한 뒤 커밋을 요청합니다.

```
/ship 할 일 마감일 표시 기능
```

시크릿 검사를 통과하면 메시지를 보여 주고, 확인을 받은 뒤 `JJonyeok` 이름으로 커밋합니다. 푸시는 따로 요청할 때만 합니다.

## 4. 이어서 하기

세션이 끊겼거나 다음 날 다시 시작할 때는 인자 없이 치면 됩니다.

```
/run
```

`docs/STATE.md`를 읽고 멈춘 단계부터 이어서 진행합니다.
