extension ListExt<T> on List<T> {
  T? get(int index) {
    try {
      return this[index];
    } catch (err) {
      return null;
    }
  }

  ///This will always return an element unless the list is empty.
  ///In case of overflow, the list will repeat.
  T getAlways(int index) {
    assert(isNotEmpty, "List should be empty");
    return this[index % length];
  }
}
