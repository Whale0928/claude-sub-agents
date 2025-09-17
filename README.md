# Claude Sub-Agents

개인적으로 사용하는 Claude Code 서브 에이전트를 관리하는 프로젝트입니다.

## 📚 Claude Code Subagents 소개

서브 에이전트는 Claude Code SDK의 강력한 기능으로, 특정 작업을 위한 전문화된 AI 에이전트를 만들 수 있습니다. 각 서브 에이전트는 독립적인 컨텍스트를 유지하며, 병렬로 실행될 수 있어 복잡한 작업을 효율적으로 처리합니다.

### 주요 이점

- **컨텍스트 관리**: 각 에이전트가 독립적인 컨텍스트 유지
- **병렬 처리**: 여러 에이전트 동시 실행 가능
- **전문화**: 특정 도메인이나 작업에 최적화
- **도구 제한**: 필요한 도구만 선택적으로 접근 가능

## 📖 공식 문서

- [Claude Code Subagents 가이드](https://docs.anthropic.com/en/docs/claude-code/sdk/subagents.md)
- [Claude Code 문서 맵](https://docs.anthropic.com/en/docs/claude-code/claude_code_docs_map.md)

## 🔧 서브 에이전트 구조

서브 에이전트는 markdown 파일로 정의되며, YAML frontmatter를 포함합니다:

```markdown
---
name: example-agent
description: Brief description of what this agent does
tools: Read, Write, Bash, Grep
model: opus-4
---

# Agent Instructions

여기에 에이전트의 상세한 지시사항을 작성합니다.
```

### 필수 필드

- `name`: 에이전트 식별자
- `description`: 에이전트 기능 설명
- `tools`: 사용 가능한 도구 목록
- `model`: 사용할 모델 (opus-4, sonet-4, claude-3-haiku 등)

## ⚙️ 설치 방법

### 기존 서브 에이전트 제거 (선택적)

```bash
rm -rf ~/.claude/agents
```
```bash
rm -rf /path/to/project/.claude/agents
```

### 사용자 레벨 설치 (전역)

모든 프로젝트에서 사용 가능한 에이전트 설치:

```bash
./install-user.sh
```

### 프로젝트 레벨 설치 (특정 프로젝트)

특정 프로젝트에만 적용되는 에이전트 설치:

```bash
./install-project.sh
```

### 수동 설치

```bash
# 사용자 레벨
mkdir -p ~/.claude/agents
cp agents/*.md ~/.claude/agents/

# 프로젝트 레벨
mkdir -p /path/to/project/.claude/agents
cp agents/*.md /path/to/project/.claude/agents/
```

## 📂 디렉토리 구조

```
claude-sub-agents/
├── agents/              # 서브 에이전트 파일들
│   └── *.md            # 개별 에이전트 정의
├── install-user.sh     # 사용자 레벨 설치 스크립트
├── install-project.sh  # 프로젝트 레벨 설치 스크립트
└── README.md           # 이 문서
```

## 🚀 사용법

1. 에이전트를 `~/.claude/agents/` 디렉토리에 설치
2. Claude Code가 자동으로 에이전트를 감지하고 로드
3. 작업 컨텍스트에 따라 적절한 에이전트가 자동 호출됨

## 📝 라이선스

개인 사용 목적의 프로젝트입니다.
