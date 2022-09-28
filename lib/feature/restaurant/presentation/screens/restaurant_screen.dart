import 'package:code_factory2_bloc_clean_architecture/core/configs/color_const.dart';
import 'package:code_factory2_bloc_clean_architecture/core/data/dto/response_dto.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/domain/entities/restaurant_model.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/presentation/blocs/restaurant_bloc/restaurant_bloc.dart';
import 'package:code_factory2_bloc_clean_architecture/feature/restaurant/presentation/widgets/restaurant_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(scrollListener);
  }

  void scrollListener() {
    // 현재 위치가 최대 길이보다 조금 덜 되는 위치면
    // 새로운 데이터를 추가 요청
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      context.read<RestaurantBloc>().add(const GetRestaurantListEvent(fetchMore: true));
    }
  }

  @override
  void dispose() {
    controller.removeListener(scrollListener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RestaurantBloc,RestaurantState>(
      listener: (context, state) {
        if(state.requestStatus == RequestStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('에러 발생')),
          );
        }
      },
      builder: (context, state) {
        final restaurantModel = state.restaurantList;
        if(restaurantModel is !ResponseDto<RestaurantModel>){
          return Container();
        }

        final model = restaurantModel.data;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<RestaurantBloc>().add(const GetRestaurantListEvent(forceRefetch: true));
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: controller,
              itemBuilder: (context, index) {
                if (index == restaurantModel.data.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: state.requestStatus == RequestStatus.fetchMore
                          ? CircularProgressIndicator()
                          : Text('마지막 데이터입니다.'),
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    // 아래와 같은 역할
                    // context.go('/restaurant/${entities.id}');

                    context.goNamed(
                      'restaurantDetail',
                      params: {'rid': model[index].id},
                    );
                  },
                  child: RestaurantCard.fromModel(model: model[index]),
                );
              },
              separatorBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(
                    color: BODY_TEXT_COLOR,
                    thickness: 2.0,
                  ),
                );
              },
              itemCount: model.length + 1,
            ),
          ),
        );
      },
    );
  }
}
