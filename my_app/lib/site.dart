/*
*Ella Muro
*25 May 2026
*Class to Represent Sits
*/

class Site {

  //**Fields of the class**\\
  int siteId;
  String siteName;
  int maxDocsOffPerWeek;

  //**Constructor Section**\\

  //Full constructor
  Site.full({required this.siteId, required this.siteName, required this.maxDocsOffPerWeek});

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site.full(
      siteId: json["siteId"],
      siteName: json["siteName"],
      maxDocsOffPerWeek: json["maxDocsOffPerWeek"]
    );
  }
}