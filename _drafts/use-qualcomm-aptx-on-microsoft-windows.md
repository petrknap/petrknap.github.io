---
layout: blog.post
title: "Use Qualcomm #aptX on Microsoft #Windows"
category: software
keywords:
    - Qualcomm aptX
    - Microsoft Windows
    - Intel AC 9260
    - GIGABYTE GC-WB1733D-I
    - Haylou GT1 Plus
    - wireless audio
---

Do you like **good audio quality and wireless headphones**?
Then you need [Qualcomm aptX], but it's not that easy to have it on Microsoft Windows as it should be.

I found **compatible hardware and software** after a long research and some fails:
Bluetooth card [Intel AC 9260] as part of [GIGABYTE GC-WB1733D-I] and
compatible [audio driver for Intel AC 8260].


## How to install?

 1. **Let Windows to install drivers** from Windows Update service
 2. Extract [audio driver for Intel AC 8260]
 3. Install extracted `Intel Bluetooth Audio.msi`
 4. Pair compatible headphones or speakers, I used [Haylou GT1 Plus]
 5. Manually install missing A2DP driver via Device Manager from `%progrsmfiles(x86)%\Intel\HPWA\drivers\ibta2db.inf`

The last step is optional, do it only if system didn't do it automatically.
If everything is working **you will see**
**wireless headphones** or speakers with a microphone **as two devices** (hands-free + stereo) and
**true wireless headphones** or speakers with a microphone **as four devices** (2×hands-free + 2×stereo).

![aptX powered by Intel](/notes/data/2021-03-06/intel-aptx/you-are-now-using-aptx.png)

If everything works, reboot your computer.
Then you will see this notification and everything is done.



[Qualcomm aptX]:https://www.aptx.com/
[Intel AC 9260]:https://ark.intel.com/content/www/us/en/ark/products/99445/intel-wireless-ac-9260.html
[GIGABYTE GC-WB1733D-I]:https://www.gigabyte.com/eu/Motherboard/GC-WB1733D-I-rev-10
[audio driver for Intel AC 8260]:https://www.dell.com/support/home/cs-cz/drivers/driversdetails?driverid=100j9
[Haylou GT1 Plus]:https://www.haylou.com/en/index.php?ac=article&at=read&did=95
