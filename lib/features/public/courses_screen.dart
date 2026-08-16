import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../models/course_model.dart';
import '../../services/course_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/course_card.dart';
import '../../widgets/public_footer.dart';
import '../../widgets/public_header.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courseService = Provider.of<CourseService>(context);
    final authService = Provider.of<AuthService>(context);
    final courses = courseService.filteredCourses;
    final isDesktop = MediaQuery.of(context).size.width > 800;

    final enrolledIds = authService.currentUser?.enrolledCourseIds ?? [];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const PublicHeader(activeRoute: AppConstants.routeCourses),

            // Page Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 24,
                vertical: 40,
              ),
              color: const Color(0xFF0F172A),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Academic Course Catalog',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Browse curriculum, course syllabi, teacher credentials, and schedules.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search & Filter Toolbar
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 20,
                vertical: 24,
              ),
              color: Colors.white,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  children: [
                    // Search Input
                    TextField(
                      onChanged: (val) => courseService.setSearchQuery(val),
                      decoration: InputDecoration(
                        hintText:
                            'Search by course title, code (e.g. CS301), topic, or professor...',
                        prefixIcon: const Icon(Icons.search,
                            color: AppColors.textSecondary),
                        suffixIcon: courseService.searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () =>
                                    courseService.setSearchQuery(''),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Categories Horizontal List
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: AppConstants.courseCategories.map((cat) {
                          final isSelected =
                              courseService.selectedCategory == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(cat),
                              selected: isSelected,
                              onSelected: (_) => courseService.setCategory(cat),
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 13,
                              ),
                              backgroundColor: const Color(0xFFF1F5F9),
                              side: BorderSide.none,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Courses Grid
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 20,
                vertical: 32,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Showing ${courses.length} Courses',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (courses.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(48),
                        alignment: Alignment.center,
                        child: Column(
                          children: const [
                            Icon(Icons.search_off,
                                size: 48, color: AppColors.textMuted),
                            SizedBox(height: 12),
                            Text(
                              'No courses found matching your search.',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      GridView.builder(
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isDesktop ? 3 : 1,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 280,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          final course = courses[index];
                          final isEnrolled =
                              enrolledIds.contains(course.id);

                          return CourseCard(
                            course: course,
                            isEnrolled: isEnrolled,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppConstants.routeCourseDetail,
                                arguments: course,
                              );
                            },
                            onEnroll: isEnrolled
                                ? null
                                : () {
                                    courseService.enrollStudent(course.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Successfully enrolled in ${course.title}!'),
                                        backgroundColor: AppColors.success,
                                      ),
                                    );
                                  },
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),

            const PublicFooter(),
          ],
        ),
      ),
    );
  }
}
