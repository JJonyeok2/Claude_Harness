---
description: Task 하나를 TDD로 구현
argument-hint: [Task 번호, 예: 03]
---

> 단계: Impl (TASK-$ARGUMENTS)

1. `docs/tasks/TASK-$ARGUMENTS-*.md`를 찾는다.
2. 그 Task 파일이 참조하는 Spec 섹션만 뽑아서, Task 파일 경로와 함께 `impl-agent`에게 넘긴다.
3. Red, Green, Refactor 결과를 받으면 바로 `qa-agent`에게 같은 Task로 QA를 맡긴다.
4. QA 판정에 따라:
   - `PASS` → 사용자에게 알리고 `/verify` 진행을 제안
   - `FIX` → 고칠 항목을 `impl-agent`에게 다시 넘김 (최대 2회, 그 이상은 사용자에게 보고)
   - `PEER_REVIEW` → `/peer-review $ARGUMENTS both` 절차를 바로 실행 (Computer Use로 Codex, Antigravity 교차 검증)
