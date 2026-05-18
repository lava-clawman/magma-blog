# Daily Review 2026-05-18

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]], [[Email Review]], [[Job Search]], [[PnL Dashboard]]

## 今日关键事项
- [[Email Review]] AM/PM 两轮正常执行：
  - 上午识别到 Yousician 新设备登录、Google 安全提醒等账号安全类邮件，建议确认是否本人操作。
  - 晚上识别到 Lovart 验证码、Anthropic 登录链接等安全/登录类邮件，并已过滤已处理邮件、更新本地状态 JSON 与 `Email_Review_Log.md`，同时把复盘发到 Discord。
- 处理 Trystan / Edwiser 邮件：确认这不是客服实质回复，而是 Edwiser Bridge Pro 自动工单回执；Trystan 后续会设置自动转发。
- 跟进 [[Job Search]]：查看 UC 的 GRI Geospatial Software Developer Research Assistant 原始 JD，判断它本质是 geospatial 方向的早期软件开发岗，而不是普通研究助理；关键限制是 NZ/AU citizen 或 permanent resident。
- 已按用户要求回复 Trystan：已知悉，并说明明天会去办公室。
- [[PnL Dashboard]] 顶部时间范围交互方案确定并已进入实现：将原 `Today / Yesterday / 更早/更新` 思路改为 `1D / 7D / 30D / 90D / 365D` + 当前日期/日期范围 + 左右箭头切换窗口。

## 决策与变更
- [[PnL Dashboard]] 日期导航采用“时间窗口导航器”模型：
  - `1D` 显示具体日期，例如 `5月18日`。
  - `7D/30D/90D/365D` 显示对应日期范围。
  - 左右箭头按当前窗口粒度移动，右箭头在当前最新窗口禁用，避免切到未来。
  - 这个方案被判断为比 `Today + Yesterday + 更早/更新` 更直觉、更少冗余。
- 邮件复盘继续按“过滤已处理 → 只复盘新增 → 写入状态文件 → 发送中文摘要”的流程执行，说明 [[Email Review]] 状态化机制已经在日常 cron 中稳定运转。
- 对 UC 软件研究助理岗位的判断应以原始 JD 为准，而不是只依赖邮件摘要；这与求职流程中“JD 原文优先”的规则一致。

## 错误与改进
- [[PnL Dashboard]] 改完代码/build 后，用户刷新页面没有变化；原因很可能是只改了代码和构建产物，但正在运行的服务仍是旧 dev bundle 或旧进程。
  - 改进：前端交互变更完成后，必须检查当前服务启动方式，并确认是否需要重启/切换运行服务。
  - 后续汇报不能只说“已改好”，要区分“代码已改/build 已过”和“线上/本地正在运行的页面已生效”。
- 今日没有找到 short-term memory log，说明 daily review 主要依赖最近 24 小时 session。若当天有重要事项发生在文件外或外部渠道，可能遗漏。
  - 改进：关键任务完成后尽量沉淀到 memory/日志或 FlashNotes，减少只靠 session 截断回忆。

## 未完成事项（待提醒）
- [[PnL Dashboard]]：需要继续确认服务是否已重启/切到新版本，并让用户刷新后能看到新的日期导航交互。
- [[Email Review]]：Lovart、Anthropic、Google、Yousician 等登录/安全提醒仍需要用户确认是否本人操作；若不是本人，需要进入账号安全处理。
- [[Job Search]]：UC GRI Geospatial Software Developer Research Assistant 岗位受 PR/citizenship 条件限制，需要确认用户是否满足硬门槛；若不满足，不应投入过多申请精力。
- Trystan / Edwiser：等待 Edwiser 后续实质回复被转发后再判断是否需要 Shaun 接手处理。

## 明日优先级 Top 3
1. 完成 [[PnL Dashboard]] 服务更新验证：确认运行进程、重启/切换到新版本，并回报用户刷新后的实际结果。
2. 处理今天积累的账号安全类邮件确认：把本人操作的标为已处理，非本人操作的升级为安全待办。
3. 跟进明天去办公室相关事项：若 Trystan/Edwiser 或 UC 岗位有后续邮件，及时复盘并给出下一步建议。
