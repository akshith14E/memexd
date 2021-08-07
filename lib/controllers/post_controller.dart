import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/models/comment_model.dart';
import 'package:memexd/models/fetched_user_model.dart';
import 'package:memexd/models/post_model.dart';
import 'package:memexd/models/rating_model.dart';
import 'package:memexd/providers/auth_provider.dart';
import 'package:memexd/extensions/reatimeDBExtention.dart';

final postsProvider =
    StateNotifierProvider<PostController, AsyncValue<List<Post>>>(
        (ref) => PostController(ref.read));
enum CurrentFeed { xplore, dyn }

class PostController extends StateNotifier<AsyncValue<List<Post>>> {
  final Reader _reader;
  List<Post>? get getPosts => state.data?.value;
  var lastXplorePost;
  var lastDynamicPost;
  var userFromExtra;
  CurrentFeed currentFeed = CurrentFeed.xplore;
  CurrentFeed changedFeed = CurrentFeed.xplore;
  bool hasMorePosts = true;
  bool refreshing = false;
  List<Post> dynamicFeedPost = [];
  List<Post> xploreFeedPost = [];
  PostController(
    this._reader,
  ) : super(AsyncData([]));

  query(bool inXplore, bool refresh) async {
    refreshing = true;
    PostFromDB postFromDB;
    Rating rating;
    FetchedUser fetchedUser;
    NoOfComments noOfComments = NoOfComments(tc: "");
    List<Post> postsFetched = [];
    List<Post> previousState = inXplore ? xploreFeedPost : dynamicFeedPost;
    if (inXplore && lastXplorePost == null) state = AsyncLoading();
    if (!inXplore && lastDynamicPost == null) state = AsyncLoading();
    final posts = inXplore
        ? await _fetchXplorePosts(lastXplorePost)
        : await _fetchDynamicPosts(lastDynamicPost);
    if (inXplore) {
      lastXplorePost = posts.elementAt(posts.length - 1);
    } else {
      lastDynamicPost = posts.elementAt(posts.length - 1);
    }
    postsFetched = [];
    for (var post in posts) {
      postFromDB = PostFromDB.fromJson(post);
      var ratingFromDB = await _getRatingFromPostId(postFromDB.postId);
      rating = Rating(rating: ratingFromDB.value?.toString() ?? "0");

      var cmCountFromDb = await _getCommentsNoFromPostId(postFromDB.postId);
      noOfComments =
          NoOfComments(tc: cmCountFromDb.value?.values.first.toString() ?? "0");

      var user = await _getPushblisherFromId(postFromDB.publisher);
      fetchedUser = FetchedUser.fromJson(user.value);
      postsFetched.add(Post(
        p: postFromDB,
        r: rating,
        u: fetchedUser,
        nc: noOfComments,
      ));
    }
    changedFeed = inXplore ? CurrentFeed.xplore : CurrentFeed.dyn;
    print(changedFeed == currentFeed);
    List xpldata = refresh
        ? [
            ...postsFetched,
            ...previousState,
          ]
        : [...previousState, ...postsFetched];
    List dyndata = refresh
        ? [...postsFetched, ...dynamicFeedPost]
        : [...dynamicFeedPost, ...postsFetched];
    if (changedFeed == currentFeed) {
      state = inXplore ? AsyncData([...xpldata]) : AsyncData([...dyndata]);
      if (inXplore) {
        xploreFeedPost = [...state.data!.value];
      } else {
        dynamicFeedPost = [...state.data!.value];
      }
    } else {
      if (inXplore) {
        xploreFeedPost = [...xpldata];
      } else {
        dynamicFeedPost = [...dyndata];
      }
    }
    refreshing = false;
  }

  void setState(List<Post>? data) {
    state = data == null ? AsyncData([]) : AsyncData([...data]);
  }

  double _parse(String value) {
    return double.parse(value);
  }

  updateRating(Post post, double value) async {
    final postId = post.p.postId;
    DatabaseReference _ref;
    final currentUserId = _reader(authServicesProvider).getCurrentUser()!.uid;
    final currentPostsState = state.data!.value;
    final snapshot = await _getRatingFromPostId(postId);
    int updatedTrtrs = post.p.trtrs;
    if (snapshot.value == null) {
      _ref = _reader(firebaseDBProvider)
          .byChild("Posts")
          .child(postId)
          .child("trtrs");
      updatedTrtrs = await _runTransaction(_ref, 1, "updateTrtrs");
    }
    _ref = _reader(firebaseDBProvider)
        .byChild("Ratings")
        .child(postId)
        .child(currentUserId);
    final updatedRating = await _runTransaction(_ref, value, "updateRating");
    _ref = _reader(firebaseDBProvider)
        .byChild("Posts")
        .child(postId)
        .child("trtrs");
    final totalRating = (-_parse(post.r.rating) + value);

    _ref =
        _reader(firebaseDBProvider).byChild("Posts").child(postId).child("tr");
    final updatedTr = await _runTransaction(_ref, totalRating, "updateTr",
        divider: updatedTrtrs.toDouble());

    for (var post in currentPostsState) {
      if (post.p.postId == postId) {
        post.r = post.r.copyWith(rating: updatedRating.toString());
        post.p = post.p.copyWith(tr: updatedTr.toDouble(), trtrs: updatedTrtrs);
      }
    }
    setState(currentPostsState);
  }

  _fetchXplorePosts(lastXplorePost) async {
    final int limit = 4;
    dynamic fetchedData;
    if (hasMorePosts) {
      if (lastXplorePost == null) {
        fetchedData = await _reader(firebaseDBProvider)
            .byChild('Posts')
            .orderByChild('time')
            .limitToFirst(limit)
            .once()
            .then((data) {
          return data.value.values;
        });
      } else {
        fetchedData = await _reader(firebaseDBProvider)
            .byChild('Posts')
            .orderByChild('time')
            .startAt(lastXplorePost['time'], key: 'time')
            .limitToFirst(limit)
            .once()
            .then((data) {
          return data.value.values;
        });
      }
    } else {
      fetchedData = [];
    }
    hasMorePosts = fetchedData.length >= limit;
    return fetchedData;
  }

  _fetchDynamicPosts(lastXplorePost) async {
    final int limit = 10;
    dynamic fetchedData;
    if (userFromExtra == null) await _fetchUserFromExtras();
    if (hasMorePosts) {
      if (lastDynamicPost == null) {
        fetchedData = await _reader(firebaseDBProvider)
            .byChild('Posts')
            .orderByChild('publisher')
            .equalTo(userFromExtra)
            .limitToFirst(limit)
            .once()
            .then((data) {
          return data.value.values;
        });
      }
      // else {
      //   fetchedData = await _reader(firebaseDBProvider)
      //       .byChild('Posts')
      //       .orderByChild('publisher')
      //       .equalTo(userFromExtra)
      //       .startAt(lastDynamicPost['time'], key: 'time')
      //       .limitToFirst(limit)
      //       .once()
      //       .then((data) {
      //     return data.value.values;
      //   });
      // }
    } else {
      fetchedData = [];
    }
    hasMorePosts = fetchedData.length >= limit;
    return fetchedData;
  }

  Future<DataSnapshot> _getRatingFromPostId(String postId) async {
    final userId = _reader(authServicesProvider).getCurrentUser()?.uid;
    final snapshot = await _reader(firebaseDBProvider)
        .byChild("Ratings")
        .child(postId)
        .child(userId!)
        .once();
    return snapshot;
  }

  Future<DataSnapshot> _getCommentsNoFromPostId(String postId) async {
    final DataSnapshot snapshot = await _reader(firebaseDBProvider)
        .byChild("CommentCounts")
        .child(postId)
        .once();
    return snapshot;
  }

  Future<DataSnapshot> _getPushblisherFromId(String pubId) async {
    return await _reader(firebaseDBProvider)
        .byChild('Users')
        .child(pubId)
        .once();
  }

  _runTransaction(DatabaseReference ref, dynamic value, String v,
      {double? divider}) async {
    assert(value != null);
    final _transaction =
        await ref.runTransaction((MutableData mutableData) async {
      switch (v) {
        case "updateTrtrs":
          mutableData.value = (mutableData.value ?? 0) + value;
          return mutableData;
        case "updateRating":
          mutableData.value = value;
          return mutableData;
        case "updateTr":
          assert(divider != 0.0);
          mutableData.value =
              ((mutableData.value ?? 0) + value) / (divider ?? 1);
          return mutableData;
      }
      return mutableData;
    });
    if (_transaction.committed) {
      await ref.set(_transaction.dataSnapshot?.value);
      return _transaction.dataSnapshot?.value;
    } else {
      if (_transaction.error != null) {
        throw ValueError(error: _transaction.error?.message);
      }
    }
  }

  _fetchUserFromExtras() async {
    userFromExtra = await _reader(firebaseDBProvider)
        .byChild("Extras")
        .child("xdUid")
        .once()
        .then((data) => data.value);
  }
}

class ValueError extends Error {
  final String? error;
  ValueError({required this.error}) {
    toString();
  }
  @override
  String toString() {
    return 'ValueError{$error}';
  }
}
