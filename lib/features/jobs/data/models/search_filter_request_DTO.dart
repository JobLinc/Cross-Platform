class SearchFilter {
  String? search;
  String? location;
  List<String>? experienceFilter;
  List<String>? companyFilter;
  int? minSalary;
  int? maxSalary;

  SearchFilter({
    this.search,
    this.location,
    this.experienceFilter,
    this.companyFilter,
    this.minSalary,
    this.maxSalary,
  });

  Map<String, dynamic> toJson() {
    return {
      'search': search,
      'location': location,
      'experienceFilter': experienceFilter,
      'companyFilter': companyFilter,
      'minSalary': minSalary,
      'maxSalary': maxSalary,
    };
  }

  factory SearchFilter.fromJson(Map<String, dynamic> json) {
    return SearchFilter(
      search: json['search'] as String?,
      location: json['location'] as String?,
      experienceFilter: (json['experienceFilter'] as List<dynamic>?)?.map((e) => e as String).toList(),
      companyFilter: (json['companyFilter'] as List<dynamic>?)?.map((e) => e as String).toList(),
      minSalary: json['minSalary'] as int?,
      maxSalary: json['maxSalary'] as int?,
    );
  }

  /// Converts filter values to query parameters for API
  Map<String, dynamic> toQueryParameters({
    int page = 1,
    int limit = 10,
    List<String>? fields,
    String? sort,
  }) {
    final Map<String, dynamic> params = {};

    if (search != null && search!.trim().isNotEmpty) {
      params['search'] = search!.trim();
      //params['skills'] = search!.trim();
    }

    if (location != null && location!.trim().isNotEmpty) {
      //params['locations.address'] = location!.trim();
      params['search_location'] = location!.trim();
      //params['locations.country'] = location!.trim();
    }


    if (experienceFilter != null && experienceFilter!.isNotEmpty) {
      for (var level in experienceFilter!) {
        params.putIfAbsent('experienceLevel[in]', () => []).add(level);
      }
    }

    if (companyFilter != null && companyFilter!.isNotEmpty) {
      for (var companyId in companyFilter!) {
        params.putIfAbsent('company.id', () => []).add(companyId);
      }
    }

    if (minSalary != null) {
      params['salaryRange.from[gte]'] = minSalary;
    }
    if (maxSalary != null) {
      params['salaryRange.from[lte]'] = maxSalary;
    }

    // if (sort != null) {
    //   params['sort'] = sort;
    // }

    // if (fields != null && fields.isNotEmpty) {
    //   params['fields'] = fields.join(',');
    // }

    // params['page'] = page;
    // params['limit'] = limit;

    return params;
  }
}
