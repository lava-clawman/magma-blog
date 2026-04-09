# Daily Review 2026-04-08

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- 完成对 [[InkOS]] 的一轮真实链路验证：在 `~/Flash-Claude/projects/novel-lab/playground` 中创建测试书《磷海》，补齐 `author_intent` / `current_focus`，实际跑通 `plan`、`compose`、`draft` 与 `write next`。
- 《磷海》自动推进到第 10 章，确认系统具备短中程连续出章、审计、字数治理、状态更新能力，但第 5 章后明显进入中段循环：情绪弧线停滞、节奏单一、伏笔只推进不回收、词汇疲劳加重。
- 对失败原因做了分层归因：主因不是单一模型失能，而是 [[InkOS]] 的流程/方法论先把故事压进坏循环，prompt/控制面缺少可执行的反循环约束，模型再放大这些问题。
- 确认《磷海》此前默认使用的是 Google provider 的 `gemini-2.5-flash`；随后切换 `writer` 到 `google/gemini-3.1-pro-preview`，启动了第 11–12 章对照测试，用于分离“流程问题”和“模型上限问题”。
- 核实本地 [[InkOS]] 路径与角色分工：源码主仓在 `~/Flash-Claude/projects/novel-lab/inkos`，真实测试目录在 `~/Flash-Claude/projects/novel-lab/playground`。
- 检查上游 [[GitHub]] 状态：`feat/google-provider` 分支已成功 rebase 到最新 `upstream/master`（v1.1.1 基线），无冲突，Google provider 相关核心测试通过，PR #159 继续保持开启。
- 进一步定位上游主线红灯根因并修复：不是业务逻辑坏，而是 monorepo 内部包依赖被写成固定版本号，破坏了 pnpm workspace 拓扑。已恢复 `workspace:*` 链接，`pnpm build` 与 `pnpm test` 重新变绿，并向上游提交独立 PR #165。

## 决策与变更
- 决定将 [[InkOS]] 的问题分成三层看：流程/方法论、prompt/控制面、模型能力；后续优化不再默认把问题归咎给模型。
- 决定先做最小变量对照：只切换 `writer` 到 Gemini 3.1 Pro，保持其余 agent 与流程不变，验证更强写手模型是否能缓解中段退化。
- 决定将“Google native provider”与“上游红灯修复”拆成两条独立线，避免把功能 PR 与基础修复混在一起：
  - PR #159：Google native provider
  - PR #165：workspace / monorepo 红灯修复
- 决定对上游同步采取 rebase 优先策略；`feat/google-provider` 已顺利重放到 v1.1.1 基线上，说明近期上游更新没有直接踩到 Google provider 改动。
- 确认 `main agent` 当前默认 `thinking=off`，这是当前默认运行基线。

## 错误与改进
- 长任务续报执行不稳定：两次后台长跑完成后，没有第一时间主动回报结果，暴露出“完成事件→用户可见状态更新”这一环仍需强化。
- 《磷海》长程测试暴露了 [[InkOS]] 中段结构缺陷：
  - Planner/Composer 没有强制章型切换
  - Hook 机制偏“推进”而弱“回收”
  - 审计能报错，但没有形成足够硬的纠偏闭环
  - 当前控制面偏风格指导，缺少工程化约束（如禁止重复结构、强制旧债回收、强制关系变化）
- 上游 CLI 红灯的真实根因已澄清：不是 Google provider rebase 引入破坏，而是 workspace 依赖拓扑错误导致 CLI 吃到过期类型声明；这个问题已经定位并修复。
- 公开 PR 检查显示，PR #165 当前没有发现明显重复的他人 PR，说明这次修复不是撞车劳动。

## 未完成事项（待提醒）
- 等待并检查《磷海》在 `writer=gemini-3.1-pro-preview` 下的第 11–12 章结果，对比 `gemini-2.5-flash` 是否明显改善中段退化。
- 继续评估 [[InkOS]] 第 5–10 章失败案例，整理成更可执行的修复建议，重点是 Planner/Composer/审计闭环与控制面硬约束设计。
- 跟进 [[GitHub]] 上 PR #159 与 PR #165 的 CI、review 与 merge 状态，确认上游是否接受两条线的拆分策略。
- 若 Gemini 3.1 Pro 仍复现相同循环，需要进一步证明问题主要在流程和 steering，而非单纯模型上限。

## 明日优先级 Top 3
1. 拉取并评估《磷海》第 11–12 章对照测试结果，明确 Gemini 3.1 Pro 是否实质改善中段写作退化。
2. 把《磷海》案例整理成 [[InkOS]] 中段循环修复方案，明确流程层、prompt 层、模型层各自该改什么。
3. 跟进 PR #159 / #165 的 CI 与 review 状态，必要时继续处理上游反馈，推动 Google provider 线与红灯修复线进入可合并状态。
