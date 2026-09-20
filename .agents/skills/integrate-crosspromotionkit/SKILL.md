---
name: integrate-crosspromotionkit
description: 在任何 Apple App 里实现、迁移或排查「我们的其他作品 / 自家产品互推列表」能力时必须先加载：一律接 CrossPromotionKit（Jewel591/CrossPromotionKit），⛔ 不再手写产品目录、App Store 链接列表或图标查询缓存。覆盖标准接入姿势、CI lint（cross-promotion-kit-lint）的装配证据、宿主选择展示产品的方式、新产品上架后的目录登记流程。触发词：其他作品、更多 App、互推、cross promotion、CrossPromotionKit。
---

# CrossPromotionKit 接入 skill

（本文件是 skill 正身；各机器 `~/.agents/skills/integrate-crosspromotionkit/` 只放指向这里的壳。）

全线 Apple App 的自有产品推荐唯一正身是
**[Jewel591/CrossPromotionKit](https://github.com/Jewel591/CrossPromotionKit)**。
产品边界读仓库 `CLAUDE.md`，用法读 `README.md`；playbook 裁决在 `tech-stack TOOL-17`。

## 何时触发

- 设置页要加「我们的其他作品」
- 存量项目里看到手写产品清单 / App Store 链接数组 / 图标抓取代码
- `cross-promotion-kit-lint` 红灯
- 新产品上架，要把它加进全线互推目录
- 调整某个 App 展示哪些产品或展示顺序

## 硬性规则

1. ⛔ 不手写目录。产品的 Bundle ID、App Store ID、本地化名称与副标题、App Store 链接、
   元数据查询与 URLCache 全在 kit 内；宿主只通过 `CrossPromotionProduct` 引用产品。
2. **展示哪些产品、什么顺序，由 Ivens 在具体项目中决定。** 宿主把选择作为第一个参数传入：
   `CrossPromotionKit.CrossPromotionSection([.pickupCat, .filmo])`。Kit 没有受众分组、
   不按宿主 Bundle ID 自动选择、不自动排除宿主；名单里不要写宿主自己。
   ⛔ 会话不得自行增删某个 App 的名单，名单变更以 Ivens 的指示为准。
3. 接入 = lint 证据齐全（`cross-promotion-kit-lint`，validation 起硬闸）：
   - canonical URL + `Up to Next Major Version`（`from:`）依赖声明
   - application target 生产源码 `import CrossPromotionKit`
   - **模块限定**构造 `CrossPromotionKit.CrossPromotionSection(...)`（默认系统样式）
     或 `CrossPromotionKit.CrossPromotionRows(...)` + `CrossPromotionRowStyle`（自定样式）
     （测试 / Preview / DEBUG / 同名本地类型不算证据）
4. 新产品只有在 App Store ID 已上线后才加入 `CrossPromotionProduct`：在 kit 仓库登记、
   发新版本，再由各宿主按 Ivens 的指示决定是否加入自己的名单。
   ⛔ 不在宿主侧 hack 出一份本地清单顶着。

## 宿主测试边界

- 宿主只测试入口放置和自定义 Style 是否使用 Kit 提供的 configuration 动作；名单是一行字面量，不为它写测试。
- 按传入顺序解析、重复项去重、目录元数据、元数据查询与缓存属于 CrossPromotionKit；这些固定契约只在 Kit 包测试一次。
- 不在 XCTest 中扫描 `project.pbxproj`、import、源码字符串或旧目录声明；装配与生产入口由 `cross-promotion-kit-lint` 负责。
- 不复制 Kit 的目录 fixture 到 App。两个宿主若需要相同测试 helper，说明能力或测试接缝应回到 Kit。
