import '../models/user_model.dart';
import '../models/course_model.dart';
import '../models/attendance_model.dart';
import '../models/assignment_model.dart';
import '../models/exam_model.dart';
import '../models/ai_insight_model.dart';
import '../models/announcement_model.dart';
import 'constants.dart';

class MockData {
  // Demo Users
  static final UserModel demoStudent1 = UserModel(
    id: 'std_001',
    email: 'student@edupulse.ai',
    name: 'Alex Johnson',
    role: UserRole.student,
    department: 'Computer Science & Engineering',
    studentIdNumber: 'CS-2026-042',
    avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
    enrolledCourseIds: ['crs_001', 'crs_002', 'crs_003', 'crs_004'],
  );

  static final UserModel demoStudentAtRisk = UserModel(
    id: 'std_002',
    email: 'david.risk@edupulse.ai',
    name: 'David Smith',
    role: UserRole.student,
    department: 'Computer Science & Engineering',
    studentIdNumber: 'CS-2026-088',
    avatarUrl: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150',
    enrolledCourseIds: ['crs_001', 'crs_002', 'crs_004'],
  );

  static final UserModel demoStudentTop = UserModel(
    id: 'std_003',
    email: 'sarah.top@edupulse.ai',
    name: 'Sarah Connor',
    role: UserRole.student,
    department: 'Artificial Intelligence & Data Science',
    studentIdNumber: 'AI-2026-015',
    avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
    enrolledCourseIds: ['crs_001', 'crs_002', 'crs_003', 'crs_005'],
  );

  static final UserModel demoTeacher1 = UserModel(
    id: 'tch_001',
    email: 'teacher@edupulse.ai',
    name: 'Dr. Alan Turing',
    role: UserRole.teacher,
    department: 'Computer Science',
    teacherTitle: 'Professor & Head of Computing',
    avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
    teachingCourseIds: ['crs_001', 'crs_003'],
  );

  static final UserModel demoTeacher2 = UserModel(
    id: 'tch_002',
    email: 'ada.lovelace@edupulse.ai',
    name: 'Dr. Ada Lovelace',
    role: UserRole.teacher,
    department: 'Artificial Intelligence',
    teacherTitle: 'Lead AI Researcher & Faculty',
    avatarUrl: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=150',
    teachingCourseIds: ['crs_002', 'crs_005'],
  );

  static final UserModel demoAdmin = UserModel(
    id: 'adm_001',
    email: 'admin@edupulse.ai',
    name: 'Dean Eleanor Vance',
    role: UserRole.admin,
    department: 'Academic Administration & Registrar',
    avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
  );

  // Course Catalog
  static final List<CourseModel> initialCourses = [
    CourseModel(
      id: 'crs_001',
      code: 'CS301',
      title: 'Data Structures & Algorithms',
      description:
          'Deep dive into abstract data types, trees, graphs, dynamic programming, and asymptotic complexity analysis.',
      category: 'Computer Science',
      teacherId: 'tch_001',
      teacherName: 'Dr. Alan Turing',
      teacherTitle: 'Professor of Computing',
      credits: 4,
      schedule: 'Mon, Wed, Fri (09:00 AM - 10:30 AM)',
      room: 'Turing Hall 101',
      rating: 4.9,
      enrolledStudentCount: 48,
      isFeatured: true,
      learningOutcomes: [
        'Master balanced search trees and graph algorithms',
        'Analyze worst-case and amortized time complexity',
        'Implement dynamic programming solutions to NP-hard approximations',
      ],
      syllabus: [
        CourseSyllabusItem(
          weekNumber: 1,
          title: 'Algorithmic Complexity & Big-O Notation',
          description: 'Time and space complexity bounds, recursion trees.',
          topics: ['Asymptotic Analysis', 'Master Theorem', 'Recurrences'],
        ),
        CourseSyllabusItem(
          weekNumber: 2,
          title: 'Advanced Trees & Balanced Search',
          description: 'Self-balancing binary search trees and heap structures.',
          topics: ['AVL Trees', 'Red-Black Trees', 'Fibonacci Heaps'],
        ),
        CourseSyllabusItem(
          weekNumber: 3,
          title: 'Graph Traversals & Shortest Paths',
          description: 'BFS, DFS, Dijkstra, Bellman-Ford, and Flow networks.',
          topics: ['Dijkstra', 'Floyd-Warshall', 'Max Flow Min Cut'],
        ),
        CourseSyllabusItem(
          weekNumber: 4,
          title: 'Dynamic Programming & Memoization',
          description: 'Optimal substructure and overlapping subproblems.',
          topics: ['Knapsack Problem', 'Matrix Chain Multiplication', 'LCS'],
        ),
      ],
    ),
    CourseModel(
      id: 'crs_002',
      code: 'AI402',
      title: 'Machine Learning & Neural Networks',
      description:
          'Comprehensive exploration of supervised learning, gradient descent, backpropagation, and transformer architectures.',
      category: 'Artificial Intelligence',
      teacherId: 'tch_002',
      teacherName: 'Dr. Ada Lovelace',
      teacherTitle: 'Lead AI Researcher',
      credits: 4,
      schedule: 'Tue, Thu (11:00 AM - 12:45 PM)',
      room: 'Lovelace Lab 204',
      rating: 4.95,
      enrolledStudentCount: 52,
      isFeatured: true,
      learningOutcomes: [
        'Build and train deep neural networks from first principles',
        'Understand loss functions, regularization, and optimization algorithms',
        'Evaluate models with precision, recall, ROC-AUC, and cross-validation',
      ],
      syllabus: [
        CourseSyllabusItem(
          weekNumber: 1,
          title: 'Statistical Learning Foundations',
          description: 'Linear models, logistic regression, and MLE.',
          topics: ['Linear Regression', 'Logistic Classification', 'Cost Functions'],
        ),
        CourseSyllabusItem(
          weekNumber: 2,
          title: 'Multi-Layer Perceptrons & Backprop',
          description: 'Activation functions, tensor operations, chain rule.',
          topics: ['Backpropagation', 'Adam Optimizer', 'Dropout Regularization'],
        ),
        CourseSyllabusItem(
          weekNumber: 3,
          title: 'Convolutional & Recurrent Networks',
          description: 'Computer vision kernels and sequential text modelling.',
          topics: ['CNN Architectures', 'LSTM & GRU', 'Attention Mechanisms'],
        ),
      ],
    ),
    CourseModel(
      id: 'crs_003',
      code: 'SE205',
      title: 'Cloud Software Engineering',
      description:
          'Modern full-stack system architecture, microservices, containerization, and automated CI/CD deployment pipelines.',
      category: 'Software Engineering',
      teacherId: 'tch_001',
      teacherName: 'Dr. Alan Turing',
      teacherTitle: 'Professor of Computing',
      credits: 3,
      schedule: 'Wed, Fri (02:00 PM - 03:30 PM)',
      room: 'Cloud Computing Lab B',
      rating: 4.75,
      enrolledStudentCount: 36,
      isFeatured: true,
      learningOutcomes: [
        'Design microservice architectures with Docker & Kubernetes',
        'Implement robust RESTful and GraphQL APIs',
        'Automate testing, linting, and continuous delivery',
      ],
      syllabus: [
        CourseSyllabusItem(
          weekNumber: 1,
          title: 'System Design & REST Principles',
          description: 'Stateless architectures and caching.',
          topics: ['REST APIs', 'Rate Limiting', 'Idempotency'],
        ),
        CourseSyllabusItem(
          weekNumber: 2,
          title: 'Docker & Container Orchestration',
          description: 'Building lean images and multi-container environments.',
          topics: ['Dockerfiles', 'Docker Compose', 'Kubernetes Pods'],
        ),
      ],
    ),
    CourseModel(
      id: 'crs_004',
      code: 'DS104',
      title: 'Applied Probability & Linear Algebra',
      description:
          'Matrix decompositions, eigenvalues, Bayes theorem, and continuous distributions for data engineering.',
      category: 'Mathematics',
      teacherId: 'tch_002',
      teacherName: 'Dr. Ada Lovelace',
      teacherTitle: 'Lead AI Researcher',
      credits: 3,
      schedule: 'Mon, Thu (03:30 PM - 05:00 PM)',
      room: 'Euler Hall 401',
      rating: 4.65,
      enrolledStudentCount: 60,
      isFeatured: false,
      learningOutcomes: [
        'Perform SVD and Eigendecomposition on high-dimensional data',
        'Formulate Bayesian inference models for uncertainty quantification',
      ],
      syllabus: [
        CourseSyllabusItem(
          weekNumber: 1,
          title: 'Vector Spaces & Matrix Transformations',
          description: 'Basis, rank, null space, and projections.',
          topics: ['Vector Spaces', 'Dot Products', 'Matrix Inverses'],
        ),
        CourseSyllabusItem(
          weekNumber: 2,
          title: 'Eigenvalues, Eigenvectors & SVD',
          description: 'Principal component analysis math.',
          topics: ['Characteristic Polynomials', 'SVD', 'PCA Theory'],
        ),
      ],
    ),
  ];

  // Announcements
  static final List<AnnouncementModel> announcements = [
    AnnouncementModel(
      id: 'anc_001',
      title: 'Midterm Examination Schedule Released',
      content:
          'Midterm examinations for Semester 1 will commence next Monday. Please review the updated hall allocations and timetable on your student dashboard.',
      category: 'Exam',
      date: DateTime.now().subtract(const Duration(days: 1)),
      author: 'Office of Academic Affairs',
      isUrgent: true,
    ),
    AnnouncementModel(
      id: 'anc_002',
      title: 'AI Academic Intelligence Portal 2.0 Live',
      content:
          'Students and teachers can now track predictive performance metrics, weak topic diagnoses, and automated study recommendations directly.',
      category: 'Academic',
      date: DateTime.now().subtract(const Duration(days: 3)),
      author: 'Academic Computing Center',
    ),
    AnnouncementModel(
      id: 'anc_003',
      title: 'Annual Research Symposium & Hackathon Registrations Open',
      content:
          'Submit your AI and Cloud computing project proposals by Friday 5:00 PM for the inter-collegiate showcase.',
      category: 'Event',
      date: DateTime.now().subtract(const Duration(days: 5)),
      author: 'Department of Computer Science',
    ),
  ];

  // Attendance Records for Alex Johnson (Good Attendance ~ 92%)
  static List<AttendanceRecord> getStudent1Attendance() {
    final now = DateTime.now();
    return [
      AttendanceRecord(
        id: 'att_001',
        studentId: 'std_001',
        studentName: 'Alex Johnson',
        courseId: 'crs_001',
        courseCode: 'CS301',
        courseTitle: 'Data Structures & Algorithms',
        date: now.subtract(const Duration(days: 1)),
        status: AttendanceStatus.present,
      ),
      AttendanceRecord(
        id: 'att_002',
        studentId: 'std_001',
        studentName: 'Alex Johnson',
        courseId: 'crs_001',
        courseCode: 'CS301',
        courseTitle: 'Data Structures & Algorithms',
        date: now.subtract(const Duration(days: 3)),
        status: AttendanceStatus.present,
      ),
      AttendanceRecord(
        id: 'att_003',
        studentId: 'std_001',
        studentName: 'Alex Johnson',
        courseId: 'crs_002',
        courseCode: 'AI402',
        courseTitle: 'Machine Learning & Neural Networks',
        date: now.subtract(const Duration(days: 2)),
        status: AttendanceStatus.present,
      ),
      AttendanceRecord(
        id: 'att_004',
        studentId: 'std_001',
        studentName: 'Alex Johnson',
        courseId: 'crs_003',
        courseCode: 'SE205',
        courseTitle: 'Cloud Software Engineering',
        date: now.subtract(const Duration(days: 2)),
        status: AttendanceStatus.present,
      ),
      AttendanceRecord(
        id: 'att_005',
        studentId: 'std_001',
        studentName: 'Alex Johnson',
        courseId: 'crs_004',
        courseCode: 'DS104',
        courseTitle: 'Applied Probability & Linear Algebra',
        date: now.subtract(const Duration(days: 4)),
        status: AttendanceStatus.late,
        remarks: '10 mins late due to transport delay',
      ),
    ];
  }

  // Attendance Records for David Smith (At-Risk Attendance ~ 64% < 75%)
  static List<AttendanceRecord> getStudentAtRiskAttendance() {
    final now = DateTime.now();
    return [
      AttendanceRecord(
        id: 'att_r_001',
        studentId: 'std_002',
        studentName: 'David Smith',
        courseId: 'crs_001',
        courseCode: 'CS301',
        courseTitle: 'Data Structures & Algorithms',
        date: now.subtract(const Duration(days: 1)),
        status: AttendanceStatus.absent,
        remarks: 'Unexcused absence',
      ),
      AttendanceRecord(
        id: 'att_r_002',
        studentId: 'std_002',
        studentName: 'David Smith',
        courseId: 'crs_001',
        courseCode: 'CS301',
        courseTitle: 'Data Structures & Algorithms',
        date: now.subtract(const Duration(days: 3)),
        status: AttendanceStatus.absent,
      ),
      AttendanceRecord(
        id: 'att_r_003',
        studentId: 'std_002',
        studentName: 'David Smith',
        courseId: 'crs_002',
        courseCode: 'AI402',
        courseTitle: 'Machine Learning & Neural Networks',
        date: now.subtract(const Duration(days: 2)),
        status: AttendanceStatus.present,
      ),
      AttendanceRecord(
        id: 'att_r_004',
        studentId: 'std_002',
        studentName: 'David Smith',
        courseId: 'crs_004',
        courseCode: 'DS104',
        courseTitle: 'Applied Probability & Linear Algebra',
        date: now.subtract(const Duration(days: 4)),
        status: AttendanceStatus.absent,
      ),
    ];
  }

  // Assignments
  static final List<AssignmentModel> initialAssignments = [
    AssignmentModel(
      id: 'asg_001',
      courseId: 'crs_001',
      courseTitle: 'Data Structures & Algorithms',
      teacherId: 'tch_001',
      title: 'Lab 4: Red-Black Tree Balancing & Rotations',
      description:
          'Implement left and right tree rotations, node insertion, and color-flip balancing logic in Dart/C++ with full unit test coverage.',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      maxScore: 100,
      subject: 'Data Structures',
      rubricCriteria: [
        'Correctness of tree rotation logic (40%)',
        'Color property preservation & invariants (30%)',
        'Time complexity O(log N) verification (20%)',
        'Code style & documentation (10%)',
      ],
    ),
    AssignmentModel(
      id: 'asg_002',
      courseId: 'crs_002',
      courseTitle: 'Machine Learning & Neural Networks',
      teacherId: 'tch_002',
      title: 'Project 1: Backpropagation from Scratch',
      description:
          'Build a 2-layer neural network with matrix dot products, sigmoid/ReLU activations, and categorical cross-entropy loss without external ML libraries.',
      dueDate: DateTime.now().add(const Duration(days: 6)),
      maxScore: 100,
      subject: 'Machine Learning',
      rubricCriteria: [
        'Correct gradient calculation & Jacobian matrices (40%)',
        'Convergence on XOR & MNIST subset (30%)',
        'Regularization & hyperparameter tuning (20%)',
        'Analysis write-up (10%)',
      ],
    ),
    AssignmentModel(
      id: 'asg_003',
      courseId: 'crs_003',
      courseTitle: 'Cloud Software Engineering',
      teacherId: 'tch_001',
      title: 'Assignment 2: Dockerized Microservices Pipeline',
      description:
          'Containerize an API gateway and auth microservice with docker-compose and write health-check probes.',
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      maxScore: 50,
      subject: 'Software Engineering',
      rubricCriteria: [
        'Multi-stage Dockerfile efficiency (30%)',
        'Service discovery and networking (40%)',
        'Automated health check probes (30%)',
      ],
    ),
  ];

  // Submissions
  static final List<AssignmentSubmissionModel> initialSubmissions = [
    AssignmentSubmissionModel(
      id: 'sub_001',
      assignmentId: 'asg_003',
      studentId: 'std_001',
      studentName: 'Alex Johnson',
      submissionContent:
          'https://github.com/alex-johnson/cloud-microservice-docker\nImplemented multi-stage alpine build, docker-compose orchestration, and health checks.',
      submittedAt: DateTime.now().subtract(const Duration(days: 3)),
      score: 47.5,
      teacherFeedback: 'Excellent modular structure and very slim Docker images!',
      aiFeedback:
          '✅ AI Evaluation: High code quality. Docker layers are well-cached. Healthcheck interval and timeout properly tuned.',
      weakConceptsIdentified: [],
      status: AssignmentStatus.graded,
    ),
    AssignmentSubmissionModel(
      id: 'sub_002',
      assignmentId: 'asg_003',
      studentId: 'std_002',
      studentName: 'David Smith',
      submissionContent: 'Single Dockerfile with standard node image.',
      submittedAt: DateTime.now().subtract(const Duration(days: 1)),
      score: 28.0,
      teacherFeedback: 'Missed compose networking setup and image size is over 1GB.',
      aiFeedback:
          '⚠️ AI Evaluation: Missing multi-stage builds. Container is running as root user. Consider non-root security context.',
      weakConceptsIdentified: ['Container Security', 'Docker Compose Networking'],
      status: AssignmentStatus.graded,
    ),
  ];

  // Exams
  static final List<ExamModel> initialExams = [
    ExamModel(
      id: 'exm_001',
      courseId: 'crs_001',
      courseTitle: 'Data Structures & Algorithms',
      title: 'Midterm Exam: Trees, Graphs & Dynamic Programming',
      examDate: DateTime.now().subtract(const Duration(days: 7)),
      durationMinutes: 120,
      totalMarks: 100,
      weightagePercentage: 35.0,
    ),
    ExamModel(
      id: 'exm_002',
      courseId: 'crs_002',
      courseTitle: 'Machine Learning & Neural Networks',
      title: 'Midterm Exam: Supervised Learning & Optimization',
      examDate: DateTime.now().subtract(const Duration(days: 5)),
      durationMinutes: 90,
      totalMarks: 100,
      weightagePercentage: 35.0,
    ),
    ExamModel(
      id: 'exm_003',
      courseId: 'crs_004',
      courseTitle: 'Applied Probability & Linear Algebra',
      title: 'Midterm Exam: SVD & Bayesian Inference',
      examDate: DateTime.now().subtract(const Duration(days: 10)),
      durationMinutes: 120,
      totalMarks: 100,
      weightagePercentage: 30.0,
    ),
  ];

  // Exam Grades for Alex Johnson (Solid A- average)
  static final List<ExamGradeModel> student1Grades = [
    ExamGradeModel(
      id: 'grd_001',
      examId: 'exm_001',
      examTitle: 'Midterm: Data Structures & Algorithms',
      studentId: 'std_001',
      studentName: 'Alex Johnson',
      courseId: 'crs_001',
      courseTitle: 'Data Structures & Algorithms',
      subject: 'Data Structures',
      marksObtained: 88.0,
      totalMarks: 100.0,
      remarks: 'Strong understanding of Red-Black invariants.',
    ),
    ExamGradeModel(
      id: 'grd_002',
      examId: 'exm_002',
      examTitle: 'Midterm: Machine Learning',
      studentId: 'std_001',
      studentName: 'Alex Johnson',
      courseId: 'crs_002',
      courseTitle: 'Machine Learning & Neural Networks',
      subject: 'Machine Learning',
      marksObtained: 92.5,
      totalMarks: 100.0,
      remarks: 'Flawless derivation of gradient descent update rules.',
    ),
    ExamGradeModel(
      id: 'grd_003',
      examId: 'exm_003',
      examTitle: 'Midterm: Applied Probability',
      studentId: 'std_001',
      studentName: 'Alex Johnson',
      courseId: 'crs_004',
      courseTitle: 'Applied Probability & Linear Algebra',
      subject: 'Linear Algebra',
      marksObtained: 74.0,
      totalMarks: 100.0,
      remarks: 'Struggled with SVD matrix decomposition proofs.',
    ),
  ];

  // Exam Grades for David Smith (At-Risk student with low scores)
  static final List<ExamGradeModel> studentAtRiskGrades = [
    ExamGradeModel(
      id: 'grd_r_001',
      examId: 'exm_001',
      examTitle: 'Midterm: Data Structures & Algorithms',
      studentId: 'std_002',
      studentName: 'David Smith',
      courseId: 'crs_001',
      courseTitle: 'Data Structures & Algorithms',
      subject: 'Data Structures',
      marksObtained: 46.0,
      totalMarks: 100.0,
      remarks: 'Failed graph traversal implementations and recursive proofs.',
    ),
    ExamGradeModel(
      id: 'grd_r_002',
      examId: 'exm_002',
      examTitle: 'Midterm: Machine Learning',
      studentId: 'std_002',
      studentName: 'David Smith',
      courseId: 'crs_002',
      courseTitle: 'Machine Learning & Neural Networks',
      subject: 'Machine Learning',
      marksObtained: 52.0,
      totalMarks: 100.0,
      remarks: 'Conceptual confusion in backprop chain rule.',
    ),
    ExamGradeModel(
      id: 'grd_r_003',
      examId: 'exm_003',
      examTitle: 'Midterm: Applied Probability',
      studentId: 'std_002',
      studentName: 'David Smith',
      courseId: 'crs_004',
      courseTitle: 'Applied Probability & Linear Algebra',
      subject: 'Linear Algebra',
      marksObtained: 42.0,
      totalMarks: 100.0,
      remarks: 'Needs urgent remediation in Eigenvalues and Vector Spaces.',
    ),
  ];

  // FAQs
  static final List<FAQItemModel> faqs = [
    FAQItemModel(
      question: 'How does the Academic Intelligence Engine identify weak areas?',
      answer:
          'EduPulse evaluates continuous student signals including weighted assignment scores, midterm exam percentiles, rubric criteria feedback, and attendance trends. It uses multi-factor diagnostic heuristics to pinpoint exact concept gaps.',
      category: 'Analytics Engine',
    ),
    FAQItemModel(
      question: 'What triggers an "At-Risk" alert for teachers and administrators?',
      answer:
          'A student is flagged as At-Risk when either their attendance falls below 75%, their average assignment/exam score falls below 60%, or rapid downward momentum is detected over two consecutive assessments.',
      category: 'Academic Flow',
    ),
    FAQItemModel(
      question: 'How can students submit assignments and receive automated feedback?',
      answer:
          'Students navigate to the Assignments section, upload their project link or solution text, and click Submit. EduPulse provides instant automated preliminary feedback and identifies improvement topics before final teacher grading.',
      category: 'Student Portal',
    ),
    FAQItemModel(
      question: 'Can reports be exported for official university accreditation?',
      answer:
          'Yes! Administrators and teachers can generate comprehensive academic performance summaries, class comparative charts, and individual progress reports with printable and exportable views.',
      category: 'Reports & Analytics',
    ),
  ];
}
