# Git常见应用场景导航

[git思维导图-ProcessOn](https://www.processon.com/view/link/5c6e2755e4b03334b523ffc3#)

[如何优雅地使用Git？ - 知乎 (zhihu.com)](https://www.zhihu.com/question/20866683)





# 配置仓库的Commiter信息

> Git仓库需要配置作者的名字和邮箱，当我们在仓库Commit后，每一次的commit会关联配置的名字和邮箱，用来表示和追溯提交者的信息。
> 如果不配置名字和邮箱，Commit就不会包含作者和邮箱信息，这种Commit可能导致push到远程仓库时报错，因为不包含作者和邮箱信息或者邮箱不满足某种格式的Commit会被禁止推送到远程代码仓库，如企业版的Gitlab，Gitee，这些推送限制准则是公司的Git仓库管理员配置的。

可以在3个级别配置Git仓库的提交者信息: ① 系统 ② 全局 ③ 仓库。

优先级：仓库 > 全局 > 系统。

如果仓库内配置了，则使用仓库内配置，否则使用全局配置。如果全局也未配置，则使用系统配置。如果系统也未配置，那么commit时会不携带提交者的名字和邮箱。

- 系统配置：任何用户登录主机使用Git管理仓库，每个仓库都会继承系统配置

  ```shell
  git  config   --system  user.name     "LiuweiLi"
  git  config   --system   user.email   "typebyteforyou@gmail.com"
  ```

  系统配置存储路径是 `‪D:\Program Files\Git\etc\gitconfig` （git安装目录/etc/gitconfig）

- 全局配置：当前用户使用Git管理仓库，每个仓库都会继承全局配置

  ```shell
  git  config   --global   user.name     "LiuweiLi"
  git  config   --global   user.email    "typebyteforyou@gmail.com"
  ```

  全局配置存储路径是 `‪C:\Users\liliuwei\.gitconfig` （C:/users/用户/.gitconfig）

- 仓库内配置

  必须在当前仓库目录(.git同级目录)下打开Git Bash输入下面的命令

  ```shell
  git   config   --local   user.name    "LiuweiLi"
  git   config   --local   user.email   "typebyteforyou@gmail.com"
  ```

  仓库内配置存储路径: `.git/config` 

上面3种配置方式生成的用户和邮箱信息在存储文件的显示如下：

<img src="D:\OneDrive\mdimg\image-20230323153657459.png" alt="image-20230323153657459" style="zoom: 80%;" />

我们可以直接按照路径打开相应的配置文件查看当前配置或直接编辑文件(INI格式)进行配置。

---

**使用Visual Studio配置仓库作者名称和邮箱**

<img src="D:\OneDrive\mdimg\image-20230323154120672.png" alt="image-20230323154120672" style="zoom:67%;" />

<img src="D:\OneDrive\mdimg\image-20230323154134306.png" alt="image-20230323154134306" style="zoom: 67%;" />

---

**使用TortoiseGit配置仓库作者名称和邮箱**

<img src="D:\OneDrive\mdimg\image-20230323154500079.png" alt="image-20230323154500079" style="zoom: 50%;" />

---

**总结**

我们的电脑上有存储在Gitee上得公司的项目，也有自己的存储在Github上的开源项目，公司项目仓库和开源项目仓库要使用不同的作者信息（公司使用公司邮箱，开源项目使用个人邮箱），这时候我们需要单独设置仓库的作者信息，单独为仓库设置的信息会覆盖掉git全局设置的作者信息。

如果电脑上的所有仓库都未指定作者信息，那么这些仓库的作者信息全部来自全局设置或系统设置。

# 处理换行符

Windows 换行符 \r\n

Linux,Unix,Mac OS \n



# Git status -s --ignored

如何删除cache再生效gitignore

Git为什么发明暂存区

Git暂存区里面其实有很多文件，和commit一样，这些文件都是被追踪的。

理解git status的文件各种状态的含义，理解未被追踪和被修改，被删除的区别。

# 忽略有道

.gitignore标准模板参照：[github/gitignore: A collection of useful .gitignore templates](https://github.com/github/gitignore)

## 基础规则

.gitignore和.git放在同级目录下。

<img src="D:\OneDrive\mdimg\image-20230320023837678.png" alt="image-20230320023837678" style="zoom:50%;" />

.git同级目录的文件和文件夹才属于版本仓库的资料，推送到远程后，会创建个以仓库名同名的文件夹，包含这些文件和文件夹。

- 被忽略的文件和文件夹不会被git add，不会被追踪和加入版本库。

- 每条过滤规则占用一行

- 空行不匹配任何文件，因此常用作分隔符方便阅读

- #开头的行表示注释

- 路径分隔符统一使用 / ,不要使用 \ ，即使是Windows系统

- .gitignore的路径开头都是 / , 表示以.gitignore当前所在目录(顶级目录)为起点的相对路径。

  如 /bin   或  /UI 或 /app.config

- /bin和和/bin/的区别

  /bin会排除bin名称的文件和文件夹，/bin/只会排除bin名称的文件

- /bin和bin的区别

  /bin只会排除顶级目录下的bin，bin可能会排除多个bin，如/bin和/bin/x/bin

- \* 可以匹配任何字符（0次或多次），？可以匹配任意字符（1次），注意它们不能匹配 /

- 原先被排除的文件，使用!模式可以被重新包含，但是如果该文件的父级目录被排除了，即使使用!也不会再被包含进来。

- 通常用于匹配一个字符列表，如：a[mn]z可匹配amz和anz

- ** 用于匹配多级目录，如a/**/b可以匹配a/x/b和a/x/y/b

案例：

<img src="D:\OneDrive\mdimg\image-20230320030037424.png" alt="image-20230320030037424" style="zoom:80%;" />

忽略node_modules

```tex
/node_modules
```

忽略所有的json文件

```tex
/*.json
```

忽略所有内容

```tex
/*
```

忽略所有的目录

```tex
/*/
```

忽略public目录下的所有文件，除了favicon.ico

下面的写法不行，因为违背父级目录已经被排除

```tex
/public/
!/public/favicon.ico
```

下面的写法可以

```tex
/public/*
!/public/favicon.ico
```

只保留public目录下的所有a{一个字符}z.{后缀名}的所有文件

```tex
/public/*
!/public/a?z.*
```

## 检测生效

方法1

```tex
git check-ignore -v  文件或文件夹路径    ||如果文件或文件夹路径被忽略，会输出导致它被忽略的规则，否则什么也不会输出
```

方法2 

```tex
git status       被忽略的文件不会被显示状态
```

![image-20230320030804806](D:\OneDrive\mdimg\image-20230320030804806.png)