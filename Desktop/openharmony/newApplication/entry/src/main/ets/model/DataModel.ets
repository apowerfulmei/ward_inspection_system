/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import distributedObject from '@ohos.data.distributedDataObject'
import Logger from './Logger'
import common from '@ohos.app.ability.common';

const random = (min:any,max:any) => Math.floor(Math.random() * (max - min + 1) + min)
const TAG: string = 'DistributedObjectModel'

class DistributedObjectModel {
  private static dmInstance: DistributedObjectModel= undefined;
  public distributedObject?:any
  public changeCallback?: () => void
  public statusCallback?: (sessionId: string, networkId: string, status: 'online' | 'offline') => void
  public deviceId:string=undefined
  public index:number

  constructor() {
    let context=getContext(this) as common.UIAbilityContext
    try{
      this.distributedObject = distributedObject.create(context,{
        //map<string(deviceID),bed(id and patient)>
        documents:[],
        msg:new Map(),
        size:0,
        name:'mky',
        heartBeat:0,
        temperature:0,
        bloodOxygen:0,
      })
      console.log("mkyy build success")
    }catch (error){
      console.log("mkyy"+error.toString())
    }

  }
  static getInstance(): DistributedObjectModel {
    if (this.dmInstance == undefined) {
      this.dmInstance = new DistributedObjectModel();
    }
    return this.dmInstance;
  }


  genSessionId() {
    return distributedObject.genSessionId()
  }

  setChangeCallback(changeCallback: () => void) {
    if (this.changeCallback === changeCallback) {
      Logger.info(TAG, 'same callback')
      return
    }
    Logger.info(TAG, 'start off')
    if (this.changeCallback !== undefined) {
      this.distributedObject.off('change', this.changeCallback)
    }
    this.changeCallback = changeCallback
    Logger.info(TAG, 'start watch change')
    this.distributedObject.on('change', this.changeCallback)
  }

  setStatusCallback(callback: (sessionId: string, networkId: string, status: 'online' | 'offline') => void) {
    if (this.statusCallback === callback) {
      Logger.info(TAG, 'same callback')
      return
    }
    Logger.info(TAG, 'start off')
    if (this.statusCallback !== undefined) {
      this.distributedObject.off('status', this.statusCallback)
    }
    this.statusCallback = callback
    Logger.info(TAG, 'start watch change')
    this.distributedObject.on('status', this.statusCallback)
  }
  findIndex(deviceId:string):number{
    //查找相关设备信息的Index
    var j
    let documents= this.distributedObject.documents
    for(j in documents){
      if(documents[j].deviceId==deviceId){
        Logger.info(TAG,"find deviceId "+deviceId+" in "+j)
        return j
      }
    }
    return -1;
  }
  add(deviceId:string){
    //将本设备数据加入到维护之中
    this.deviceId=deviceId
    this.index=this.distributedObject.size
    Logger.info(TAG,"add "+deviceId+" to place "+this.index)
    this.distributedObject.documents = [...this.distributedObject.documents,
      {
        deviceId:deviceId
      }]
    this.distributedObject.size++
    Logger.info(TAG, `add my documents,${JSON.stringify(this.distributedObject.documents)}`)

  }
  update(patientName:string,bedId:string,heartBeat:number,temperature:number,bloodOxygen:number) {

    // this.distributedObject.heartBeat=random(60,80)
    // this.distributedObject.bloodOxygen=random(70,100)
    // this.distributedObject.temperature=random(34,37)

    let documents = this.distributedObject.documents
    documents[this.index] = {
      deviceId:this.deviceId,
      patientName:patientName,
      bedId:bedId,
      heartBeat:heartBeat,
      temperature:temperature,
      bloodOxygen:bloodOxygen
    }
    this.distributedObject.documents = documents
    Logger.info(TAG, `update my documents,${JSON.stringify(this.distributedObject.documents)}`)

    Logger.info(TAG, `update my documents`)
  }



  clear() {
    Logger.info(TAG, 'doClear')
    this.distributedObject.documents = []
    this.distributedObject.documentSize = 0
    Logger.info(TAG, 'doClear finish')
  }

  off() {
    this.distributedObject.off('change')
    this.changeCallback = undefined
    this.distributedObject.off('status')
    this.statusCallback = undefined
  }
}

export default DistributedObjectModel.getInstance();