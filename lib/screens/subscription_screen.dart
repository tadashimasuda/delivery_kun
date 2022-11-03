import 'package:delivery_kun/components/icon_and_text.dart';
import 'package:delivery_kun/services/subscription.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class PurchaseSubscriptionScreen extends StatefulWidget {
  const PurchaseSubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<PurchaseSubscriptionScreen> createState() =>
      _PurchaseSubscriptionScreenState();
}

class _PurchaseSubscriptionScreenState
    extends State<PurchaseSubscriptionScreen> {
  Subscription subscription = Subscription();
  bool _hasSubscribed = false;
  Offerings? offerings;

  final Uri _termsOfService = Uri.parse(
      "https://harmonious-boar-ca8.notion.site/eb5d9ad442694de797da8979222bd087");
  final Uri _privacyPolicy = Uri.parse(
      "https://harmonious-boar-ca8.notion.site/6d19d35840a8494c9cf73af19be393a7");

  void _getSubscription() async {
    await context.read<Subscription>().getOffers();
  }

  void _hasSubscription() async {
    await context.read<Subscription>().getCustomerInfo('subscriptions');
  }

  Future<void> _lanchURL(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  void initState() {
    _getSubscription();
    _hasSubscription();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    num screenWidth = MediaQuery.of(context).size.width;
    offerings = context.watch<Subscription>().offerings;
    _hasSubscribed = context.watch<Subscription>().hasSubscribed;

    return Scaffold(
      appBar: AppBar(
        title: const Text('プレミアムプラン'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            const Image(image: AssetImage("images/subscription.png")),
            const SizedBox(height: 20),
            const Text(
              'プレミアムプラン',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: screenWidth * 0.8,
              child: const IconAndText(
                icon: Icons.check_circle,
                text: '  広告が完全非表示（バナー・全面）',
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: screenWidth * 0.8,
                child: const IconAndText(
                  icon: Icons.check_circle,
                  text: '  4日以上前の配達履歴も見れる',
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                Package packeage =
                    offerings!.all['subscription_1m']!.availablePackages[0];
                await context.read<Subscription>().makePurchase(packeage);
                _hasSubscribed = context.read<Subscription>().hasSubscribed;
                if (!mounted) return;
              },
              style: ElevatedButton.styleFrom(
                primary: !_hasSubscribed ? Colors.redAccent : Colors.grey,
              ),
              child: SizedBox(
                width: screenWidth * 0.75,
                child: offerings != null
                    ? Column(children: [
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'プレミアムプランに登録する',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        offerings!.all['subscription_1m']!.availablePackages[0]
                                    .storeProduct.price ==
                                500.00
                            ? Text(
                                '${offerings!.all['subscription_1m']!.availablePackages[0].storeProduct.price.round()}円/1ヶ月',
                                style: const TextStyle(fontSize: 12),
                              )
                            : Text(
                                '￥${offerings!.all['subscription_1m']!.availablePackages[0].storeProduct.price}/1ヶ月',
                                style: const TextStyle(fontSize: 12),
                              ),
                        const SizedBox(
                          height: 5,
                        )
                      ])
                    : const CircularProgressIndicator(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
              child: SizedBox(
                height: 45,
                width: screenWidth * 0.75,
                child: const Center(
                  child: Text(
                    'ストアから購入状態を復元する',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: screenWidth * 0.8,
              child: const Text(
                  '課金はAppleアカウントごとに行われます。\n有料プランは自動更新されます。有効期限の24時間前であれば、停止ができます。\n自動更新の停止は、購入後にAppleIDの設定画面から可能です。'),
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () {
                _lanchURL(_termsOfService);
              },
              child: const Text('利用規約'),
            ),
            TextButton(
              onPressed: () {
                _lanchURL(_privacyPolicy);
              },
              child: const Text('プライバシーポリシー'),
            ),
            const SizedBox(
              height: 20,
            ),
          ]),
        ),
      ),
    );
  }
}
