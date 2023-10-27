// Index.ets
// 导入页面路由模块
//服务器端
import router from '@ohos.router';
import dataModel from '../model/DataModel'
import Patient from '../model/Patient'
import Logger from '../model/Logger'
import common from '@ohos.app.ability.common';
import remoteModel from '../model/ManagerModel'
import blueManager from '../model/Blue'
import bluetoothManager from '@ohos.bluetoothManager';
const random = (min:any,max:any) => Math.floor(Math.random() * (max - min + 1) + min)
@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  @State isInSession: boolean = false;
  @State heartBeat:number=0;
  @State temperature:number=0;
  @State bloodOxygen:number=0;
  @State patientName:string='梅开彦'
  @State bedId:string='10-1'
  @State patient:Patient=new Patient('梅开彦')
  @State isPositive:boolean=false
  @State bt:boolean=false
  @State targetDevice:string='hellomky'
  @State promise:number=undefined

  startAb(){
    dataModel.distributedObject.setSessionId('123456')
  }
  getByRandom(){
    //主动生成数据，主动模式下使用
    this.heartBeat=random(60,80)
    this.bloodOxygen=random(70,100)
    this.temperature=random(34,37)
  }
  getByRecv(){
    //被动获取数据，被动模式下使用
    let index=dataModel.findIndex(this.targetDevice)
    if(this.isInSession&&index!=-1)
    {
      let documents=dataModel.distributedObject.documents
      this.patientName=documents[index].patientName
      this.bedId=documents[index].bedId
      this.heartBeat=documents[index].heartBeat
      this.bloodOxygen=documents[index].bloodOxygen
      this.temperature=documents[index].temperature
    }

  }
  onPageShow(){


  }
  saveRecord(){
    try{
      this.patient.addRecord(this.heartBeat,this.temperature,this.bloodOxygen)
    }catch (error){
      console.log("bad happen"+error.toString())
    }
  }


  build() {
    Row() {
      Column() {
        Text("heartBeat: "+this.heartBeat)
        Text("temperature: "+this.temperature)
        Text("bloodOxygen: "+this.bloodOxygen)
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        // 添加按钮，以响应用户点击
        Button() {
          Text('Next')
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .width('40%')
        .height('5%')
        // 跳转按钮绑定onClick事件，点击时跳转到第二页
        .onClick(() => {
          console.info(`Succeeded in clicking the 'Next' button.`)

          // 跳转到第二页
          router.pushUrl({ url: 'pages/ListDevice' }).then(() => {
            console.info('Succeeded in jumping to the second page.')
          }).catch((err) => {
            console.error(`Failed to jump to the second page.Code is ${err.code}, message is ${err.message}`)
          })
        })
        Button() {
          Text('Save')
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .width('40%')
        .height('5%')
        .visibility(this.isPositive  ? Visibility.None : Visibility.Visible) //主动模式关闭，被动模式开启
        // 跳转按钮绑定onClick事件，点击时跳转到第二页
        .onClick(() => {
          this.saveRecord()

          })

        Toggle({ type: ToggleType.Switch, isOn: this.isInSession })
          .selectedColor('#007DFF')
          .switchPointColor('#FFFFFF')
          .onChange((isOn: boolean) => {
            console.info('Component status:' + isOn);
            this.isInSession = isOn;
            try{
              dataModel.distributedObject.setSessionId('123456')
            }catch(error){
              console.error("join session error")
            }

          })
        Row() {
          //设置主动被动模式
          Text("模式")
            .fontSize(16)
            .fontColor('#182431')
            .fontFamily('HarmonyHeiTi-Medium')
            .fontWeight(500)
          Blank()
          Toggle({ type: ToggleType.Switch, isOn: this.isPositive })
            .selectedColor('#007DFF')
            .switchPointColor('#FFFFFF')
            .onChange((isOn: boolean) => {
              Logger.info('Component status:' + isOn);
              this.isPositive = isOn;
              if (this.isPositive) {
                //开启主动模式
                console.log("start positive pattern")
                //添加数据维护段

                dataModel.add('hellomky')
                if(this.promise!=undefined) clearInterval(this.promise)
                this.promise=setInterval(()=>{
                  this.getByRandom()
                  dataModel.update(this.patientName,this.bedId,this.heartBeat,this.temperature,this.bloodOxygen)
                },1000)


              }else{
                //开启被动模式
                console.log("start passive pattern")
                if(this.promise!=undefined) clearInterval(this.promise)
                this.promise=setInterval(()=>{
                  this.getByRecv()
                },100)
              }
            })
        }.width('100%')
        .height(48)



        Row() {
          //设置主动被动模式
          Text("蓝牙启动")
            .fontSize(16)
            .fontColor('#182431')
            .fontFamily('HarmonyHeiTi-Medium')
            .fontWeight(500)
          Blank()
          Toggle({ type: ToggleType.Switch, isOn: this.bt })
            .selectedColor('#007DFF')
            .switchPointColor('#FFFFFF')
            .onChange((isOn: boolean) => {
              Logger.info('Component status:' + isOn);
              this.bt = isOn;
              if (this.bt) {
                //开启蓝牙
                blueManager.startDiscover()
                blueManager.startAdvertising()



              }else{
                //开启被动模式
                blueManager.stopDiscover()


              }
            })
        }.width('100%')
        .height(48)
      }
      .width('100%')
    }
    .height('100%')
  }
}
