#!/bin/bash
#
# Claude Learning Mode — Init Script
# Sets up Claude Code as a personal programming tutor
#
# Usage: ./init.sh [target-directory]
#   target-directory: the project where you want learning mode (default: current directory)

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-.}"

# ---------- Validations ----------

# Check target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}Error: Directory '$TARGET_DIR' does not exist.${NC}"
    echo "Create it first or specify a valid directory."
    exit 1
fi

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

# Check templates exist
if [ ! -d "${SCRIPT_DIR}/templates" ]; then
    echo -e "${RED}Error: Templates directory not found at ${SCRIPT_DIR}/templates${NC}"
    echo "Make sure the framework is intact."
    exit 1
fi

# Check not running inside the framework itself
if [ "$TARGET_DIR" = "$SCRIPT_DIR" ]; then
    echo -e "${RED}Error: Cannot init inside the framework directory itself.${NC}"
    echo "Run: ./init.sh /path/to/your/project"
    exit 1
fi

# Warn if no git repo
HAS_GIT=true
if [ ! -d "${TARGET_DIR}/.git" ]; then
    HAS_GIT=false
    echo -e "${YELLOW}Warning: ${TARGET_DIR} is not a git repository.${NC}"
    echo -e "${YELLOW}Git is recommended to track your learning progress across sessions.${NC}"
    echo -e "${YELLOW}You can run 'git init' later to set it up.${NC}"
    read -rp "$(echo -e "${YELLOW}Continue without git? [y/N]: ${NC}")" CONTINUE
    if [[ ! "$CONTINUE" =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
fi

# Detect if directory is empty (no source files) — offer "from scratch" mode
FILE_COUNT=$(find "$TARGET_DIR" -maxdepth 2 -type f \( -name "*.go" -o -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.tsx" -o -name "*.jsx" -o -name "*.rs" -o -name "*.java" -o -name "*.rb" -o -name "*.c" -o -name "*.cpp" -o -name "*.cs" \) 2>/dev/null | head -5 | wc -l)
PROJECT_MODE="existing"
PROJECT_IDEA=""
PROJECT_GOALS=""
if [ "$FILE_COUNT" -eq 0 ]; then
    echo -e "${BLUE}${BOLD}No source code found in this directory.${NC}"
    echo ""
    echo -e "${YELLOW}How do you want to use Learning Mode?${NC}"
    echo "  1) From scratch — I have a project idea and want to build it from zero"
    echo "  2) Existing project — I'll add code later, just set up learning mode"
    read -rp "$(echo -e "${YELLOW}Choose [1/2]: ${NC}")" MODE_CHOICE

    case $MODE_CHOICE in
        1)
            PROJECT_MODE="from-scratch"
            echo ""
            echo -e "${BLUE}${BOLD}Great! Let's plan your project.${NC}"
            echo -e "${YELLOW}Describe your project idea (what do you want to build?):${NC}"
            read -rp "> " PROJECT_IDEA
            echo ""
            echo -e "${YELLOW}What's the main goal? (e.g., 'learn REST APIs', 'build a portfolio', 'practice DDD'):${NC}"
            read -rp "> " PROJECT_GOALS
            ;;
        2)
            PROJECT_MODE="existing"
            ;;
        *)
            PROJECT_MODE="existing"
            ;;
    esac
fi

# Check if already initialized
if [ -d "${TARGET_DIR}/cours" ] && [ -f "${TARGET_DIR}/cours/suivi-progression.md" ]; then
    echo -e "${YELLOW}Warning: Learning mode seems already initialized (cours/ folder exists).${NC}"
    read -rp "$(echo -e "${YELLOW}Overwrite? This will reset your progress! [y/N]: ${NC}")" OVERWRITE
    if [[ ! "$OVERWRITE" =~ ^[Yy]$ ]]; then
        echo "Aborted. Your existing progress is safe."
        exit 0
    fi
fi

echo -e "${BLUE}${BOLD}"
echo "============================================"
if [ "$PROJECT_MODE" = "from-scratch" ]; then
    echo "  Claude Learning Mode — New Project Setup"
else
    echo "  Claude Learning Mode — Setup"
fi
echo "============================================"
echo -e "${NC}"

# ---------- Interactive config ----------

read -rp "$(echo -e "${YELLOW}Student name: ${NC}")" STUDENT_NAME
read -rp "$(echo -e "${YELLOW}Programming language (e.g., Go, Python, TypeScript): ${NC}")" LANGUAGE
read -rp "$(echo -e "${YELLOW}Project name (e.g., Review Reminder, My API): ${NC}")" PROJECT_NAME

if [ "$PROJECT_MODE" = "from-scratch" ]; then
    # In from-scratch mode, the project idea serves as the description
    PROJECT_DESC="${PROJECT_IDEA}"
    echo -e "${YELLOW}Tech stack you want to learn/use (e.g., Go / Gin / PostgreSQL, or 'not sure yet'):${NC}"
    read -rp "> " TECH_STACK
else
    read -rp "$(echo -e "${YELLOW}Project description (one sentence): ${NC}")" PROJECT_DESC
    read -rp "$(echo -e "${YELLOW}Tech stack (e.g., Go / Gin / PostgreSQL / Temporal): ${NC}")" TECH_STACK
fi

echo ""
echo -e "${YELLOW}Student level:${NC}"
echo "  1) Beginner — first time coding or very early"
echo "  2) Intermediate — knows basics, learning architecture/patterns"
echo "  3) Advanced — comfortable coding, learning advanced patterns"
read -rp "$(echo -e "${YELLOW}Choose [1/2/3]: ${NC}")" LEVEL_CHOICE

case $LEVEL_CHOICE in
    1) STUDENT_LEVEL="beginner" ;;
    2) STUDENT_LEVEL="intermediate" ;;
    3) STUDENT_LEVEL="advanced" ;;
    *) STUDENT_LEVEL="intermediate" ;;
esac

echo ""
echo -e "${YELLOW}Schedule type:${NC}"
echo "  1) Alternance (school/work rotation)"
echo "  2) Full-time work"
echo "  3) Full-time school"
echo "  4) Self-study (no fixed schedule)"
read -rp "$(echo -e "${YELLOW}Choose [1/2/3/4]: ${NC}")" SCHEDULE_CHOICE

SCHEDULE_TYPE=""
SCHEDULE_DETAILS=""
case $SCHEDULE_CHOICE in
    1)
        SCHEDULE_TYPE="alternance"
        echo ""
        echo -e "${YELLOW}Enter your school weeks (comma-separated, e.g., 'March 09-13, March 30-April 03'):${NC}"
        read -rp "> " SCHEDULE_DETAILS
        ;;
    2) SCHEDULE_TYPE="full-time-work" ;;
    3) SCHEDULE_TYPE="full-time-school" ;;
    4) SCHEDULE_TYPE="self-study" ;;
    *) SCHEDULE_TYPE="self-study" ;;
esac

echo ""
read -rp "$(echo -e "${YELLOW}Daily end time (e.g., 18h30, or 'flexible'): ${NC}")" END_TIME

echo ""
read -rp "$(echo -e "${YELLOW}Team context? (e.g., 'works with senior devs who review PRs', or 'solo'): ${NC}")" TEAM_CONTEXT

# ---------- Generate files ----------

echo ""
if [ "$PROJECT_MODE" = "from-scratch" ]; then
    echo -e "${BLUE}Generating files for new project in ${TARGET_DIR}...${NC}"
else
    echo -e "${BLUE}Generating files in ${TARGET_DIR}...${NC}"
fi

TODAY=$(date +%Y-%m-%d)

# --- Helper: replace placeholders in a template ---
render_template() {
    local template="$1"
    sed \
        -e "s|{{STUDENT_NAME}}|${STUDENT_NAME}|g" \
        -e "s|{{LANGUAGE}}|${LANGUAGE}|g" \
        -e "s|{{PROJECT_NAME}}|${PROJECT_NAME}|g" \
        -e "s|{{PROJECT_DESC}}|${PROJECT_DESC}|g" \
        -e "s|{{TECH_STACK}}|${TECH_STACK}|g" \
        -e "s|{{STUDENT_LEVEL}}|${STUDENT_LEVEL}|g" \
        -e "s|{{SCHEDULE_TYPE}}|${SCHEDULE_TYPE}|g" \
        -e "s|{{SCHEDULE_DETAILS}}|${SCHEDULE_DETAILS}|g" \
        -e "s|{{END_TIME}}|${END_TIME}|g" \
        -e "s|{{TEAM_CONTEXT}}|${TEAM_CONTEXT}|g" \
        -e "s|{{PROJECT_MODE}}|${PROJECT_MODE}|g" \
        -e "s|{{PROJECT_IDEA}}|${PROJECT_IDEA}|g" \
        -e "s|{{PROJECT_GOALS}}|${PROJECT_GOALS}|g" \
        -e "s|{{TODAY}}|${TODAY}|g" \
        "$template"
}

# Ensure cours/ and memory/ directories exist
mkdir -p "${TARGET_DIR}/cours"
mkdir -p "${TARGET_DIR}/.claude/projects"

# Detect the Claude memory path (project-specific)
CLAUDE_MEMORY_DIR="${HOME}/.claude/projects"
# We'll create a generic memory location — user can move it
MEMORY_TARGET="${TARGET_DIR}/.claude-learning"
mkdir -p "${MEMORY_TARGET}"

# --- Generate CLAUDE.md ---
if [ -f "${TARGET_DIR}/CLAUDE.md" ]; then
    echo ""
    echo -e "${YELLOW}CLAUDE.md already exists in this project.${NC}"
    echo "  1) Append learning rules to existing CLAUDE.md"
    echo "  2) Create separate CLAUDE-learning.md (merge manually later)"
    echo "  3) Replace existing CLAUDE.md (backs up to CLAUDE.md.bak)"
    read -rp "$(echo -e "${YELLOW}Choose [1/2/3]: ${NC}")" CLAUDE_CHOICE

    case $CLAUDE_CHOICE in
        1)
            CLAUDE_TARGET="${TARGET_DIR}/CLAUDE.md"
            echo "" >> "${CLAUDE_TARGET}"
            echo "<!-- ========== CLAUDE LEARNING MODE (auto-generated) ========== -->" >> "${CLAUDE_TARGET}"
            echo "" >> "${CLAUDE_TARGET}"
            render_template "${SCRIPT_DIR}/templates/CLAUDE.md.tmpl" >> "${CLAUDE_TARGET}"
            echo -e "  ${GREEN}+${NC} CLAUDE.md (appended)"
            ;;
        2)
            CLAUDE_TARGET="${TARGET_DIR}/CLAUDE-learning.md"
            render_template "${SCRIPT_DIR}/templates/CLAUDE.md.tmpl" > "${CLAUDE_TARGET}"
            echo -e "  ${GREEN}+${NC} CLAUDE-learning.md"
            echo -e "  ${YELLOW}!${NC} Remember to merge with your existing CLAUDE.md"
            ;;
        3)
            cp "${TARGET_DIR}/CLAUDE.md" "${TARGET_DIR}/CLAUDE.md.bak"
            CLAUDE_TARGET="${TARGET_DIR}/CLAUDE.md"
            render_template "${SCRIPT_DIR}/templates/CLAUDE.md.tmpl" > "${CLAUDE_TARGET}"
            echo -e "  ${GREEN}+${NC} CLAUDE.md (replaced, backup: CLAUDE.md.bak)"
            ;;
        *)
            CLAUDE_TARGET="${TARGET_DIR}/CLAUDE-learning.md"
            render_template "${SCRIPT_DIR}/templates/CLAUDE.md.tmpl" > "${CLAUDE_TARGET}"
            echo -e "  ${GREEN}+${NC} CLAUDE-learning.md"
            ;;
    esac
else
    CLAUDE_TARGET="${TARGET_DIR}/CLAUDE.md"
    render_template "${SCRIPT_DIR}/templates/CLAUDE.md.tmpl" > "${CLAUDE_TARGET}"
    echo -e "  ${GREEN}+${NC} CLAUDE.md"
fi

# --- Generate cours/ files ---
for tmpl in "${SCRIPT_DIR}/templates/cours/"*.tmpl; do
    filename=$(basename "$tmpl" .tmpl)
    # Skip plan-projet template if not in from-scratch mode
    if [ "$filename" = "plan-projet.md" ] && [ "$PROJECT_MODE" != "from-scratch" ]; then
        continue
    fi
    render_template "$tmpl" > "${TARGET_DIR}/cours/${filename}"
    echo -e "  ${GREEN}+${NC} cours/${filename}"
done

# --- Generate memory files ---
for tmpl in "${SCRIPT_DIR}/templates/memory/"*.tmpl; do
    filename=$(basename "$tmpl" .tmpl)
    render_template "$tmpl" > "${MEMORY_TARGET}/${filename}"
    echo -e "  ${GREEN}+${NC} .claude-learning/${filename}"
done

# ---------- Summary ----------

echo ""
echo -e "${GREEN}${BOLD}============================================${NC}"
if [ "$PROJECT_MODE" = "from-scratch" ]; then
    echo -e "${GREEN}${BOLD}  Setup complete! Ready to plan your project.${NC}"
else
    echo -e "${GREEN}${BOLD}  Setup complete!${NC}"
fi
echo -e "${GREEN}${BOLD}============================================${NC}"
echo ""
echo -e "Files created:"
echo -e "  ${BOLD}${CLAUDE_TARGET##*/}${NC}         — The brain (pedagogical rules for Claude)"
if [ "$PROJECT_MODE" = "from-scratch" ]; then
    echo -e "  ${BOLD}cours/${NC}                — Project plan, progress tracking, revision questions"
    echo -e "  ${BOLD}cours/plan-projet.md${NC}   — Your project plan (Claude will fill this with you)"
else
    echo -e "  ${BOLD}cours/${NC}                — Course files, progress tracking, revision questions"
fi
echo -e "  ${BOLD}.claude-learning/${NC}     — Memory files (session state, time tracking)"
echo ""
echo -e "${YELLOW}${BOLD}Next steps:${NC}"
echo ""
if [ "$PROJECT_MODE" = "from-scratch" ]; then
    echo -e "  1. ${BOLD}Start Claude Code${NC} and begin your first session!"
    echo -e "     Claude will help you plan your project step by step,"
    echo -e "     then generate learning modules based on your project plan."
    echo ""
    echo -e "  2. ${BOLD}Link memory files${NC} to Claude Code's memory system:"
    echo -e "     Copy .claude-learning/ contents to your Claude project memory path"
    echo -e "     (usually ~/.claude/projects/<project-path>/memory/)"
    echo ""
    echo -e "  3. ${BOLD}Review cours/plan-projet.md${NC} after your first session"
    echo -e "     Claude will fill it in with you during project planning."
else
    echo -e "  1. ${BOLD}Review ${CLAUDE_TARGET##*/}${NC} — customize project-specific sections"
    echo -e "     (architecture, commands, code conventions)"
    echo ""
    echo -e "  2. ${BOLD}Link memory files${NC} to Claude Code's memory system:"
    echo -e "     Copy .claude-learning/ contents to your Claude project memory path"
    echo -e "     (usually ~/.claude/projects/<project-path>/memory/)"
    echo ""
    echo -e "  3. ${BOLD}Define your learning modules${NC} in cours/00-programme.md"
    echo -e "     (follow the existing template — list what you want to learn)"
    echo ""
    echo -e "  4. ${BOLD}Start Claude Code${NC} and begin a session!"
    echo -e "     Claude will automatically enter teaching mode."
fi
echo ""
if [ "$HAS_GIT" = false ]; then
    echo -e "${BLUE}Tip: Run 'git init' in your project to start tracking your progress.${NC}"
    echo -e "${BLUE}Then add cours/ and .claude-learning/ so your learning is versioned.${NC}"
else
    echo -e "${BLUE}Tip: Add cours/ and .claude-learning/ to your git repo${NC}"
    echo -e "${BLUE}so your learning progress is versioned alongside your code.${NC}"
fi
