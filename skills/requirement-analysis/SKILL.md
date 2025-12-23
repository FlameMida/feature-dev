---
name: requirement-analysis
description: 【当用户提出功能开发、API设计、数据库设计等需求时自动启用】系统化需求分析工作流 - 理解需求、探索代码库、澄清问题、使用ultrathink深度分析并在编码前展示实施计划（全程使用中文）
---

# 需求分析技能 (Requirement Analysis Skill)

本技能强制执行系统化的需求分析工作流，确保在实施前彻底理解需求。

## 何时使用 (When to Use)

在以下情况下使用本技能：
- 开始新功能实施
- 接收到复杂或模糊的需求
- 在不熟悉的代码库部分工作
- 需要设计 API 端点、数据库架构或服务架构
- 修改原有功能

## 如何触发此技能 (How to Trigger)

### 方式 1: 自动触发
当你提出以下类型的需求时，Claude 应该会自动使用此技能：
- "我需要实现一个 XXX 功能"
- "帮我设计一个 XXX 的 API"
- "需要添加 XXX 数据库表"
- "开发一个 XXX 模块"
- "需要新增一个 XXX 功能"
- "需要新增一个 XXX 模块"
- "XXX 需要修改"

### 方式 2: 手动触发命令
显式调用技能：
```bash
/RA
```

### 方式 3: 在消息中明确提示
在你的需求描述中加入提示语：
- "**使用需求分析skill**来帮我实现用户管理功能"
- "请**用 requirement-analysis 技能**来处理这个需求"
- "**按照需求分析流程**帮我设计这个 API"

### 推荐做法
对于复杂功能开发，建议在需求开头明确说明：
```
使用需求分析skill：我需要实现一个文件上传和管理系统...
```

## 工作流程 (Workflow)

### 阶段 1: 需求理解 (Requirement Understanding)

**根据需求复杂度决定是否使用 ultrathink**：

仔细阅读用户的需求并识别：

- **核心功能 (Core Functionality)**: 请求的主要特性/能力是什么？
- **业务实体 (Business Entities)**: 涉及哪些数据模型或领域对象？
- **API 端点 (API Endpoints)**: 需要暴露哪些接口？
- **业务规则 (Business Rules)**: 适用哪些约束、验证或特殊逻辑？
- **输入/输出 (Input/Output)**: 预期的请求和响应格式是什么？

**何时在此阶段使用 ultrathink**：

满足以下任一条件时，应在需求理解阶段使用 ultrathink：
- ✅ 需求涉及**多个模块或系统**的集成
- ✅ 需求包含**复杂的业务逻辑**或工作流
- ✅ 需求描述**模糊或不完整**，需要推理补充
- ✅ 需求之间存在**依赖关系或冲突**
- ✅ 需要设计**复杂的数据结构**或关系

如果是简单的 CRUD 功能或单一模块的简单需求，可以跳过此阶段的 ultrathink，直接进入阶段 2。

### 阶段 2: 代码库探索 (Codebase Exploration)

**首要任务**: 查找并阅读项目根目录下的 **CLAUDE.md** 文件，理解项目规范和约定。

使用 **Task 工具的 subagent_type=Explore** 来调查现有代码：

```
Use Task tool with:
- subagent_type: Explore
- thoroughness: medium or very thorough (depending on complexity)
- prompt: "Find existing implementations of [related feature] including entities, services, and controllers"
```

查找：
- **CLAUDE.md** - 项目的开发规范、约定和指南（必须优先查看）
-  项目中的相关实体、数据库对象
-  项目中的类似服务实现
-  项目中的控制器
-  项目中现有的请求/响应模式
-  项目中使用的通用工具和模式

### 阶段 3: 澄清问题 (Clarification Questions)

**重要**: 对任何不清楚、模糊、有歧义的地方，必须主动使用 **AskUserQuestion 工具** 向用户提问。不要假设或猜测用户的意图。

使用 **AskUserQuestion 工具** 来澄清：

- 模糊或规格不足的需求
- 多个有效实施方法之间的选择
- 业务规则细节或边缘情况处理
- 与现有功能的关系
- 需要验证的任何假设
- 技术选型或架构决策
- 数据格式、字段类型等具体细节

**示例**:
```
AskUserQuestion with:
- questions: [
    {
      question: "批量导入是否应同时支持 Excel 和 CSV 格式？",
      header: "文件格式",
      options: [
        {label: "同时支持 Excel 和 CSV", description: "..."},
        {label: "仅支持 Excel", description: "..."}
      ],
      multiSelect: false
    }
  ]
```

### 阶段 4: 使用顺序思考进行深度分析 (Deep Analysis with Sequential Thinking)

**必须使用 ultrathink**: 在此阶段必须使用 **mcp__sequential-thinking__sequentialthinking 工具** (ultrathink) 进行深度思考和分析，不要跳过这一步骤。

使用 **mcp__sequential-thinking__sequentialthinking 工具** 来：

1. **分析需求** - 将需求分解为组件
2. **设计数据结构** - 规划数据库表、实体字段、关系（必须符合 CLAUDE.md 中的数据库设计规范）
3. **设计 API 端点** - 定义 REST 端点、请求/响应格式（必须符合 CLAUDE.md 中的 API 设计规范）
4. **设计服务层** - 规划业务逻辑、验证、错误处理（必须符合 CLAUDE.md 中的架构模式）
5. **识别风险** - 考虑边缘情况、性能、安全问题
6. **规划实施** - 概述逐步实施任务（确保符合项目规范）

**思考过程示例**:
- Thought 1: 分析核心需求并分解为子功能
- Thought 2: 基于业务实体设计数据库架构，检查 CLAUDE.md 中的命名约定和字段类型规范
- Thought 3: 遵循 RESTful 约定和 CLAUDE.md 中的 API 路由规范规划端点
- Thought 4: 考虑验证规则和错误场景，遵循 CLAUDE.md 中的错误处理规范
- Thought 5: 识别潜在的性能瓶颈
- Thought 6: 规划实施顺序，确保每个步骤都符合项目规范

### 阶段 5: 展示实施计划 (Present Implementation Plan)

完成分析后，向用户展示：

#### 1. 需求总结 (Requirement Summary)
- 清楚说明你理解的需求
- 关键特性和能力

#### 2. 代码库发现 (Codebase Findings)
- 发现的相关现有代码
- 要遵循的模式和约定
- 可重用的组件或工具

#### 3. 技术设计 (Technical Design)

**数据库设计**

**API 端点**:
```
POST   /api/resource/create   - 创建新资源
GET    /api/resource/list     - 列出资源（分页）
PUT    /api/resource/update   - 更新资源
DELETE /api/resource/delete   - 删除资源
```

**Service 层设计**:
- 关键服务方法
- 业务逻辑流程
- 验证策略
- 错误处理方法

#### 4. 实施步骤 (Implementation Steps)
1. 步骤 1: 创建实体和迁移
2. 步骤 2: 实施服务层
3. 步骤 3: 创建请求/响应结构
4. 步骤 4: 实施控制器
5. 步骤 5: 注册路由
6. 步骤 6: 添加验证和错误处理
7. 步骤 7: 代码审查
8. 步骤 8: 测试实施

#### 5. 风险和注意事项 (Risks and Considerations)
- 潜在的技术挑战
- 需要处理的边缘情况
- 性能考虑
- 安全问题

#### 6. 等待确认 (Wait for Confirmation)

**重要**: 在用户确认计划之前，不要开始实施。

询问: "这个实施计划看起来如何？我可以开始实施了吗？"

## 重要原则 (Important Principles)

1. **全程使用中文**: 与用户的所有沟通、分析报告、实施计划必须使用中文（技术术语和代码除外）
2. **严格遵循 CLAUDE.md 规范**: 必须阅读并遵守项目根目录下的 CLAUDE.md 文件中制定的所有开发规范、编码约定和架构指南
3. **主动提问**: 对任何不清楚、模糊、有歧义的地方，必须主动向用户提问澄清，不要假设或猜测
4. **合理使用 ultrathink**:
   - 阶段 1（需求理解）：根据复杂度决定是否使用
   - 阶段 4（深度分析）：必须使用 Sequential Thinking 工具进行系统化思考
5. **切勿急躁**: 在计划被确认之前不要开始编码
6. **善用工具**: 充分利用 Explore agent 和其他分析工具
7. **保持彻底**: 考虑边缘情况、错误和性能

## 使用示例 (Example Usage)

### 示例 1: 复杂需求（使用 ultrathink 分析）

用户: "我需要一个用户活动跟踪功能来记录用户操作，支持多租户隔离和实时分析"

使用本技能的助手：
1. 理解：判断为复杂需求（涉及多租户、实时分析），**使用 ultrathink** 分析需求
2. 探索：检查代码库中现有的日志/审计功能和多租户架构
3. 询问："应该跟踪哪些类型的操作？数据保留策略是什么？"
4. 深度分析：**使用 ultrathink** 设计架构和实施方案（遵循 CLAUDE.md 规范）
5. 展示：显示完整计划，包括实体设计、API 端点、实施步骤
6. 等待：在开始编码之前获得用户确认

### 示例 2: 简单需求（跳过阶段 1 的 ultrathink）

用户: "给用户表添加一个手机号字段"

使用本技能的助手：
1. 理解：判断为简单需求（单一字段添加），**跳过此阶段的 ultrathink**
2. 探索：查找用户实体定义和相关迁移文件
3. 询问："手机号是否需要验证？是否允许为空？"
4. 深度分析：**使用 ultrathink** 考虑字段类型、验证规则、索引等（遵循 CLAUDE.md 规范）
5. 展示：显示完整计划
6. 等待：获得确认

## 输出格式模板 (Output Format Template)

```markdown
## 🎯 需求理解
- [我理解的要点列表]

## 🔍 代码库探索结果
- **CLAUDE.md 规范**: [项目规范的关键要点 - 命名约定、架构模式、编码规范等]
- **发现**: [相关的现有代码]
- **模式**: [要遵循的约定]

## ❓ 需要澄清的问题
[AskUserQuestion 工具结果 或 "无疑问 - 需求很清楚"]

## 🧠 深度分析 (使用 ultrathink)
[Sequential Thinking 顺序思考结果 - 技术设计决策，必须体现如何遵循 CLAUDE.md 规范]

## 📋 实施计划

### 数据库设计
[实体定义 - 遵循 CLAUDE.md 中的命名和字段规范]

### API 端点
[带方法和路径的端点列表 - 遵循 CLAUDE.md 中的 API 设计规范]

### Service 层
[服务方法签名和逻辑流程 - 遵循 CLAUDE.md 中的架构模式]

### 实施步骤
[编号的步骤列表 - 确保每步符合项目规范]

### 风险和注意事项
[需要注意的潜在问题]

### 规范遵循检查
- [ ] 数据库设计符合 CLAUDE.md 规范
- [ ] API 端点符合 CLAUDE.md 规范
- [ ] 代码结构符合 CLAUDE.md 规范
- [ ] 命名约定符合 CLAUDE.md 规范

## ✅ 准备好继续了吗？
这个计划看起来如何？我可以开始实施了吗？
```
