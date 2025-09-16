#!/bin/bash

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}╔════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║  Claude Sub-Agents 프로젝트 레벨 설치     ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════╝${NC}"
echo

# 프로젝트 경로 입력 받기
echo -e "${GREEN}프로젝트 경로를 입력하세요 (절대 경로):${NC}"
echo -e "${BLUE}예: /Users/username/my-project${NC}"
read -p "> " PROJECT_PATH

# 경로 확장 (~ 처리)
PROJECT_PATH="${PROJECT_PATH/#\~/$HOME}"

# 경로 유효성 검사
if [ ! -d "$PROJECT_PATH" ]; then
    echo -e "${RED}❌ 디렉토리가 존재하지 않습니다: $PROJECT_PATH${NC}"
    exit 1
fi

# .claude/agents 디렉토리 확인 및 생성
PROJECT_AGENTS_DIR="$PROJECT_PATH/.claude/agents"

if [ -d "$PROJECT_AGENTS_DIR" ]; then
    echo -e "${BLUE}📁 기존 에이전트 디렉토리 발견: $PROJECT_AGENTS_DIR${NC}"
elif [ -d "$PROJECT_PATH/.claude" ]; then
    echo -e "${BLUE}📁 .claude 디렉토리 발견. agents 폴더 생성...${NC}"
    mkdir -p "$PROJECT_AGENTS_DIR"
else
    echo -e "${YELLOW}📁 .claude 디렉토리가 없습니다. 새로 생성...${NC}"
    mkdir -p "$PROJECT_AGENTS_DIR"
fi

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
    # description 추출
    description=$(grep "^description:" "$agent_file" 2>/dev/null | sed 's/description: //')
    # model 추출
    model=$(grep "^model:" "$agent_file" 2>/dev/null | sed 's/model: //')

    echo -e "${YELLOW}  $((i+1)).${NC} $agent_name ${CYAN}[$model]${NC}"
    if [ -n "$description" ]; then
        echo -e "     ${BLUE}└─ $description${NC}"
    fi
done

echo
echo -e "${GREEN}설치할 에이전트 번호를 입력하세요 (쉼표로 구분):${NC}"
echo -e "예: 1,3,4 또는 0 (전체)"
read -p "> " selection

# 선택한 에이전트 복사
copy_agent() {
    local agent_file="$1"
    local agent_name=$(basename "$agent_file")

    if [ -f "$PROJECT_AGENTS_DIR/$agent_name" ]; then
        echo -e "${YELLOW}  ⚠️  $agent_name 이미 존재함. 덮어쓰시겠습니까? (y/n)${NC}"
        read -p "  > " overwrite
        if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}  ⏭️  $agent_name 건너뜀${NC}"
            return 0
        fi
    fi

    if cp "$agent_file" "$PROJECT_AGENTS_DIR/$agent_name"; then
        echo -e "${GREEN}  ✅ $agent_name 설치 완료${NC}"
    else
        echo -e "${RED}  ❌ $agent_name 설치 실패${NC}"
        return 1
    fi
}

# 선택 처리
if [ "$selection" = "0" ]; then
    echo
    echo -e "${BLUE}📦 전체 에이전트를 프로젝트에 설치 중...${NC}"
    for agent in "${AGENTS[@]}"; do
        copy_agent "$agent"
    done
else
    echo
    echo -e "${BLUE}📦 선택한 에이전트를 프로젝트에 설치 중...${NC}"
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
echo -e "${BLUE}설치 경로: $PROJECT_AGENTS_DIR${NC}"
echo

# 설치된 에이전트 목록 표시
INSTALLED_COUNT=$(ls -1 "$PROJECT_AGENTS_DIR"/*.md 2>/dev/null | wc -l)
if [ "$INSTALLED_COUNT" -gt 0 ]; then
    echo -e "${CYAN}📋 설치된 에이전트 (총 $INSTALLED_COUNT개):${NC}"
    ls -1 "$PROJECT_AGENTS_DIR"/*.md 2>/dev/null | while read file; do
        echo -e "  • $(basename "$file" .md)"
    done
fi

echo
echo -e "${YELLOW}💡 프로젝트를 Claude Code로 열면 에이전트가 자동으로 로드됩니다.${NC}"