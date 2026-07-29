# Daily Review 2026-07-29

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- 完成全部启用中 [[OpenClaw]] cron 任务的模型配置排查。邮件 AM/PM 复盘及 `sb-daily-review`、`sb-weekly-review`、`sb-monthly-review`、`weekly-portfolio-context-review` 均已从失效的 `openai-codex/gpt-5.4` 切换至 `a-dobe-club/gpt-5.6-sol`，并配置可用 fallback；邮件 AM 复盘成功补跑，PM 复盘也正常交付。
- 深入核查 [[University of Canterbury]] 两个 Digital Services 岗位：均要求新西兰/澳大利亚公民或永久居民，且岗位级别偏高；当前 Post-Study Work Visa 不满足硬性身份条件，因此决定不投入申请时间。
- 核查 [[Westpac]] Digital AI & Automation Graduate 岗位：系统此前已抓取但仅进入 SEEK 本地岗位库，尚未完成人工深度分析或进入 positions；主要待确认毕业时间窗口与公民/PR 身份要求。
- 修复岗位扫描通知的统计与措辞：跨关键词重复岗位不再重复计数；“本轮新增 0 个”会同时说明当天此前的新收录数量；用“新收录”替代容易误解的“归档”。修复已通过语法检查及 20 项测试。
- 完成服务器开发环境迁移事项收口：旧 session 最后停在 7 月 28 日模型刷新修复完成、南京 SSH 主路径切换至 ZeroTier；南京开发机与 GCP Singapore 生产机均在线且目标服务可响应，确认不存在需要抢救的悬挂迁移任务。
- [[magma-blog]] 自动化链路完成一次正式发布：Antigravity/Claude Code 草稿 → worker-general 终稿 → 脚本发布。
- 完成 AM/PM 邮件复盘。重点包括 OpenAI 登录验证码、Vimeo 新账号、Google/Zoom 新授权、McDonald’s 收据核实，以及 Phocas 面试后续等待。

## 决策与变更
- cron 模型策略统一为当前白名单内的主模型与 fallback，避免任务在启动前因旧模型被拒绝。
- 坎大岗位以身份硬门槛优先筛除，不因技能相关性继续投入时间。
- 岗位扫描口径明确区分：系统“新收录”不等于人工分析、进入重点岗位、生成申请材料或已申请。
- 服务器迁移任务正式闭环；若后续继续推进，应创建新的工作项，而不是恢复旧 session。当前迁移线程为权威记录，其他频道仅作同步副本。
- 多 Agent 响应异常时明确身份边界：Lava 不代替 Alma 回复；先区分单 Agent 短暂卡顿与整体服务故障。

## 错误与改进
- 邮件复盘及多个 Second Brain cron 残留已失效模型名，导致任务启动前被拒绝。已批量修正并复查所有启用任务，当前未发现其他白名单外模型引用。
- 7 月 28 日 Daily Review 曾在脚本成功采集数据后因模型未调用写入工具而中断，暴露出“生成完成但文件未落盘”的交付风险。今日任务应以目标文件实际存在和内容检查作为完成标准。
- 岗位扫描上午通知将跨关键词重复结果计为 104 个，实际为 67 个唯一 Job ID，其中 66 个通过标题过滤。已在统计层去重，并调整通知上下文，防止“下午新增 0 个”被误读为全天无新岗位。
- Discord 中 Alma 一度未响应，但进程与 Lava 线程正常，更像单路短暂卡顿而非整体服务中断；后续故障排查应先检查 Agent、线程和路由三个层级。
- 南京服务探针曾使用错误的回环地址，随后改用 ZeroTier 入口完成验证；远程服务核验应区分进程存活与 HTTP 可响应，并使用实际访问路径。

## 未完成事项（待提醒）
- 确认 OpenAI 登录验证码、Vimeo 新账号及 Google/Zoom 授权是否均为本人操作；若否，立即撤销授权、检查活动会话并更新安全设置。
- 核实 McDonald’s 收据对应的消费是否为本人或家人产生。
- 等待 [[Phocas Software]] 第二阶段面试结果；招聘方预计下周初反馈。
- 如仍考虑 Westpac Graduate 岗位，需先确认是否满足“毕业前最后一年或毕业不超过 12 个月”以及新西兰/澳大利亚公民或 PR 条件；截止日期为 8 月 5 日。
- Breathing Matters 的 Tania 将于 8 月 6 日返回，期间课程正常进行。

## 明日优先级 Top 3
1. 完成账户安全确认：优先核实 OpenAI、Vimeo 和 Google/Zoom 的登录、注册及授权活动。
2. 跟进高价值求职事项：确认 Westpac 硬性资格；持续等待并准备回应 Phocas 面试反馈。
3. 观察修复后的 cron 与岗位扫描下一轮运行，确认模型 fallback、文件落盘、唯一岗位计数及“新收录”通知口径均按预期生效。
