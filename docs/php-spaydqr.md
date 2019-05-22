---
layout: blueprint
---
# Short Payment Descriptor (SPayD) with QR output

It connects [shoptet/spayd-php] and [endroid/qr-code] to one unit.

## Example

```php
<?php

PetrKnap\Php\SpaydQr\SpaydQr::create(
    'CZ7801000000000000000123',
    Money\Money::CZK(79950)
)->writeFile('spayd_qr.png', 200);
```


{% include docs/how-to-install.md %}



[shoptet/spayd-php]:https://github.com/shoptet/spayd-php
[endroid/qr-code]:https://github.com/endroid/qr-code
