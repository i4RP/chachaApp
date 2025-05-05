import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QRコード決済アプリ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF5A5F)),
        useMaterial3: true,
      ),
      home: const PaymentPage(),
    );
  }
}

class PaymentPage extends HookWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    // タブの選択状態を管理
    final selectedTabIndex = useState(0);
    
    // タイマーの状態を管理
    final seconds = useState(89); // 1分29秒
    final timerController = useStreamController<int>();
    
    // タイマーの初期化
    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (seconds.value > 0) {
          seconds.value--;
        } else {
          // タイマーが0になったら、リセット
          seconds.value = 89;
        }
        timerController.add(seconds.value);
      });
      
      return timer.cancel;
    }, const []);
    
    // 分と秒に変換
    final minutes = (seconds.value / 60).floor();
    final remainingSeconds = seconds.value % 60;
    
    return Scaffold(
      body: Container(
        color: const Color(0xFFFF5A5F),
        child: SafeArea(
          child: Column(
            children: [
              // ヘッダー部分
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // PayPayロゴ
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'P',
                              style: TextStyle(
                                color: Color(0xFFFF5A5F),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'PayPay',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // 閉じるボタン
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 30),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              
              // タブ部分
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => selectedTabIndex.value = 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          decoration: BoxDecoration(
                            color: selectedTabIndex.value == 0 ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              'お店に支払う',
                              style: TextStyle(
                                color: selectedTabIndex.value == 0 ? const Color(0xFF333333) : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => selectedTabIndex.value = 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          decoration: BoxDecoration(
                            color: selectedTabIndex.value == 1 ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              '送る・受け取る',
                              style: TextStyle(
                                color: selectedTabIndex.value == 1 ? const Color(0xFF333333) : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // メインコンテンツ
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      // バーコード
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        width: double.infinity,
                        child: BarcodeWidget(
                          barcode: Barcode.code128(),
                          data: '0000 0001 0002 0003 0004 0005',
                          drawText: true,
                          height: 100,
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // QRコード
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: QrImageView(
                          data: 'https://paypay.ne.jp/payment/12345',
                          version: QrVersions.auto,
                          size: 200.0,
                          // Removed embedded image to fix error
                        ),
                      ),
                      
                      const SizedBox(height: 10),
                      
                      // タイマー
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () {
                              seconds.value = 89; // リセット
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 10),
                      
                      // 注意書き
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '3万円以上のお支払いには本人確認が必要です',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            '詳細',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      
                      const Spacer(),
                      
                      // 残高表示
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(Icons.account_balance_wallet, color: Colors.blue),
                            ),
                            const SizedBox(width: 16),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PayPay残高',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '残高 2,500円',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'チャージ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '変更',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // フッター
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.qr_code, color: Color(0xFFFF5A5F)),
                        const SizedBox(height: 4),
                        Text(
                          'コード支払い',
                          style: TextStyle(
                            color: const Color(0xFFFF5A5F),
                            fontSize: 12,
                            fontWeight: selectedTabIndex.value == 0 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(Icons.crop_free, color: Colors.grey),
                        const SizedBox(height: 4),
                        Text(
                          'スキャン支払い',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: selectedTabIndex.value == 1 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(Icons.person, color: Colors.grey),
                        const SizedBox(height: 4),
                        Text(
                          'PayPay管理',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: selectedTabIndex.value == 2 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
