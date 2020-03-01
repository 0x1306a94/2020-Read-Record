title: "离屏渲染专题学习笔记"
date: 日期
tags: [标签]
categories: [分类]
keywords: 关键字
description: 简短描述。

<!--此处开始正文-->

## What is it?

### 1. 何为离屏渲染？

至少需要一块与屏幕像素数据量一样大小的 frame buffer(`width * height * pixelPerPoint`)，作为像素数据存储区域，这也是 GPU 存储渲染结果之地。但某些情况下图层合成过程较为负责，需要临时租用一块内存进行变换操作等，根据文献谈及一旦写入到 frame buffer 就不可逆，所以申请临时内存此刻是必要的，这个过程就是 GPU 的离屏渲染。

CPU 的离屏渲染： 正如 UIView 中的 drawRect 方法，系统会为view申请一块内存区域，所以也有“内存恶鬼”一说（有待考证），允许开发者在 drawRect 中利用 CoreGraphics 进行绘图操作，所有绘制内存都存储在 CGContext 画布中。CPU 进行的光栅化操作：文字渲染、图片解码，需要额外开辟一块内存，而非 GPU 分配的 frame buffer——文献说至多分配2.5个屏幕大小内容。 

### 2. 算法

>  ref 评论：现代GPU应该使用的是深度缓冲技术而不是画家算法。通过计算每个像素/片元的深度z值，z越小离观察者更近，此时会去更新颜色缓冲区，将对应坐标的值更新为当前像素/片元的颜色，同时更新深度缓冲区，同样将对应坐标的值更新为当前像素/片元的深度。

### 3. 为什么绘制带圆角并剪切圆角以外内容的容器会触发离屏渲染

如果只是设置 layer 的 cornerRadius，并不会触发离屏渲染，按照算法可一次性写入到 framebuffer 中，而其子视图后绘制会覆盖之前的内容：

```objective-c
UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
childView.backgroundColor = UIColor.redColor;
childView.layer.cornerRadius = 20;
[self.view addSubview:childView];
UIView *ccView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
ccView.backgroundColor = [UIColor greenColor];
[childView addSubview:ccView];
```

但是如果希望子视图内容不要出现在圆角之外区域，那么我们一般会加上 `childView.layer.masksToBounds = YES`，此刻就会触发离屏渲染。

> ref: 容器的子layer因为父容器有圆角，那么也会需要被裁剪，而这时它们还在渲染队列中排队，尚未被合成到同一块画布上，自然也无法统一裁剪。
>
> 疑问：倘若对每一层都应用圆角剪裁，是否也可以做到一次算法写入 frame buffer 呢？ 但是这明显会降低效率。最好的自然是先按照矩形区域一层层写入，然后统一来个剪裁。

### 4. 其他触发离屏渲染方式

> ref ：shadow，其原因在于，虽然layer本身是一块矩形区域，但是阴影的形状却未必是矩形，而是与layer中”非透明区域“的形状一致。这就意味着**需要先知道这个形状是什么样的（由layer与其所有子结构合成后所决定），阴影只能在这之后得到**。但矛盾的是，阴影需要显示在所有layer内容的下方，那么**根据画家算法，下层的阴影又必须先被渲染**。因为这个矛盾无法被调和，这样一来又只能另外申请一块内存，把本体内容都先画好，再根据渲染结果的形状，添加阴影到frame buffer，最后把内容画上去（这只是我的猜测，实际情况可能更复杂）。不过如果我们能够预先告诉CoreAnimation（通过shadowPath属性）阴影的几何形状，那么阴影当然可以先被独立渲染出来，不需要依赖layer本体，也就不再需要离屏渲染了。

**这个观点还是比较赞同的，阴影这东西如果我们可以明确，比如指定 shadowPath 绘制，那么就可以一次性写入frame buffer 中了，先通过 path 绘制阴影，然后是各个 layer 图形。**

>  ref ：group opacity，其实从名字就可以猜到，alpha并不是分别应用在每一层之上，而是只有到整个layer树画完之后，再统一加上alpha，最后和底下其他layer的像素进行合成。显然也无法通过一次遍历就得到最终结果。将一对蓝色和红色layer叠在一起，然后在父layer上设置opacity=0.5，并复制一份在旁边作对比。左边关闭group opacity，右边保持默认（从iOS7开始，如果没有显式指定，group opacity会默认打开），然后打开offscreen rendering的调试，我们会发现右边的那一组确实是离屏渲染了。

TODO：讲道理也能一次算法得到才对呀。



## How to use?

> ref : 离屏渲染某些情况下不可避免，但频繁地触发又影响性能，所以可尝试缓存。1秒60帧，一帧可能有十几个地方触发，雪球式地滚起来还是影响很大的，所以 CALayer 的 shouldRasterize 属性就是缓存于此。Render Server就会强制把layer的渲染结果（包括其子layer，以及圆角、阴影、group opacity等等）保存在一块内存中，这样一来在下一帧仍然可以被复用，而不会再次触发离屏渲染。有几个需要注意的点：

- shouldRasterize的主旨在于**降低性能损失，但总是至少会触发一次离屏渲染**。如果你的layer本来并不复杂，也没有圆角阴影等等，打开这个开关反而会增加一次不必要的离屏渲染
- 离屏渲染缓存有空间上限，最多不超过屏幕总像素的2.5倍大小
- 一旦缓存超过100ms没有被使用，会自动被丢弃
- layer的内容（包括子layer）必须是静态的，因为一旦发生变化（如resize，动画），之前辛苦处理得到的缓存就失效了。如果这件事频繁发生，我们就又回到了“每一帧都需要离屏渲染”的情景，而这正是开发者需要极力避免的。针对这种情况，Xcode提供了“Color Hits Green and Misses Red”的选项，帮助我们查看缓存的使用是否符合预期
- 其实除了解决多次离屏渲染的开销，shouldRasterize在另一个场景中也可以使用：如果layer的子结构非常复杂，渲染一次所需时间较长，同样可以打开这个开关，把layer绘制到一块缓存，然后在接下来复用这个结果，这样就不需要每次都重新绘制整个layer树了

借助 CPU 操作来实现圆角，比如 CoreGraphics 给图片加上圆角，整个过程发生在 CPU 阶段，甚至我们开子线程来进行圆角添加。将最后得到带圆角的视图提取出 image 赋值给 layer.content。

```objective-c
@implementation UIImage (RoundedCorder)
- (UIImage *)pt_drawRectWithRoundedCornerWithRadius:(CGFloat)radius
                                          sizeToFit:(CGSize)sizeToFit {
    CGRect rect = CGRectMake(0, 0, sizeToFit.width, sizeToFit.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());// 剪裁区域
    [self drawInRect:rect];
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return output;
}

@end

@implementation UIImageView (RoundedCorder)

- (void)pt_addCorner:(CGFloat)radius {
    self.image = [self.image pt_drawRectWithRoundedCornerWithRadius:radius sizeToFit:self.bounds.size];
}

@end

```

* CPU 利用 CoreGraphics 进行渲染占用一部分计算，且影响用户操作，但图形类的应用这个不可避免的会调用 CoreGraphics 接口吧，难道直接用 OpenGL ES 吗？
* CPU 渲染不够快，只适合渲染静态元素，如文字、图片；
* 作为渲染结果的bitmap数据量较大（形式上一般为解码后的UIImage），消耗内存较多，所以应该在使用完及时释放，并在需要的时候重新生成，否则很容易导致OOM

### 优化点

> ref 即刻的优化:

- 即刻大量应用AsyncDisplayKit(Texture)作为主要渲染框架，对于文字和图片的异步渲染操作交由框架来处理。关于这方面可以看我[之前的一些介绍](https://medium.com/jike-engineering/asyncdisplaykit介绍-一-6b871d29e005)
- 对于图片的圆角，统一采用“precomposite”的策略，也就是不经由容器来做剪切，而是预先使用CoreGraphics为图片裁剪圆角
- 对于视频的圆角，由于实时剪切非常消耗性能，我们会创建四个白色弧形的layer盖住四个角，从视觉上制造圆角的效果
- 对于view的圆形边框，如果没有backgroundColor，可以放心使用cornerRadius来做
- 对于所有的阴影，使用shadowPath来规避离屏渲染
- 对于特殊形状的view，使用layer mask并打开shouldRasterize来对渲染结果进行缓存
- 对于模糊效果，不采用系统提供的UIVisualEffect，而是另外实现模糊效果（CIGaussianBlur），并手动管理渲染结果

都是非常好的建议可尝试。

## Why like this?

## Summary

## Reference

* [关于离屏渲染的深入研究](https://medium.com/@jasonyuh/关于离屏渲染的深入研究-e776f56b3e60)























