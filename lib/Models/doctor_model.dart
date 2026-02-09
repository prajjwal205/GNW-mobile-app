class DoctorModel{
  final int id;
  final String name;
  final int subCategoryId;
  final String Qualification;
  final String AboutDoctor;
  final String email;
  final String location;
  final int Experience;
  final String Phonenumber;
  final String? doctorImage; // Nullable
  final String? clinicImage;
  final bool IsActive;

  DoctorModel({
    required this.id,
    required this.name,
    required this.subCategoryId,
    required this.Qualification,
    required this.AboutDoctor,
    required this.email,
    required this.location,
    required this.Experience,
    required this.Phonenumber,
    required this.IsActive,
     this.doctorImage,
     this.clinicImage,

});
factory DoctorModel.fromJson(Map<String,dynamic>json){
  return DoctorModel(
      id: json["Id"]??0,
      name: json["DoctorName"]?? 'Unknown Doctor',
      subCategoryId: json["HealthCareSubCategoryId"]??0,
      Qualification: json["Qualification"]??'',
      AboutDoctor: json["AboutDoctor"]??'',
      email: json["Email"]??'',
      location: json["location"]??'Unknown',
      Experience: json["Experience"]??0,
      Phonenumber: json["Phonenumber"]??'',
    doctorImage: json['DoctorImage'],
    clinicImage: json['ClinicImage'],
      IsActive: json["IsActive"]??false,
  );
}
}