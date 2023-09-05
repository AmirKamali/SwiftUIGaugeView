# SwiftUIGaugeView

SwiftUIGaugeView is a super lightweight SwiftUI View that allows you to add a nice looking Gauge to your app. The usage is simple and supports animation as well.

## Using SwiftUIGaugeView

Using is very simple and has most of the values you need. 

```swift
        GaugeView(
            numberOfTicks: 40,
            startAngle: -110,
            stopAngle: 110,
            minValue: 0,
            maxValue: 100,
            selectedValue: 75,
            animationDuration: 2.0
        )
        .frame(width: 500, height: 500)
```

## Roadmap

The codes needs some clean up to allow states to be passed as well. PRs are welcome!



![Alt text](resources/screenshot.png?raw=true "Example of the SwiftUIGaugeView")

## Apps using SwiftUIGaugeView

If you use this code in your app, please let me know and I'd love to highlight your project here. you can find me @amirmc3 on twitter