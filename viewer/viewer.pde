/*
* Hotspot 1D Viewer
* Cristian Delgado, Dr. Miguel Condes, INB UNAM Juriquilla
* 2019
* External Libraries
* ControlP5
*/

import processing.serial.*;
import java.util.*;
import controlP5.*;

ControlP5 p5;
Textlabel localDate;
Textlabel localTime;
Chart chart;
Serial port;
ScrollableList sListPorts;
List listPorts;
int serialPortNumber;
float dataInChart = 0;
String  osName;
boolean runSerial = false;
PrintWriter output;

void setup()
{
  size(1000,600);
  osName = System.getProperty("os.name");
  
  println("Running on " + osName);
  PImage icon = loadImage("data/icon.png");
  surface.setIcon(icon);
  
  p5 = new ControlP5(this);
  List listPorts = Arrays.asList(Serial.list());
  sListPorts = p5.addScrollableList("ports");
  sListPorts.setPosition(10,10)
    .setSize(200,100)
    .setBarHeight(20)
    .setItemHeight(20)
    .setItems(listPorts)
    .setType(ScrollableList.LIST);
    ;
      
  p5.addTextfield("experiment")
     .setPosition(250,10)
     .setSize(150,20)
  ;
  p5.addToggle("Start")
    .setPosition(440,10)
    .setSize(70,20)
    .setValue(false)
    .setMode(ControlP5.SWITCH)
    ;
  p5.addButton("Open Data folder")
    .setPosition(550,10)
    .setSize(100,20)
    ;
  localDate = p5.addTextlabel("date")
                    .setText(str(day()) + '-' + str(month()) + '-' + str(year()))
                    .setPosition(700,10)
                    .setFont(createFont("Courier",30))
                    ;
  localTime = p5.addTextlabel("time")
    .setText(str(hour())+":" + str(minute()) +":" +str(second()))
    .setPosition(700,40)
    .setFont(createFont("Courier",30))
    ;
                    
  chart = p5.addChart("Temperature")
    .setPosition(10, 120)
    .setSize(980, 400)
    .setView(Chart.LINE)
    .setStrokeWeight(1.5)
    .setRange(0,40)
    .setColorCaptionLabel(color(255,255,255,255))
    ;
    chart.addDataSet("incoming");
    chart.setData("incoming", new float[200]);

}

void draw()
{
  surface.setTitle("Hotspot 1D "  );
  background(0);
  p5.get(ScrollableList.class,"ports").setItems(Arrays.asList(Serial.list()));
  p5.get(Textlabel.class,"time").setText(str(hour())+":" + str(minute()) +":" +str(second()));
  p5.get(Textlabel.class,"date").setText(str(day()) + '-' + str(month()) + '-' + str(year()));
}

void controlEvent(ControlEvent theEvent){
  if(theEvent.getController().getName()=="Open Data folder")
  {
    launch(sketchPath());
  }
  if(theEvent.getController().getName()=="ports"){
    println("Setting port: " + Serial.list()[int(theEvent.getController().getValue())]);
    serialPortNumber = int(theEvent.getController().getValue());
  }
  if(theEvent.getController().getName()=="Start"){
    if(theEvent.getController().getValue()==1){
      String filename = p5.get(Textfield.class,"experiment").getText() +'-' + str(day()) + '-' + str(month()) + '-' + str(year()) + '_' + str(hour()) + str(minute()) + str(second()) +".csv";
      println("File :" + filename);
      output = createWriter(filename); 
      println("Starting data input");
      
      if (runSerial != true){
        p5.get(Toggle.class,"Start").setCaptionLabel("Stop");
        setSerialPort(serialPortNumber);
        runSerial = true;
      }
    }
    if(theEvent.getController().getValue()==0){
      if(runSerial != false){
       p5.get(Toggle.class,"Start").setCaptionLabel("Start");
       runSerial =false;
       output.flush();
       output.close();
       port.stop();
       println("Stop reading");
    }
  }
    }
}


void setSerialPort(int n)
{
  port = new Serial(this, Serial.list()[n],9600);
  port.bufferUntil('\n');
  delay(100);
}

void serialEvent(Serial port)
{
  String dataIn = port.readStringUntil('\n');
  if(dataIn!= null)
  {
    dataIn=trim(dataIn);
    output.println(dataIn);
    dataInChart = float(dataIn);
    if (runSerial == true) {
      chart.push("incoming",dataInChart);
  } else {
    }
  }
}
