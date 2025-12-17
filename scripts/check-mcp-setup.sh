#!/bin/bash

# MCP 配置检查脚本
# 在会话开始时运行，检测 MCP 配置状态并提供友好提示

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置文件路径
CONFIG_FILE="$HOME/.claude/config.json"
PLUGIN_MCP="$CLAUDE_PLUGIN_ROOT/.mcp.json"

# 检查 MCP 是否存在于配置文件中
check_mcp_exists() {
  local mcp_name=$1
  local config_file=$2

  if [ -f "$config_file" ]; then
    if grep -q "\"$mcp_name\"" "$config_file" 2>/dev/null; then
      return 0  # 存在
    fi
  fi
  return 1  # 不存在
}

# 检查环境变量是否设置
check_env_var() {
  local var_name=$1
  if [ -n "${!var_name}" ]; then
    return 0  # 已设置
  fi
  return 1  # 未设置
}

# MCP 列表
MCPS=("context7" "exa" "sequential-thinking")
ENV_VARS=("CONTEXT7_API_KEY:context7" "EXA_API_KEY:exa")

# 检测结果
user_has_mcps=()
plugin_only_mcps=()
missing_env_vars=()

# 检查每个 MCP
for mcp in "${MCPS[@]}"; do
  if check_mcp_exists "$mcp" "$CONFIG_FILE"; then
    user_has_mcps+=("$mcp")
  elif check_mcp_exists "$mcp" "$PLUGIN_MCP"; then
    plugin_only_mcps+=("$mcp")
  fi
done

# 检查环境变量
for env_pair in "${ENV_VARS[@]}"; do
  IFS=':' read -r env_var mcp_name <<< "$env_pair"

  # 只检查正在使用的 MCP 的环境变量
  is_using=false
  for mcp in "${user_has_mcps[@]}" "${plugin_only_mcps[@]}"; do
    if [ "$mcp" = "$mcp_name" ]; then
      is_using=true
      break
    fi
  done

  if [ "$is_using" = true ]; then
    if ! check_env_var "$env_var"; then
      missing_env_vars+=("$env_var")
    fi
  fi
done

# 输出提示信息
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Feature Dev CN - MCP 配置检查${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# 如果用户有全局 MCP 配置
if [ ${#user_has_mcps[@]} -gt 0 ]; then
  echo -e "${GREEN}✓${NC} 检测到您已在全局配置中安装了以下 MCP："
  for mcp in "${user_has_mcps[@]}"; do
    echo -e "  ${GREEN}•${NC} $mcp"
  done
  echo ""
  echo -e "${BLUE}ℹ${NC}  您的全局配置会自动优先于插件配置，这是正常的。"
  echo -e "   插件功能将使用您的配置正常工作。"
  echo ""
fi

# 如果有仅来自插件的 MCP
if [ ${#plugin_only_mcps[@]} -gt 0 ]; then
  echo -e "${GREEN}✓${NC} 以下 MCP 由插件提供："
  for mcp in "${plugin_only_mcps[@]}"; do
    echo -e "  ${GREEN}•${NC} $mcp"
  done
  echo ""
fi

# 如果有缺失的环境变量
if [ ${#missing_env_vars[@]} -gt 0 ]; then
  echo -e "${YELLOW}⚠${NC}  以下环境变量未配置，某些功能可能受限："
  for env_var in "${missing_env_vars[@]}"; do
    echo -e "  ${YELLOW}•${NC} $env_var"
  done
  echo ""
  echo -e "${BLUE}ℹ${NC}  设置方式（在 ~/.zshrc 或 ~/.bashrc 中添加）："
  echo -e "   export CONTEXT7_API_KEY=\"your-api-key\""
  echo -e "   export EXA_API_KEY=\"your-api-key\""
  echo ""
  echo -e "   获取 API Key:"
  echo -e "   • Context7: ${BLUE}https://context7.com/${NC}"
  echo -e "   • Exa: ${BLUE}https://exa.ai/${NC}"
  echo ""
fi

# 总体状态
total_mcps=$((${#user_has_mcps[@]} + ${#plugin_only_mcps[@]}))
if [ $total_mcps -eq ${#MCPS[@]} ] && [ ${#missing_env_vars[@]} -eq 0 ]; then
  echo -e "${GREEN}✓${NC} 所有 MCP 配置正常！插件功能已就绪。"
  echo ""
elif [ $total_mcps -eq ${#MCPS[@]} ] && [ ${#missing_env_vars[@]} -gt 0 ]; then
  echo -e "${YELLOW}⚠${NC}  MCP 已配置，但需要设置 API Key 以获得完整功能。"
  echo ""
else
  echo -e "${BLUE}ℹ${NC}  运行 ${BLUE}/check-mcp${NC} 命令查看详细配置状态。"
  echo ""
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
