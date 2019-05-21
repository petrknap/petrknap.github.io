---
layout: blueprint
---
# Short Payment Descriptor (SPayD) with QR output for PHP

It connects [shoptet/spayd-php] and [endroid/qr-code] to one unit.

## Example

```php
<?php

file_put_contents(
    'spayd_qr.png',
    PetrKnap\Php\SpaydQr\SpaydQr::create(
        'CZ7801000000000000000123',
        799.55,
        'CZK'
    )->getQrCodeContent(96)
);
```


{% include docs/how-to-install.md %}



[shoptet/spayd-php]:https://github.com/shoptet/spayd-php
[endroid/qr-code]:https://github.com/endroid/qr-code
