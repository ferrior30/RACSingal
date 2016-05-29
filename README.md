# ReactiveCocoa学习

## 主要的类
* RACSignal
  * 信号，abstract，抽象类，源信号或者说是信号源。
  * 有订阅信号的方法（因为实现了一个（subscription）分类）。
  * 没有发送信息的方法。
  * `重复订阅会重复执行didsubscribe`
  * 同一时间只有一个订阅，下一个会将前一个执行dispose（前一个没有自动执行的情况下）销毁掉。
* RACSubscriber协议
  * 用来发信号
* RACSubject
  * RACSignal的子类，可以发送信息和订阅信号（因为实现了RACSubscriber协议）
* RACReplaySubject
  * RACSubject的子类
  * replay：重放，重现，可以先发信号 再订阅，是个特例。
* RACDisposable
  * 当有信号订阅时就会生成RACDisposable.管理订阅（subscription）的相关必要信息。
* 注：那么当不想订阅信息时就应该disposable掉，释放资源。
* RACSubscriber协议 : `发送邮件`
* RACSubject ：`以上三者的结合。` 
  * `订阅前发送的信号内容收不到`
* RACReplaySubject： RACSubject的子灰；可以先订阅再发。
* RACDisposable： 订阅状态的追踪、记录。

```objc
//RACSubject情况下
* 收到信息直接就发送，不会保存。
// RACReplay情况下
* 收到信息会先保存起来，然后遍历订阅者去发送。当有一个新的订阅时，会先把保存的信息一次性发送给它。当信号销毁时才释放信息？
```  

## 信号创建、发送、`发送完毕`
* 发送基本过程
  * 创建信号
  * 订阅信号
  * 发送信息
  注： RACReplaySubject是个特例，可以先发再订。
* [signal sendCompleted]
  * 表明`发送完成`。
  * RACSuject调用[signal sendCompleted]
    * 只对它前面的订阅起作用。
    * 在它前面的订阅收不到它后面发送的信息。-> 前面的订阅是不是应该功成身退？
    * `调用后，订阅不变，后面的还是会加入`(为什么不把不起前面订阅干掉？见上）
  * RACReplaySuject调用[signal sendCompleted]
    * 信息还是会保存在数组中。
    * 对于在它前面的订阅：不能收到后面的信息
    * 对于后面的订阅，只能收到订阅的那一刻信息数组中保存的信息，后面加入的收不到了。
    * `调用后，订阅的个数不会变了`，是不是后面新的会替代前面旧？还是旧的不会加入？直接执行
  * 请合理调用，以释放资源。

#### RACSignal方式
* 在创建信号的block中发送信号

```objc

```
#### RACSubject方式
* 可以订阅信号
* 可以发送信号

### RACReplaySubject方式
`replay意思重放，能收到订阅前的信号`
* 把信号保存在数组，保存一个然后马上遍历订阅数组发送信号
* 总之就是来一个信号就发送给每一个订阅者。
* 与RACSubject区别
  * 可以先发送再订阅。


## 常见集合
* RACTuple : 元组，对应数组
* RACSequence ：有序的集合

## 信号与信号组合 
### RACMulticastConnection（不是信号）
* 信号发送信号
* 对信号发送的信号 进行订阅
  * [connect.signal subscribeNext:。。。】
  * 多次【connect connect】只有第一次执行有作用。意思开启连接，connect能拿到connect.signal订阅。
* 感觉作用就是：当信号发送信号时，利用MulticastConnection，可以建立连接快速找到发送的信号。（有个私有的sourceSignal，代表源信号，不过拿不到）
```objc
RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"创建信号内容");
        
        [subscriber sendNext:@"发送信号具体内容"];
        
        [subscriber sendCompleted];
        
      return [RACDisposable disposableWithBlock:^{
            NSLog(@"发送完成");
        }];
    }];
    
    RACMulticastConnection *connection = [signal publish];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"订阅者1 = %@",x);
    }];
    
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"订阅者2 = %@",x);
    }];
    [connection connect];
2016-05-27 07:37:56.559 连接类[26507:5623371] 创建信号内容
2016-05-27 07:37:56.560 连接类[26507:5623371] 订阅者1 = 发送信号具体内容
2016-05-27 07:37:56.560 连接类[26507:5623371] 订阅者2 = 发送信号具体内容
2016-05-27 07:37:56.560 连接类[26507:5623371] 发送完成

 RACSubject *subjectA = [RACSubject subject];
    RACSubject *subjectB = [RACSubject subject];
    RACMulticastConnection *connetAB = [subjectA multicast:subjectB];
    
    [connetAB.signal subscribeNext:^(id x) {
        NSLog(@"connect = %@", x);
    }];
    
    [(RACSubject *)connetAB.signal sendNext:@"B1"];
    
    [subjectB sendNext:@"B"];
 
    [connetAB connect];
2016-05-28 22:58:03.335 连接类[12033:1071400] connect = B1
2016-05-28 22:58:03.335 连接类[12033:1071400] connect = B
```
### concat 
* RACSignal *concat = [A concat：B]
* concat先订阅A，在A 执行sendComplete后才能订阅B。

```objc
- (void)concat {
//        RACSignal *signalOne = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            [subscriber sendNext:@"sendNest 1"];
//            // 不加上，concat就无法订阅signalTwo
//                    [subscriber sendCompleted];
//            return [RACDisposable disposableWithBlock:^{
////                NSLog(@"disposable");
//            }];
//        }];
    
    RACSubject *subjectA = [RACSubject subject];
   
    RACSignal *signalTwo = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"sendNest 2"];
        
        return [RACDisposable disposableWithBlock:^{
        }];
    }];
    
    RACSignal *concat = [subjectA concat:signalTwo];
    
    [subjectA sendNext:@"aaA"];
    
    [concat subscribeNext:^(id x) {
        NSLog(@"concat  %@",x);
    }];
        [subjectA sendNext:@"A"];
        // 执行这句才能收到B的信息
        [subjectA sendCompleted];
```

### then 
 *  RACSignal *then =  [subjectA then:^RACSignal *{ return subjectB}]
 *  只有信号subjectA接收到sendComplete,then:参数的block才会执行. then才可以订阅，成为B的其中一个订阅者，就会收到B发送的信号内容。（并不会订阅subjectA的）
 *  then实际上就是subjectB。
```
- (void)then {
    RACSubject *subjectA = [RACSubject subject];
    
    RACSubject *subjectB = [RACSubject subject];

    RACSignal *then =  [subjectA then:^RACSignal *{
        NSLog(@"then请求");
        return subjectB;
    }];
}
```

### merge
* [merge subscribeNext:^(id x)], 开始订阅A 和 B，能收到 A 或 B 信号内容。

### combineLatest 
* 任何一个有信号，就会把二个的最新信息合成后收到。

### zip
* A/B对应信息数组index位置同时有信息才接收触发next

## RACCommand
专门用来处理事件，多用于UI事件
* 信号发送信号


## 
