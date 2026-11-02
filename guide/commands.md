# 명령어 레퍼런스

모든 명령은 `.claude/commands/`에 있습니다. 평소에는 `/run`과 `/status`만 써도 됩니다. 나머지는 특정 단계만 다시 돌리고 싶을 때 씁니다.

## `/run [요청]`

오케스트레이터. 요청을 단계 판별한 뒤 상태 흐름대로 끝까지 진행합니다.

```
/run 장바구니에 쿠폰 적용 기능 추가해 줘
/run 결제 완료 후 화면이 하얗게 나와
/run
```

- 요청이 없으면 `docs/STATE.md`를 읽고 멈춘 곳부터 이어서 진행합니다.
- 상태가 바뀔 때마다 한 줄씩 보고합니다: `> 단계: QA (TASK-03) | 판정: PASS | 다음: VERIFY`

## `/status`

`status-agent`로 에이전트별 상태와 어긋난 곳을 점검합니다. 파일을 바꾸지 않습니다.

## `/spec [요청]`

`spec-agent`로 `docs/spec/SPEC.md`를 쓰거나 고칩니다. 끝나면 질문 목록과 승인 요청을 보여 줍니다.

```
/spec 비밀번호 찾기를 이메일 인증 방식으로 추가
```

## `/task [기능 ID]`

승인된 Spec을 Task로 나눕니다. 비우면 전체 기능, 기능 ID를 주면 그 기능만 나눕니다.

```
/task
/task F-03
```

## `/impl <Task 번호>`

한 Task를 TDD로 구현하고 이어서 QA까지 돌립니다.

```
/impl 03
```

- QA가 `FIX`면 Impl로 다시 넘기며, 최대 2회까지 자동으로 반복합니다.
- QA가 `PEER_REVIEW`면 바로 `/peer-review 03 both` 절차를 실행합니다.

## `/qa <Task 번호>`

QA만 다시 실행합니다. 직접 코드를 손본 뒤 다시 검토받고 싶을 때 씁니다.

## `/peer-review <Task 번호> [리뷰어]`

Computer Use로 Codex, Antigravity를 띄워 교차 리뷰를 받습니다. 리뷰어는 `codex`, `antigravity`, `both` 중 하나이고, 비우면 `both`입니다.

```
/peer-review 03
/peer-review 03 codex
```

대화로 "피어 리뷰 해", "교차 검증 돌려"라고만 해도 실행됩니다. 자세한 절차는 [피어 리뷰](peer-review.md).

## `/verify`

테스트, 타입 검사, ESLint, Playwright, Sentry를 돌리고, 모두 통과하면 로컬 서버를 띄워 확인 체크리스트를 줍니다.

## `/ship <커밋 요지>`

시크릿 검사 후 커밋합니다.

```
/ship 쿠폰 적용 기능
```

1. 사용자 최종 검증이 "통과"였는지 확인
2. `.env` 계열 파일을 스테이징에서 제외
3. `scripts/check-secrets.sh --staged`
4. 작성자 `JJonyeok` 확인
5. `<type>: <한국어 요약>` 형식으로 메시지 작성 후 확인 받기
6. 커밋 (푸시는 따로 요청할 때만)

## 명령과 단계 대응

| 명령 | Spec | Task | Impl | QA | 피어 리뷰 | 검증 | 최종 확인 | Git |
|---|---|---|---|---|---|---|---|---|
| `/run` | ● | ● | ● | ● | ● | ● | ● | ● |
| `/spec` | ● | | | | | | | |
| `/task` | | ● | | | | | | |
| `/impl` | | | ● | ● | ● | | | |
| `/qa` | | | | ● | | | | |
| `/peer-review` | | | | | ● | | | |
| `/verify` | | | | | | ● | ● | |
| `/ship` | | | | | | | | ● |
