# Daily Review 2026-08-03

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- 求职扫描两轮共新增 102 个岗位，并按新要求在通知中完整列出 `worth_reviewing`：上午 2 个、下午 10 个；其中包括 Air New Zealand 的 Senior Data Engineer for AI、Software Engineer (Microservices) 等候选。
- 收到 XO Recruitment 招聘顾问 Chloe 通过 SEEK 主动联系，推荐 Christchurch 医疗 IoT 公司的 Customer Operations Lead（约 NZ$100k）；值得回复以确认公司、团队、职责和匹配度。
- 确认 AI Developer & Enablement Specialist 视频申请自 7 月 19 日提交后已超过 10 个工作日无反馈，决定明日上午在原邮件线程礼貌追问进度。
- 邮件复盘确认 LinkedIn Newmarket 新设备登录为本人操作并关闭安全提醒；Contented Software Engineering Intern 已成功提交，继续等待反馈。
- [[magma-blog]] 完成“Claude Code 草稿 → worker-general 终稿 → 脚本发布”的自动发布链路；公开作品集 Context 周审也完成，安全加入 `seek-cli`，并将 `magma-blog` 能力排队待审。
- Jade Digital Experience Engineer 申请已提交；历史核查确认这是首次正式申请，未附 cover letter 暂不重复投递，等待是否有补充材料入口。

## 决策与变更
- 岗位扫描通知今后必须完整展示所有新增 `worth_reviewing` 岗位的名称与链接，不再仅展示自动推进结果；自动发帖仍只服务于真正进入 pipeline 的岗位。
- 明确区分三种状态：规则初筛候选、自动分析/推进、用户人工识别后推进；不得根据当前 forum 或 pipeline 状态倒推岗位当时是否被自动命中。
- Jade 被确认为关键回归案例：7 月 31 日扫描时得分 50，处于 36 个 `worth_reviewing` 候选中，但分析队列只取前 5，因而未进入分析；8 月 2 日是在用户人工要求后才进入 positions/pipeline。
- 作品集公开 Context 继续遵循隐私边界：Daily Review、memory 和内部运行记录只作为信号源，公开内容需移除私人求职数据、Cookie、本地路径、Discord 与内部流水线细节。

## 错误与改进
- 曾将 Jade 后来存在 forum 帖误判为扫描后自动推进。已纠正为真实链路，并确立以原始扫描、queue、triage 和 promotion 日志为准的历史核验规则。
- 当前岗位发现存在两层漏项风险：`worth_reviewing` 分析队列上限仅 5 个，以及机械评分/启发式门槛难以识别“接受 junior potential”等正文例外。完整通知已先解决显化问题，后续仍需改进队列覆盖和语义分析。
- 用户提供的 LinkedIn 入口与系统 SEEK 扫描来源曾被混淆。已确认二者是独立来源，同一岗位后来由 SEEK archive 提升入库；今后需保留“发现来源”和“流水线主链接来源”的区别。
- Elmwood School 校讯网页未能提取正文，当前信息不足，需手动浏览或换抓取方式。

## 未完成事项（待提醒）
- 明日上午回复原邮件线程，追问 AI Developer & Enablement Specialist 的申请进度。
- 回复 XO Recruitment 的 Chloe，了解 Customer Operations Lead 的具体公司、岗位范围、团队结构、技术/运营比例及招聘流程。
- 评估本日列出的 12 个新增 `worth_reviewing` 岗位，优先关注与本地经验、AI/data 和可迁移软件工程能力匹配的岗位。
- 为岗位扫描补充 Jade 回归场景，并评估扩大分析队列、分批分析或对低分高潜候选增加正文语义例外检测。
- 手动查看 Elmwood School 校讯；继续观察 Jade 与 Contented 的申请反馈。
- 审核是否将 `magma-blog` 多阶段内容自动化与故障恢复能力加入公开作品集 Context。

## 明日优先级 Top 3
1. 发出 AI Developer & Enablement Specialist 跟进邮件，并回复 XO Recruitment 主动邀约。
2. 快速筛选今日新增的 `worth_reviewing` 岗位，确定需要深入分析或立即申请的候选。
3. 修正岗位扫描的候选截断与语义漏判问题，完成 Jade 回归验证并确保通知持续完整显化。
