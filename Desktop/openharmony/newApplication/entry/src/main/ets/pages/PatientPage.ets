import hilog from '@ohos.hilog';
import testNapi from 'libentry.so'
import router from '@ohos.router';


function getDate(){
  //三目运算符
  const Dates = new Date();
  //年份
  const Year : number = Dates.getFullYear();
  //月份下标是0-11
  const Months : any = Dates.getMonth()+1;
  //具体的天数
  const Day : any = Dates.getDate() < 10 ? '0' + Dates.getDate() : Dates.getDate();
  //小时
  const Hours = Dates.getHours() < 10 ? '0' + Dates.getHours() : Dates.getHours();
  //分钟
  const Minutes = Dates.getMinutes() < 10 ? '0' + Dates.getMinutes() : Dates.getMinutes();
  //秒
  const Seconds = Dates.getSeconds() < 10 ? '0' + Dates.getSeconds() : Dates.getSeconds();
  //返回数据格式
  return Year + '-' + Months + '-' + Day + '-' + Hours + ':' + Minutes + ':' + Seconds;
}


//病人类
class Record{
  time             //时间
  heartBeat        //心率
  temperature      //体温
  bloodOxygen      //血氧
  constructor(heartBeat:number,temperature:number,bloodOxygen:number){
    this.time=getDate()
    console.log("patient time"+this.time)

    this.heartBeat=heartBeat
    this.temperature=temperature
    this.bloodOxygen=bloodOxygen

  }
}
export default class Patient {
  public name
  public id
  public record: Array<Record> = new Array()
  constructor(name:string) {
    //创建
    this.name=name
    console.log("patient build"+name)
  }

  addRecord(heartBeat:number,temperature:number,bloodOxygen:number){
    //添加新的数据记录
    let tRecord=new Record(heartBeat,temperature,bloodOxygen)
    console.log("patient add record"+JSON.stringify(tRecord))

    this.record.push(tRecord)

  }
}




function onJmupClick(data:Patient) : void{
  router.pushUrl({
    url: 'pages/PatientDetailPage',
    params: data
  }),(err) => {
    if (err){
      console.error('invoke pushurl failed ,error code is ${err.code},error message is ${err.message}');
      return;
    }
    console.info('successful invoke')
  }
}





const patient1 = new Patient('alice')
patient1.addRecord(90,36.5,70)
patient1.addRecord(90,36.2,85)
patient1.addRecord(99,36.2,85)

const patient2 = new Patient('bob')
patient2.addRecord(87,36.5,70)
patient2.addRecord(92,36.2,92)
patient2.addRecord(96,36.9,94)

const patient3 = new Patient('chlie')
patient3.addRecord(94,36.1,82)
patient3.addRecord(93,36.8,87)
patient3.addRecord(92,36.0,86)
patient3.addRecord(112,36.3,110)


const patient4 = new Patient('rockey')
patient4.addRecord(92,36.1,82)
patient4.addRecord(99,36.8,87)
patient4.addRecord(97,36.0,86)
patient4.addRecord(114,36.3,110)





@Entry
@Component
struct PatientPage {

  scroller: Scroller = new Scroller();
  @State patient:Patient[] = [patient1,patient2,patient3]


  public additem():void{
    this.patient.push(patient4)
  }

  build() {
    Scroll(this.scroller) {
      Column() {
        Text('病人列表')
          .fontColor(0xFFFFFF)
          .textAlign(TextAlign.Center)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .width(375)
          .maxLines(2)
          .padding(10)
          .margin(0)
          .height(80)
          .backgroundColor(0x1e90ff)
        ForEach(this.patient, (item?:Patient|undefined) => {
          if(item){
            Button(item.name+'\t'+item.id,{ type: ButtonType.Normal, stateEffect: true })
              .fontSize(30)
              .width('90%')
              .height(150)
              .borderRadius(10)
              .fontColor(0x000000)
              .backgroundColor(0xFFFFFF)
              .borderRadius(15)
              .margin({ top: 10 })
              .onClick(()=>{
                onJmupClick(item)
              })
          }
        })

        Button('添加项目',{ type: ButtonType.Normal, stateEffect: true })
          .fontSize(20)
          .borderRadius(10)
          .onClick(()=>{
            this.additem()
          })

        Button('返回').onClick(() => {
          router.back()
        })

      }.width('100%')
    }
    .height(1000)
    .align(Alignment.Top)
    .backgroundColor(0xDCDCDC)
    .scrollable(ScrollDirection.Vertical) // 滚动方向纵向
    .scrollBar(BarState.On) // 滚动条常驻显示
    .scrollBarColor(Color.Gray) // 滚动条颜色
    .scrollBarWidth(10) // 滚动条宽度
    .edgeEffect(EdgeEffect.Spring) // 滚动到边沿后回弹
  }
}