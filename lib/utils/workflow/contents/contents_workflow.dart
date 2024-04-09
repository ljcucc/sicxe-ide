/// A base class for ContentsWorkflow, implemeted the most basic function to interact with other workflow
class ContentsWorkflow {
  Map<String, String> _contents = {};

  Future<void> init() async {
    print("no init() implemented");
  }

  Future<bool> isFileExists(String filename) async =>
      _contents.containsKey(filename);

  Future<String> getFileString(String filename,
          {String? fallbackString}) async =>
      _contents[filename] ?? (fallbackString ?? "");

  Future<void> setFileString(String filename, String content) async =>
      _contents[filename] = content;

  Future<void> newFile(String filename, String? content) async {
    _contents[filename] = content ?? "";
  }

  Future<void> deleteFile(String filename) async {
    _contents.remove(filename);
  }

  Future<List<String>> getFileList() async => _contents.keys.toList();
}
