import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../arguments/news_arguments.dart';
import '../../blocs/foryou_bloc.dart';
import '../../constants/colors.dart';
import '../../handlers/api_response.dart';
import '../../models/responseModels/news_response_model.dart';
import 'headlines.dart';
import 'headlines_details.dart';

class ForYou extends StatefulWidget {
  // const ForYou({Key? key, required User user})
  //     : _user = user,
  //       super(key: key);

  // final User _user;
  @override
  State<ForYou> createState() => _ForYouState();
}

class _ForYouState extends State<ForYou> {
  final bool _isSigningOut = false;

  String formattedDate = DateFormat("EEEE , d MMM").format(DateTime.now());

  final ForYouNewsBloc _forYouNewsBloc = ForYouNewsBloc();
  void _onShare(BuildContext context, String shareLink) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(shareLink,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  @override
  void initState() {
    super.initState();
    _forYouNewsBloc.newsDataResponse("in");
  }

  Future<void> refreshData() async {
    // Simulating an API request or data refresh
    await Future.delayed(const Duration(milliseconds: 5))
        .then((value) => setState(() {
              _forYouNewsBloc.newsDataResponse("in");
            }));
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final GlobalKey<LiquidPullToRefreshState> refreshIndicatorKey =
        GlobalKey<LiquidPullToRefreshState>();

    return RefreshIndicator(
      strokeWidth: 3,
      key: refreshIndicatorKey,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: refreshData,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // Container(
              //   margin: const EdgeInsets.only(
              //       left: 12.0, right: 12.0, top: 12.0, bottom: 5.0),
              //   child: const Text(
              //     "Your briefing",
              //     overflow: TextOverflow.ellipsis,
              //     maxLines: 2,
              //     textAlign: TextAlign.justify,
              //     textScaleFactor: 1.3,
              //     style: TextStyle(
              //         color: Color(0xFF0D0821),
              //         fontSize: 24.0,
              //         fontWeight: FontWeight.w500),
              //   ),
              // ),

              // Container(
              //   margin: const EdgeInsets.only(
              //       left: 14.0, right: 12.0, top: 12.0, bottom: 20.0),
              //   child: Text(
              //     formattedDate,
              //     overflow: TextOverflow.ellipsis,
              //     maxLines: 2,
              //     textAlign: TextAlign.justify,
              //     textScaleFactor: 1.3,
              //     style: TextStyle(
              //         color: Colors.black.withOpacity(.5),
              //         fontSize: 14.0,
              //         fontWeight: FontWeight.w400,
              //         fontStyle: FontStyle.italic),
              //   ),
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 12.0, right: 12.0, top: 12.0, bottom: 12.0),
                    child: Text(
                      "Top Stories",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.justify,
                      textScaleFactor: 1.3,
                      style: TextStyle(
                          color: Color(0xFF0D0821),
                          fontSize: 24.0,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  // SizedBox(
                  //   width: 50.0,
                  //   height: 40,
                  //   child: Container(
                  //     margin: const EdgeInsets.only(right: 12.0),
                  //     decoration: BoxDecoration(
                  //       color: Color(0xFF0D0821),
                  //       borderRadius: BorderRadius.circular(12.0),
                  //     ),
                  //     child: IconButton(
                  //         onPressed: () {
                  //           Navigator.of(context).push(MaterialPageRoute(
                  //               builder: (context) => Headlines()));
                  //         },
                  //         icon: const Icon(
                  //           Icons.arrow_forward_ios,
                  //           color: Colors.white,
                  //           size: 20.0,
                  //         )),
                  //   ),
                  // )
                ],
              ),
              StreamBuilder<ApiResponse<NewsResponseModel>>(
                stream: _forYouNewsBloc.forYouDataStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.loading:
                        return Container(
                          color: Colors.blue,
                          child: const Center(
                              child: CircularProgressIndicator(
                                  color: Color(0xFF0D0821))),
                        );

                      case Status.completed:
                        var getSnapshotdata = snapshot.data?.data ?? [];
                        print("For you inside data");
                        return Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, snapshotIndex) {
                                var getSnapshot = snapshot.data?.data?.articles;
                                return GestureDetector(
                                  onTap: () => Navigator.pushNamed(context,
                                      HeadlinesDetails.headlinesDetails,
                                      arguments: NewsArguments(
                                          newsArguments:
                                              getSnapshot[snapshotIndex].url)),
                                  child: Card(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 12.0,
                                          right: 12.0,
                                          top: 12.0,
                                          bottom: 12.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              child: CachedNetworkImage(
                                                imageUrl: getSnapshot![
                                                            snapshotIndex]
                                                        .urlToImage ??
                                                    "https://mcdn.wallpapersafari.com/medium/87/17/VF4DQk.jpg",
                                                placeholder: (context, url) => Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                            color: Color(
                                                                0xFF0D0821))),
                                                //                                          errorWidget: (context, url, error) =>
                                                //                                            const Icon(Icons.error),
                                              )),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 12.0,
                                                bottom: 12.0,
                                                right: 20.0),
                                            child: Text(
                                              getSnapshot[snapshotIndex]
                                                      .source
                                                      .name
                                                      .toString()
                                                      .isNotEmpty
                                                  ? getSnapshot[snapshotIndex]
                                                      .source
                                                      .name
                                                      .toString()
                                                  : "",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              textAlign: TextAlign.justify,
                                              textScaleFactor: 1.3,
                                              style: const TextStyle(
                                                color: Color(0xFF0D0821),
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 12.0,
                                                bottom: 12.0,
                                                right: 20.0),
                                            child: Text(
                                              getSnapshot[snapshotIndex].title,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              textAlign: TextAlign.justify,
                                              textScaleFactor: 1.3,
                                              style: const TextStyle(
                                                color: Color(0xFF0D0821),
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 12.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  getSnapshot[snapshotIndex]
                                                      .publishedAt
                                                      .timeAgo(
                                                          numericDates: true),
                                                  maxLines: 1,
                                                  textAlign: TextAlign.justify,
                                                  textScaleFactor: 1.3,
                                                  style: const TextStyle(
                                                    color: Color(0xFF0D0821),
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      showModalBottomSheet<
                                                          void>(
                                                        context: context,
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                                // <-- SEE HERE
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .vertical(
                                                          top: Radius.circular(
                                                              12.0),
                                                        )),
                                                        builder: (BuildContext
                                                            context) {
                                                          return Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              ListTile(
                                                                onTap: () => _onShare(
                                                                    context,
                                                                    getSnapshot[
                                                                            snapshotIndex]
                                                                        .url),
                                                                leading:
                                                                    Container(
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                12.0),
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .share,
                                                                          size:
                                                                              24.0,
                                                                          color:
                                                                              Colors.black,
                                                                        )),
                                                                title:
                                                                    const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 12.0),
                                                                  child: Text(
                                                                    "Share",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          14.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              ListTile(
                                                                onTap: () => Navigator.pushNamed(
                                                                    context,
                                                                    HeadlinesDetails
                                                                        .headlinesDetails,
                                                                    arguments: NewsArguments(
                                                                        newsArguments:
                                                                            getSnapshot[snapshotIndex].url)),
                                                                leading:
                                                                    Container(
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                12.0),
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .webhook_sharp,
                                                                          size:
                                                                              24.0,
                                                                          color:
                                                                              Colors.black,
                                                                        )),
                                                                title: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              12.0),
                                                                  child: Text(
                                                                    "Go to ${getSnapshot[snapshotIndex].source.name.toString()}",
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          14.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.more_vert,
                                                      color:
                                                          AppColors.blackColor,
                                                      size: 20.0,
                                                    ))
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => Navigator.pushNamed(
                                                context,
                                                HeadlinesDetails
                                                    .headlinesDetails,
                                                arguments: NewsArguments(
                                                    newsArguments: getSnapshot[
                                                            snapshotIndex]
                                                        .url)),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.whiteColor,
                                                border: Border.all(
                                                    color: AppColors.greyColor),
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              child: Center(
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.newspaper,
                                                      color: Color(0xFF0D0821),
                                                      size: 20.0,
                                                    ),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.all(12.0),
                                                      child: Text(
                                                        "Full Coverage of this Story",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount:
                                  snapshot.data?.data?.articles.length ?? 0),
                        );

                      case Status.error:
                        return Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF0D0821)),
                        );
                    }
                  } else {
                    return Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF0D0821)),
                    );
                  }
                },
              )
            ],
          )),
    );
  }
}
