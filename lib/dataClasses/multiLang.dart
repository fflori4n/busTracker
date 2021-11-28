String activeLang = 'srb';

class langStr {
  String eng;
  String srb;
  String cpb;
  String hun;

  langStr(
      this.eng,
      this.srb,
      this.cpb,
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

      case "cpb":
        return cpb;
        break;

      default:
        return eng;
    }
  }
}

//final langStr lbl_station = new langStr('Staнtion', 'Staнnica', 'Станица', 'Megálló');
final langStr lbl_noSelectedStation = new langStr('', '', '', '');
final langStr lbl_filters = new langStr('#filters', '#filteri','филтери', '#filterek');
final langStr lbl_lineName = new langStr('LINE', 'LINIJA','ЛИНИЈА','JÁRAT');
final langStr lbl_departsAt = new langStr('DEPARTS AT', 'POLAZAK','ПОЛАЗАК','INDUL');
final langStr lbl_arrivesIn = new langStr('ARRIVES IN', 'DOLAZAK','ДОЛАЗАК','ÉRKEZIK');
final langStr lbl_lineDescr = new langStr('LINE WAYPOINTS - MAIN STATIONS', 'KARAKTERISTIČNE STANICE', 'КАРАКТЕРИСТИЧНЕ СТАНИЦЕ', 'FONTOS / JELLEMZŐ MEGÁLLÓK');
final langStr lbl_nickName = new langStr('NICKNAME', 'NADIMAK','НАДИМАК', 'BECENÉV');
final langStr lbl_expError = new langStr('EXP.ERROR', 'OČEK.GREŠKA','ОЧЕК.ГРЕШКА','VÁRT HIBA');

final langStr lbl_arriving = new langStr('ARRIVING', 'DOLAZI', 'ДОЛАЗИ', 'ÉRKEZIK');
final langStr lbl_left = new langStr('LEFT', 'POŠAO','ПОШАО', 'ELMENT');

final langStr lbl_filt_hiddenLines = new langStr('Hidden lines', 'Sakrivene linije','Сакривене линије','Rejtett vonalak');
final langStr lbl_filt_leftBuses = new langStr('Left buses', 'Prošli busevi', 'Прошли бусеви','Előző buszok');
final langStr lbl_filt_eta1 = new langStr('Only in next 15min', 'Samo narednih 15min','само наредних 15мин', 'Csak a következő 15min');
final langStr lbl_filt_onlyFirst10 = new langStr('Only first 10', 'Samo prvih 10', 'само првих 10','Csak első 10');

final langStr lbl_schedule = new langStr('SCHEDULE', 'RED VOŽNJE','РЕД ВОЖЊЕ', 'MENETREND');
final langStr lbl_map = new langStr('MAP', 'MAPA','МАПА','TÉRKÉP');

final langStr lbl_noSelected= new langStr('SELECT A STATION', 'IZABERITE STANICU', 'ИЗАБЕРИТЕ СТАНИЦУ', 'VÁLASSZON MEGÁLLÓT');
final langStr lbl_clickMap = new langStr('Find and click your station on the map!', 'Pronađi i klikni željenu stanicu na mapu!','Пронађи и кликни желјену станицу на мапу', 'Kattintson a megállóra a térképen!');





