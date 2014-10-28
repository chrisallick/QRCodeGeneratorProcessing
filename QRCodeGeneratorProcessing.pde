QREncoder qrencoder;

void setup() {
  size( 300, 300 );

  qrencoder = new QREncoder( this );
  /*
    string to encode,
   size squared,
   false: just throw even, true: throw event and save to file
   */
  qrencoder.encodeImage( "http://a.ru", 300, false );
}

void draw() {
}

void qrencoderEvent(QREncoder qrencoder) {
  println("encoder event fired and received");

  image( qrencoder.qr_image, 0, 0 );
}

