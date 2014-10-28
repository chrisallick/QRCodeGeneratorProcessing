import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.Hashtable;

import javax.imageio.ImageIO;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

import java.lang.reflect.Method;

class QREncoder {
  BufferedImage qrimage;
  PImage qr_image;
  
  Method qrencoderEventMethod;
  
  PApplet parent;
  
  QREncoder( PApplet _parent ) {
    this.parent = _parent;
    
    try {
        qrencoderEventMethod = parent.getClass().getMethod("qrencoderEvent", new Class[] { 
                QREncoder.class             }
        );
    } 
    catch (Exception e) {
        System.out.println("You need to have a qrencoderEvent method");
    }
  }
  
  void encodeImage( String _url, int _size, boolean print ) {
      String myCodeText = _url;
      //String filePath = "/Users/chris.allick/Desktop/CrunchifyQR.png";
      String filePath = sketchPath("")+"/qr_"+str(millis())+".png";
      int size = _size;
      String fileType = "png";
      File myFile = new File(filePath);

      try {
          Hashtable<EncodeHintType, ErrorCorrectionLevel> hintMap = new Hashtable<EncodeHintType, ErrorCorrectionLevel>();
          hintMap.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.L);
          QRCodeWriter qrCodeWriter = new QRCodeWriter();
          BitMatrix byteMatrix = qrCodeWriter.encode(myCodeText,BarcodeFormat.QR_CODE, size, size, hintMap);
          int CrunchifyWidth = byteMatrix.getWidth();
          qrimage = new BufferedImage(CrunchifyWidth, CrunchifyWidth,
                  BufferedImage.TYPE_INT_RGB);
          qrimage.createGraphics();
 
          Graphics2D graphics = (Graphics2D) qrimage.getGraphics();
          graphics.setColor(Color.WHITE);
          graphics.fillRect(0, 0, CrunchifyWidth, CrunchifyWidth);
          graphics.setColor(Color.BLACK);
 
          for (int i = 0; i < CrunchifyWidth; i++) {
              for (int j = 0; j < CrunchifyWidth; j++) {
                  if (byteMatrix.get(i, j)) {
                      graphics.fillRect(i, j, 1, 1);
                  }
              }
          }
          
          if( print ) {
            ImageIO.write(qrimage, fileType, myFile);
          }
          
          try { 
            qr_image = new PImage(qrimage.getWidth(),qrimage.getHeight(),PConstants.ARGB);
            qrimage.getRGB(0, 0, qr_image.width, qr_image.height, qr_image.pixels, 0, qr_image.width);
            qr_image.updatePixels();
          }
          catch(Exception e) {
            System.err.println("Can't create image from buffer");
            e.printStackTrace();
          }

      } catch (WriterException e) {
          e.printStackTrace();
      } catch (IOException e) {
          e.printStackTrace();
      }
      
      try {
          qrencoderEventMethod.invoke(parent, new Object[] { 
                  this                     }
          );
      } 
      catch (Exception e) {
          System.err.println("There was an error invoking qrencoderEvent()");
          e.printStackTrace();
          qrencoderEventMethod = null;
      }
  }
}
