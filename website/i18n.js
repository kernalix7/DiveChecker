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
    'problem.1.desc': { ko: '이퀄라이징이 안 돼서 다음 레벨을 포기. 수강료만 날리는 악순환.', en: 'Can\'t equalize, can\'t advance. A vicious cycle of wasted tuition fees.', ja: 'Can\'t equalize, can\'t advance. A vicious cycle of wasted tuition fees.', zh: 'Can\'t equalize, can\'t advance. A vicious cycle of wasted tuition fees.', tw: 'Can\'t equalize, can\'t advance. A vicious cycle of wasted tuition fees.' },
    'problem.2.title': { ko: '원인 불명', en: 'Unknown Cause', ja: '原因不明', zh: '原因不明', tw: '原因不明' },
    'problem.2.desc': { ko: '뭐가 잘못인지 모른 채 같은 실수 반복. 연습이 아니라 시간 낭비.', en: 'Repeating the same mistakes without knowing what\'s wrong. Not practice — just wasted time.', ja: 'Repeating the same mistakes without knowing what\'s wrong. Not practice — just wasted time.', zh: 'Repeating the same mistakes without knowing what\'s wrong. Not practice — just wasted time.', tw: 'Repeating the same mistakes without knowing what\'s wrong. Not practice — just wasted time.' },
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
    'feat2.desc': { ko: '지금 내가 프렌젤을 하고 있는지, 발살바를 하고 있는지 그래프 패턴이 즉시 알려줍니다. 두 기법의 압력 커브는 완전히 다릅니다.', en: 'The graph pattern instantly tells you whether you\'re doing Frenzel or Valsalva. The pressure curves of the two techniques are completely different.', ja: 'The graph pattern instantly tells you whether you\'re doing Frenzel or Valsalva. The pressure curves of the two techniques are completely different.', zh: 'The graph pattern instantly tells you whether you\'re doing Frenzel or Valsalva. The pressure curves of the two techniques are completely different.', tw: 'The graph pattern instantly tells you whether you\'re doing Frenzel or Valsalva. The pressure curves of the two techniques are completely different.' },
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
    'target.title': { ko: '이런 분들이 사용합니다', en: 'Who It\'s For', ja: 'Who It\'s For', zh: 'Who It\'s For', tw: 'Who It\'s For' },
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
    'specs.product-name-val': { ko: '전자식 이퀄라이징 학습기', en: 'Electronic Equalization Trainer', ja: '電子式イコライジング学習器', zh: '电子式均压训练器', tw: '電子式均壓訓練器' },
    'specs.model': { ko: '모델명', en: 'Model', ja: 'モデル名', zh: '型号', tw: '型號' },
    'specs.mcu': { ko: 'MCU', en: 'MCU', ja: 'MCU', zh: 'MCU', tw: 'MCU' },
    'specs.mcu-val': { ko: 'RP2350 (Pico2) 듀얼코어', en: 'RP2350 (Pico2) Dual-core', ja: 'RP2350 (Pico2) デュアルコア', zh: 'RP2350 (Pico2) 双核', tw: 'RP2350 (Pico2) 雙核' },
    'specs.interface': { ko: '인터페이스', en: 'Interface', ja: 'インターフェース', zh: '接口', tw: '接口' },
    'specs.power': { ko: '전원', en: 'Power', ja: '電源', zh: '电源', tw: '電源' },
    'specs.cert': { ko: '인증', en: 'Certification', ja: '認証', zh: '认证', tw: '認證' },
    'specs.cert-val': { ko: 'KC 인증 완료', en: 'KC Certified', ja: 'KC認証取得済み', zh: 'KC认证完成', tw: 'KC認證完成' },
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
    'closing.title': { ko: '프렌젤이 안 되는 게 아닙니다.<br><span class="gradient-text glow-text">확인할 방법</span>이 없었을 뿐.', en: 'It\'s not that you can\'t Frenzel.<br>You just had <span class="gradient-text glow-text">no way to see it</span>.', ja: 'It\'s not that you can\'t Frenzel.<br>You just had <span class="gradient-text glow-text">no way to see it</span>.', zh: 'It\'s not that you can\'t Frenzel.<br>You just had <span class="gradient-text glow-text">no way to see it</span>.', tw: 'It\'s not that you can\'t Frenzel.<br>You just had <span class="gradient-text glow-text">no way to see it</span>.' },
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
    'footer.disclaimer': { ko: '본 제품은 다이빙 이퀄라이징 기술 향상을 위한 교육용 학습기(Learning Device)이며, 의료기기가 아닙니다. 이관 기능 장애, 중이염 등 질환의 진단·예방·치료 목적으로 사용할 수 없습니다. 사용 중 통증이 느껴지면 즉시 사용을 중단하십시오.', en: 'This product is an educational learning device for improving diving equalization technique and is not a medical device. It cannot be used for diagnosis, prevention, or treatment of conditions such as Eustachian tube dysfunction or otitis media. If you feel pain during use, stop immediately.', ja: '本製品はダイビングイコライジング技術向上のための教育用学習器(Learning Device)であり、医療機器ではありません。耳管機能障害、中耳炎などの疾患の診断・予防・治療目的に使用することはできません。使用中に痛みを感じた場合は直ちに使用を中止してください。', zh: '本产品是用于提高潜水均压技术的教育用学习设备(Learning Device)，非医疗器械。不能用于诊断、预防或治疗咽鼓管功能障碍、中耳炎等疾病。使用中如感到疼痛，请立即停止使用。', tw: '本產品是用於提高潛水均壓技术的教育用學習設備(Learning Device)，非医療器械。不能用於診斷、預防或治療咽鼓管功能障礙、中耳炎等疾病。使用中如感到疼痛，請立即停止使用。' },

    // ═══ GUIDE PAGE ═══
    'guide.page-title': { ko: '사용 가이드', en: 'User Guide', ja: 'User Guide', zh: 'User Guide', tw: 'User Guide' },
    'guide.page-desc': { ko: 'DiveChecker를 처음 사용하시나요?<br>설치부터 실시간 측정까지, 단계별로 안내합니다.', en: 'New to DiveChecker?<br>We\'ll guide you step by step, from setup to real-time measurement.', ja: 'New to DiveChecker?<br>We\'ll guide you step by step, from setup to real-time measurement.', zh: 'New to DiveChecker?<br>We\'ll guide you step by step, from setup to real-time measurement.', tw: 'New to DiveChecker?<br>We\'ll guide you step by step, from setup to real-time measurement.' },
    'guide.toc-title': { ko: '목차', en: 'Table of Contents', ja: 'Table of Contents', zh: 'Table of Contents', tw: 'Table of Contents' },
    'guide.toc1': { ko: '개봉 및 구성품 확인', en: 'Unboxing & Package Contents', ja: 'Unboxing & Package Contents', zh: 'Unboxing & Package Contents', tw: 'Unboxing & Package Contents' },
    'guide.toc2': { ko: '디바이스 연결', en: 'Device Connection', ja: 'Device Connection', zh: 'Device Connection', tw: 'Device Connection' },
    'guide.toc3': { ko: '앱 설치', en: 'App Installation', ja: 'App Installation', zh: 'App Installation', tw: 'App Installation' },
    'guide.toc4': { ko: '첫 번째 측정', en: 'First Measurement', ja: 'First Measurement', zh: 'First Measurement', tw: 'First Measurement' },
    'guide.toc5': { ko: '캘리브레이션', en: 'Calibration', ja: 'Calibration', zh: 'Calibration', tw: 'Calibration' },
    'guide.toc6': { ko: '실시간 측정 & 기록', en: 'Real-time Measurement & Recording', ja: 'Real-time Measurement & Recording', zh: 'Real-time Measurement & Recording', tw: 'Real-time Measurement & Recording' },
    'guide.toc7': { ko: '피크 분석 읽는 법', en: 'Reading Peak Analysis', ja: 'Reading Peak Analysis', zh: 'Reading Peak Analysis', tw: 'Reading Peak Analysis' },
    'guide.toc8': { ko: '기법별 연습 팁', en: 'Technique Practice Tips', ja: 'Technique Practice Tips', zh: 'Technique Practice Tips', tw: 'Technique Practice Tips' },
    'guide.toc9': { ko: '펌웨어 업데이트', en: 'Firmware Update', ja: 'Firmware Update', zh: 'Firmware Update', tw: 'Firmware Update' },
    'guide.toc10': { ko: '문제 해결', en: 'Troubleshooting', ja: 'Troubleshooting', zh: 'Troubleshooting', tw: 'Troubleshooting' },
    'guide.s01': { ko: '개봉 및 구성품 확인', en: 'Unboxing & Package Contents', ja: 'Unboxing & Package Contents', zh: 'Unboxing & Package Contents', tw: 'Unboxing & Package Contents' },
    'guide.s01.intro': { ko: '패키지를 개봉하면 아래 구성품이 들어있습니다.', en: 'Your package includes the following items.', ja: 'Your package includes the following items.', zh: 'Your package includes the following items.', tw: 'Your package includes the following items.' },
    'guide.s01.item1': { ko: '다이브체커 본체 (DC-EQ01)', en: 'DiveChecker Unit (DC-EQ01)', ja: 'DiveChecker Unit (DC-EQ01)', zh: 'DiveChecker Unit (DC-EQ01)', tw: 'DiveChecker Unit (DC-EQ01)' },
    'guide.s01.item1-desc': { ko: '압력 센서가 내장된 메인 디바이스', en: 'Main device with built-in pressure sensor', ja: 'Main device with built-in pressure sensor', zh: 'Main device with built-in pressure sensor', tw: 'Main device with built-in pressure sensor' },
    'guide.s01.item2': { ko: 'USB-C 데이터 케이블', en: 'USB-C Data Cable', ja: 'USB-C Data Cable', zh: 'USB-C Data Cable', tw: 'USB-C Data Cable' },
    'guide.s01.item2-desc': { ko: '전원 공급 + 데이터 전송 겸용 (충전 전용 케이블은 사용 불가)', en: 'Power + data combined (charge-only cables will not work)', ja: 'Power + data combined (charge-only cables will not work)', zh: 'Power + data combined (charge-only cables will not work)', tw: 'Power + data combined (charge-only cables will not work)' },
    'guide.s01.item3': { ko: '사용 설명서', en: 'User Manual', ja: 'User Manual', zh: 'User Manual', tw: 'User Manual' },
    'guide.s01.item3-desc': { ko: '퀵 스타트 가이드 및 QR코드', en: 'Quick start guide and QR code', ja: 'Quick start guide and QR code', zh: 'Quick start guide and QR code', tw: 'Quick start guide and QR code' },
    'guide.s01.warning': { ko: '<strong>충전 전용 케이블</strong>로는 데이터 전송이 되지 않습니다. 반드시 동봉된 케이블 또는 데이터 전송 가능한 USB-C 케이블을 사용하세요.', en: '<strong>Charge-only cables</strong> cannot transfer data. Always use the included cable or a USB-C cable that supports data transfer.', ja: '<strong>Charge-only cables</strong> cannot transfer data. Always use the included cable or a USB-C cable that supports data transfer.', zh: '<strong>Charge-only cables</strong> cannot transfer data. Always use the included cable or a USB-C cable that supports data transfer.', tw: '<strong>Charge-only cables</strong> cannot transfer data. Always use the included cable or a USB-C cable that supports data transfer.' },
    'guide.s02': { ko: '디바이스 연결', en: 'Device Connection', ja: 'Device Connection', zh: 'Device Connection', tw: 'Device Connection' },
    'guide.s02.intro': { ko: 'USB-C 케이블로 DiveChecker와 기기를 연결합니다.', en: 'Connect DiveChecker to your device with a USB-C cable.', ja: 'Connect DiveChecker to your device with a USB-C cable.', zh: 'Connect DiveChecker to your device with a USB-C cable.', tw: 'Connect DiveChecker to your device with a USB-C cable.' },
    'guide.s02.1-title': { ko: 'USB-C 케이블 연결', en: 'USB-C Cable Connection', ja: 'USB-C Cable Connection', zh: 'USB-C Cable Connection', tw: 'USB-C Cable Connection' },
    'guide.s02.1-desc': { ko: '동봉된 케이블의 한쪽을 DiveChecker 본체에, 다른 한쪽을 PC/스마트폰에 연결합니다.', en: 'Connect one end of the included cable to DiveChecker and the other to your PC/smartphone.', ja: 'Connect one end of the included cable to DiveChecker and the other to your PC/smartphone.', zh: 'Connect one end of the included cable to DiveChecker and the other to your PC/smartphone.', tw: 'Connect one end of the included cable to DiveChecker and the other to your PC/smartphone.' },
    'guide.s02.2-title': { ko: 'LED 확인', en: 'Check LED', ja: 'Check LED', zh: 'Check LED', tw: 'Check LED' },
    'guide.s02.2-desc': { ko: '전원이 연결되면 본체의 LED가 점등됩니다. LED가 켜지지 않는다면 케이블이나 포트를 확인하세요.', en: 'The LED lights up when powered. If the LED doesn\'t turn on, check the cable or port.', ja: 'The LED lights up when powered. If the LED doesn\'t turn on, check the cable or port.', zh: 'The LED lights up when powered. If the LED doesn\'t turn on, check the cable or port.', tw: 'The LED lights up when powered. If the LED doesn\'t turn on, check the cable or port.' },
    'guide.s02.3-title': { ko: 'Android OTG', en: 'Android OTG', ja: 'Android OTG', zh: 'Android OTG', tw: 'Android OTG' },
    'guide.s02.3-desc': { ko: '스마트폰 연결 시 USB OTG를 지원하는 기기여야 합니다. 대부분의 최신 Android 폰은 지원합니다.', en: 'Your smartphone must support USB OTG. Most modern Android phones support it.', ja: 'Your smartphone must support USB OTG. Most modern Android phones support it.', zh: 'Your smartphone must support USB OTG. Most modern Android phones support it.', tw: 'Your smartphone must support USB OTG. Most modern Android phones support it.' },
    'guide.s02.win': { ko: 'USB 포트에 바로 연결. 별도 드라이버 불필요.', en: 'Direct USB connection. No driver needed.', ja: 'Direct USB connection. No driver needed.', zh: 'Direct USB connection. No driver needed.', tw: 'Direct USB connection. No driver needed.' },
    'guide.s02.android': { ko: 'USB-C OTG 또는 USB-C to C 케이블 사용.', en: 'Use USB-C OTG or USB-C to C cable.', ja: 'Use USB-C OTG or USB-C to C cable.', zh: 'Use USB-C OTG or USB-C to C cable.', tw: 'Use USB-C OTG or USB-C to C cable.' },
    'guide.s02.ios': { ko: 'USB-C iPhone 15 이상 및 USB-C iPad에서 바로 사용 가능. Lightning 기기는 별도 변환잭 필요 (옵션 구매 가능).', en: 'Works directly with USB-C iPhone 15+ and USB-C iPad. Lightning devices require a separate adapter (available as option).', ja: 'Works directly with USB-C iPhone 15+ and USB-C iPad. Lightning devices require a separate adapter (available as option).', zh: 'Works directly with USB-C iPhone 15+ and USB-C iPad. Lightning devices require a separate adapter (available as option).', tw: 'Works directly with USB-C iPhone 15+ and USB-C iPad. Lightning devices require a separate adapter (available as option).' },
    'guide.s03': { ko: '앱 설치', en: 'App Installation', ja: 'App Installation', zh: 'App Installation', tw: 'App Installation' },
    'guide.s03.intro': { ko: '사용 설명서에 포함된 QR코드를 스캔하거나, 아래에서 플랫폼에 맞는 앱을 다운로드하세요.', en: 'Scan the QR code in the manual, or download the app for your platform below.', ja: 'Scan the QR code in the manual, or download the app for your platform below.', zh: 'Scan the QR code in the manual, or download the app for your platform below.', tw: 'Scan the QR code in the manual, or download the app for your platform below.' },
    'guide.s03.tip': { ko: '<strong>Google Play</strong>와 <strong>App Store</strong>에서 다운로드할 수 있습니다. Windows, macOS, Linux용은 GitHub Releases에서 설치 가능합니다.', en: 'Available on <strong>Google Play</strong> and <strong>App Store</strong>. Windows, macOS, and Linux versions available from GitHub Releases.', ja: '<strong>Google Play</strong>と<strong>App Store</strong>からダウンロードできます。Windows、macOS、Linux版はGitHub Releasesからインストール可能です。', zh: '可从<strong>Google Play</strong>和<strong>App Store</strong>下载。Windows、macOS、Linux版可从GitHub Releases安装。', tw: '可從<strong>Google Play</strong>和<strong>App Store</strong>下載。Windows、macOS、Linux版可從GitHub Releases安裝。' },
    'guide.s04': { ko: '첫 번째 측정', en: 'First Measurement', ja: 'First Measurement', zh: 'First Measurement', tw: 'First Measurement' },
    'guide.s04.1-title': { ko: '앱 실행 & 디바이스 연결', en: 'Launch App & Connect Device', ja: 'Launch App & Connect Device', zh: 'Launch App & Connect Device', tw: 'Launch App & Connect Device' },
    'guide.s04.1-desc': { ko: '앱 홈 화면에서 <strong>"디바이스 연결"</strong> 버튼을 탭합니다. 목록에 DiveChecker가 나타나면 선택하세요.', en: 'Tap <strong>"Connect Device"</strong> on the home screen. Select DiveChecker when it appears in the list.', ja: 'Tap <strong>"Connect Device"</strong> on the home screen. Select DiveChecker when it appears in the list.', zh: 'Tap <strong>"Connect Device"</strong> on the home screen. Select DiveChecker when it appears in the list.', tw: 'Tap <strong>"Connect Device"</strong> on the home screen. Select DiveChecker when it appears in the list.' },
    'guide.s04.2-title': { ko: '인증 확인', en: 'Authentication Check', ja: 'Authentication Check', zh: 'Authentication Check', tw: 'Authentication Check' },
    'guide.s04.2-desc': { ko: '정품 인증(ECDSA)이 자동으로 진행됩니다. 인증이 완료되면 연결 상태가 녹색으로 표시됩니다.', en: 'Authenticity verification (ECDSA) runs automatically. The connection status turns green when verified.', ja: 'Authenticity verification (ECDSA) runs automatically. The connection status turns green when verified.', zh: 'Authenticity verification (ECDSA) runs automatically. The connection status turns green when verified.', tw: 'Authenticity verification (ECDSA) runs automatically. The connection status turns green when verified.' },
    'guide.s04.3-title': { ko: '캘리브레이션', en: 'Calibration', ja: 'Calibration', zh: 'Calibration', tw: 'Calibration' },
    'guide.s04.3-desc': { ko: '<strong>"캘리브레이션"</strong> 버튼을 눌러 현재 대기압을 기준점으로 설정합니다. 센서에 입/코를 대지 않은 상태에서 진행하세요.', en: 'Press <strong>"Calibrate"</strong> to set the current atmospheric pressure as baseline. Keep your mouth/nose away from the sensor.', ja: 'Press <strong>"Calibrate"</strong> to set the current atmospheric pressure as baseline. Keep your mouth/nose away from the sensor.', zh: 'Press <strong>"Calibrate"</strong> to set the current atmospheric pressure as baseline. Keep your mouth/nose away from the sensor.', tw: 'Press <strong>"Calibrate"</strong> to set the current atmospheric pressure as baseline. Keep your mouth/nose away from the sensor.' },
    'guide.s04.4-title': { ko: '측정 시작', en: 'Start Measuring', ja: 'Start Measuring', zh: 'Start Measuring', tw: 'Start Measuring' },
    'guide.s04.4-desc': { ko: '측정 탭에서 <strong>"시작"</strong>을 누르고, 센서에 코를 대고 이퀄라이징을 시작하세요. 그래프가 실시간으로 나타납니다!', en: 'Press <strong>"Start"</strong> in the measurement tab, place the sensor on your nose and begin equalizing. The graph appears in real time!', ja: 'Press <strong>"Start"</strong> in the measurement tab, place the sensor on your nose and begin equalizing. The graph appears in real time!', zh: 'Press <strong>"Start"</strong> in the measurement tab, place the sensor on your nose and begin equalizing. The graph appears in real time!', tw: 'Press <strong>"Start"</strong> in the measurement tab, place the sensor on your nose and begin equalizing. The graph appears in real time!' },
    'guide.s05': { ko: '캘리브레이션', en: 'Calibration', ja: 'Calibration', zh: 'Calibration', tw: 'Calibration' },
    'guide.s05.intro': { ko: '캘리브레이션은 현재 대기압을 0 hPa 기준으로 설정하는 과정입니다. 정확한 측정을 위해 <strong>매 세션 시작 전</strong> 권장합니다.', en: 'Calibration sets the current atmospheric pressure as the 0 hPa baseline. Recommended <strong>before each session</strong> for accurate measurement.', ja: 'Calibration sets the current atmospheric pressure as the 0 hPa baseline. Recommended <strong>before each session</strong> for accurate measurement.', zh: 'Calibration sets the current atmospheric pressure as the 0 hPa baseline. Recommended <strong>before each session</strong> for accurate measurement.', tw: 'Calibration sets the current atmospheric pressure as the 0 hPa baseline. Recommended <strong>before each session</strong> for accurate measurement.' },
    'guide.s05.callout-title': { ko: '캘리브레이션 과정', en: 'Calibration Process', ja: 'Calibration Process', zh: 'Calibration Process', tw: 'Calibration Process' },
    'guide.s05.step1': { ko: '센서에서 입/코를 떼고 자연 상태로 둡니다', en: 'Remove mouth/nose from sensor and leave in natural state', ja: 'Remove mouth/nose from sensor and leave in natural state', zh: 'Remove mouth/nose from sensor and leave in natural state', tw: 'Remove mouth/nose from sensor and leave in natural state' },
    'guide.s05.step2': { ko: '앱에서 "캘리브레이션" 버튼을 탭합니다', en: 'Tap "Calibrate" button in the app', ja: 'Tap "Calibrate" button in the app', zh: 'Tap "Calibrate" button in the app', tw: 'Tap "Calibrate" button in the app' },
    'guide.s05.step3': { ko: '3초간 대기압 샘플을 수집합니다', en: 'Collects atmospheric pressure samples for 3 seconds', ja: 'Collects atmospheric pressure samples for 3 seconds', zh: 'Collects atmospheric pressure samples for 3 seconds', tw: 'Collects atmospheric pressure samples for 3 seconds' },
    'guide.s05.step4': { ko: '평균값이 자동으로 기준점(baseline)으로 설정됩니다', en: 'Average value is automatically set as the baseline', ja: 'Average value is automatically set as the baseline', zh: 'Average value is automatically set as the baseline', tw: 'Average value is automatically set as the baseline' },
    'guide.s05.tip': { ko: '고도가 변하거나 장소를 이동한 후에는 반드시 재캘리브레이션하세요. 대기압 변화가 측정값에 영향을 줍니다.', en: 'Always recalibrate after changing altitude or location. Atmospheric pressure changes affect measurements.', ja: 'Always recalibrate after changing altitude or location. Atmospheric pressure changes affect measurements.', zh: 'Always recalibrate after changing altitude or location. Atmospheric pressure changes affect measurements.', tw: 'Always recalibrate after changing altitude or location. Atmospheric pressure changes affect measurements.' },
    'guide.s06': { ko: '실시간 측정 & 기록', en: 'Real-time Measurement & Recording', ja: 'Real-time Measurement & Recording', zh: 'Real-time Measurement & Recording', tw: 'Real-time Measurement & Recording' },
    'guide.s06.intro': { ko: '측정 화면에서 실시간 그래프를 확인하며 이퀄라이징을 연습합니다.', en: 'Practice equalization while watching the real-time graph on the measurement screen.', ja: 'Practice equalization while watching the real-time graph on the measurement screen.', zh: 'Practice equalization while watching the real-time graph on the measurement screen.', tw: 'Practice equalization while watching the real-time graph on the measurement screen.' },
    'guide.s06.f1-title': { ko: '실시간 그래프', en: 'Real-time Graph', ja: 'Real-time Graph', zh: 'Real-time Graph', tw: 'Real-time Graph' },
    'guide.s06.f1-desc': { ko: '30초 슬라이딩 윈도우로 압력 변화를 실시간으로 표시합니다. Y축은 자동 스케일링됩니다.', en: '30-second sliding window displays pressure changes in real time. Y-axis auto-scales.', ja: '30-second sliding window displays pressure changes in real time. Y-axis auto-scales.', zh: '30-second sliding window displays pressure changes in real time. Y-axis auto-scales.', tw: '30-second sliding window displays pressure changes in real time. Y-axis auto-scales.' },
    'guide.s06.f2-title': { ko: '핀치 줌 & 드래그', en: 'Pinch Zoom & Drag', ja: 'Pinch Zoom & Drag', zh: 'Pinch Zoom & Drag', tw: 'Pinch Zoom & Drag' },
    'guide.s06.f2-desc': { ko: '그래프를 핀치 줌으로 확대하거나 드래그하여 과거 데이터를 확인할 수 있습니다.', en: 'Pinch to zoom in on the graph or drag to review past data.', ja: 'Pinch to zoom in on the graph or drag to review past data.', zh: 'Pinch to zoom in on the graph or drag to review past data.', tw: 'Pinch to zoom in on the graph or drag to review past data.' },
    'guide.s06.f3-title': { ko: '세션 기록', en: 'Session Recording', ja: 'Session Recording', zh: 'Session Recording', tw: 'Session Recording' },
    'guide.s06.f3-desc': { ko: '"정지"를 누르면 세션이 자동 저장됩니다. 기록 탭에서 언제든 다시 확인 가능합니다.', en: 'Press "Stop" to auto-save the session. Review anytime in the History tab.', ja: 'Press "Stop" to auto-save the session. Review anytime in the History tab.', zh: 'Press "Stop" to auto-save the session. Review anytime in the History tab.', tw: 'Press "Stop" to auto-save the session. Review anytime in the History tab.' },
    'guide.s06.f4-title': { ko: '그래프 노트', en: 'Graph Notes', ja: 'Graph Notes', zh: 'Graph Notes', tw: 'Graph Notes' },
    'guide.s06.f4-desc': { ko: '특정 시점에 메모를 남길 수 있습니다. 연습 중 느낀 점을 바로 기록하세요.', en: 'Leave notes at specific points. Record your observations during practice.', ja: 'Leave notes at specific points. Record your observations during practice.', zh: 'Leave notes at specific points. Record your observations during practice.', tw: 'Leave notes at specific points. Record your observations during practice.' },
    'guide.s07': { ko: '피크 분석 읽는 법', en: 'Reading Peak Analysis', ja: 'Reading Peak Analysis', zh: 'Reading Peak Analysis', tw: 'Reading Peak Analysis' },
    'guide.s07.intro': { ko: '세션 기록에서 피크 분석을 선택하면 아래 지표들을 확인할 수 있습니다.', en: 'Select Peak Analysis from session records to see the following metrics.', ja: 'Select Peak Analysis from session records to see the following metrics.', zh: 'Select Peak Analysis from session records to see the following metrics.', tw: 'Select Peak Analysis from session records to see the following metrics.' },
    'guide.s07.m1-title': { ko: '리듬 점수', en: 'Rhythm Score', ja: 'Rhythm Score', zh: 'Rhythm Score', tw: 'Rhythm Score' },
    'guide.s07.m1-desc': { ko: '피크 간격의 일관성을 측정합니다. 변동계수(CV) 기반으로 계산되며, 점수가 높을수록 규칙적인 이퀄라이징을 의미합니다.', en: 'Measures peak interval consistency. Calculated based on coefficient of variation (CV) — higher scores mean more regular equalization.', ja: 'Measures peak interval consistency. Calculated based on coefficient of variation (CV) — higher scores mean more regular equalization.', zh: 'Measures peak interval consistency. Calculated based on coefficient of variation (CV) — higher scores mean more regular equalization.', tw: 'Measures peak interval consistency. Calculated based on coefficient of variation (CV) — higher scores mean more regular equalization.' },
    'guide.s07.m2-title': { ko: '압력 점수', en: 'Pressure Score', ja: 'Pressure Score', zh: 'Pressure Score', tw: 'Pressure Score' },
    'guide.s07.m2-desc': { ko: '피크 강도의 균일성을 측정합니다. 매번 일정한 힘으로 이퀄라이징하는지 확인할 수 있습니다.', en: 'Measures peak intensity uniformity. Check if you\'re equalizing with consistent force each time.', ja: 'Measures peak intensity uniformity. Check if you\'re equalizing with consistent force each time.', zh: 'Measures peak intensity uniformity. Check if you\'re equalizing with consistent force each time.', tw: 'Measures peak intensity uniformity. Check if you\'re equalizing with consistent force each time.' },
    'guide.s07.m3-title': { ko: '기법 점수', en: 'Technique Score', ja: 'Technique Score', zh: 'Technique Score', tw: 'Technique Score' },
    'guide.s07.m3-desc': { ko: '상승 시간, 하강 시간, 피크 폭을 분석합니다. 날카롭고 빠른 피크일수록 프렌젤에 가깝습니다.', en: 'Analyzes rise time, fall time, and peak width. Sharper, faster peaks indicate Frenzel technique.', ja: 'Analyzes rise time, fall time, and peak width. Sharper, faster peaks indicate Frenzel technique.', zh: 'Analyzes rise time, fall time, and peak width. Sharper, faster peaks indicate Frenzel technique.', tw: 'Analyzes rise time, fall time, and peak width. Sharper, faster peaks indicate Frenzel technique.' },
    'guide.s07.m4-title': { ko: '피로도 지수', en: 'Fatigue Index', ja: 'Fatigue Index', zh: 'Fatigue Index', tw: 'Fatigue Index' },
    'guide.s07.m4-desc': { ko: '세션 후반부의 압력 감소 추세를 측정합니다. 지수가 높으면 근육 피로가 누적되고 있음을 나타냅니다.', en: 'Measures pressure decline trend in the latter half. Higher index indicates accumulated muscle fatigue.', ja: 'Measures pressure decline trend in the latter half. Higher index indicates accumulated muscle fatigue.', zh: 'Measures pressure decline trend in the latter half. Higher index indicates accumulated muscle fatigue.', tw: 'Measures pressure decline trend in the latter half. Higher index indicates accumulated muscle fatigue.' },
    'guide.s07.grade-title': { ko: '종합 등급 기준', en: 'Overall Grade Criteria', ja: 'Overall Grade Criteria', zh: 'Overall Grade Criteria', tw: 'Overall Grade Criteria' },
    'guide.s07.grade-desc': { ko: '각 지표의 가중 평균으로 산출됩니다. 꾸준한 연습으로 등급을 올려보세요!', en: 'Calculated as a weighted average of all metrics. Keep practicing to improve your grade!', ja: 'Calculated as a weighted average of all metrics. Keep practicing to improve your grade!', zh: 'Calculated as a weighted average of all metrics. Keep practicing to improve your grade!', tw: 'Calculated as a weighted average of all metrics. Keep practicing to improve your grade!' },
    'guide.s08': { ko: '기법별 연습 팁', en: 'Technique Practice Tips', ja: 'Technique Practice Tips', zh: 'Technique Practice Tips', tw: 'Technique Practice Tips' },
    'guide.s08.valsalva': { ko: '발살바 (Valsalva)', en: 'Valsalva', ja: 'Valsalva', zh: 'Valsalva', tw: 'Valsalva' },
    'guide.s08.valsalva-badge': { ko: '기본', en: 'Basic', ja: 'Basic', zh: 'Basic', tw: 'Basic' },
    'guide.s08.valsalva-desc': { ko: '코를 막고 입을 다문 채 복부/흉부 압력으로 공기를 밀어냅니다.', en: 'Pinch nose, close mouth, and push air using abdominal/chest pressure.', ja: 'Pinch nose, close mouth, and push air using abdominal/chest pressure.', zh: 'Pinch nose, close mouth, and push air using abdominal/chest pressure.', tw: 'Pinch nose, close mouth, and push air using abdominal/chest pressure.' },
    'guide.s08.valsalva-pattern': { ko: '천천히 올라가서 오래 유지되는 <strong>둥근 커브</strong>. 상승/하강이 느리고 피크 폭이 넓습니다.', en: 'Slowly rising and long-lasting <strong>rounded curve</strong>. Slow rise/fall with wide peaks.', ja: 'Slowly rising and long-lasting <strong>rounded curve</strong>. Slow rise/fall with wide peaks.', zh: 'Slowly rising and long-lasting <strong>rounded curve</strong>. Slow rise/fall with wide peaks.', tw: 'Slowly rising and long-lasting <strong>rounded curve</strong>. Slow rise/fall with wide peaks.' },
    'guide.s08.valsalva-warn': { ko: '과도한 힘은 고막 손상을 유발할 수 있습니다. 그래프에서 과압 경고가 나타나면 즉시 멈추세요.', en: 'Excessive force can cause eardrum damage. Stop immediately if the graph shows an overpressure warning.', ja: 'Excessive force can cause eardrum damage. Stop immediately if the graph shows an overpressure warning.', zh: 'Excessive force can cause eardrum damage. Stop immediately if the graph shows an overpressure warning.', tw: 'Excessive force can cause eardrum damage. Stop immediately if the graph shows an overpressure warning.' },
    'guide.s08.frenzel': { ko: '프렌젤 (Frenzel)', en: 'Frenzel', ja: 'Frenzel', zh: 'Frenzel', tw: 'Frenzel' },
    'guide.s08.frenzel-badge': { ko: '중급', en: 'Intermediate', ja: 'Intermediate', zh: 'Intermediate', tw: 'Intermediate' },
    'guide.s08.frenzel-desc': { ko: '혀의 뒤쪽(혀뿌리)을 입천장 쪽으로 밀어 올려 공기를 압축합니다.', en: 'Compress air by pushing the back of the tongue up against the palate.', ja: 'Compress air by pushing the back of the tongue up against the palate.', zh: 'Compress air by pushing the back of the tongue up against the palate.', tw: 'Compress air by pushing the back of the tongue up against the palate.' },
    'guide.s08.frenzel-pattern': { ko: '빠르고 <strong>날카로운 스파이크</strong>. 상승/하강이 매우 빠르고 피크 폭이 좁습니다.', en: 'Fast and <strong>sharp spikes</strong>. Very fast rise/fall with narrow peaks.', ja: 'Fast and <strong>sharp spikes</strong>. Very fast rise/fall with narrow peaks.', zh: 'Fast and <strong>sharp spikes</strong>. Very fast rise/fall with narrow peaks.', tw: 'Fast and <strong>sharp spikes</strong>. Very fast rise/fall with narrow peaks.' },
    'guide.s08.frenzel-tip': { ko: '"K" 또는 "T" 발음을 하듯이 혀를 움직여 보세요. 그래프에서 날카로운 피크가 나타나면 성공입니다!', en: 'Try moving your tongue as if saying "K" or "T". You\'ve got it when you see sharp peaks on the graph!', ja: 'Try moving your tongue as if saying "K" or "T". You\'ve got it when you see sharp peaks on the graph!', zh: 'Try moving your tongue as if saying "K" or "T". You\'ve got it when you see sharp peaks on the graph!', tw: 'Try moving your tongue as if saying "K" or "T". You\'ve got it when you see sharp peaks on the graph!' },
    'guide.s08.mouthfill': { ko: '마우스필 (Mouthfill)', en: 'Mouthfill', ja: 'Mouthfill', zh: 'Mouthfill', tw: 'Mouthfill' },
    'guide.s08.mouthfill-badge': { ko: '고급', en: 'Advanced', ja: 'Advanced', zh: 'Advanced', tw: 'Advanced' },
    'guide.s08.mouthfill-desc': { ko: '입안에 공기를 가득 채운 후, 성문을 닫고 입안의 공기만으로 이퀄라이징합니다.', en: 'Fill your mouth with air, close the glottis, and equalize using only mouth air.', ja: 'Fill your mouth with air, close the glottis, and equalize using only mouth air.', zh: 'Fill your mouth with air, close the glottis, and equalize using only mouth air.', tw: 'Fill your mouth with air, close the glottis, and equalize using only mouth air.' },
    'guide.s08.mouthfill-pattern': { ko: '초기 높은 피크 후, 점차 <strong>감소하는 연속 피크</strong>. 입안 공기가 줄어들며 압력이 낮아집니다.', en: 'Initial high peak followed by <strong>progressively decreasing peaks</strong>. Pressure drops as mouth air depletes.', ja: 'Initial high peak followed by <strong>progressively decreasing peaks</strong>. Pressure drops as mouth air depletes.', zh: 'Initial high peak followed by <strong>progressively decreasing peaks</strong>. Pressure drops as mouth air depletes.', tw: 'Initial high peak followed by <strong>progressively decreasing peaks</strong>. Pressure drops as mouth air depletes.' },
    'guide.s08.btv': { ko: '핸즈프리 / BTV', en: 'Hands-free / BTV', ja: 'Hands-free / BTV', zh: 'Hands-free / BTV', tw: 'Hands-free / BTV' },
    'guide.s08.btv-badge': { ko: '고급', en: 'Advanced', ja: 'Advanced', zh: 'Advanced', tw: 'Advanced' },
    'guide.s08.btv-desc': { ko: '유스타키오관의 자발적 개방(Voluntary Tubal Opening). 코를 막지 않고 이퀄라이징합니다.', en: 'Voluntary Tubal Opening of the Eustachian tube. Equalize without pinching your nose.', ja: 'Voluntary Tubal Opening of the Eustachian tube. Equalize without pinching your nose.', zh: 'Voluntary Tubal Opening of the Eustachian tube. Equalize without pinching your nose.', tw: 'Voluntary Tubal Opening of the Eustachian tube. Equalize without pinching your nose.' },
    'guide.s08.btv-pattern': { ko: '매우 <strong>미세한 압력 변화</strong>. 다른 기법에 비해 피크가 작지만 일정한 패턴을 보입니다.', en: 'Very <strong>subtle pressure changes</strong>. Smaller peaks than other techniques but consistent pattern.', ja: 'Very <strong>subtle pressure changes</strong>. Smaller peaks than other techniques but consistent pattern.', zh: 'Very <strong>subtle pressure changes</strong>. Smaller peaks than other techniques but consistent pattern.', tw: 'Very <strong>subtle pressure changes</strong>. Smaller peaks than other techniques but consistent pattern.' },
    'guide.s09': { ko: '펌웨어 업데이트', en: 'Firmware Update', ja: 'Firmware Update', zh: 'Firmware Update', tw: 'Firmware Update' },
    'guide.s09.intro': { ko: '앱의 설정 탭에서 펌웨어 버전을 확인하고, 최신 버전으로 업데이트할 수 있습니다.', en: 'Check the firmware version in the app\'s Settings tab and update to the latest version.', ja: 'Check the firmware version in the app\'s Settings tab and update to the latest version.', zh: 'Check the firmware version in the app\'s Settings tab and update to the latest version.', tw: 'Check the firmware version in the app\'s Settings tab and update to the latest version.' },
    'guide.s09.1-title': { ko: '현재 버전 확인', en: 'Check Current Version', ja: 'Check Current Version', zh: 'Check Current Version', tw: 'Check Current Version' },
    'guide.s09.1-desc': { ko: '설정 → 디바이스 설정에서 현재 펌웨어 버전을 확인합니다.', en: 'Go to Settings → Device Settings to check your current firmware version.', ja: 'Go to Settings → Device Settings to check your current firmware version.', zh: 'Go to Settings → Device Settings to check your current firmware version.', tw: 'Go to Settings → Device Settings to check your current firmware version.' },
    'guide.s09.2-title': { ko: '업데이트 시작', en: 'Start Update', ja: 'Start Update', zh: 'Start Update', tw: 'Start Update' },
    'guide.s09.2-desc': { ko: '"펌웨어 업데이트" 버튼을 탭하면 디바이스가 BOOTSEL 모드로 재부팅됩니다.', en: 'Tap "Firmware Update" and the device reboots into BOOTSEL mode.', ja: 'Tap "Firmware Update" and the device reboots into BOOTSEL mode.', zh: 'Tap "Firmware Update" and the device reboots into BOOTSEL mode.', tw: 'Tap "Firmware Update" and the device reboots into BOOTSEL mode.' },
    'guide.s09.3-title': { ko: 'UF2 파일 복사', en: 'Copy UF2 File', ja: 'Copy UF2 File', zh: 'Copy UF2 File', tw: 'Copy UF2 File' },
    'guide.s09.3-desc': { ko: 'PC에서 USB 드라이브로 인식된 DiveChecker에 .uf2 파일을 드래그 앤 드롭합니다.', en: 'Drag and drop the .uf2 file onto the DiveChecker USB drive on your PC.', ja: 'Drag and drop the .uf2 file onto the DiveChecker USB drive on your PC.', zh: 'Drag and drop the .uf2 file onto the DiveChecker USB drive on your PC.', tw: 'Drag and drop the .uf2 file onto the DiveChecker USB drive on your PC.' },
    'guide.s09.4-title': { ko: '자동 재부팅', en: 'Auto Reboot', ja: 'Auto Reboot', zh: 'Auto Reboot', tw: 'Auto Reboot' },
    'guide.s09.4-desc': { ko: '업로드가 완료되면 자동으로 재부팅되어 새 펌웨어로 동작합니다.', en: 'The device automatically reboots with the new firmware after upload.', ja: 'The device automatically reboots with the new firmware after upload.', zh: 'The device automatically reboots with the new firmware after upload.', tw: 'The device automatically reboots with the new firmware after upload.' },
    'guide.s10': { ko: '문제 해결', en: 'Troubleshooting', ja: 'Troubleshooting', zh: 'Troubleshooting', tw: 'Troubleshooting' },
    'guide.s10.q1': { ko: '디바이스가 인식되지 않아요', en: 'Device not recognized', ja: 'Device not recognized', zh: 'Device not recognized', tw: 'Device not recognized' },
    'guide.s10.q1-a1': { ko: '충전 전용 케이블이 아닌 데이터 케이블인지 확인하세요', en: 'Make sure you\'re using a data cable, not a charge-only cable', ja: 'Make sure you\'re using a data cable, not a charge-only cable', zh: 'Make sure you\'re using a data cable, not a charge-only cable', tw: 'Make sure you\'re using a data cable, not a charge-only cable' },
    'guide.s10.q1-a2': { ko: '다른 USB 포트에 연결해 보세요', en: 'Try a different USB port', ja: 'Try a different USB port', zh: 'Try a different USB port', tw: 'Try a different USB port' },
    'guide.s10.q1-a3': { ko: '케이블을 분리했다가 다시 연결하세요', en: 'Disconnect and reconnect the cable', ja: 'Disconnect and reconnect the cable', zh: 'Disconnect and reconnect the cable', tw: 'Disconnect and reconnect the cable' },
    'guide.s10.q1-a4': { ko: 'Android: USB OTG 설정이 켜져 있는지 확인하세요', en: 'Android: Check if USB OTG is enabled', ja: 'Android: Check if USB OTG is enabled', zh: 'Android: Check if USB OTG is enabled', tw: 'Android: Check if USB OTG is enabled' },
    'guide.s10.q2': { ko: '그래프가 움직이지 않아요', en: 'Graph not moving', ja: 'Graph not moving', zh: 'Graph not moving', tw: 'Graph not moving' },
    'guide.s10.q2-a1': { ko: '캘리브레이션을 다시 진행하세요', en: 'Recalibrate the sensor', ja: 'Recalibrate the sensor', zh: 'Recalibrate the sensor', tw: 'Recalibrate the sensor' },
    'guide.s10.q2-a2': { ko: '센서 홀에 이물질이 없는지 확인하세요', en: 'Check for debris in the sensor hole', ja: 'Check for debris in the sensor hole', zh: 'Check for debris in the sensor hole', tw: 'Check for debris in the sensor hole' },
    'guide.s10.q2-a3': { ko: '앱을 종료 후 재실행하세요', en: 'Restart the app', ja: 'Restart the app', zh: 'Restart the app', tw: 'Restart the app' },
    'guide.s10.q3': { ko: '압력 값이 비정상적이에요', en: 'Abnormal pressure readings', ja: 'Abnormal pressure readings', zh: 'Abnormal pressure readings', tw: 'Abnormal pressure readings' },
    'guide.s10.q3-a1': { ko: '캘리브레이션을 다시 진행하세요', en: 'Recalibrate the sensor', ja: 'Recalibrate the sensor', zh: 'Recalibrate the sensor', tw: 'Recalibrate the sensor' },
    'guide.s10.q3-a2': { ko: '센서에 수분이 들어가지 않았는지 확인하세요', en: 'Check if moisture has entered the sensor', ja: 'Check if moisture has entered the sensor', zh: 'Check if moisture has entered the sensor', tw: 'Check if moisture has entered the sensor' },
    'guide.s10.q3-a3': { ko: '급격한 온도 변화 후에는 10분 안정화 후 사용하세요', en: 'Wait 10 minutes to stabilize after rapid temperature changes', ja: 'Wait 10 minutes to stabilize after rapid temperature changes', zh: 'Wait 10 minutes to stabilize after rapid temperature changes', tw: 'Wait 10 minutes to stabilize after rapid temperature changes' },
    'guide.s10.q4': { ko: 'LED가 켜지지 않아요', en: 'LED not turning on', ja: 'LED not turning on', zh: 'LED not turning on', tw: 'LED not turning on' },
    'guide.s10.q4-a1': { ko: '케이블이 제대로 꽂혀 있는지 확인하세요', en: 'Check if the cable is properly connected', ja: 'Check if the cable is properly connected', zh: 'Check if the cable is properly connected', tw: 'Check if the cable is properly connected' },
    'guide.s10.q4-a2': { ko: '다른 기기에 연결해서 테스트하세요', en: 'Test with a different device', ja: 'Test with a different device', zh: 'Test with a different device', tw: 'Test with a different device' },
    'guide.s10.q4-a3': { ko: '문제가 지속되면 <a href="support.html">고객 지원</a>에 문의하세요', en: 'If the problem persists, contact <a href="support.html">customer support</a>', ja: 'If the problem persists, contact <a href="support.html">customer support</a>', zh: 'If the problem persists, contact <a href="support.html">customer support</a>', tw: 'If the problem persists, contact <a href="support.html">customer support</a>' },
    'guide.cta': { ko: '해결되지 않는 문제가 있으신가요?', en: 'Still having issues?', ja: 'Still having issues?', zh: 'Still having issues?', tw: 'Still having issues?' },
    'guide.cta-btn': { ko: '고객 지원 문의', en: 'Contact Support', ja: 'Contact Support', zh: 'Contact Support', tw: 'Contact Support' },
    'guide.pattern-label': { ko: '그래프 패턴', en: 'Graph Pattern', ja: 'Graph Pattern', zh: 'Graph Pattern', tw: 'Graph Pattern' },

    // ═══ FAQ PAGE ═══
    'faq.page-title': { ko: '자주 묻는 질문', en: 'Frequently Asked Questions', ja: 'よくある質問', zh: '常见问题', tw: '常见問題' },
    'faq.page-desc': { ko: '구매부터 사용까지, 궁금한 점을 확인하세요.', en: 'Find answers about purchasing and using DiveChecker.', ja: '製品について気になることを確認しましょう。', zh: '查看关于产品的常见疑问。', tw: '查看关於產品的常见疑問。' },
    'faq.cat1': { ko: '제품 일반', en: 'General', ja: '製品について', zh: '关于产品', tw: '关於產品' },
    'faq.q1': { ko: '다이브체커는 어떤 제품인가요?', en: 'What is DiveChecker?', ja: 'DiveCheckerとは何ですか？', zh: 'DiveChecker是什么？', tw: 'DiveChecker是什么？' },
    'faq.a1': { ko: '다이브체커는 프리다이빙 이퀄라이징(균압) 훈련을 위한 실시간 압력 모니터링 디바이스입니다. 고정밀 압력 센서(BMP280)로 코/입의 미세한 압력 변화를 100Hz로 측정하고, 전용 앱을 통해 실시간 그래프로 시각화합니다.', en: 'DiveChecker is a real-time pressure monitoring device for freediving equalization training. It measures subtle pressure changes from your nose/mouth at 100Hz using a high-precision pressure sensor (BMP280) and visualizes them as real-time graphs through a dedicated app.', ja: 'ダイビングに必要なイコライジング（均圧）技術を実時間で可視化する教育用トレーニングデバイスです。BMP280圧力センサーが100Hzでサンプリングし、USB経由でリアルタイムグラフを表示します。', zh: '这是一款将潜水所需的均压技术实时可视化的教育训练设备。BMP280压力传感器以100Hz采样，通过USB实时显示图表。', tw: '這是一款将潛水所需的均壓技术實時可視化的教育訓練設備。BMP280壓力傳感器以100Hz採樣，通過USB實時顯示圖表。' },
    'faq.q2': { ko: '방수가 되나요? 물속에서 사용할 수 있나요?', en: 'Is it waterproof? Can I use it underwater?', ja: '誰のためのデバイスですか？', zh: '适合谁使用？', tw: '適合谁使用？' },
    'faq.a2': { ko: '<strong>아니요.</strong> DiveChecker는 지상 훈련용 디바이스입니다. 방수 기능이 없으므로 물에 닿지 않도록 주의해 주세요. 센서에 수분이 유입되면 고장의 원인이 됩니다.', en: '<strong>No.</strong> DiveChecker is a dry training device. It is not waterproof, so keep it away from water. Moisture entering the sensor can cause damage.', ja: 'イコライジングが苦手な方、Valsalvaからフレンゼルへの移行練習中の方、Mouthfill/BTVなどの上級テクニックを陸上で練習したいダイバー、そしてグラフ基盤のフィードバックを提供したいインストラクターに最適です。', zh: '适合均压困难的人、正在从Valsalva转换到Frenzel的练习者、想在陆地练习Mouthfill/BTV等高级技法的潜水员，以及想提供基于图表反馈的教练。', tw: '適合均壓困難的人、正在從Valsalva轉換到Frenzel的練習者、想在陸地練習Mouthfill/BTV等高級技法的潛水員，以及想提供基於圖表反饋的教練。' },
    'faq.q3': { ko: '배터리가 필요한가요?', en: 'Does it need a battery?', ja: 'なぜBluetoothではなくUSBですか？', zh: '为什么用USB而不是蓝牙？', tw: '為什么用USB而不是藍牙？' },
    'faq.a3': { ko: '아니요. USB-C 연결만으로 전원이 공급됩니다. 배터리 충전이나 교체가 필요 없어 언제든 바로 사용할 수 있습니다.', en: 'No. It\'s powered via USB-C connection. No battery charging or replacement needed — always ready to use.', ja: 'No. It\'s powered via USB-C connection. No battery charging or replacement needed — always ready to use.', zh: 'No. It\'s powered via USB-C connection. No battery charging or replacement needed — always ready to use.', tw: 'No. It\'s powered via USB-C connection. No battery charging or replacement needed — always ready to use.' },
    'faq.q4': { ko: '왜 블루투스가 아닌 USB 방식인가요?', en: 'Why USB instead of Bluetooth?', ja: 'Valsalvaとフレンゼルの違いはグラフで分かりますか？', zh: '能从图表区分Valsalva和Frenzel吗？', tw: '能從圖表区分Valsalva和Frenzel吗？' },
    'faq.a4': { ko: '이퀄라이징 훈련에서는 0.01초의 지연도 잘못된 피드백으로 이어집니다. 블루투스는 50~300ms의 전송 지연이 발생하지만, USB는 <strong>제로 레이턴시</strong>로 정확한 실시간 피드백을 제공합니다. 또한 페어링 실패, 배터리 방전, 연결 끊김 문제가 없습니다.', en: 'In equalization training, even 0.01s delay leads to wrong feedback. Bluetooth has 50~300ms latency, but USB provides <strong>zero latency</strong> for accurate real-time feedback. Also eliminates pairing failures, battery drain, and disconnections.', ja: 'はい！2つの技法は圧力カーブが完全に異なります。Valsalvaはゆっくり上昇する丸いカーブ、フレンゼルは速く鋭いスパイク。リアルタイムグラフで即座に判別できます。', zh: '当然！两种技法的压力曲线完全不同。Valsalva是缓慢上升的圆形曲线，Frenzel是快速尖锐的尖峰。通过实时图表可以立即判别。', tw: '当然！兩種技法的壓力曲線完全不同。Valsalva是緩慢上升的圆形曲線，Frenzel是快速尖銳的尖峰。通過實時圖表可以立即判別。' },
    'faq.q5': { ko: '오픈소스인가요?', en: 'Is it open source?', ja: '圧力の分解能はどのくらいですか？', zh: '压力分辨率是多少？', tw: '壓力分辨率是多少？' },
    'faq.a5': { ko: '네! 소프트웨어(앱, 펌웨어)는 <strong>Apache License 2.0</strong>, 하드웨어 설계는 <strong>CERN-OHL-S v2</strong> 라이센스로 공개되어 있습니다. GitHub에서 소스코드를 확인할 수 있습니다.', en: 'Yes! Software (app, firmware) is under <strong>Apache License 2.0</strong>, hardware design under <strong>CERN-OHL-S v2</strong>. Source code is available on GitHub.', ja: '0.01 hPaの分解能で、微細な圧力変化も検出できます。BMP280センサーが内部100Hzでサンプリングし、IIR x2 + 平均化フィルターで安定したデータを提供します。', zh: '0.01 hPa分辨率，能检测到细微的压力变化。BMP280传感器以内部100Hz采样，通过IIR x2 + 均值化滤波器提供稳定数据。', tw: '0.01 hPa分辨率，能檢測到細微的壓力變化。BMP280傳感器以內部100Hz採樣，通過IIR x2 + 均值化濾波器提供穩定數據。' },
    'faq.cat2': { ko: '호환성 & 앱', en: 'Compatibility & App', ja: '技術・使い方', zh: '技术・使用', tw: '技术・使用' },
    'faq.q6': { ko: '어떤 기기에서 사용할 수 있나요?', en: 'What devices are compatible?', ja: 'どのデバイスで使えますか？', zh: '支持哪些设备？', tw: '支持哪些設備？' },
    'faq.a6': { ko: 'Android, iOS, Windows, macOS, Linux에서 사용 가능합니다. USB-C 포트가 있는 기기여야 하며, Android의 경우 USB OTG를 지원하는 기기에서 사용할 수 있습니다. Lightning 기기는 별도 변환잭이 필요합니다 (옵션 구매 가능).', en: 'Compatible with Android, iOS, Windows, macOS, and Linux. Requires USB-C port. Android devices need USB OTG support. Lightning devices require a separate adapter (available as option).', ja: 'Compatible with Android, iOS, Windows, macOS, and Linux. Requires USB-C port. Android devices need USB OTG support. Lightning devices require a separate adapter (available as option).', zh: 'Compatible with Android, iOS, Windows, macOS, and Linux. Requires USB-C port. Android devices need USB OTG support. Lightning devices require a separate adapter (available as option).', tw: 'Compatible with Android, iOS, Windows, macOS, and Linux. Requires USB-C port. Android devices need USB OTG support. Lightning devices require a separate adapter (available as option).' },
    'faq.q7': { ko: 'iPhone에서 사용할 수 있나요?', en: 'Can I use it with iPhone?', ja: 'iPhoneでも使えますか？', zh: 'iPhone也能用吗？', tw: 'iPhone也能用吗？' },
    'faq.a7': { ko: '네, USB-C 포트가 있는 iPhone 15 이상 및 USB-C iPad에서 사용 가능합니다. Lightning 포트 모델은 USB 데이터 전송 방식 특성상 지원하지 않습니다.', en: 'Yes, with USB-C iPhone 15+ and USB-C iPad. Lightning port models are not supported due to USB data transfer limitations.', ja: 'はい！USB-C搭載のiPhone 15以降およびUSB-C iPadで使用可能です。Lightning機器には別途Lightning to USB-Cアダプターが必要です（オプション品として購入可能）。', zh: '可以！USB-C款iPhone 15及以上和USB-C iPad可直接使用。Lightning设备需要另购Lightning转USB-C转接头（可作为选配件购买）。', tw: '可以！USB-C款iPhone 15及以上和USB-C iPad可直接使用。Lightning設備需要另購Lightning轉USB-C轉接頭（可作為選配件購買）。' },
    'faq.q8': { ko: '앱 설치 없이 사용할 수 있나요?', en: 'Can I use it without installing an app?', ja: 'アプリをインストールせずに使えますか？', zh: '不安装应用也能用吗？', tw: '不安裝應用也能用吗？' },
    'faq.a8': { ko: '전용 앱 설치를 권장합니다. Android는 <a href="https://play.google.com/store/apps/details?id=kr.createch.divechecker">Google Play</a>, iOS는 <a href="https://apps.apple.com/kr/app/divechecker/id6758508799">App Store</a>에서 다운로드할 수 있습니다. Windows, macOS, Linux용은 GitHub Releases에서 설치 가능합니다.', en: 'We recommend installing the dedicated app. Android is available on <a href="https://play.google.com/store/apps/details?id=kr.createch.divechecker">Google Play</a>, iOS on the <a href="https://apps.apple.com/kr/app/divechecker/id6758508799">App Store</a>. Windows, macOS, and Linux versions are available from GitHub Releases.', ja: '専用アプリのインストールを推奨します。Androidは<a href="https://play.google.com/store/apps/details?id=kr.createch.divechecker">Google Play</a>、iOSは<a href="https://apps.apple.com/kr/app/divechecker/id6758508799">App Store</a>からダウンロードできます。Windows、macOS、Linux版はGitHub Releasesからインストール可能です。', zh: '建议安装专用应用。Android可从<a href="https://play.google.com/store/apps/details?id=kr.createch.divechecker">Google Play</a>下载，iOS可从<a href="https://apps.apple.com/kr/app/divechecker/id6758508799">App Store</a>下载。Windows、macOS、Linux版可从GitHub Releases安装。', tw: '建議安裝專用應用。Android可從<a href="https://play.google.com/store/apps/details?id=kr.createch.divechecker">Google Play</a>下載，iOS可從<a href="https://apps.apple.com/kr/app/divechecker/id6758508799">App Store</a>下載。Windows、macOS、Linux版可從GitHub Releases安裝。' },
    'faq.q9': { ko: '앱에서 데이터를 백업할 수 있나요?', en: 'Can I back up data from the app?', ja: 'ピーク分析は何を教えてくれますか？', zh: '峰值分析告诉我什么？', tw: '峰值分析告訴我什么？' },
    'faq.a9': { ko: '네. 설정 메뉴에서 JSON 형식으로 데이터를 백업하고 복원할 수 있습니다. 기기 변경 시에도 기록을 유지할 수 있습니다.', en: 'Yes. You can back up and restore data in JSON format from the settings menu. Keep your records when switching devices.', ja: 'リズムスコア（間隔の一貫性）、圧力スコア（強度の均一性）、技法スコア（上昇/下降速度）、疲労度指数（後半の圧力低下）の4指標を分析し、S~Fの総合グレードを算出します。', zh: '分析节奏分数（间隔一致性）、压力分数（强度均匀性）、技法分数（上升/下降速度）、疲劳指数（后半段压力下降）4项指标，计算S~F综合等级。', tw: '分析節奏分數（間隔一致性）、壓力分數（強度均匀性）、技法分數（上升/下降速度）、疲勞指數（後半段壓力下降）4項指標，计算S~F綜合等級。' },
    'faq.cat3': { ko: '사용 방법', en: 'How to Use', ja: '購入・配送', zh: '购买・配送', tw: '購買・配送' },
    'faq.q10': { ko: '어떻게 사용하나요?', en: 'How do I use it?', ja: '使い始めるにはどうすればいいですか？', zh: '如何开始使用？', tw: '如何開始使用？' },
    'faq.a10': { ko: 'USB-C 케이블로 연결 → 앱 실행 → 캘리브레이션 → 센서에 코를 대고 이퀄라이징. 3단계로 바로 시작할 수 있습니다. 자세한 내용은 <a href="guide.html">사용 가이드</a>를 참고하세요.', en: 'Connect via USB-C → Launch app → Calibrate → Place sensor on nose and equalize. Start in 3 simple steps. See the <a href="guide.html">User Guide</a> for details.', ja: 'Connect via USB-C → Launch app → Calibrate → Place sensor on nose and equalize. Start in 3 simple steps. See the <a href="guide.html">User Guide</a> for details.', zh: 'Connect via USB-C → Launch app → Calibrate → Place sensor on nose and equalize. Start in 3 simple steps. See the <a href="guide.html">User Guide</a> for details.', tw: 'Connect via USB-C → Launch app → Calibrate → Place sensor on nose and equalize. Start in 3 simple steps. See the <a href="guide.html">User Guide</a> for details.' },
    'faq.q11': { ko: '캘리브레이션은 매번 해야 하나요?', en: 'Do I need to calibrate every time?', ja: 'キャリブレーションは毎回必要ですか？', zh: '每次都需要校准吗？', tw: '每次都需要校準吗？' },
    'faq.a11': { ko: '권장합니다. 캘리브레이션은 현재 대기압을 기준점(0 hPa)으로 설정하는 과정입니다. 고도 변화, 날씨 변화 등으로 대기압이 달라지면 측정값에 영향을 줄 수 있으므로, 매 세션 시작 전 캘리브레이션을 진행하는 것이 좋습니다.', en: 'Recommended. Calibration sets the current atmospheric pressure as baseline (0 hPa). Changes in altitude or weather can affect readings, so calibrating before each session is best practice.', ja: 'はい、各セッション開始前のキャリブレーションを推奨します。大気圧は高度・場所・天候で変わるため、基準点の再設定が必要です。アプリで「キャリブレーション」ボタンをタップするだけで3秒で完了します。', zh: '是的，建议每次训练前校准。大气压会因海拔、位置、天气而变化，需要重新设置基准点。在应用中点击"校准"按钮3秒即可完成。', tw: '是的，建議每次訓練前校準。大氣壓會因海拔、位置、天气而變化，需要重新設置基準點。在應用中點击"校準"按鈕3秒即可完成。' },
    'faq.q12': { ko: '프렌젤과 발살바를 어떻게 구분하나요?', en: 'How to distinguish Frenzel from Valsalva?', ja: 'データはどこに保存されますか？', zh: '数据存储在哪里？', tw: '數據存儲在哪裡？' },
    'faq.a12': { ko: '그래프 패턴이 완전히 다릅니다. <strong>발살바</strong>는 천천히 올라가서 오래 유지되는 둥근 커브, <strong>프렌젤</strong>은 빠르고 날카로운 스파이크 형태입니다. 다이브체커를 사용하면 내가 어떤 기법을 하고 있는지 즉시 눈으로 확인할 수 있습니다.', en: 'The graph patterns are completely different. <strong>Valsalva</strong> shows a slowly rising, long-lasting rounded curve, while <strong>Frenzel</strong> produces fast, sharp spikes. DiveChecker lets you instantly see which technique you\'re using.', ja: 'The graph patterns are completely different. <strong>Valsalva</strong> shows a slowly rising, long-lasting rounded curve, while <strong>Frenzel</strong> produces fast, sharp spikes. DiveChecker lets you instantly see which technique you\'re using.', zh: 'The graph patterns are completely different. <strong>Valsalva</strong> shows a slowly rising, long-lasting rounded curve, while <strong>Frenzel</strong> produces fast, sharp spikes. DiveChecker lets you instantly see which technique you\'re using.', tw: 'The graph patterns are completely different. <strong>Valsalva</strong> shows a slowly rising, long-lasting rounded curve, while <strong>Frenzel</strong> produces fast, sharp spikes. DiveChecker lets you instantly see which technique you\'re using.' },
    'faq.q13': { ko: '초보자도 사용할 수 있나요?', en: 'Can beginners use it?', ja: 'ファームウェアはどうやってアップデートしますか？', zh: '如何更新固件？', tw: '如何更新固件？' },
    'faq.a13': { ko: '물론입니다! 오히려 초보자에게 더 효과적입니다. 이퀄라이징이 되는지 안 되는지조차 판단하기 어려운 단계에서, 그래프를 통해 즉각적인 피드백을 받을 수 있습니다.', en: 'Absolutely! It\'s actually more effective for beginners. At the stage where you can\'t even tell if equalization is working, the graph provides instant feedback.', ja: 'Absolutely! It\'s actually more effective for beginners. At the stage where you can\'t even tell if equalization is working, the graph provides instant feedback.', zh: 'Absolutely! It\'s actually more effective for beginners. At the stage where you can\'t even tell if equalization is working, the graph provides instant feedback.', tw: 'Absolutely! It\'s actually more effective for beginners. At the stage where you can\'t even tell if equalization is working, the graph provides instant feedback.' },
    'faq.q14': { ko: '센서에 직접 코를 대야 하나요?', en: 'Do I need to place my nose directly on the sensor?', ja: '医療機器ですか？', zh: '这是医疗器械吗？', tw: '這是医療器械吗？' },
    'faq.a14': { ko: '센서 홀에 직접 코(한쪽 콧구멍)를 밀착시키면 가장 정확한 측정이 됩니다. 또는 짧은 실리콘 튜브를 연결하여 사용할 수도 있습니다. 밀착도가 높을수록 정밀한 측정이 가능합니다.', en: 'Placing your nose (one nostril) directly on the sensor hole gives the most accurate reading. You can also use a short silicone tube. Better seal = more precise measurement.', ja: 'いいえ。DiveCheckerは教育用学習器(Learning Device)であり、医療機器ではありません。耳管機能障害、中耳炎等の疾患の診断・予防・治療目的に使用することはできません。', zh: '不是。DiveChecker是教育用学习设备(Learning Device)，不是医疗器械。不能用于诊断、预防或治疗咽鼓管功能障碍、中耳炎等疾病。', tw: '不是。DiveChecker是教育用學習設備(Learning Device)，不是医療器械。不能用於診斷、預防或治療咽鼓管功能障礙、中耳炎等疾病。' },
    'faq.cat4': { ko: '구매 & A/S', en: 'Purchase & A/S', ja: 'Purchase & A/S', zh: 'Purchase & A/S', tw: 'Purchase & A/S' },
    'faq.q15': { ko: '어디서 구매할 수 있나요?', en: 'Where can I buy it?', ja: 'KC認証とは何ですか？', zh: 'KC认证是什么？', tw: 'KC認證是什么？' },
    'faq.a15': { ko: '온라인 스토어에서 구매하실 수 있으며, 아이레 다이브 센터에서 직접 체험 후 현장 구매도 가능합니다.', en: 'Available at our online store. You can also try and buy in person at Aire Dive Center.', ja: 'KC(Korea Certification)は韓国の国家安全認証です。国家公認試験機関KTC(韓国試験認証院)の試験を経て安全性が確認された製品にのみ付与されます。', zh: 'KC(Korea Certification)是韩国国家安全认证。只有通过国家认证机构KTC(韩国测试认证院)检测确认安全的产品才能获得。', tw: 'KC(Korea Certification)是韓國國家安全認證。只有通過國家認證機構KTC(韓國測试認證院)檢測確認安全的產品才能獲得。' },
    'faq.q16': { ko: '보증 기간은 얼마인가요?', en: 'What is the warranty period?', ja: '価格はいくらですか？', zh: '价格是多少？', tw: '價格是多少？' },
    'faq.a16': { ko: '제품 구매일로부터 <strong>1개월 이내</strong>, 제품 자체 결함에 한해 무상 A/S를 제공합니다. 침수·이물질 유입·사용자 과실에 의한 파손은 유상 수리 대상입니다. 구매 영수증 등 구매 증빙을 첨부하여 이메일로 신청해 주세요.', en: 'Free A/S for manufacturing defects within <strong>1 month</strong> of purchase. Damage from water, debris, or user error is covered by paid repair. Submit via email with proof of purchase.', ja: '129,000ウォンです。韓国設計・製造でコストを削減しています。', zh: '129,000韩元。韩国设计和制造，降低了成本。', tw: '129,000韓元。韓國設计和製造，降低了成本。' },
    'faq.q17': { ko: 'A/S는 어떻게 받나요?', en: 'How do I get A/S service?', ja: '保証はありますか？', zh: '有保修吗？', tw: '有保修吗？' },
    'faq.a17': { ko: '<a href="support.html">고객 지원 페이지</a>에서 문의해 주세요. 증상 확인 후 택배 수거 → 수리/교체 → 발송 순으로 진행됩니다. 국내 제조 제품이라 빠른 A/S가 가능합니다.', en: 'Contact us through our <a href="support.html">support page</a>. Process: confirm symptoms → courier pickup → repair/replace → ship back. Fast A/S since it\'s made in Korea.', ja: 'Contact us through our <a href="support.html">support page</a>. Process: confirm symptoms → courier pickup → repair/replace → ship back. Fast A/S since it\'s made in Korea.', zh: 'Contact us through our <a href="support.html">support page</a>. Process: confirm symptoms → courier pickup → repair/replace → ship back. Fast A/S since it\'s made in Korea.', tw: 'Contact us through our <a href="support.html">support page</a>. Process: confirm symptoms → courier pickup → repair/replace → ship back. Fast A/S since it\'s made in Korea.' },
    'faq.q18': { ko: '강사 할인 / 딜러 계약이 가능한가요?', en: 'Are instructor discounts / dealer agreements available?', ja: 'ディーラー契約はできますか？', zh: '可以成为经销商吗？', tw: '可以成為經銷商吗？' },
    'faq.a18': { ko: '네! 다이브샵 및 다이빙 강사 분들과의 딜러 계약을 환영합니다. 도매 가격, 교육용 특별 할인 등 자세한 조건은 <a href="mailto:megakdh@createch.kr">megakdh@createch.kr</a>으로 문의해 주세요.', en: 'Yes! We welcome dealer partnerships with dive shops and instructors. For wholesale pricing and educational discounts, contact <a href="mailto:megakdh@createch.kr">megakdh@createch.kr</a>.', ja: 'Yes! We welcome dealer partnerships with dive shops and instructors. For wholesale pricing and educational discounts, contact <a href="mailto:megakdh@createch.kr">megakdh@createch.kr</a>.', zh: 'Yes! We welcome dealer partnerships with dive shops and instructors. For wholesale pricing and educational discounts, contact <a href="mailto:megakdh@createch.kr">megakdh@createch.kr</a>.', tw: 'Yes! We welcome dealer partnerships with dive shops and instructors. For wholesale pricing and educational discounts, contact <a href="mailto:megakdh@createch.kr">megakdh@createch.kr</a>.' },
    'faq.q19': { ko: '해외 배송이 가능한가요?', en: 'Do you ship internationally?', ja: '海外配送はできますか？', zh: '支持海外配送吗？', tw: '支持海外配送吗？' },
    'faq.a19': { ko: '현재 국내 배송만 지원하고 있습니다. 해외 배송은 준비 중이며, <a href="mailto:megakdh@createch.kr">megakdh@createch.kr</a>으로 문의해 주시면 개별적으로 안내드리겠습니다.', en: 'Currently domestic shipping only. International shipping is coming soon. Contact <a href="mailto:megakdh@createch.kr">megakdh@createch.kr</a> for individual arrangements.', ja: 'Currently domestic shipping only. International shipping is coming soon. Contact <a href="mailto:megakdh@createch.kr">megakdh@createch.kr</a> for individual arrangements.', zh: 'Currently domestic shipping only. International shipping is coming soon. Contact <a href="mailto:megakdh@createch.kr">megakdh@createch.kr</a> for individual arrangements.', tw: 'Currently domestic shipping only. International shipping is coming soon. Contact <a href="mailto:megakdh@createch.kr">megakdh@createch.kr</a> for individual arrangements.' },
    'faq.cta-title': { ko: '찾는 답변이 없으신가요?', en: 'Can\'t find your answer?', ja: 'Can\'t find your answer?', zh: 'Can\'t find your answer?', tw: 'Can\'t find your answer?' },
    'faq.cta-desc': { ko: '아래 버튼을 눌러 직접 문의해 주세요.', en: 'Click below to contact us directly.', ja: 'メールでお気軽にお問い合わせください。', zh: '请随时通过邮件联系我们。', tw: '請随時通過郵件聯繫我們。' },
    'faq.cta-btn': { ko: '문의하기', en: 'Contact Us', ja: 'Contact Us', zh: 'Contact Us', tw: 'Contact Us' },

    // ═══ SUPPORT PAGE ═══
    'support.page-title': { ko: '고객 지원', en: 'Customer Support', ja: 'サポート', zh: '支持', tw: '支持' },
    'support.page-desc': { ko: '도움이 필요하신가요? 아래에서 문의 유형을 선택하세요.', en: 'Need help? Select your inquiry type below.', ja: 'お困りですか？お手伝いします。', zh: '遇到困难？我们来帮助您。', tw: '遇到困難？我們来帮助您。' },
    'support.as-title': { ko: 'A/S 수리', en: 'A/S Repair', ja: 'A/S・修理', zh: '售后・维修', tw: '售後・维修' },
    'support.as-desc': { ko: '제품 고장, 센서 이상, 물리적 손상 등 수리가 필요한 경우', en: 'Product malfunction, sensor issues, physical damage requiring repair', ja: '製品の故障やお修理が必要な場合', zh: '产品故障或需要维修时', tw: '產品故障或需要维修時' },
    'support.as-warranty': { ko: '보증 기간', en: 'Warranty', ja: 'Warranty', zh: 'Warranty', tw: 'Warranty' },
    'support.as-warranty-val': { ko: '구매일로부터 1개월', en: '1 month from purchase', ja: '1 month from purchase', zh: '1 month from purchase', tw: '1 month from purchase' },
    'support.as-time': { ko: '처리 기간', en: 'Processing', ja: 'Processing', zh: 'Processing', tw: 'Processing' },
    'support.as-time-val': { ko: '접수 후 3~5 영업일', en: '3~5 business days', ja: '3~5 business days', zh: '3~5 business days', tw: '3~5 business days' },
    'support.as-method': { ko: '방법', en: 'Method', ja: 'Method', zh: 'Method', tw: 'Method' },
    'support.as-method-val': { ko: '택배 수거 → 수리 → 발송', en: 'Courier pickup → Repair → Ship', ja: 'Courier pickup → Repair → Ship', zh: 'Courier pickup → Repair → Ship', tw: 'Courier pickup → Repair → Ship' },
    'support.usage-title': { ko: '사용 문의', en: 'Usage Inquiry', ja: 'Usage Inquiry', zh: 'Usage Inquiry', tw: 'Usage Inquiry' },
    'support.usage-desc': { ko: '앱 사용법, 연결 문제, 캘리브레이션, 측정 관련 질문', en: 'App usage, connection issues, calibration, measurement questions', ja: 'App usage, connection issues, calibration, measurement questions', zh: 'App usage, connection issues, calibration, measurement questions', tw: 'App usage, connection issues, calibration, measurement questions' },
    'support.usage-hint': { ko: '먼저 확인해 보세요:', en: 'Check these first:', ja: 'Check these first:', zh: 'Check these first:', tw: 'Check these first:' },
    'support.purchase-title': { ko: '구매 문의', en: 'Purchase Inquiry', ja: 'Purchase Inquiry', zh: 'Purchase Inquiry', tw: 'Purchase Inquiry' },
    'support.purchase-desc': { ko: '가격, 배송, 강사 할인, 딜러 계약, 단체 구매 관련 문의', en: 'Pricing, shipping, instructor discounts, dealer agreements, bulk orders', ja: 'Pricing, shipping, instructor discounts, dealer agreements, bulk orders', zh: 'Pricing, shipping, instructor discounts, dealer agreements, bulk orders', tw: 'Pricing, shipping, instructor discounts, dealer agreements, bulk orders' },
    'support.purchase-dealer': { ko: '강사 / 딜러', en: 'Instructor / Dealer', ja: 'Instructor / Dealer', zh: 'Instructor / Dealer', tw: 'Instructor / Dealer' },
    'support.purchase-dealer-val': { ko: '이메일 별도 문의', en: 'Contact via email', ja: 'Contact via email', zh: 'Contact via email', tw: 'Contact via email' },
    'support.purchase-store': { ko: '현장 구매', en: 'In-store', ja: 'In-store', zh: 'In-store', tw: 'In-store' },
    'support.purchase-store-val': { ko: '아이레 다이브 센터', en: 'Aire Dive Center', ja: 'Aire Dive Center', zh: 'Aire Dive Center', tw: 'Aire Dive Center' },
    'support.tech-title': { ko: '기술 / 개발', en: 'Technical / Development', ja: 'Technical / Development', zh: 'Technical / Development', tw: 'Technical / Development' },
    'support.tech-desc': { ko: '펌웨어, 오픈소스, API, 커스텀 개발 관련 문의', en: 'Firmware, open source, API, custom development inquiries', ja: 'Firmware, open source, API, custom development inquiries', zh: 'Firmware, open source, API, custom development inquiries', tw: 'Firmware, open source, API, custom development inquiries' },
    'support.contact-label': { ko: 'CONTACT', en: 'CONTACT', ja: 'CONTACT', zh: 'CONTACT', tw: 'CONTACT' },
    'support.contact-title': { ko: '문의하기', en: 'Contact Us', ja: 'Contact Us', zh: 'Contact Us', tw: 'Contact Us' },
    'support.contact-sub': { ko: '아래 양식을 작성해 주시면 빠르게 답변 드리겠습니다', en: 'Fill out the form below and we\'ll respond promptly', ja: 'Fill out the form below and we\'ll respond promptly', zh: 'Fill out the form below and we\'ll respond promptly', tw: 'Fill out the form below and we\'ll respond promptly' },
    'support.form-name': { ko: '이름', en: 'Name', ja: 'Name', zh: 'Name', tw: 'Name' },
    'support.form-email': { ko: '이메일', en: 'Email', ja: 'Email', zh: 'Email', tw: 'Email' },
    'support.form-category': { ko: '문의 유형', en: 'Inquiry Type', ja: 'Inquiry Type', zh: 'Inquiry Type', tw: 'Inquiry Type' },
    'support.form-select': { ko: '선택하세요', en: 'Select', ja: 'Select', zh: 'Select', tw: 'Select' },
    'support.form-cat-as': { ko: 'A/S 수리', en: 'A/S Repair', ja: 'A/S Repair', zh: 'A/S Repair', tw: 'A/S Repair' },
    'support.form-cat-usage': { ko: '사용 문의', en: 'Usage Inquiry', ja: 'Usage Inquiry', zh: 'Usage Inquiry', tw: 'Usage Inquiry' },
    'support.form-cat-purchase': { ko: '구매 문의', en: 'Purchase Inquiry', ja: 'Purchase Inquiry', zh: 'Purchase Inquiry', tw: 'Purchase Inquiry' },
    'support.form-cat-instructor': { ko: '강사 할인 / 딜러 계약 문의', en: 'Instructor / Dealer Inquiry', ja: 'Instructor / Dealer Inquiry', zh: 'Instructor / Dealer Inquiry', tw: 'Instructor / Dealer Inquiry' },
    'support.form-cat-tech': { ko: '기술 / 개발', en: 'Technical / Development', ja: 'Technical / Development', zh: 'Technical / Development', tw: 'Technical / Development' },
    'support.form-cat-other': { ko: '기타', en: 'Other', ja: 'Other', zh: 'Other', tw: 'Other' },
    'support.form-subject': { ko: '제목', en: 'Subject', ja: 'Subject', zh: 'Subject', tw: 'Subject' },
    'support.form-subject-ph': { ko: '문의 제목을 입력하세요', en: 'Enter your subject', ja: 'お問い合わせ件名を入力してください', zh: '请输入咨询主题', tw: '請輸入諮詢主題' },
    'support.form-message': { ko: '내용', en: 'Message', ja: 'Message', zh: 'Message', tw: 'Message' },
    'support.form-message-ph': { ko: '문의 내용을 자세히 적어주세요. A/S의 경우 증상과 구매일을 포함해 주세요.', en: 'Please describe your inquiry in detail. For A/S, include symptoms and purchase date.', ja: 'Please describe your inquiry in detail. For A/S, include symptoms and purchase date.', zh: 'Please describe your inquiry in detail. For A/S, include symptoms and purchase date.', tw: 'Please describe your inquiry in detail. For A/S, include symptoms and purchase date.' },
    'support.form-order': { ko: '주문번호 (선택)', en: 'Order Number (optional)', ja: 'Order Number (optional)', zh: 'Order Number (optional)', tw: 'Order Number (optional)' },
    'support.form-order-ph': { ko: 'A/S 문의 시 주문번호를 입력하세요', en: 'Enter order number for A/S inquiries', ja: 'Enter order number for A/S inquiries', zh: 'Enter order number for A/S inquiries', tw: 'Enter order number for A/S inquiries' },
    'support.form-submit': { ko: '문의 보내기', en: 'Send Inquiry', ja: 'Send Inquiry', zh: 'Send Inquiry', tw: 'Send Inquiry' },
    'support.success-title': { ko: '문의가 접수되었습니다', en: 'Inquiry Submitted', ja: 'Inquiry Submitted', zh: 'Inquiry Submitted', tw: 'Inquiry Submitted' },
    'support.success-desc': { ko: '빠른 시일 내에 답변 드리겠습니다.<br>확인 메일을 보내드렸으니 수신함을 확인해 주세요.', en: 'We\'ll respond as soon as possible.<br>A confirmation email has been sent — please check your inbox.', ja: 'We\'ll respond as soon as possible.<br>A confirmation email has been sent — please check your inbox.', zh: 'We\'ll respond as soon as possible.<br>A confirmation email has been sent — please check your inbox.', tw: 'We\'ll respond as soon as possible.<br>A confirmation email has been sent — please check your inbox.' },
    'support.success-btn': { ko: '홈으로 돌아가기', en: 'Back to Home', ja: 'Back to Home', zh: 'Back to Home', tw: 'Back to Home' },
    'support.email-title': { ko: '이메일', en: 'Email', ja: 'メール問い合わせ', zh: '邮件咨询', tw: '郵件諮詢' },
    'support.email-sub': { ko: '영업일 기준 1~2일 내 답변', en: 'Response within 1~2 business days', ja: '営業日1~2日以内に返信', zh: '1~2个工作日内回复', tw: '1~2個工作日內回復' },
    'support.kakao-title': { ko: '카카오톡', en: 'KakaoTalk', ja: 'カカオトーク', zh: 'KakaoTalk', tw: 'KakaoTalk' },
    'support.kakao-sub': { ko: '실시간 채팅 상담', en: 'Real-time chat support', ja: 'リアルタイムチャット相談', zh: '实时聊天咨询', tw: '實時聊天諮詢' },
    'support.github-desc': { ko: '기술 이슈 & 버그 리포트', en: 'Technical issues & bug reports', ja: '技術問題＆バグ報告', zh: '技术问题和Bug报告', tw: '技术問題和Bug报告' },
    'support.github-sub': { ko: '오픈소스 커뮤니티', en: 'Open source community', ja: 'オープンソースコミュニティ', zh: '开源社区', tw: '開源社区' },
    'support.troubleshoot': { ko: '문제 해결', en: 'Troubleshooting', ja: '取扱説明書', zh: '产品说明书', tw: '產品說明書' },
    'support.form-name-ph': { ko: '홍길동', en: 'John Doe', ja: '山田太郎', zh: '张三', tw: '张三' },
    'support.form-subject-ph': { ko: '문의 제목을 입력하세요', en: 'Enter your subject', ja: 'Enter your subject', zh: 'Enter your subject', tw: 'Enter your subject' },
    'support.form-category-default': { ko: '선택하세요', en: 'Select', ja: '選択してください', zh: '请选择', tw: '請選擇' },
    'support.form-category-as': { ko: 'A/S 수리', en: 'A/S Repair', ja: 'A/S修理', zh: '售后维修', tw: '售後维修' },
    'support.form-category-usage': { ko: '사용 문의', en: 'Usage Inquiry', ja: '使い方のご質問', zh: '使用咨询', tw: '使用諮詢' },
    'support.form-category-purchase': { ko: '구매 문의', en: 'Purchase Inquiry', ja: 'ご購入のご質問', zh: '购买咨询', tw: '購買諮詢' },
    'support.form-category-instructor': { ko: '강사 할인 / 딜러 계약 문의', en: 'Instructor / Dealer Inquiry', ja: 'インストラクター割引/ディーラー契約', zh: '教练折扣/经销合作', tw: '教練折扣/經銷合作' },
    'support.form-category-tech': { ko: '기술 / 개발', en: 'Technical / Development', ja: '技術/開発', zh: '技术/开发', tw: '技术/開發' },
    'support.form-category-other': { ko: '기타', en: 'Other', ja: 'その他', zh: '其他', tw: '其他' },
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
