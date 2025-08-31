import 'package:flutter/material.dart';
// import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/core/util/input_convertor.dart';
import 'package:provider/provider.dart';
import '../controllers/home_controller.dart';
import '../state/home_state.dart';
import 'package:hostel_mgmt/view/student/widgets/request_card_student.dart';
import 'package:hostel_mgmt/view/student/widgets/skeleton_loader.dart';
import 'package:hostel_mgmt/view/widgets/welcome_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeState>(
      create: (_) {
        final controller = HomeController();
        return controller.state;
      },
      child: Consumer<HomeState>(
        builder: (context, state, _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: state.isLoading
                ? SingleChildScrollView(child: const ShimmerCard())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        WelcomeHeader(
                          name: state.profile?.name ?? '',
                          avatarUrl: state.profile?.profilePic,
                          greeting: 'Welcome back,',
                        ),
                        ...state.requests.map((req) {
                          return RequestCard(
                            reason: req.reason,
                            status: req.status,
                            type: req.requestType,
                            outTime: InputConverter.dateFormater(
                              req.appliedFrom,
                            ),
                            inTime: InputConverter.dateFormater(req.appliedTo),
                            currentStep: 1, // update logic as needed
                          );
                        }).toList(),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
