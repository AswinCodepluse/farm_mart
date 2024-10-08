import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/btn.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/text_styles.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/data_model/category_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/presenter/bottom_appbar_index.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:active_ecommerce_flutter/screens/category_list_n_product/category_products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryList extends StatefulWidget {
  CategoryList(
      {Key? key,
      //this.parent_category_id = 0,
      required this.slug,
      this.is_base_category = false,
      this.is_top_category = false,
      this.digital = 1,
      this.bottomAppbarIndex})
      : super(key: key);

  //final int parent_category_id;
  final String slug;
  final bool is_base_category;
  final bool is_top_category;
  final BottomAppbarIndex? bottomAppbarIndex;
  final int digital;

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Stack(children: [
        // Container(
        //   height: DeviceInfo(context).height! / 4,
        //   width: DeviceInfo(context).width,
        //   color: MyTheme.accent_color,
        //   alignment: Alignment.topRight,
        //   child: Image.asset(
        //     "assets/background_1.png",
        //   ),
        // ),
        Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              leading: Builder(
                  builder: (context) => widget.digital == 0
                      ? IconButton(
                          icon: Icon(CupertinoIcons.arrow_left,
                              color: MyTheme.dark_grey),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      : SizedBox()),

              // leading: Builder(
              //   builder: (context) => widget.from_navigation
              //       ? UsefulElements.backToMain(context, go_back: false)
              //       : UsefulElements.backButton(context),
              // ),
              title: Text(
                "Categories",
                style: TextStyles.buildAppBarTexStyle(),
              ),
              centerTitle: true,
              elevation: 0.0,
              titleSpacing: 0,
            ),

            // PreferredSize(
            //     child: buildAppBar(context),
            //     preferredSize: Size(
            //       DeviceInfo(context).width!,
            //       50,
            //     )),
            body: buildBody()),
        Align(
          alignment: Alignment.bottomCenter,
          child: widget.is_base_category || widget.is_top_category
              ? Container(
                  height: 0,
                )
              : buildBottomContainer(),
        )
      ]),
    );
  }

  Widget buildBody() {
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
          buildCategoryList(digital: widget.digital),
          Container(
            height: widget.is_base_category ? 60 : 90,
          )
        ]))
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      leading: widget.is_base_category
          ? Builder(
              builder: (context) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                child: UsefulElements.backToMain(context,
                    go_back: false, color: "black"),
              ),
            )
          : Builder(
              builder: (context) => IconButton(
                icon:
                    Icon(CupertinoIcons.arrow_left, color: MyTheme.blackColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
      title: Text(
        getAppBarTitle(),
        style: TextStyle(
            fontSize: 16,
            color: MyTheme.blackColor,
            fontWeight: FontWeight.bold),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  String getAppBarTitle() {
    String name = widget.is_top_category
        ? AppLocalizations.of(context)!.top_categories_ucf
        : AppLocalizations.of(context)!.categories_ucf;

    return name;
  }

  buildCategoryList({required int digital}) {
    var data = widget.is_top_category
        ? CategoryRepository().getTopCategories()
        : CategoryRepository().getCategories(parent_id: widget.slug);
    return FutureBuilder(
      future: data,
      builder: (context, AsyncSnapshot<CategoryResponse> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SingleChildScrollView(child: buildShimmer());
        }
        if (snapshot.hasError) {
          return Container(
            height: 10,
          );
        } else if (snapshot.hasData) {
          List<Category> foodCategoryList = [];
          List<Category> animalCategoryList = [];
          snapshot.data!.categories?.forEach((element) {
            if (element.digital == 0) {
              foodCategoryList.add(element);
            } else {
              animalCategoryList.add(element);
            }
          });
          if (digital == 0 && foodCategoryList.isEmpty) {
            return Center(
              child: Text("Food Not Available"),
            );
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              // childAspectRatio: 0.7,
              crossAxisCount: 2,
            ),
            // itemCount: snapshot.data!.categories!.length,
            itemCount: digital == 1
                ? animalCategoryList.length
                : foodCategoryList.length,
            padding: EdgeInsets.only(
                left: 18, right: 18, bottom: widget.is_base_category ? 30 : 0),
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final data = digital == 0
                  ? foodCategoryList[index]
                  : animalCategoryList[index];
              return buildCategoryItemCard(data);
            },
          );
        } else {
          return SingleChildScrollView(child: buildShimmer());
        }
      },
    );
  }

  Widget buildCategoryItemCard(categoryResponse) {
    var itemWidth = ((DeviceInfo(context).width! - 36) / 3);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CategoryProducts(
                slug: categoryResponse.slug ?? "",
              );
            },
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).width / 1.97,
            // constraints: BoxConstraints(maxHeight: itemWidth - 28),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(6), topLeft: Radius.circular(6)),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/placeholder.png',
                image: categoryResponse.banner,
                fit: BoxFit.cover,
                height: itemWidth,
                width: DeviceInfo(context).width,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              categoryResponse.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                  color: MyTheme.white,
                  fontSize: 12,
                  height: 1.6,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Container buildBottomContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      height: widget.is_base_category ? 0 : 80,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                width: (MediaQuery.of(context).size.width - 32),
                height: 40,
                child: Btn.basic(
                  minWidth: MediaQuery.of(context).size.width,
                  color: MyTheme.accent_color,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0))),
                  child: Text(
                    AppLocalizations.of(context)!.all_products_of_ucf + " ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CategoryProducts(
                            slug: widget.slug,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildShimmer() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1,
        crossAxisCount: 3,
      ),
      itemCount: 18,
      padding: EdgeInsets.only(
          left: 18, right: 18, bottom: widget.is_base_category ? 30 : 0),
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecorations.buildBoxDecoration_1(),
          child: ShimmerHelper().buildBasicShimmer(),
        );
      },
    );
  }
}
