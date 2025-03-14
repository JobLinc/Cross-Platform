import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'connections_state.dart';

class ConnectionsCubit extends Cubit<ConnectionsState> {
  ConnectionsCubit() : super(ConnectionsInitial());
}
