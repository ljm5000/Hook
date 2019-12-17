# Hook

### Hook 系统函数，目的是为了更好的分析内存
#### 前提：
 iOS的内存申请不全走 /VM_allocate /Malloc/ alloc 可以通过glTexture2D申请界面渲染的时候，里面回走驱动层来直接开辟内存，此时我们需要获取它的内存地址。

#### 原理：
通过各位大佬的分析，最后的出来一个结果在$\color{HotPink}{glTexture2D}$会走到系统私有函数 $\color{HotPink}{MTLIOAccelResource}$的,

.我这边的做法是 RunTime 来Hook 
$\color{HotPink}{initWithDevice:options:args:argsSize:}$
函数

#### 项目结构：
*  JMHook 包含：
 * JMHook.h (RuntTime hook)
 * JMHook.m
 * JMAllocateHook.mm (编译期 hook)
 * (google hook:fishook.h,fishook.m)

#### 使用方式：
直接把JMHook放入Target参与编译，即可看到结果。（切记，不能放到静态库里面编译）

#### 常见问题：
Runtime中的 objc_msg_send 参数对不上报错，
把target -> build prase >enable strice checking of objc_msg_send calls设为NO