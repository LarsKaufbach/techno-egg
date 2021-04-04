
class Band {
  
  private final float[] array;
  public final int offset;
  public final int count;
  
  Band(float[] array, int offset, int count) {
    this.array = array;
    this.offset = offset;
    this.count = count;
  }
  
  float get(int index) {
    final int i = offset + index;
    if (i < 0 || i >= array.length)
      return 0;
    return array[offset + index];
  }
}
