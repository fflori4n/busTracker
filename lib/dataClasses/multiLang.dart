String activeLang = 'srb';

class langStr {
  String eng;
  String srb;
  String hun;

  langStr(
      this.eng,
      this.srb,
      this.hun
      );

  String print(){
    switch (activeLang) {
      case "srb":
        return srb;
        break;

      case "eng":
        return eng;
        break;

      case "hun":
        return hun;
        break;

      default:
        return eng;
    }
  }
}

final langStr lbl_station = new langStr('Station', 'Stanica', 'Megálló');
final langStr lbl_noSelectedStation = new langStr('', '', '');
final langStr lbl_filters = new langStr('#filters', '#filteri', '#filterek');
final langStr lbl_lineName = new langStr('LINE', 'LINIJA', 'JÁRAT');
final langStr lbl_departsAt = new langStr('DEPARTS AT', 'POLAZAK', 'INDUL');
final langStr lbl_arrivesIn = new langStr('ARRIVES IN', 'DOLAZAK', 'ÉRKEZIK');
final langStr lbl_lineDescr = new langStr('LINE WAYPOINTS - MAIN STATIONS',
    'KARAKTERISTIČNE STANICE',
    'FONTOS / JELLEMZŐ MEGÁLLÓK');
final langStr lbl_nickName = new langStr('NICKNAME', 'NADIMAK', 'BECENÉV');
final langStr lbl_expError = new langStr('EXP.ERROR', 'OČEK.GREŠKA', 'VÁRT HIBA');

final langStr lbl_arriving = new langStr('ARRIVING', 'DOLAZI', 'ÉRKEZIK');
final langStr lbl_left = new langStr('LEFT', 'POŠAO', 'ELMENT');

final langStr lbl_filt_hiddenLines = new langStr('Hidden lines', 'Sakrivene linije', 'Rejtett vonalak');
final langStr lbl_filt_leftBuses = new langStr('Left buses', 'Prošli busevi', 'Előző buszok');
final langStr lbl_filt_eta1 = new langStr('Only in next 15min', 'Samo narednih 15min', 'Csak a következő 15min');
final langStr lbl_filt_onlyFirst10 = new langStr('Only first 10', 'Samo prvih 10', 'Csak első 10');

final langStr lbl_schedule = new langStr('SCHEDULE', 'RED VOŽNJE', 'MENETREND');
final langStr lbl_map = new langStr('MAP', 'MAPA', 'TÉRKÉP');

final langStr lbl_noSelected= new langStr('SELECT A STATION', 'IZABERITE STANICU', 'VÁLASSZON MEGÁLLÓT');
final langStr lbl_clickMap = new langStr('Find and click your station on the map!', 'Pronađi i klikni željenu stanicu na mapi!', 'Kattintson a megállóra a térképen!');

// 'location enabled'
// 'center current location'
// 'where am I?'
// 'enable cookies'




