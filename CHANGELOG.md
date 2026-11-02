# 변경 이력

## 0.2.0 (2026-11-02)

### 변경
- 토큰 절감: Impl, QA 에이전트에게 Spec 전체 대신 Task 파일 하나만 전달
  - Task 템플릿에 "기능 범위(Spec 발췌)"와 "연결 범위(받아 쓰는 것, 내보내는 것의 계약)" 칸 추가
  - `task-agent`에 발췌 규칙 추가 (넣는 것과 넣지 않는 것, 60줄 안팎 기준)
  - `impl-agent`는 SPEC과 다른 Task 파일을 열지 않고, 정보가 부족하면 추측 대신 중단
  - 오케스트레이터가 부족한 줄만 "추가 발췌"로 보충, 3회를 넘으면 Task 재분해
  - `qa-agent`가 "내보내는 것" 계약이 바뀌었는지 확인

## 0.1.0 (2026-11-02)

첫 공개 버전.

### 추가
- Spec → Task → Impl → QA → 자동 검증 → 사용자 최종 검증 → Git 게이트 작업 흐름 (`CLAUDE.md`)
- 단계 판별표: 요청을 받으면 어느 단계인지 먼저 밝히는 규칙
- 메인 오케스트레이터 `/run`과 진행 상태 파일 `docs/STATE.md`
- 작업 에이전트 5개: `spec-agent`, `task-agent`, `impl-agent`(TDD), `qa-agent`, `verify-agent`
- 점검 에이전트 `status-agent`와 `/status`, 에이전트 로그 `docs/status/AGENT_LOG.md`
- 병렬/순차 실행: Task별 분류, 병렬 그룹 최대 3개 동시 실행, worktree 격리와 병합
- Computer Use 기반 피어 리뷰: Codex, Antigravity 교차 검증과 안전장치
- Git 안전장치: `.env` 읽기 차단, PreToolUse Git 가드 훅, `pre-commit`, `commit-msg`, 시크릿 검사 스크립트
- 템플릿: SPEC, TASK, QA_REPORT, PEER_REVIEW_REQUEST, STATE, 헤더/푸터 주석 규칙
- 설치 스크립트 `scripts/install.sh`
- 설명서 `guide/`
