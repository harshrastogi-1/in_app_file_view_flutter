enum ViewStatus {
  /// Not initialized
  NONE,

  /// File is being downloaded or written
  LOADING,

  /// Unsupported platform
  UNSUPPORTED_PLATFORM,

  /// Nonexistent file
  NON_EXISTENT,

  /// Unsupported file type
  UNSUPPORTED_FILETYPE,

  /// Successfully opened file
  DONE,
}
