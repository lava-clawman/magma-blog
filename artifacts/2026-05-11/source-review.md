# Daily Review 2026-05-11

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]], [[Job Search]], [[Email Review]], [[Hermes CLI]]

## 今日关键事项
- [[Job Search]] 是今天主线：围绕 EnergyAE、Allied Telesis、Rabobank 做了筛选、材料生成、状态同步与 forum 跟进。
- EnergyAE 岗位被判定为值得推进：虽然有机械/热工/合规经验短板，但与 Christchurch 本地、Python/data、AI/LLM workflow、产品架构、小团队 ownership、中英跨境沟通背景高度相关。
- 已为 EnergyAE 生成投递材料，并将状态推进到 `ready_to_apply`：
  - CV HTML/PDF
  - Cover letter HTML/PDF
  - 本地 pipeline 与 jobs forum 已同步。
- Allied Telesis 已完成投递后状态更新：
  - `application_status: submitted`
  - `pipeline_stage: submitted`
  - `recommended_action: wait_for_response`
  - 后续不会再作为待投递项推送。
- Rabobank graduate programme 经快速筛选后判定为低优先级备选：偏 agribusiness banking、非软件/BA/AI 主线，且 2027-02 才开始，不进入 jobs forum。
- 邮件复盘上午、晚上各执行一次：今天无需要马上处理的邮件；值得注意的是 Christchurch City Council 申请反馈延迟、Elmwood 校讯、Trade Me / Prosple 岗位推荐等。

## 决策与变更
- EnergyAE 的 CV/cover letter 方向明确为“Software Engineer + Technical Analyst / AI-assisted analysis 平台”而非普通全栈岗，材料应突出 Python、data、AI workflow、产品架构与跨域沟通。
- Allied Telesis 材料中撤掉突兀的 Angular 经验表述，改用更自然的 web / TypeScript / workflow dashboard 方向。
- `https://zone.a-dobe.club/` 被纳入 Allied Telesis 相关项目表达：作为真实临时 MVP demo，更能支撑 web app、地图/配送区域规划、真实需求落地能力。
- jobs forum 同步机制继续作为求职 pipeline 的外部状态面板：EnergyAE 新增 thread，Allied Telesis 已投递状态也被同步。
- [[Hermes CLI]] 配置完成一次重要修复：
  - 将 legacy root-level `provider / base_url / api_mode` 移入 `model:` 下。
  - 将 `compression.threshold` 从 `0.5` 降到 `0.24`。
  - `hermes doctor` 配置告警消失。
  - 非交互 smoke test 返回 `OK`。

## 错误与改进
- 下午岗位扫描出现 `triage_exit=1`、`promote_exit=skipped`。
  - 判断：不是 SEEK 抓取失败；pipeline、analysis queue、forum queue、forum sync 都成功。
  - 根因：`run_analysis_triage.py` 调用 Hermes 做岗位 triage 时，Hermes 非交互执行 exit 1，未返回 triage JSON。
  - 处理：修复 Hermes 配置并验证非交互调用恢复。
- `seek-cli` 的 SEEK detail `content2` 解析问题已修复并推送：
  - repo: `lazyeo/seek-cli`
  - commit: `2604e36 fix: parse SEEK detail content2 descriptions`
  - 验证：EnergyAE 详情页 JD 解析长度 `3975`，包含 `AI-assisted` / `LLMs`。
- 求职材料生成继续坚持“JD 原文 + profile 复核”，不机械沿用 pipeline 分数；今天 EnergyAE 与 Rabobank 的判断都体现了这一点。

## 未完成事项（待提醒）
- EnergyAE 当前状态为 `ready_to_apply`，下一步是实际投递；投递后需要回写本地状态并同步 forum。
- Christchurch City Council / Digital Experience Advisor 申请仍在等待反馈；邮件显示流程延迟，不需要主动追问，但应继续留意后续通知。
- Elmwood Normal School 5 月 11 日校讯仅被标记为值得扫一眼，尚未见已处理记录。
- Hermes triage 修复后，需在下一轮 job scan 中确认 `triage_exit` 不再失败，避免只完成了单点 smoke test 而未验证完整链路。

## 明日优先级 Top 3
1. 完成 EnergyAE 实际投递，并同步 `submitted` 状态到本地 pipeline 与 jobs forum。
2. 观察下一轮岗位扫描/triage/promote 链路，确认 Hermes 修复后不再触发 `triage_exit=1`。
3. 快速处理 Elmwood 校讯与 Christchurch City Council 后续邮件，只保留真正需要行动的事项。