1. 讲一下内存管理的关键字？strong 和 copy 的区别

   strong 是对指向对象引用计数+1操作，copy 则是进行拷贝操作，引用计数等于1；

2. NSString 用什么关键字？为什么

   用 copy 关键字，倘若某个 `NSMutableString` 对象赋值给 `NSString` 对象，然后在某个时刻，前者进行了 append，或者其他操作，都会引起指向对象内容变化

3. 深拷贝和浅拷贝

   浅拷贝就是指针拷贝，深copy就是另外分配一块内存，然后将原对象内容赋值到该内存上。

   不可变数组 copy 是浅拷贝，mutablecopy是深拷贝；可变数组 copy 和 mutablecopy 都是深拷贝；copy 方法返回的都是不可变对象；

   完全深copy 和单层深copy，数组可以使用 `- (instancetype)initWithArray:(NSArray<ObjectType> *)array copyItems:(BOOL)flag;` 进行完全深拷贝；

4. NSString使用copy关键字，内部是怎么实现的？string本身会copy吗？

   NSString 使用 copy 是进行了浅拷贝（指针拷贝），不会重新生成一个新的对象。因为原来的对象是不能修改的, 拷贝出来的对象也是不能修改的,既然两个都不能修改, 所以永远不能影响到另外一个对象,已经符合拷贝的目的 。所以，OC为了对内存进行优化, 就不会生成一个新的对象

5. 使用NSArray 保存weak对象，会有什么问题？

   NSArray  addObject 一个 weak 对象，内部会对weak对象进行 `retaincount +1` 操作，导致非预期情况发生。

   那么有时候，我们想将对象存储起来,但是不想让数组增加了这个对象的引用计数,这个时候，NSPointArray才是你想要的

   ```objective-c
   @property (nonatomic, strong) NSPointerArray  *pointerArray;
   
   self.pointerArray = [NSPointerArray weakObjectsPointerArray];
   
   - (void)addObject:(id)object {
       [self.pointerArray addPointer:(__bridge void *)(object)];
   }
    
   - (id)objectAtWeakMutableArrayIndex:(NSUInteger)index {
       return [self.pointerArray pointerAtIndex:index];
   }
   ```

   方法二：万事加一层，同样可以解决这个问题，比如搞一个 WeakObject 类，内部用 weak 属性封装，但是这种做法还是无法避免数组持有这个 weakObject 的问题。

   方法三：不想自己搞封装类，就是用 `+ (NSValue )valueWithPointer:(nullable const void *)pointer` 现有类；

6. 有没有用过MRC？怎么用MRC？

   `retain release autorelease, free/malloc/memset, CFRelease/CFRetain`

   规则：

   * **自己生成的对象，自己所持有， 用alloc/new/copy/mutablecopy 名称开头的方法创建的对象。**—>生成对象并持有所有权。
   * **非自己生成的对象，自己也能持有。用retain方法持有对象。一个对象可以被多个人持有** –>获取对象的所有权

   用`alloc/new/copy/mutablecopy` 名称以外开头的方法创建的对象，属于非自己生成并持有的对象。

   通过`alloc/new/copy/mutablecopy` 名称开头的方法创建的对象表示自己生成的对象自己所持有，这里不需要进行retain操作，ps: alloc 时候引用计数并未+1操作，但是返回+1，这个和底层retaincount设置了默认值有关系。

   ```objective-c
   - (id)allocObject
   {
     id obj = [[NSObject alloc]init];
     return obj;
   }
   
   // 这种外面必须retain操作，内部使用autorelease pool
   - (id)Object
   {
     id obj = [[NSObject alloc]init];
     [obj autorelease];
     return obj;
   }
   ```

   **在MRC情况下：**

   1. **如果一个方法以init或者copy开头，那么返回给你的对象的引用计数是1，并且这不是一个autorelease的对象。换句话说，你调用这些方法的话，你就对返回的对象负责，你再用完之后必须手动调用release来释放内存。**
   2. **如果一个方法不是以init或者copy开头的话,那么返回的对象引用计数为1，但是，这是一个autorelease对象。换句话说，你现在可以放心使用此对象，用完之后它会自动释放内存。但是，如果你想在其它地方使用它（比如换个函数），那么，这时，你就需要手动retain它了。（记得用完release）。**

   更多请点击[ARC/MRC使用一文](http://m6830098.github.io/2015/12/24/ARC-MRC使用/)。

7. MRC和ARC的区别？

   ARC 是 LLVM 和 Runtime 协作的结果，ARC 中禁止调用 retain/release/retainCount/dealloc方法，新增weak strong。MRC 是手动管理内存。

   简单地说，就是代码中自动加入了retain/release，原先需要手动添加的用来处理内存管理的引用计数的代码可以自动地由编译器完成了。ARC并不是GC，它只是一种代码静态分析（Static Analyzer）工具.比如如果不是 alloc/new/copy/mutableCopy 开头的函数，编译器会将生成的对象自动放入 autoReleasePool 中。如果是 __strong 修饰的变量，编译器会自动给其加上所有权。等等，详细，我们根据不同的关键字来看看编译器为我们具体做了什么。并从中总结出 ARC 的使用规则。

8. weak修饰的属性释放后会被变成nil，怎么实现的？

   全局的 SideTables，通过key-value，用指针获取到对应的SideTable，引用计数和weak表

   ```objective-c
   struct SideTable {
       spinlock_t slock;
       RefcountMap refcnts;
       weak_table_t weak_table;
   }
   
   struct weak_table_t {
       weak_entry_t *weak_entries;
       size_t    num_entries;
       uintptr_t mask;
       uintptr_t max_hash_displacement;
   };
   ```

   做成不同的SideTable，是为了提升效率，涉及到资源竞争，所以加锁，但是加锁又很耗时，如果只有一个全局表，那么不同线程都访问的话，效率极低，而现在就ok拉。

   `weak_entries` 保存了指向某个实例对象的 weak objects，因为存储的是 `referrers`，说白了就是指针的指针，在 dealloc 的时候会被置为 nil。

   ```objective-c
   // 1
   _objc_rootDealloc 
   
   // 2
   obj->rootDealloc() 
   
   // 3
   inline void
   objc_object::rootDealloc()
   {
       if (isTaggedPointer()) return;  // fixme necessary?
   
       if (fastpath(isa.nonpointer  &&  
                    !isa.weakly_referenced  &&  
                    !isa.has_assoc  &&  
                    !isa.has_cxx_dtor  &&  
                    !isa.has_sidetable_rc))
       {
           assert(!sidetable_present());
           free(this);
       } 
       else {
           object_dispose((id)this);
       }
   }
   
   // 4
   id 
   object_dispose(id obj)
   {
       if (!obj) return nil;
   
       objc_destructInstance(obj);    
       free(obj);
   
       return nil;
   }
   
   // 5
   void *objc_destructInstance(id obj) 
   {
       if (obj) {
           // Read all of the flags at once for performance.
           bool cxx = obj->hasCxxDtor();
           bool assoc = obj->hasAssociatedObjects();
   
           // This order is important.
           if (cxx) object_cxxDestruct(obj);
           if (assoc) _object_remove_assocations(obj);
           obj->clearDeallocating();
       }
   
       return obj;
   }
   
   // 6 
   inline void 
   objc_object::clearDeallocating()
   {
       if (slowpath(!isa.nonpointer)) {
           // Slow path for raw pointer isa.
           sidetable_clearDeallocating();
       }
       else if (slowpath(isa.weakly_referenced  ||  isa.has_sidetable_rc)) {
           // Slow path for non-pointer isa with weak refs and/or side table data.
           clearDeallocating_slow();
       }
   
       assert(!sidetable_present());
   }
   
   // 7
   void 
   objc_object::sidetable_clearDeallocating()
   {
       SideTable& table = SideTables()[this];
   
       // clear any weak table items
       // clear extra retain count and deallocating bit
       // (fixme warn or abort if extra retain count == 0 ?)
       table.lock();
       RefcountMap::iterator it = table.refcnts.find(this);
       if (it != table.refcnts.end()) {
           if (it->second & SIDE_TABLE_WEAKLY_REFERENCED) {
               weak_clear_no_lock(&table.weak_table, (id)this);
           }
           table.refcnts.erase(it);
       }
       table.unlock();
   }
   ```

   真的够深入。

9. KVC平时怎么用的？举个例子

10. KVC一定能修改readonly的变量吗？

11. KVC还有哪些用法？

12. keyPath怎么用的？

13. KVO的实现原理？

14. KVO使用时要注意什么？

15. KVO的观察者如果为weak，会有什么影响？

16. 如何实现多代理？

17. 给一个对象发消息，中间过程是怎样的？

18. 消息转发的几个阶段

19. 设计一个方案，在消息转发的阶段中统一处理掉找不到方法的这种crash

20. 如何实现高效绘制圆角

21. 异步绘制过程中，将生成的image赋值给contents的这种方式，会有什么问题？