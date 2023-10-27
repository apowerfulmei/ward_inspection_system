

const random = (min:any,max:any) => Math.floor(Math.random() * (max - min + 1) + min)
const TIME_GAP=1000


class DataBuild {
  private static dmInstance:DataBuild=undefined;

  work :boolean=false;
  heartBeat:number=0;
  temperature:number=0;
  bloodOxygen:number=0;
  patientName:string='mky';

  //machineID:string;
  timePromise : any;
  static getInstance() {

    if(this.dmInstance == undefined){
      this.dmInstance=new DataBuild();
    }
    return this.dmInstance;
  }
  changeStatus():void{
    //change the working status
    if(this.work==false){
      this.work=true;
      console.log('time start')
      this.timePromise=setInterval(()=>{
        this.dataBuild()
      },TIME_GAP);
    }
    else{
      this.work=false;
      clearInterval(this.timePromise);
    }
  }
  changeName(name:string):void{
    //change the patient name
    console.log("change patient name to"+name);
    this.patientName=name;
  }

  dataBuild():void {
    //change the data
    this.heartBeat=random(60,90);
    this.temperature=random(35,40);
    this.bloodOxygen=random(80,100);


  }

  dataGet():{patientName:string,heartBeat:number,temperature:number,bloodOxygen:number}{
    let ret={
      patientName:this.patientName,
      heartBeat:this.heartBeat,
      temperature:this.temperature,
      bloodOxygen:this.bloodOxygen
    };
    return ret;
  }


}
export default DataBuild.getInstance();