// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

class HomeState extends Equatable {
  final HomeDataStatus homeDataStatus;
  const HomeState({required this.homeDataStatus});

  HomeState copyWith({HomeDataStatus? newHomeStatus}) {
    return HomeState(homeDataStatus: newHomeStatus ?? homeDataStatus);
  }

  @override
  List<Object> get props => [homeDataStatus];
}
