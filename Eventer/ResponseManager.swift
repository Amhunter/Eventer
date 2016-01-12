//
//  ResponseButtonsView.swift
//  Eventer
//
//  Created by Grisha on 14/06/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

protocol ResponseViewDelegate{
    func didGetNumberOfResponses(numberOfObjects:[String:UInt], error:NSError!)
    func didFinishSavingOrDeletingResponse(visualnumberOfObjects:[String:UInt], error:NSError!)
    
}
class ResponseManager: UIView {
    var delegate:ResponseViewDelegate! = nil

    var buttons =
    [
        "yes": ResponseButton(),
        "no": ResponseButton(),
        "maybe": ResponseButton()
    ]
    
    var attempts:Int = 0 //attempts to save or delete

    
    var event:FetchedEvent!
    
    var localResponse:String = "" // what buttons show
    var actualResponse:String = "" // what's actually in the database
    var actualResponseObject:ActivityUnit!
    
    var numberOfActivity:[String:UInt] =
    [
        "yes": 0,
        "maybe": 0,
        "no": 0
    ]

    var isBusy:Bool = false // if processing a query
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    init(){
        super.init(frame: CGRectZero)
    }
    func initialize(forEvent:FetchedEvent){
        self.addSubview(buttons["yes"]!)
        self.addSubview(buttons["maybe"]!)
        self.addSubview(buttons["no"]!)
        
        buttons["yes"]?.translatesAutoresizingMaskIntoConstraints = false
        buttons["maybe"]?.translatesAutoresizingMaskIntoConstraints = false
        buttons["no"]?.translatesAutoresizingMaskIntoConstraints = false
        
        let H_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[yes]-15-[maybe]-15-[no]-5-|", options: [], metrics: nil, views: buttons)
        //equalize widths
        let H_Constraint1 = NSLayoutConstraint(item: buttons["yes"]!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: buttons["maybe"]!, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        let H_Constraint2 = NSLayoutConstraint(item: buttons["maybe"]!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: buttons["no"]!, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        
        let V_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[yes]-5-|", options: [], metrics: nil, views: buttons)
        let V_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[maybe]-5-|", options: [], metrics: nil, views: buttons)
        let V_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[no]-5-|", options: [], metrics: nil, views: buttons)

        self.addConstraints(H_Constraint0)
        self.addConstraint(H_Constraint1)
        self.addConstraint(H_Constraint2)
        self.addConstraints(V_Constraint0)
        self.addConstraints(V_Constraint1)
        self.addConstraints(V_Constraint2)
        
        self.event = forEvent
        
        buttons["yes"]!.content = "yes"
        buttons["maybe"]!.content = "maybe"
        buttons["no"]!.content = "no"
        
        for cont in Array(self.buttons.keys){
            let content:String = cont
            buttons[content]?.addTarget(self, action: "Response:", forControlEvents: UIControlEvents.TouchUpInside)

        }
    }
    
    
    
    
//    func Get_Number_Of_Responses(){
//        println("Get_Likes")
//        //sBusy = true
//        //check if I liked it or not
//        
//        
//        let store = KCSLinkedAppdataStore.storeWithOptions([
//            KCSStoreKeyCollectionName : "Activity",
//            KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
//            ])
//        
//        var query:KCSQuery = KCSQuery()
//        query.addQueryOnField("type", withExactMatchForValue: "response")
//        query.addQueryOnField("eventAuthor._id", withExactMatchForValue: self.event!.creatorID)
//        query.addQueryOnField("fromUser._id", withExactMatchForValue: KCSUser.activeUser().userId)
//        query.addQueryOnField("event._id", withExactMatchForValue: self.event!.eventOriginal!.entityId!)
//        store.queryWithQuery(query, withCompletionBlock: {
//            (objects:[AnyObject]!, error:NSError!) -> Void in
//            if (error == nil){
//                // get response
//                if (objects.count > 1){ // exception detected
//                    self.actualResponseObject = objects[0] as! ActivityUnit
//                    
//                    // deleting excessive components
//                    var objectsToRemove = objects
//                    objectsToRemove.removeRange(Range(start: 1, end: objects.count-1))
//                    println("more than one response detected, fixing...")
//                    
//                    var idsToRemove:NSMutableArray = NSMutableArray()
//                    for obj in objectsToRemove{
//                        idsToRemove.addObject((obj as! ActivityUnit).entityId!)
//                    }
//                        
//                    store.removeObject(NSArray(array: idsToRemove), withCompletionBlock: {
//                        (number:UInt, error:NSError!) -> Void in
//                        if (error == nil){
//                            println("fixed")
//                        }else{
//                            println("couldnt fix")
//                        }
//                    }, withProgressBlock: nil)
//                    
//                }else if (objects.count == 1){
//                    self.actualResponseObject = objects[0] as! ActivityUnit
//                    self.actualResponse = self.actualResponseObject.content as! String
//                }else{
//                    self.actualResponse = "none"
//                }
//                //println(self.actualResponse)
//                
//                // update buttons state
//                
//                self.initialResponse = self.actualResponse
//                self.localResponse = self.actualResponse
//                
//                self.Display_Changes()
//                var subquery:KCSQuery = KCSQuery()
//                subquery.addQueryOnField("type", withExactMatchForValue: "response")
//                subquery.addQueryOnField("event._id", withExactMatchForValue: self.event!.eventOriginal!.entityId)
//                
//                // find all responses and group them for counting
//                store.group("content", reduce: KCSReduceFunction.COUNT(), condition: subquery, completionBlock: {
//                    (group:KCSGroup!, error:NSError!) -> Void in
//                    if (error == nil){
//                        for cont in self.buttons.keys.array{
//                            let content:String = cont
//                            // get number of responses , 9223372036854775807 is a wrong value
//
//                            var number = group.reducedValueForFields(["content" : content]).integerValue
//                            if (number == NSNotFound){
//                                number = 0
//                            }
//                            self.numberOfActivity[content] = UInt(number)
//                        }
//                        
//                        self.delegate.didGetNumberOfResponses(self.numberOfActivity, error: nil)
//                    }else{
//                        self.delegate.didGetNumberOfResponses(self.numberOfActivity, error: error)
//                        println("Error:" + error.description)
//                    }
//                }, progressBlock: nil)
//            }else{
//                println("Error:" + error.description)
//            }
//        }, withProgressBlock: nil)
//    }

    func Response(sender:ResponseButton){
        let content = sender.content as String
        if (isBusy){ //just visual change
            if (self.localResponse == sender.content){
                self.localResponse = ""
            }else{
                self.localResponse = content
            }
            Display_Changes()
        }else{
            Save_Response(content,buttonWasPressed: true)
        }
    }

    func Save_Response(content:String, buttonWasPressed:Bool){
        isBusy = true
        
        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Activity",
            KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
            ])
        
        let query:KCSQuery = KCSQuery()
        query.addQueryOnField("type", withExactMatchForValue: "response")
        query.addQueryOnField("event._id", withExactMatchForValue: self.event!.entityID)
        query.addQueryOnField("toUser._id", withExactMatchForValue: self.event!.authorId)
        query.addQueryOnField("fromUser._id", withExactMatchForValue: KCSUser.activeUser().userId)
        
        //  in case if we need to store or remove
        let response:ActivityUnit = ActivityUnit()

        
        
        response.entityId = "r-\(KCSUser.activeUser().userId!)-\(event.eventOriginal!.entityId!)"
        if (KCSUser.activeUser().userId == event.metadata!.creatorId()){
            response.addit = "s"
        }
        response.event = self.event!.eventOriginal
        response.fromUser = KCSUser.activeUser()
        response.type = "response"
        response.content = content
        let toUser = KCSUser()
        toUser.userId = self.event!.authorId as String
        response.toUser = toUser
        
        //  visual check
        if (self.localResponse != content){  // visually you havent given response it yet
            self.localResponse = content
            
            if buttonWasPressed {
                self.Display_Changes()
            }
            
            //update
            //response.content = content
            
            store.saveObject(response, withCompletionBlock: { //save 1
                (objects:[AnyObject]!, error:NSError!) -> Void in
                if (error == nil){
                    print("saved \(content)")
                    self.actualResponseObject = objects[0] as! ActivityUnit

                    self.actualResponse = content
                    self.checkIfVisualValueMatchesActualValue()
                    
                }else{
                    print("Error: " + error.description)
                    self.checkIfVisualValueMatchesActualValue()
                    
                }
            }, withProgressBlock: nil)
        }else{ // to unlike

            // visual unlike
            self.localResponse = ""
            if buttonWasPressed {
                self.Display_Changes()
            }
            
            store.removeObject(response.entityId, withCompletionBlock: {
                (number:UInt, error:NSError!) -> Void in
                if (error == nil){
                    
                    print("deleted")
                    self.actualResponse = ""
                    self.checkIfVisualValueMatchesActualValue()
                    
                }else{
                    if error.code == 404 {
                        self.actualResponse = ""
                    }
                    print("Error: " + error.description)
                    self.checkIfVisualValueMatchesActualValue()

                }
            }, withProgressBlock: nil)

        }
    }
    
    func getResponses(inout event:FetchedEvent, handler: (goingNumber:Int,maybeNumber:Int,invitedNumber:Int,yourResponse:String!,error:NSError!) -> Void){
        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Activity",
            KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
            ])
        
        let query = KCSQuery(onField: "event._id", withExactMatchForValue: event.eventOriginal.entityId)
        query.addQueryOnField("type", withExactMatchForValue: "response")
        var goingNumber = 0
        var maybeNumber = 0
        var invitedNumber = 0
        var myResponse:String?
        var responsesLoaded:Bool = false
        var myresponseLoaded:Bool = false
        var Done:Bool = false
        
        store.group(["event._id","content"], reduce: KCSReduceFunction.COUNT(), condition: query, completionBlock: {
            (group:KCSGroup!, error:NSError!) -> Void in
            if (error == nil){

                
                    goingNumber = (group.reducedValueForFields(["event._id" : event.eventOriginal!.entityId! ,"content" : "yes"]).integerValue)
                    if (goingNumber == NSNotFound) { goingNumber = 0 }
                    
                    maybeNumber = group.reducedValueForFields(["event._id" : event.eventOriginal!.entityId!, "content" : "maybe"]).integerValue
                    if (maybeNumber == NSNotFound) { maybeNumber = 0 }
                
                    invitedNumber = group.reducedValueForFields(["event._id" : event.eventOriginal!.entityId!, "content" : "invite"]).integerValue
                    if (invitedNumber  == NSNotFound) { invitedNumber  = 0 }
            
                    event.additionalDataDownloaded = true
                    
                
                
                if (myresponseLoaded && !Done){
                    Done = true
                    handler(goingNumber: goingNumber, maybeNumber: maybeNumber, invitedNumber: invitedNumber, yourResponse: myResponse!,error: nil)
                }
                responsesLoaded = true
            }else{
                handler(goingNumber: 0, maybeNumber: 0, invitedNumber: 0, yourResponse: nil, error: error)
            }
        }, progressBlock: nil)
        
        store.loadObjectWithID("r-\(KCSUser.activeUser().userId!)-\(event.eventOriginal!.entityId!)", withCompletionBlock: {
            (objects:[AnyObject]!, error:NSError!) -> Void in
            if error == nil {
                if objects.count > 0 {
                    let response = FetchedActivityUnit(fromUnit: objects[0] as! ActivityUnit)
                    myResponse = response.content as String
                }else{
                    myResponse = nil
                }
                if (responsesLoaded && !Done){
                    Done = true
                    handler(goingNumber: goingNumber, maybeNumber: maybeNumber, invitedNumber: invitedNumber, yourResponse: myResponse!,error: nil)
                }
                myresponseLoaded = true

            }else{
                myResponse = ""
                if (responsesLoaded && !Done){
                    Done = true
                    handler(goingNumber: goingNumber, maybeNumber: maybeNumber, invitedNumber: invitedNumber, yourResponse: myResponse!,error: nil)
                }
                myresponseLoaded = true

            }
        }, withProgressBlock: nil)
        
    }
    
    
    func Display_Changes(){
//        var tempDict:[String:UInt] =
//        [
//            "yes": 0,
//            "maybe": 0,
//            "no": 0
//        ]
        for cont in Array(self.buttons.keys){
            let content:String = cont
            
            if (content == localResponse){
                buttons[content]?.setActive(true)

            }else{
                buttons[content]?.setActive(false)

            }
        }
        //delegate.didFinishSavingOrDeletingResponse(tempDict, error: nil)

    }


    func checkIfVisualValueMatchesActualValue(){
        if (actualResponse != localResponse){
            self.localResponse = actualResponse

            if (attempts>0){
                attempts = 0
                isBusy = false
                print("_____________________stop trying___________________")
                Display_Changes()
            }else{
                attempts++
                print("_____________________try again_____________________")
                Save_Response(actualResponse, buttonWasPressed: false)
            }
            
            
        }else{
            attempts = 0
            isBusy = false
        }
    }
    
    
    
    
    
}
