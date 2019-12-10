class DemoData {
  static Map<String, String> formValues = {};
  List<String> _countries = ['Canada', 'France', 'United States', 'Japan'];
  List<String> _canadaProvinces = [
    'Alberta',
    'British Columbia',
    'Manitoba',
    'New Brunswick',
    'Newfoundland and Labrador',
    'Northwest Territories',
    'Nova Scotia',
    'Nunavut',
    'Ontario',
    'Prince Edward Island',
    'Quebec',
    'Saskatchewan',
    'Yukon',
  ];

  List<String> _japanPrefectures = [
    'Hokkaido',
    'Aomori',
    'Iwate',
    'Miyagi',
    'Akita',
    'Yamagata',
    'Fukushima',
    'Ibaraki',
    'Tochigi',
    'Gunma',
    'Saitama',
    'Chiba',
    'Tokyo',
    'Kanagawa',
    'Niigata',
    'Toyama',
    'Ishikawa',
    'Fukui',
    'Yamanashi',
    'Nagano',
    'Gifu',
    'Shizuoka',
    'Aichi',
    'Mie',
    'Shiga',
    'Kyoto',
    'Osaka',
    'Hyogo',
    'Nara',
    'Wakayama',
    'Tottori',
    'Shimane',
    'Okayama',
    'Hiroshima',
    'Yamaguchi',
    'Tokushima',
    'Kagawa',
    'Ehime',
    'Kochi',
    'Fukuoka',
    'Miyazaki',
    'Nagasaki',
    'Kumamoto',
    'Kagoshima',
    'Saga',
    'Oita',
    'Okinawa',
  ];

  List<String> _usaStates = [
    'Alabama',
    'Alaska',
    'Arizona',
    'Arkansas',
    'California',
    'Colorado',
    'Connecticut',
    'Delaware',
    'Florida',
    'Georgia',
    'Hawaii',
    'Idaho',
    'IllinoisIndiana',
    'Iowa',
    'Kansas',
    'Kentucky',
    'Louisiana',
    'Maine',
    'Maryland',
    'Massachusetts',
    'Michigan',
    'Minnesota',
    'Mississippi',
    'Missouri',
    'MontanaNebraska',
    'Nevada',
    'New Hampshire',
    'New Jersey',
    'New Mexico',
    'New York',
    'North Carolina',
    'North Dakota',
    'Ohio',
    'Oklahoma',
    'Oregon',
    'PennsylvaniaRhode Island',
    'South Carolina',
    'South Dakota',
    'Tennessee',
    'Texas',
    'Utah',
    'Vermont',
    'Virginia',
    'Washington',
    'West Virginia',
    'Wisconsin',
    'Wyoming'
  ];

  String getSubdivisionTitle(String country) {
    String subdivision = '';
    switch (country) {
      case 'Canada':
        subdivision = 'Province';
        break;
      case 'Japan':
        subdivision = 'Prefecture';
        break;
      case 'United States':
        subdivision = 'State';
        break;
      case 'France':
        break;
    }
    return subdivision;
  }

  List<String> getCountries() => _countries;
  List<String> getSubdivisionList(String subdivision) {
    switch (subdivision) {
      case 'Province':
        return _canadaProvinces;
      case 'Prefecture':
        return _japanPrefectures;
      case 'State':
        return _usaStates;
      default:
        return [];
    }
  }
}

enum InputType { text, email, number, telephone }
enum CreditCardInputType { number, expirationDate, securityCode }
enum CreditCardNetwork { visa, mastercard, amex }
