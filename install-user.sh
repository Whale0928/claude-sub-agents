#!/bin/bash

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 사용자 홈 디렉토리의 Claude 에이전트 경로
USER_AGENTS_DIR="$HOME/.claude/agents"

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Claude Sub-Agents 사용자 레벨 설치   ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo

# agents 디렉토리에서 .md 파일 목록 가져오기
AGENTS=($(ls agents/*.md 2>/dev/null))

if [ ${#AGENTS[@]} -eq 0 ]; then
    echo -e "${RED}❌ agents 디렉토리에 에이전트 파일이 없습니다.${NC}"
    exit 1
fi

# 에이전트 목록 표시
echo -e "${GREEN}📋 사용 가능한 에이전트 목록:${NC}"
echo
echo -e "${YELLOW}  0.${NC} 전체 설치"

for i in "${!AGENTS[@]}"; do
    agent_file="${AGENTS[$i]}"
    agent_name=$(basename "$agent_file" .md)
    # description 추출 (있는 경우)
    description=$(grep "^description:" "$agent_file" 2>/dev/null | sed 's/description: //')

    if [ -n "$description" ]; then
        echo -e "${YELLOW}  $((i+1)).${NC} $agent_name"
        echo -e "     ${BLUE}└─ $description${NC}"
    else
        echo -e "${YELLOW}  $((i+1)).${NC} $agent_name"
    fi
done

echo
echo -e "${GREEN}선택할 에이전트 번호를 입력하세요 (쉼표로 구분):${NC}"
echo -e "예: 1,3,4 또는 0 (전체)"
read -p "> " selection

# 사용자 에이전트 디렉토리 생성
mkdir -p "$USER_AGENTS_DIR"

# 선택한 에이전트 복사
copy_agent() {
    local agent_file="$1"
    local agent_name=$(basename "$agent_file")

    if cp "$agent_file" "$USER_AGENTS_DIR/$agent_name"; then
        echo -e "${GREEN}  ✅ $agent_name 설치 완료${NC}"
    else
        echo -e "${RED}  ❌ $agent_name 설치 실패${NC}"
        return 1
    fi
}

# 선택 처리
if [ "$selection" = "0" ]; then
    echo
    echo -e "${BLUE}📦 전체 에이전트 설치 중...${NC}"
    for agent in "${AGENTS[@]}"; do
        copy_agent "$agent"
    done
else
    echo
    echo -e "${BLUE}📦 선택한 에이전트 설치 중...${NC}"
    IFS=',' read -ra SELECTED <<< "$selection"
    for i in "${SELECTED[@]}"; do
        # 공백 제거
        i=$(echo "$i" | tr -d ' ')
        # 유효한 번호인지 확인
        if [[ "$i" =~ ^[0-9]+$ ]] && [ "$i" -ge 1 ] && [ "$i" -le ${#AGENTS[@]} ]; then
            copy_agent "${AGENTS[$((i-1))]}"
        else
            echo -e "${RED}  ⚠️  잘못된 번호: $i (건너뜀)${NC}"
        fi
    done
fi

echo
echo -e "${GREEN}✨ 설치 완료!${NC}"
echo -e "${BLUE}설치 경로: $USER_AGENTS_DIR${NC}"
echo
echo -e "${YELLOW}💡 Claude Code를 재시작하면 에이전트가 자동으로 로드됩니다.${NC}"