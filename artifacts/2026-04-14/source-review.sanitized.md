# Daily Review 2026-04-14

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- 完成 [[SEEK Job Capture]] 的三层留存落地：机器缓存 `seek_cache_v2.json`、日报 `seek_report_v2_YYYY-MM-DD.md`、可编辑归档 `data/seek_archive/`，并生成总索引、按日索引、单岗位 Markdown 与 sidecar metadata。
- 将岗位巡检从一次性脚本推进为可持续流程：新增 `run_seek_capture_daily.sh`，接入 cron，形成 09:00 与 15:00 两次定时抓取。
- 建立面向 AI 的可管理岗位目录结构：单岗位记录支持 `management_state`、`position_synced`、`position_id`、`analysis_status`、`application_status` 等字段，便于后续接入 [[Position System]] 与持续更新。
- 为新增岗位加入显式标记：在索引和单岗位文档中加入 `is_new` / `last_run_new`，让 AI 可直接识别“本轮新增”并做后续处理。
- 建立巡检观测层：新增 `seek_last_run_summary.json/txt` 与 `seek_capture_observations.jsonl/md`，开始记录每次抓取的新增量与时间，用于后续判断下午补抓是否有价值。
- 实测验证 SEEK 抓取链路：多次手动运行成功，已抓取并归档 270 个岗位；初步规则评分后形成 17 个 hot leads、55 个 worth reviewing 的本地池。

## 决策与变更
- 明确岗位巡检优先级：先稳定“抓取 → 留档 → 可管理目录”，后续再考虑更重的 AI 深分析与自动投递联动，避免过早复杂化。
- 定时策略多次迭代后定为：每天 09:00 与 15:00 运行；每个关键词抓 2 页，而不是 1 页。
- 默认检索关键词扩展为 9 个：`business analyst`、`product manager`、`data analyst`、`software developer`、`web developer`、`ux`、`mandarin`、`AI engineer`、`technical analyst`。
- 汇报策略收敛为低噪音：抓取后默认只汇报“新增岗位数量”，其余统计留在本地 summary / observation 文件中。
- 文档基线已同步更新：`seek_archive/README.md` 与 `docs/seek-scraper-design.md` 已记录当前 cron、页数、关键词、summary 文件与新增标记语义，避免脚本与文档漂移。

## 错误与改进
- cron 首次运行暴露环境差异：`uv` 不在 cron PATH，已通过 runner 显式补全 PATH 修复。
- 15:00 巡检虽然准时触发，但当次 `seek-cli` 未能读取可用 SEEK cookies，导致结果表面上为 `0 new jobs`；这说明“正常无新增”和“session/cookie 不可用”目前仍被混在同一种 summary 中。
- 已确认问题不在 `seek-cli` 本体：手动测试 search/detail 均可成功；通过启动 [[OpenClaw Browser]]、打开 SEEK 并重新登录后，再次验证 CLI 已恢复可用。
- 需要把抓取观测进一步升级为带状态码的结果（如 `ok` / `cookie_missing` / `seek_error`），否则下午巡检价值判断会被脏数据污染。

## 未完成事项（待提醒）
- 为 `seek_last_run_summary.*` 与 `seek_capture_observations.*` 增加 `run_status` 字段，区分真实零新增与 session/cookie 异常。
- 观察未来几天 09:00 vs 15:00 的新增量差异，判断下午补抓是否值得长期保留。
- 视观察结果再决定是否增加 `NEW THIS RUN` 专用视图或更适合 Shaun 的新增排序逻辑。
- 后续待接：[[Position System]] 同步映射、岗位状态流转标准化、按需 AI 深分析与投递流程联动。

## 明日优先级 Top 3
1. 给 SEEK 巡检 summary / observation 增加明确的 `run_status`，修正“0 新增”与“抓取失败”混淆的问题。
2. 检查 09:00 / 15:00 两轮抓取是否都稳定复用 SEEK session，并确认观测日志连续可用。
3. 评估 [[SEEK Job Capture]] 与 [[Position System]] 的最小映射方案，为后续统一管理岗位状态做准备。
