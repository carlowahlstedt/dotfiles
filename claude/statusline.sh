#!/bin/bash

# Claude Code statusline script
# Reads JSON input from stdin and outputs a formatted status line

input=$(cat)

# Extract fields using jq
cwd=$(echo "$input" | jq -r '.workspace.current_dir // empty')
model_name=$(echo "$input" | jq -r '.model.display_name // empty')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
input_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
output_tokens=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')

# Time
time=$(date +%H:%M:%S)

# Shorten home directory in path
short_cwd="${cwd/#$HOME/~}"

# Git info
git_info=""
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" -c core.useBuiltinFSMonitor=false --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        if ! git -C "$cwd" -c core.useBuiltinFSMonitor=false --no-optional-locks diff --quiet 2>/dev/null || ! git -C "$cwd" -c core.useBuiltinFSMonitor=false --no-optional-locks diff --cached --quiet 2>/dev/null; then
            git_info=" $branch*"
        else
            git_info=" $branch"
        fi
    fi
fi

# Format token counts (e.g., 15234 -> 15.2k)
format_tokens() {
    local t=$1
    if [ "$t" -ge 1000000 ]; then
        printf "%.1fM" "$(echo "scale=1; $t / 1000000" | bc)"
    elif [ "$t" -ge 1000 ]; then
        printf "%.1fk" "$(echo "scale=1; $t / 1000" | bc)"
    else
        printf "%d" "$t"
    fi
}

in_fmt=$(format_tokens "$input_tokens")
out_fmt=$(format_tokens "$output_tokens")

# Format cost
if [ "$(echo "$cost > 0" | bc -l 2>/dev/null)" = "1" ]; then
    cost_fmt=$(printf "$%.2f" "$cost")
else
    cost_fmt="\$0.00"
fi

# Format duration (ms -> Xm Ys)
if [ "$duration_ms" -gt 0 ] 2>/dev/null; then
    total_sec=$((duration_ms / 1000))
    mins=$((total_sec / 60))
    secs=$((total_sec % 60))
    if [ "$mins" -gt 0 ]; then
        dur_fmt="${mins}m${secs}s"
    else
        dur_fmt="${secs}s"
    fi
else
    dur_fmt="0s"
fi

# Build context window progress bar (10 chars wide)
# Use block characters: filled=\u2588 empty=\u2591
ctx_int=${ctx_pct%.*}  # truncate to integer
if [ -z "$ctx_int" ] || [ "$ctx_int" = "0" ]; then
    ctx_int=0
fi
filled=$((ctx_int / 10))
empty=$((10 - filled))

bar=""
for ((i=0; i<filled; i++)); do bar+="█"; done
for ((i=0; i<empty; i++)); do bar+="░"; done

# Color the bar based on usage level
if [ "$ctx_int" -ge 80 ]; then
    # Red for high usage
    bar_color="\033[31m"
elif [ "$ctx_int" -ge 50 ]; then
    # Yellow for medium usage
    bar_color="\033[33m"
else
    # Blue for normal usage
    bar_color="\033[34m"
fi

# Build output
# Format:  HH:MM:SS ~/path  branch | Opus | Ctx ████░░░░░░ 42% | 15k/4k | $0.05 | +156/-23 | 2m30s
printf "\033[33m%s\033[0m " "$time"
printf "\033[32m%s\033[0m" "$short_cwd"

if [ -n "$git_info" ]; then
    printf " \033[34m%s\033[0m" "$git_info"
fi

printf " \033[90m|\033[0m "

# Model
if [ -n "$model_name" ]; then
    printf "\033[35m%s\033[0m " "$model_name"
    printf "\033[90m|\033[0m "
fi

# Context window with bar
printf "Ctx ${bar_color}%s\033[0m %d%% " "$bar" "$ctx_int"
printf "\033[90m|\033[0m "

# Tokens
printf "\033[36m%s\033[90m/\033[36m%s\033[0m " "$in_fmt" "$out_fmt"
printf "\033[90m|\033[0m "

# Cost
printf "\033[33m%s\033[0m " "$cost_fmt"
printf "\033[90m|\033[0m "

# Lines changed
if [ "$lines_added" -gt 0 ] || [ "$lines_removed" -gt 0 ]; then
    printf "\033[32m+%s\033[90m/\033[31m-%s\033[0m " "$lines_added" "$lines_removed"
    printf "\033[90m|\033[0m "
fi

# Duration
printf "\033[90m%s\033[0m" "$dur_fmt"
