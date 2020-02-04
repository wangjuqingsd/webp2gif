### What is this
基于github上[elsonwx/webp2gif](https://github.com/elsonwx/webp2gif)做了一些改动
网上保存一些动图总是发现是webp格式的，对他进行了一些研究，发现这货的一些项目应用案例和转换回gif图片的方式，在此做一下记录。这个程序需要你给她一个权限

```bash
chmod +x run.bash
```



### What can it do

将webp动态图片转gif

###What does it depends on ?

webpinfo,dwebp,convert.

webpinfo和dwebp是一家的，有谷歌文档支持[API在这](https://developers.google.cn/speed/webp/docs/api)，为什么这个格式出现了？相关文献引用如下：

> 与JPEG相同，WebP是一种有损压缩。但谷歌表示，这种格式的主要优势在于高效率。他们发现，“在质量相同的情况下，WebP格式图像的体积要比JPEG格式图像小40%。谷歌浏览器已经支持webp格式，Opera在版本号Opera11.10后也增加了支持，然而火狐和ie暂时还不支持webp格式，可以采用flash插件来显示webp，当然这样会耗费一些性能。
> 美中不足的是，WebP格式图像的编码时间“比JPEG格式图像长8倍

[相关项目应用的博客](https://www.jianshu.com/p/73ca9e8b986a)

Convert: 这货是imagemagick里面的一个组件，在linux下如果找不到convert命令需要去编译安装imagemagick来让他生效。他的作用也是处理图片。

[这货的API](http://www.imagemagick.org/script/convert.php)

### How it works

1. 首先利用```wepinfo```去获取webp文件的信息，检查他有多少个Frame（帧）。
2. 利用```dwebp```来将每一帧保存成一个png图片到临时文件夹里。
3. 然后利用convert将这一大坨png图片转换成gif文件。
4. 最后删除临时文件夹。

记录几个比较蛋疼的玩意

**mktemp临时文件（夹）**

>Usage: mktemp [OPTION]... [TEMPLATE]
>
>Create a temporary file or directory, safely, and print its name.
>TEMPLATE must contain at least 3 consecutive 'X's in last component.
>If TEMPLATE is not specified, use tmp.XXXXXXXXXX, and --tmpdir is implied.
>Files are created u+rw, and directories u+rwx, minus umask restrictions.
>
>**-d, --directory create a directory, not a file**
>-u, --dry-run do not create anything; merely print a name (unsafe)
>-q, --quiet suppress diagnostics about file/dir-creation failure
>--suffix=SUFF append SUFF to TEMPLATE; SUFF must not contain a slash.
>This option is implied if TEMPLATE does not end in X
>-p DIR, --tmpdir[=DIR] interpret TEMPLATE relative to DIR; if DIR is not
>specified, use \$TMPDIR if set, else /tmp. With
>this option, TEMPLATE must not be an absolute name;
>unlike with -t, TEMPLATE may contain slashes, but
>mktemp creates only the final component
>-t interpret TEMPLATE as a single file name component,
>relative to a directory: \$TMPDIR, if set; else the
>directory specified via -p; else /tmp [deprecated]
>--help display this help and exit
>--version output version information and exit

**wc计数**

> wc函数用法
>
>- -c或--bytes或--chars 只显示Bytes数。
>- -l或--lines 只显示行数。
>- -w或--words 只显示字数。
>- --help 在线帮助。
>- --version 显示版本信息。

**convert**

>几个参数 
>
>-delay 每一帧停顿几秒
>
>-loop 循环几次
>
>用哪些图片
>
>输出文件名

详细看上面的API

####这东西怎么用，去看下源码吧，里面我写注释了。

