# 更新日志

本项目的所有重要更改都将记录在此文件中。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
并且本项目遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [1.1.0] - 2025-12-17

### 新增 (Added)
- ✨ 添加 SessionStart hook，会话启动时自动检查 MCP 配置状态
- ✨ 新增 `/check-mcp` 命令，手动查看 MCP 配置详情和状态
- ✨ 智能 MCP 冲突检测和处理机制
- 📝 完善 MCP 依赖管理文档，包含详细的配置说明和常见问题解答
- 📄 创建 `scripts/check-mcp-setup.sh` - 自动检测脚本
- 📄 创建 `commands/check-mcp.md` - MCP 配置检查斜杠命令

### 改进 (Changed)
- 🔧 利用 Claude Code 作用域优先级机制自动处理 MCP 重复问题
- 📚 添加详细的 MCP 配置说明（3 种配置方式）
- 🎨 友好的彩色终端输出和提示信息
- 📝 更新项目目录结构文档

### 技术细节 (Technical)
- 更新 `plugin.json` 添加 SessionStart hooks 配置
- 使用 `${CLAUDE_PLUGIN_ROOT}` 环境变量确保路径正确性
- 实现环境变量检测（CONTEXT7_API_KEY、EXA_API_KEY）
- Bash 脚本支持彩色输出和错误处理

### 文档 (Documentation)
- 新增 "MCP 依赖管理" 章节到 README
- 添加 MCP 配置常见问题解答
- 说明 Claude Code 作用域优先级机制
- 提供配置方式对比和建议

## [1.0.0] - 2025-12-17

### 新增 (Added)
- 🎉 7 阶段功能开发工作流
  - 阶段 1: 需求理解 (Discovery)
  - 阶段 2: 代码库探索 (Codebase Exploration)
  - 阶段 3: 澄清问题 (Clarifying Questions)
  - 阶段 4: 架构设计 (Architecture Design)
  - 阶段 5: 实施 (Implementation)
  - 阶段 6: 质量审查 (Quality Review)
  - 阶段 7: 总结 (Summary)
- 🤖 3 个专门化 Agent
  - `code-explorer` - 深度分析代码库，追踪执行路径
  - `code-architect` - 设计架构蓝图，制定实施方案
  - `code-reviewer` - 代码审查，识别 bug 和规范问题
- 🧠 集成 ultrathink 深度分析（Sequential Thinking）
- 🔌 MCP 工具增强
  - `context7` - 获取最新库文档和 API 参考
  - `exa` - 高质量网页搜索和代码示例
  - `sequential-thinking` - 深度结构化思考
- 🌐 完整的中文支持和输出
- ⚡ 并行 Agent 执行能力
- 🎯 自动触发机制（通过 skill）
- 📝 `/feat-dev` 斜杠命令

### 特性 (Features)
- 语言无关 - 适用于任何编程语言和项目结构
- 灵活的模型配置（Sonnet/Opus）
- 支持复杂度判断的智能 ultrathink 使用
- 完整的 MCP 服务器配置（.mcp.json）

---

## 版本说明

### 版本号格式
遵循 [语义化版本 2.0.0](https://semver.org/lang/zh-CN/)：

- **主版本号（MAJOR）**：不兼容的 API 修改
- **次版本号（MINOR）**：向下兼容的功能性新增
- **修订号（PATCH）**：向下兼容的问题修正

### 更新类型

- **新增 (Added)**：新功能
- **改进 (Changed)**：对现有功能的变更
- **弃用 (Deprecated)**：即将删除的功能
- **移除 (Removed)**：已删除的功能
- **修复 (Fixed)**：任何 bug 修复
- **安全 (Security)**：安全相关的修复

---

[1.1.0]: https://github.com/FlameMida/feat-dev/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/FlameMida/feat-dev/releases/tag/v1.0.0
