import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'dart:typed_data';

class AppwriteService {
  late Client client;
  late Databases database;
  AppwriteService() {
    client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1') // Cloud Appwrite endpoint
        .setProject('67063a6f003a4b04f99d'); // Cloud project ID
    database = Databases(client);
  }
  //USED FOR LOGIN PAGE FOR STUDENT USERS
  Future<bool> verifyUserCredentials(
      String username, String password, int dId, String Role) async {
    try {
      final result = await database.listDocuments(
        databaseId: '67063b0100053a7a4f6b',
        collectionId: '67063b70002a8f541a52', // user table
        queries: [Query.equal('username', username)],
      );
      final resultdID = await database.listDocuments(
          databaseId: '67063b0100053a7a4f6b',
          collectionId: '67063b2600143fa8cd34', //Students Table
          queries: [Query.equal('stud_department', dId)]);

      if (result.documents.isNotEmpty && resultdID.documents.isNotEmpty) {
        final userDocument = result.documents.first;
        final userDepartment = resultdID.documents.first;
        final storedPassword = userDocument.data['password'];
        final storedRole = userDocument.data['role'];
        print('Role Received S: $Role');
        print('Role Received from Database S: $storedRole');

        if ((password == storedPassword) &&
            (userDepartment.data['stud_department'] == dId) &&
            (Role == storedRole)) {
          print('Logged in Successfully');
          return true;
        } else {
          print('Invalid Password');
          return false;
        }
      } else {
        print(' No user found with the provided username');
        return false;
      }
    } catch (Exception) {
      print(' Error validating credentials :$Exception');
      return false;
    }
  }

//TO GET DEPARTMENT ID BY USING NAME FROM SELECT DEPARTMENT PAGE
  Future<int> getDepartmentIdByName(String? selectedDepartmentName) async {
    try {
      final response = await database.listDocuments(
        databaseId: '67063b0100053a7a4f6b',
        collectionId: '67063b38001859339782', // Department Table
        queries: [
          Query.equal('department_name',
              selectedDepartmentName), // Query by the department name
        ],
      );
      if (response.documents.isNotEmpty) {
        print(response);
        return response
            .documents.first.data['department_id']; // Return the department ID
      } else {
        return 0; // No department found with the given name
      }
    } catch (e) {
      print('Error fetching department ID: $e');
      return 0;
    }
  }

  //USED FOR LOGIN PAGE FOR FACULTY USERS
  Future<bool> verifyUserCredentialsF(
      String username, String password, int dId, String Role) async {
    try {
      final result = await database.listDocuments(
        databaseId: '67063b0100053a7a4f6b',
        collectionId: '67063b70002a8f541a52', // user table
        queries: [Query.equal('username', username)],
      );
      final resultdID = await database.listDocuments(
          databaseId: '67063b0100053a7a4f6b',
          collectionId: '67063b2e001e51be5681', //Faculty Table
          queries: [Query.equal('faculty_department', dId)]);

      if (result.documents.isNotEmpty && resultdID.documents.isNotEmpty) {
        final userDocument = result.documents.first;
        final userDepartment = resultdID.documents.first;
        final storedPassword = userDocument.data['password'];
        final storedRole = userDocument.data['role'];
        print('Role Received F: $Role');
        print('Role Received from Database F: $storedRole');

        if ((password == storedPassword) &&
            (userDepartment.data['faculty_department'] == dId) &&
            (Role == storedRole)) {
          print('Logged in Successfully');
          return true;
        } else {
          print('Invalid Password');
          return false;
        }
      } else {
        print(' No user found with the provided username');
        return false;
      }
    } catch (Exception) {
      print(' Error validating credentials :$Exception');
      return false;
    }
  }

  //inputing list of faculty names through departmentID
  Future<List<String>> getFacultyByDepartment(int departmentId) async {
    try {
      var response = await database.listDocuments(
        databaseId: '67063b0100053a7a4f6b',
        collectionId: '67063b2e001e51be5681', //Faculty Table
        queries: [Query.equal('faculty_department', departmentId)],
      );

      // Extract faculty names from the response
      List<String> facultyNames = response.documents
          .map((doc) => doc.data['faculty_name'].toString())
          .toList();
      return facultyNames;
    } catch (e) {
      print('Error fetching faculty: $e');
      return [];
    }
  }

//Verifying Email by using username
  Future<bool> verifyEmail(
      String gvnUserName, String userRole, String gvnEmail) async {
    try {
      if (userRole == 'Student') {
        final studentemailResponse = await database.listDocuments(
            databaseId: '67063b0100053a7a4f6b',
            collectionId: '67063b2600143fa8cd34',
            queries: [Query.equal('enrollment_no', gvnUserName)]);
        if (studentemailResponse.documents.isNotEmpty) {
          final dbUser = studentemailResponse.documents.first;
          final email = dbUser.data['stud_e_mail'].toString();
          if (gvnEmail == email) {
            print('E-mail Verification done Successfully.');
            return true;
          } else {
            print('Username and E-mail doesnt match');
            return false;
          }
        } else {
          print('Incorrect UserName');
          return false;
        }
      } else {
        final facultyemailResponse = await database.listDocuments(
            databaseId: '67063b0100053a7a4f6b',
            collectionId: '67063b2e001e51be5681',
            queries: [Query.equal('faculty_id', gvnUserName)]);
        if (facultyemailResponse.documents.isNotEmpty) {
          final dbUser = facultyemailResponse.documents.first;
          final email = dbUser.data['faculty_email'].toString();
          if (gvnEmail == email) {
            print('E-mail Verification done Successfully.');
            return true;
          } else {
            print('Username and E-mail doesnt match');
            return false;
          }
        } else {
          print('Incorrect UserName');
          return false;
        }
      }
    } catch (Exception) {
      print('Error Verifying E-mail: $Exception');
      return false;
    }
  }

  //Resetting Password by using UserName
  Future<bool> resetPassword(String rpusername, String rpPassword) async {
    try {
      final rpResponse = await database.listDocuments(
          databaseId: '67063b0100053a7a4f6b',
          collectionId: '67063b70002a8f541a52',
          queries: [Query.equal('username', rpusername)]);
      if (rpResponse.documents.isNotEmpty) {
        final userDoc = rpResponse.documents.first;
        final userID = userDoc.$id;
        await database.updateDocument(
            databaseId: '67063b0100053a7a4f6b',
            collectionId: '67063b70002a8f541a52',
            documentId: userID,
            data: {'password': rpPassword});
        print('Password Updated Successfully');
        return true;
      } else {
        print('Could not reset the password');
        return false;
      }
    } catch (Exception) {
      print('Could not reset the password ;$Exception');
      return false;
    }
  }

  //getting course code via course name and departmentId
  Future<String> getCourseCode(String courseName, int departmentId) async {
    try {
      print('executing try block : $courseName');
      print('executing try block : $departmentId');
      final ccresponse = await database.listDocuments(
        databaseId: '67063b0100053a7a4f6b', // Replace with your database ID
        collectionId:
            '67063b40000de94d73f4', // Replace with your courses collection ID
        queries: [
          Query.equal('course_name', courseName), // Filter by department ID
        ],
      );
      if (ccresponse.documents.isEmpty) {
        print('document is empty!');
      } else {
        print('document recieved : $ccresponse');
      }

      final courseDoc = ccresponse.documents.first;
      print(courseDoc);
      int recdeptId = courseDoc.data['course_dept'];
      print(recdeptId);

      if (recdeptId == departmentId) {
        final coursecode = courseDoc.data['course_code'];
        print(coursecode);
        return coursecode;
      } else {
        print('could not fetch course code');
        return '';
      }
    } catch (e) {
      print('Error fetching course code: $e');
      return '';
    }
  }

// Fetch courses by department
  Future<List<String>> getCoursesByDepartment(int departmentId) async {
    try {
      // Replace 'databaseId' and 'collectionId' with your actual IDs
      DocumentList result = await database.listDocuments(
        databaseId: '67063b0100053a7a4f6b', //  database ID
        collectionId: '67063b40000de94d73f4', //  courses table
        queries: [
          Query.equal('course_dept', departmentId), // Filter by department ID
        ],
      );
      List<String> courseName = result.documents
          .map((doc) => doc.data['course_name'].toString())
          .toList();
      print(courseName);
      return courseName;
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }

  //Fetching name of user using role and username
  Future<String> getFullName(String recUserID, String recUserRole) async {
    try {
      if (recUserRole == 'Student') {
        final fnResult = await database.listDocuments(
            databaseId: '67063b0100053a7a4f6b',
            collectionId: '67063b2600143fa8cd34', //Students Table
            queries: [Query.equal('enrollment_no', recUserID)]);
        final doc = fnResult.documents.first;
        print(doc);
        final fullName = doc.data['stud_name'];
        print(fullName);
        return fullName;
      } else {
        final fnResult = await database.listDocuments(
            databaseId: '67063b0100053a7a4f6b',
            collectionId: '67063b2e001e51be5681', //Faculty Table
            queries: [Query.equal('faculty_id', recUserID)]);
        final doc = fnResult.documents.first;
        print(doc);
        final fullName = doc.data['faculty_name'];
        print(fullName);
        return fullName;
      }
    } catch (Exception) {
      print('Could not fetch name: $Exception');
      return '';
    }
  }

  //getting course outcomes based on course name and dept id
  Future<List<String>> getCourseOutcomes(String courseName, int deptId) async {
    try {
      // Use the queries to filter by courseName and deptId
      final response = await database.listDocuments(
        databaseId: '67063b0100053a7a4f6b',
        collectionId: '67063b40000de94d73f4', // collection ID
        queries: [
          Query.equal('course_name', courseName),
          Query.equal('course_dept', deptId)
        ],
      );
      if (response.documents.isNotEmpty) {
        final document = response.documents.first;
        List<String> courseOutcomes = [
          document.data['CO1'],
          document.data['CO2'],
          document.data['CO3'],
          document.data['CO4'],
          document.data['CO5'],
          document.data['CO6'],
          //document.data['CO7'],
          //document.data['CO8']
        ];
        return courseOutcomes;
      } else {
        print('No document found for courseName: $courseName, deptId: $deptId');
        return [];
      }
    } catch (e) {
      print('Error fetching course outcomes: $e');
      return [];
    }
  }
  //For storing Feedback from form

  Future<void> submitFeedback(Map<String, dynamic> feedbackData) async {
    try {
      await database.createDocument(
        databaseId: '67063b0100053a7a4f6b',
        collectionId: '6710c87e001c8d4dfd50', //feedbackCollection
        documentId: 'unique()', // Your feedback collection ID
        data: feedbackData,
      );
    } catch (e) {
      throw Exception('Error submitting feedback: $e');
    }
  }

  //fetching data from feedback table
  Future<List<Map<String, dynamic>>> getFeedbackForCourse(
      String facultyName, String courseCode, int deptid) async {
    try {
      String prefix = facultyName.substring(0, 3);
      if (prefix == 'HOD') {
        var result = await database.listDocuments(
          databaseId: '67063b0100053a7a4f6b',
          collectionId: '6710c87e001c8d4dfd50', //feedback collection id
          queries: [
            Query.equal('dept_id', deptid),
          ],
        );

        return result.documents.map((doc) => doc.data).toList();
      } else {
        var result = await database.listDocuments(
          databaseId: '67063b0100053a7a4f6b',
          collectionId: '6710c87e001c8d4dfd50', //feedback collection id
          queries: [
            Query.equal('feedback_course_code', courseCode),
            Query.equal('feedback_faculty_name', facultyName)
          ],
        );

        return result.documents.map((doc) => doc.data).toList();
      }
    } catch (e) {
      print('Error fetching feedback: $e');
      return [];
    }
  }

  // count of feedback submission
  Future<bool> canSubmitFeedback(String enrollmentno, String coursecode) async {
    try {
      final documents = await database.listDocuments(
        databaseId: '67063b0100053a7a4f6b',
        collectionId: '6710c87e001c8d4dfd50',
        queries: [
          Query.equal('enrollment_no', enrollmentno),
          Query.equal('feedback_course_code', coursecode)
        ],
      );

      // Allow submission only if feedback count is less than 2
      return documents.total < 2;
    } catch (e) {
      print('Error fetching feedback count: $e');
      return false;
    }
  }

//Statistics Dropdown Visual page getting data
  Future<List<Map<String, dynamic>>> getCoursesByFacultyName(
      String facultyName, int sdvdepartmentid) async {
    try {
      String prefix = facultyName.substring(0, 3);
      if (prefix == 'HOD') {
        final result = await database.listDocuments(
          databaseId: '67063b0100053a7a4f6b',
          collectionId: '6710c87e001c8d4dfd50',
          queries: [
            Query.equal('dept_id', sdvdepartmentid), // Query by department ID
          ],
        );
        if (result.documents.isEmpty) {
          print("No documents found");
          return [];
        }
        List<Map<String, dynamic>> courses = result.documents.map((doc) {
          // Returning course details including faculty name
          return {
            'course_name': doc.data['feedback_course_name'] ?? 'Unknown Course',
            'course_code': doc.data['feedback_course_code'] ?? 'Unknown Code',
            'faculty_name':
                doc.data['feedback_faculty_name'] ?? 'Unknown Faculty',
          };
        }).toList();
        print(courses); // For debugging
        return courses;
      } else {
        final result = await database.listDocuments(
          databaseId: '67063b0100053a7a4f6b',
          collectionId: '6710c87e001c8d4dfd50',
          queries: [
            Query.equal(
                'feedback_faculty_name', facultyName), // Query by faculty name
          ],
        );
        if (result.documents.isEmpty) {
          print("No documents found");
          return [];
        }
        List<Map<String, dynamic>> courses = result.documents.map((doc) {
          // Returning course details including faculty name
          return {
            'course_name': doc.data['feedback_course_name'] ?? 'Unknown Course',
            'course_code': doc.data['feedback_course_code'] ?? 'Unknown Code',
            'faculty_name':
                doc.data['feedback_faculty_name'] ?? 'Unknown Faculty',
          };
        }).toList();
        print(courses); // For debugging
        return courses;
      }
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }

  //Add a user
  Future<String> addUser(String username, String password, String role) async {
    try {
      final userData = {
        'username': username,
        'password': password,
        'role': role // Store passwords securely in production
      };

      final result = await database.createDocument(
        databaseId:
            '67063b0100053a7a4f6b', // Replace with your actual database ID for users
        collectionId:
            '67063b70002a8f541a52', // Replace with the actual collection ID for users
        documentId: 'unique()', // Automatically generates a unique document ID
        data: userData,
      );

      print(result);
      return "User created successfully";
    } catch (e) {
      print('Error adding user: $e');
      return "Error adding user";
    }
  }

// Add faculty to the database
  Future<String> addFaculty(
      String username, String name, String email, int deptid) async {
    try {
      final facultyData = {
        'faculty_id': username,
        'faculty_name': name,
        'faculty_department': deptid,
        'faculty_email': email,
      };

      final result = await database.createDocument(
        databaseId:
            '67063b0100053a7a4f6b', // Replace with your actual database ID
        collectionId:
            '67063b2e001e51be5681', // Replace with the actual collection ID for faculty
        documentId: 'unique()', // Automatically generates a unique document ID
        data: facultyData,
      );

      print(result);
      return "Faculty added successfully";
    } catch (e) {
      print('Error adding faculty: $e');
      return "Error adding faculty";
    }
  }

  //Add Course
  Future<String> addCourse(
      String coursecode,
      String coursename,
      int coursedept,
      String co1,
      String co2,
      String co3,
      String co4,
      String co5,
      String co6,
      String co7,
      String co8) async {
    try {
      final courseData = {
        'course_code': coursecode,
        'course_name': coursename,
        'course_dept': coursedept,
        'CO1': co1,
        'CO2': co2,
        'CO3': co3,
        'CO4': co4,
        'CO5': co5,
        'CO6': co6,
        'CO7': co7,
        'CO8': co8,
      };
      final result = await database.createDocument(
        databaseId: '67063b0100053a7a4f6b', // Replace with your database ID
        collectionId: '67063b40000de94d73f4',
        documentId: 'unique()',
        data: courseData,
      );
      print(result);
      return "Course added successfully";
    } catch (e) {
      print('Error adding Course: $e');
      return "Error adding Course";
    }
  }

  // Request Storage Permission using the 'perm' prefix
  Future<void> _requestStoragePermission() async {
    if (await perm.Permission.storage.request().isGranted) {
      print("Storage permission granted");
    } else {
      throw Exception("Storage permission denied. Cannot export file.");
    }
  }

  Future<bool> exportDataToExcel(
      String facultyname, String coursecode, int deptid) async {
    try {
      List<dynamic> row = [];
      // Step 1: Request permission
      await _requestStoragePermission();

      // Step 2: Fetch data from Appwrite with filters
      final response = await database.listDocuments(
          databaseId: '67063b0100053a7a4f6b',
          collectionId: '6710c87e001c8d4dfd50',
          queries: [
            Query.equal('dept_id', deptid),
            Query.equal('feedback_course_code', coursecode),
            Query.equal('feedback_faculty_name', facultyname)
          ]); //FeedbackCollection

      // Step 3: Create an Excel sheet
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];

      // Step 4: Add Header Row
      sheetObject.appendRow([
        'Department',
        'Enrollment No.',
        'Feedback Course',
        'Course Code',
        'Coverage of the course curriculum',
        'Competence and commitment of faculty',
        'Communication',
        'Pace of content covered ',
        'Relevance of the Content of Curriculum',
        'CO1',
        'CO2',
        'CO3',
        'CO4',
        'CO5',
        'CO6',
        'Lab/Infrastructure',
        'Reference Books',
        'Suggestions'
      ]);

      // Step 5: Add Data Rows
      for (var item in response.documents) {
        // Create a list of values with null checks
        row = [
          item.data['dept_id'] ?? '', // Use empty string if null
          item.data['enrollment_no'] ?? '',
          item.data['feedback_course_name'] ?? '',
          item.data['feedback_course_code'] ?? '',
          item.data['frf1'] ?? '',
          item.data['frf2'] ?? '',
          item.data['frf3'] ?? '',
          item.data['frf4'] ?? '',
          item.data['frf5'] ?? '',
          item.data['co1_F'] ?? '',
          item.data['co2_F'] ?? '',
          item.data['co3_F'] ?? '',
          item.data['co4_F'] ?? '',
          item.data['co5_F'] ?? '',
          item.data['co6_F'] ?? '',
          item.data['lab_infra'] ?? '',
          item.data['library'] ?? '',
          item.data['suggestion'] ?? ''
        ];

        // Filter out null or empty values from the row
        row = row.where((element) => element != null && element != '').toList();

        // Append the filtered row to the sheet
        if (row.isNotEmpty) {
          sheetObject.appendRow(row);
        }
      }
      final excelBytes = Uint8List.fromList(excel.save()!);

      final String result = await FileSaver.instance.saveFile(
        '$facultyname.xlsx',
        excelBytes,
        'xlsx',
        mimeType: MimeType.MICROSOFTEXCEL
      );
      return true;
    } catch (e) {
      print('Error exporting data: $e');
      return false;
    }
  }
}
