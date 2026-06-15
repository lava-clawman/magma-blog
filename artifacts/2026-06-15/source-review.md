# Daily Review 2026-06-15

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]], [[Job Search]], [[Email Review]], [[Paperclip]], [[Magma Blog]]

## 今日关键事项
- [[Job Search]] 是今天最主要的执行线：
  - 完成并记录 **Sunstone Talent / Junior AI Software Engineer** 投递，使用定制 CV、cover letter 和 60–90 秒视频；同步更新 `positions/index.json`、岗位 detail、`job_pipeline` 与 `analysis_queue`。
  - 完成并记录 **Ember Technology / Junior-Intermediate Software Engineer** 投递，使用定制短 cover note、Loom 自我介绍与 CareerMatch walkthrough；状态从 `draft` 更新为 `submitted`，并同步 pipeline/forum queue。
  - 复核 **Trimble / Cloud Engineer (Early Career/Intermediate)**，结论为不建议投；原因是 C#/.NET commercial development 与 CS/SE 学历要求是硬伤，匹配度约 40/100，已写入求职系统后归档。
  - 识别 **Halter / Software Engineers (All levels!)** 是旧岗位重发：旧 SEEK id `92099200`，新 SEEK id `92715247`，JD 基本相同；避免重复分析和误判为新机会。
- [[Email Review]] AM/PM 两次自动复盘正常运行：
  - AM：提醒图书馆借阅到期、Summer of Tech 活动、One-on-One CV Reviews 等事项。
  - PM：提醒 Elmwood Normal School 校讯、Futu AGM 参加申请截止、以及其他需要留意的账户/服务邮件。
- [[Cover Letter]] 与视频自我介绍话术完成多轮调整：
  - 对 Ember 通用 cover note 做了针对性微调，修正 `intrude myself` → `introduce myself`，降低“非传统工程师”防守感，强化 SaaS/cloud、practical AI、supportive team 与 Loom 项目展示。
  - 对 Sunstone/Junior AI Software Engineer 生成完整 75–90 秒视频稿，平衡工程能力、AI 项目和 product thinking，不把产品经验写成 PM 定位。
- 夜间系统维护/梦境摘要反映：[[Paperclip]] 运行稳定，`paperclip-poc` tmux 健康检查持续 200；[[Magma Blog]] 草稿流程仍围绕 Antigravity/prompt 文件与敏感信息清理运行。

## 决策与变更
- 求职策略继续保持“宁可少投，也不硬凑”：
  - 对 Trimble 这类本地优质但硬性技术栈不匹配的岗位，明确归档不投，避免消耗申请精力。
  - 对 Sunstone、Ember 这类更能承接 AI workflow、RAG、user-facing tools、SaaS/cloud 产品感的岗位，投入定制材料并完成投递。
- Cover note 定位策略进一步收敛：
  - 不再把 Shaun 描述成“主要是产品背景而非工程背景”，改为“product/client-requirements background + hands-on web/AI projects”。
  - 产品经验只作为 product thinking / user awareness 加分项，不喧宾夺主。
- 重复岗位识别成为 SEEK archive / position pipeline 的重要防重机制：
  - Halter 案例说明同公司同标题重发会换 SEEK id，但 JD 可能基本一致；后续分析需要优先查历史岗位库与正文相似度。
- 邮件复盘继续采用“状态记录 + 过滤已处理邮件”的机制，避免同一封邮件在 AM/PM 复盘中重复追问。

## 错误与改进
- 没有找到今天的 memory log：
  - 今日 review 只能依赖 24h active sessions，缺少本地日内流水补充。
  - 改进：确认 `memory/2026-06-15.md` 是否应由 heartbeat/日记/任务流程自动写入；如果没有，后续需要补上关键任务的轻量日志入口。
- 求职材料中出现明显 typo：
  - `intrude myself` 已被及时发现并修正为 `introduce myself`。
  - 改进：投递前对 cover note / Loom intro 固定做一次拼写与语气校验。
- 岗位名称听写/输入存在小误差：
  - “Helter” 实际为 **Halter**，已通过本地岗位库查证纠正。
  - 改进：对公司名/岗位名先 fuzzy search 本地 archive，再做判断。
- 邮件复盘仍有部分事项只给出“建议查看”，没有完成后续动作闭环：
  - Elmwood 校讯、图书馆借阅、Summer of Tech CV Review 等需要后续确认或执行。

## 未完成事项（待提醒）
- [[Email Review]] 待确认：
  - Christchurch City Libraries 借阅到期：需要确认是否续借或归还。
  - Elmwood Normal School 6月15日校讯：需要打开 Hail 链接扫一眼，确认是否有学校活动/截止日期。
  - Futu HK AGM：如需参加，申请截止为 2026-06-17 12:00；大概率留档即可。
- [[Job Search]] 待跟进：
  - Sunstone Talent 投递后的后续状态跟踪。
  - Ember Technology 投递后的后续状态跟踪。
  - Summer of Tech 6月18日 18:00 One-on-One CV Reviews：如果仍推进本地求职，建议优先参加/预约。
- [[Second Brain Operating System]] 待补强：
  - 检查为什么今天没有 memory log，并决定是否补一条当天任务摘要。
  - 将今日求职材料调整经验沉淀到求职话术/cover note 模板中，尤其是 product thinking 的表达边界。

## 明日优先级 Top 3
1. 跟进 [[Job Search]]：检查 Sunstone、Ember 投递记录是否完整，继续筛选更匹配 AI/web/SaaS 的本地岗位；避免把明显硬栈不匹配岗位推进到投递。
2. 处理 [[Email Review]] 遗留：图书馆借阅、Elmwood 校讯、Summer of Tech CV Review/Futu AGM 截止事项，能关闭的直接关闭。
3. 补强 [[Second Brain Operating System]] 日志链路：确认 daily memory log 缺失原因，并把今日“求职话术定位 + 重复岗位识别”沉淀成可复用规则或模板。
