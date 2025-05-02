import 'package:dio/dio.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/features/companypages/data/data/models/location_model.dart';
import 'package:joblinc/features/companypages/data/data/repos/getmycompany_repo.dart';
import 'package:joblinc/features/companypages/data/data/services/getmycompany.dart';

enum Industry {
  itServices,
  hospitals,
  education,
  government,
  advertising,
  accounting,
  oilAndGas,
  wellness,
  foodAndBeverageServices,
  technology,
  appliances,
  businessConsulting,
  primaryEducation,
  transportation,
  retail,
  foodAndBeverageManufacturing,
  staffing,
  architecture,
  travel,
  armedForces,
  softwareDevelopment
}

enum OrganizationSize {
  zeroToOne,
  twoToTen,
  elevenToFifty,
  fiftyOneToTwoHundred,
  twoHundredOneToFiveHundred,
  fiveHundredOneToOneThousand,
  oneThousandOneToFiveThousand,
  fiveThousandOneToTenThousand,
  tenThousandPlus,
}

enum OrganizationType {
  publicCompany,
  governmentAgency,
  nonprofit,
  selfEmployed,
  soleProprietorship,
  partnership,
  privatelyHeld,
}

extension IndustryExtension on Industry {
  String get displayName {
    switch (this) {
      case Industry.itServices:
        return "IT Services and IT Consulting";
      case Industry.hospitals:
        return "Hospitals and Healthcare";
      case Industry.education:
        return "Education Administration Programs";
      case Industry.government:
        return "Government Administration";
      case Industry.advertising:
        return "Advertising Services";
      case Industry.accounting:
        return "Accounting";
      case Industry.oilAndGas:
        return "Oil and Gas";
      case Industry.wellness:
        return "Wellness and Fitness Services";
      case Industry.foodAndBeverageServices:
        return "Food and Beverage Services";
      case Industry.technology:
        return "Technology, Information and Internet";
      case Industry.appliances:
        return "Appliances, Electrical and Electronics Manufacturing";
      case Industry.businessConsulting:
        return "Business Consulting and Services";
      case Industry.primaryEducation:
        return "Primary and Secondary Education";
      case Industry.transportation:
        return "Transportation, Logistics, Supply Chain and Storage";
      case Industry.retail:
        return "Retail Apparel and Fashion";
      case Industry.foodAndBeverageManufacturing:
        return "Food and Beverage Manufacturing";
      case Industry.staffing:
        return "Staffing and Recruiting";
      case Industry.architecture:
        return "Architecture and Planning";
      case Industry.travel:
        return "Travel Arrangements";
      case Industry.armedForces:
        return "Armed Forces";
      case Industry.softwareDevelopment:
        return "Software Development";
    }
  }

  static Industry? fromDisplayName(String displayName) {
    for (final value in Industry.values) {
      if (value.displayName == displayName) {
        return value;
      }
    }
    return null;
  }
}

extension OrganizationSizeExtension on OrganizationSize {
  String get displayName {
    switch (this) {
      case OrganizationSize.zeroToOne:
        return "0-1 employees";
      case OrganizationSize.twoToTen:
        return "2-10 employees";
      case OrganizationSize.elevenToFifty:
        return "11-50 employees";
      case OrganizationSize.fiftyOneToTwoHundred:
        return "51-200 employees";
      case OrganizationSize.twoHundredOneToFiveHundred:
        return "201-500 employees";
      case OrganizationSize.fiveHundredOneToOneThousand:
        return "501-1000 employees";
      case OrganizationSize.oneThousandOneToFiveThousand:
        return "1001-5000 employees";
      case OrganizationSize.fiveThousandOneToTenThousand:
        return "5001-10000 employees";
      case OrganizationSize.tenThousandPlus:
        return "10000+ employees";
    }
  }

  static OrganizationSize? fromDisplayName(String displayName) {
    for (final value in OrganizationSize.values) {
      if (value.displayName == displayName) {
        return value;
      }
    }
    return null;
  }
}

extension OrganizationTypeExtension on OrganizationType {
  String get displayName {
    switch (this) {
      case OrganizationType.publicCompany:
        return "Public Company";
      case OrganizationType.governmentAgency:
        return "Government Agency";
      case OrganizationType.nonprofit:
        return "Nonprofit";
      case OrganizationType.selfEmployed:
        return "Self-Employed";
      case OrganizationType.soleProprietorship:
        return "Sole Proprietorship";
      case OrganizationType.partnership:
        return "Partnership";
      case OrganizationType.privatelyHeld:
        return "Privately Held";
    }
  }

  static OrganizationType? fromDisplayName(String displayName) {
    for (final value in OrganizationType.values) {
      if (value.displayName == displayName) {
        return value;
      }
    }
    return null;
  }
}

class Company {
  String name;
  String? id;
  String profileUrl;
  String? overview;
  String? website;
  String? tagline;
  String? logoUrl;
  String? coverUrl;
  String? location;
  String? country;
  String? city;
  String industry;
  String organizationSize;
  String organizationType;
  int followers = 0;
  bool isVerified = true;
  List <CompanyLocationModel>? locations;

  Company({
    required this.name,
    this.id,
    required this.profileUrl,
    this.website,
    this.tagline,
    this.overview,
    this.country,
    this.city,
    required this.industry,
    required this.organizationSize,
    required this.organizationType,
    this.logoUrl,
    this.coverUrl,
    this.followers = 0,
    this.locations,
  });

  Future<bool> isAdmin() async {
    final companies = await CompanyRepositoryImpl(
      CompanyApiService(getIt<Dio>()),
    ).getAllCompanies();

    for (var company in companies) {
      if (company.id == id) {
        return true;
      }
    }
    return false;
  }
}