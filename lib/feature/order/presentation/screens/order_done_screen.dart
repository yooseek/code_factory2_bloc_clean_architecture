import 'package:code_factory2_bloc_clean_architecture/core/configs/color_const.dart';
import 'package:code_factory2_bloc_clean_architecture/core/presentation/widgets/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderDoneScreen extends StatelessWidget {
  static String get routeName => 'orderDone';

  const OrderDoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.thumb_up_alt_outlined,
                color: PRIMARY_COLOR,
                size: 50.0,
              ),
              const SizedBox(
                height: 32.0,
              ),
              const Text('걀제가 완료되었습니다.',textAlign: TextAlign.center),
              const SizedBox(
                height: 32.0,
              ),
              ElevatedButton(
                onPressed: () {
                  context.goNamed('home');
                },
                style: ElevatedButton.styleFrom(primary: PRIMARY_COLOR),
                child: Text('홈으로'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
