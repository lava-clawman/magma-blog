# Daily Review 2026-05-19

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]], [[Job Search]], [[Email Review]], [[OpenClaw]]

## 今日关键事项
- [[Job Search]] 是今天主线：围绕多个新西兰本地岗位做了分析、材料生成和申请优先级判断。
  - 已生成并同步材料：[[Ryman Healthcare]] AI Solution Engineer。
  - 已生成并同步材料：[[Comrad]] Junior / 软件相关岗位，人工复核后建议推进，约 78%。
  - 已生成并同步材料：[[Landpower]] SOP Product / Business Analyst，匹配度约 70%，适合作为本地经验入口。
  - 已生成并校验材料：[[Farmlands]] Graduate Software Developer；处理过程中发现 Claude Code 跑偏，改为手动补齐。
  - 邮件岗位初筛中重点看了 UC/GRI、Trimble、Partly 等机会；[[Partly]] Solutions Engineer 结论是“可以投，但要按 Solutions / Implementation / Data / Integration 逻辑定位，不要沿用 Product Manager 投法”。
- [[Email Review]] AM/PM 两次复盘正常运行。
  - AM：无紧急事项；标出一篇关于 Agent 上下文治理的高价值内容，建议后续认真读并沉淀。
  - PM：识别 HostGator 验证码与 Claude 登录链接为账号安全待确认项；晚些时候 Shaun 确认都是本人触发，已从待确认中消掉。
  - PM 还筛出多封岗位邮件，并完成简版判断。
- 继续执行 [[Second Brain Operating System]] 的日评流程：今天没有本地 `memory/YYYY-MM-DD.md` 日志，但从 24 小时活跃 session 中提取了有效记录并生成本日复盘。
- 昨晚延续事项：Shaun 询问设备进程管理里大量 `npm exec` 进程是否有用；判断多数是 Codex App 拉起的 MCP 服务或残留进程，不一定是未完成任务。

## 决策与变更
- [[Job Search]] 策略继续明确：当前优先争取本地岗位和本地经验，不只看标题是否完美匹配。
  - 对本地 Christchurch / NZ 经验价值高的岗位，即使不是纯 SWE，也可纳入申请池。
  - 对 Partly 这类岗位，需要从“PM 申请失败”切换到“Solutions Engineer / 客户落地 / 数据集成 / Python+SQL”叙事。
- 新西兰 CV 长度判断明确：Shaun 当前背景更适合 **2 页 CV**，不是硬压成 1 页。
  - 理由：有 Lincoln MAC、本地 volunteer、Python/Flask/MySQL 项目、AI/产品/需求/文档背景；压成一页会损失匹配度。
- 求职材料生成流程形成一个重要校准：Claude Code / 项目自动流程可用，但必须由主 agent 二次检查。
  - 今天多次出现 Claude Code 跑偏或误生成其他岗位材料的情况；最终采用“中止跑偏任务 → 本地确定性生成 → 文件/PDF/状态校验”的补救流程。
- 邮件安全信号处理形成闭环：验证码和登录链接不直接当作异常，也不忽略；先提醒确认，收到 Shaun 明确确认后更新状态，避免重复追问。

## 错误与改进
- Claude Code 在求职项目中出现上下文污染/目标跑偏：
  - Comrad 流程一度开始动 Ryman 材料和 index。
  - Farmlands 流程一度误生成 Landpower 文件并卡住。
  - 改进：后续每次调用求职项目技能前，应明确目标公司、岗位 slug、允许写入路径；运行后必须检查文件名、内容、PDF 产出和 pipeline 状态，不直接信任自动输出。
- 今日没有写入 `memory/2026-05-19.md`，导致日评脚本显示 “NO MEMORY LOGS FOUND FOR TODAY”。
  - 改进：高价值事项若当天发生，应及时写入短期 memory 或由日/周总结时补充，避免只散落在 session logs。
- 邮件复盘 PM 一开始把验证码/登录链接列为待确认是正确的，但后续需要继续保持“确认后清账”的纪律，防止安全类提醒反复出现造成噪音。
- 进程管理问题仍停留在诊断层：已判断大量 `npm exec` 多数来自 Codex App / MCP，但未见后续清理或策略收口记录。

## 未完成事项（待提醒）
- [[Job Search]]：确认并推进今天生成材料的岗位申请状态，尤其是 Ryman、Comrad、Landpower、Farmlands。
- [[Partly]] Solutions Engineer：若决定投，需要单独生成按 Solutions Engineer 定位的 CV / cover letter，不要复用之前 Product Manager 材料。
- UC/GRI Geospatial Research Assistant：先确认 NZ/AU citizen 或 PR 硬门槛；若不满足，直接跳过，避免浪费时间。
- AM 邮件中提到的 Agent 上下文治理文章值得后续深读，并可能沉淀到 [[OpenClaw]] / [[Agent Reliability]] 知识库。
- 设备上的 Codex App / MCP `npm exec` 残留进程可继续做一次安全清理判断：哪些是活跃需要保留，哪些可终止或通过重启 Codex App 回收。
- 补记短期 memory：今天关于求职流程跑偏、CV 两页判断、邮件安全确认闭环，都值得择要写入 `memory/2026-05-19.md` 或后续周总结。

## 明日优先级 Top 3
1. 推进今天已生成材料的本地岗位申请，并更新 [[Job Search]] pipeline 状态，避免材料生成后停在本地文件夹。
2. 对 [[Partly]] Solutions Engineer 做专门申请材料；同时按硬门槛快速筛掉不适合继续投入的岗位。
3. 把今天暴露的自动求职材料生成跑偏问题沉淀成项目流程检查清单：目标确认、写入范围、产物校验、状态同步。