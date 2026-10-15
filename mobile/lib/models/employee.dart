/// Funcionário da Atlas Logistics que utiliza o aplicativo.
class Employee {
  const Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.jobTitle,
    required this.registration,
    this.phone,
    this.unit,
  });

  final String id;
  final String name;
  final String email;
  final String? phone;
  final String jobTitle;

  /// Matrícula do funcionário (ex.: ATL-2847).
  final String registration;

  /// Unidade de trabalho já formatada (ex.: "Santos - SP").
  final String? unit;

  String get firstName => name.trim().split(' ').first;

  /// Iniciais exibidas no avatar (ex.: "Lucas Almeida" -> "LA").
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      jobTitle: json['jobTitle'] as String,
      registration: json['registration'] as String,
      unit: json['unit'] as String?,
    );
  }
}
