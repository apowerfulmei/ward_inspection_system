import router from '@ohos.router';
import hilog from '@ohos.hilog';
import Record from '../pages/PatientPage'
import Patient from '../pages/PatientPage';



const params = router.getParams()
const name = params['name']
const id = params['id']
const record = params['record']


@Entry
@Component
struct PatientDetail {
  scroller: Scroller = new Scroller();
  @State message: string = 'Hello CRK'
  build() {
    Scroll(this.scroller) {
      Column() {
        // Text('hello, world')
        //   .fontSize(30)
        //   .fontWeight(FontWeight.Bold)
        //   .width('100%')
        //   .padding({top: 10})
        Text('病人详细信息')
          .textAlign(TextAlign.Center)
          .fontColor(0xFFFFFF)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .width(375)
          .maxLines(2)
          .padding(10)
          .margin(0)
          .height(80)
          .backgroundColor(0x1e90ff)


        Text('姓名:'+ name)
          .fontSize(30)
          .fontColor(0x000000)
          .width('90%')
          .textAlign(TextAlign.Start)
          .height(50)


        Text('病号:' + id)
          .fontSize(30)
          .fontColor(0x000000)
          .width('90%')
          .textAlign(TextAlign.Start)

        ForEach(record, (item?:Record|undefined) => {
          if(item){
            Divider().strokeWidth(5)
            Text('时间：' + item['time'].toString())
              .fontSize(20)
              .width('90%')
              .height(50)
              .fontColor(0x000000)
              .backgroundColor(0xDCDCDC)


            Text('心率：' + item['heartBeat'].toString())
              .fontSize(20)
              .width('90%')
              .height(50)
              .fontColor(0x000000)
              .backgroundColor(0xDCDCDC)


            Text('血氧：' + item['bloodOxygen'].toString())
              .fontSize(20)
              .width('90%')
              .height(50)
              .fontColor(0x000000)
              .backgroundColor(0xDCDCDC)



          }
        })





        // Text(this.message)
        //   .fontSize(50)
        //   .fontWeight(FontWeight.Bold)
        // Text(this.message)
        //   .fontSize(50)
        //   .fontWeight(FontWeight.Bold)
        // Text(this.message)
        //   .fontSize(50)
        //   .fontWeight(FontWeight.Bold)
        // Text(this.message)
        //   .fontSize(50)
        //   .fontWeight(FontWeight.Bold)

        Button('返回').onClick(() => {
          router.back()
        })
      }
      .width('100%')
    }
    // .height('100%')
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