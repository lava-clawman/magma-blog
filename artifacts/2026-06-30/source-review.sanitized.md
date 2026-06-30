# Daily Review 2026-06-30

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]], [[Job Search]], [[Email Review]], [[Magma Blog]], [[Knowledge Base]]

## 今日关键事项
- [[Job Search]] 今天是主线：岗位扫描两轮共新增大量 SEEK 岗位，并自动推进了若干匹配岗位进入 positions 系统，包括 Product Analyst、Software Engineer、Data and Insights Analyst、Junior Software Developer 等。
- 收到一个线上 interview 机会，并已将对应岗位状态更新为 `online_interview_invited`；准备方向已明确为“客户实施 + AI 工具/agent + 流程自动化”的混合叙事。
- [[Email Review]] AM/PM 两轮邮件复盘均已完成；本地状态文件与 `Email_Review_Log.md` 已更新。PM 复盘里确认 Phocas 面试已安排，是近期最高优先级事项。
- 为 Trade Me Intermediate Product Designer 岗位完成材料推进：修正岗位判断、生成 CV 与 cover letter PDF、刷新 pipeline，并通过 Discord jobs forum dry-run/live sync 确认没有重复建帖。
- 对 `EdgeMatrixChain/EMC-Website` private repo 做了快速工程与安全体检：确认是 Next.js 14 landing/marketing site，可 build，但存在较明显依赖安全与工程基线问题；同时解释了 Lark secret 的用途是 Contact Us 表单写入 Lark Bitable。
- 查询 Christchurch 与 Selwyn 图书馆馆藏，确认目标儿童书系列三本在两地均可找到，且 Christchurch 当前显示可借。
- [[Magma Blog]] 自动链路完成一次发布：Claude Code 草稿 → worker-general 终稿 → 脚本发布，2026-06-29 文章已发布。
- 日常生活问答处理：确认新西兰语境中 `gold/golden coin` 通常指 $1 或 $2，活动 donation 场景 $2 更常见/体面。

## 决策与变更
- 面试准备策略：不按纯技术面试准备，而应围绕“把混乱真实流程转成可落地 AI/software 工具”的主叙事，突出产品/客户理解 + agent/workflow 自动化能力。
- Trade Me 设计岗定位已定：不硬包装成纯视觉/专职 UX Designer，而是以 Product-side UX / Product Designer 叙事申请，正面处理 Figma/作品集弱项。
- EMC 官网项目判断：虽然主体是 landing page，但 Lark app secret 属于后端/表单集成敏感信息，不应视为前端展示依赖；上线前需要处理 secret 管理、依赖 audit 与工程基线。
- 求职流水线继续保持标准链路：岗位进入 positions 后，通过项目脚本刷新 pipeline、生成材料、dry-run Discord 同步，再 live sync，避免绕过系统造成状态漂移。
- 邮件复盘链路继续有效：每天 AM/PM cron 复盘新邮件，并把处理状态写入本地 JSON 与 FlashNotes 日志，减少重复提醒。

## 错误与改进
- EMC repo 安装时遇到本机 npm cache root-owned 文件；已按本机基线使用临时 npm cache 规避，没有贸然修改系统 cache。改进：后续遇到同类 `EACCES`/cache 问题继续优先用临时 cache。
- EMC 项目存在 critical/high audit 风险；需要区分“可 build”与“可生产上线”。改进：类似外部/私有项目体检要默认包含依赖安全、secret 暴露、部署方式与表单后端风险。
- Selwyn 图书馆官网被 Cloudflare 拦截；已改走目录入口继续查证。改进：公共站点检索不要因单入口失败就停止，优先换馆藏目录/搜索入口。
- 今日没有 memory log 文件，Daily Review 主要依赖 24h active sessions。改进：如果希望日总结更完整，需要让关键 cron/session 同步写入 `memory/YYYY-MM-DD.md` 或更稳定的事件日志。

## 未完成事项（待提醒）
- Phocas/线上 interview 准备需要继续推进：整理 STAR stories、岗位匹配叙事、英文回答、问题清单与模拟面试。
- Trade Me Product Designer 岗位材料已生成并同步，但是否正式提交、是否需要作品集/short note 最终润色，仍需跟进。
- EMC 官网项目尚未进入修复阶段；待办包括 secret 管理方案、依赖升级/audit、部署基线、Contact Us 后端替代方案评估。
- 自动推进的 SEEK 岗位需要后续人工/半自动复核并决定是否生成正式申请材料。
- Magma Blog 自动发布虽完成，但仍需持续观察 Antigravity/opencli 链路稳定性，避免之前的草稿质量/适配问题复发。

## 明日优先级 Top 3
1. 优先准备 Phocas/线上 interview：完成主叙事、STAR 案例、项目讲法、常见问题与一轮模拟。
2. 处理求职 pipeline 中已推进岗位：筛选最高价值 2-3 个，生成或完善申请材料，并确认提交状态。
3. 对 EMC 官网给出可执行修复清单：先处理 secret/安全风险，再决定是否值得继续工程化上线。