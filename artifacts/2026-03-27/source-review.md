# Daily Review 2026-03-27

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- 完成 [[阳绵优汇]] 项目首轮代码接管：确认新远端为 `git.metacash.cn/Flash/youhui.git`，生成并交付专用 SSH 公钥，同时验证 HTTPS + token 可访问。
- 发现 `youhui` 所在上层目录 `/Users/lab/Flash-Claude` 的 git/worktree 状态异常，避免继续在坏仓库上下文里操作，改为将 `youhui` 独立初始化为单独仓库并完成首次提交与首推。
- 成功将 `youhui` 首次推送到新仓库：提交 `1475b19 feat: initial import of youhui project`，远端 `main` 已建立并跟踪。
- 连上 [[Aliyun]] 服务器完成部署探查：确认现有线上结构为 Nginx(80/443) → Next.js(`127.0.0.1:3000`，PM2 进程 `ai-course-landing`)。
- 确认 `youhui` 为 [[Vite]] + [[React]] 静态前端，不应占用现有 `3000`，已在服务器上构建并上传静态产物到 `/var/www/youhui-test`。
- 为 `youhui` 临时新增 Nginx 测试监听 `8081`，服务器内网可返回内容；公网访问仍受阿里云安全组/现有入口限制，已把部署目录、端口和当前结构交接给同事处理域名与放行。
- 对第三方 skill [[Impeccable]] 完成安全审查，结论为低到中低风险、适合前端/UI 场景；随后完成 reference 拉取、本地构建，并同步到 [[Claude Code]] / Antigravity 相关目录，同时给 builder workspace 落了一份核心设计 skill。
- 对 [[openclaw-chat-history-import]] 完成初步安全审查：方向有价值，但因会写入 raw archive、daily memory 与 `MEMORY.md`，暂不建议直接进主 workspace 生产使用。

## 决策与变更
- 确认外部 Git 服务优先采用 `git.metacash.cn`，其中 `youhui` 已从原有混乱上层仓库中剥离，转为独立仓库管理。
- 明确 `youhui` 的部署策略：按静态站托管，不走 Next/Node 常驻服务，不复用线上 `3000`。
- 明确当前线上服务运行模型：Nginx 对外监听 `80/443`，反代到本机 `3000` 的 Next.js 应用；`3000` 属于现有生产应用，不可挪作测试用途。
- 服务器上新增 `8081` 作为 `youhui` 的临时测试监听端口；目录为 `/var/www/youhui-test`，适合作为后续运维接手的固定入口。
- 对第三方 skill 的安全 intake 规则得到实际执行：[[Impeccable]] 允许有限落地；[[openclaw-chat-history-import]] 暂定为“只适合 reference / 隔离测试”。

## 错误与改进
- `youhui` 初始排查时被上层损坏的 git/worktree 配置干扰，`git status` 报错指向无关路径；后续改为显式识别仓库边界，并在必要时直接独立初始化项目仓库，避免继续依赖坏的 monorepo 状态。
- SSH 方式接入 `git.metacash.cn` 时，22 端口被拒绝，说明不能先验假设远端支持 SSH；改为先用 HTTPS + token 完成验证与推送，更快落地。
- 尝试将 `youhui` 挂到现有 HTTPS 域名子路径时，因现有 Nginx/Next 路由结构导致静态页请求持续回落主站 404；结论是测试环境应优先使用独立端口或独立子域名，少碰现有线上路径复用。
- 公网 `8081` 超时但本机可访问，说明问题不在应用而在外层安全组/入口配置；今后部署汇报应继续区分“服务已起”与“公网已通”两个层次，避免误判为同一问题。
- [[Impeccable]] 仓库默认没有现成 `dist/`，需要本地 `bun install && bun run build` 后再同步；这类 skill 安装今后应默认先检查是否为源码仓而非成品包。

## 未完成事项（待提醒）
- 同事尚未完成 `youhui` 的公网测试入口处理：需放行 `8081`，或为其分配新域名/子域名并接到 `/var/www/youhui-test`。
- `youhui` 的对外可访问测试地址仍未最终拿到，目前只有服务器内部部署和结构信息已确认。
- Antigravity 虽已同步 [[Impeccable]] provider 文件，但是否被当前运行实例完整识别，还缺一次实际调用验证。
- [[openclaw-chat-history-import]] 仅完成安全审查，尚未拉到 reference 深读脚本与写入逻辑，也未做“只导 raw archive、不碰 `MEMORY.md`”的本地改造验证。
- 需要后续决定：是否为 `youhui` 补 SSH remote / 长期部署方案，还是保持 HTTPS 推送链路。

## 明日优先级 Top 3
1. 跟进 [[阳绵优汇]] 测试环境公网入口，拿到真实可访问 URL，并确认 Nginx / 安全组 / 域名的最终接法。
2. 验证 [[Impeccable]] 在 [[Claude Code]] 与 Antigravity 中的实际可见性与触发效果，必要时补最小使用说明。
3. 将 [[openclaw-chat-history-import]] 拉入 reference 深拆，评估是否值得做成“仅导 archive、人工审核记忆”的安全改造版。