# Daily Review 2026-05-20

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]], [[Job Search]], [[Email Review]], [[Discord Jobs Forum]]

## 今日关键事项
- [[Job Search]] 继续推进：针对 University of Canterbury 的 Digital Course Developer 岗位，已用项目内 Claude Code skill 重新分析 JD，并生成专用 CV / cover letter 材料。
  - CV HTML：`/Users/lab/Flash-Claude/projects/project-resume-optimizer/Resumes/cv_uc_digital_course_developer.html`
  - CV PDF：`/Users/lab/Flash-Claude/projects/project-resume-optimizer/Resumes/cv_uc_digital_course_developer.pdf`
  - Cover letter HTML/PDF 同步生成在同一项目材料目录中。
- 对 [[Articulate Rise]] / [[Storyline]] 做了概念澄清：它们不是 LMS，而是 eLearning authoring tools；典型流程是制作课件后导出 SCORM/xAPI，再上传到 Moodle / Totara / Canvas 等 LMS。
- [[Email Review]] AM/PM 正常运行：
  - AM 识别 Humanitix / EPIC AI Conference AM Workshops 为明日行程提醒，地点 EPIC Innovation, 100 Manchester Street，8:00 开门，9:00 开始。
  - PM 识别 IBKR 日活动报表为财务留档类邮件；Cloudflare 周报显示 `all2h.com` 访问量较高但 LCP `5,740ms` 偏差，后续可作为性能优化线索。
- 今日没有发现 workspace `memory/YYYY-MM-DD.md` 日志；本次 review 主要基于近 24 小时 active sessions。

## 决策与变更
- 修正 [[Job Search]] / [[Discord Jobs Forum]] 的岗位同步流程：position 系统已有标准脚本链路，不应手动绕过。
- 标准链路已明确并沉淀：
  1. `build_job_pipeline.py`
  2. `build_analysis_queue.py`
  3. `build_discord_jobs_forum_queue.py`
  4. dry-run `sync_discord_jobs_forum.py`
  5. 确认不会重复发帖后再 `--live`
- 针对一次手动发帖补救：已发现脚本会因标题和 map 缺失而重复建帖，因此先把手动 thread 回填到 `data/discord_jobs_forum_map.json`，再让标准同步脚本接管。
- 已把“邮件里的岗位进入 position 系统后必须走标准同步链路”的规则补入两处：
  - `/Users/lab/.openclaw/workspace/skills/mail-review/SKILL.md`
  - `/Users/lab/.openclaw/workspace/AGENTS.md`

## 错误与改进
- 错误：处理岗位进入 [[Discord Jobs Forum]] 时曾手动发帖，绕过了 position → Discord 的标准同步脚本，造成潜在重复帖风险。
- 改进：已查明并固化标准流程；后续从邮件/岗位提醒进入 position 系统时，必须先跑完整 pipeline 和 dry-run，再执行 live sync。
- 改进：对 job-search pipeline 的关键规则已写入 skill 和 agent baseline，降低之后重复犯错概率。
- 观察：今日无短期 memory log，说明部分关键事件只存在 session history；如果这些事项具有长期复用价值，应优先沉淀到 `AGENTS.md` / skill / FlashNotes，而不是只留在聊天里。今天的岗位同步规则已完成沉淀。

## 未完成事项（待提醒）
- 明日 EPIC AI Conference AM Workshops：如果确认参加，需要提前准备路线、时间、签到材料和 workshop 所需设备。
- Cloudflare 周报中的 `all2h.com` LCP `5,740ms` 偏慢，可加入后续网站性能优化 backlog。
- IBKR 日活动报表可在方便时登录检查；若没有陌生交易，通常无需进一步处理。
- University of Canterbury Digital Course Developer 岗位材料已生成，后续仍需确认是否提交申请，以及申请状态是否已回填到 resume optimizer 项目。

## 明日优先级 Top 3
1. 确认并执行 EPIC AI Conference AM Workshops 行程准备，避免错过 9:00 开始时间。
2. 继续推进 University of Canterbury Digital Course Developer 岗位：复核材料、决定是否提交、提交后回填状态。
3. 把 `all2h.com` LCP 偏慢问题放入网站性能优化待办，至少先做一次页面性能检查和瓶颈定位。
