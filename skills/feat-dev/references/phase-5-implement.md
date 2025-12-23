# 阶段 5: 实施 (Implementation)

## 目标

按照架构设计计划实施功能，编写高质量、符合规范的代码。

---

## 前置条件

**必须**：用户已确认阶段 4 的架构方案。

如果用户未确认，返回阶段 4 等待确认。

---

## 使用模型

**推荐模型**：Sonnet

- HumanEval 分数：93.7%
- 性价比最优
- 适合编码实现

---

## 实施顺序

按照阶段 4 规划的步骤顺序实施，通常为：

### 1. 创建实体和数据库迁移

- 创建 Entity 文件
- 定义字段、类型、约束
- 定义关联关系
- 创建数据库迁移文件
- 运行迁移测试

### 2. 实施数据访问层

- 创建 Repository 接口
- 实现 CRUD 方法
- 实现查询方法
- 添加事务支持

### 3. 实施服务层业务逻辑

- 创建 Service 接口
- 实现业务逻辑方法
- 添加业务验证
- 添加错误处理
- 实现依赖注入

### 4. 创建请求/响应结构

- 创建 DTO（Data Transfer Object）
- 定义请求结构
- 添加验证规则（binding tags）
- 定义响应结构

### 5. 实施控制器

- 创建 Controller 文件
- 实现路由处理函数
- 添加请求验证
- 添加响应格式化
- 添加错误处理

### 6. 注册路由

- 在路由文件中注册端点
- 配置中间件（认证、授权、日志等）
- 分组和版本管理

### 7. 添加验证和错误处理

- 自定义验证规则
- 统一错误响应格式
- 添加日志记录
- 添加性能监控

---

## MCP 工具使用

### 📚 优先尝试：context7.get-library-docs

**目的**：实时查询 API 文档，确保使用最新语法

**使用场景**：
- 不确定某个 API 的用法
- 需要查看参数选项
- 需要了解返回值结构
- 需要查看错误处理方式

**示例**：

```bash
# 查询 ORM 的关联关系用法
context7.resolve-library-id: "gorm"
context7.get-library-docs: "/go-gorm/gorm" mode="code" topic="associations"

# 查询 Web 框架 的验证规则
context7.resolve-library-id: "gin"
context7.get-library-docs: "/gin-gonic/gin" mode="code" topic="validation"
```

**降级方案**：

```bash
# context7 不可用时
1. WebSearch: "ORM associations documentation latest version"
2. Grep: "HasMany|BelongsTo" 查找项目中的关联示例
3. Read: vendor/gorm.io/gorm/README.md
```

### 🔍 优先尝试：exa.get_code_context_exa

**目的**：搜索特定功能的实现示例

**示例查询**：
```
"ORM many-to-many relationship example code"
"Web 框架 custom validation rule implementation"
"context timeout handling example"
```

**降级方案**：
```
WebSearch: [相同查询内容]
```

---

## 实施原则

### 1. 严格遵循 CLAUDE.md 规范

- 代码组织结构
- 命名约定
- 错误处理模式
- 日志记录格式
- 注释风格

### 2. 遵循代码库现有模式

- 查看类似功能的实现
- 保持一致的代码风格
- 复用现有组件和工具函数

### 3. 每完成一个模块及时测试

不要等到所有代码都写完才测试：

```bash
# 实体创建后测试
go run main.{ext} migrate

# 服务层完成后测试
go test ./services/...

# 控制器完成后测试
curl -X POST http://localhost:8080/api/...
```

### 4. 保持代码简洁，避免过度设计

- 不要添加未请求的功能
- 不要过早优化
- 不要创建不必要的抽象
- 只在必要时添加注释

### 5. 安全第一

检查并避免常见安全漏洞：

- ✅ SQL 注入：使用参数化查询（ORM 自动处理）
- ✅ XSS：前端正确转义用户输入
- ✅ CSRF：使用 CSRF token
- ✅ 认证：验证用户身份
- ✅ 授权：验证用户权限
- ✅ 输入验证：验证所有用户输入
- ✅ 敏感信息：不要在日志中记录密码、token 等

---

## 代码示例

### 实体定义

```go
// models/dashboard.{ext}
package models

import (
    "time"
    "gorm.io/gorm"
)

type Dashboard struct {
    ID          uint           `gorm:"primaryKey" json:"id"`
    UserID      uint           `gorm:"not null;index" json:"user_id"`
    Name        string         `gorm:"size:100;not null" json:"name"`
    Description string         `gorm:"size:500" json:"description"`
    IsDefault   bool           `gorm:"default:false" json:"is_default"`
    CreatedAt   time.Time      `json:"created_at"`
    UpdatedAt   time.Time      `json:"updated_at"`
    DeletedAt   gorm.DeletedAt `gorm:"index" json:"-"`

    // Relations
    User    User     `gorm:"foreignKey:UserID" json:"user,omitempty"`
    Widgets []Widget `gorm:"foreignKey:DashboardID" json:"widgets,omitempty"`
}
```

### 数据库迁移

```go
// migrations/20250101_create_dashboards_table.{ext}
package migrations

import "gorm.io/gorm"

func CreateDashboardsTable(db *gorm.DB) error {
    return db.AutoMigrate(&models.Dashboard{})
}
```

### 服务层

```go
// services/dashboard_service.{ext}
package services

import (
    "context"
    "errors"
    "your-project/models"
    "your-project/dto"
    "gorm.io/gorm"
)

type DashboardService interface {
    Create(ctx context.Context, userID uint, req *dto.CreateDashboardRequest) (*models.Dashboard, error)
    GetByID(ctx context.Context, id uint, userID uint) (*models.Dashboard, error)
    List(ctx context.Context, userID uint) ([]*models.Dashboard, error)
    Update(ctx context.Context, id uint, userID uint, req *dto.UpdateDashboardRequest) (*models.Dashboard, error)
    Delete(ctx context.Context, id uint, userID uint) error
}

type dashboardService struct {
    db *gorm.DB
}

func NewDashboardService(db *gorm.DB) DashboardService {
    return &dashboardService{db: db}
}

func (s *dashboardService) Create(ctx context.Context, userID uint, req *dto.CreateDashboardRequest) (*models.Dashboard, error) {
    dashboard := &models.Dashboard{
        UserID:      userID,
        Name:        req.Name,
        Description: req.Description,
        IsDefault:   req.IsDefault,
    }

    if err := s.db.WithContext(ctx).Create(dashboard).Error; err != nil {
        return nil, err
    }

    return dashboard, nil
}

func (s *dashboardService) GetByID(ctx context.Context, id uint, userID uint) (*models.Dashboard, error) {
    var dashboard models.Dashboard
    err := s.db.WithContext(ctx).
        Where("id = ? AND user_id = ?", id, userID).
        Preload("Widgets").
        First(&dashboard).Error

    if err != nil {
        if errors.Is(err, gorm.ErrRecordNotFound) {
            return nil, errors.New("dashboard not found")
        }
        return nil, err
    }

    return &dashboard, nil
}

// ... 其他方法实现
```

### DTO 定义

```go
// dto/dashboard_dto.{ext}
package dto

type CreateDashboardRequest struct {
    Name        string `json:"name" binding:"required,max=100"`
    Description string `json:"description" binding:"max=500"`
    IsDefault   bool   `json:"is_default"`
}

type UpdateDashboardRequest struct {
    Name        string `json:"name" binding:"omitempty,max=100"`
    Description string `json:"description" binding:"omitempty,max=500"`
    IsDefault   *bool  `json:"is_default"`
}

type DashboardResponse struct {
    ID          uint            `json:"id"`
    Name        string          `json:"name"`
    Description string          `json:"description"`
    IsDefault   bool            `json:"is_default"`
    Widgets     []WidgetSummary `json:"widgets"`
    CreatedAt   string          `json:"created_at"`
    UpdatedAt   string          `json:"updated_at"`
}
```

### 控制器

```go
// controllers/dashboard_controller.{ext}
package controllers

import (
    "net/http"
    "strconv"
    "your-project/dto"
    "your-project/services"
    "github.com/gin-gonic/gin"
)

type DashboardController struct {
    service services.DashboardService
}

func NewDashboardController(service services.DashboardService) *DashboardController {
    return &DashboardController{service: service}
}

// Create godoc
// @Summary Create a new dashboard
// @Tags dashboards
// @Accept json
// @Produce json
// @Param request body dto.CreateDashboardRequest true "Dashboard data"
// @Success 201 {object} dto.DashboardResponse
// @Failure 400 {object} dto.ErrorResponse
// @Failure 401 {object} dto.ErrorResponse
// @Router /api/dashboards [post]
func (c *DashboardController) Create(ctx *gin.Context) {
    var req dto.CreateDashboardRequest
    if err := ctx.ShouldBindJSON(&req); err != nil {
        ctx.JSON(http.StatusBadRequest, dto.ErrorResponse{
            Error: "Invalid request",
            Message: err.Error(),
        })
        return
    }

    // 从上下文获取当前用户 ID
    userID := ctx.GetUint("user_id")

    dashboard, err := c.service.Create(ctx.Request.Context(), userID, &req)
    if err != nil {
        ctx.JSON(http.StatusInternalServerError, dto.ErrorResponse{
            Error: "Failed to create dashboard",
            Message: err.Error(),
        })
        return
    }

    ctx.JSON(http.StatusCreated, dto.DashboardResponse{
        ID:          dashboard.ID,
        Name:        dashboard.Name,
        Description: dashboard.Description,
        IsDefault:   dashboard.IsDefault,
        CreatedAt:   dashboard.CreatedAt.Format("2006-01-02T15:04:05Z07:00"),
        UpdatedAt:   dashboard.UpdatedAt.Format("2006-01-02T15:04:05Z07:00"),
    })
}

// GetByID godoc
// @Summary Get dashboard by ID
// @Tags dashboards
// @Produce json
// @Param id path int true "Dashboard ID"
// @Success 200 {object} dto.DashboardResponse
// @Failure 404 {object} dto.ErrorResponse
// @Router /api/dashboards/{id} [get]
func (c *DashboardController) GetByID(ctx *gin.Context) {
    id, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
    if err != nil {
        ctx.JSON(http.StatusBadRequest, dto.ErrorResponse{
            Error: "Invalid ID",
        })
        return
    }

    userID := ctx.GetUint("user_id")

    dashboard, err := c.service.GetByID(ctx.Request.Context(), uint(id), userID)
    if err != nil {
        ctx.JSON(http.StatusNotFound, dto.ErrorResponse{
            Error: "Dashboard not found",
        })
        return
    }

    ctx.JSON(http.StatusOK, dto.ToDashboardResponse(dashboard))
}

// ... 其他路由处理函数
```

### 路由注册

```go
// routes/api.{ext}
package routes

import (
    "your-project/controllers"
    "your-project/middleware"
    "github.com/gin-gonic/gin"
)

func RegisterAPIRoutes(router *gin.Engine, dashboardCtrl *controllers.DashboardController) {
    api := router.Group("/api")
    api.Use(middleware.AuthMiddleware())

    dashboards := api.Group("/dashboards")
    {
        dashboards.GET("", dashboardCtrl.List)
        dashboards.POST("", dashboardCtrl.Create)
        dashboards.GET("/:id", dashboardCtrl.GetByID)
        dashboards.PUT("/:id", dashboardCtrl.Update)
        dashboards.DELETE("/:id", dashboardCtrl.Delete)
        dashboards.GET("/:id/data", dashboardCtrl.GetData)
    }
}
```

---

## 测试建议

### 单元测试

```go
// services/dashboard_service_test.{ext}
package services

import (
    "context"
    "testing"
    "your-project/dto"
    "github.com/stretchr/testify/assert"
)

func TestDashboardService_Create(t *testing.T) {
    // Setup test database
    db := setupTestDB(t)
    defer cleanupTestDB(t, db)

    service := NewDashboardService(db)

    req := &dto.CreateDashboardRequest{
        Name:        "Test Dashboard",
        Description: "Test Description",
        IsDefault:   false,
    }

    dashboard, err := service.Create(context.Background(), 1, req)

    assert.NoError(t, err)
    assert.NotNil(t, dashboard)
    assert.Equal(t, "Test Dashboard", dashboard.Name)
}
```

### 集成测试

```bash
# 使用 curl 测试
curl -X POST http://localhost:8080/api/dashboards \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"name":"My Dashboard","description":"Test"}'
```

---

## 常见问题

### Q: 遇到不熟悉的 API 怎么办？

A: 使用 context7 或 WebSearch 查询文档，或查看项目中已有的类似实现。

### Q: 发现架构设计有问题怎么办？

A: 暂停实施，与用户讨论调整方案，更新设计后继续。

### Q: 代码写到一半发现需求理解有误怎么办？

A: 停止实施，与用户澄清，必要时回到阶段 3 或 4。

### Q: 是否需要写测试？

A: 根据项目要求。如果 CLAUDE.md 要求测试，必须编写。否则可选。

---

## 进入下一阶段

实施完成后，进入 **阶段 6: 质量审查**。

参见：[phase-6-review.md](phase-6-review.md)
