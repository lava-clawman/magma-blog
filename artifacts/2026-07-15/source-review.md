# Daily Review 2026-07-15

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- 完成 [[Opefin Software Engineer]] 岗位深度分析，结论为 **81% / 四星、高优先级定制投递**。主要匹配点是 Christchurch hybrid、NZ work rights、TypeScript / Next.js / serverless / Postgres / LLM，以及强调规格澄清、测试和对 AI 生成代码负责的工程方式；主要风险是商业工程年限。
- 为 Opefin 重新生成并调整 CV，随后已完成投递；申请状态、日期（2026-07-15）、岗位索引及 pipeline 队列均已同步。下一阶段是留意 recruiter introductory chat。
- 重新定位 [[Wholesale Solutions]] 视频脚本：不再以较久未更新的 CareerMatch AI 为中心，而是面向非技术受众，用真实求职流程说明 [[Agentic Workflow]] 如何减少重复劳动、提高判断质量，并保留具体案例避免内容过于抽象。
- 两轮邮件复盘均完成。PM 复盘识别出 Opefin 机会并推动进入岗位分析与投递；Gate 的 OpenAI Pre-IPO 产品被判断为高风险投机信息，不建议参与；其他低相关活动和岗位未分散当前求职主线。
- 自动岗位扫描两轮共发现 286 个新增岗位，自动推进 4 个进入 positions；包括 Docuvera Senior Data Engineer、Trade Me Senior / Intermediate Insights Analyst、Hall Consulting AI & Data Scientist 等候选。
- [[magma-blog]] 从 Claude CLI 草稿失败中恢复：草稿成功生成，随后完成 worker-general 终稿编排并正式发布，形成了一次完整的自动恢复与跨阶段闭环。

## 决策与变更
- CV 生成规范从“控制在两页、优先压缩”改为“优先可读性和页面均衡”：默认先使用舒展的字号、行高和间距；超页时优先删除低价值内容，而不是先缩字号。
- CV 验收增加硬性门槛：除两页限制外，还必须检查最小正文字号、行高、页面占用率、页间平衡、无溢出，并查看截图或打印预览。目标是消除“上半页过密、下方大块留白”的反复返工。
- 邮件 AM/PM 定时任务的固定模型由已下线的 `a-dobe-club/gpt-5.5` 更新为当前可用的 `a-dobe-club/gpt-5.6-sol`，并补跑了漏掉的 PM 复盘；确认故障来自模型白名单，而非邮箱或邮件脚本。
- 明确 Discord 路由语义：`replyTo` 仅引用消息，不会切换发送目标；向既有 thread 发消息必须使用 `thread-reply + threadId`，并校验返回的 `channelId` 是否等于目标 thread ID。该规则已写入持久工作规范，适用于切换频道和新 session 后的执行。
- 求职内容叙事进一步从“展示单个 AI 项目”转向“展示真实 agentic 工作流带来的业务效益”，更贴近当前实践和非技术招聘方的理解方式。

## 错误与改进
- **Discord 分析发错位置**：创建了 Opefin thread，但最终分析仍发送到父频道。原因是把 thread ID 错填为 `replyTo`。已将完整分析补发到正确 thread，并把正确调用方式和结果校验固化到 `AGENTS.md` / `TOOLS.md` 层面的长期规则。
- **CV 反复出现密度失衡**：旧流程只验证“两页”，导致字号偏小、顶部拥挤、底部留白。已将视觉平衡和可读性从人工反馈升级为自动验收条件，并用 Opefin CV 实测新门槛。
- **邮件复盘任务因模型下线失败**：任务绑定了不存在于白名单中的旧模型。已更新两个 cron 的显式模型绑定并成功恢复运行；后续关键定时任务应持续使用明确且已验证可用的模型。
- **magma-blog 草稿阶段失败**：Claude CLI 首次生成失败，但后续恢复成功，草稿、终稿和发布均完成。需要保留失败原因与恢复路径，以判断这是偶发 CLI 故障还是重复性稳定性问题。

## 未完成事项（待提醒）
- 跟踪 Opefin 投递后续，重点留意 recruiter 的 introductory chat；如收到邀请，优先准备针对商业工程年限、AI coding 责任边界、测试习惯和 Christchurch hybrid 的回答。
- 继续观察新版 CV 规范在后续岗位中的表现，确认自动检查确实能阻止页面密度失衡，而不是只修复 Opefin 单例。
- 对今日自动推进的 4 个岗位做价值排序和人工复核，避免低匹配的自动入库岗位占用定制投递精力。
- 核验 Wholesale Solutions 新版视频脚本是否已进入录制准备，包括时长、口语自然度、具体案例和面向非技术受众的表达清晰度。
- 观察 magma-blog 下一次运行；若 Claude CLI 草稿失败再次出现，应升级为稳定性排障，而不是继续依赖偶发恢复。

## 明日优先级 Top 3
1. 为 [[Opefin Software Engineer]] 准备 recruiter introductory chat 的精简答题包，并持续监控回复。
2. 用新版 CV 排版验收流程验证下一个高优先级岗位，确认字号、页面占用率、页间平衡和截图检查形成稳定闭环。
3. 复核自动进入 positions 的岗位并排序，只推进最符合“尽快获得本地经验”主线的机会。
