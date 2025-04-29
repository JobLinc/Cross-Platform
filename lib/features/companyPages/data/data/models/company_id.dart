class MyCompanyIds {
  List<String> companyIds = [];

  static final MyCompanyIds instance = MyCompanyIds();

  void addCompanyId(String companyId) {
    if (!companyIds.contains(companyId)) {
      companyIds.add(companyId);
    }
  }

  void setCompanyIds(List<String> ids) {
    companyIds = ids;
  }
}
