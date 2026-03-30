# Daily Review 2026-03-17

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- 完成了针对 GitHub「过去一周 [[Coding Agent]] / AI 开源项目热度榜」的多轮整理：先做趋势判断，再补成“项目价值 × 与本地工作流契合度”分析，最后重组为按系统层划分的研究地图（[[Runtime]], [[Skills]], [[Workflow]], [[Memory]], [[Browser Automation]], [[Orchestration]]）。
- 新增记录了 [[Agent Reach]]，将其定位为“给 agent 快速补齐互联网读取能力的脚手架”，并归入 [[Web Retrieval]] / [[Tool Use]] / [[CLI-first]] 相关图谱。
- 设计并落地了多 agent 共用的 [[Shared Baseline]]：不共享人格与记忆，而是共享机器级路径、工具说明、安全边界与运行基线。
- 为共享基线创建并启用了宿主级 hook，确保所有 agent 在 bootstrap 时自动加载共享文档。
- 完成了本地测试数据库环境核验：确认 `172.29.16.71:3306` 的 [[MySQL]] 测试库可实际登录查询；确认 `172.29.16.71:5432` 为同一台 ZeroTier 测试机上的 [[PostgreSQL]] 端口可达。

## 决策与变更
- 明确多 agent 共享策略应采用“共享 baseline / common ops context”，而不是共享 `MEMORY.md`：
  - 保持各 agent 的 `SOUL.md` / `USER.md` / `AGENTS.md` / `TOOLS.md` / `MEMORY.md` 独立。
  - 共享机器级资料：路径、工具约定、安全规则、环境说明。
- 新建共享目录：`/Users/lab/.openclaw/shared-baseline/`，并写入：
  - `SHARED_AGENT_BASELINE.md`
  - `SHARED_TOOLS_BASELINE.md`
  - `SHARED_PATHS.md`
  - `SHARED_SAFETY.md`
- 新建并启用 hook：`~/.openclaw/hooks/shared-baseline/`，使共享基线在 `agent:bootstrap` 时自动注入；Gateway 已重启并确认 hook `ready`。
- 对 main / planner / worker / reviewer 四个 workspace 的 `AGENTS.md` 与 `TOOLS.md` 做了瘦身，保留各自角色专属内容，将共用规则抽离到共享层。
- 将本地数据库测试环境写入共享基线，作为后续本地服务测试的默认候选：
  - [[MySQL]]: `172.29.16.71:3306`，数据库 `ai_course_landing_test`，用户 `casaos`
  - [[PostgreSQL]]: `172.29.16.71:5432`，已确认 TCP 可达，但库名/用户名/密码仍待补全

## 错误与改进
- 一度将 PostgreSQL 错测为本机 `127.0.0.1:5432`，得到“未监听”的错误结论；随后根据用户补充确认应测试 `172.29.16.71:5432`，完成纠正并回写共享基线。这个误差暴露出“本机端口”和“ZeroTier 远端端口”在表述上容易混淆。
- 共享基线初版带入了 [[Antfarm]] 与 [[Scrapling]] 的说明，但实际使用状态并不明确：
  - [[Antfarm]] 更像历史保留项，当前默认不应被视为主工作流。
  - [[Scrapling]] 是备用网页抓取工具，不是核心服务。
  后续需要把共享基线描述从“默认推荐”进一步收敛为“历史保留 / 备用工具”。
- 当前记忆库中没有沉淀 AWS / Google 服务器与本地测试机的结构化连接信息，说明部分关键基础设施事实仍停留在会话或终端痕迹中，尚未系统化进入共享层或长期记忆。
- 启用共享基线 hook 时伴随完成了 Gateway 重启与状态确认，但配置基线 diff 中暴露出历史配置差异仍较多，后续应继续保持“变更前 diff、变更后基线同步”的纪律。

## 未完成事项（待提醒）
- 审计 [[Antfarm]] 当前是否仍有残留 cron、workflow 或后台轮询，并决定是否降级为“历史保留”。
- 将 [[Scrapling]] 在共享基线中的定位明确改为“备用网页抓取工具”。
- 补全 `172.29.16.71:5432` 对应 [[PostgreSQL]] 的数据库名、用户、密码/认证方式，并写回共享基线。
- 追查并整理此前帮助连接过的服务器信息（AWS、Google、本地测试机/CasaOS），从 `~/.ssh/config`、known_hosts、shell history 或项目配置中提取结构化记录。
- 视需要把项目中硬编码的 `192.168.18.30` 更新为 `172.29.16.71`，避免继续混用旧内网地址与 ZeroTier 地址。
- 继续检查其他 agent workspace 是否还有适合抽到共享层的重复规则。

## 明日优先级 Top 3
1. 补全并验证 `172.29.16.71:5432` 的 [[PostgreSQL]] 凭据，形成可直接复用的本地测试数据库基线。
2. 做一次基础设施连接痕迹审计，沉淀 AWS / Google / CasaOS 测试机的结构化连接记录。
3. 清理共享基线中 [[Antfarm]] / [[Scrapling]] 的状态描述，并确认 shared baseline 是否还需进一步拆分或收敛。