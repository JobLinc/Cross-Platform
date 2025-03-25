import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/companyPages/data/data/company.dart';
import 'package:joblinc/features/companyPages/logic/cubit/create_company_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateCompanyCubit extends Mock implements CreateCompanyCubit {}
class FakeTextEditingController extends Fake implements TextEditingController {}

void setupCreateCompanyMocks() {
  registerFallbackValue(FakeTextEditingController());
  registerFallbackValue(Industry.technology);
  registerFallbackValue(OrganizationSize.zeroToOne);
  registerFallbackValue(OrganizationType.privatelyHeld);
  
  TestWidgetsFlutterBinding.ensureInitialized();
}

// Updated to explicitly return MockCreateCompanyCubit
MockCreateCompanyCubit createMockCubit() {
  final cubit = MockCreateCompanyCubit();
  when(() => cubit.state).thenReturn(CreateCompanyInitial());
  when(() => cubit.createCompany(
    nameController: any(named: 'nameController'),
    jobLincUrlController: any(named: 'jobLincUrlController'),
    selectedIndustry: any(named: 'selectedIndustry'),
    orgSize: any(named: 'orgSize'),
    orgType: any(named: 'orgType'),
    websiteController: any(named: 'websiteController'),
  )).thenAnswer((_) async {});
  
  return cubit;
}

Future<void> selectDropdownItem(
  WidgetTester tester, 
  Finder dropdownFinder, 
  String value
) async {
  await tester.tap(dropdownFinder);
  await tester.pumpAndSettle();
  await tester.tap(find.text(value).last);
  await tester.pumpAndSettle();
}