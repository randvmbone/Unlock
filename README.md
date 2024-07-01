Unlock
=========

https://github.com/randvmbone/unlock

## Description

Unlock CoreStorage volumes during boot

## Why?

The CoreStorage User Agent (CSUserAgent) does not unlock CoreStorage volumes until a user has logged in. Consequently, CSUserAgent operates too late for the OpenZFS LaunchDaemon to import pools. These limitations prevent OpenZFS datasets from being automatically accessible after boot.

## Install

Run [this][install] in the terminal.

    curl -L https://raw.github.com/randvmbone/unlock/main/install.sh | bash

## Uninstall

Run [this][uninstall] in the terminal.

    curl -L https://raw.github.com/randvmbone/unlock/main/uninstall.sh | bash

## Problems?

If you have a problem, file a [bug report][issue] or fix it and submit a [pull request][pull].

[install]: https://raw.github.com/randvmbone/unlock/main/install.sh
[uninstall]: https://raw.github.com/randvmbone/unlock/main/uninstall.sh
[issue]: https://github.com/randvmbone/unlock/issues
[pull]: https://github.com/randvmbone/unlock/pulls
