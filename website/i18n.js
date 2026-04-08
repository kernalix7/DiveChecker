/* ══════════════════════════════════════════════
   DiveChecker — i18n (KO / EN / JA / ZH)
   ══════════════════════════════════════════════ */

const translations = {
    // ── PAGE ──
    'page.title': { ko: 'DiveChecker — 이퀄라이징을 눈으로 보다', en: 'DiveChecker — See Your Equalization', ja: 'DiveChecker — イコライジングを目で見る', zh: 'DiveChecker — 用眼睛看均压', tw: 'DiveChecker — 用眼睛看均壓' },

    // ── NAV ──
    'nav.guide': { ko: '사용 가이드', en: 'User Guide', ja: 'ユーザーガイド', zh: '使用指南', tw: '使用指南' },
    'nav.manual': { ko: '사용 설명서', en: 'Manual', ja: '取扱説明書', zh: '产品说明书', tw: '產品說明書' },
    'nav.faq': { ko: 'FAQ', en: 'FAQ', ja: 'FAQ', zh: 'FAQ', tw: 'FAQ' },
    'nav.support': { ko: '지원', en: 'Support', ja: 'サポート', zh: '支持', tw: '支持' },
    'nav.buy': { ko: '구매하기', en: 'Buy Now', ja: '購入する', zh: '立即购买', tw: '立即購買' },
    'nav.menu-label': { ko: '메뉴 열기', en: 'Open Menu', ja: 'メニューを開く', zh: '打开菜单', tw: '打開菜单' },

    // ── HERO ──
    'hero.badge': { ko: 'Equalizing Learning Device', en: 'Equalizing Learning Device', ja: 'Equalizing Learning Device', zh: 'Equalizing Learning Device', tw: 'Equalizing Learning Device' },
    'hero.title': { ko: '이퀄라이징을<br><span class="gradient-text">\'눈\'으로 보다</span>', en: 'See Your<br><span class="gradient-text">Equalization</span>', ja: 'イコライジングを<br><span class="gradient-text">「目」で見る</span>', zh: '用<span class="gradient-text">「眼睛」</span><br>看均压', tw: '用<span class="gradient-text">「眼睛」</span><br>看均壓' },
    'hero.desc': { ko: '감각이 아닌 <strong>데이터</strong>로 배우는 프리다이빙 균압 훈련.<br>100Hz 실시간 압력 센서 &middot; USB 제로 레이턴시 &middot; 크로스플랫폼', en: 'Freediving equalization training with <strong>data</strong>, not guesswork.<br>100Hz real-time pressure sensor &middot; USB zero latency &middot; Cross-platform', ja: '感覚ではなく<strong>データ</strong>で学ぶフリーダイビング均圧トレーニング。<br>100Hzリアルタイム圧力センサー &middot; USBゼロレイテンシー &middot; クロスプラットフォーム', zh: '不靠感觉，用<strong>数据</strong>学习自由潜水均压训练。<br>100Hz实时压力传感器 &middot; USB零延迟 &middot; 跨平台', tw: '不靠感覺，用<strong>數據</strong>學習自由潛水均壓訓練。<br>100Hz實時壓力傳感器 &middot; USB零延遲 &middot; 跨平台' },
    'hero.cta-buy': { ko: '지금 구매하기', en: 'Buy Now', ja: '今すぐ購入', zh: '立即购买', tw: '立即購買' },
    'hero.cta-learn': { ko: '더 알아보기', en: 'Learn More', ja: '詳しく見る', zh: '了解更多', tw: '了解更多' },
    'hero.stat-sampling': { ko: '샘플링', en: 'Sampling', ja: 'サンプリング', zh: '采样率', tw: '採樣率' },
    'hero.stat-latency': { ko: '레이턴시', en: 'Latency', ja: 'レイテンシー', zh: '延迟', tw: '延遲' },
    'hero.stat-resolution': { ko: 'hPa 분해능', en: 'hPa Resolution', ja: 'hPa分解能', zh: 'hPa分辨率', tw: 'hPa分辨率' },

    // ── PROBLEM ──
    'problem.label': { ko: 'PROBLEM', en: 'PROBLEM', ja: 'PROBLEM', zh: 'PROBLEM', tw: 'PROBLEM' },
    'problem.title': { ko: '이퀄라이징 실패는<br><span class="text-red">수업 포기</span>로 이어집니다', en: 'Equalization failure leads to<br><span class="text-red">giving up lessons</span>', ja: 'イコライジングの失敗は<br><span class="text-red">レッスン断念</span>につながります', zh: '均压失败会导致<br><span class="text-red">放弃课程</span>', tw: '均壓失敗會導致<br><span class="text-red">放棄課程</span>' },
    'problem.1.title': { ko: '수업 포기', en: 'Dropout', ja: 'レッスン断念', zh: '放弃课程', tw: '放棄課程' },
    'problem.1.desc': { ko: '이퀄라이징이 안 돼서 다음 레벨을 포기. 수강료만 날리는 악순환.', en: 'Can\'t equalize, can\'t advance. A vicious cycle of wasted tuition fees.', ja: 'イコライジングができず次のレベルを断念。受講料だけが無駄になる悪循環。', zh: '因为无法均压而放弃下一级别。学费白白浪费的恶性循环。', tw: '因為無法均壓而放棄下一級別。學費白白浪費的惡性循環。' },
    'problem.2.title': { ko: '원인 불명', en: 'Unknown Cause', ja: '原因不明', zh: '原因不明', tw: '原因不明' },
    'problem.2.desc': { ko: '뭐가 잘못인지 모른 채 같은 실수 반복. 연습이 아니라 시간 낭비.', en: 'Repeating the same mistakes without knowing what\'s wrong. Not practice — just wasted time.', ja: '何が間違っているかわからないまま同じミスを繰り返す。練習ではなく、ただの時間の無駄。', zh: '不知道哪里出了问题，却一直重复同样的错误。不是练习，而是浪费时间。', tw: '不知道哪裡出了問題，卻一直重複同樣的錯誤。不是練習，而是浪費時間。' },
    'problem.3.title': { ko: '건강 리스크', en: 'Health Risk', ja: '健康リスク', zh: '健康风险', tw: '健康風險' },
    'problem.3.desc': { ko: '과도한 발살바로 인한 고막 손상, 역압착. 되돌릴 수 없습니다.', en: 'Eardrum damage and reverse squeeze from excessive Valsalva. Irreversible.', ja: '過度なバルサルバによる鼓膜損傷、リバーススクイーズ。取り返しがつきません。', zh: '过度的Valsalva导致鼓膜损伤、反向挤压。不可逆转。', tw: '過度的Valsalva導致鼓膜損傷、反向擠壓。不可逆轉。' },

    // ── SOLUTION ──
    'solution.label': { ko: 'SOLUTION', en: 'SOLUTION', ja: 'SOLUTION', zh: 'SOLUTION', tw: 'SOLUTION' },
    'solution.title': { ko: '감 대신<br><span class="gradient-text">그래프</span>로 배우세요', en: 'Learn with<br><span class="gradient-text">graphs</span>, not guesswork', ja: '感覚ではなく<br><span class="gradient-text">グラフ</span>で学ぶ', zh: '不靠感觉<br>用<span class="gradient-text">图表</span>学习', tw: '不靠感覺<br>用<span class="gradient-text">圖表</span>學習' },
    'solution.sub': { ko: '이퀄라이징 압력을 실시간으로 시각화하는 국내 유일 디바이스', en: 'The only device that visualizes equalization pressure in real time', ja: 'イコライジング圧力をリアルタイムで可視化する唯一のデバイス', zh: '实时可视化均压压力的唯一设备', tw: '實時可視化均壓壓力的唯一設備' },

    // ── FEATURES ──
    'features.label': { ko: 'FEATURES', en: 'FEATURES', ja: 'FEATURES', zh: 'FEATURES', tw: 'FEATURES' },
    'features.title': { ko: '왜 다이브체커인가', en: 'Why DiveChecker', ja: 'なぜDiveCheckerなのか', zh: '为什么选择DiveChecker', tw: '為什么選擇DiveChecker' },
    'feat1.title': { ko: '실시간 압력 시각화', en: 'Real-time Pressure Visualization', ja: 'リアルタイム圧力可視化', zh: '实时压力可视化', tw: '實時壓力可視化' },
    'feat1.desc': { ko: '"더 세게" 같은 모호한 피드백은 끝.<br>내 프렌젤 압력이 정확히 몇 hPa인지 실시간으로 확인합니다. 과도한 압력 시 즉각 시각 경고까지.', en: 'No more vague feedback like "push harder."<br>See exactly how many hPa your Frenzel generates in real time. Visual alerts for excessive pressure.', ja: '「もっと強く」のような曖昧なフィードバックは終わり。<br>フレンゼルの圧力が正確に何hPaか、リアルタイムで確認できます。過度な圧力には即座に視覚警告。', zh: '告别"再用力一点"这样模糊的反馈。<br>实时确认您的Frenzel压力精确到几hPa。压力过大时立即视觉警告。', tw: '告別"再用力一點"這樣模糊的反饋。<br>實時確認您的Frenzel壓力精確到幾hPa。壓力過大時立即視覺警告。' },
    'feat1.tag1': { ko: '100Hz 샘플링', en: '100Hz Sampling', ja: '100Hzサンプリング', zh: '100Hz采样', tw: '100Hz採樣' },
    'feat1.tag2': { ko: '0.01 hPa 분해능', en: '0.01 hPa Resolution', ja: '0.01 hPa分解能', zh: '0.01 hPa分辨率', tw: '0.01 hPa分辨率' },
    'feat1.tag3': { ko: '실시간 그래프', en: 'Real-time Graph', ja: 'リアルタイムグラフ', zh: '实时图表', tw: '實時圖表' },
    'feat2.title': { ko: '발살바 vs 프렌젤 판별', en: 'Valsalva vs Frenzel Detection', ja: 'Valsalva vs Frenzel判別', zh: 'Valsalva与Frenzel判别', tw: 'Valsalva與Frenzel判別' },
    'feat2.desc': { ko: '지금 내가 프렌젤을 하고 있는지, 발살바를 하고 있는지 그래프 패턴이 즉시 알려줍니다. 두 기법의 압력 커브는 완전히 다릅니다.', en: 'The graph pattern instantly tells you whether you\'re doing Frenzel or Valsalva. The pressure curves of the two techniques are completely different.', ja: '今自分がフレンゼルをしているのか、バルサルバをしているのか、グラフパターンが即座に教えてくれます。2つの技法の圧力カーブはまったく異なります。', zh: '图表模式会立即告诉您现在是在做Frenzel还是Valsalva。两种技法的压力曲线完全不同。', tw: '圖表模式會立即告訴您現在是在做Frenzel還是Valsalva。兩種技法的壓力曲線完全不同。' },
    'feat2.tag1': { ko: '패턴 분석', en: 'Pattern Analysis', ja: 'パターン分析', zh: '模式分析', tw: '模式分析' },
    'feat2.tag2': { ko: '피크 감지', en: 'Peak Detection', ja: 'ピーク検出', zh: '峰值检测', tw: '峰值檢測' },
    'feat2.tag3': { ko: '기법 점수화', en: 'Technique Scoring', ja: '技法スコア化', zh: '技法评分', tw: '技法評分' },
    'feat3.title': { ko: '고급 기법 지상 훈련', en: 'Advanced Technique Dry Training', ja: '上級テクニック陸上トレーニング', zh: '高级技法陆地训练', tw: '高級技法陸地訓練' },
    'feat3.desc': { ko: '프렌젤 → 마우스필 → 핸즈프리(BTV).<br>물속에서 실패하기 전에, 지상에서 완벽하게 마스터하세요. 모든 기법의 학습 과정을 다이브체커가 함께합니다.', en: 'Frenzel → Mouthfill → Hands-free (BTV).<br>Master them on dry land before failing underwater. DiveChecker guides you through every technique.', ja: 'Frenzel → Mouthfill → Hands-free(BTV)。<br>水中で失敗する前に、陸上で完璧にマスターしましょう。すべての技法の学習過程をDiveCheckerがサポートします。', zh: 'Frenzel → Mouthfill → Hands-free(BTV)。<br>在水下失败之前，先在陆地上完美掌握。DiveChecker陪伴您学习所有技法。', tw: 'Frenzel → Mouthfill → Hands-free(BTV)。<br>在水下失敗之前，先在陸地上完美掌握。DiveChecker陪伴您學習所有技法。' },
    'feat3.tag1': { ko: '마우스필', en: 'Mouthfill', ja: 'Mouthfill', zh: 'Mouthfill', tw: 'Mouthfill' },
    'feat3.tag2': { ko: '핸즈프리 BTV', en: 'Hands-free BTV', ja: 'Hands-free BTV', zh: 'Hands-free BTV', tw: 'Hands-free BTV' },
    'feat3.tag3': { ko: '단계별 훈련', en: 'Step-by-step Training', ja: 'ステップ別トレーニング', zh: '分步训练', tw: '分步訓練' },
    'feat4.title': { ko: '피크 분석 & 성장 기록', en: 'Peak Analysis & Progress Tracking', ja: 'ピーク分析 & 成長記録', zh: '峰值分析 & 成长记录', tw: '峰值分析 & 成長記錄' },
    'feat4.desc': { ko: '매 세션마다 리듬 점수, 압력 점수, 기법 점수, 피로도 지수를 분석. S~F 등급으로 객관적인 성장을 추적합니다.', en: 'Analyze rhythm score, pressure score, technique score, and fatigue index every session. Track your objective growth with S~F grades.', ja: '毎セッション、リズムスコア、圧力スコア、技法スコア、疲労度指数を分析。S〜Fグレードで客観的な成長を追跡します。', zh: '每次训练分析节奏分数、压力分数、技法分数、疲劳指数。用S~F等级客观跟踪您的成长。', tw: '每次訓練分析節奏分數、壓力分數、技法分數、疲勞指數。用S~F等級客觀跟蹤您的成長。' },
    'feat4.tag1': { ko: '리듬 점수', en: 'Rhythm Score', ja: 'リズムスコア', zh: '节奏分数', tw: '節奏分數' },
    'feat4.tag2': { ko: '피로도 지수', en: 'Fatigue Index', ja: '疲労度指数', zh: '疲劳指数', tw: '疲勞指數' },
    'feat4.tag3': { ko: 'S~F 등급', en: 'S~F Grades', ja: 'S〜Fグレード', zh: 'S~F等级', tw: 'S~F等級' },

    // ── WHY USB ──
    'usb.label': { ko: 'WHY USB', en: 'WHY USB', ja: 'WHY USB', zh: 'WHY USB', tw: 'WHY USB' },
    'usb.title': { ko: '블루투스 대신 <span class="gradient-text">USB</span>를 선택한 이유', en: 'Why we chose <span class="gradient-text">USB</span> over Bluetooth', ja: 'Bluetoothではなく<span class="gradient-text">USB</span>を選んだ理由', zh: '选择<span class="gradient-text">USB</span>而非蓝牙的原因', tw: '選擇<span class="gradient-text">USB</span>而非藍牙的原因' },
    'usb.sub': { ko: '이퀄라이징 훈련에서 0.01초의 지연은 잘못된 피드백입니다', en: 'In equalization training, 0.01s delay means wrong feedback', ja: 'イコライジング訓練で0.01秒の遅延は間違ったフィードバックです', zh: '在均压训练中，0.01秒的延迟就意味着错误的反馈', tw: '在均壓訓練中，0.01秒的延遲就意味着錯誤的反饋' },
    'usb.col-bt': { ko: 'Bluetooth', en: 'Bluetooth', ja: 'Bluetooth', zh: 'Bluetooth', tw: 'Bluetooth' },
    'usb.col-usb': { ko: 'USB (다이브체커)', en: 'USB (DiveChecker)', ja: 'USB (DiveChecker)', zh: 'USB (DiveChecker)', tw: 'USB (DiveChecker)' },
    'usb.row1': { ko: '전송 지연', en: 'Latency', ja: '伝送遅延', zh: '传输延迟', tw: '傳輸延遲' },
    'usb.row1-bt': { ko: '50~300ms', en: '50~300ms', ja: '50~300ms', zh: '50~300ms', tw: '50~300ms' },
    'usb.row1-usb': { ko: '0ms', en: '0ms', ja: '0ms', zh: '0ms', tw: '0ms' },
    'usb.row2': { ko: '배터리', en: 'Battery', ja: 'バッテリー', zh: '电池', tw: '電池' },
    'usb.row2-bt': { ko: '충전 필요', en: 'Charging required', ja: '充電が必要', zh: '需要充电', tw: '需要充電' },
    'usb.row2-usb': { ko: 'USB 전원 공급', en: 'USB powered', ja: 'USB給電', zh: 'USB供电', tw: 'USB供電' },
    'usb.row3': { ko: '연결 안정성', en: 'Stability', ja: '接続安定性', zh: '连接稳定性', tw: '連接穩定性' },
    'usb.row3-bt': { ko: '페어링 실패 가능', en: 'Pairing may fail', ja: 'ペアリング失敗の可能性', zh: '可能配对失败', tw: '可能配對失敗' },
    'usb.row3-usb': { ko: '100% 안정 연결', en: '100% stable', ja: '100%安定接続', zh: '100%稳定连接', tw: '100%穩定連接' },
    'usb.row4': { ko: '호환성', en: 'Compatibility', ja: '互換性', zh: '兼容性', tw: '兼容性' },
    'usb.row4-bt': { ko: '기기별 상이', en: 'Varies by device', ja: 'デバイスにより異なる', zh: '因设备而异', tw: '因設備而異' },
    'usb.row4-usb': { ko: 'Win / Mac / Android / iOS', en: 'Win / Mac / Android / iOS', ja: 'Win / Mac / Android / iOS', zh: 'Win / Mac / Android / iOS', tw: 'Win / Mac / Android / iOS' },
    'usb.row5': { ko: '데이터 손실', en: 'Data Loss', ja: 'データ損失', zh: '数据丢失', tw: '數據丟失' },
    'usb.row5-bt': { ko: '끊김 발생', en: 'Disconnection', ja: '切断の発生', zh: '会断开', tw: '會斷開' },
    'usb.row5-usb': { ko: '단 1초도 놓치지 않음', en: 'Never miss a second', ja: '1秒も逃さない', zh: '一秒不漏', tw: '一秒不漏' },

    // ── HOW TO USE ──
    'how.label': { ko: 'HOW TO USE', en: 'HOW TO USE', ja: 'HOW TO USE', zh: 'HOW TO USE', tw: 'HOW TO USE' },
    'how.title': { ko: '3단계로 시작하세요', en: 'Start in 3 Steps', ja: '3ステップで始めよう', zh: '3步开始', tw: '3步開始' },
    'how.step1.title': { ko: 'USB-C 연결', en: 'Connect USB-C', ja: 'USB-C接続', zh: '连接USB-C', tw: '連接USB-C' },
    'how.step1.desc': { ko: '케이블 하나로 전원 + 데이터 동시 연결. 복잡한 페어링 없이 꽂기만 하면 끝.', en: 'One cable for power + data. Just plug in — no complex pairing needed.', ja: 'ケーブル1本で電源+データ同時接続。複雑なペアリングなしで差すだけ。', zh: '一根线同时供电+传输数据。无需复杂配对，插上即可。', tw: '一根線同時供電+傳輸數據。無需復杂配對，插上即可。' },
    'how.step2.title': { ko: '앱 실행', en: 'Launch App', ja: 'アプリ起動', zh: '启动应用', tw: '啟動應用' },
    'how.step2.desc': { ko: 'QR코드로 앱 다운로드, 자동 디바이스 인식. 별도 설정 필요 없음.', en: 'Download via QR code, auto device detection. No setup needed.', ja: 'QRコードでアプリダウンロード、自動デバイス認識。設定不要。', zh: '扫描QR码下载应用，自动识别设备。无需设置。', tw: '掃描QR碼下載應用，自動識別設備。無需設置。' },
    'how.step3.title': { ko: '연습 시작', en: 'Start Training', ja: 'トレーニング開始', zh: '开始训练', tw: '開始訓練' },
    'how.step3.desc': { ko: '코에 대고 이퀄라이징. 실시간 그래프로 즉각 피드백을 받으세요.', en: 'Place on your nose and equalize. Get instant feedback via real-time graphs.', ja: '鼻に当ててイコライジング。リアルタイムグラフで即座にフィードバック。', zh: '贴在鼻子上均压。通过实时图表立即获得反馈。', tw: '貼在鼻子上均壓。通過實時圖表立即獲得反饋。' },

    // ── TARGET ──
    'target.label': { ko: 'FOR YOU', en: 'FOR YOU', ja: 'FOR YOU', zh: 'FOR YOU', tw: 'FOR YOU' },
    'target.title': { ko: '이런 분들이 사용합니다', en: 'Who It\'s For', ja: 'こんな方におすすめです', zh: '适合这些人使用', tw: '適合這些人使用' },
    'target.1.title': { ko: '이퀄라이징이 안 되는 분', en: 'Struggling with Equalization', ja: 'イコライジングができない方', zh: '无法均压的人', tw: '無法均壓的人' },
    'target.1.desc': { ko: '내 문제를 눈으로 확인하고 정확히 교정', en: 'See your problem and correct it precisely', ja: '問題を目で確認し正確に矯正', zh: '用眼睛确认问题并精确矫正', tw: '用眼睛確認問題并精確矯正' },
    'target.2.title': { ko: '프렌젤 전환이 어려운 분', en: 'Switching to Frenzel', ja: 'フレンゼル移行が難しい方', zh: '难以转换到Frenzel的人', tw: '難以轉換到Frenzel的人' },
    'target.2.desc': { ko: '발살바 → 프렌젤 전환을 그래프로 확인', en: 'Verify Valsalva → Frenzel transition with graphs', ja: 'バルサルバ→フレンゼル移行をグラフで確認', zh: '通过图表确认Valsalva→Frenzel的转换', tw: '通過圖表確認Valsalva→Frenzel的轉換' },
    'target.3.title': { ko: '딥 & 머메이드 다이버', en: 'Deep & Mermaid Divers', ja: 'ディープ＆マーメイドダイバー', zh: '深潜和美人鱼潜水员', tw: '深潛和美人魚潛水員' },
    'target.3.desc': { ko: '마우스필 · BTV 핸즈프리 지상 훈련', en: 'Dry training for Mouthfill & BTV hands-free', ja: 'Mouthfill・BTV Hands-free陸上トレーニング', zh: 'Mouthfill・BTV Hands-free陆地训练', tw: 'Mouthfill・BTV Hands-free陸地訓練' },
    'target.4.title': { ko: '다이빙 강사', en: 'Diving Instructors', ja: 'ダイビングインストラクター', zh: '潜水教练', tw: '潛水教練' },
    'target.4.desc': { ko: '그래프 기반 정확한 피드백 제공', en: 'Provide precise graph-based feedback', ja: 'グラフに基づく正確なフィードバック提供', zh: '提供基于图表的精确反馈', tw: '提供基於圖表的精確反饋' },

    // ── TECH FLOW ──
    'tech.sensor': { ko: '100Hz 센서', en: '100Hz Sensor', ja: '100Hzセンサー', zh: '100Hz传感器', tw: '100Hz傳感器' },
    'tech.mcu': { ko: '듀얼코어 MCU', en: 'Dual-core MCU', ja: 'デュアルコアMCU', zh: '双核MCU', tw: '雙核MCU' },
    'tech.midi': { ko: '제로 레이턴시', en: 'Zero Latency', ja: 'ゼロレイテンシー', zh: '零延迟', tw: '零延遲' },
    'tech.app': { ko: '크로스플랫폼', en: 'Cross-platform', ja: 'クロスプラットフォーム', zh: '跨平台', tw: '跨平台' },

    // ── SPECS ──
    'specs.label': { ko: 'SPECIFICATIONS', en: 'SPECIFICATIONS', ja: 'SPECIFICATIONS', zh: 'SPECIFICATIONS', tw: 'SPECIFICATIONS' },
    'specs.title': { ko: '제품 사양', en: 'Specifications', ja: '製品仕様', zh: '产品规格', tw: '產品规格' },
    'specs.sensor-title': { ko: '센서 & 성능', en: 'Sensor & Performance', ja: 'センサー & 性能', zh: '传感器 & 性能', tw: '傳感器 & 性能' },
    'specs.sensor': { ko: '센서', en: 'Sensor', ja: 'センサー', zh: '传感器', tw: '傳感器' },
    'specs.internal-sampling': { ko: '내부 샘플링', en: 'Internal Sampling', ja: '内部サンプリング', zh: '内部采样', tw: '內部採樣' },
    'specs.output-freq': { ko: '출력 주파수', en: 'Output Frequency', ja: '出力周波数', zh: '输出频率', tw: '輸出頻率' },
    'specs.output-freq-val': { ko: '4~50Hz (설정 가능)', en: '4~50Hz (configurable)', ja: '4~50Hz（設定可能）', zh: '4~50Hz（可设置）', tw: '4~50Hz（可設置）' },
    'specs.resolution': { ko: '분해능', en: 'Resolution', ja: '分解能', zh: '分辨率', tw: '分辨率' },
    'specs.range': { ko: '측정 범위', en: 'Range', ja: '測定範囲', zh: '测量范围', tw: '測量范围' },
    'specs.range-val': { ko: '-10 ~ +200 hPa (상대압)', en: '-10 ~ +200 hPa (relative)', ja: '-10 ~ +200 hPa（相対圧）', zh: '-10 ~ +200 hPa（相对压力）', tw: '-10 ~ +200 hPa（相對壓力）' },
    'specs.filter': { ko: '필터', en: 'Filter', ja: 'フィルター', zh: '滤波器', tw: '濾波器' },
    'specs.filter-val': { ko: 'IIR x2 + 평균화', en: 'IIR x2 + Averaging', ja: 'IIR x2 + 平均化', zh: 'IIR x2 + 均值化', tw: 'IIR x2 + 均值化' },
    'specs.hw-title': { ko: '하드웨어', en: 'Hardware', ja: 'ハードウェア', zh: '硬件', tw: '硬件' },
    'specs.product-name': { ko: '제품명', en: 'Product', ja: '製品名', zh: '产品名', tw: '產品名' },
    'specs.product-name-val': { ko: '디지털 압력 감지 학습기', en: 'Digital Pressure Sensing Trainer', ja: 'デジタル圧力感知学習器', zh: '数字压力感知学习器', tw: '數位壓力感知學習器' },
    'specs.model': { ko: '모델명', en: 'Model', ja: 'モデル名', zh: '型号', tw: '型號' },
    'specs.mcu': { ko: 'MCU', en: 'MCU', ja: 'MCU', zh: 'MCU', tw: 'MCU' },
    'specs.mcu-val': { ko: 'RP2350 (Pico2) 듀얼코어', en: 'RP2350 (Pico2) Dual-core', ja: 'RP2350 (Pico2) デュアルコア', zh: 'RP2350 (Pico2) 双核', tw: 'RP2350 (Pico2) 雙核' },
    'specs.interface': { ko: '인터페이스', en: 'Interface', ja: 'インターフェース', zh: '接口', tw: '接口' },
    'specs.power': { ko: '전원', en: 'Power', ja: '電源', zh: '电源', tw: '電源' },
    'specs.cert': { ko: '인증', en: 'Certification', ja: '認証', zh: '认证', tw: '認證' },
    'specs.cert-val': { ko: 'KC 적합등록 (R-R-DCQ-DC)', en: 'KC Registered (R-R-DCQ-DC)', ja: 'KC適合登録 (R-R-DCQ-DC)', zh: 'KC合规登记 (R-R-DCQ-DC)', tw: 'KC合規登記 (R-R-DCQ-DC)' },
    'specs.origin': { ko: '제조국', en: 'Made in', ja: '製造国', zh: '产地', tw: '產地' },
    'specs.origin-val': { ko: '대한민국', en: 'South Korea', ja: '韓国', zh: '韩国', tw: '韓國' },
    'specs.sw-title': { ko: '소프트웨어', en: 'Software', ja: 'ソフトウェア', zh: '软件', tw: '軟件' },
    'specs.framework': { ko: '앱 프레임워크', en: 'App Framework', ja: 'アプリフレームワーク', zh: '应用框架', tw: '應用框架' },
    'specs.platform': { ko: '플랫폼', en: 'Platforms', ja: 'プラットフォーム', zh: '平台', tw: '平台' },
    'specs.platform-val': { ko: '5개 OS 지원', en: '5 OS Support', ja: '5 OS対応', zh: '支持5个OS', tw: '支持5個OS' },
    'specs.storage': { ko: '데이터 저장', en: 'Data Storage', ja: 'データ保存', zh: '数据存储', tw: '數據存儲' },
    'specs.analysis': { ko: '분석', en: 'Analysis', ja: '分析', zh: '分析', tw: '分析' },
    'specs.analysis-val': { ko: '피크 감지 + 점수화', en: 'Peak Detection + Scoring', ja: 'ピーク検出 + スコア化', zh: '峰值检测 + 评分', tw: '峰值檢測 + 評分' },
    'specs.app-ver': { ko: '앱 버전', en: 'App Version', ja: 'アプリバージョン', zh: '应用版本', tw: '應用版本' },
    'specs.fw-ver': { ko: '펌웨어 버전', en: 'Firmware Version', ja: 'ファームウェアバージョン', zh: '固件版本', tw: '固件版本' },
    'specs.lang': { ko: '언어', en: 'Language', ja: '言語', zh: '语言', tw: '語言' },
    'specs.lang-val': { ko: '한국어 / English / 日本語 / 中文 / 繁體中文', en: 'Korean / English / Japanese / Chinese / Traditional Chinese', ja: '韓国語 / English / 日本語 / 中文 / 繁體中文', zh: '韩语 / English / 日本語 / 中文 / 繁體中文', tw: '韓語 / English / 日本語 / 中文 / 繁體中文' },
    'specs.update': { ko: '업데이트', en: 'Update', ja: 'アップデート', zh: '更新', tw: '更新' },
    'specs.update-val': { ko: 'UF2 펌웨어 업데이트', en: 'UF2 Firmware Update', ja: 'UF2ファームウェアアップデート', zh: 'UF2固件更新', tw: 'UF2固件更新' },

    // ── PACKAGE ──
    'pkg.label': { ko: 'PACKAGE', en: 'PACKAGE', ja: 'PACKAGE', zh: 'PACKAGE', tw: 'PACKAGE' },
    'pkg.title': { ko: '구성품', en: 'Package Contents', ja: '同梱品', zh: '包装内容', tw: '包裝內容' },
    'pkg.item1': { ko: '다이브체커 본체 (DC-EQ01)', en: 'DiveChecker Unit (DC-EQ01)', ja: 'DiveChecker本体 (DC-EQ01)', zh: 'DiveChecker主机 (DC-EQ01)', tw: 'DiveChecker主機 (DC-EQ01)' },
    'pkg.item2': { ko: 'USB-C 데이터 케이블', en: 'USB-C Data Cable', ja: 'USB-Cデータケーブル', zh: 'USB-C数据线', tw: 'USB-C數據線' },
    'pkg.item3': { ko: '사용 설명서', en: 'User Manual', ja: '取扱説明書', zh: '使用说明书', tw: '使用說明書' },

    // ── DOWNLOAD ──
    'dl.label': { ko: 'DOWNLOAD', en: 'DOWNLOAD', ja: 'DOWNLOAD', zh: 'DOWNLOAD', tw: 'DOWNLOAD' },
    'dl.title': { ko: '앱 다운로드', en: 'Download App', ja: 'アプリダウンロード', zh: '下载应用', tw: '下載應用' },
    'dl.platforms': { ko: 'Android &middot; iOS &middot; Windows &middot; macOS &middot; Linux', en: 'Android &middot; iOS &middot; Windows &middot; macOS &middot; Linux', ja: 'Android &middot; iOS &middot; Windows &middot; macOS &middot; Linux', zh: 'Android &middot; iOS &middot; Windows &middot; macOS &middot; Linux', tw: 'Android &middot; iOS &middot; Windows &middot; macOS &middot; Linux' },
    'dl.android-sub': { ko: 'Google Play', en: 'Google Play', ja: 'Google Play', zh: 'Google Play', tw: 'Google Play' },

    // ── PRICING ──
    'price.label': { ko: 'PRICING', en: 'PRICING', ja: 'PRICING', zh: 'PRICING', tw: 'PRICING' },
    'price.sub': { ko: '국내 설계 · 제조로 가격 거품을 걷어냈습니다', en: 'Designed & manufactured in Korea — no price markup', ja: '韓国設計・製造でコストを削減', zh: '韩国设计·制造，去除价格泡沫', tw: '韓國設计·製造，去除價格泡沫' },
    'price.badge1': { ko: 'KC 안전 인증', en: 'KC Safety Certified', ja: 'KC安全認証', zh: 'KC安全认证', tw: 'KC安全認證' },
    'price.badge2': { ko: 'Made in Korea', en: 'Made in Korea', ja: 'Made in Korea', zh: 'Made in Korea', tw: 'Made in Korea' },
    'price.badge3': { ko: 'A/S 지원', en: 'A/S Support', ja: 'A/Sサポート', zh: '售后支持', tw: '售後支持' },
    'price.badge4': { ko: '친환경 포장', en: 'Eco-Friendly Packaging', ja: 'エコパッケージ', zh: '环保包装', tw: '環保包裝' },
    'price.won': { ko: '원', en: 'KRW', ja: 'ウォン', zh: '韩元', tw: '韓元' },
    'price.cta': { ko: '지금 구매하기', en: 'Buy Now', ja: '今すぐ購入', zh: '立即购买', tw: '立即購買' },

    // ── TRUST ──
    'trust.1.title': { ko: 'KC 안전 인증', en: 'KC Safety Certified', ja: 'KC安全認証', zh: 'KC安全认证', tw: 'KC安全認證' },
    'trust.1.desc': { ko: '국가공인시험기관(KTC) 시험을 거쳐<br>KC 안전 인증을 획득한 제품입니다', en: 'Tested by KTC (Korea Testing Certification)<br>and KC safety certified', ja: '国家公認試験機関(KTC)の試験を経て<br>KC安全認証を取得した製品です', zh: '经韩国国家认证机构(KTC)检测<br>获得KC安全认证的产品', tw: '經韓國國家認證機構(KTC)檢測<br>獲得KC安全認證的產品' },
    'trust.2.title': { ko: 'Made in Korea', en: 'Made in Korea', ja: 'Made in Korea', zh: 'Made in Korea', tw: 'Made in Korea' },
    'trust.2.desc': { ko: '설계부터 제조까지 100% 국내<br>빠른 A/S와 지속적인 업데이트', en: '100% designed & manufactured in Korea<br>Fast A/S and continuous updates', ja: '設計から製造まで100%韓国国内<br>迅速なA/Sと継続的なアップデート', zh: '从设计到制造100%韩国国内<br>快速售后和持续更新', tw: '從設计到製造100%韓國國內<br>快速售後和持續更新' },
    'trust.3.title': { ko: '오픈소스', en: 'Open Source', ja: 'オープンソース', zh: '开源', tw: '開源' },
    'trust.3.desc': { ko: '소프트웨어(Apache 2.0)와<br>하드웨어(CERN-OHL-S v2) 모두 공개', en: 'Software (Apache 2.0) and<br>Hardware (CERN-OHL-S v2) fully open', ja: 'ソフトウェア(Apache 2.0)と<br>ハードウェア(CERN-OHL-S v2)すべて公開', zh: '软件(Apache 2.0)和<br>硬件(CERN-OHL-S v2)全部公开', tw: '軟件(Apache 2.0)和<br>硬件(CERN-OHL-S v2)全部公開' },
    'trust.4.title': { ko: '친환경 포장', en: 'Eco-Friendly Packaging', ja: 'エコパッケージ', zh: '环保包装', tw: '環保包裝' },
    'trust.4.desc': { ko: '불필요한 플라스틱 없이<br>환경을 생각한 포장재 사용', en: 'No unnecessary plastic<br>Eco-conscious packaging materials', ja: '不要なプラスチックなし<br>環境を考えた包装材を使用', zh: '无多余塑料<br>使用环保包装材料', tw: '無多余塑料<br>使用環保包裝材料' },

    // ── CLOSING ──
    'closing.title': { ko: '프렌젤이 안 되는 게 아닙니다.<br><span class="gradient-text glow-text">확인할 방법</span>이 없었을 뿐.', en: 'It\'s not that you can\'t Frenzel.<br>You just had <span class="gradient-text glow-text">no way to see it</span>.', ja: 'フレンゼルができないのではありません。<br><span class="gradient-text glow-text">確認する方法</span>がなかっただけです。', zh: '不是您做不到Frenzel，<br>只是以前没有<span class="gradient-text glow-text">确认的方法</span>而已。', tw: '不是您做不到Frenzel，<br>只是以前沒有<span class="gradient-text glow-text">確認的方法</span>而已。' },
    'closing.sub': { ko: '다이브체커와 함께, 오늘부터 수심이 달라집니다.', en: 'With DiveChecker, your depth changes starting today.', ja: 'DiveCheckerと共に、今日から深度が変わります。', zh: '与DiveChecker一起，从今天开始改变深度。', tw: '與DiveChecker一起，從今天開始改變深度。' },

    // ── DEALER ──
    'dealer.badge': { ko: 'DEALER & PARTNERSHIP', en: 'DEALER & PARTNERSHIP', ja: 'DEALER & PARTNERSHIP', zh: 'DEALER & PARTNERSHIP', tw: 'DEALER & PARTNERSHIP' },
    'dealer.title': { ko: '다이브샵 대표님, 강사님께', en: 'For Dive Shop Owners & Instructors', ja: 'ダイブショップオーナー・インストラクターの皆様へ', zh: '致潜水店店主、教练', tw: '致潛水店店主、教練' },
    'dealer.desc': { ko: '다이브체커는 <strong>다이브샵</strong> 및 <strong>다이빙 강사</strong>와의 딜러 계약을 환영합니다.<br>매장에 새로운 가치를, 교육생에게 더 나은 피드백을 더하세요.', en: 'DiveChecker welcomes dealer partnerships with <strong>dive shops</strong> and <strong>diving instructors</strong>.<br>Add new value to your shop and better feedback for your students.', ja: 'DiveCheckerは<strong>ダイブショップ</strong>および<strong>ダイビングインストラクター</strong>とのディーラー契約を歓迎します。<br>店舗に新たな価値を、受講生により良いフィードバックを。', zh: 'DiveChecker欢迎与<strong>潜水店</strong>和<strong>潜水教练</strong>建立经销合作。<br>为门店增添新价值，为学员提供更好的反馈。', tw: 'DiveChecker歡迎與<strong>潛水店</strong>和<strong>潛水教練</strong>建立經銷合作。<br>為門店增添新價值，為學員提供更好的反饋。' },
    'dealer.note': { ko: '딜러 조건, 도매 가격, 교육용 특별 할인 등 자세한 내용은 이메일로 문의해 주세요.', en: 'For dealer terms, wholesale pricing, and educational discounts, please contact us via email.', ja: 'ディーラー条件、卸売価格、教育用特別割引など、詳しくはメールでお問い合わせください。', zh: '经销条件、批发价格、教育特别折扣等详情，请通过邮件联系我们。', tw: '經銷條件、批發價格、教育特別折扣等詳情，請通過郵件聯繫我們。' },

    // ── FOOTER ──
    'footer.tagline': { ko: '이퀄라이징을 눈으로 보다', en: 'See Your Equalization', ja: 'イコライジングを目で見る', zh: '用眼睛看均压', tw: '用眼睛看均壓' },
    'footer.guide': { ko: '사용 가이드', en: 'User Guide', ja: 'ユーザーガイド', zh: '使用指南', tw: '使用指南' },
    'footer.as': { ko: 'A/S 문의', en: 'A/S Support', ja: 'A/Sお問い合わせ', zh: '售后咨询', tw: '售後諮詢' },
    'disclaimer.title': { ko: '면책 고지', en: 'Disclaimer', ja: '免責事項', zh: '免责声明', tw: '免責聲明' },
    'disclaimer.sub': { ko: 'DiveChecker DC-EQ01 제품 사용에 관한 법적 고지사항', en: 'Legal notices regarding the use of DiveChecker DC-EQ01', ja: 'DiveChecker DC-EQ01の使用に関する法的告知', zh: 'DiveChecker DC-EQ01产品使用相关法律声明', tw: 'DiveChecker DC-EQ01產品使用相關法律聲明' },
    'disclaimer.effective': { ko: '시행일: 2026년 4월 7일', en: 'Effective: April 7, 2026', ja: '施行日：2026年4月7日', zh: '生效日期：2026年4月7日', tw: '生效日期：2026年4月7日' },
    'disclaimer.s1': { ko: '1. 제품의 용도 및 성격', en: '1. Purpose and Nature of the Product', ja: '1. 製品の用途および性質', zh: '1. 产品用途及性质', tw: '1. 產品用途及性質' },
    'disclaimer.s1.p1': { ko: 'DiveChecker DC-EQ01(이하 "본 제품")은 다이빙 이퀄라이징(압력 평형) 기술 향상을 위한 <strong>교육용 학습기(Learning Device)</strong>이며, 교육 및 실습 목적 외의 용도로 사용할 수 없습니다.', en: 'DiveChecker DC-EQ01 (hereinafter "this product") is an <strong>educational learning device</strong> designed to improve diving equalization (pressure equalization) techniques and shall not be used for any purpose other than education and training.', ja: 'DiveChecker DC-EQ01（以下「本製品」）は、ダイビングイコライジング（圧力平衡）技術の向上を目的とした<strong>教育用学習器（Learning Device）</strong>であり、教育および実習目的以外の用途に使用することはできません。', zh: 'DiveChecker DC-EQ01（以下简称"本产品"）是一款用于提高潜水均压（压力平衡）技术的<strong>教育用学习设备（Learning Device）</strong>，不得用于教育和实习目的以外的用途。', tw: 'DiveChecker DC-EQ01（以下簡稱「本產品」）是一款用於提高潛水均壓（壓力平衡）技術的<strong>教育用學習設備（Learning Device）</strong>，不得用於教育和實習目的以外的用途。' },
    'disclaimer.s1.warn': { ko: '<strong>본 제품은 의료기기가 아닙니다.</strong> 이관 기능 장애, 중이염, 부비동염 등 어떠한 질환의 진단·예방·치료 목적으로도 사용할 수 없으며, 대한민국 의료기기법 또는 기타 국가의 의료기기 관련 법률에 의해 허가·인증된 제품이 아닙니다.', en: '<strong>This product is not a medical device.</strong> It shall not be used for the diagnosis, prevention, or treatment of any condition, including Eustachian tube dysfunction, otitis media, sinusitis, or any other ailment. This product has not been approved or certified under the Medical Devices Act of the Republic of Korea or the medical device regulations of any other country.', ja: '<strong>本製品は医療機器ではありません。</strong>耳管機能障害、中耳炎、副鼻腔炎等いかなる疾患の診断・予防・治療の目的にも使用できず、大韓民国の医療機器法またはその他の国の医療機器関連法令により許可・認証された製品ではありません。', zh: '<strong>本产品不是医疗器械。</strong>不得用于诊断、预防或治疗咽鼓管功能障碍、中耳炎、鼻窦炎等任何疾病，且未经韩国医疗器械法或其他国家医疗器械相关法律的许可或认证。', tw: '<strong>本產品不是醫療器械。</strong>不得用於診斷、預防或治療咽鼓管功能障礙、中耳炎、鼻竇炎等任何疾病，且未經韓國醫療器械法或其他國家醫療器械相關法律的許可或認證。' },
    'disclaimer.s2': { ko: '2. 사용상 주의사항', en: '2. Precautions for Use', ja: '2. 使用上の注意事項', zh: '2. 使用注意事项', tw: '2. 使用注意事項' },
    'disclaimer.s2.l1': { ko: '<strong>통증 발생 시 즉시 중단</strong> — 사용 중 귀, 코, 두부 또는 기타 신체 부위에 통증이나 불편감이 느껴지면 즉시 사용을 중단하고, 필요 시 의료 전문가와 상담하십시오.', en: '<strong>Stop immediately if pain occurs</strong> — If you experience pain or discomfort in your ears, nose, head, or any other part of the body during use, stop immediately and consult a medical professional if necessary.', ja: '<strong>痛みが発生した場合は直ちに中止</strong> — 使用中に耳、鼻、頭部またはその他の身体部位に痛みや不快感を感じた場合は、直ちに使用を中止し、必要に応じて医療専門家にご相談ください。', zh: '<strong>出现疼痛时立即停止</strong> — 使用过程中如耳朵、鼻子、头部或其他身体部位出现疼痛或不适，请立即停止使用，必要时请咨询医疗专业人员。', tw: '<strong>出現疼痛時立即停止</strong> — 使用過程中如耳朵、鼻子、頭部或其他身體部位出現疼痛或不適，請立即停止使用，必要時請諮詢醫療專業人員。' },
    'disclaimer.s2.l2': { ko: '<strong>과도한 압력 금지</strong> — 이퀄라이징 시 과도한 힘을 가하면 고막 손상, 역압착(reverse squeeze), 부비동 손상 등 비가역적 신체 손상이 발생할 수 있습니다.', en: '<strong>Do not apply excessive pressure</strong> — Applying excessive force during equalization may cause irreversible bodily harm, including eardrum damage, reverse squeeze, and sinus barotrauma.', ja: '<strong>過度な圧力の禁止</strong> — イコライジング時に過度な力を加えると、鼓膜損傷、リバーススクイーズ、副鼻腔損傷等の不可逆的な身体損傷が発生する恐れがあります。', zh: '<strong>禁止施加过度压力</strong> — 均压时施加过大的力可能导致鼓膜损伤、反向挤压（reverse squeeze）、鼻窦损伤等不可逆的身体伤害。', tw: '<strong>禁止施加過度壓力</strong> — 均壓時施加過大的力可能導致鼓膜損傷、反向擠壓（reverse squeeze）、鼻竇損傷等不可逆的身體傷害。' },
    'disclaimer.s2.l3': { ko: '<strong>기존 질환자 주의</strong> — 이관 기능 장애, 만성 중이염, 비중격 만곡증 또는 기타 이비인후과 질환이 있는 경우 사용 전 반드시 담당 의사와 상의하십시오.', en: '<strong>Caution for persons with pre-existing conditions</strong> — If you have Eustachian tube dysfunction, chronic otitis media, deviated nasal septum, or any other otorhinolaryngological condition, you must consult your physician before use.', ja: '<strong>既往症のある方はご注意ください</strong> — 耳管機能障害、慢性中耳炎、鼻中隔弯曲症またはその他の耳鼻咽喉科疾患がある場合は、使用前に必ず担当医にご相談ください。', zh: '<strong>既有疾病患者请注意</strong> — 如患有咽鼓管功能障碍、慢性中耳炎、鼻中隔偏曲或其他耳鼻喉科疾病，使用前务必咨询主治医生。', tw: '<strong>既有疾病患者請注意</strong> — 如患有咽鼓管功能障礙、慢性中耳炎、鼻中隔偏曲或其他耳鼻喉科疾病，使用前務必諮詢主治醫生。' },
    'disclaimer.s2.l4': { ko: '<strong>어린이 사용 금지</strong> — 본 제품은 전문 교육용 기자재로, 13세 미만의 어린이가 사용하기에 적합하지 않습니다.', en: '<strong>Not for use by children</strong> — This product is professional educational equipment and is not suitable for use by children under 13 years of age.', ja: '<strong>子供の使用禁止</strong> — 本製品は専門教育用機材であり、13歳未満のお子様の使用には適していません。', zh: '<strong>禁止儿童使用</strong> — 本产品为专业教育器材，不适合13岁以下儿童使用。', tw: '<strong>禁止兒童使用</strong> — 本產品為專業教育器材，不適合13歲以下兒童使用。' },
    'disclaimer.s2.l5': { ko: '<strong>자격 있는 지도자 권장</strong> — 초보자는 자격을 갖춘 프리다이빙 강사의 지도 하에 본 제품을 사용할 것을 강력히 권장합니다.', en: '<strong>Qualified instructor recommended</strong> — Beginners are strongly recommended to use this product under the supervision of a qualified freediving instructor.', ja: '<strong>有資格の指導者の下での使用を推奨</strong> — 初心者は、資格を持つフリーダイビングインストラクターの指導の下で本製品を使用することを強くお勧めします。', zh: '<strong>建议在合格指导者指导下使用</strong> — 强烈建议初学者在具备资质的自由潜水教练指导下使用本产品。', tw: '<strong>建議在合格指導者指導下使用</strong> — 強烈建議初學者在具備資質的自由潛水教練指導下使用本產品。' },
    'disclaimer.s3': { ko: '3. 제품 취급 주의사항', en: '3. Product Handling Precautions', ja: '3. 製品取扱上の注意事項', zh: '3. 产品使用注意事项', tw: '3. 產品使用注意事項' },
    'disclaimer.s3.l1': { ko: '<strong>방수 아님</strong> — 본 제품은 방수 제품이 아닙니다. 물, 타액, 비강 분비물 등 액체가 센서 유입구에 들어가지 않도록 주의하십시오.', en: '<strong>Not waterproof</strong> — This product is not waterproof. Take care to prevent water, saliva, nasal secretions, or other liquids from entering the sensor inlet.', ja: '<strong>防水ではありません</strong> — 本製品は防水製品ではありません。水、唾液、鼻腔分泌物等の液体がセンサー流入口に入らないようご注意ください。', zh: '<strong>非防水产品</strong> — 本产品不具备防水功能。请注意防止水、唾液、鼻腔分泌物等液体进入传感器入口。', tw: '<strong>非防水產品</strong> — 本產品不具備防水功能。請注意防止水、唾液、鼻腔分泌物等液體進入傳感器入口。' },
    'disclaimer.s3.l2': { ko: '<strong>충격 방지</strong> — 떨어뜨리거나 강한 충격을 가하면 내부 센서가 손상될 수 있습니다.', en: '<strong>Avoid impact</strong> — Dropping or subjecting the product to strong impact may damage the internal sensor.', ja: '<strong>衝撃防止</strong> — 落下させたり強い衝撃を与えると、内部センサーが損傷する恐れがあります。', zh: '<strong>防止冲击</strong> — 跌落或受到强烈冲击可能导致内部传感器损坏。', tw: '<strong>防止衝擊</strong> — 跌落或受到強烈衝擊可能導致內部傳感器損壞。' },
    'disclaimer.s3.l3': { ko: '<strong>보관 환경</strong> — 직사광선, 고온(60°C 이상), 다습한 환경을 피하여 보관하십시오.', en: '<strong>Storage environment</strong> — Store away from direct sunlight, high temperatures (above 60°C), and humid conditions.', ja: '<strong>保管環境</strong> — 直射日光、高温（60°C以上）、多湿な環境を避けて保管してください。', zh: '<strong>存储环境</strong> — 请避免在阳光直射、高温（60°C以上）、潮湿的环境中存放。', tw: '<strong>存放環境</strong> — 請避免在陽光直射、高溫（60°C以上）、潮濕的環境中存放。' },
    'disclaimer.s3.l4': { ko: '<strong>분해 및 개조 금지</strong> — 제품을 분해하거나 개조하면 보증이 무효화되며, 안전상의 문제가 발생할 수 있습니다.', en: '<strong>Do not disassemble or modify</strong> — Disassembling or modifying the product will void the warranty and may result in safety hazards.', ja: '<strong>分解および改造の禁止</strong> — 製品を分解または改造すると保証が無効となり、安全上の問題が発生する恐れがあります。', zh: '<strong>禁止拆解及改装</strong> — 拆解或改装产品将导致保修失效，并可能引发安全问题。', tw: '<strong>禁止拆解及改裝</strong> — 拆解或改裝產品將導致保固失效，並可能引發安全問題。' },
    'disclaimer.s3.l5': { ko: '<strong>데이터 케이블 사용</strong> — 반드시 데이터 전송이 가능한 USB-C 케이블을 사용하십시오. 충전 전용 케이블로는 정상 동작하지 않습니다.', en: '<strong>Use a data cable</strong> — You must use a USB-C cable capable of data transfer. Charge-only cables will not allow the product to function properly.', ja: '<strong>データケーブルの使用</strong> — 必ずデータ転送対応のUSB-Cケーブルをご使用ください。充電専用ケーブルでは正常に動作しません。', zh: '<strong>请使用数据线</strong> — 必须使用支持数据传输的USB-C数据线。仅充电线缆无法正常使用。', tw: '<strong>請使用數據線</strong> — 必須使用支持數據傳輸的USB-C數據線。僅充電線纜無法正常使用。' },
    'disclaimer.s4': { ko: '4. 면책 조항', en: '4. Limitation of Liability', ja: '4. 免責条項', zh: '4. 免责条款', tw: '4. 免責條款' },
    'disclaimer.s4.p1': { ko: '크리에이테크 (Createch, 이하 "제조자")는 본 제품의 사용과 관련하여 다음 사항에 대해 책임을 지지 않습니다:', en: 'Createch (hereinafter "the manufacturer") shall not be liable for the following in connection with the use of this product:', ja: 'Createch（クリエイテク、以下「製造者」）は、本製品の使用に関して以下の事項について責任を負いません：', zh: 'Createch（크리에이테크，以下简称"制造商"）对于与本产品使用相关的以下事项不承担任何责任：', tw: 'Createch（크리에이테크，以下簡稱「製造商」）對於與本產品使用相關的以下事項不承擔任何責任：' },
    'disclaimer.s4.l1': { ko: '본 제품의 <strong>오용, 부주의, 또는 부적절한 사용</strong>으로 인해 발생하는 어떠한 부상, 건강 상의 문제 또는 재산상의 손해', en: 'Any injury, health issue, or property damage arising from <strong>misuse, negligence, or improper use</strong> of this product', ja: '本製品の<strong>誤用、不注意、または不適切な使用</strong>により発生するいかなる傷害、健康上の問題または財産上の損害', zh: '因<strong>误用、疏忽或不当使用</strong>本产品而导致的任何伤害、健康问题或财产损失', tw: '因<strong>誤用、疏忽或不當使用</strong>本產品而導致的任何傷害、健康問題或財產損失' },
    'disclaimer.s4.l2': { ko: '사용자가 본 면책 고지에 명시된 <strong>주의사항을 준수하지 않아</strong> 발생하는 모든 손해', en: 'All damages arising from the user\'s <strong>failure to comply with the precautions</strong> specified in this disclaimer', ja: '使用者が本免責事項に明記された<strong>注意事項を遵守しなかった</strong>ことにより発生するすべての損害', zh: '因用户<strong>未遵守</strong>本免责声明中规定的注意事项而造成的一切损害', tw: '因用戶<strong>未遵守</strong>本免責聲明中規定的注意事項而造成的一切損害' },
    'disclaimer.s4.l3': { ko: '<strong>비인가 수리, 개조, 분해</strong>로 인해 발생하는 제품 손상 또는 신체 손해', en: 'Product damage or bodily harm resulting from <strong>unauthorized repair, modification, or disassembly</strong>', ja: '<strong>非認可の修理、改造、分解</strong>により発生する製品損傷または身体損害', zh: '因<strong>未经授权的维修、改装、拆解</strong>而导致的产品损坏或人身伤害', tw: '因<strong>未經授權的維修、改裝、拆解</strong>而導致的產品損壞或人身傷害' },
    'disclaimer.s4.l4': { ko: '본 제품을 <strong>의료적 목적</strong>으로 사용하여 발생하는 모든 결과', en: 'All consequences arising from the use of this product for <strong>medical purposes</strong>', ja: '本製品を<strong>医療目的</strong>で使用して発生するすべての結果', zh: '将本产品用于<strong>医疗目的</strong>而产生的一切后果', tw: '將本產品用於<strong>醫療目的</strong>而產生的一切後果' },
    'disclaimer.s4.l5': { ko: '다이빙, 수중 활동 또는 이퀄라이징 훈련 중 발생하는 <strong>사고, 부상 또는 사망</strong>', en: '<strong>Accidents, injuries, or death</strong> occurring during diving, underwater activities, or equalization training', ja: 'ダイビング、水中活動またはイコライジング訓練中に発生する<strong>事故、傷害または死亡</strong>', zh: '在潜水、水下活动或均压训练中发生的<strong>事故、伤害或死亡</strong>', tw: '在潛水、水下活動或均壓訓練中發生的<strong>事故、傷害或死亡</strong>' },
    'disclaimer.s4.warn': { ko: '본 제품은 실제 다이빙 환경에서의 안전을 보장하지 않습니다. 본 제품으로 학습한 이퀄라이징 기법은 반드시 <strong>자격을 갖춘 강사의 지도 하에 수중에서 검증</strong>되어야 합니다.', en: 'This product does not guarantee safety in actual diving environments. Equalization techniques learned with this product must be <strong>verified underwater under the supervision of a qualified instructor</strong>.', ja: '本製品は実際のダイビング環境での安全を保証するものではありません。本製品で学んだイコライジング技法は、必ず<strong>有資格のインストラクターの指導の下、水中で検証</strong>されなければなりません。', zh: '本产品不保证在实际潜水环境中的安全性。使用本产品学习的均压技术必须在<strong>合格教练的指导下在水中进行验证</strong>。', tw: '本產品不保證在實際潛水環境中的安全性。使用本產品學習的均壓技術必須在<strong>合格教練的指導下在水中進行驗證</strong>。' },
    'disclaimer.s5': { ko: '5. 측정 데이터에 관한 고지', en: '5. Notice Regarding Measurement Data', ja: '5. 測定データに関する告知', zh: '5. 关于测量数据的告知', tw: '5. 關於測量數據的告知' },
    'disclaimer.s5.p1': { ko: '본 제품이 제공하는 압력 데이터, 피크 분석, 등급 평가 등의 정보는 <strong>교육적 참고 자료</strong>이며, 의학적 또는 전문적 판단의 근거로 사용할 수 없습니다. 센서 특성, 환경 조건, 사용자의 사용 방법에 따라 측정값에 오차가 발생할 수 있습니다.', en: 'Information provided by this product, including pressure data, peak analysis, and grade evaluations, is for <strong>educational reference only</strong> and shall not be used as a basis for medical or professional judgment. Measurement values may vary depending on sensor characteristics, environmental conditions, and user operation.', ja: '本製品が提供する圧力データ、ピーク分析、等級評価等の情報は<strong>教育的参考資料</strong>であり、医学的または専門的判断の根拠として使用することはできません。センサー特性、環境条件、使用者の使用方法により測定値に誤差が生じる場合があります。', zh: '本产品提供的压力数据、峰值分析、等级评估等信息仅为<strong>教育参考资料</strong>，不得作为医学或专业判断的依据。由于传感器特性、环境条件及用户使用方法的差异，测量值可能存在误差。', tw: '本產品提供的壓力數據、峰值分析、等級評估等資訊僅為<strong>教育參考資料</strong>，不得作為醫學或專業判斷的依據。由於傳感器特性、環境條件及用戶使用方法的差異，測量值可能存在誤差。' },
    'disclaimer.s6': { ko: '6. 제조 품질 안내', en: '6. Manufacturing Quality Notice', ja: '6. 製造品質に関するご案内', zh: '6. 制造质量说明', tw: '6. 製造品質說明' },
    'disclaimer.s6.l1': { ko: '제조 과정에서 발생하는 <strong>미세한 스크래치나 표면 질감의 차이</strong>는 제품 불량이 아닌 공정 특성입니다.', en: '<strong>Minor scratches or variations in surface texture</strong> that occur during the manufacturing process are characteristics of the production process, not product defects.', ja: '製造過程で発生する<strong>微細な傷や表面質感の差異</strong>は製品不良ではなく、工程上の特性です。', zh: '制造过程中产生的<strong>细微划痕或表面质感差异</strong>属于工艺特性，并非产品缺陷。', tw: '製造過程中產生的<strong>細微刮痕或表面質感差異</strong>屬於工藝特性，並非產品缺陷。' },
    'disclaimer.s6.l2': { ko: '외관에 미세한 표면 차이가 있을 수 있으며, 이는 제품의 기능 및 성능에 영향을 주지 않습니다.', en: 'There may be minor surface differences in appearance, which do not affect the product\'s functionality or performance.', ja: '外観に微細な表面の差異がある場合がありますが、製品の機能および性能には影響しません。', zh: '外观可能存在细微的表面差异，但不影响产品的功能和性能。', tw: '外觀可能存在細微的表面差異，但不影響產品的功能和性能。' },
    'disclaimer.s6.l3': { ko: '제조 특성상 개체 간 미세한 외관 차이가 있을 수 있습니다.', en: 'Due to the nature of the manufacturing process, there may be minor cosmetic differences between individual units.', ja: '製造特性上、個体間に微細な外観の差異がある場合があります。', zh: '由于制造特性，个体之间可能存在细微的外观差异。', tw: '由於製造特性，個體之間可能存在細微的外觀差異。' },
    'disclaimer.s6.l4': { ko: '상기 사유로 인한 교환·반품은 불가합니다.', en: 'Exchanges or returns for the reasons stated above are not accepted.', ja: '上記の理由による交換・返品はお受けできません。', zh: '因上述原因不予换货或退货。', tw: '因上述原因不予換貨或退貨。' },
    'disclaimer.s7': { ko: '7. 보증 범위', en: '7. Warranty Coverage', ja: '7. 保証範囲', zh: '7. 保修范围', tw: '7. 保固範圍' },
    'disclaimer.s7.p1': { ko: '무상 A/S는 구매일로부터 <strong>1개월 이내</strong>, 제품 자체 결함에 한합니다. 구매 영수증 등 구매 증빙을 첨부하여 이메일로 신청해 주십시오.', en: 'Complimentary after-sales service is limited to product defects within <strong>one (1) month</strong> from the date of purchase. Please submit your request via email with proof of purchase, such as a receipt.', ja: '無償アフターサービスはご購入日から<strong>1ヶ月以内</strong>、製品自体の欠陥に限ります。購入レシート等の購入証明を添付の上、メールにてお申し込みください。', zh: '免费售后服务仅限于购买之日起<strong>1个月内</strong>的产品自身缺陷。请附上购买收据等购买凭证，通过电子邮件提交申请。', tw: '免費售後服務僅限於購買之日起<strong>1個月內</strong>的產品自身缺陷。請附上購買收據等購買憑證，透過電子郵件提交申請。' },
    'disclaimer.s7.ex-title': { ko: '보증 제외 사항', en: 'Warranty Exclusions', ja: '保証除外事項', zh: '保修除外事项', tw: '保固除外事項' },
    'disclaimer.s7.ex1': { ko: '침수 또는 이물질(타액, 비강 분비물 포함) 유입으로 인한 고장', en: 'Malfunction caused by submersion in water or ingress of foreign substances (including saliva and nasal secretions)', ja: '浸水または異物（唾液、鼻腔分泌物を含む）の侵入による故障', zh: '因浸水或异物（包括唾液、鼻腔分泌物）进入而导致的故障', tw: '因浸水或異物（包括唾液、鼻腔分泌物）進入而導致的故障' },
    'disclaimer.s7.ex2': { ko: '사용자 과실에 의한 파손, 변형, 낙하 손상', en: 'Breakage, deformation, or drop damage caused by user negligence', ja: '使用者の過失による破損、変形、落下損傷', zh: '因用户过失造成的破损、变形、跌落损坏', tw: '因用戶過失造成的破損、變形、跌落損壞' },
    'disclaimer.s7.ex3': { ko: '비인가 분해, 개조, 수리로 인한 고장', en: 'Malfunction caused by unauthorized disassembly, modification, or repair', ja: '非認可の分解、改造、修理による故障', zh: '因未经授权的拆解、改装、维修而导致的故障', tw: '因未經授權的拆解、改裝、維修而導致的故障' },
    'disclaimer.s7.ex4': { ko: '정상적인 마모 및 경년 열화', en: 'Normal wear and tear and age-related deterioration', ja: '通常の摩耗および経年劣化', zh: '正常磨损及老化', tw: '正常磨損及老化' },
    'disclaimer.s7.ex5': { ko: '천재지변, 화재 등 외부 요인에 의한 손상', en: 'Damage caused by external factors such as natural disasters or fire', ja: '天災、火災等の外部要因による損傷', zh: '因自然灾害、火灾等外部因素造成的损坏', tw: '因自然災害、火災等外部因素造成的損壞' },
    'disclaimer.s7.contact': { ko: 'A/S 문의: <strong>cs-divechecker@createch.kr</strong>', en: 'After-sales inquiries: <strong>cs-divechecker@createch.kr</strong>', ja: 'アフターサービスお問い合わせ：<strong>cs-divechecker@createch.kr</strong>', zh: '售后咨询：<strong>cs-divechecker@createch.kr</strong>', tw: '售後諮詢：<strong>cs-divechecker@createch.kr</strong>' },
    'disclaimer.s8': { ko: '8. 규격 및 인증 정보', en: '8. Specifications and Certification Information', ja: '8. 規格および認証情報', zh: '8. 规格及认证信息', tw: '8. 規格及認證資訊' },
    'disclaimer.s8.p1': { ko: '기자재명칭: 디지털 압력 감지 학습기 · 모델명: DC-EQ01 · 기기부호: DCPM · 입력 전원: DC 5V (USB-C) · 인증: KC 적합등록 (등록번호: R-R-DCQ-DC, 등록일: 2026-03-24) · 제조국: 대한민국 · 제조사: 크리에이테크 (Createch)', en: 'Equipment Name: Digital Pressure Sensing Learning Device · Model: DC-EQ01 · Equipment Code: DCPM · Input Power: DC 5V (USB-C) · Certification: KC Conformity Registration (Registration No.: R-R-DCQ-DC, Registration Date: 2026-03-24) · Country of Manufacture: Republic of Korea · Manufacturer: Createch', ja: '機器名称：デジタル圧力検知学習器 · モデル名：DC-EQ01 · 機器符号：DCPM · 入力電源：DC 5V（USB-C） · 認証：KC適合登録（登録番号：R-R-DCQ-DC、登録日：2026-03-24） · 製造国：大韓民国 · 製造者：クリエイテク（Createch）', zh: '设备名称：数字压力感应学习器 · 型号：DC-EQ01 · 设备代码：DCPM · 输入电源：DC 5V（USB-C） · 认证：KC合规注册（注册号：R-R-DCQ-DC，注册日期：2026-03-24） · 制造国：大韩民国 · 制造商：Createch（크리에이테크）', tw: '設備名稱：數位壓力感應學習器 · 型號：DC-EQ01 · 設備代碼：DCPM · 輸入電源：DC 5V（USB-C） · 認證：KC合規註冊（註冊號：R-R-DCQ-DC，註冊日期：2026-03-24） · 製造國：大韓民國 · 製造商：Createch（크리에이테크）' },
    'disclaimer.s9': { ko: '9. 준거법 및 관할', en: '9. Governing Law and Jurisdiction', ja: '9. 準拠法および管轄', zh: '9. 准据法及管辖', tw: '9. 準據法及管轄' },
    'disclaimer.s9.p1': { ko: '본 면책 고지는 대한민국 법률에 따라 해석되며, 본 제품과 관련된 모든 분쟁은 제조자의 소재지를 관할하는 법원을 전속적 관할 법원으로 합니다.', en: 'This disclaimer shall be construed in accordance with the laws of the Republic of Korea. All disputes arising in connection with this product shall be subject to the exclusive jurisdiction of the court having jurisdiction over the manufacturer\'s place of business.', ja: '本免責事項は大韓民国の法律に従って解釈され、本製品に関連するすべての紛争は、製造者の所在地を管轄する裁判所を専属的管轄裁判所とします。', zh: '本免责声明依据大韩民国法律进行解释。与本产品相关的所有争议，以制造商所在地有管辖权的法院为专属管辖法院。', tw: '本免責聲明依據大韓民國法律進行解釋。與本產品相關的所有爭議，以製造商所在地有管轄權的法院為專屬管轄法院。' },
    'footer.disclaimer-link': { ko: '면책 고지', en: 'Disclaimer', ja: '免責事項', zh: '免责声明', tw: '免責聲明' },
    'footer.privacy': { ko: '개인정보처리방침', en: 'Privacy Policy', ja: 'プライバシーポリシー', zh: '隐私政策', tw: '隱私政策' },
    'footer.disclaimer': { ko: '본 제품은 다이빙 이퀄라이징 기술 향상을 위한 교육용 학습기(Learning Device)이며, 의료기기가 아닙니다. 이관 기능 장애, 중이염 등 질환의 진단·예방·치료 목적으로 사용할 수 없습니다. 사용 중 귀 또는 코에 통증이 느껴지면 즉시 사용을 중단하십시오. 본 제품의 오용·부주의 또는 부적절한 사용으로 인해 발생하는 어떠한 부상·손해에 대해서도 제조자는 책임을 지지 않습니다.', en: 'This product is an educational learning device for improving diving equalization technique and is not a medical device. It cannot be used for diagnosis, prevention, or treatment of conditions such as Eustachian tube dysfunction or otitis media. If you feel pain in your ears or nose during use, stop immediately. The manufacturer is not liable for any injury or damage resulting from misuse, negligence, or improper use of this product.', ja: '本製品はダイビングイコライジング技術向上のための教育用学習器であり、医療機器ではありません。耳管機能障害、中耳炎等の疾患の診断・予防・治療目的に使用できません。使用中に耳や鼻に痛みを感じた場合は直ちに使用を中止してください。本製品の誤用・不注意または不適切な使用により発生するいかなる傷害・損害についても製造者は責任を負いません。', zh: '本产品是用于提高潜水均压技术的教育用学习设备，非医疗器械。不能用于诊断、预防或治疗咽鼓管功能障碍、中耳炎等疾病。使用中如耳朵或鼻子感到疼痛，请立即停止使用。因误用、疏忽或不当使用本产品而导致的任何伤害或损失，制造商概不负责。', tw: '本產品是用於提高潛水均壓技術的教育用學習設備，非醫療器械。不能用於診斷、預防或治療咽鼓管功能障礙、中耳炎等疾病。使用中如耳朵或鼻子感到疼痛，請立即停止使用。因誤用、疏忽或不當使用本產品而導致的任何傷害或損失，製造商概不負責。' },
    'footer.trademarks': { ko: 'DiveChecker 및 DiveChecker 로고는 크리에이테크 (Createch)의 상표입니다. Google Play, Android, Flutter는 Google LLC의 상표입니다. Apple, App Store, iOS, iPhone, iPad, macOS는 Apple Inc.의 상표입니다. Windows는 Microsoft Corporation의 등록 상표입니다. Bluetooth는 Bluetooth SIG, Inc.의 등록 상표입니다. USB, USB-C는 USB Implementers Forum의 상표입니다. Linux는 Linus Torvalds의 등록 상표입니다. GitHub는 GitHub, Inc.의 상표입니다.', en: 'DiveChecker and the DiveChecker logo are trademarks of Createch. Google Play, Android, and Flutter are trademarks of Google LLC. Apple, App Store, iOS, iPhone, iPad, and macOS are trademarks of Apple Inc. Windows is a registered trademark of Microsoft Corporation. Bluetooth is a registered trademark of Bluetooth SIG, Inc. USB and USB-C are trademarks of USB Implementers Forum. Linux is a registered trademark of Linus Torvalds. GitHub is a trademark of GitHub, Inc.', ja: 'DiveCheckerおよびDiveCheckerロゴは、Createchの商標です。Google Play、Android、FlutterはGoogle LLCの商標です。Apple、App Store、iOS、iPhone、iPad、macOSはApple Inc.の商標です。WindowsはMicrosoft Corporationの登録商標です。BluetoothはBluetooth SIG, Inc.の登録商標です。USB、USB-CはUSB Implementers Forumの商標です。LinuxはLinus Torvaldsの登録商標です。GitHubはGitHub, Inc.の商標です。', zh: 'DiveChecker及DiveChecker标志是Createch的商标。Google Play、Android、Flutter是Google LLC的商标。Apple、App Store、iOS、iPhone、iPad、macOS是Apple Inc.的商标。Windows是Microsoft Corporation的注册商标。Bluetooth是Bluetooth SIG, Inc.的注册商标。USB、USB-C是USB Implementers Forum的商标。Linux是Linus Torvalds的注册商标。GitHub是GitHub, Inc.的商标。', tw: 'DiveChecker及DiveChecker標誌是Createch的商標。Google Play、Android、Flutter是Google LLC的商標。Apple、App Store、iOS、iPhone、iPad、macOS是Apple Inc.的商標。Windows是Microsoft Corporation的註冊商標。Bluetooth是Bluetooth SIG, Inc.的註冊商標。USB、USB-C是USB Implementers Forum的商標。Linux是Linus Torvalds的註冊商標。GitHub是GitHub, Inc.的商標。' },

    // ═══ GUIDE PAGE ═══
    'guide.page-title': { ko: '사용 가이드', en: 'User Guide', ja: 'ユーザーガイド', zh: '使用指南', tw: '使用指南' },
    'guide.page-desc': { ko: 'DiveChecker를 처음 사용하시나요?<br>설치부터 실시간 측정까지, 단계별로 안내합니다.', en: 'New to DiveChecker?<br>We\'ll guide you step by step, from setup to real-time measurement.', ja: 'DiveCheckerを初めてお使いですか？<br>セットアップからリアルタイム測定まで、ステップごとにご案内します。', zh: '第一次使用DiveChecker？<br>从安装到实时测量，我们将逐步为您指导。', tw: '第一次使用DiveChecker？<br>從安裝到即時測量，我們將逐步為您指導。' },
    'guide.toc-title': { ko: '목차', en: 'Table of Contents', ja: '目次', zh: '目录', tw: '目錄' },
    'guide.toc1': { ko: '개봉 및 구성품 확인', en: 'Unboxing & Package Contents', ja: '開封・同梱品の確認', zh: '开箱及配件确认', tw: '開箱及配件確認' },
    'guide.toc2': { ko: '디바이스 연결', en: 'Device Connection', ja: 'デバイス接続', zh: '设备连接', tw: '設備連接' },
    'guide.toc3': { ko: '앱 설치', en: 'App Installation', ja: 'アプリのインストール', zh: '安装应用', tw: '安裝應用' },
    'guide.toc4': { ko: '첫 번째 측정', en: 'First Measurement', ja: '初めての測定', zh: '首次测量', tw: '首次測量' },
    'guide.toc5': { ko: '캘리브레이션', en: 'Calibration', ja: 'キャリブレーション', zh: '校准', tw: '校準' },
    'guide.toc6': { ko: '실시간 측정 & 기록', en: 'Real-time Measurement & Recording', ja: 'リアルタイム測定 & 記録', zh: '实时测量与记录', tw: '即時測量與記錄' },
    'guide.toc7': { ko: '피크 분석 읽는 법', en: 'Reading Peak Analysis', ja: 'ピーク分析の読み方', zh: '如何阅读峰值分析', tw: '如何閱讀峰值分析' },
    'guide.toc8': { ko: '기법별 연습 팁', en: 'Technique Practice Tips', ja: '技法別練習のコツ', zh: '各技法练习技巧', tw: '各技法練習技巧' },
    'guide.toc9': { ko: '펌웨어 업데이트', en: 'Firmware Update', ja: 'ファームウェアアップデート', zh: '固件更新', tw: '韌體更新' },
    'guide.toc10': { ko: '문제 해결', en: 'Troubleshooting', ja: 'トラブルシューティング', zh: '故障排除', tw: '故障排除' },
    'guide.s01': { ko: '개봉 및 구성품 확인', en: 'Unboxing & Package Contents', ja: '開封・同梱品の確認', zh: '开箱及配件确认', tw: '開箱及配件確認' },
    'guide.s01.intro': { ko: '패키지를 개봉하면 아래 구성품이 들어있습니다.', en: 'Your package includes the following items.', ja: 'パッケージを開封すると、以下の同梱品が入っています。', zh: '打开包装后，内含以下配件。', tw: '打開包裝後，內含以下配件。' },
    'guide.s01.item1': { ko: '다이브체커 본체 (DC-EQ01)', en: 'DiveChecker Unit (DC-EQ01)', ja: 'DiveChecker本体 (DC-EQ01)', zh: 'DiveChecker主机 (DC-EQ01)', tw: 'DiveChecker主機 (DC-EQ01)' },
    'guide.s01.item1-desc': { ko: '압력 센서가 내장된 메인 디바이스', en: 'Main device with built-in pressure sensor', ja: '圧力センサー内蔵のメインデバイス', zh: '内置压力传感器的主设备', tw: '內建壓力感測器的主設備' },
    'guide.s01.item2': { ko: 'USB-C 데이터 케이블', en: 'USB-C Data Cable', ja: 'USB-Cデータケーブル', zh: 'USB-C数据线', tw: 'USB-C數據線' },
    'guide.s01.item2-desc': { ko: '전원 공급 + 데이터 전송 겸용 (충전 전용 케이블은 사용 불가)', en: 'Power + data combined (charge-only cables will not work)', ja: '電源供給+データ転送兼用（充電専用ケーブルは使用不可）', zh: '供电+数据传输两用（充电专用线不可使用）', tw: '供電+數據傳輸兩用（充電專用線不可使用）' },
    'guide.s01.item3': { ko: '사용 설명서', en: 'User Manual', ja: '取扱説明書', zh: '使用说明书', tw: '使用說明書' },
    'guide.s01.item3-desc': { ko: '퀵 스타트 가이드 및 QR코드', en: 'Quick start guide and QR code', ja: 'クイックスタートガイドおよびQRコード', zh: '快速入门指南及QR码', tw: '快速入門指南及QR碼' },
    'guide.s01.warning': { ko: '<strong>충전 전용 케이블</strong>로는 데이터 전송이 되지 않습니다. 반드시 동봉된 케이블 또는 데이터 전송 가능한 USB-C 케이블을 사용하세요.', en: '<strong>Charge-only cables</strong> cannot transfer data. Always use the included cable or a USB-C cable that supports data transfer.', ja: '<strong>充電専用ケーブル</strong>ではデータ転送ができません。必ず同梱のケーブルまたはデータ転送対応のUSB-Cケーブルをご使用ください。', zh: '<strong>充电专用线</strong>无法传输数据。请务必使用附带的数据线或支持数据传输的USB-C数据线。', tw: '<strong>充電專用線</strong>無法傳輸數據。請務必使用附帶的數據線或支持數據傳輸的USB-C數據線。' },
    'guide.s02': { ko: '디바이스 연결', en: 'Device Connection', ja: 'デバイス接続', zh: '设备连接', tw: '設備連接' },
    'guide.s02.intro': { ko: 'USB-C 케이블로 DiveChecker와 기기를 연결합니다.', en: 'Connect DiveChecker to your device with a USB-C cable.', ja: 'USB-CケーブルでDiveCheckerとデバイスを接続します。', zh: '使用USB-C数据线将DiveChecker与设备连接。', tw: '使用USB-C數據線將DiveChecker與設備連接。' },
    'guide.s02.1-title': { ko: 'USB-C 케이블 연결', en: 'USB-C Cable Connection', ja: 'USB-Cケーブル接続', zh: 'USB-C数据线连接', tw: 'USB-C數據線連接' },
    'guide.s02.1-desc': { ko: '동봉된 케이블의 한쪽을 DiveChecker 본체에, 다른 한쪽을 PC/스마트폰에 연결합니다.', en: 'Connect one end of the included cable to DiveChecker and the other to your PC/smartphone.', ja: '同梱ケーブルの片方をDiveChecker本体に、もう片方をPC/スマートフォンに接続します。', zh: '将附带数据线的一端连接到DiveChecker主机，另一端连接到PC/智能手机。', tw: '將附帶數據線的一端連接到DiveChecker主機，另一端連接到PC/智慧手機。' },
    'guide.s02.2-title': { ko: 'LED 확인', en: 'Check LED', ja: 'LED確認', zh: '确认LED', tw: '確認LED' },
    'guide.s02.2-desc': { ko: '전원이 연결되면 본체의 LED가 점등됩니다. LED가 켜지지 않는다면 케이블이나 포트를 확인하세요.', en: 'The LED lights up when powered. If the LED doesn\'t turn on, check the cable or port.', ja: '電源が接続されると本体のLEDが点灯します。LEDが点灯しない場合はケーブルやポートをご確認ください。', zh: '电源连接后主机LED会亮起。如果LED未亮，请检查数据线或端口。', tw: '電源連接後主機LED會亮起。如果LED未亮，請檢查數據線或端口。' },
    'guide.s02.3-title': { ko: 'Android OTG', en: 'Android OTG', ja: 'Android OTG', zh: 'Android OTG', tw: 'Android OTG' },
    'guide.s02.3-desc': { ko: '스마트폰 연결 시 USB OTG를 지원하는 기기여야 합니다. 대부분의 최신 Android 폰은 지원합니다.', en: 'Your smartphone must support USB OTG. Most modern Android phones support it.', ja: 'スマートフォン接続時はUSB OTG対応機器が必要です。最新のAndroidスマートフォンのほとんどが対応しています。', zh: '连接智能手机时，设备必须支持USB OTG。大多数新款Android手机均支持。', tw: '連接智慧手機時，設備必須支持USB OTG。大多數新款Android手機均支持。' },
    'guide.s02.win': { ko: 'USB 포트에 바로 연결. 별도 드라이버 불필요.', en: 'Direct USB connection. No driver needed.', ja: 'USBポートに直接接続。ドライバー不要。', zh: '直接连接USB端口，无需驱动程序。', tw: '直接連接USB端口，無需驅動程式。' },
    'guide.s02.android': { ko: 'USB-C OTG 또는 USB-C to C 케이블 사용.', en: 'Use USB-C OTG or USB-C to C cable.', ja: 'USB-C OTGまたはUSB-C to Cケーブルを使用。', zh: '使用USB-C OTG或USB-C to C数据线。', tw: '使用USB-C OTG或USB-C to C數據線。' },
    'guide.s02.ios': { ko: 'USB-C iPhone 15 이상 및 USB-C iPad에서 바로 사용 가능. Lightning 기기는 별도 변환잭 필요 (옵션 구매 가능).', en: 'Works directly with USB-C iPhone 15+ and USB-C iPad. Lightning devices require a separate adapter (available as option).', ja: 'USB-C iPhone 15以降およびUSB-C iPadで直接使用可能。Lightning機器は別途変換アダプターが必要です（オプション購入可能）。', zh: 'USB-C iPhone 15及以上和USB-C iPad可直接使用。Lightning设备需要另购转接头（可选购）。', tw: 'USB-C iPhone 15及以上和USB-C iPad可直接使用。Lightning設備需要另購轉接頭（可選購）。' },
    'guide.s03': { ko: '앱 설치', en: 'App Installation', ja: 'アプリのインストール', zh: '安装应用', tw: '安裝應用' },
    'guide.s03.intro': { ko: '사용 설명서에 포함된 QR코드를 스캔하거나, 아래에서 플랫폼에 맞는 앱을 다운로드하세요.', en: 'Scan the QR code in the manual, or download the app for your platform below.', ja: '取扱説明書のQRコードをスキャンするか、以下からお使いのプラットフォーム向けアプリをダウンロードしてください。', zh: '扫描说明书中的QR码，或在下方下载适合您平台的应用。', tw: '掃描說明書中的QR碼，或在下方下載適合您平台的應用。' },
    'guide.s03.tip': { ko: '<strong>Google Play</strong>와 <strong>App Store</strong>에서 다운로드할 수 있습니다. Windows, macOS, Linux용은 GitHub Releases에서 설치 가능합니다.', en: 'Available on <strong>Google Play</strong> and <strong>App Store</strong>. Windows, macOS, and Linux versions available from GitHub Releases.', ja: '<strong>Google Play</strong>と<strong>App Store</strong>からダウンロードできます。Windows、macOS、Linux版はGitHub Releasesからインストール可能です。', zh: '可从<strong>Google Play</strong>和<strong>App Store</strong>下载。Windows、macOS、Linux版可从GitHub Releases安装。', tw: '可從<strong>Google Play</strong>和<strong>App Store</strong>下載。Windows、macOS、Linux版可從GitHub Releases安裝。' },
    'guide.s04': { ko: '첫 번째 측정', en: 'First Measurement', ja: '初めての測定', zh: '首次测量', tw: '首次測量' },
    'guide.s04.1-title': { ko: '앱 실행 & 디바이스 연결', en: 'Launch App & Connect Device', ja: 'アプリ起動 & デバイス接続', zh: '启动应用 & 连接设备', tw: '啟動應用 & 連接設備' },
    'guide.s04.1-desc': { ko: '앱 홈 화면에서 <strong>"디바이스 연결"</strong> 버튼을 탭합니다. 목록에 DiveChecker가 나타나면 선택하세요.', en: 'Tap <strong>"Connect Device"</strong> on the home screen. Select DiveChecker when it appears in the list.', ja: 'アプリのホーム画面で<strong>「デバイス接続」</strong>ボタンをタップします。リストにDiveCheckerが表示されたら選択してください。', zh: '在应用主页点击<strong>"连接设备"</strong>按钮。列表中出现DiveChecker后选择它。', tw: '在應用主頁點擊<strong>"連接設備"</strong>按鈕。列表中出現DiveChecker後選擇它。' },
    'guide.s04.2-title': { ko: '인증 확인', en: 'Authentication Check', ja: '認証確認', zh: '认证确认', tw: '認證確認' },
    'guide.s04.2-desc': { ko: '정품 인증(ECDSA)이 자동으로 진행됩니다. 인증이 완료되면 연결 상태가 녹색으로 표시됩니다.', en: 'Authenticity verification (ECDSA) runs automatically. The connection status turns green when verified.', ja: '正規品認証（ECDSA）が自動で行われます。認証が完了すると接続状態が緑色に表示されます。', zh: '正品认证（ECDSA）将自动进行。认证完成后连接状态会显示为绿色。', tw: '正品認證（ECDSA）將自動進行。認證完成後連接狀態會顯示為綠色。' },
    'guide.s04.3-title': { ko: '캘리브레이션', en: 'Calibration', ja: 'キャリブレーション', zh: '校准', tw: '校準' },
    'guide.s04.3-desc': { ko: '<strong>"캘리브레이션"</strong> 버튼을 눌러 현재 대기압을 기준점으로 설정합니다. 센서에 입/코를 대지 않은 상태에서 진행하세요.', en: 'Press <strong>"Calibrate"</strong> to set the current atmospheric pressure as baseline. Keep your mouth/nose away from the sensor.', ja: '<strong>「キャリブレーション」</strong>ボタンを押して、現在の大気圧を基準点に設定します。センサーに口/鼻を当てていない状態で行ってください。', zh: '按下<strong>"校准"</strong>按钮，将当前大气压设为基准点。请在传感器上没有口/鼻接触的状态下进行。', tw: '按下<strong>"校準"</strong>按鈕，將當前大氣壓設為基準點。請在感測器上沒有口/鼻接觸的狀態下進行。' },
    'guide.s04.4-title': { ko: '측정 시작', en: 'Start Measuring', ja: '測定開始', zh: '开始测量', tw: '開始測量' },
    'guide.s04.4-desc': { ko: '측정 탭에서 <strong>"시작"</strong>을 누르고, 센서에 코를 대고 이퀄라이징을 시작하세요. 그래프가 실시간으로 나타납니다!', en: 'Press <strong>"Start"</strong> in the measurement tab, place the sensor on your nose and begin equalizing. The graph appears in real time!', ja: '測定タブで<strong>「開始」</strong>を押し、センサーに鼻を当ててイコライジングを始めてください。グラフがリアルタイムで表示されます！', zh: '在测量页面按下<strong>"开始"</strong>，将传感器贴在鼻子上开始均压。图表会实时显示！', tw: '在測量頁面按下<strong>"開始"</strong>，將感測器貼在鼻子上開始均壓。圖表會即時顯示！' },
    'guide.s05': { ko: '캘리브레이션', en: 'Calibration', ja: 'キャリブレーション', zh: '校准', tw: '校準' },
    'guide.s05.intro': { ko: '캘리브레이션은 현재 대기압을 0 hPa 기준으로 설정하는 과정입니다. 정확한 측정을 위해 <strong>매 세션 시작 전</strong> 권장합니다.', en: 'Calibration sets the current atmospheric pressure as the 0 hPa baseline. Recommended <strong>before each session</strong> for accurate measurement.', ja: 'キャリブレーションは現在の大気圧を0 hPa基準に設定する過程です。正確な測定のため<strong>毎セッション開始前</strong>に行うことを推奨します。', zh: '校准是将当前大气压设置为0 hPa基准的过程。为确保测量准确，建议<strong>每次训练前</strong>执行。', tw: '校準是將當前大氣壓設置為0 hPa基準的過程。為確保測量準確，建議<strong>每次訓練前</strong>執行。' },
    'guide.s05.callout-title': { ko: '캘리브레이션 과정', en: 'Calibration Process', ja: 'キャリブレーション手順', zh: '校准过程', tw: '校準過程' },
    'guide.s05.step1': { ko: '센서에서 입/코를 떼고 자연 상태로 둡니다', en: 'Remove mouth/nose from sensor and leave in natural state', ja: 'センサーから口/鼻を離し、自然な状態にします', zh: '将口/鼻从传感器移开，保持自然状态', tw: '將口/鼻從感測器移開，保持自然狀態' },
    'guide.s05.step2': { ko: '앱에서 "캘리브레이션" 버튼을 탭합니다', en: 'Tap "Calibrate" button in the app', ja: 'アプリで「キャリブレーション」ボタンをタップします', zh: '在应用中点击"校准"按钮', tw: '在應用中點擊"校準"按鈕' },
    'guide.s05.step3': { ko: '3초간 대기압 샘플을 수집합니다', en: 'Collects atmospheric pressure samples for 3 seconds', ja: '3秒間、大気圧サンプルを収集します', zh: '收集3秒的大气压样本', tw: '收集3秒的大氣壓樣本' },
    'guide.s05.step4': { ko: '평균값이 자동으로 기준점(baseline)으로 설정됩니다', en: 'Average value is automatically set as the baseline', ja: '平均値が自動的に基準点（ベースライン）として設定されます', zh: '平均值将自动设置为基准点（baseline）', tw: '平均值將自動設置為基準點（baseline）' },
    'guide.s05.tip': { ko: '고도가 변하거나 장소를 이동한 후에는 반드시 재캘리브레이션하세요. 대기압 변화가 측정값에 영향을 줍니다.', en: 'Always recalibrate after changing altitude or location. Atmospheric pressure changes affect measurements.', ja: '高度が変わったり場所を移動した後は、必ず再キャリブレーションしてください。気圧の変化が測定値に影響します。', zh: '更换海拔或位置后请务必重新校准。大气压变化会影响测量值。', tw: '更換海拔或位置後請務必重新校準。大氣壓變化會影響測量值。' },
    'guide.s06': { ko: '실시간 측정 & 기록', en: 'Real-time Measurement & Recording', ja: 'リアルタイム測定 & 記録', zh: '实时测量与记录', tw: '即時測量與記錄' },
    'guide.s06.intro': { ko: '측정 화면에서 실시간 그래프를 확인하며 이퀄라이징을 연습합니다.', en: 'Practice equalization while watching the real-time graph on the measurement screen.', ja: '測定画面でリアルタイムグラフを確認しながらイコライジングを練習します。', zh: '在测量界面查看实时图表并练习均压。', tw: '在測量介面查看即時圖表並練習均壓。' },
    'guide.s06.f1-title': { ko: '실시간 그래프', en: 'Real-time Graph', ja: 'リアルタイムグラフ', zh: '实时图表', tw: '即時圖表' },
    'guide.s06.f1-desc': { ko: '30초 슬라이딩 윈도우로 압력 변화를 실시간으로 표시합니다. Y축은 자동 스케일링됩니다.', en: '30-second sliding window displays pressure changes in real time. Y-axis auto-scales.', ja: '30秒のスライディングウィンドウで圧力変化をリアルタイムに表示します。Y軸は自動スケーリングされます。', zh: '30秒滑动窗口实时显示压力变化。Y轴自动缩放。', tw: '30秒滑動窗口即時顯示壓力變化。Y軸自動縮放。' },
    'guide.s06.f2-title': { ko: '핀치 줌 & 드래그', en: 'Pinch Zoom & Drag', ja: 'ピンチズーム & ドラッグ', zh: '捏合缩放与拖拽', tw: '捏合縮放與拖曳' },
    'guide.s06.f2-desc': { ko: '그래프를 핀치 줌으로 확대하거나 드래그하여 과거 데이터를 확인할 수 있습니다.', en: 'Pinch to zoom in on the graph or drag to review past data.', ja: 'グラフをピンチズームで拡大したり、ドラッグして過去のデータを確認できます。', zh: '通过捏合缩放放大图表，或拖拽查看过去的数据。', tw: '通過捏合縮放放大圖表，或拖曳查看過去的數據。' },
    'guide.s06.f3-title': { ko: '세션 기록', en: 'Session Recording', ja: 'セッション記録', zh: '会话记录', tw: '會話記錄' },
    'guide.s06.f3-desc': { ko: '"정지"를 누르면 세션이 자동 저장됩니다. 기록 탭에서 언제든 다시 확인 가능합니다.', en: 'Press "Stop" to auto-save the session. Review anytime in the History tab.', ja: '「停止」を押すとセッションが自動保存されます。履歴タブでいつでも再確認できます。', zh: '按下"停止"后会话将自动保存。可随时在记录页面中查看。', tw: '按下"停止"後會話將自動儲存。可隨時在記錄頁面中查看。' },
    'guide.s06.f4-title': { ko: '그래프 노트', en: 'Graph Notes', ja: 'グラフノート', zh: '图表备注', tw: '圖表備註' },
    'guide.s06.f4-desc': { ko: '특정 시점에 메모를 남길 수 있습니다. 연습 중 느낀 점을 바로 기록하세요.', en: 'Leave notes at specific points. Record your observations during practice.', ja: '特定の時点にメモを残すことができます。練習中に感じたことをすぐに記録しましょう。', zh: '可以在特定时间点留下备注。将练习中的感受随时记录下来。', tw: '可以在特定時間點留下備註。將練習中的感受隨時記錄下來。' },
    'guide.s07': { ko: '피크 분석 읽는 법', en: 'Reading Peak Analysis', ja: 'ピーク分析の読み方', zh: '如何阅读峰值分析', tw: '如何閱讀峰值分析' },
    'guide.s07.intro': { ko: '세션 기록에서 피크 분석을 선택하면 아래 지표들을 확인할 수 있습니다.', en: 'Select Peak Analysis from session records to see the following metrics.', ja: 'セッション記録からピーク分析を選択すると、以下の指標を確認できます。', zh: '在会话记录中选择峰值分析，可以查看以下指标。', tw: '在會話記錄中選擇峰值分析，可以查看以下指標。' },
    'guide.s07.m1-title': { ko: '리듬 점수', en: 'Rhythm Score', ja: 'リズムスコア', zh: '节奏分数', tw: '節奏分數' },
    'guide.s07.m1-desc': { ko: '피크 간격의 일관성을 측정합니다. 변동계수(CV) 기반으로 계산되며, 점수가 높을수록 규칙적인 이퀄라이징을 의미합니다.', en: 'Measures peak interval consistency. Calculated based on coefficient of variation (CV) — higher scores mean more regular equalization.', ja: 'ピーク間隔の一貫性を測定します。変動係数（CV）に基づいて計算され、スコアが高いほど規則的なイコライジングを意味します。', zh: '测量峰值间隔的一致性。基于变异系数（CV）计算，分数越高表示均压越规律。', tw: '測量峰值間隔的一致性。基於變異係數（CV）計算，分數越高表示均壓越規律。' },
    'guide.s07.m2-title': { ko: '압력 점수', en: 'Pressure Score', ja: '圧力スコア', zh: '压力分数', tw: '壓力分數' },
    'guide.s07.m2-desc': { ko: '피크 강도의 균일성을 측정합니다. 매번 일정한 힘으로 이퀄라이징하는지 확인할 수 있습니다.', en: 'Measures peak intensity uniformity. Check if you\'re equalizing with consistent force each time.', ja: 'ピーク強度の均一性を測定します。毎回一定の力でイコライジングしているか確認できます。', zh: '测量峰值强度的均匀性。可以确认每次均压力度是否一致。', tw: '測量峰值強度的均勻性。可以確認每次均壓力度是否一致。' },
    'guide.s07.m3-title': { ko: '기법 점수', en: 'Technique Score', ja: '技法スコア', zh: '技法分数', tw: '技法分數' },
    'guide.s07.m3-desc': { ko: '상승 시간, 하강 시간, 피크 폭을 분석합니다. 날카롭고 빠른 피크일수록 프렌젤에 가깝습니다.', en: 'Analyzes rise time, fall time, and peak width. Sharper, faster peaks indicate Frenzel technique.', ja: '上昇時間、下降時間、ピーク幅を分析します。鋭く速いピークほどフレンゼルに近いです。', zh: '分析上升时间、下降时间和峰宽。越尖锐、越快的峰值越接近Frenzel技法。', tw: '分析上升時間、下降時間和峰寬。越尖銳、越快的峰值越接近Frenzel技法。' },
    'guide.s07.m4-title': { ko: '피로도 지수', en: 'Fatigue Index', ja: '疲労度指数', zh: '疲劳指数', tw: '疲勞指數' },
    'guide.s07.m4-desc': { ko: '세션 후반부의 압력 감소 추세를 측정합니다. 지수가 높으면 근육 피로가 누적되고 있음을 나타냅니다.', en: 'Measures pressure decline trend in the latter half. Higher index indicates accumulated muscle fatigue.', ja: 'セッション後半の圧力減少傾向を測定します。指数が高いと筋肉疲労が蓄積していることを示します。', zh: '测量会话后半段的压力下降趋势。指数越高表示肌肉疲劳正在累积。', tw: '測量會話後半段的壓力下降趨勢。指數越高表示肌肉疲勞正在累積。' },
    'guide.s07.grade-title': { ko: '종합 등급 기준', en: 'Overall Grade Criteria', ja: '総合グレード基準', zh: '综合等级标准', tw: '綜合等級標準' },
    'guide.s07.grade-desc': { ko: '각 지표의 가중 평균으로 산출됩니다. 꾸준한 연습으로 등급을 올려보세요!', en: 'Calculated as a weighted average of all metrics. Keep practicing to improve your grade!', ja: '各指標の加重平均で算出されます。継続的な練習でグレードを上げましょう！', zh: '由各指标的加权平均计算得出。坚持练习提升等级吧！', tw: '由各指標的加權平均計算得出。堅持練習提升等級吧！' },
    'guide.s08': { ko: '기법별 연습 팁', en: 'Technique Practice Tips', ja: '技法別練習のコツ', zh: '各技法练习技巧', tw: '各技法練習技巧' },
    'guide.s08.valsalva': { ko: '발살바 (Valsalva)', en: 'Valsalva', ja: 'バルサルバ (Valsalva)', zh: 'Valsalva（瓦尔萨尔瓦）', tw: 'Valsalva（瓦爾薩爾瓦）' },
    'guide.s08.valsalva-badge': { ko: '기본', en: 'Basic', ja: '基本', zh: '基础', tw: '基礎' },
    'guide.s08.valsalva-desc': { ko: '코를 막고 입을 다문 채 복부/흉부 압력으로 공기를 밀어냅니다.', en: 'Pinch nose, close mouth, and push air using abdominal/chest pressure.', ja: '鼻をつまみ、口を閉じたまま腹部/胸部の圧力で空気を押し出します。', zh: '捏住鼻子，闭上嘴巴，利用腹部/胸部压力推送空气。', tw: '捏住鼻子，閉上嘴巴，利用腹部/胸部壓力推送空氣。' },
    'guide.s08.valsalva-pattern': { ko: '천천히 올라가서 오래 유지되는 <strong>둥근 커브</strong>. 상승/하강이 느리고 피크 폭이 넓습니다.', en: 'Slowly rising and long-lasting <strong>rounded curve</strong>. Slow rise/fall with wide peaks.', ja: 'ゆっくり上昇し長く維持される<strong>丸みのあるカーブ</strong>。上昇/下降が遅く、ピーク幅が広いです。', zh: '缓慢上升并长时间保持的<strong>圆弧曲线</strong>。上升/下降缓慢，峰宽较大。', tw: '緩慢上升並長時間保持的<strong>圓弧曲線</strong>。上升/下降緩慢，峰寬較大。' },
    'guide.s08.valsalva-warn': { ko: '과도한 힘은 고막 손상을 유발할 수 있습니다. 그래프에서 과압 경고가 나타나면 즉시 멈추세요.', en: 'Excessive force can cause eardrum damage. Stop immediately if the graph shows an overpressure warning.', ja: '過度な力は鼓膜損傷を引き起こす可能性があります。グラフで過圧警告が表示されたら直ちに止めてください。', zh: '过度用力可能导致鼓膜损伤。图表显示过压警告时请立即停止。', tw: '過度用力可能導致鼓膜損傷。圖表顯示過壓警告時請立即停止。' },
    'guide.s08.frenzel': { ko: '프렌젤 (Frenzel)', en: 'Frenzel', ja: 'フレンゼル (Frenzel)', zh: 'Frenzel（弗伦泽尔）', tw: 'Frenzel（弗倫澤爾）' },
    'guide.s08.frenzel-badge': { ko: '중급', en: 'Intermediate', ja: '中級', zh: '中级', tw: '中級' },
    'guide.s08.frenzel-desc': { ko: '혀의 뒤쪽(혀뿌리)을 입천장 쪽으로 밀어 올려 공기를 압축합니다.', en: 'Compress air by pushing the back of the tongue up against the palate.', ja: '舌の奥（舌根）を口蓋に向かって押し上げて空気を圧縮します。', zh: '将舌头后部（舌根）向上颚推压以压缩空气。', tw: '將舌頭後部（舌根）向上顎推壓以壓縮空氣。' },
    'guide.s08.frenzel-pattern': { ko: '빠르고 <strong>날카로운 스파이크</strong>. 상승/하강이 매우 빠르고 피크 폭이 좁습니다.', en: 'Fast and <strong>sharp spikes</strong>. Very fast rise/fall with narrow peaks.', ja: '速く<strong>鋭いスパイク</strong>。上昇/下降が非常に速く、ピーク幅が狭いです。', zh: '快速的<strong>尖锐脉冲</strong>。上升/下降非常快，峰宽很窄。', tw: '快速的<strong>尖銳脈衝</strong>。上升/下降非常快，峰寬很窄。' },
    'guide.s08.frenzel-tip': { ko: '"K" 또는 "T" 발음을 하듯이 혀를 움직여 보세요. 그래프에서 날카로운 피크가 나타나면 성공입니다!', en: 'Try moving your tongue as if saying "K" or "T". You\'ve got it when you see sharp peaks on the graph!', ja: '「K」または「T」を発音するように舌を動かしてみてください。グラフに鋭いピークが現れたら成功です！', zh: '尝试像发"K"或"T"音一样移动舌头。图表上出现尖锐的峰值就成功了！', tw: '嘗試像發"K"或"T"音一樣移動舌頭。圖表上出現尖銳的峰值就成功了！' },
    'guide.s08.mouthfill': { ko: '마우스필 (Mouthfill)', en: 'Mouthfill', ja: 'マウスフィル (Mouthfill)', zh: 'Mouthfill（口腔填充）', tw: 'Mouthfill（口腔填充）' },
    'guide.s08.mouthfill-badge': { ko: '고급', en: 'Advanced', ja: '上級', zh: '高级', tw: '高級' },
    'guide.s08.mouthfill-desc': { ko: '입안에 공기를 가득 채운 후, 성문을 닫고 입안의 공기만으로 이퀄라이징합니다.', en: 'Fill your mouth with air, close the glottis, and equalize using only mouth air.', ja: '口の中に空気をいっぱいに貯め、声門を閉じ、口の中の空気だけでイコライジングします。', zh: '将口腔充满空气，关闭声门，仅用口腔内的空气进行均压。', tw: '將口腔充滿空氣，關閉聲門，僅用口腔內的空氣進行均壓。' },
    'guide.s08.mouthfill-pattern': { ko: '초기 높은 피크 후, 점차 <strong>감소하는 연속 피크</strong>. 입안 공기가 줄어들며 압력이 낮아집니다.', en: 'Initial high peak followed by <strong>progressively decreasing peaks</strong>. Pressure drops as mouth air depletes.', ja: '初期の高いピークの後、徐々に<strong>減少する連続ピーク</strong>。口の中の空気が減り、圧力が下がります。', zh: '初始高峰后逐渐<strong>递减的连续峰值</strong>。随着口腔空气减少，压力降低。', tw: '初始高峰後逐漸<strong>遞減的連續峰值</strong>。隨著口腔空氣減少，壓力降低。' },
    'guide.s08.btv': { ko: '핸즈프리 / BTV', en: 'Hands-free / BTV', ja: 'ハンズフリー / BTV', zh: 'Hands-free / BTV', tw: 'Hands-free / BTV' },
    'guide.s08.btv-badge': { ko: '고급', en: 'Advanced', ja: '上級', zh: '高级', tw: '高級' },
    'guide.s08.btv-desc': { ko: '유스타키오관의 자발적 개방(Voluntary Tubal Opening). 코를 막지 않고 이퀄라이징합니다.', en: 'Voluntary Tubal Opening of the Eustachian tube. Equalize without pinching your nose.', ja: '耳管の自発的開放（Voluntary Tubal Opening）。鼻をつままずにイコライジングします。', zh: '咽鼓管自主开放（Voluntary Tubal Opening）。无需捏鼻即可均压。', tw: '咽鼓管自主開放（Voluntary Tubal Opening）。無需捏鼻即可均壓。' },
    'guide.s08.btv-pattern': { ko: '매우 <strong>미세한 압력 변화</strong>. 다른 기법에 비해 피크가 작지만 일정한 패턴을 보입니다.', en: 'Very <strong>subtle pressure changes</strong>. Smaller peaks than other techniques but consistent pattern.', ja: '非常に<strong>微細な圧力変化</strong>。他の技法に比べてピークは小さいですが、一定のパターンを示します。', zh: '非常<strong>微小的压力变化</strong>。相比其他技法峰值较小，但呈现一致的模式。', tw: '非常<strong>微小的壓力變化</strong>。相比其他技法峰值較小，但呈現一致的模式。' },
    'guide.s09': { ko: '펌웨어 업데이트', en: 'Firmware Update', ja: 'ファームウェアアップデート', zh: '固件更新', tw: '韌體更新' },
    'guide.s09.intro': { ko: '앱의 설정 탭에서 펌웨어 버전을 확인하고, 최신 버전으로 업데이트할 수 있습니다.', en: 'Check the firmware version in the app\'s Settings tab and update to the latest version.', ja: 'アプリの設定タブでファームウェアバージョンを確認し、最新バージョンにアップデートできます。', zh: '在应用的设置页面中查看固件版本，并更新到最新版本。', tw: '在應用的設定頁面中查看韌體版本，並更新到最新版本。' },
    'guide.s09.1-title': { ko: '현재 버전 확인', en: 'Check Current Version', ja: '現在のバージョン確認', zh: '确认当前版本', tw: '確認當前版本' },
    'guide.s09.1-desc': { ko: '설정 → 디바이스 설정에서 현재 펌웨어 버전을 확인합니다.', en: 'Go to Settings → Device Settings to check your current firmware version.', ja: '設定 → デバイス設定で現在のファームウェアバージョンを確認します。', zh: '前往设置 → 设备设置查看当前固件版本。', tw: '前往設定 → 設備設定查看當前韌體版本。' },
    'guide.s09.2-title': { ko: '업데이트 시작', en: 'Start Update', ja: 'アップデート開始', zh: '开始更新', tw: '開始更新' },
    'guide.s09.2-desc': { ko: '"펌웨어 업데이트" 버튼을 탭하면 디바이스가 BOOTSEL 모드로 재부팅됩니다.', en: 'Tap "Firmware Update" and the device reboots into BOOTSEL mode.', ja: '「ファームウェアアップデート」ボタンをタップすると、デバイスがBOOTSELモードで再起動します。', zh: '点击"固件更新"按钮后，设备将重启进入BOOTSEL模式。', tw: '點擊"韌體更新"按鈕後，設備將重新啟動進入BOOTSEL模式。' },
    'guide.s09.3-title': { ko: 'UF2 파일 복사', en: 'Copy UF2 File', ja: 'UF2ファイルのコピー', zh: '复制UF2文件', tw: '複製UF2檔案' },
    'guide.s09.3-desc': { ko: 'PC에서 USB 드라이브로 인식된 DiveChecker에 .uf2 파일을 드래그 앤 드롭합니다.', en: 'Drag and drop the .uf2 file onto the DiveChecker USB drive on your PC.', ja: 'PCでUSBドライブとして認識されたDiveCheckerに.uf2ファイルをドラッグ＆ドロップします。', zh: '将.uf2文件拖放到PC上识别为USB驱动器的DiveChecker中。', tw: '將.uf2檔案拖放到PC上識別為USB磁碟機的DiveChecker中。' },
    'guide.s09.4-title': { ko: '자동 재부팅', en: 'Auto Reboot', ja: '自動再起動', zh: '自动重启', tw: '自動重新啟動' },
    'guide.s09.4-desc': { ko: '업로드가 완료되면 자동으로 재부팅되어 새 펌웨어로 동작합니다.', en: 'The device automatically reboots with the new firmware after upload.', ja: 'アップロードが完了すると自動的に再起動し、新しいファームウェアで動作します。', zh: '上传完成后将自动重启并运行新固件。', tw: '上傳完成後將自動重新啟動並執行新韌體。' },
    'guide.s10': { ko: '문제 해결', en: 'Troubleshooting', ja: 'トラブルシューティング', zh: '故障排除', tw: '故障排除' },
    'guide.s10.q1': { ko: '디바이스가 인식되지 않아요', en: 'Device not recognized', ja: 'デバイスが認識されません', zh: '设备未被识别', tw: '設備未被識別' },
    'guide.s10.q1-a1': { ko: '충전 전용 케이블이 아닌 데이터 케이블인지 확인하세요', en: 'Make sure you\'re using a data cable, not a charge-only cable', ja: '充電専用ケーブルではなくデータケーブルであることを確認してください', zh: '请确认使用的是数据线而非充电专用线', tw: '請確認使用的是數據線而非充電專用線' },
    'guide.s10.q1-a2': { ko: '다른 USB 포트에 연결해 보세요', en: 'Try a different USB port', ja: '別のUSBポートに接続してみてください', zh: '尝试连接到其他USB端口', tw: '嘗試連接到其他USB端口' },
    'guide.s10.q1-a3': { ko: '케이블을 분리했다가 다시 연결하세요', en: 'Disconnect and reconnect the cable', ja: 'ケーブルを外してから再接続してください', zh: '断开后重新连接数据线', tw: '斷開後重新連接數據線' },
    'guide.s10.q1-a4': { ko: 'Android: USB OTG 설정이 켜져 있는지 확인하세요', en: 'Android: Check if USB OTG is enabled', ja: 'Android: USB OTG設定がオンになっているか確認してください', zh: 'Android：请确认USB OTG设置已开启', tw: 'Android：請確認USB OTG設定已開啟' },
    'guide.s10.q2': { ko: '그래프가 움직이지 않아요', en: 'Graph not moving', ja: 'グラフが動きません', zh: '图表没有动', tw: '圖表沒有動' },
    'guide.s10.q2-a1': { ko: '캘리브레이션을 다시 진행하세요', en: 'Recalibrate the sensor', ja: 'キャリブレーションをやり直してください', zh: '请重新进行校准', tw: '請重新進行校準' },
    'guide.s10.q2-a2': { ko: '센서 홀에 이물질이 없는지 확인하세요', en: 'Check for debris in the sensor hole', ja: 'センサーホールに異物がないか確認してください', zh: '请检查传感器孔是否有异物', tw: '請檢查感測器孔是否有異物' },
    'guide.s10.q2-a3': { ko: '앱을 종료 후 재실행하세요', en: 'Restart the app', ja: 'アプリを終了して再起動してください', zh: '请关闭应用后重新启动', tw: '請關閉應用後重新啟動' },
    'guide.s10.q3': { ko: '압력 값이 비정상적이에요', en: 'Abnormal pressure readings', ja: '圧力値が異常です', zh: '压力值异常', tw: '壓力值異常' },
    'guide.s10.q3-a1': { ko: '캘리브레이션을 다시 진행하세요', en: 'Recalibrate the sensor', ja: 'キャリブレーションをやり直してください', zh: '请重新进行校准', tw: '請重新進行校準' },
    'guide.s10.q3-a2': { ko: '센서에 수분이 들어가지 않았는지 확인하세요', en: 'Check if moisture has entered the sensor', ja: 'センサーに水分が入っていないか確認してください', zh: '请检查传感器是否进水', tw: '請檢查感測器是否進水' },
    'guide.s10.q3-a3': { ko: '급격한 온도 변화 후에는 10분 안정화 후 사용하세요', en: 'Wait 10 minutes to stabilize after rapid temperature changes', ja: '急激な温度変化の後は10分間安定化してからご使用ください', zh: '温度急剧变化后，请等待10分钟稳定后再使用', tw: '溫度急劇變化後，請等待10分鐘穩定後再使用' },
    'guide.s10.q4': { ko: 'LED가 켜지지 않아요', en: 'LED not turning on', ja: 'LEDが点灯しません', zh: 'LED不亮', tw: 'LED不亮' },
    'guide.s10.q4-a1': { ko: '케이블이 제대로 꽂혀 있는지 확인하세요', en: 'Check if the cable is properly connected', ja: 'ケーブルがしっかり差し込まれているか確認してください', zh: '请检查数据线是否正确连接', tw: '請檢查數據線是否正確連接' },
    'guide.s10.q4-a2': { ko: '다른 기기에 연결해서 테스트하세요', en: 'Test with a different device', ja: '別のデバイスに接続してテストしてください', zh: '尝试连接到其他设备进行测试', tw: '嘗試連接到其他設備進行測試' },
    'guide.s10.q4-a3': { ko: '문제가 지속되면 <a href="support.html">고객 지원</a>에 문의하세요', en: 'If the problem persists, contact <a href="support.html">customer support</a>', ja: '問題が続く場合は<a href="support.html">カスタマーサポート</a>にお問い合わせください', zh: '如问题持续，请联系<a href="support.html">客户支持</a>', tw: '如問題持續，請聯繫<a href="support.html">客戶支持</a>' },
    'guide.cta': { ko: '해결되지 않는 문제가 있으신가요?', en: 'Still having issues?', ja: '解決しない問題がありますか？', zh: '还有未解决的问题吗？', tw: '還有未解決的問題嗎？' },
    'guide.cta-btn': { ko: '고객 지원 문의', en: 'Contact Support', ja: 'カスタマーサポートに問い合わせ', zh: '联系客户支持', tw: '聯繫客戶支持' },
    'guide.pattern-label': { ko: '그래프 패턴', en: 'Graph Pattern', ja: 'グラフパターン', zh: '图表模式', tw: '圖表模式' },

    // ═══ FAQ PAGE ═══
    'faq.page-title': { ko: '자주 묻는 질문', en: 'Frequently Asked Questions', ja: 'よくある質問', zh: '常见问题', tw: '常見問題' },
    'faq.page-desc': { ko: '구매부터 사용까지, 궁금한 점을 확인하세요.', en: 'Find answers about purchasing and using DiveChecker.', ja: '製品について気になることを確認しましょう。', zh: '查看关于产品的常见疑问。', tw: '查看關於產品的常見疑問。' },
    'faq.cat1': { ko: '제품 일반', en: 'General', ja: '製品について', zh: '关于产品', tw: '關於產品' },
    'faq.q1': { ko: '다이브체커는 어떤 제품인가요?', en: 'What is DiveChecker?', ja: 'DiveCheckerとは何ですか？', zh: 'DiveChecker是什么？', tw: 'DiveChecker是什麼？' },
    'faq.a1': { ko: '다이브체커는 프리다이빙 이퀄라이징(균압) 훈련을 위한 실시간 압력 모니터링 디바이스입니다. 고정밀 압력 센서(BMP280)로 코/입의 미세한 압력 변화를 100Hz로 측정하고, 전용 앱을 통해 실시간 그래프로 시각화합니다.', en: 'DiveChecker is a real-time pressure monitoring device for freediving equalization training. It measures subtle pressure changes from your nose/mouth at 100Hz using a high-precision pressure sensor (BMP280) and visualizes them as real-time graphs through a dedicated app.', ja: 'ダイビングに必要なイコライジング（均圧）技術を実時間で可視化する教育用トレーニングデバイスです。BMP280圧力センサーが100Hzでサンプリングし、USB経由でリアルタイムグラフを表示します。', zh: '这是一款将潜水所需的均压技术实时可视化的教育训练设备。BMP280压力传感器以100Hz采样，通过USB实时显示图表。', tw: '這是一款將潛水所需的均壓技術實時可視化的教育訓練設備。BMP280壓力傳感器以100Hz採樣，通過USB實時顯示圖表。' },
    'faq.q2': { ko: '방수가 되나요? 물속에서 사용할 수 있나요?', en: 'Is it waterproof? Can I use it underwater?', ja: '防水ですか？水中で使えますか？', zh: '防水吗？可以在水中使用吗？', tw: '防水嗎？可以在水中使用嗎？' },
    'faq.a2': { ko: '<strong>아니요.</strong> DiveChecker는 지상 훈련용 디바이스입니다. 방수 기능이 없으므로 물에 닿지 않도록 주의해 주세요. 센서에 수분이 유입되면 고장의 원인이 됩니다.', en: '<strong>No.</strong> DiveChecker is a dry training device. It is not waterproof, so keep it away from water. Moisture entering the sensor can cause damage.', ja: '<strong>いいえ。</strong>DiveCheckerは陸上トレーニング用デバイスです。防水機能がないため、水に触れないようご注意ください。センサーに水分が入ると故障の原因になります。', zh: '<strong>不是。</strong>DiveChecker是陆地训练用设备。没有防水功能，请注意不要接触水。传感器进水会导致故障。', tw: '<strong>不是。</strong>DiveChecker是陸地訓練用設備。沒有防水功能，請注意不要接觸水。傳感器進水會導致故障。' },
    'faq.q3': { ko: '배터리가 필요한가요?', en: 'Does it need a battery?', ja: 'バッテリーは必要ですか？', zh: '需要电池吗？', tw: '需要電池嗎？' },
    'faq.a3': { ko: '아니요. USB-C 연결만으로 전원이 공급됩니다. 배터리 충전이나 교체가 필요 없어 언제든 바로 사용할 수 있습니다.', en: 'No. It\'s powered via USB-C connection. No battery charging or replacement needed — always ready to use.', ja: 'いいえ。USB-C接続だけで電源が供給されます。バッテリーの充電や交換が不要で、いつでもすぐに使用できます。', zh: '不需要。仅通过USB-C连接即可供电。无需充电或更换电池，随时可用。', tw: '不需要。僅通過USB-C連接即可供電。無需充電或更換電池，隨時可用。' },
    'faq.q4': { ko: '왜 블루투스가 아닌 USB 방식인가요?', en: 'Why USB instead of Bluetooth?', ja: 'なぜBluetoothではなくUSBですか？', zh: '为什么用USB而不是蓝牙？', tw: '為什麼用USB而不是藍牙？' },
    'faq.a4': { ko: '이퀄라이징 훈련에서는 0.01초의 지연도 잘못된 피드백으로 이어집니다. 블루투스는 50~300ms의 전송 지연이 발생하지만, USB는 <strong>제로 레이턴시</strong>로 정확한 실시간 피드백을 제공합니다. 또한 페어링 실패, 배터리 방전, 연결 끊김 문제가 없습니다.', en: 'In equalization training, even 0.01s delay leads to wrong feedback. Bluetooth has 50~300ms latency, but USB provides <strong>zero latency</strong> for accurate real-time feedback. Also eliminates pairing failures, battery drain, and disconnections.', ja: 'イコライジング訓練では0.01秒の遅延でも誤ったフィードバックにつながります。Bluetoothは50〜300msの遅延がありますが、USBは<strong>ゼロレイテンシ</strong>で正確なリアルタイムフィードバックを提供します。ペアリング失敗、バッテリー消耗、接続切断の問題もありません。', zh: '在均压训练中，即使0.01秒的延迟也会导致错误的反馈。蓝牙有50~300ms的传输延迟，而USB提供<strong>零延迟</strong>的精确实时反馈。此外还消除了配对失败、电池耗尽和断连问题。', tw: '在均壓訓練中，即使0.01秒的延遲也會導致錯誤的反饋。藍牙有50~300ms的傳輸延遲，而USB提供<strong>零延遲</strong>的精確實時反饋。此外還消除了配對失敗、電池耗盡和斷連問題。' },
    'faq.q5': { ko: '오픈소스인가요?', en: 'Is it open source?', ja: 'オープンソースですか？', zh: '是开源的吗？', tw: '是開源的嗎？' },
    'faq.a5': { ko: '네! 소프트웨어(앱, 펌웨어)는 <strong>Apache License 2.0</strong>, 하드웨어 설계는 <strong>CERN-OHL-S v2</strong> 라이센스로 공개되어 있습니다. GitHub에서 소스코드를 확인할 수 있습니다.', en: 'Yes! Software (app, firmware) is under <strong>Apache License 2.0</strong>, hardware design under <strong>CERN-OHL-S v2</strong>. Source code is available on GitHub.', ja: 'はい！ソフトウェア（アプリ、ファームウェア）は<strong>Apache License 2.0</strong>、ハードウェア設計は<strong>CERN-OHL-S v2</strong>ライセンスで公開されています。GitHubでソースコードを確認できます。', zh: '是的！软件（应用、固件）采用<strong>Apache License 2.0</strong>，硬件设计采用<strong>CERN-OHL-S v2</strong>许可证开源。可在GitHub上查看源代码。', tw: '是的！軟體（應用、韌體）採用<strong>Apache License 2.0</strong>，硬體設計採用<strong>CERN-OHL-S v2</strong>許可證開源。可在GitHub上查看原始碼。' },
    'faq.cat2': { ko: '호환성 & 앱', en: 'Compatibility & App', ja: '互換性・アプリ', zh: '兼容性与应用', tw: '相容性與應用' },
    'faq.q6': { ko: '어떤 기기에서 사용할 수 있나요?', en: 'What devices are compatible?', ja: 'どのデバイスで使えますか？', zh: '支持哪些设备？', tw: '支持哪些設備？' },
    'faq.a6': { ko: 'Android, iOS, Windows, macOS, Linux에서 사용 가능합니다. USB-C 포트가 있는 기기여야 하며, Android의 경우 USB OTG를 지원하는 기기에서 사용할 수 있습니다. Lightning 기기는 별도 변환잭이 필요합니다 (옵션 구매 가능).', en: 'Compatible with Android, iOS, Windows, macOS, and Linux. Requires USB-C port. Android devices need USB OTG support. Lightning devices require a separate adapter (available as option).', ja: 'Android、iOS、Windows、macOS、Linuxで使用可能です。USB-Cポートが必要で、Androidの場合はUSB OTG対応機器が必要です。Lightning機器には別途変換アダプターが必要です（オプション購入可能）。', zh: '支持Android、iOS、Windows、macOS和Linux。需要USB-C端口，Android设备需要支持USB OTG。Lightning设备需要另购转接头（可选购）。', tw: '支持Android、iOS、Windows、macOS和Linux。需要USB-C端口，Android設備需要支持USB OTG。Lightning設備需要另購轉接頭（可選購）。' },
    'faq.q7': { ko: 'iPhone에서 사용할 수 있나요?', en: 'Can I use it with iPhone?', ja: 'iPhoneでも使えますか？', zh: 'iPhone也能用吗？', tw: 'iPhone也能用嗎？' },
    'faq.a7': { ko: '네, USB-C 포트가 있는 iPhone 15 이상 및 USB-C iPad에서 바로 사용 가능합니다. Lightning 포트 모델(iPhone 14 이하, 구형 iPad)은 별도의 Lightning to USB-C 카메라 어댑터가 필요합니다 (옵션 구매 가능).', en: 'Yes, with USB-C iPhone 15+ and USB-C iPad directly. Lightning port models (iPhone 14 and earlier, older iPads) require a separate Lightning to USB-C camera adapter (available as an option).', ja: 'はい！USB-C搭載のiPhone 15以降およびUSB-C iPadで直接使用可能です。Lightningポートモデル（iPhone 14以前、旧型iPad）は別途Lightning to USB-Cカメラアダプターが必要です（オプション品として購入可能）。', zh: '可以！USB-C款iPhone 15及以上和USB-C iPad可直接使用。Lightning端口机型（iPhone 14及以下、旧款iPad）需要另购Lightning转USB-C相机转接头（可作为选配件购买）。', tw: '可以！USB-C款iPhone 15及以上和USB-C iPad可直接使用。Lightning端口機型（iPhone 14及以下、舊款iPad）需要另購Lightning轉USB-C相機轉接頭（可作為選配件購買）。' },
    'faq.q8': { ko: '앱 설치 없이 사용할 수 있나요?', en: 'Can I use it without installing an app?', ja: 'アプリをインストールせずに使えますか？', zh: '不安装应用也能用吗？', tw: '不安裝應用也能用嗎？' },
    'faq.a8': { ko: '전용 앱 설치를 권장합니다. Android는 <a href="https://play.google.com/store/apps/details?id=kr.createch.divechecker">Google Play</a>, iOS는 <a href="https://apps.apple.com/kr/app/divechecker/id6758508799">App Store</a>에서 다운로드할 수 있습니다. Windows, macOS, Linux용은 GitHub Releases에서 설치 가능합니다.', en: 'We recommend installing the dedicated app. Android is available on <a href="https://play.google.com/store/apps/details?id=kr.createch.divechecker">Google Play</a>, iOS on the <a href="https://apps.apple.com/kr/app/divechecker/id6758508799">App Store</a>. Windows, macOS, and Linux versions are available from GitHub Releases.', ja: '専用アプリのインストールを推奨します。Androidは<a href="https://play.google.com/store/apps/details?id=kr.createch.divechecker">Google Play</a>、iOSは<a href="https://apps.apple.com/kr/app/divechecker/id6758508799">App Store</a>からダウンロードできます。Windows、macOS、Linux版はGitHub Releasesからインストール可能です。', zh: '建议安装专用应用。Android可从<a href="https://play.google.com/store/apps/details?id=kr.createch.divechecker">Google Play</a>下载，iOS可从<a href="https://apps.apple.com/kr/app/divechecker/id6758508799">App Store</a>下载。Windows、macOS、Linux版可从GitHub Releases安装。', tw: '建議安裝專用應用。Android可從<a href="https://play.google.com/store/apps/details?id=kr.createch.divechecker">Google Play</a>下載，iOS可從<a href="https://apps.apple.com/kr/app/divechecker/id6758508799">App Store</a>下載。Windows、macOS、Linux版可從GitHub Releases安裝。' },
    'faq.q9': { ko: '앱에서 데이터를 백업할 수 있나요?', en: 'Can I back up data from the app?', ja: 'アプリでデータをバックアップできますか？', zh: '可以从应用备份数据吗？', tw: '可以從應用備份數據嗎？' },
    'faq.a9': { ko: '네. 설정 메뉴에서 JSON 형식으로 데이터를 백업하고 복원할 수 있습니다. 기기 변경 시에도 기록을 유지할 수 있습니다.', en: 'Yes. You can back up and restore data in JSON format from the settings menu. Keep your records when switching devices.', ja: 'はい。設定メニューからJSON形式でデータをバックアップ・復元できます。機器変更時にも記録を保持できます。', zh: '可以。在设置菜单中可以以JSON格式备份和恢复数据。更换设备时也能保留记录。', tw: '可以。在設置菜單中可以以JSON格式備份和恢復數據。更換設備時也能保留記錄。' },
    'faq.cat3': { ko: '사용 방법', en: 'How to Use', ja: '使い方', zh: '使用方法', tw: '使用方法' },
    'faq.q10': { ko: '어떻게 사용하나요?', en: 'How do I use it?', ja: 'どうやって使いますか？', zh: '怎么使用？', tw: '怎麼使用？' },
    'faq.a10': { ko: 'USB-C 케이블로 연결 → 앱 실행 → 캘리브레이션 → 센서에 코를 대고 이퀄라이징. 3단계로 바로 시작할 수 있습니다. 자세한 내용은 <a href="index.html#manual">사용 가이드</a>를 참고하세요.', en: 'Connect via USB-C → Launch app → Calibrate → Place sensor on nose and equalize. Start in 3 simple steps. See the <a href="index.html#manual">User Guide</a> for details.', ja: 'USB-Cケーブルで接続 → アプリ起動 → キャリブレーション → センサーに鼻を当ててイコライジング。3ステップですぐに始められます。詳しくは<a href="index.html#manual">ユーザーガイド</a>をご覧ください。', zh: '通过USB-C线连接 → 启动应用 → 校准 → 将传感器放在鼻子上进行均压。3个简单步骤即可开始。详情请参阅<a href="index.html#manual">使用指南</a>。', tw: '通過USB-C線連接 → 啟動應用 → 校準 → 將傳感器放在鼻子上進行均壓。3個簡單步驟即可開始。詳情請參閱<a href="index.html#manual">使用指南</a>。' },
    'faq.q11': { ko: '캘리브레이션은 매번 해야 하나요?', en: 'Do I need to calibrate every time?', ja: 'キャリブレーションは毎回必要ですか？', zh: '每次都需要校准吗？', tw: '每次都需要校準嗎？' },
    'faq.a11': { ko: '권장합니다. 캘리브레이션은 현재 대기압을 기준점(0 hPa)으로 설정하는 과정입니다. 고도 변화, 날씨 변화 등으로 대기압이 달라지면 측정값에 영향을 줄 수 있으므로, 매 세션 시작 전 캘리브레이션을 진행하는 것이 좋습니다.', en: 'Recommended. Calibration sets the current atmospheric pressure as baseline (0 hPa). Changes in altitude or weather can affect readings, so calibrating before each session is best practice.', ja: 'はい、各セッション開始前のキャリブレーションを推奨します。大気圧は高度・場所・天候で変わるため、基準点の再設定が必要です。アプリで「キャリブレーション」ボタンをタップするだけで3秒で完了します。', zh: '是的，建议每次训练前校准。大气压会因海拔、位置、天气而变化，需要重新设置基准点。在应用中点击"校准"按钮3秒即可完成。', tw: '是的，建議每次訓練前校準。大氣壓會因海拔、位置、天氣而變化，需要重新設置基準點。在應用中點擊「校準」按鈕3秒即可完成。' },
    'faq.q12': { ko: '프렌젤과 발살바를 어떻게 구분하나요?', en: 'How to distinguish Frenzel from Valsalva?', ja: 'フレンゼルとバルサルバはどう区別しますか？', zh: '如何区分Frenzel和Valsalva？', tw: '如何區分Frenzel和Valsalva？' },
    'faq.a12': { ko: '그래프 패턴이 완전히 다릅니다. <strong>발살바</strong>는 천천히 올라가서 오래 유지되는 둥근 커브, <strong>프렌젤</strong>은 빠르고 날카로운 스파이크 형태입니다. 다이브체커를 사용하면 내가 어떤 기법을 하고 있는지 즉시 눈으로 확인할 수 있습니다.', en: 'The graph patterns are completely different. <strong>Valsalva</strong> shows a slowly rising, long-lasting rounded curve, while <strong>Frenzel</strong> produces fast, sharp spikes. DiveChecker lets you instantly see which technique you\'re using.', ja: 'グラフパターンが全く異なります。<strong>バルサルバ</strong>はゆっくり上昇して長く維持される丸いカーブ、<strong>フレンゼル</strong>は速く鋭いスパイク形状です。DiveCheckerを使えば、自分がどの技法を行っているか即座に目で確認できます。', zh: '图表模式完全不同。<strong>Valsalva</strong>是缓慢上升并长时间保持的圆形曲线，<strong>Frenzel</strong>是快速尖锐的尖峰形状。使用DiveChecker可以立即直观地确认自己正在使用哪种技法。', tw: '圖表模式完全不同。<strong>Valsalva</strong>是緩慢上升並長時間保持的圓形曲線，<strong>Frenzel</strong>是快速尖銳的尖峰形狀。使用DiveChecker可以立即直觀地確認自己正在使用哪種技法。' },
    'faq.q13': { ko: '초보자도 사용할 수 있나요?', en: 'Can beginners use it?', ja: '初心者でも使えますか？', zh: '初学者也能用吗？', tw: '初學者也能用嗎？' },
    'faq.a13': { ko: '물론입니다! 오히려 초보자에게 더 효과적입니다. 이퀄라이징이 되는지 안 되는지조차 판단하기 어려운 단계에서, 그래프를 통해 즉각적인 피드백을 받을 수 있습니다.', en: 'Absolutely! It\'s actually more effective for beginners. At the stage where you can\'t even tell if equalization is working, the graph provides instant feedback.', ja: 'もちろんです！むしろ初心者にこそ効果的です。イコライジングができているかどうかすら判断しにくい段階で、グラフを通じて即座にフィードバックを受けることができます。', zh: '当然可以！对初学者反而更有效。在连均压是否成功都难以判断的阶段，通过图表可以获得即时反馈。', tw: '當然可以！對初學者反而更有效。在連均壓是否成功都難以判斷的階段，通過圖表可以獲得即時反饋。' },
    'faq.q14': { ko: '센서에 직접 코를 대야 하나요?', en: 'Do I need to place my nose directly on the sensor?', ja: 'センサーに直接鼻を当てる必要がありますか？', zh: '需要直接把鼻子放在传感器上吗？', tw: '需要直接把鼻子放在傳感器上嗎？' },
    'faq.a14': { ko: '센서 홀에 직접 코(한쪽 콧구멍)를 밀착시키면 가장 정확한 측정이 됩니다. 또는 짧은 실리콘 튜브를 연결하여 사용할 수도 있습니다. 밀착도가 높을수록 정밀한 측정이 가능합니다.', en: 'Placing your nose (one nostril) directly on the sensor hole gives the most accurate reading. You can also use a short silicone tube. Better seal = more precise measurement.', ja: 'センサーホールに直接鼻（片方の鼻孔）を密着させると最も正確な測定ができます。短いシリコンチューブを接続して使用することもできます。密着度が高いほど精密な測定が可能です。', zh: '将鼻子（一侧鼻孔）直接贴合传感器孔可获得最准确的测量。也可以连接短硅胶管使用。密封度越高，测量越精确。', tw: '將鼻子（一側鼻孔）直接貼合傳感器孔可獲得最準確的測量。也可以連接短矽膠管使用。密封度越高，測量越精確。' },
    'faq.cat4': { ko: '구매 & A/S', en: 'Purchase & A/S', ja: '購入・アフターサービス', zh: '购买与售后', tw: '購買與售後' },
    'faq.q15': { ko: '어디서 구매할 수 있나요?', en: 'Where can I buy it?', ja: 'どこで購入できますか？', zh: '在哪里可以购买？', tw: '在哪裡可以購買？' },
    'faq.a15': { ko: '온라인 스토어에서 구매하실 수 있으며, 아이레 다이브 센터에서 직접 체험 후 현장 구매도 가능합니다.', en: 'Available at our online store. You can also try and buy in person at Aire Dive Center.', ja: 'オンラインストアでご購入いただけます。Aire Dive Centerで直接体験後、現場購入も可能です。', zh: '可在线上商店购买，也可以在Aire Dive Center亲自体验后现场购买。', tw: '可在線上商店購買，也可以在Aire Dive Center親自體驗後現場購買。' },
    'faq.q16': { ko: '보증 기간은 얼마인가요?', en: 'What is the warranty period?', ja: '保証期間はどのくらいですか？', zh: '保修期是多久？', tw: '保固期是多久？' },
    'faq.a16': { ko: '제품 구매일로부터 <strong>1개월 이내</strong>, 제품 자체 결함에 한해 무상 A/S를 제공합니다. 침수·이물질 유입·사용자 과실에 의한 파손은 유상 수리 대상입니다. 구매 영수증 등 구매 증빙을 첨부하여 이메일로 신청해 주세요.', en: 'Free A/S for manufacturing defects within <strong>1 month</strong> of purchase. Damage from water, debris, or user error is covered by paid repair. Submit via email with proof of purchase.', ja: '購入日から<strong>1ヶ月以内</strong>、製品自体の欠陥に限り無償アフターサービスを提供します。浸水・異物混入・ユーザーの過失による破損は有償修理の対象です。購入レシートなどの購入証明を添付してメールでお申し込みください。', zh: '自购买日起<strong>1个月内</strong>，仅限产品本身缺陷提供免费售后服务。浸水、异物进入、用户过失导致的损坏为有偿维修。请附上购买凭证通过邮件申请。', tw: '自購買日起<strong>1個月內</strong>，僅限產品本身缺陷提供免費售後服務。浸水、異物進入、用戶過失導致的損壞為有償維修。請附上購買憑證通過郵件申請。' },
    'faq.q17': { ko: 'A/S는 어떻게 받나요?', en: 'How do I get A/S service?', ja: 'アフターサービスはどのように受けられますか？', zh: '如何获得售后服务？', tw: '如何獲得售後服務？' },
    'faq.a17': { ko: '<a href="support.html">고객 지원 페이지</a>에서 문의해 주세요. 증상 확인 후 택배 수거 → 수리/교체 → 발송 순으로 진행됩니다. 국내 제조 제품이라 빠른 A/S가 가능합니다.', en: 'Contact us through our <a href="support.html">support page</a>. Process: confirm symptoms → courier pickup → repair/replace → ship back. Fast A/S since it\'s made in Korea.', ja: '<a href="support.html">カスタマーサポートページ</a>からお問い合わせください。症状確認後、宅配回収 → 修理/交換 → 発送の順で進みます。国内製造製品のため迅速なアフターサービスが可能です。', zh: '请通过<a href="support.html">客户支持页面</a>联系我们。确认症状后按快递取件 → 维修/更换 → 发货的流程进行。因为是国内制造产品，可以快速提供售后服务。', tw: '請通過<a href="support.html">客戶支持頁面</a>聯繫我們。確認症狀後按快遞取件 → 維修/更換 → 發貨的流程進行。因為是國內製造產品，可以快速提供售後服務。' },
    'faq.q18': { ko: '강사 할인 / 딜러 계약이 가능한가요?', en: 'Are instructor discounts / dealer agreements available?', ja: 'インストラクター割引やディーラー契約はできますか？', zh: '可以获得教练折扣或经销商合作吗？', tw: '可以獲得教練折扣或經銷商合作嗎？' },
    'faq.a18': { ko: '네! 다이브샵 및 다이빙 강사 분들과의 딜러 계약을 환영합니다. 도매 가격, 교육용 특별 할인 등 자세한 조건은 <a href="mailto:cs-divechecker@createch.kr">cs-divechecker@createch.kr</a>으로 문의해 주세요.', en: 'Yes! We welcome dealer partnerships with dive shops and instructors. For wholesale pricing and educational discounts, contact <a href="mailto:cs-divechecker@createch.kr">cs-divechecker@createch.kr</a>.', ja: 'はい！ダイブショップやダイビングインストラクターの方々とのディーラー契約を歓迎します。卸売価格、教育用特別割引など詳しい条件は<a href="mailto:cs-divechecker@createch.kr">cs-divechecker@createch.kr</a>までお問い合わせください。', zh: '当然！我们欢迎与潜水店和潜水教练建立经销商合作。批发价格、教育专属折扣等详细条件请联系<a href="mailto:cs-divechecker@createch.kr">cs-divechecker@createch.kr</a>。', tw: '當然！我們歡迎與潛水店和潛水教練建立經銷商合作。批發價格、教育專屬折扣等詳細條件請聯繫<a href="mailto:cs-divechecker@createch.kr">cs-divechecker@createch.kr</a>。' },
    'faq.q19': { ko: '해외 배송이 가능한가요?', en: 'Do you ship internationally?', ja: '海外配送はできますか？', zh: '支持海外配送吗？', tw: '支持海外配送嗎？' },
    'faq.a19': { ko: '현재 국내 배송만 지원하고 있습니다. 해외 배송은 준비 중이며, <a href="mailto:cs-divechecker@createch.kr">cs-divechecker@createch.kr</a>으로 문의해 주시면 개별적으로 안내드리겠습니다.', en: 'Currently domestic shipping only. International shipping is coming soon. Contact <a href="mailto:cs-divechecker@createch.kr">cs-divechecker@createch.kr</a> for individual arrangements.', ja: '現在、国内配送のみ対応しています。海外配送は準備中です。<a href="mailto:cs-divechecker@createch.kr">cs-divechecker@createch.kr</a>までお問い合わせいただければ個別にご案内いたします。', zh: '目前仅支持韩国国内配送。海外配送正在准备中，请联系<a href="mailto:cs-divechecker@createch.kr">cs-divechecker@createch.kr</a>，我们将单独为您安排。', tw: '目前僅支持韓國國內配送。海外配送正在準備中，請聯繫<a href="mailto:cs-divechecker@createch.kr">cs-divechecker@createch.kr</a>，我們將單獨為您安排。' },
    'faq.cta-title': { ko: '찾는 답변이 없으신가요?', en: 'Can\'t find your answer?', ja: 'お探しの回答が見つかりませんか？', zh: '没有找到您需要的答案？', tw: '沒有找到您需要的答案？' },
    'faq.cta-desc': { ko: '아래 버튼을 눌러 직접 문의해 주세요.', en: 'Click below to contact us directly.', ja: '下のボタンを押して直接お問い合わせください。', zh: '请点击下方按钮直接联系我们。', tw: '請點擊下方按鈕直接聯繫我們。' },
    'faq.cta-btn': { ko: '문의하기', en: 'Contact Us', ja: 'お問い合わせ', zh: '联系我们', tw: '聯繫我們' },

    // ═══ SUPPORT PAGE ═══
    'support.page-title': { ko: '고객 지원', en: 'Customer Support', ja: 'サポート', zh: '支持', tw: '支持' },
    'support.page-desc': { ko: '도움이 필요하신가요? 아래에서 문의 유형을 선택하세요.', en: 'Need help? Select your inquiry type below.', ja: 'お困りですか？お手伝いします。', zh: '遇到困难？我们来帮助您。', tw: '遇到困難？我們来帮助您。' },
    'support.as-title': { ko: 'A/S 수리', en: 'A/S Repair', ja: 'A/S・修理', zh: '售后・维修', tw: '售後・维修' },
    'support.as-desc': { ko: '제품 고장, 센서 이상, 물리적 손상 등 수리가 필요한 경우', en: 'Product malfunction, sensor issues, physical damage requiring repair', ja: '製品の故障やお修理が必要な場合', zh: '产品故障或需要维修时', tw: '產品故障或需要维修時' },
    'support.as-warranty': { ko: '보증 기간', en: 'Warranty', ja: '保証期間', zh: '保修期', tw: '保固期' },
    'support.as-warranty-val': { ko: '구매일로부터 1개월', en: '1 month from purchase', ja: '購入日から1ヶ月', zh: '自购买之日起1个月', tw: '自購買之日起1個月' },
    'support.as-time': { ko: '처리 기간', en: 'Processing', ja: '処理期間', zh: '处理期限', tw: '處理期限' },
    'support.as-time-val': { ko: '접수 후 3~5 영업일', en: '3~5 business days', ja: '受付後3〜5営業日', zh: '受理后3~5个工作日', tw: '受理後3~5個工作日' },
    'support.as-method': { ko: '방법', en: 'Method', ja: '方法', zh: '方式', tw: '方式' },
    'support.as-method-val': { ko: '택배 수거 → 수리 → 발송', en: 'Courier pickup → Repair → Ship', ja: '宅配回収 → 修理 → 発送', zh: '快递取件 → 维修 → 发货', tw: '快遞取件 → 維修 → 發貨' },
    'support.usage-title': { ko: '사용 문의', en: 'Usage Inquiry', ja: '使い方のご質問', zh: '使用咨询', tw: '使用諮詢' },
    'support.usage-desc': { ko: '앱 사용법, 연결 문제, 캘리브레이션, 측정 관련 질문', en: 'App usage, connection issues, calibration, measurement questions', ja: 'アプリの使い方、接続問題、キャリブレーション、測定に関する質問', zh: '应用使用方法、连接问题、校准、测量相关问题', tw: '應用使用方法、連接問題、校準、測量相關問題' },
    'support.usage-hint': { ko: '먼저 확인해 보세요:', en: 'Check these first:', ja: 'まずこちらをご確認ください：', zh: '请先确认以下内容：', tw: '請先確認以下內容：' },
    'support.purchase-title': { ko: '구매 문의', en: 'Purchase Inquiry', ja: 'ご購入のご質問', zh: '购买咨询', tw: '購買諮詢' },
    'support.purchase-desc': { ko: '가격, 배송, 강사 할인, 딜러 계약, 단체 구매 관련 문의', en: 'Pricing, shipping, instructor discounts, dealer agreements, bulk orders', ja: '価格、配送、インストラクター割引、ディーラー契約、大量購入に関するお問い合わせ', zh: '价格、配送、教练折扣、经销商合作、团购相关咨询', tw: '價格、配送、教練折扣、經銷商合作、團購相關諮詢' },
    'support.purchase-dealer': { ko: '강사 / 딜러', en: 'Instructor / Dealer', ja: 'インストラクター / ディーラー', zh: '教练 / 经销商', tw: '教練 / 經銷商' },
    'support.purchase-dealer-val': { ko: '이메일 별도 문의', en: 'Contact via email', ja: 'メールにてお問い合わせ', zh: '请通过邮件咨询', tw: '請透過郵件諮詢' },
    'support.purchase-store': { ko: '현장 구매', en: 'In-store', ja: '店頭購入', zh: '现场购买', tw: '現場購買' },
    'support.purchase-store-val': { ko: '아이레 다이브 센터', en: 'Aire Dive Center', ja: 'Aire Dive Center', zh: 'Aire Dive Center', tw: 'Aire Dive Center' },
    'support.tech-title': { ko: '기술 / 개발', en: 'Technical / Development', ja: '技術 / 開発', zh: '技术 / 开发', tw: '技術 / 開發' },
    'support.tech-desc': { ko: '펌웨어, 오픈소스, API, 커스텀 개발 관련 문의', en: 'Firmware, open source, API, custom development inquiries', ja: 'ファームウェア、オープンソース、API、カスタム開発に関するお問い合わせ', zh: '固件、开源、API、定制开发相关咨询', tw: '韌體、開源、API、客製開發相關諮詢' },
    'support.contact-label': { ko: 'CONTACT', en: 'CONTACT', ja: 'CONTACT', zh: 'CONTACT', tw: 'CONTACT' },
    'support.contact-title': { ko: '문의하기', en: 'Contact Us', ja: 'お問い合わせ', zh: '联系我们', tw: '聯繫我們' },
    'support.contact-sub': { ko: '아래 양식을 작성해 주시면 빠르게 답변 드리겠습니다', en: 'Fill out the form below and we\'ll respond promptly', ja: '以下のフォームにご記入いただければ、迅速にご回答いたします', zh: '请填写以下表单，我们将尽快回复', tw: '請填寫以下表單，我們將盡快回覆' },
    'support.form-name': { ko: '이름', en: 'Name', ja: 'お名前', zh: '姓名', tw: '姓名' },
    'support.form-email': { ko: '이메일', en: 'Email', ja: 'メールアドレス', zh: '邮箱', tw: '電子郵件' },
    'support.form-category': { ko: '문의 유형', en: 'Inquiry Type', ja: 'お問い合わせ種別', zh: '咨询类型', tw: '諮詢類型' },
    'support.form-select': { ko: '선택하세요', en: 'Select', ja: '選択してください', zh: '请选择', tw: '請選擇' },
    'support.form-cat-as': { ko: 'A/S 수리', en: 'A/S Repair', ja: 'A/S修理', zh: '售后维修', tw: '售後維修' },
    'support.form-cat-usage': { ko: '사용 문의', en: 'Usage Inquiry', ja: '使い方のご質問', zh: '使用咨询', tw: '使用諮詢' },
    'support.form-cat-purchase': { ko: '구매 문의', en: 'Purchase Inquiry', ja: 'ご購入のご質問', zh: '购买咨询', tw: '購買諮詢' },
    'support.form-cat-instructor': { ko: '강사 할인 / 딜러 계약 문의', en: 'Instructor / Dealer Inquiry', ja: 'インストラクター割引 / ディーラー契約', zh: '教练折扣 / 经销合作', tw: '教練折扣 / 經銷合作' },
    'support.form-cat-tech': { ko: '기술 / 개발', en: 'Technical / Development', ja: '技術 / 開発', zh: '技术 / 开发', tw: '技術 / 開發' },
    'support.form-cat-other': { ko: '기타', en: 'Other', ja: 'その他', zh: '其他', tw: '其他' },
    'support.form-subject': { ko: '제목', en: 'Subject', ja: '件名', zh: '主题', tw: '主題' },
    'support.form-subject-ph': { ko: '문의 제목을 입력하세요', en: 'Enter your subject', ja: 'お問い合わせ件名を入力してください', zh: '请输入咨询主题', tw: '請輸入諮詢主題' },
    'support.form-message': { ko: '내용', en: 'Message', ja: '内容', zh: '内容', tw: '內容' },
    'support.form-message-ph': { ko: '문의 내용을 자세히 적어주세요. A/S의 경우 증상과 구매일을 포함해 주세요.', en: 'Please describe your inquiry in detail. For A/S, include symptoms and purchase date.', ja: 'お問い合わせ内容を詳しくご記入ください。A/Sの場合は症状と購入日をお含めください。', zh: '请详细描述您的问题。如果是售后维修，请包含症状和购买日期。', tw: '請詳細描述您的問題。如果是售後維修，請包含症狀和購買日期。' },
    'support.form-order': { ko: '주문번호 (선택)', en: 'Order Number (optional)', ja: '注文番号（任意）', zh: '订单号（选填）', tw: '訂單號（選填）' },
    'support.form-order-ph': { ko: 'A/S 문의 시 주문번호를 입력하세요', en: 'Enter order number for A/S inquiries', ja: 'A/Sお問い合わせの場合は注文番号を入力してください', zh: '售后咨询时请输入订单号', tw: '售後諮詢時請輸入訂單號' },
    'support.form-submit': { ko: '문의 보내기', en: 'Send Inquiry', ja: 'お問い合わせを送信', zh: '发送咨询', tw: '發送諮詢' },
    'support.success-title': { ko: '문의가 접수되었습니다', en: 'Inquiry Submitted', ja: 'お問い合わせを受け付けました', zh: '咨询已提交', tw: '諮詢已提交' },
    'support.success-desc': { ko: '빠른 시일 내에 답변 드리겠습니다.<br>확인 메일을 보내드렸으니 수신함을 확인해 주세요.', en: 'We\'ll respond as soon as possible.<br>A confirmation email has been sent — please check your inbox.', ja: 'できるだけ早くご回答いたします。<br>確認メールをお送りしましたので、受信箱をご確認ください。', zh: '我们将尽快回复。<br>已发送确认邮件，请查看收件箱。', tw: '我們將盡快回覆。<br>已發送確認郵件，請查看收件箱。' },
    'support.success-btn': { ko: '홈으로 돌아가기', en: 'Back to Home', ja: 'ホームに戻る', zh: '返回首页', tw: '返回首頁' },
    'support.email-title': { ko: '이메일', en: 'Email', ja: 'メール問い合わせ', zh: '邮件咨询', tw: '郵件諮詢' },
    'support.email-sub': { ko: '영업일 기준 1~2일 내 답변', en: 'Response within 1~2 business days', ja: '営業日1~2日以内に返信', zh: '1~2个工作日内回复', tw: '1~2個工作日內回復' },
    'support.kakao-title': { ko: '카카오톡', en: 'KakaoTalk', ja: 'カカオトーク', zh: 'KakaoTalk', tw: 'KakaoTalk' },
    'support.kakao-sub': { ko: '실시간 채팅 상담', en: 'Real-time chat support', ja: 'リアルタイムチャット相談', zh: '实时聊天咨询', tw: '實時聊天諮詢' },
    'support.github-desc': { ko: '기술 이슈 & 버그 리포트', en: 'Technical issues & bug reports', ja: '技術問題＆バグ報告', zh: '技术问题和Bug报告', tw: '技术問題和Bug报告' },
    'support.github-sub': { ko: '오픈소스 커뮤니티', en: 'Open source community', ja: 'オープンソースコミュニティ', zh: '开源社区', tw: '開源社区' },
    'support.troubleshoot': { ko: '문제 해결', en: 'Troubleshooting', ja: '取扱説明書', zh: '产品说明书', tw: '產品說明書' },
    'support.form-name-ph': { ko: '홍길동', en: 'John Doe', ja: '山田太郎', zh: '张三', tw: '张三' },
    'support.form-category-default': { ko: '선택하세요', en: 'Select', ja: '選択してください', zh: '请选择', tw: '請選擇' },
    'support.form-category-as': { ko: 'A/S 수리', en: 'A/S Repair', ja: 'A/S修理', zh: '售后维修', tw: '售後维修' },
    'support.form-category-usage': { ko: '사용 문의', en: 'Usage Inquiry', ja: '使い方のご質問', zh: '使用咨询', tw: '使用諮詢' },
    'support.form-category-purchase': { ko: '구매 문의', en: 'Purchase Inquiry', ja: 'ご購入のご質問', zh: '购买咨询', tw: '購買諮詢' },
    'support.form-category-instructor': { ko: '강사 할인 / 딜러 계약 문의', en: 'Instructor / Dealer Inquiry', ja: 'インストラクター割引/ディーラー契約', zh: '教练折扣/经销合作', tw: '教練折扣/經銷合作' },
    'support.form-category-tech': { ko: '기술 / 개발', en: 'Technical / Development', ja: '技術/開発', zh: '技术/开发', tw: '技术/開發' },
    'support.form-category-other': { ko: '기타', en: 'Other', ja: 'その他', zh: '其他', tw: '其他' },

    // ── MANUAL ──
    'manual.title': { ko: '제품 사용 설명서', en: 'User Manual', ja: '製品取扱説明書', zh: '产品使用说明书', tw: '產品使用說明書' },
    'manual.sub': { ko: '디지털 압력 감지 학습기 DC-EQ01', en: 'Digital Pressure Sensing Trainer DC-EQ01', ja: 'デジタル圧力センシングトレーナー DC-EQ01', zh: '数字压力感应训练器 DC-EQ01', tw: '數位壓力感應訓練器 DC-EQ01' },

    // ── MANUAL: How to Use ──
    'manual.s02b': { ko: '사용 방법', en: 'How to Use', ja: '使用方法', zh: '使用方法', tw: '使用方法' },
    'manual.s02b.desc': { ko: '센서를 활용한 이퀄라이징 연습 순서입니다.', en: 'Step-by-step equalization practice using the sensor.', ja: 'センサーを使ったイコライジング練習の手順です。', zh: '使用传感器进行均压练习的步骤。', tw: '使用感測器進行均壓練習的步驟。' },
    'manual.s02b.step1': { ko: '1. 준비', en: '1. Preparation', ja: '1. 準備', zh: '1. 准备', tw: '1. 準備' },
    'manual.s02b.step1-desc': { ko: '기기 상단의 공기 유입구를 한쪽 콧구멍에 밀착하고, 반대쪽 코를 막습니다.', en: 'Place the air inlet on top of the device snugly against one nostril and block the other nostril.', ja: '機器上部の空気取入口を片方の鼻孔に密着させ、反対側の鼻を塞ぎます。', zh: '将设备顶部的进气口紧贴一侧鼻孔，堵住另一侧鼻孔。', tw: '將設備頂部的進氣口緊貼一側鼻孔，堵住另一側鼻孔。' },
    'manual.s02b.step2': { ko: '2. 실습', en: '2. Practice', ja: '2. 実習', zh: '2. 练习', tw: '2. 練習' },
    'manual.s02b.step2-desc': { ko: '발살바(Valsalva) 또는 프렌젤(Frenzel) 등 이퀄라이징 기법으로 압력을 형성합니다.', en: 'Build pressure using an equalization technique such as Valsalva or Frenzel.', ja: 'Valsalvaまたはフレンゼルなどのイコライジング技法で圧力を形成します。', zh: '使用Valsalva或Frenzel等均压技法形成压力。', tw: '使用Valsalva或Frenzel等均壓技法形成壓力。' },
    'manual.s02b.step3': { ko: '3. 확인', en: '3. Observe', ja: '3. 確認', zh: '3. 确认', tw: '3. 確認' },
    'manual.s02b.step3-desc': { ko: '화면의 실시간 그래프로 압력의 강도와 지속 시간을 관찰합니다.', en: 'Observe the pressure intensity and duration on the real-time graph.', ja: '画面のリアルタイムグラフで圧力の強度と持続時間を観察します。', zh: '通过屏幕上的实时图表观察压力强度和持续时间。', tw: '透過螢幕上的即時圖表觀察壓力強度和持續時間。' },
    'manual.s02b.step4': { ko: '4. 반복', en: '4. Repeat', ja: '4. 繰り返し', zh: '4. 重复', tw: '4. 重複' },
    'manual.s02b.step4-desc': { ko: '적정 압력 유지와 일정한 파형 형성을 목표로 반복 연습합니다.', en: 'Repeat practice aiming for consistent pressure and uniform waveforms.', ja: '適切な圧力の維持と一定した波形の形成を目指して繰り返し練習します。', zh: '以维持适当压力和形成一致波形为目标反复练习。', tw: '以維持適當壓力和形成一致波形為目標反覆練習。' },
    'manual.s01.lightning': { ko: '<strong>Lightning (iPhone 14 이하 / 구형 iPad)</strong> 사용자는 별도의 Lightning to USB-C 변환잭이 필요합니다. <strong>옵션 상품</strong>으로 구매하실 수 있습니다.', en: '<strong>Lightning (iPhone 14 or earlier / older iPad)</strong> users need a separate Lightning to USB-C adapter. Available as an <strong>optional accessory</strong>.', ja: '<strong>Lightning（iPhone 14以前 / 旧型iPad）</strong>をお使いの方は、別途Lightning to USB-C変換アダプターが必要です。<strong>オプション商品</strong>としてご購入いただけます。', zh: '<strong>Lightning（iPhone 14及更早 / 旧款iPad）</strong>用户需要另购Lightning转USB-C转换头。可作为<strong>可选配件</strong>购买。', tw: '<strong>Lightning（iPhone 14及更早 / 舊款iPad）</strong>使用者需要另購Lightning轉USB-C轉接頭。可作為<strong>選購配件</strong>購買。' },

    // ── MANUAL: App Screens ──
    'manual.s03': { ko: '앱 화면 안내', en: 'App Screens', ja: 'アプリ画面ガイド', zh: '应用界面指南', tw: '應用介面指南' },
    'manual.s03.desc': { ko: 'DiveChecker 앱의 주요 화면과 기능을 알아봅니다.', en: 'Explore the main screens and features of the DiveChecker app.', ja: 'DiveCheckerアプリの主要画面と機能をご紹介します。', zh: '了解DiveChecker应用的主要界面和功能。', tw: '了解DiveChecker應用的主要介面和功能。' },
    'manual.s03.home': { ko: '홈', en: 'Home', ja: 'ホーム', zh: '主页', tw: '主頁' },
    'manual.s03.home-desc': { ko: '디바이스 연결 상태, 실시간 압력값, 캘리브레이션, 정품 인증을 관리합니다.', en: 'Manage device connection status, real-time pressure values, calibration, and device authentication.', ja: 'デバイス接続状態、リアルタイム圧力値、キャリブレーション、正規品認証を管理します。', zh: '管理设备连接状态、实时压力值、校准和设备认证。', tw: '管理設備連接狀態、即時壓力值、校準和設備認證。' },
    'manual.s03.monitor': { ko: '모니터', en: 'Monitor', ja: 'モニター', zh: '监视器', tw: '監視器' },
    'manual.s03.monitor-desc': { ko: '30초 슬라이딩 윈도우로 실시간 압력 스트리밍을 확인합니다. 기록 없이 모니터링만 합니다.', en: 'View real-time pressure streaming with a 30-second sliding window. Monitoring only, no recording.', ja: '30秒のスライディングウィンドウでリアルタイムの圧力ストリーミングを確認します。記録なしのモニタリングのみです。', zh: '通过30秒滑动窗口查看实时压力流。仅监视，不记录。', tw: '透過30秒滑動窗口查看即時壓力流。僅監視，不記錄。' },
    'manual.s03.measure': { ko: '측정', en: 'Measure', ja: '測定', zh: '测量', tw: '測量' },
    'manual.s03.measure-desc': { ko: '시작/정지/일시정지 컨트롤로 세션을 기록합니다. 최대/평균 압력 통계가 실시간 표시됩니다.', en: 'Record sessions with start/stop/pause controls. Max/average pressure statistics are displayed in real time.', ja: '開始/停止/一時停止コントロールでセッションを記録します。最大/平均圧力統計がリアルタイムで表示されます。', zh: '使用开始/停止/暂停控件记录会话。最大/平均压力统计实时显示。', tw: '使用開始/停止/暫停控制項記錄會話。最大/平均壓力統計即時顯示。' },
    'manual.s03.history': { ko: '기록', en: 'History', ja: '履歴', zh: '记录', tw: '記錄' },
    'manual.s03.history-desc': { ko: '저장된 세션 목록을 확인하고, 디바이스별 필터링 및 상세 그래프를 봅니다.', en: 'View saved session list, filter by device, and view detailed graphs.', ja: '保存されたセッション一覧を確認し、デバイス別のフィルタリングや詳細グラフを表示します。', zh: '查看已保存的会话列表，按设备筛选并查看详细图表。', tw: '查看已儲存的會話列表，按設備篩選並查看詳細圖表。' },
    'manual.s03.graph': { ko: '그래프 상세', en: 'Graph Detail', ja: 'グラフ詳細', zh: '图表详情', tw: '圖表詳情' },
    'manual.s03.graph-desc': { ko: '핀치 줌/드래그로 세션을 탐색합니다. 특정 시점에 메모를 추가할 수 있습니다.', en: 'Explore sessions with pinch-zoom and drag. Add notes at specific points in time.', ja: 'ピンチズーム/ドラッグでセッションを探索します。特定のタイミングにメモを追加できます。', zh: '通过捏合缩放/拖拽浏览会话。可在特定时间点添加备注。', tw: '透過捏合縮放/拖曳瀏覽會話。可在特定時間點添加備註。' },
    'manual.s03.peak': { ko: '피크 분석', en: 'Peak Analysis', ja: 'ピーク分析', zh: '峰值分析', tw: '峰值分析' },
    'manual.s03.peak-desc': { ko: '리듬, 압력, 기법, 피로도 4가지 지표로 이퀄라이징 품질을 S~F 등급으로 평가합니다.', en: 'Evaluates equalization quality with S–F grades based on four metrics: rhythm, pressure, technique, and fatigue.', ja: 'リズム、圧力、技法、疲労度の4つの指標でイコライジング品質をS〜Fのグレードで評価します。', zh: '通过节奏、压力、技法、疲劳度4项指标，以S~F等级评估均压质量。', tw: '透過節奏、壓力、技法、疲勞度4項指標，以S~F等級評估均壓品質。' },

    // ── MANUAL: Equalization Techniques ──
    'manual.s04': { ko: '이퀄라이징 기법 가이드', en: 'Equalization Technique Guide', ja: 'イコライジング技法ガイド', zh: '均压技法指南', tw: '均壓技法指南' },
    'manual.s04.desc': { ko: '각 기법의 그래프 패턴을 알면 자신의 이퀄라이징을 정확히 판별할 수 있습니다.', en: 'Knowing the graph pattern of each technique helps you accurately identify your equalization.', ja: '各技法のグラフパターンを知れば、自分のイコライジングを正確に判別できます。', zh: '了解每种技法的图表模式，就能准确判别自己的均压方式。', tw: '了解每種技法的圖表模式，就能準確判別自己的均壓方式。' },
    'manual.s04.badge-basic': { ko: '기본', en: 'Basic', ja: '基本', zh: '基础', tw: '基礎' },
    'manual.s04.badge-mid': { ko: '중급', en: 'Intermediate', ja: '中級', zh: '中级', tw: '中級' },
    'manual.s04.badge-adv': { ko: '고급', en: 'Advanced', ja: '上級', zh: '高级', tw: '高級' },
    'manual.s04.valsalva-kr': { ko: '발살바', en: 'Valsalva', ja: 'バルサルバ', zh: 'Valsalva', tw: 'Valsalva' },
    'manual.s04.valsalva-desc': { ko: '코를 막고 복부/흉부 압력으로 공기를 밀어내는 기법', en: 'A technique that pushes air using abdominal/chest pressure while pinching the nose', ja: '鼻をつまみ、腹部/胸部の圧力で空気を押し出す技法', zh: '捏住鼻子，利用腹部/胸部压力推送空气的技法', tw: '捏住鼻子，利用腹部/胸部壓力推送空氣的技法' },
    'manual.s04.pattern': { ko: '그래프 패턴', en: 'Graph Pattern', ja: 'グラフパターン', zh: '图表模式', tw: '圖表模式' },
    'manual.s04.valsalva-pattern': { ko: '천천히 올라가는 <strong>둥근 커브</strong>. 상승/하강이 느리고 피크 폭이 넓습니다.', en: 'A slowly rising <strong>rounded curve</strong>. Slow rise/fall with a wide peak.', ja: 'ゆっくり上昇する<strong>丸みのあるカーブ</strong>。上昇/下降が遅く、ピーク幅が広いです。', zh: '缓慢上升的<strong>圆弧曲线</strong>。上升/下降缓慢，峰值较宽。', tw: '緩慢上升的<strong>圓弧曲線</strong>。上升/下降緩慢，峰值較寬。' },
    'manual.s04.valsalva-warn': { ko: '과도한 힘은 고막 손상 위험. 과압 경고 시 즉시 중단하세요.', en: 'Excessive force risks eardrum damage. Stop immediately when an overpressure warning appears.', ja: '過度な力は鼓膜損傷の危険があります。過圧警告が出たら直ちに中止してください。', zh: '过度用力有鼓膜损伤风险。出现过压警告时请立即停止。', tw: '過度用力有鼓膜損傷風險。出現過壓警告時請立即停止。' },
    'manual.s04.frenzel-kr': { ko: '프렌젤', en: 'Frenzel', ja: 'フレンゼル', zh: 'Frenzel', tw: 'Frenzel' },
    'manual.s04.frenzel-desc': { ko: '혀뿌리를 입천장으로 밀어 올려 공기를 압축하는 기법', en: 'A technique that compresses air by pushing the tongue root up against the palate', ja: '舌根を口蓋に押し上げて空気を圧縮する技法', zh: '将舌根推向上颚压缩空气的技法', tw: '將舌根推向上顎壓縮空氣的技法' },
    'manual.s04.frenzel-pattern': { ko: '빠르고 <strong>날카로운 스파이크</strong>. 상승/하강이 빠르고 피크 폭이 좁습니다.', en: 'A fast, <strong>sharp spike</strong>. Rapid rise/fall with a narrow peak.', ja: '速く<strong>鋭いスパイク</strong>。上昇/下降が速く、ピーク幅が狭いです。', zh: '快速的<strong>尖锐脉冲</strong>。上升/下降快，峰值较窄。', tw: '快速的<strong>尖銳脈衝</strong>。上升/下降快，峰值較窄。' },
    'manual.s04.frenzel-tip': { ko: '"K" 또는 "T" 발음 동작으로 연습해 보세요.', en: 'Try practicing with a "K" or "T" tongue motion.', ja: '「K」または「T」の発音動作で練習してみましょう。', zh: '尝试用发"K"或"T"音的舌头动作来练习。', tw: '嘗試用發"K"或"T"音的舌頭動作來練習。' },
    'manual.s04.mouthfill-kr': { ko: '마우스필', en: 'Mouthfill', ja: 'マウスフィル', zh: 'Mouthfill', tw: 'Mouthfill' },
    'manual.s04.mouthfill-desc': { ko: '성문을 닫고 입안의 공기만으로 이퀄라이징하는 기법', en: 'A technique that equalizes using only the air in the mouth with the glottis closed', ja: '声門を閉じ、口の中の空気だけでイコライジングする技法', zh: '关闭声门，仅用口腔内空气进行均压的技法', tw: '關閉聲門，僅用口腔內空氣進行均壓的技法' },
    'manual.s04.mouthfill-pattern': { ko: '초기 높은 피크 후 점차 <strong>감소하는 연속 피크</strong>. 입안 공기가 줄어들며 압력이 낮아집니다.', en: 'An initially high peak followed by progressively <strong>decreasing consecutive peaks</strong>. Pressure drops as the air in the mouth depletes.', ja: '初期の高いピークの後、徐々に<strong>減少する連続ピーク</strong>。口の中の空気が減り、圧力が下がります。', zh: '初始高峰后逐渐<strong>递减的连续峰值</strong>。随着口腔空气减少，压力降低。', tw: '初始高峰後逐漸<strong>遞減的連續峰值</strong>。隨著口腔空氣減少，壓力降低。' },
    'manual.s04.btv-kr': { ko: '핸즈프리', en: 'Hands-free', ja: 'ハンズフリー', zh: 'Hands-free', tw: 'Hands-free' },
    'manual.s04.btv-desc': { ko: '유스타키오관의 자발적 개방. 코를 막지 않고 이퀄라이징합니다.', en: 'Voluntary opening of the Eustachian tube. Equalization without pinching the nose.', ja: '耳管の自発的開放。鼻をつままずにイコライジングします。', zh: '自主开放咽鼓管。无需捏鼻即可均压。', tw: '自主開放咽鼓管。無需捏鼻即可均壓。' },
    'manual.s04.btv-pattern': { ko: '매우 <strong>미세한 압력 변화</strong>. 피크가 작지만 일정한 패턴을 보입니다.', en: 'Very <strong>subtle pressure changes</strong>. Small peaks but a consistent pattern.', ja: '非常に<strong>微細な圧力変化</strong>。ピークは小さいですが、一定のパターンを示します。', zh: '非常<strong>微小的压力变化</strong>。峰值虽小但呈现一致的模式。', tw: '非常<strong>微小的壓力變化</strong>。峰值雖小但呈現一致的模式。' },

    // ── MANUAL: Peak Analysis ──
    'manual.s05': { ko: '피크 분석 읽는 법', en: 'How to Read Peak Analysis', ja: 'ピーク分析の読み方', zh: '如何阅读峰值分析', tw: '如何閱讀峰值分析' },
    'manual.s05.desc': { ko: '4가지 지표로 이퀄라이징 품질을 객관적으로 평가합니다.', en: 'Objectively evaluate equalization quality with four metrics.', ja: '4つの指標でイコライジング品質を客観的に評価します。', zh: '通过4项指标客观评估均压质量。', tw: '透過4項指標客觀評估均壓品質。' },
    'manual.s05.m1': { ko: '리듬 점수', en: 'Rhythm Score', ja: 'リズムスコア', zh: '节奏评分', tw: '節奏評分' },
    'manual.s05.m1-desc': { ko: '피크 간격의 일관성. 변동계수(CV) 기반 — 높을수록 규칙적인 이퀄라이징.', en: 'Consistency of peak intervals. Based on coefficient of variation (CV) — higher means more regular equalization.', ja: 'ピーク間隔の一貫性。変動係数（CV）基準 — 高いほど規則的なイコライジング。', zh: '峰值间隔的一致性。基于变异系数(CV)——越高表示均压越规律。', tw: '峰值間隔的一致性。基於變異係數(CV)——越高表示均壓越規律。' },
    'manual.s05.m2': { ko: '압력 점수', en: 'Pressure Score', ja: '圧力スコア', zh: '压力评分', tw: '壓力評分' },
    'manual.s05.m2-desc': { ko: '피크 강도의 균일성. 매번 일정한 힘으로 이퀄라이징하는지 평가.', en: 'Uniformity of peak intensity. Evaluates whether you equalize with consistent force each time.', ja: 'ピーク強度の均一性。毎回一定の力でイコライジングしているか評価。', zh: '峰值强度的均匀性。评估每次均压力度是否一致。', tw: '峰值強度的均勻性。評估每次均壓力度是否一致。' },
    'manual.s05.m3': { ko: '기법 점수', en: 'Technique Score', ja: '技法スコア', zh: '技法评分', tw: '技法評分' },
    'manual.s05.m3-desc': { ko: '상승/하강 시간, 피크 폭 분석. 날카로운 피크 = 프렌젤에 가까움.', en: 'Rise/fall time and peak width analysis. Sharp peaks = closer to Frenzel.', ja: '上昇/下降時間、ピーク幅の分析。鋭いピーク＝フレンゼルに近い。', zh: '上升/下降时间和峰宽分析。尖锐峰值 = 接近Frenzel。', tw: '上升/下降時間和峰寬分析。尖銳峰值 = 接近Frenzel。' },
    'manual.s05.m4': { ko: '피로도 지수', en: 'Fatigue Index', ja: '疲労度指数', zh: '疲劳指数', tw: '疲勞指數' },
    'manual.s05.m4-desc': { ko: '세션 후반부 압력 감소 추세. 높으면 근육 피로가 누적 중.', en: 'Pressure decline trend in the latter half of the session. High value indicates accumulating muscle fatigue.', ja: 'セッション後半の圧力減少傾向。高いと筋肉疲労が蓄積中。', zh: '会话后半段的压力下降趋势。数值高表示肌肉疲劳正在累积。', tw: '會話後半段的壓力下降趨勢。數值高表示肌肉疲勞正在累積。' },
    'manual.s05.grade-title': { ko: '종합 등급', en: 'Overall Grade', ja: '総合グレード', zh: '综合等级', tw: '綜合等級' },
    'manual.s05.grade-s': { ko: '완벽', en: 'Perfect', ja: '完璧', zh: '完美', tw: '完美' },
    'manual.s05.grade-a': { ko: '우수', en: 'Excellent', ja: '優秀', zh: '优秀', tw: '優秀' },
    'manual.s05.grade-b': { ko: '양호', en: 'Good', ja: '良好', zh: '良好', tw: '良好' },
    'manual.s05.grade-c': { ko: '보통', en: 'Average', ja: '普通', zh: '一般', tw: '一般' },
    'manual.s05.grade-d': { ko: '미흡', en: 'Poor', ja: '不十分', zh: '不足', tw: '不足' },
    'manual.s05.grade-f': { ko: '부족', en: 'Insufficient', ja: '不足', zh: '不及格', tw: '不及格' },
    'manual.s05.grade-note': { ko: '4가지 지표의 가중 평균으로 산출됩니다. 꾸준한 연습으로 등급을 올려보세요!', en: 'Calculated as a weighted average of the four metrics. Keep practicing to improve your grade!', ja: '4つの指標の加重平均で算出されます。練習を重ねてグレードを上げましょう！', zh: '由4项指标的加权平均计算得出。坚持练习提升等级吧！', tw: '由4項指標的加權平均計算得出。堅持練習提升等級吧！' },

    // ── MANUAL: Care & Cleaning ──
    'manual.care': { ko: '청소 및 관리', en: 'Care & Cleaning', ja: 'お手入れ・メンテナンス', zh: '清洁与保养', tw: '清潔與保養' },
    'manual.care.desc': { ko: '센서의 정확도와 위생을 유지하기 위해 정기적으로 청소해 주세요.', en: 'Clean regularly to maintain sensor accuracy and hygiene.', ja: 'センサーの精度と衛生を保つため、定期的にお手入れしてください。', zh: '请定期清洁以保持传感器的精度和卫生。', tw: '請定期清潔以保持感測器的精度和衛生。' },
    'manual.care.clean-title': { ko: '센서 유입구 청소', en: 'Sensor Inlet Cleaning', ja: 'センサー取入口の清掃', zh: '传感器进气口清洁', tw: '感測器進氣口清潔' },
    'manual.care.clean-desc': { ko: '<strong>얇은 면봉</strong> 또는 옵션으로 제공되는 <strong>전용 청소 도구</strong>를 사용하여 공기 유입구의 이물질을 부드럽게 제거합니다.', en: 'Gently remove debris from the air inlet using a <strong>thin cotton swab</strong> or the <strong>dedicated cleaning tool</strong> available as an optional accessory.', ja: '<strong>細い綿棒</strong>またはオプションの<strong>専用クリーニングツール</strong>を使い、空気取入口の異物をやさしく除去します。', zh: '使用<strong>细棉签</strong>或可选配件中的<strong>专用清洁工具</strong>轻柔地清除进气口异物。', tw: '使用<strong>細棉花棒</strong>或選購配件中的<strong>專用清潔工具</strong>輕柔地清除進氣口異物。' },
    'manual.care.donot-title': { ko: '주의 사항', en: 'Precautions', ja: '注意事項', zh: '注意事项', tw: '注意事項' },
    'manual.care.donot1': { ko: '물이나 액체로 직접 세척하지 마세요', en: 'Do not wash directly with water or liquids', ja: '水や液体で直接洗わないでください', zh: '请勿直接用水或液体清洗', tw: '請勿直接用水或液體清洗' },
    'manual.care.donot2': { ko: '뾰족한 도구로 센서 홀을 찌르지 마세요', en: 'Do not poke the sensor hole with sharp tools', ja: '尖った道具でセンサーホールを突かないでください', zh: '请勿用尖锐工具戳传感器孔', tw: '請勿用尖銳工具戳感測器孔' },
    'manual.care.donot3': { ko: '에어 스프레이를 직접 분사하지 마세요', en: 'Do not spray compressed air directly', ja: 'エアスプレーを直接噴射しないでください', zh: '请勿直接喷射压缩空气', tw: '請勿直接噴射壓縮空氣' },
    'manual.care.store-title': { ko: '보관 방법', en: 'Storage', ja: '保管方法', zh: '存放方法', tw: '存放方法' },
    'manual.care.store-desc': { ko: '사용 후 건조하고 서늘한 곳에 보관해 주세요. 직사광선 및 고온 환경을 피하세요.', en: 'Store in a dry, cool place after use. Avoid direct sunlight and high-temperature environments.', ja: '使用後は乾燥した涼しい場所に保管してください。直射日光や高温環境を避けてください。', zh: '使用后请存放在干燥凉爽处。避免阳光直射和高温环境。', tw: '使用後請存放在乾燥涼爽處。避免陽光直射和高溫環境。' },
    'manual.care.option-tip': { ko: '전용 청소 도구 및 Lightning 변환잭은 <strong>옵션 상품</strong>으로 별도 구매하실 수 있습니다.', en: 'The dedicated cleaning tool and Lightning adapter are available for separate purchase as <strong>optional accessories</strong>.', ja: '専用クリーニングツールおよびLightning変換アダプターは<strong>オプション商品</strong>として別途ご購入いただけます。', zh: '专用清洁工具和Lightning转接头可作为<strong>可选配件</strong>另行购买。', tw: '專用清潔工具和Lightning轉接頭可作為<strong>選購配件</strong>另行購買。' },

    // ── MANUAL: Calibration ──
    'manual.cal': { ko: '캘리브레이션', en: 'Calibration', ja: 'キャリブレーション', zh: '校准', tw: '校準' },
    'manual.cal.desc': { ko: '현재 대기압을 0 hPa 기준으로 설정하는 과정입니다. <strong>매 세션 시작 전</strong> 권장합니다.', en: 'The process of setting the current atmospheric pressure as the 0 hPa baseline. Recommended <strong>before every session</strong>.', ja: '現在の大気圧を0 hPa基準に設定するプロセスです。<strong>毎セッション開始前</strong>に推奨します。', zh: '将当前大气压设置为0 hPa基准的过程。建议<strong>每次开始会话前</strong>执行。', tw: '將當前大氣壓設置為0 hPa基準的過程。建議<strong>每次開始會話前</strong>執行。' },
    'manual.cal.process': { ko: '캘리브레이션 과정', en: 'Calibration Process', ja: 'キャリブレーション手順', zh: '校准过程', tw: '校準過程' },
    'manual.cal.step1': { ko: '센서에서 입/코를 떼고 자연 상태로 둡니다', en: 'Remove your mouth/nose from the sensor and leave it in its natural state', ja: 'センサーから口/鼻を離し、自然な状態にします', zh: '将口/鼻从传感器移开，保持自然状态', tw: '將口/鼻從感測器移開，保持自然狀態' },
    'manual.cal.step2': { ko: '앱에서 "캘리브레이션" 버튼을 탭합니다', en: 'Tap the "Calibration" button in the app', ja: 'アプリで「キャリブレーション」ボタンをタップします', zh: '在应用中点击"校准"按钮', tw: '在應用中點擊"校準"按鈕' },
    'manual.cal.step3': { ko: '3초간 대기압 샘플을 수집합니다', en: 'Atmospheric pressure samples are collected for 3 seconds', ja: '3秒間、大気圧サンプルを収集します', zh: '收集3秒的大气压样本', tw: '收集3秒的大氣壓樣本' },
    'manual.cal.step4': { ko: '평균값이 자동으로 기준점(baseline)으로 설정됩니다', en: 'The average value is automatically set as the baseline', ja: '平均値が自動的に基準点（ベースライン）として設定されます', zh: '平均值将自动设置为基准点（baseline）', tw: '平均值將自動設置為基準點（baseline）' },
    'manual.cal.tip': { ko: '고도가 변하거나 장소를 이동한 후에는 반드시 재캘리브레이션하세요. 대기압 변화가 측정값에 영향을 줍니다.', en: 'Always recalibrate after changing altitude or location. Atmospheric pressure changes affect measurement values.', ja: '高度が変わったり場所を移動した後は、必ず再キャリブレーションしてください。気圧の変化が測定値に影響します。', zh: '更换海拔或位置后请务必重新校准。大气压变化会影响测量值。', tw: '更換海拔或位置後請務必重新校準。大氣壓變化會影響測量值。' },

    // ── MANUAL: Firmware Update ──
    'manual.fw': { ko: '펌웨어 업데이트', en: 'Firmware Update', ja: 'ファームウェアアップデート', zh: '固件更新', tw: '韌體更新' },
    'manual.fw.desc': { ko: '앱의 설정 탭에서 펌웨어 버전을 확인하고, 최신 버전으로 업데이트할 수 있습니다.', en: 'Check the firmware version in the app\'s settings tab and update to the latest version.', ja: 'アプリの設定タブでファームウェアバージョンを確認し、最新バージョンにアップデートできます。', zh: '在应用的设置页面中查看固件版本并更新到最新版本。', tw: '在應用的設定頁面中查看韌體版本並更新到最新版本。' },
    'manual.fw.step1': { ko: '현재 버전 확인', en: 'Check Current Version', ja: '現在のバージョンを確認', zh: '确认当前版本', tw: '確認當前版本' },
    'manual.fw.step1-desc': { ko: '설정 → 디바이스 설정에서 현재 펌웨어 버전을 확인합니다.', en: 'Check the current firmware version in Settings → Device Settings.', ja: '設定 → デバイス設定で現在のファームウェアバージョンを確認します。', zh: '在设置 → 设备设置中确认当前固件版本。', tw: '在設定 → 設備設定中確認當前韌體版本。' },
    'manual.fw.step2': { ko: '업데이트 시작', en: 'Start Update', ja: 'アップデート開始', zh: '开始更新', tw: '開始更新' },
    'manual.fw.step2-desc': { ko: '"펌웨어 업데이트" 버튼을 탭하면 디바이스가 BOOTSEL 모드로 재부팅됩니다.', en: 'Tap the "Firmware Update" button and the device will reboot into BOOTSEL mode.', ja: '「ファームウェアアップデート」ボタンをタップすると、デバイスがBOOTSELモードで再起動します。', zh: '点击"固件更新"按钮，设备将重启进入BOOTSEL模式。', tw: '點擊"韌體更新"按鈕，設備將重新啟動進入BOOTSEL模式。' },
    'manual.fw.step3': { ko: 'UF2 파일 복사', en: 'Copy UF2 File', ja: 'UF2ファイルのコピー', zh: '复制UF2文件', tw: '複製UF2檔案' },
    'manual.fw.step3-desc': { ko: 'PC에서 USB 드라이브로 인식된 DiveChecker에 .uf2 파일을 드래그 앤 드롭합니다.', en: 'Drag and drop the .uf2 file onto DiveChecker, which appears as a USB drive on your PC.', ja: 'PCでUSBドライブとして認識されたDiveCheckerに.uf2ファイルをドラッグ＆ドロップします。', zh: '将.uf2文件拖放到PC上识别为USB驱动器的DiveChecker中。', tw: '將.uf2檔案拖放到PC上識別為USB磁碟機的DiveChecker中。' },
    'manual.fw.step4': { ko: '자동 재부팅', en: 'Auto Reboot', ja: '自動再起動', zh: '自动重启', tw: '自動重新啟動' },
    'manual.fw.step4-desc': { ko: '업로드가 완료되면 자동으로 재부팅되어 새 펌웨어로 동작합니다.', en: 'Once the upload is complete, it automatically reboots and runs the new firmware.', ja: 'アップロードが完了すると自動的に再起動し、新しいファームウェアで動作します。', zh: '上传完成后将自动重启并运行新固件。', tw: '上傳完成後將自動重新啟動並執行新韌體。' },

    // ── MANUAL: Troubleshooting ──
    'manual.s07': { ko: '문제 해결', en: 'Troubleshooting', ja: 'トラブルシューティング', zh: '故障排除', tw: '故障排除' },
    'manual.s07.q1': { ko: '디바이스가 인식되지 않아요', en: 'The device is not recognized', ja: 'デバイスが認識されません', zh: '设备未被识别', tw: '設備未被識別' },
    'manual.s07.q1-a1': { ko: '충전 전용 케이블이 아닌 <strong>데이터 케이블</strong>인지 확인', en: 'Make sure you are using a <strong>data cable</strong>, not a charge-only cable', ja: '充電専用ケーブルではなく<strong>データケーブル</strong>であることを確認', zh: '确认使用的是<strong>数据线</strong>而非充电专用线', tw: '確認使用的是<strong>數據線</strong>而非充電專用線' },
    'manual.s07.q1-a2': { ko: '다른 USB 포트에 연결해 보기', en: 'Try connecting to a different USB port', ja: '別のUSBポートに接続してみてください', zh: '尝试连接到其他USB端口', tw: '嘗試連接到其他USB端口' },
    'manual.s07.q1-a3': { ko: '케이블을 분리했다가 다시 연결', en: 'Disconnect and reconnect the cable', ja: 'ケーブルを外して再接続', zh: '断开并重新连接数据线', tw: '斷開並重新連接數據線' },
    'manual.s07.q1-a4': { ko: 'Android: <strong>USB OTG 설정</strong>이 켜져 있는지 확인', en: 'Android: Make sure <strong>USB OTG setting</strong> is enabled', ja: 'Android: <strong>USB OTG設定</strong>がオンになっていることを確認', zh: 'Android：确认<strong>USB OTG设置</strong>已开启', tw: 'Android：確認<strong>USB OTG設定</strong>已開啟' },
    'manual.s07.q1-a5': { ko: 'iOS: USB-C iPhone 15 이상 / USB-C iPad만 지원 (Lightning은 변환잭 필요)', en: 'iOS: Only USB-C iPhone 15 or later / USB-C iPad supported (Lightning requires an adapter)', ja: 'iOS: USB-C iPhone 15以降 / USB-C iPadのみ対応（Lightningは変換アダプター必要）', zh: 'iOS：仅支持USB-C iPhone 15及以上 / USB-C iPad（Lightning需要转接头）', tw: 'iOS：僅支援USB-C iPhone 15及以上 / USB-C iPad（Lightning需要轉接頭）' },
    'manual.s07.q2': { ko: '그래프가 움직이지 않아요', en: 'The graph is not moving', ja: 'グラフが動きません', zh: '图表没有动', tw: '圖表沒有動' },
    'manual.s07.q2-a1': { ko: '캘리브레이션을 다시 진행', en: 'Run calibration again', ja: 'キャリブレーションをやり直してください', zh: '重新进行校准', tw: '重新進行校準' },
    'manual.s07.q2-a2': { ko: '센서 홀에 이물질이 없는지 확인', en: 'Check if the sensor hole is free of debris', ja: 'センサーホールに異物がないか確認', zh: '检查传感器孔是否有异物', tw: '檢查感測器孔是否有異物' },
    'manual.s07.q2-a3': { ko: '앱을 종료 후 재실행', en: 'Close and restart the app', ja: 'アプリを終了して再起動', zh: '关闭应用后重新启动', tw: '關閉應用後重新啟動' },
    'manual.s07.q3': { ko: '압력 값이 비정상적이에요', en: 'Pressure values are abnormal', ja: '圧力値が異常です', zh: '压力值异常', tw: '壓力值異常' },
    'manual.s07.q3-a1': { ko: '캘리브레이션을 다시 진행', en: 'Run calibration again', ja: 'キャリブレーションをやり直してください', zh: '重新进行校准', tw: '重新進行校準' },
    'manual.s07.q3-a2': { ko: '센서에 수분이 들어가지 않았는지 확인', en: 'Check if moisture has entered the sensor', ja: 'センサーに水分が入っていないか確認', zh: '检查传感器是否进水', tw: '檢查感測器是否進水' },
    'manual.s07.q3-a3': { ko: '급격한 온도 변화 후에는 <strong>10분 안정화</strong> 후 사용', en: 'After rapid temperature changes, wait <strong>10 minutes to stabilize</strong> before use', ja: '急激な温度変化の後は<strong>10分間安定化</strong>してからご使用ください', zh: '温度急剧变化后，请等待<strong>10分钟稳定</strong>后再使用', tw: '溫度急劇變化後，請等待<strong>10分鐘穩定</strong>後再使用' },
    'manual.s07.q4': { ko: 'LED가 켜지지 않아요', en: 'The LED does not turn on', ja: 'LEDが点灯しません', zh: 'LED不亮', tw: 'LED不亮' },
    'manual.s07.q4-a1': { ko: '케이블이 제대로 꽂혀 있는지 확인', en: 'Check if the cable is properly connected', ja: 'ケーブルがしっかり差し込まれているか確認', zh: '检查数据线是否正确连接', tw: '檢查數據線是否正確連接' },
    'manual.s07.q4-a2': { ko: '다른 기기에 연결해서 테스트', en: 'Test by connecting to a different device', ja: '別のデバイスに接続してテスト', zh: '尝试连接到其他设备进行测试', tw: '嘗試連接到其他設備進行測試' },
    'manual.s07.q4-a3': { ko: '문제 지속 시 <a href="support.html">고객 지원</a>에 문의', en: 'If the problem persists, contact <a href="support.html">customer support</a>', ja: '問題が続く場合は<a href="support.html">カスタマーサポート</a>にお問い合わせください', zh: '如问题持续，请联系<a href="support.html">客户支持</a>', tw: '如問題持續，請聯繫<a href="support.html">客戶支持</a>' },

    // ── MANUAL: Warranty & A/S ──
    'manual.s08': { ko: '보증 및 A/S', en: 'Warranty & After-Sales Service', ja: '保証およびアフターサービス', zh: '保修与售后服务', tw: '保固與售後服務' },
    'manual.s08.period': { ko: '무상 A/S 기간', en: 'Free A/S Period', ja: '無償A/S期間', zh: '免费售后期限', tw: '免費售後期限' },
    'manual.s08.duration': { ko: '구매일로부터 <strong>1개월 이내</strong>', en: 'Within <strong>1 month</strong> from purchase date', ja: 'ご購入日から<strong>1ヶ月以内</strong>', zh: '自购买之日起<strong>1个月内</strong>', tw: '自購買之日起<strong>1個月內</strong>' },
    'manual.s08.desc': { ko: '제품 자체 결함에 한하여 무상 A/S가 제공됩니다. 구매 영수증 등 구매 증빙을 첨부하여 이메일로 신청해 주세요.', en: 'Free after-sales service is provided only for product defects. Please apply via email with proof of purchase such as a receipt.', ja: '製品自体の欠陥に限り、無償A/Sが提供されます。購入レシート等の購入証明を添付してメールでお申し込みください。', zh: '仅限产品本身缺陷提供免费售后服务。请附上购买收据等购买凭证通过邮件申请。', tw: '僅限產品本身缺陷提供免費售後服務。請附上購買收據等購買憑證透過郵件申請。' },
    'manual.s08.exclude-title': { ko: '보증 제외 사항', en: 'Warranty Exclusions', ja: '保証除外事項', zh: '保修除外事项', tw: '保固除外事項' },
    'manual.s08.ex1': { ko: '침수 또는 이물질 유입으로 인한 고장', en: 'Malfunction caused by water immersion or foreign object intrusion', ja: '浸水または異物混入による故障', zh: '因浸水或异物进入导致的故障', tw: '因浸水或異物進入導致的故障' },
    'manual.s08.ex2': { ko: '사용자 과실에 의한 파손 및 변형', en: 'Damage or deformation caused by user negligence', ja: 'ユーザーの過失による破損および変形', zh: '因用户过失导致的损坏及变形', tw: '因使用者過失導致的損壞及變形' },
    'manual.s08.ex3': { ko: '분해 또는 개조로 인한 고장', en: 'Malfunction caused by disassembly or modification', ja: '分解または改造による故障', zh: '因拆解或改装导致的故障', tw: '因拆解或改裝導致的故障' },
    'manual.s08.contact': { ko: 'A/S 문의', en: 'A/S Inquiry', ja: 'A/Sお問い合わせ', zh: '售后咨询', tw: '售後諮詢' },

    // ── MANUAL: Safety & Disclaimer ──
    'manual.safety-title': { ko: '안전 및 주의사항', en: 'Safety & Precautions', ja: '安全および注意事項', zh: '安全及注意事项', tw: '安全及注意事項' },
    'manual.safety1': { ko: '<strong>교육 및 실습 전용</strong> — 이퀄라이징 기술 향상을 위한 학습기이며, 그 외의 목적으로 사용할 수 없습니다.', en: '<strong>For training and practice only</strong> — This is a learning device for improving equalization skills and cannot be used for any other purpose.', ja: '<strong>教育・練習専用</strong> — イコライジング技術向上のための学習器であり、それ以外の目的には使用できません。', zh: '<strong>仅供教育和练习使用</strong> — 这是一款用于提升均压技能的学习设备，不可用于其他目的。', tw: '<strong>僅供教育和練習使用</strong> — 這是一款用於提升均壓技能的學習設備，不可用於其他目的。' },
    'manual.safety2': { ko: '<strong>의료기기 아님</strong> — 이관 기능 장애, 중이염 등 질환의 진단/예방/치료 목적으로 사용할 수 없으며, 의료기기로 허가/인증된 제품이 아닙니다.', en: '<strong>Not a medical device</strong> — Cannot be used for diagnosis, prevention, or treatment of conditions such as Eustachian tube dysfunction or otitis media, and is not approved or certified as a medical device.', ja: '<strong>医療機器ではありません</strong> — 耳管機能障害、中耳炎等の疾患の診断/予防/治療目的には使用できず、医療機器として許可/認証された製品ではありません。', zh: '<strong>非医疗器械</strong> — 不可用于咽鼓管功能障碍、中耳炎等疾病的诊断/预防/治疗目的，且未获得医疗器械许可/认证。', tw: '<strong>非醫療器材</strong> — 不可用於咽鼓管功能障礙、中耳炎等疾病的診斷/預防/治療目的，且未獲得醫療器材許可/認證。' },
    'manual.safety3': { ko: '<strong>통증 발생 시 즉시 중단</strong> — 귀 또는 코에 통증이 느껴지면 즉시 사용을 중단하십시오.', en: '<strong>Stop immediately if pain occurs</strong> — Discontinue use immediately if you feel pain in your ears or nose.', ja: '<strong>痛みが生じた場合は直ちに中止</strong> — 耳または鼻に痛みを感じた場合は、直ちに使用を中止してください。', zh: '<strong>出现疼痛时立即停止</strong> — 如果感到耳朵或鼻子疼痛，请立即停止使用。', tw: '<strong>出現疼痛時立即停止</strong> — 如果感到耳朵或鼻子疼痛，請立即停止使用。' },
    'manual.safety5': { ko: '<strong>방수 아님</strong> — 물/이물질이 유입되지 않도록 주의. 사용 후 건조하고 서늘한 곳에 보관.', en: '<strong>Not waterproof</strong> — Take care to prevent water/foreign object intrusion. Store in a dry, cool place after use.', ja: '<strong>防水ではありません</strong> — 水/異物が入らないようご注意ください。使用後は乾燥した涼しい場所に保管。', zh: '<strong>非防水产品</strong> — 请注意防止水/异物进入。使用后存放在干燥凉爽处。', tw: '<strong>非防水產品</strong> — 請注意防止水/異物進入。使用後存放在乾燥涼爽處。' },
    'manual.mfg-title': { ko: '제조 품질 안내', en: 'Manufacturing Quality Notice', ja: '製造品質のご案内', zh: '制造质量说明', tw: '製造品質說明' },
    'manual.mfg1': { ko: '제조 과정에서 발생하는 <strong>미세한 스크래치나 표면 질감의 차이</strong>는 제품 불량이 아닌 공정 특성입니다.', en: '<strong>Minor scratches or surface texture variations</strong> that occur during manufacturing are characteristics of the process, not product defects.', ja: '製造工程で生じる<strong>微細な傷や表面質感の違い</strong>は製品不良ではなく、工程上の特性です。', zh: '制造过程中产生的<strong>细微划痕或表面质感差异</strong>属于工艺特性，非产品缺陷。', tw: '製造過程中產生的<strong>細微刮痕或表面質感差異</strong>屬於工藝特性，非產品缺陷。' },
    'manual.mfg2': { ko: '외관에 미세한 표면 차이가 있을 수 있으며, 이는 제품의 기능 및 성능에 영향을 주지 않습니다.', en: 'There may be slight surface differences in appearance, which do not affect the product\'s function or performance.', ja: '外観に微細な表面差異がある場合がありますが、製品の機能および性能には影響しません。', zh: '外观可能存在细微的表面差异，这不影响产品的功能和性能。', tw: '外觀可能存在細微的表面差異，這不影響產品的功能和性能。' },
    'manual.mfg3': { ko: '상기 사유로 인한 교환/반품은 불가합니다.', en: 'Exchanges or returns for the above reasons are not accepted.', ja: '上記の理由による交換/返品はお受けできません。', zh: '因上述原因的换货/退货不予受理。', tw: '因上述原因的換貨/退貨不予受理。' },

    // ── MANUAL: Contact Form ──
    'manual.contact-title': { ko: '문의하기', en: 'Contact Us', ja: 'お問い合わせ', zh: '联系我们', tw: '聯繫我們' },
    'manual.contact-desc': { ko: '제품 관련 문의사항이 있으시면 아래 양식을 작성해 주세요.', en: 'If you have any product inquiries, please fill out the form below.', ja: '製品に関するお問い合わせは、下記フォームにご記入ください。', zh: '如有产品相关咨询，请填写下方表单。', tw: '如有產品相關諮詢，請填寫下方表單。' },
    'manual.contact.name': { ko: '이름 <span class="required">*</span>', en: 'Name <span class="required">*</span>', ja: 'お名前 <span class="required">*</span>', zh: '姓名 <span class="required">*</span>', tw: '姓名 <span class="required">*</span>' },
    'manual.contact.email': { ko: '이메일 <span class="required">*</span>', en: 'Email <span class="required">*</span>', ja: 'メールアドレス <span class="required">*</span>', zh: '邮箱 <span class="required">*</span>', tw: '電子郵件 <span class="required">*</span>' },
    'manual.contact.type': { ko: '문의 유형', en: 'Inquiry Type', ja: 'お問い合わせ種別', zh: '咨询类型', tw: '諮詢類型' },
    'manual.contact.type-general': { ko: '일반 문의', en: 'General Inquiry', ja: '一般お問い合わせ', zh: '一般咨询', tw: '一般諮詢' },
    'manual.contact.type-as': { ko: 'A/S 접수', en: 'A/S Request', ja: 'A/S受付', zh: '售后申请', tw: '售後申請' },
    'manual.contact.type-option': { ko: '옵션 상품 구매', en: 'Optional Accessory Purchase', ja: 'オプション商品購入', zh: '可选配件购买', tw: '選購配件購買' },
    'manual.contact.type-dealer': { ko: '딜러/대량 구매', en: 'Dealer / Bulk Purchase', ja: 'ディーラー/大量購入', zh: '经销/批量购买', tw: '經銷/批量購買' },
    'manual.contact.type-other': { ko: '기타', en: 'Other', ja: 'その他', zh: '其他', tw: '其他' },
    'manual.contact.serial': { ko: '시리얼 넘버 (선택)', en: 'Serial Number (optional)', ja: 'シリアルナンバー（任意）', zh: '序列号（选填）', tw: '序號（選填）' },
    'manual.contact.message': { ko: '내용 <span class="required">*</span>', en: 'Message <span class="required">*</span>', ja: '内容 <span class="required">*</span>', zh: '内容 <span class="required">*</span>', tw: '內容 <span class="required">*</span>' },
    'manual.contact.submit': { ko: '메일로 문의하기', en: 'Send via Email', ja: 'メールで問い合わせる', zh: '通过邮件咨询', tw: '透過郵件諮詢' },
};

// ── i18n Engine ──
const SUPPORTED_LANGS = ['ko', 'en', 'ja', 'zh', 'tw'];
const LANG_LABELS = { ko: 'KO', en: 'EN', ja: 'JA', zh: '简', tw: '繁' };

function getLang() {
    const params = new URLSearchParams(window.location.search);
    const urlLang = params.get('lang');
    if (SUPPORTED_LANGS.includes(urlLang)) return urlLang;
    try { return localStorage.getItem('dc-lang') || 'ko'; }
    catch { return 'ko'; }
}

function setLang(lang) {
    try { localStorage.setItem('dc-lang', lang); } catch {}
    document.documentElement.lang = lang;
    applyTranslations(lang);
    updateToggleUI(lang);
    updateLinks(lang);
}

function updateLinks(lang) {
    document.querySelectorAll('a[href]').forEach(a => {
        const href = a.getAttribute('href');
        if (!href || href.startsWith('#') || href.startsWith('http') || href.startsWith('mailto:')) return;
        try {
            const url = new URL(href, window.location.href);
            if (!url.pathname.endsWith('.html')) return;
            url.searchParams.set('lang', lang);
            a.setAttribute('href', url.pathname + url.search + url.hash);
        } catch {}
    });
}

function applyTranslations(lang) {
    document.querySelectorAll('[data-i18n]').forEach(el => {
        const key = el.dataset.i18n;
        const t = translations[key];
        if (!t) return;
        const text = t[lang] || (lang === 'tw' ? t.zh : null) || t.ko;

        if (el.tagName === 'INPUT' || el.tagName === 'TEXTAREA') {
            if (el.placeholder !== undefined && el.dataset.i18nAttr === 'placeholder') {
                el.placeholder = text;
            }
        } else if (el.tagName === 'OPTION') {
            el.textContent = text;
        } else {
            el.innerHTML = text;
        }
    });

    // Update page title
    const titleEl = document.querySelector('[data-i18n-title]');
    if (titleEl) {
        const key = titleEl.dataset.i18nTitle;
        const t = translations[key];
        if (t) document.title = t[lang] || t.ko;
    }
}

function updateToggleUI(lang) {
    document.querySelectorAll('.lang-toggle').forEach(toggle => {
        toggle.querySelectorAll('.lang-opt').forEach(opt => {
            opt.classList.toggle('active', opt.dataset.lang === lang);
        });
    });
}

function createLangToggle() {
    const lang = getLang();
    const toggle = document.createElement('div');
    toggle.className = 'lang-toggle';
    toggle.innerHTML = SUPPORTED_LANGS.map(l =>
        `<button class="lang-opt ${lang === l ? 'active' : ''}" data-lang="${l}">${LANG_LABELS[l] || l.toUpperCase()}</button>`
    ).join('');
    toggle.addEventListener('click', (e) => {
        const btn = e.target.closest('.lang-opt');
        if (btn) setLang(btn.dataset.lang);
    });
    return toggle;
}

document.addEventListener('DOMContentLoaded', () => {
    const lang = getLang();

    // Insert toggle into desktop nav
    const navLinks = document.querySelector('.nav-links');
    if (navLinks) {
        const lastLink = navLinks.querySelector('.nav-cta');
        navLinks.insertBefore(createLangToggle(), lastLink);
    }

    // Insert toggle into mobile menu
    const mobileMenu = document.getElementById('mobileMenu');
    if (mobileMenu) {
        const mobileCta = mobileMenu.querySelector('.nav-cta');
        mobileMenu.insertBefore(createLangToggle(), mobileCta);
    }

    // Apply on load
    if (lang !== 'ko') {
        document.documentElement.lang = lang;
        applyTranslations(lang);
    }
    updateToggleUI(lang);
    updateLinks(lang);

    // Sync URL param to localStorage
    try { localStorage.setItem('dc-lang', lang); } catch {}
});
