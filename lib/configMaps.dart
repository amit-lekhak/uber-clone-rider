import 'package:firebase_auth/firebase_auth.dart';
import 'package:rider_app/Models/allUsers.dart';

const String mapKey = "AIzaSyAD8_JmEJ9RnwHUp2woLVw9Fyk3B_V2FhU";
const String mapBoxKey =
    "pk.eyJ1IjoicmlzM3IiLCJhIjoiY2s1YzV3NjdtMWV1bDNucG5sb2M0dnJvOSJ9.ywM58I6P5A-s1CVbaOXJcA";

User firebaseUser;
Users userCurrentInfo;

String serverToken =
    "key=AAAAjfsgUmY:APA91bE691VOd7ScI4JoVuYReVwUzzpUoBvo2WDr_g5ewu7hPC5rbI871AwRHW5JUlsbqzmJoQ9tS_xJXVNThuAUTZn2v9596FNaYJApMegcp-oniQrODCeyHKCWtlaaA9p5jq-Qp1Qh";

int driverRequestTimeout = 40;
