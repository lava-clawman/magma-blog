# Daily Review 2026-05-28

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- [[Email Review]] 继续运行 AM/PM 两轮复盘；PM 复盘识别出需要处理的家庭/账单/求职相关邮件，并在 `#mail` 输出中文分组建议。
- [[Job Search]] 今天重点推进 CrescoNet / Christchurch full stack developer 岗位判断：该岗位虽写 full stack，但实际画像更偏 senior backend / data infrastructure / utility platform，地点和方向都比远程 AU/NZ 或偏 Lead 岗位更贴当前目标。
- Supabase 云项目恢复能力被核实：本机 CLI 版本 `2.72.7`，但当前 CLI 不支持直接恢复 paused 云项目；`supabase start` 只适用于本地开发容器。
- 凌晨系统巡检显示 [[Paperclip]] 仍处于预期 local mode，`paperclip-poc` tmux 与 `/api/health` 状态正常。
- 昨日/凌晨沉淀的流程变化继续进入今日上下文：邮件复盘去重与状态闭环、Hermes dashboard 修复、岗位同步标准链路、Farmlands 申请材料等都已作为近期系统状态保留。

## 决策与变更
- [[CrescoNet]] 岗位被标记为当前批次中优先级较高的本地机会，原因是 Christchurch + full-time/hybrid + backend/data infrastructure 方向更接近 Shaun 当前“尽快获得本地岗位经验”的目标。
- [[Supabase]] 决策：不把 `supabase start` 误当作云端 paused project 恢复手段；云端恢复需要走 dashboard 或其他可用管理入口确认。
- [[Email Review]] 已形成更稳定的执行模式：读取 `email_review_state.json` 去重，输出待处理邮件，并同步写入状态/日志，避免重复追问已处理事项。
- [[Discord Jobs Forum]] / [[Job Search]] 的岗位同步规则已明确：必须走 position 系统标准脚本链路，先 dry-run 确认不重复，再 live；不要手动绕过论坛同步脚本。

## 错误与改进
- 邮件抓取仍可能缺失关键字段，例如 Mercury 账单金额/到期日未可靠读到；后续账单类邮件应明确标注“抓取不完整”，并优先建议去官网或原邮件确认金额与扣款状态。
- Supabase CLI 能力边界需要持续避免误判：命令存在不等于可执行云端管理操作，后续类似云服务恢复任务应先核实 CLI 子命令与权限。
- 今日没有找到独立 memory 日志，说明 daily review 对记忆材料依赖主要来自活跃 session；后续若希望日评更完整，应确保关键事项被及时写入 `memory/YYYY-MM-DD.md` 或 FlashNotes 对应日志。
- 求职线中自动 draft / pipeline 结论仍需和 JD 原文交叉复核，尤其当岗位标题与实际职责不一致时，应优先按 JD 原文重新判断。

## 未完成事项（待提醒）
- CrescoNet 岗位需要继续推进：保存/归档 JD，按项目标准流程进入分析队列，并决定是否生成定制 CV / cover letter。
- Mercury 账单需要 Shaun 或后续邮件/官网确认金额、到期日、direct debit 是否正常。
- Elmwood / Jill Royds 通知中的实际动作：孩子明天需要带 spelling book 回学校；周一 King’s Birthday 学校关闭，需要家庭安排确认。
- Supabase paused 云项目如仍需恢复，应通过 dashboard 或可用管理入口继续处理，不要停留在 CLI 假设上。
- Email Review 状态文件与 `Email_Review_Log.md` 需要继续保持去重，避免把用户已确认的邮件重新列为待处理。

## 明日优先级 Top 3
1. 推进 [[CrescoNet]] 岗位：按 [[Job Search]] 标准链路归档 JD、进入分析队列，并判断是否值得当天完成申请材料。
2. 清理 [[Email Review]] 待确认事项：优先确认 Mercury 账单与家庭通知动作，更新本地状态，减少重复提醒。
3. 补齐 [[Second Brain Operating System]] 日志链路：把今日关键系统决策写入 memory/FlashNotes，避免 daily review 只依赖 session 摘要。