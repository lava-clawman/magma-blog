# Daily Review 2026-04-20

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- 对 [[magma-blog]] 自动发布链路做了实质性收口：确认“`03:35` 主任务 + `04:35` 起 hourly retry”才是正确分工，已同步修改当前 crontab、`scripts/install-local-cron.sh` 和 `README.md`，避免主任务与补偿任务在 `03:35` 撞车。
- 重新核对了 [[magma-blog]] 4/19 的实际失败链，确认 `00:35` 是 `git pull --rebase` 被未提交改动阻断，`01:35` 至 `06:35` 持续发生草稿生成失败，`07:35` 首次进入后半段但又被 `orchestrate-reflection-finalization.py` 的 Python 兼容问题打断；此前“`02:35` 后停到 `07:35`”只是观察错觉，不是 cron 没跑。
- 明确回答并澄清了 OpenClaw 的 thinking / reasoning 机制：当前会话显示 `Reasoning: off`，但系统层支持 `off|minimal|low|medium|high|xhigh|adaptive` 多档 thinking；`adaptive` 的含义也被确认是“自适应”，并非固定档位。
- 对一个 [[Partly]] 的 intern 工程岗位做了结构化判断：岗位质量高、偏强工程基础与项目作品、明确要求 Christchurch 与 NZ work rights，更适合作为“高质量 intern / 学生向工程岗”而不是通用初级开发岗。
- 用 `gcloud` 对 Google Cloud 风险面做了只读审查：确认当前活跃账号为 `[redacted-email]`，可见项目主要为 `Default Gemini Project` 与 `ClawdTest`；未发现陌生 Owner、异常 service account 或 user-managed key。识别出 Gemini 相关 API key 3 个、Maps Platform key 1 个，但 OAuth client / redirect URI 仍未完整枚举，后续需结合 Console 人工核对。
- 在 Discord 多个上下文中持续提供了系统性解释与排障：包括 [[magma-blog]] cron 行为、 Google Cloud 授权风险面、以及岗位匹配性判断，整体从“即时答复”推进为“可落地的检查与修正”。

## 决策与变更
- 将 [[magma-blog]] 的调度策略正式收敛为：`03:35` 只保留首发主任务，retry 从 `04:35` 开始，避免再依赖锁去消化设计层面的重复触发。
- 确认对调度改动不能只改线上 crontab，必须同步改写安装脚本与文档，避免未来重装时把旧策略写回；这次已经把运行配置、生成脚本、README 三处对齐。
- 对 OpenClaw 的默认 thinking 叙述做了校正：不能把“当前 session 的 `Reasoning: off`”混同于“系统只有 off”；以后需要区分“会话当前状态”和“平台可配置能力”。
- 对 Google Cloud 安全排查采用了“先 CLI 只读收敛风险面，再要求最少量 Console 人工核对关键字段”的策略，而不是一开始就要求完整人工浏览器检查。

## 错误与改进
- [[magma-blog]] 暴露出两个不同层级的问题：一是 cron 设计本身重复触发，二是 `orchestrate-reflection-finalization.py` 使用了 `int | None` 这类更高 Python 版本语法，和 cron 下的 `/usr/bin/python3` 不兼容。前者今天已修正，后者仍待完成兼容性修补。
- [[magma-blog]] 失败观察再次提醒：外部体感上的“长时间没跑”常常是“其实在按计划重试，但推进失败且通知不稳定”；以后要把“实际执行次数”和“外部可见通知”分开记录，减少误判。
- Google Cloud 这轮排查没有发现明显恶意授权，但也暴露出 CLI 覆盖面的边界：IAM、API key、service account 能查得比较清楚，OAuth consent screen / redirect URI / Google Account 级第三方授权则仍需网页面确认，不能误以为 CLI 已完成闭环审计。
- 当前 `ClawdTest` 项目开启了 Gmail / Drive / Calendar / People 等较宽的 API 面，虽然不构成直接异常，但说明该项目的权限半径较大；后续必须继续确认 OAuth client、authorized domains、test users 与 key 来源限制，避免“无异常证据”被误当成“零风险”。

## 未完成事项（待提醒）
- 完成 `orchestrate-reflection-finalization.py` 的 Python 兼容性修复，并确认 cron 环境下后半段终稿编排能真正跑通。
- 继续核对 Google Cloud Console 中的 OAuth 2.0 Client IDs、redirect URIs、authorized domains、scopes、test users，以及 `Maps Platform API Key` 与 3 个 Gemini key 的 application restrictions / API restrictions。
- 对 `Default Gemini Project` 下的 `android`、`Lava Banana`、`Lava` 三个 key 做用途盘点，清理不再使用的 key，降低暴露面。
- 将今天对 OpenClaw thinking / reasoning、Google Cloud 授权检查、以及 [[magma-blog]] 调度修正中形成的稳定规则，视成熟度决定是否沉淀到 [[USER.md]] / [[AGENTS.md]] / [[TOOLS.md]] 或 `.learnings/`。

## 明日优先级 Top 3
1. 修完并验证 [[magma-blog]] 的 `orchestrate-reflection-finalization.py` Python 兼容问题，确保 `03:35` 主任务后的整条链路可闭环。
2. 完成 Google Cloud Console 的关键凭据核对：OAuth clients、redirect URIs、consent screen、API key 来源限制，并据此判断是否需要立即清理或收紧。
3. 对今天形成的系统级结论做一次轻量沉淀，尤其是 [[magma-blog]] 调度基线和 OpenClaw thinking / reasoning 的正确表述，避免后续重复误判。