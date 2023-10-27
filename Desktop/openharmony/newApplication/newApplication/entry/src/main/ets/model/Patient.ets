
function getDate(){
  //三目运算符
  const Dates = new Date();
  //年份
  const Year : number = Dates.getFullYear();
  //月份下标是0-11
  const Months : any = Dates.getMonth();
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
export default class Patient{
  public name
  public id
  public record:Array<Record>=new Array()

  constructor(name:string) {
    //创建
    this.name=name
    console.log("patient build"+name)
  }
  changeName(newName:string) {
    //修改名字
    this.name = newName
  }

  addRecord(heartBeat:number,temperature:number,bloodOxygen:number){
    //添加新的数据记录
    let tRecord=new Record(heartBeat,temperature,bloodOxygen)
    console.log("patient add record"+JSON.stringify(tRecord))

    this.record.push(tRecord)

  }
  clearRecord(){
    //清除所有记录
    this.record=[]
    console.log("clear patient "+this.name+" record")
  }
}
