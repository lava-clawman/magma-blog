# Daily Review 2026-07-17

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- [[Job Search]] 扫描两轮新增约 270 个岗位，自动推进 3 个：Royal New Zealand College of General Practitioners 的 Engineer - Full Stack，以及 Westpac Bank 的两条 Technical Systems Analyst 记录；其中 Westpac 结果存在重复/归并线索，需要清理。
- 重新复核 Information Leadership 的 Project Coordinator：人工匹配约 72%，建议中高优先级投递。历史归档与 SEEK 发布时间表明它不是同岗 repost；该公司近期多个岗位职责相似，是因为都围绕同一条客户交付链展开。
- 邮件复盘识别到 Google、Oracle Cloud、Anthropic 等账号安全事件；上午列出的 4 项操作已确认均为本人处理并关闭。晚间又出现 Windows 新设备登录及 Claude.ai 登录链接，仍需确认。
- Phocas Software 已发送面试确认，属于当前求职流程中的明确进展。
- [[magma-blog]] 在 Claude Code 认证过期导致连续失败后恢复：草稿生成、worker-general 终稿编排及正式发布均已完成。

## 决策与变更
- 岗位判断不沿用邮件自动评分，优先依据 JD 原文、真实经历与可迁移证据人工复核。
- Information Leadership 的多个职位按客户交付链区分，而不是简单视为重复岗位：Customer Engagement Manager 偏售前与 onboarding，Project Coordinator 偏协调与跟进，Technical Project Manager 对 scope、风险和交付结果负责。
- 修正 [[magma-blog]] 认证预检：不能只依据 `claude auth status` 退出码，必须识别输出中的 `Login: Expired`；同时改进失败通知，使重试次数和持续失败原因可见。

## 错误与改进
- [[magma-blog]] 从 04:35 到 10:35 每小时重试，共 7 次，但因 Claude Code 返回 401 全部失败；`.failure-notified` 抑制重复告警，导致用户误以为没有重试。现已修复认证判断与通知文案，并完成后续发布，恢复闭环。
- 公司/岗位交叉检索期间没有及时回复，造成用户等待并追问。今后长检索应先给阶段性结论或明确等待状态，不能无反馈卡住。
- Westpac 同名岗位被自动推进两次且分数不同，说明岗位去重/归并链路仍需验证，避免 positions 与 Discord forum 出现重复记录。
- 用户要求将两个岗位放入 pipeline 后，现有会话记录中没有看到明确执行确认；必须核查真实状态，不能把请求视为已完成。

## 未完成事项（待提醒）
- 核查用户所说“1、2进 pipeline”对应的两个岗位，并完成标准同步链路；确认 positions、analysis queue 与 Discord jobs forum 均无重复。
- 确认晚间 Google Windows 新设备登录及 Anthropic Claude.ai 登录链接是否为本人操作，并更新邮件复盘状态。
- 跟进 Phocas Software 面试：确认时间、参会方式，并准备公司/岗位研究、STAR 例子和反问问题。
- 清理或归并 Westpac Technical Systems Analyst 的重复候选记录。

## 明日优先级 Top 3
1. 核查并完成两个指定岗位进入 [[Job Search Pipeline]] 的全链路同步，同时处理 Westpac 重复记录。
2. 完成 Phocas Software 面试准备，形成可直接使用的公司研究、岗位匹配证据与 STAR 回答。
3. 关闭晚间两项账号安全确认，并验证 [[magma-blog]] 下一次定时运行的认证预检和告警行为。
