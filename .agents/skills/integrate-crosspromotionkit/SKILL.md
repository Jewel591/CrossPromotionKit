---
name: integrate-crosspromotionkit
description: 在任何 Apple App 里实现、迁移或排查「我们的其他作品 / 自家产品互推列表」能力时必须先加载：一律接 CrossPromotionKit（Jewel591/CrossPromotionKit），⛔ 不再手写产品目录、App Store 链接列表或图标查询缓存。覆盖标准接入姿势、CI lint（cross-promotion-kit-lint）的装配证据、consumer/developer 分组与 fail-closed 规则、新产品上架后的目录登记流程。触发词：其他作品、更多 App、互推、cross promotion、CrossPromotionKit。
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
- 排查某 App 里互推列表为空 / 分组不对

## 硬性规则

1. ⛔ 不手写目录。consumer / developer 分组、按宿主 bundle ID 自动选组、
   排除当前 App、App Store 元数据查询与 URLCache 全在 kit 内。
2. 接入 = lint 证据齐全（`cross-promotion-kit-lint`，validation 起硬闸）：
   - canonical URL + `Up to Next Major Version`（`from:`）依赖声明
   - application target 生产源码 `import CrossPromotionKit`
   - **模块限定**构造 `CrossPromotionKit.CrossPromotionSection(...)`（默认系统样式）
     或 `CrossPromotionKit.CrossPromotionRows(...)` + `CrossPromotionRowStyle`（自定样式）
     （测试 / Preview / DEBUG / 同名本地类型不算证据）
3. **未知宿主 fail closed（空目录）**：新产品接入后列表为空是登记问题，不是 bug——
   去 kit 仓库把宿主 bundle ID 登记进目录、发 kit 新版本、宿主重新解析依赖。
   ⛔ 不在宿主侧 hack 出一份本地清单顶着。
4. App 身份、分组归属、排序、上架状态都不是外部参数：⛔ 不给宿主加目录注入接口。
   产品只有在 App Store ID 已上线后才加入目录；未上架宿主可以只登记分组、
   自己的条目保持不出现。
5. ⛔ 不混分组：consumer 宿主只见 consumer 目录，developer 同理，没有降级混排。
