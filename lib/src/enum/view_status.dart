enum ViewStatus {
  /// Not initialized
  none,

  /// File is being downloaded or written
  loading,

  /// Unsupported platform
  unsupportedPlatform,

  /// Nonexistent file
  nonExistent,

  /// Unsupported file type
  unsupportedFileType,

  /// Successfully opened file
  done,
}
