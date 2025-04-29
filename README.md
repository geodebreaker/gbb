# GBB overwriter for enrolled chromebooks

**UNTESTED:** needs testing.

after downloading the script (gbb.sh), follow [this tutorial](https://docs.mrchromebox.tech/docs/support/unbricking/unbrick-ch341a.html) until step 6, then run

```bash
chmod +x gbb.sh
./gbb.sh ch341a_spi
```

afterwards, reassemble your chromebook and [follow dev mode steps](https://www.chromium.org/chromium-os/developer-library/guides/device/developer-mode/#enable-developer-mode)<br>
or you could use a thumbdrive with an old version of chromeos to use different exploits

works on Linux, may work on WSL
