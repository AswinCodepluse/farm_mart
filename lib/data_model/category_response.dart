// To parse this JSON data, do
//
//     final categoryResponse = categoryResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

CategoryResponse categoryResponseFromJson(String str) =>
    CategoryResponse.fromJson(json.decode(str));

String categoryResponseToJson(CategoryResponse data) =>
    json.encode(data.toJson());

class CategoryResponse {
  CategoryResponse({
    this.categories,
    this.success,
    this.status,
  });

  List<Category>? categories;
  bool? success;
  int? status;

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      CategoryResponse(
        categories:
            List<Category>.from(json["data"].map((x) => Category.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(categories!.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };
}

class Category {
  Category({
    this.id,
    this.name,
    this.slug,
    this.banner,
    this.icon,
    this.number_of_children,
    this.links,
    this.digital,
  });

  int? id;
  String? name;
  String? slug;
  String? banner;
  String? icon;
  int? number_of_children;
  Links? links;
  int? digital;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
      id: json["id"],
      name: json["name"],
      slug: json["slug"],
      banner: json["banner"],
      icon: json["icon"],
      number_of_children: json["number_of_children"],
      links: Links.fromJson(json["links"]),
      digital: json["digital"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "banner": banner,
        "icon": icon,
        "number_of_children": number_of_children,
        "links": links!.toJson(),
        "digital": digital,
      };
}

class Links {
  Links({
    this.products,
    this.subCategories,
  });

  String? products;
  String? subCategories;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        products: json["products"],
        subCategories: json["sub_categories"],
      );

  Map<String, dynamic> toJson() => {
        "products": products,
        "sub_categories": subCategories,
      };
}
