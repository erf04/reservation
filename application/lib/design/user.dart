class User { 
  int id; 
  String userName; 
  String profilePhoto; 
  bool isSuperVisor; 
  bool isShiftManager; 
 
  User({ 
    required this.id, 
    required this.userName, 
    required this.profilePhoto, 
    required this.isSuperVisor, 
    required this.isShiftManager, 
  }); 
 
  factory User.fromJson(Map<String, dynamic> json) { 
    return User( 
      id: json['id'], 
      userName: json['username'], 
      profilePhoto: json['profile'], 
      isSuperVisor: json['is_supervisor'], 
      isShiftManager: json['is_shift_manager'], 
    ); 
  } 
} 