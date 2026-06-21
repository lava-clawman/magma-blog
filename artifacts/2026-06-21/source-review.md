# Daily Review 2026-06-21

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- [[Email Review]] AM/PM 两次执行：上午确认暂无紧急事项，`Supabase / kid-cards` 暂停通知按既有判断归档；晚上再次复盘时把 `kid-cards` 暂停、Creative Mail 营销邮件、LinkedIn / Trimble 相关岗位机会列入提醒与判断。
- [[School]] / Elmwood 观影时间确认：查明 **ENSCA Toy Story 5 Movie Night** 为 2026-06-21 14:45，地点 Reading Cinemas, The Palms；时间来源来自 Elmwood 6月8日 Hail 校讯文章，并交叉说明 Kindo 订单只确认购票，不提供时间。
- [[Knowledge Base]] 捕获了一篇关于 coding agent context management 的文章《Context Is A Projection》：核心判断是 transcript 不应直接无限 append 成 context；成熟 harness 应区分 durable log、model-visible context、structured app state，并在每次调用前投影出恰当上下文。
- [[Paperclip]] 相关夜间记忆显示：Paperclip 在 `paperclip-poc` tmux 中保持健康，release pin 为 `2026.609.0`，多次 heartbeat 返回 200；当前不需要干预。
- 外置硬盘备份流程被明确保持安全优先：在 APFS 卷未稳定挂载到 `/Volumes/AgentData`、写入/同步未通过前，不停止 Paperclip 做冷备份。
- 自动梦境/叙事日志生成正常运行，用于把系统片段、知识库摄取和运维状态转成轻量记忆材料。

## 决策与变更
- [[Email Review]] 继续采用“已处理/无需提醒则过滤”的状态驱动方式，避免重复追问已经归档的 Supabase 暂停类邮件。
- [[External Backup]] / [[Paperclip]] 备份策略保持保守：先确认外置盘物理识别、APFS 卷挂载、写入稳定性与 sync，再进入停服务冷备份；不为了完成备份而牺牲运行服务安全。
- [[Knowledge Management]] 对《Context Is A Projection》的吸收强化了第二大脑/agent 记忆的方向：长期日志、结构状态、模型可见上下文要分层，而不是把所有 transcript 当作上下文。
- [[School Operations]] 信息核验方式有效：用户追问来源后，明确区分“校讯文章确认时间”和“Kindo 订单确认购票”，提升了可追溯性。

## 错误与改进
- 邮件 PM 复盘中 `kid-cards` 暂停再次被列为“需要马上处理”，而 AM 已按用户偏好归档。这说明邮件状态过滤仍可能出现重复提醒；后续应优先读取 `email_review_state.json` 与历史日志，并按 subject/thread 去重。
- 外置硬盘仍存在不稳定：物理盘可见但 APFS 卷未可靠挂载。改进方向是继续更换线材/接口后做挂载与写入预检，必要时检查磁盘健康或改用更可靠备份介质。
- 今日没有 memory log 文件，Daily Review 只能依赖最近 24h active sessions。需要确认 `memory/YYYY-MM-DD.md` 的生成链路是否应该在当天自动产生日志，避免日评缺少结构化输入。
- 邮件复盘被同步到了 Discord channel session 中，可能产生频道噪音或路由混淆；后续应确认邮件复盘默认目标仍为 `#mail` 或专用上下文。

## 未完成事项（待提醒）
- 确认 `Supabase / kid-cards` 是否彻底归档；若未来仍要使用，需要在 90 天内 unpause，并考虑保活策略。
- 继续处理 LinkedIn / Trimble 等值得认真看的岗位机会：需要进入求职 pipeline 做 JD 复核、评分、是否申请判断。
- 外置硬盘冷备份未完成：等待磁盘稳定挂载与写入预检通过后，再停 Paperclip 做完整备份。
- 检查为什么今天没有 `memory/YYYY-MM-DD.md` 记录，并决定是否需要修复 daily memory capture。
- 复核邮件复盘状态去重逻辑，避免同一 Supabase 暂停事项 AM/PM 重复出现。

## 明日优先级 Top 3
1. 修复/确认 [[Email Review]] 去重与状态过滤，尤其是 Supabase 暂停类通知不要重复提醒。
2. 继续推进 [[External Backup]]：先做外置盘稳定性诊断，通过后再安排 Paperclip 冷备份。
3. 把 Trimble 等岗位机会放入 [[Job Search]] 标准 pipeline，完成 JD 原文复核、匹配判断与下一步申请动作。
