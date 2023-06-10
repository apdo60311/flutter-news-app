enum Country {
  ae,
  ar,
  at,
  au,
  be,
  bg,
  br,
  ca,
  ch,
  cn,
  co,
  cu,
  cz,
  de,
  eg,
  fr,
  gb,
  gr,
  hk,
  hu,
  id,
  ie,
  il,
  iN,
  it,
  jp,
  kr,
  lt,
  lv,
  ma,
  mx,
  my,
  ng,
  nl,
  no,
  nz,
  ph,
  pl,
  pt,
  ro,
  rs,
  ru,
  sa,
  se,
  sg,
  si,
  sk,
  th,
  tr,
  tw,
  ua,
  us,
  ve,
  za;
}

class CountryHandler {
  static String getCountryString(Country country) {
    switch (country) {
      case Country.ae:
        return 'ae';
      case Country.ar:
        return 'ar';
      case Country.at:
        return 'at';
      case Country.au:
        return 'au';
      case Country.be:
        return 'be';
      case Country.bg:
        return 'bg';
      case Country.br:
        return 'br';
      case Country.ca:
        return 'ca';
      case Country.ch:
        return 'ch';
      case Country.cn:
        return 'cn';
      case Country.co:
        return 'co';
      case Country.cu:
        return 'cu';
      case Country.cz:
        return 'cz';
      case Country.de:
        return 'de';
      case Country.eg:
        return 'eg';
      case Country.fr:
        return 'fr';
      case Country.gb:
        return 'gb';
      case Country.gr:
        return 'gr';
      case Country.hk:
        return 'hk';
      case Country.hu:
        return 'hu';
      case Country.id:
        return 'id';
      case Country.ie:
        return 'ie';
      case Country.il:
        return 'il';
      case Country.iN:
        return 'in';
      case Country.it:
        return 'it';
      case Country.jp:
        return 'jp';
      case Country.kr:
        return 'kr';
      case Country.lt:
        return 'lt';
      case Country.lv:
        return 'lv';
      case Country.ma:
        return 'ma';
      case Country.mx:
        return 'mx';
      case Country.my:
        return 'my';
      case Country.ng:
        return 'ng';
      case Country.nl:
        return 'nl';
      case Country.no:
        return 'no';
      case Country.nz:
        return 'nz';
      case Country.ph:
        return 'ph';
      case Country.pl:
        return 'pl';
      case Country.pt:
        return 'pt';
      case Country.ro:
        return 'ro';
      case Country.rs:
        return 'rs';
      case Country.ru:
        return 'ru';
      case Country.sa:
        return 'sa';
      case Country.se:
        return 'se';
      case Country.sg:
        return 'sg';
      case Country.si:
        return 'si';
      case Country.sk:
        return 'sk';
      case Country.th:
        return 'th';
      case Country.tr:
        return 'tr';
      case Country.tw:
        return 'tw';
      case Country.ua:
        return 'ua';
      case Country.us:
        return 'us';
      case Country.ve:
        return 've';
      case Country.za:
        return 'za';
    }
  }

  static String? getCountryCode(String countryName) {
    switch (countryName) {
      case 'United Arab Emirates':
        return 'ae';
      case 'Argentina':
        return 'ar';
      case 'Austria':
        return 'at';
      case 'Australia':
        return 'au';
      case 'Belgium':
        return 'be';
      case 'Bulgaria':
        return 'bg';
      case 'Brazil':
        return 'br';
      case 'Canada':
        return 'ca';
      case 'Switzerland':
        return 'ch';
      case 'China':
        return 'cn';
      case 'Colombia':
        return 'co';
      case 'Cuba':
        return 'cu';
      case 'Czech Republic':
        return 'cz';
      case 'Germany':
        return 'de';
      case 'Egypt':
        return 'eg';
      case 'France':
        return 'fr';
      case 'United Kingdom':
        return 'gb';
      case 'Greece':
        return 'gr';
      case 'Hong Kong':
        return 'hk';
      case '':
        return 'hu';
      case '':
        return 'id';
      case '':
        return 'ie';
      case '':
        return 'il';
      case '':
        return 'in';
      case '':
        return 'it';
      case '':
        return 'jp';
      case '':
        return 'kr';
      case '':
        return 'lt';
      case '':
        return 'lv';
      case '':
        return 'ma';
      case '':
        return 'mx';
      case '':
        return 'my';
      case '':
        return 'ng';
      case '':
        return 'nl';
      case '':
        return 'no';
      case '':
        return 'nz';
      case '':
        return 'ph';
      case '':
        return 'pl';
      case '':
        return 'pt';
      case '':
        return 'ro';
      case '':
        return 'rs';
      case '':
        return 'ru';
      case '':
        return 'sa';
      case '':
        return 'se';
      case '':
        return 'sg';
      case '':
        return 'si';
      case '':
        return 'sk';
      case '':
        return 'th';
      case 'Türkiye':
        return 'tr';
      case '':
        return 'tw';
      case '':
        return 'ua';
      case 'USA':
        return 'us';
      case '':
        return 've';
      case '':
        return 'za';
    }
  }

  static List contriesList = [
    'USA',
    'United Arab Emirates',
    'Argentina',
    'Austria',
    'Australia',
    'Belgium',
    'Bulgaria',
    'Brazil',
    'Canada',
    'Switzerland',
    'China',
    'Colombia',
    'Cuba',
    'Czech Republic',
    'Germany',
    'Egypt',
    'France',
    'United Kingdom',
    'Greece',
    'Hong Kong',
    'Türkiye',
  ];
}
