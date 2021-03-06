import "dart:typed_data";
import "binary_reader.dart";

class BlockReader extends BinaryReader {
  @override
  int blockType;

  BlockReader(ByteData data) : super(data) {
    blockType = 0;
  }

  BlockReader.fromBlock(this.blockType, ByteData stream) : super(stream);

  // A binary block is defined as a TLV with type of one byte, length of 4
  // bytes, and then the value following.
  @override
  BlockReader readNextBlock(Map<String, int> types) {
    if (isEOF()) {
      return null;
    }
    int blockType = readUint8();
    int length = readUint32();

    Uint8List buffer = Uint8List(length);

    return BlockReader.fromBlock(
        blockType,
        ByteData.view(readUint8Array(
          buffer,
          buffer.length,
          0,
        ).buffer));
  }
}
