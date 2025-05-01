import 'package:dio/dio.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
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
  Industry industry;
  OrganizationSize organizationSize;
  OrganizationType organizationType;
  int followers = 0;
  bool isVerified = true;

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
    this.location,
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

//Mock Data
List<Company> mockCompanies = [
  Company(
    name: "Microsoft",
    id: "1",
    profileUrl: "joblinc.com/microsoft",
    industry: Industry.softwareDevelopment,
    organizationSize: OrganizationSize.tenThousandPlus,
    organizationType: OrganizationType.privatelyHeld,
    logoUrl:
        "https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Microsoft_logo.svg/1024px-Microsoft_logo.svg.png?20210729021049",
    coverUrl:
        "https://media.licdn.com/dms/image/v2/D5616AQFA1b3IWtImEw/profile-displaybackgroundimage-shrink_350_1400/profile-displaybackgroundimage-shrink_350_1400/0/1698372804036?e=1747267200&v=beta&t=Lo5P4SBuzIk2Ik6NHtfyqkSd7ggVGgMkbNNfosiltW8",
    followers: 25000000,
    website: "https://www.microsoft.com",
    tagline:
        "Empowering every person and every organization on the planet to achieve more.",
    location: "Redmond, Washington",
  ),
  Company(
    name: "Google",
    id: "2",
    profileUrl: "joblinc.com/google",
    industry: Industry.technology,
    organizationSize: OrganizationSize.tenThousandPlus,
    organizationType: OrganizationType.publicCompany,
    logoUrl:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8TnrQxTZSfvVAv5WMvi3cNJZdO09N-NfkXQ&s",
    coverUrl:
        "https://media.licdn.com/dms/image/v2/C561BAQFhLiarxRw1QQ/company-background_10000/company-background_10000/0/1584579327009/google_partners_cover?e=2147483647&v=beta&t=9RplEJ-8oaumWceZpNRcdwrIHafiK-CRWzl1DcZHUsk",
    followers: 20000000,
    website: "https://google.com",
    tagline:
        "To organize the world's information and make it universally accessible and useful.",
    location: "Mountain View, California",
  ),
  Company(
    name: "Apple",
    profileUrl: "joblinc.com/apple",
    industry: Industry.technology,
    organizationSize: OrganizationSize.tenThousandPlus,
    organizationType: OrganizationType.publicCompany,
    logoUrl:
        "https://media.licdn.com/dms/image/v2/C560BAQHdAaarsO-eyA/company-logo_200_200/company-logo_200_200/0/1630637844948/apple_logo?e=1750291200&v=beta&t=PO9gPFA9fMQKkkNcKW7C6hgUmppuQ9hbZilIs_G5dw4",
    coverUrl:
        "https://media.licdn.com/dms/image/v2/C4E1BAQFcckDwSlhOVg/company-background_10000/company-background_10000/0/1584537393991/apple_cover?e=1742601600&v=beta&t=AHjR9xgDH9nT5_eZS6d4Yumw0xgh8g8N0IddCEwL_Q0",
    followers: 22000000,
    website: "https://www.apple.com",
    tagline: "Think different.",
    location: "Cupertino, California",
  ),
  Company(
    name: "Amazon",
    id: "3",
    profileUrl: "joblinc.com/amazon",
    industry: Industry.technology,
    organizationSize: OrganizationSize.tenThousandPlus,
    organizationType: OrganizationType.publicCompany,
    logoUrl:
        "https://media.licdn.com/dms/image/v2/C560BAQHTvZwCx4p2Qg/company-logo_200_200/company-logo_200_200/0/1630640869849/amazon_logo?e=1750291200&v=beta&t=S-WbLXjQY6sb_Lt8aaKbfeq086zp14cAL9mshdO1Q1w",
    coverUrl:
        "https://media.licdn.com/dms/image/v2/D4D3DAQGri_YWxYb-GQ/image-scale_191_1128/image-scale_191_1128/0/1681945878609/amazon_cover?e=1742612400&v=beta&t=sKeSxA8U8R09elO4d_IQLNKjZaM9a_6p-b2CfnIkIaw",
    followers: 18000000,
    website: "https://www.amazon.com",
    tagline: "Work hard. Have fun. Make history.",
    location: "Seattle, Washington",
  ),
  Company(
    name: "Tesla",
    id: "4",
    profileUrl: "joblinc.com/tesla",
    industry: Industry.technology,
    organizationSize: OrganizationSize.tenThousandPlus,
    organizationType: OrganizationType.publicCompany,
    logoUrl:
        "https://www.researchgate.net/profile/Locky-Law-2/publication/349493132/figure/fig4/AS:11431281085420770@1663768886900/The-logo-of-Tesla-Inc.png",
    coverUrl:
        "https://media.licdn.com/dms/image/v2/C561BAQFqQXNCkzg_Uw/company-background_10000/company-background_10000/0/1635791699664/tesla_motors_cover?e=1742601600&v=beta&t=WfDUV1fWC_zayas8PZA0Rqc1hrT3bkLxw99sJnWM7LE",
    followers: 12000000,
    website: "https://www.tesla.com",
    tagline: "Accelerating the world's transition to sustainable energy.",
    location: "Palo Alto, California",
  ),
  Company(
    name: "Netflix",
    id: "5",
    profileUrl: "joblinc.com/netflix",
    industry: Industry.technology,
    organizationSize: OrganizationSize.tenThousandPlus,
    organizationType: OrganizationType.publicCompany,
    logoUrl:
        "https://static.vecteezy.com/system/resources/previews/020/335/987/non_2x/netflix-logo-netflix-icon-free-free-vector.jpg",
    coverUrl:
        "https://media.licdn.com/dms/image/v2/D4E3DAQEKmQHFFvC4Fw/image-scale_191_1128/image-scale_191_1128/0/1736891212728/netflix_cover?e=2147483647&v=beta&t=SsN1pLcKzV7i5hmwPbqUeiUs0C37A8UkNk1ilhIl9YA",
    followers: 10000000,
    website: "https://www.netflix.com",
    tagline: "See what's next.",
    location: "Los Gatos, California",
  ),
  Company(
    name: "Uber",
    id: "6",
    profileUrl: "joblinc.com/uber",
    industry: Industry.technology,
    organizationSize: OrganizationSize.tenThousandPlus,
    organizationType: OrganizationType.publicCompany,
    logoUrl:
        "https://media.licdn.com/dms/image/v2/C4D0BAQFiYnR1Mbtxdg/company-logo_200_200/company-logo_200_200/0/1630552741617/uber_com_logo?e=1750291200&v=beta&t=cDlilvW7YkUwonv8rbGMGWbjZdq6d50OHaIELA3OZvM",
    coverUrl:
        "https://media.licdn.com/dms/image/v2/D4E3DAQEZVS54MgjRNQ/image-scale_191_1128/image-scale_191_1128/0/1721908502230/uber_com_cover?e=1742601600&v=beta&t=GZP60hBHwMZyYbp24DzNjaprFRFR-rZV1vjqUK6FODo",
    followers: 8000000,
    website: "https://www.uber.com",
    tagline: "We ignite opportunity by setting the world in motion.",
    location: "San Francisco, California",
  ),
];
