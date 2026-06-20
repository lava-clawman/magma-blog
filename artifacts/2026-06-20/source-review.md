# Daily Review 2026-06-20

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]], [[Job Search]], [[Email Review]], [[Security]], [[Youthline]], [[Paperclip]], [[Magma Blog]]

## 今日关键事项
- [[Email Review]] 完成 AM/PM 两轮邮件复盘：
  - [[ImmiAccount]] 新浏览器登录已由 Shaun 确认为本人操作，标记为已处理。
  - [[Youthline]] / Trystan 的 online training launch 邀请被识别为需要 RSVP，但原邮件只写了 “in a few Thursdays / afternoon dessert”，缺少明确日期时间；Shaun 表示先想一想，需要后续提醒。
  - Supabase `kid-cards` 相关事项按 Shaun 指示仅存档，由他自行处理。
- [[Job Search]] 持续推进：
  - 已快速复核 Phocas、Datacom、Xe、UC Product Lead、Partly / ClearPoint 等岗位方向，Shaun 要求“岗位都帮我看一眼”，需要继续做统一排序。
  - [[Mike Greer Homes]] / IT Support + AI Business 相关材料已生成：`cv_mike_greer_it_support_ai_business.pdf`、`cover_letter_mike_greer_it_support_ai_business.pdf`，主线强调学习能力、适应能力、M365 / AD / device support 上手能力，以及把业务流程拆解、学习、自动化的能力。
  - [[hairyLemon]] 岗位重新评估：Youthline 真实项目经验可显著补足 WordPress / CMS / LMS / plugin integration / client training 场景，主观匹配度从原 73 上调到约 78–82；但 INZ Accredited Employer 查询未命中，若考虑签证路径需谨慎。
- [[Youthline]] 项目经历已被整理为可写入 profile / CV 的事实：
  - 真实 NGO / volunteer training platform 场景。
  - 技术栈与工作内容包括 [[Moodle]] LMS、[[WordPress]]、[[WooCommerce]]、[[Edwiser]] 插件、H5P、课程路径、证书、报名/访问 workflow、插件配置与兼容处理。
  - 核心叙事不是“做课程”，而是跨系统培训平台集成与运营支持。
- [[Security]] 排查与整改推进：
  - 对 AMOS / `AccountsHelper` 木马相关 IOC 做了检查，未发现同款木马明确命中。
  - 判断当前更大的真实风险是“浏览器钱包 + AI/自动化扩展 + 明文 token + agent 自动执行命令”的组合风险，而非已确认失陷。
  - 已清理 shell history 中敏感行：`.zsh_history` 移除 44 行，`.bash_history` 移除 1 行，并验证剩余敏感命中为 0；含 token 的临时备份也已删除。
  - 已把安装包 / 外部脚本安全准则同步给 [[Hermes]] agent。
- [[Second Brain]] / 知识库吸收继续运行：
  - x.com 文章 `Context Is A Projection` 已归档并吸收到知识库，核心判断是 coding agent 不应把 transcript 直接无限 append 成 context，而应区分 durable log、model-visible context、structured app state，并在每次调用时投影出合适上下文。
  - 今日 review 脚本未找到当天 memory log，但最近 24 小时 session 已提供足够复盘材料。
- [[Paperclip]] / [[Magma Blog]] 夜间自动化仍有背景状态：
  - Paperclip release `2026.609.0` 多次被记录为健康运行，迁移到移动硬盘的流程仍受 `AgentData` 未挂载限制。
  - Magma Blog 相关 prompt / source review / draft / final 流程在梦境日志中被记录为已产生 DRAFT_WRITTEN / FINAL_WRITTEN 信号，但不应替代后续真实状态核验。

## 决策与变更
- [[Email Review]] 状态处理策略继续明确：已确认/已处理邮件必须写入本地状态，避免 AM/PM 复盘重复追问；同一邮件 thread 有新进展时应标明“旧事项的新进展”。
- [[Youthline]] 经历正式成为求职 profile 的重要新素材：
  - 应作为本地真实组织项目经验使用，特别适合 CMS / LMS / WordPress / support / integration / training platform 类岗位。
  - 叙事重点应放在真实业务场景、跨系统集成、插件配置、用户/课程流程，而不是简单列技术名词。
- [[Job Search]] 策略保持现实优先：
  - 继续优先筛选本地岗位与能积累本地经验的机会。
  - 对非认证雇主岗位可作为 portfolio / local experience 机会，但不应和签证路径强绑定。
- [[Security]] 整改决策：
  - history 清理已完成。
  - 远程控制仍需要保留，但应约束为只接受 ZeroTier 网络内指定节点 `f9fd8928d1` 的操作。
  - 入站网络服务应尽量约束到 ZeroTier 内；但 pf 规则不能简单硬挡所有非 ZeroTier 入站，否则可能影响 ZeroTier 自身 UDP transport。
- [[Hermes]] / agent 安全规则新增重点：外部安装包、脚本、未知仓库、MCP / skill 等进入本机前必须先做安全审查，避免安装后再补审。
- [[Second Brain]] 继续强化“archive ≠ absorbed”的原则：链接与文章进入 raw archive 后，只有高信号内容才进一步抽取为 active knowledge fragment / topic / problem pack。

## 错误与改进
- 网络限制执行受阻：Telegram 直连会话无 elevated 权限，无法替 Shaun 修改 `/etc/pf.conf` / LaunchDaemon；后续需要本机管理员权限或由 Shaun 在本机 Terminal 执行经审查的脚本。
- 对安全整改不能只说“限制到 ZeroTier”：需要先识别 ZeroTier 接口、节点 IP、pf 当前状态、Remote Management/Screen Sharing 端口，再做可回滚变更；否则容易误伤 ZeroTier transport 或本机可达性。
- 今日无 memory log，说明 daily review 依赖 session 抽取仍可工作，但长期应补齐 `memory/YYYY-MM-DD.md` 的关键事实，避免重要状态只散落在会话里。
- 求职岗位自动分数需要二次判断：例如 hairyLemon 原分数低估了 Youthline 项目与岗位关键词的真实匹配；自动 pipeline 分数不能替代 JD 原文 + profile 复核。
- 邮件提醒需要更精确：Trystan 邮件缺少明确时间，不应假定活动日期；下一步应提醒 Shaun 决定是否回复，并建议向 Trystan 确认具体日期/时间。

## 未完成事项（待提醒）
- 明天上午提醒 Shaun：决定是否回复 Trystan / Youthline launch 邀请；如要回复，先确认活动具体日期与时间。
- 继续完成“岗位都帮我看一眼”：统一复核 Phocas、Datacom、Xe、UC Product Lead、Partly / ClearPoint 等岗位，按“值得投 / 备选 / 不建议占时间”排序，并标出是否需要生成 CV / cover letter。
- 网络安全限制仍未落地：需要在有管理员权限的环境执行或确认 pf/LaunchDaemon 脚本，把业务入站限制到 ZeroTier，并把远程控制限制到 `f9fd8928d1` 对应节点。
- Paperclip 数据迁移仍等待 `AgentData` 移动硬盘挂载；流程应保持“停服务 → 备份迁移 → 校验 → 可恢复清本地”，不要在未挂载时清理本地。
- 检查是否需要把 Youthline 项目经历写入 `data/my_profile.json` / 求职 profile 基线，以便后续 CV 生成稳定复用。
- 对 `Context Is A Projection` 文章的知识库吸收可继续推进：若已归档，应确认是否已写入 active knowledge log / topic，并用 wikilink 连接到 [[Agent Context Management]] 或相关页面。

## 明日优先级 Top 3
1. 完成 [[Job Search]] 岗位统一复核与排序，优先推进最值得投、最能积累本地经验的岗位，并决定哪些需要定制 CV / cover letter。
2. 处理 [[Youthline]] / Trystan launch 邀请：提醒 Shaun 做决定；若决定回复，草拟简短邮件并确认具体日期时间。
3. 收口 [[Security]] 后续：在具备管理员权限时落地 ZeroTier 入站 / 远程控制限制，并把 Youthline 项目经历同步进求职 profile 基线。