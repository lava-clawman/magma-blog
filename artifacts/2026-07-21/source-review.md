# Daily Review 2026-07-21

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- 完成 [[The Warehouse Group]] AI Engineer 岗位判断与定制投递材料。岗位定位为初级数据工程、AI 落地推广与业务协作的混合角色；材料如实突出 GCP/AWS、硕士阶段 ML 学习、协作工具熟练度和学习意愿，未虚构 Azure 经验。
- 将 WordPress、Shopify、Squarespace、Webflow 等 CMS、网站建设及电商平台相关岗位正式纳入求职检索和评分范围；相关实现已完成，26 项测试全部通过。
- 核实 Tailgunner Web Developer/Designer 为 4 月归档且已下架的旧岗位，停止推进。
- 完成两轮邮件复盘。Todoist 产品更新已归档；HostGator 验证码、Youthline Staging 测试订单与选课、AA Insurance 续保等事项被识别并分级，其中前两项仍需确认是否为本人或符合预期。
- [[Magma Blog]] 已完成 2026-07-20 内容流水线：Claude Code 草稿、worker-general 终稿和脚本发布均成功。
- 查明一个 Discord 旧会话故障源于连续工具调用导致 272k 上下文溢出；自动压缩、工具结果截断及三次恢复均未能继续，但原会话和磁盘记录未丢失。

## 决策与变更
- 求职检索范围从传统软件与 AI 岗扩展至 CMS、网站制作和电商建站岗位，覆盖 WordPress、Shopify、Squarespace、Webflow 等技能组合，以增加更贴合现有能力且有本地经验价值的机会。
- AI Engineer 投递采用“真实相邻能力”策略：用 GCP/AWS 和 ML 基础证明迁移能力，不将有限的 Azure 使用包装成直接经验。
- Tailgunner 旧岗位确认失效后不再补建或顶起帖子，避免让历史归档岗位重新进入活跃流程。
- cron 清理工作决定延后至 Shaun 返回 Mac mini 后再执行管理员授权；在此之前保留原配置，避免绕过系统权限或直接修改 cron spool。
- DiDi 邮件事项的语义修正为“邮箱验证后绑定当前账户，同时从原账户解除关联”，相关四项正常活动均已关闭。

## 错误与改进
- 查找 Tailgunner 岗位时先按描述匹配了历史记录，却未优先验证招聘是否仍有效。后续处理历史岗位时应先检查当前页面、公司招聘页和归档日期，再建议顶帖或推进。
- 生成 AI Engineer 材料时，Claude Code 首次运行被项目 MCP 初始化卡住。已及时终止空转并改用禁用无关 MCP 的执行方式；以后应在启动前做 MCP 最小化或非交互预检。
- Discord 长会话因工具结果持续累积而超过上下文上限。多步骤、高工具输出任务应更早拆分到任务线程或子会话，并把大结果写入文件后只保留摘要，避免压缩后继续迅速溢出。
- `crontab -l` 可正常读取，但任何写入甚至原样写回都会卡死。当前确认配置未损坏且已有备份；后续应通过管理员授权定位系统写入层，不直接操作 cron spool。
- 邮件摘要中曾将 DiDi 事项简化为“解绑”，遗漏了“绑定当前账户”的主体动作。涉及账户关系变化时应保留完整因果和目标账户，避免产生误导。

## 未完成事项（待提醒）
- Shaun 回到 Mac mini 后，触发一次管理员授权：将 watchdog 路径规范为 `/Users/Shared/Claude/...`，并删除两条已迁移至 LaunchAgent 的 [[Magma Blog]] 旧 cron；完成后需验证 crontab、LaunchAgent 状态及 Magma Blog 调度均正常。
- 确认 HostGator 验证码是否由本人触发；若不是，应从官方入口修改密码并检查账户活动。
- 确认 Youthline Staging 的测试订单和 Moodle 课程加入是否符合预期。
- 跟进 AA Insurance 即将续保事项，检查续保日期、价格及是否需要比较替代方案。
- 继续观察扩展后的 CMS/建站岗位检索结果，确认新增召回没有引入过多低相关职位，并根据真实样本调整评分权重。

## 明日优先级 Top 3
1. 处理 HostGator、Youthline Staging 与 AA Insurance 邮件中的安全和时效性事项。
2. 检查 AI Engineer 投递材料与申请状态，确保 CV、cover letter 和岗位记录已进入标准求职 pipeline。
3. 复核新增 CMS/网站/电商岗位检索的首批结果；若 Shaun 已回到设备旁，再完成 watchdog 路径和旧 cron 清理。
