---
name: feat-dev
description: 完整的 7 阶段功能开发工作流（需求理解、代码探索、架构设计、实施、审查、总结）。适用场景：(1) 新功能实施或模块开发，(2) 复杂代码修改和重构，(3) API/数据库/服务架构设计，(4) 多模块功能开发，(5) 需要代码审查的实施任务。融合 ultrathink 深度分析、MCP 工具增强（context7、exa、sequential-thinking）和并行 agent 执行（code-explorer、code-architect、code-reviewer）。支持全程中文交互。
---

# 功能开发技能

提供系统化的 7 阶段功能开发工作流，确保从需求理解到质量交付的完整过程。

---

## 快速开始

**工作流概览**：
```
需求理解 → 代码探索 → 澄清问题 → 架构设计 → 实施 → 质量审查 → 总结
```

**核心特性**：
- 🧠 **ultrathink 深度分析**：复杂需求和架构设计阶段使用 sequential-thinking
- 🔧 **MCP 工具增强**：优先使用 context7、exa、sequential-thinking，自动降级保证可用性
- 🤖 **并行 agents**：使用专门化 agents（code-explorer、code-architect、code-reviewer）提升效率
- 🌐 **语言无关**：适用于任何技术栈和编程语言
- 🇨🇳 **中文交互**：全程使用中文与用户沟通

**手动触发**：
```bash
/feat-dev [功能描述]
```

**详细指南**：
- MCP 工具和降级策略：[references/mcp-tools.md](references/mcp-tools.md)
- 快速参考：[references/quick-reference.md](references/quick-reference.md)
- 故障排查：[references/troubleshooting.md](references/troubleshooting.md)

---

## MCP 工具集成

本 skill 优先使用 MCP 工具，但**所有功能在无 MCP 环境下完全可用**。

### 工具清单

| MCP 工具 | 用途 | 降级方案 | 使用阶段 |
|---------|------|---------|---------|
| **context7** | 获取最新库文档和 API 参考 | WebSearch + Grep + Read | 2、4、5 |
| **exa** | 高质量网页搜索和代码示例 | WebSearch | 1、4、6 |
| **sequential-thinking** | 深度结构化思考（ultrathink） | EnterPlanMode + 思维链分析 | 1、4 |

### 降级策略

```
尝试 MCP 工具 → 失败 → 立即切换降级方案 → 继续工作流（不中断）
```

**重要**：不要因为 MCP 工具不可用而中断工作流。

**详细说明**：[references/mcp-tools.md](references/mcp-tools.md)

---

## 专门化 Agents

三个外部 agents（位于 `agents/` 目录）：

| Agent | 用途 | 使用阶段 | 并行数量 |
|-------|------|---------|---------|
| **code-explorer** | 深度分析代码库，追踪执行路径 | 2 | 2-3 个 |
| **code-architect** | 设计架构蓝图，制定实施方案 | 4 | 1 个（可选） |
| **code-reviewer** | 代码审查，识别 bug 和规范问题 | 6 | 3 个 |

**调用方式**：使用 Task 工具，model 从 agent 文件 YAML frontmatter 读取，并行执行时设置 `run_in_background: true`。

详见各阶段的参考文档。

---

## 7 阶段工作流

### 阶段 1: 需求理解

**目标**：全面理解用户需求

**执行要点**：
- 识别核心功能、业务实体、API 端点、业务规则、集成点
- 根据复杂度决定是否使用 ultrathink（sequential-thinking）
- 可选：搜索类似实现案例（exa/WebSearch）

**产出**：需求理解摘要（核心功能、业务实体、API 端点、业务规则、集成点、不确定点）

**详细指南**：[references/phase-1-discovery.md](references/phase-1-discovery.md)

---

### 阶段 2: 代码库探索

**目标**：深入理解现有代码库

**执行要点**：
- **首要任务**：查找并阅读项目根目录的 CLAUDE.md 文件
- 并行启动 2-3 个 code-explorer agents 探索不同层面：
  - Agent 1: 数据层（实体、数据库模式）
  - Agent 2: 业务逻辑层（服务、Repository）
  - Agent 3: API 层（控制器、路由）
- 可选：使用 context7 查询依赖库文档
- 汇总探索结果，识别设计模式和技术栈

**产出**：代码库探索报告（CLAUDE.md 规范、项目架构、相关组件、设计模式、技术栈、必读文件）

**详细指南**：[references/phase-2-exploration.md](references/phase-2-exploration.md)

---

### 阶段 3: 澄清问题

**目标**：填补需求空白，解决模糊和歧义

**执行要点**：
- 识别需要澄清的情况：
  - 模糊或规格不足的需求
  - 多个有效实施方法
  - 业务规则细节
  - 与现有功能的关系
  - 技术选型或架构决策
- **必须**使用 AskUserQuestion 工具向用户提问
- 记录用户反馈，更新需求理解

**产出**：澄清结果（用户反馈）或"无需澄清"

**详细指南**：[references/phase-3-clarify.md](references/phase-3-clarify.md)

---

### 阶段 4: 架构设计

**目标**：设计详细的实施方案

**执行要点**：
- **必须**使用 ultrathink（sequential-thinking）进行深度架构分析：
  1. 分析需求组件
  2. 设计数据结构（遵循 CLAUDE.md 规范）
  3. 设计 API 端点（遵循 CLAUDE.md 规范）
  4. 设计服务层架构
  5. 识别风险和边缘情况
  6. **规划详细实施步骤**（必须产出，至少 5-10 步，详细到可直接执行）
- 可选：启动 code-architect agent 获取额外的架构见解
- 可选：搜索架构模式和最佳实践（exa/WebSearch）
- **必须**等待用户确认架构方案后才能进入阶段 5

**产出**（所有都是必须的）：
- ✅ 数据库设计（实体/表结构、字段、关联、索引）
- ✅ API 端点设计（方法、路径、请求/响应、认证）
- ✅ 服务层设计（服务接口、依赖关系、业务逻辑流程）
- ✅ **详细实施步骤**（编号列表，每步明确任务和产出）
- ✅ 用户确认

**详细指南**：[references/phase-4-design.md](references/phase-4-design.md)

---

### 阶段 5: 实施

**目标**：按照架构设计实施功能

**前置条件**：用户已确认架构方案

**执行要点**：
- 按阶段 4 规划的步骤顺序实施（通常为）：
  1. 数据层（实体、数据库）
  2. 数据访问层（Repository/DAO）
  3. 服务层（业务逻辑）
  4. DTO（请求/响应结构）
  5. API 层（控制器/路由）
  6. 验证和错误处理
- 严格遵循 CLAUDE.md 规范和现有模式
- 每完成一个模块及时测试
- 可选：使用 context7 查询 API 文档

**实施原则**：
- 保持代码简洁，避免过度设计
- 安全第一（防止注入、XSS、认证授权等）
- 遵循项目现有模式

**产出**：完整的功能实现代码

**详细指南**：[references/phase-5-implement.md](references/phase-5-implement.md)

---

### 阶段 6: 质量审查

**目标**：确保代码质量

**执行要点**：
- 并行启动 3 个 code-reviewer agents：
  - Reviewer 1: Bug 和逻辑错误
  - Reviewer 2: 代码风格和质量
  - Reviewer 3: 项目规范遵循
- 汇总审查结果，按优先级分类
- 修复高置信度 bug（≥80%）
- 修复严重质量和规范问题
- 记录暂不处理的问题及原因
- 完成安全检查清单

**修复策略**：
- 必须修复：高置信度 bug、严重规范违反
- 应该修复：中置信度 bug、严重质量问题
- 可选修复：一般质量问题

**产出**：审查报告、修复记录、质量评分

**详细指南**：[references/phase-6-review.md](references/phase-6-review.md)

---

### 阶段 7: 总结

**目标**：全面总结实施成果

**输出内容**：
1. **变更摘要**：实现了什么功能
2. **修改文件列表**：所有新增和修改的文件
3. **API 变更**：新增的 API 端点
4. **数据库变更**：新增或修改的表/字段
5. **后续建议**：
   - 测试计划
   - 部署注意事项
   - CHANGELOG 条目
   - API 文档生成
   - 可选功能扩展
   - 性能优化建议
   - 监控指标
6. **工具使用情况**：MCP 工具和 agents 使用记录

**产出**：完整总结文档

**详细指南**：[references/phase-7-summary.md](references/phase-7-summary.md)

---

## 工作流控制

### 阶段声明要求

**每个阶段开始时必须输出**：
```markdown
---
## 🚀 当前阶段：[X] - [阶段名称]
---
```

**每个阶段结束时必须输出**：
```markdown
---
✅ 阶段 [X] 完成

📍 下一阶段：[X+1] - [阶段名称]
---
```

### 用户输入后的继续机制

当用户在阶段中提供输入（如回答澄清问题）后，**必须**：

1. **确认收到输入**：
```markdown
---
📥 已收到用户输入

🔄 继续阶段 [X] - [阶段名称]
---
```

2. **处理用户输入**：整合到当前阶段

3. **继续当前阶段**：完成阶段剩余工作

4. **不要**：
   - ❌ 跳出当前 skill
   - ❌ 重新评估 skill 触发条件
   - ❌ 跳过任何阶段
   - ❌ 在未完成当前阶段时进入下一阶段

### 强制检查点

**阶段 3 → 4**：
- 如果使用了 AskUserQuestion，必须等待用户回应
- 收到回应后，继续阶段 3 完成澄清
- 然后进入阶段 4

**阶段 4 → 5**：
- **必须**等待用户明确确认架构方案
- 用户确认前**禁止**开始实施
- 如果用户要求修改，更新设计并重新请求确认

**阶段 5 → 6**：
- 实施必须完成
- 不能在实施中途跳到审查

### 阶段顺序规则

**严格顺序**：1 → 2 → 3 → 4 → 5 → 6 → 7

**允许回退**：
- 阶段 5 发现需求理解有误 → 回退到阶段 3 或 4
- 阶段 4 用户要求修改 → 停留在阶段 4 更新设计

**禁止跳跃**：
- ❌ 不能从阶段 3 直接到阶段 5
- ❌ 不能在未确认架构时开始实施
- ❌ 不能跳过任何阶段

---

## 输出格式

使用标准化模板输出各阶段结果。详见：[assets/output-template.md](assets/output-template.md)

**重要**：所有输出必须包含阶段标记（见"工作流控制"章节）

---

## 重要原则

1. **全程使用中文**：与用户的所有沟通必须使用中文
2. **严格遵循 CLAUDE.md**：必须阅读并遵守项目规范
3. **主动提问**：不清楚的地方必须澄清（阶段 3）
4. **善用 ultrathink**：复杂分析必须使用 Sequential Thinking（阶段 1 可选、阶段 4 必须）
5. **并行执行**：探索和审查阶段并行启动多个 agents
6. **等待确认**：架构设计确认后才开始实施（阶段 4 → 5）
7. **质量把关**：实施后必须进行代码审查（阶段 6）
8. **不中断工作流**：MCP 工具不可用时立即使用降级方案

---

## 何时使用 ultrathink

### ✅ 应该使用
- 需求涉及多个模块或系统集成
- 需求包含复杂业务逻辑或工作流
- 需求描述模糊或不完整
- 需求之间存在依赖关系或冲突
- **架构设计阶段（阶段 4）- 必须使用**

### ❌ 不需要使用
- 单一、明确的需求
- 简单的 CRUD 操作
- 直接的代码修改
- 需求已经非常清晰且范围明确

---

## 参考文档

### 阶段详细指南
- [阶段 1: 需求理解](references/phase-1-discovery.md)
- [阶段 2: 代码库探索](references/phase-2-exploration.md)
- [阶段 3: 澄清问题](references/phase-3-clarify.md)
- [阶段 4: 架构设计](references/phase-4-design.md)
- [阶段 5: 实施](references/phase-5-implement.md)
- [阶段 6: 质量审查](references/phase-6-review.md)
- [阶段 7: 总结](references/phase-7-summary.md)

### 辅助文档
- [MCP 工具集成指南](references/mcp-tools.md)
- [快速参考](references/quick-reference.md)
- [故障排查指南](references/troubleshooting.md)
- [输出格式模板](assets/output-template.md)

---

## 技术栈支持

本 skill 设计为**语言无关**，适用于但不限于：

**后端**：Node.js、Python、Go、Java、Ruby、PHP、C#、Rust 等
**前端**：React、Vue、Angular、Svelte、纯 JavaScript/TypeScript 等
**全栈**：Next.js、Nuxt、SvelteKit 等
**移动端**：React Native、Flutter、Swift、Kotlin 等
**数据库**：关系型（PostgreSQL、MySQL、SQL Server）、NoSQL（MongoDB、Redis）等

具体实施时，会根据项目的技术栈和 CLAUDE.md 规范调整。
