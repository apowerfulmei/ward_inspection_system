import bluetoothManager from '@ohos.bluetoothManager';
import Logger from '../model/Logger'


class BlueManager{

  private static dmInstance: BlueManager = undefined;
  public gattServer:any
  static getInstance(): BlueManager {
    if (this.dmInstance == undefined) {
      this.dmInstance = new BlueManager();
    }
    return this.dmInstance;
  }

  constructor() {
    this.gattServer=bluetoothManager.BLE.createGattServer()

  }

  startDiscover(){
    // function onReceiveEvent(data: Array<bluetoothManager.ScanResult>) {
    //   console.info('BLE scan device find result = '+ JSON.stringify(data));
    // }
    try {
      bluetoothManager.BLE.on("BLEDeviceFind", (data)=>{
        console.info('BLE scan device find result = '+ JSON.stringify(data));
        console.log("BLE"+data[0].deviceId)
        var i = 0;
        var x = data[0].data[i]
        var y = data[0].data[i + 1]
        while(y!=0x09 && i+x+2<data[0].data.byteLength){
          i = i+x+1
          x = data[0].data[i]
          y = data[0].data[i+1]
        }

        let arr = data[0].data.slice(i+2,i+x+1)

        var BLEName = ""
        for(let j=0;j<arr.byteLength;j++){
          BLEName+=String.fromCharCode(arr[j])
        }
        console.log("BLE NAME"+BLEName)
        // BLEName=decodeURIComponent(BLEName)
        // console.log("BLE devicename "+BLEName)
      });

      let scanfilter: bluetoothManager.ScanFilter = {
        // deviceId:"XX:XX:XX:XX:XX:XX",



      };
      let scanoptions: bluetoothManager.ScanOptions = {


      }
      bluetoothManager.BLE.startBLEScan([scanfilter], scanoptions);
    } catch (err) {
      console.error("blue scan error")
    }
  }
  stopDiscover(){
    try {
      bluetoothManager.BLE.stopBLEScan();
    } catch (err) {
      console.error("blue scan error")
    }
  }

  startAdvertising(){
    let manufactureValueBuffer = new Uint8Array(4);
    manufactureValueBuffer[0] = 1;
    manufactureValueBuffer[1] = 2;
    manufactureValueBuffer[2] = 3;
    manufactureValueBuffer[3] = 4;

    let serviceValueBuffer = new Uint8Array(4);
    serviceValueBuffer[0] = 4;
    serviceValueBuffer[1] = 6;
    serviceValueBuffer[2] = 7;
    serviceValueBuffer[3] = 8;
    console.info('manufactureValueBuffer = '+ JSON.stringify(manufactureValueBuffer));
    console.info('serviceValueBuffer = '+ JSON.stringify(serviceValueBuffer));
    try {
      let setting: bluetoothManager.AdvertiseSetting = {
        interval:50,
        txPower:1,
        connectable:true,
      };
      let manufactureDataUnit: bluetoothManager.ManufactureData = {
        manufactureId:4567,
        manufactureValue:manufactureValueBuffer.buffer
      };
      let serviceDataUnit: bluetoothManager.ServiceData = {
        serviceUuid:"00001888-0000-1000-8000-00805f9b34fb",
        serviceValue:serviceValueBuffer.buffer
      };
      let advData: bluetoothManager.AdvertiseData = {
        serviceUuids:["00001888-0000-1000-8000-00805f9b34fb"],
        manufactureData:[manufactureDataUnit],
        serviceData:[serviceDataUnit],
      };
      let advResponse: bluetoothManager.AdvertiseData = {
        serviceUuids:["00001888-0000-1000-8000-00805f9b34fb"],
        manufactureData:[manufactureDataUnit],
        serviceData:[serviceDataUnit],
      };
      this.gattServer.startAdvertising(setting, advData ,advResponse);
    } catch (err) {
      console.error("errCode:");
    }
  }
}

export default BlueManager.getInstance()