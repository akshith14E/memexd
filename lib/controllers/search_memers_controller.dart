import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/models/fetched_user_model.dart';
import 'package:memexd/providers/auth_provider.dart';

final searchMemersProvider = StateNotifierProvider<SearchMemersController,
    AsyncValue<List<FetchedUser>>>((ref) => SearchMemersController(ref.read));

class SearchMemersController
    extends StateNotifier<AsyncValue<List<FetchedUser>>> {
  final Reader _reader;
  SearchMemersController(this._reader) : super(AsyncData([]));

  void query(String searchString) async {
    state = AsyncLoading();
    print('object');
    final fetchUsers = await _reader(firebaseDBProvider)
        .reference()
        .child('Users')
        .orderByChild('username')
        .startAt(searchString)
        .endAt(searchString + '\uf8ff')
        .once()
        .then((data) => data.value)
        .onError((error, stackTrace) => state = AsyncError(error!));
    state = AsyncData([]);
    if (fetchUsers != null) {
      for (var user in fetchUsers.values) {
        state.data!.value.add(FetchedUser.fromJson(user));
      }
    }
    print(state.data!.value.length);
  }
}
