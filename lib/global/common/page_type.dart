enum PageType {
  video,
  dateTime,
  list,
  memo,
  docUpload,
  docList
}

class PageTypeHelper {
  static const Map<PageType, String> _valueToString = {
    PageType.video: 'video',
    PageType.dateTime: 'dateTime',
    PageType.list: 'list',
    PageType.memo: 'memo',
    PageType.docUpload : 'docUpload',
    PageType.docList : 'docList',
  };

  static String getStringValue(PageType pageType) {
    return _valueToString[pageType] ?? 'memo';
  }

  static PageType fromStringValue(String value) {
    return _valueToString.entries
        .firstWhere((entry) => entry.value == value, orElse: () => const MapEntry(PageType.memo, ''))
        .key;
  }

}
