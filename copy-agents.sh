#!/bin/bash

# Claude 서브 에이전트 자동 설치 스크립트
# agents 폴더의 모든 파일을 ~/.claude/agents 폴더로 복사

echo "🚀 Claude 서브 에이전트 설치 시작..."

# .claude/agents 디렉토리 생성 (없는 경우)
if [ ! -d "$HOME/.claude/agents" ]; then
    echo "📁 ~/.claude/agents 디렉토리 생성 중..."
    mkdir -p "$HOME/.claude/agents"
fi

# agents 디렉토리 확인
if [ ! -d "./agents" ]; then
    echo "❌ ./agents 디렉토리를 찾을 수 없습니다."
    echo "   프로젝트 루트에서 실행해주세요."
    exit 1
fi

# 기존 파일 백업 (있는 경우)
backup_dir="$HOME/.claude/agents/backup-$(date +%Y%m%d_%H%M%S)"
existing_files=false

for file in ./agents/*.md; do
    filename=$(basename "$file")
    if [ -f "$HOME/.claude/agents/$filename" ]; then
        if [ "$existing_files" = false ]; then
            echo "💾 기존 파일 백업 중..."
            mkdir -p "$backup_dir"
            existing_files=true
        fi
        cp "$HOME/.claude/agents/$filename" "$backup_dir/"
        echo "   백업: $filename"
    fi
done

if [ "$existing_files" = true ]; then
    echo "   백업 완료: $backup_dir"
fi

# 새 파일들 복사
echo "📋 에이전트 설치 중..."
copied_count=0

for file in ./agents/*.md; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        cp "$file" "$HOME/.claude/agents/"
        echo "   설치: $filename"
        ((copied_count++))
    fi
done

echo ""
echo "✅ 설치 완료!"
echo "   설치된 에이전트: ${copied_count}개"
echo "   위치: ~/.claude/agents/"

if [ "$existing_files" = true ]; then
    echo "   백업 위치: $backup_dir"
fi

echo ""
echo "🎯 사용 방법:"
echo "   Claude Code에서 다음과 같이 호출하세요:"
echo "   - work-note-path-finder 호출해서 파일 경로 찾아줘"
echo "   - work-note-templater 호출해서 대화를 템플릿으로 만들어줘"
echo "   - work-note-writer 호출해서 템플릿을 파일에 저장해줘"
echo ""
echo "   또는 통합 에이전트:"
echo "   - 업무노트 작성해줘"
