# LinearGradientBrush

StartPoint和EndPoint的坐标的取值范围是[0,1]，单位不是尺寸，而是LinearGradientBrush作用的控件的X和Y的占比。

假设我们将Grid的Background的值设置成LinearGradientBrush，Grid的尺寸是X=200,Y=500；StartPoint = "0.5,0.5",意味着StartPoint的坐标是(100,250)。

StartPoint与EndPoint构成一条直线，颜色沿着这条直线渐变。Offset的值的取值范围是[0,1]，Offset指在这条直线的占比。

## 示例一

```xaml
<LinearGradientBrush StartPoint="0,0.5" EndPoint="1,0.5">
    <GradientStop Offset="0.25" Color="Black"/>
    <GradientStop Offset="0.5" Color="Red"/>
    <GradientStop Offset="0.75" Color="Blue"/>
    <GradientStop Offset="1" Color="Green"/>
</LinearGradientBrush>
```

![渐变色.png](https://i.loli.net/2021/03/24/C7ZtnhrjWI51TBz.png)

## 示例二

![2021-03-24_004406.png](https://i.loli.net/2021/03/24/VqUw7TBnyv59sct.png)
