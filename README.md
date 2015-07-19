> _Wahoo_: The [Fishshell][fishshell] Framework

[![][travis-logo]][travis] ![](https://img.shields.io/badge/Wahoo-Framework-00b0ff.svg?style=flat-square)
![](https://img.shields.io/badge/License-MIT-707070.svg?style=flat-square)

<a name="wahoo"></a>

<br>

<p align="center">
  <a href="https://github.com/fish-shell/wahoo/blob/master/README.md">
  <img width="35%" src="https://cloud.githubusercontent.com/assets/8317250/7772540/c6929db6-00d9-11e5-86bc-4f65533243e9.png">
  </a>
</p>

<br>

<p align="center">
<b><a href="#about">About</a></b>
|
<b><a href="#install">Install</a></b>
|
<b><a href="#getting-started">Getting Started</a></b>
|
<b><a href="#advanced">Advanced</a></b>
|
<b><a href="https://github.com/fish-shell/wahoo/wiki/Screencasts">Screencasts</a></b>
|
<b><a href="/CONTRIBUTING.md">Contributing</a></b>

  <p align="center">
    <a href="https://gitter.im/fish-shell/wahoo?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge">
      <img src="https://badges.gitter.im/Join%20Chat.svg">
    </a>
  </p>
</p>

<br>

# About

_Wahoo_ is an all-purpose framework and package manager for the [fishshell][Fishshell]. It looks after your configuration and packages. It's lightining fast and easy to use.

Wahoo only keeps a URL registry of packages, if you want to contribute please [fork and send us a PR](https://github.com/fish-shell/wahoo/fork).

# Install

```sh
curl -L git.io/wa | sh
wa help
```

Or download and run it yourself:

```sh
curl -L git.io/wa > install
chmod +x install
./install
```


### `sudo`?

No need to `sudo` if you already have `fish`, but if you are starting from scratch you need to `sudo` in order to change your default shell.

# Getting Started

Wahoo includes a small utility `wa` to fetch and install new packages and themes.

## `wa update`

Update framework and installed packages.

> *Note*: Unstaged changes are [stashed](https://git-scm.com/book/no-nb/v1/Git-Tools-Stashing) and reapplied after pulling updates from upstream. Committed changes are [rebased](https://git-scm.com/book/en/v2/Git-Branching-Rebasing) with master.

## `wa get` _`<package> ...`_

Install one _or more_ themes or packages. To list available packages type `wa use`.

> You can fetch packages via URL as well `wa get URL`

## `wa list`

List only _installed_ packages.

> To list packages available for download use `wa get`.

## `wa use` _`<theme>`_

Apply a theme. To list available themes type `wa use`.

## `wa remove` _`<package>`_

Remove a theme or package.

> Packages subscribed to `uninstall_<pkg>` events are notified before the package is removed to allow custom cleanup of resources. See [Uninstall](#uninstall).

## `wa new pkg | theme` _`<name>`_

Scaffold out a new package or theme.

> This creates a new directory under `$WAHOO_CUSTOM/[pkg|themes]/` and adds a starting template.

## `wa submit` _`pkg/<name>`_ _`[<url>]`_

> _Note:_ The following commands only update your local copy of Wahoo. Please [send us a PR][wahoo-pulls-link] to update the global registry.

Add a new package. To add a theme use `wa submit` _`themes/<name>`_ _`<url>`_

## `wa query` _`<variable name>`_

Use `wa query` to inspect all session variables. Useful to pretty dump _path_ variables like `$fish_function_path`, `$fish_complete_path`, `$PATH`, etc.

## `wa destroy`

Uninstall _Wahoo_. See [uninstall](#uninstall) for more information.

# Advanced

> Hoot! Ho, brave sir or madam, on your quest to wake the dreamer! Read on if you wish to learn more about Wahoo's internals.

+ [Bootstrap](#bootstrap-process)
+ [Core Library](#core-library)
+ [Packages](#packages)
  + [Names](#package-names)
  + [Submitting](#submitting)
  + [Directory Structure](#package-directory-structure)
  + [Initialization](#initialization)
  + [Ignoring Packages](#ignoring)
+ [Uninstall](#uninstall)

## Bootstrap Process

Wahoo's bootstrap script installs `git` (`fish` if not installed), switches your default shell and modifies `$HOME/.config/fish/config.fish` to load the Wahoo `init.fish` script at the start of a shell session.

It also extends the `fish_function_path` to autoload Wahoo's core library under `$WAHOO_PATH/lib` and the `$WAHOO_PATH/pkg` directory.

## `init.fish`

Autoloads Wahoo's packages, themes and _custom_ path (in that order), loading any `<package>.fish` files if available. If successful, emits an `init_<package>` event for each package. See [Initialization](#initialization).

Also autoloads any `functions` directory and sources `init.fish` under the _custom_ path if available.

The _custom_ path, `$HOME/.dotfiles` by default, is defined in `$WAHOO_CUSTOM` and set in `$HOME/.config/fish/config.fish`. You can modify this to your own preferred path.

## Core library

The core library is a minimum set of basic utility functions that extend your shell.

### `autoload`

Modify the `$fish_function_path` and autoload functions and/or completions.

```fish
autoload "mypkg/utils" "mypkg/core" "mypkg/lib/completions"
```

### `refresh`

Short for `exec fish < /dev/tty` causing the fish session to restart.


### `git` functions

See [documentation](/lib/git/README.md).


## Packages

Packages are kept under `$WAHOO_PATH/pkg` and themes under `$WAHOO_PATH/themes`.

### Package Names

A package name may only contain lowercase letters and hyphens to separate words.

### Submitting

Run `wa submit <name> <url>` inside the package or theme directory.

### Package Directory Structure

_Directory Structure_
```
wahoo/
  db/
    pkg/
      mypkg
```
_Contents of_ `mypkg`
```
https://github.com/<USER>/wa-mypkg
```

A package can be as simple as a `mypkg/mypkg.fish` file exposing only a `mypkg` function, or several `function.fish` files, a `README` file, a `completions/mypkg.fish` file with fish [tab-completions](http://fishshell.com/docs/current/commands.html#complete), etc.

+ Example:

```
mypkg/
  README.md
  mypkg.fish
  completions/mypkg.fish
```

### Initialization

Wahoo loads each `$WAHOO_PATH/<pkg>.fish` on startup and [emits](http://fishshell.com/docs/current/commands.html#emit) `init_<pkg>` events to subscribers with the full path to the package.

```fish
function init -a path --on-event init_mypkg
end

function mypkg -d "My package"
end
```

Use the `init` event set up your package environment, load resources, autoload functions, etc.

> The `init` event is optional.

### Ignoring

Remove any packages you wish to turn off using `wa remove <package name>`. You can also set a new global `$WAHOO_IGNORE` in your `~/.config/fish/config.fish` with your ignores. For example:

```fish
set -g WAHOO_IGNORE skip this that ...
```

### Uninstall

Wahoo emits `uninstall_<pkg>` events before a package is removed via `wahoo remove <pkg>`. Subscribers can use the event to clean up custom resources, etc.

```fish
function uninstall --on-event uninstall_pkg
end
```

# License

[MIT](http://opensource.org/licenses/MIT) © [Jorge Bucaran][author] et [al][contributors] :heart:

[author]: http://about.bucaran.me
[contributors]: https://github.com/fish-shell/wahoo/graphs/contributors
[travis-logo]: http://img.shields.io/travis/fish-shell/wahoo.svg?style=flat-square
[travis]: https://travis-ci.org/fish-shell/wahoo
[fishshell]: http://fishshell.com
[wahoo-pulls-link]: https://github.com/fish-shell/wahoo/pulls
