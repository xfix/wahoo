> The [Fishshell][fishshell] Framework

![][fish-badge]
[![][travis-logo]][travis]
![][license-badge]


<a name="wahoo"></a>

<br>

<p align="center">
  <a href="https://github.com/fish-shell/wahoo/blob/master/README.md">
  <img width="300px" src="https://cloud.githubusercontent.com/assets/8317250/8765102/40cbf31c-2e38-11e5-930b-134ad949726e.png">
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

We love contributions, [fork and send us a PR](https://github.com/fish-shell/wahoo/fork).

# Install

```sh
curl -L git.io/wa | sh
wa help
```

Or _download first_ and run it yourself:

```sh
curl -L git.io/wa > install
chmod +x install
./install
```

> **Note**: If you haven't installed `fish` already, you may need to `sudo` in order to _change the default_ shell.

# :beginner: Getting Started

Wahoo includes a small utility `wa` to fetch and install new packages and themes.

## `wa update`

Update framework and installed packages.

> If you have unstaged changes in your local copy, these are [stashed](https://git-scm.com/book/no-nb/v1/Git-Tools-Stashing) and reapplied after pulling updates from upstream. Committed changes are [rebased](https://git-scm.com/book/en/v2/Git-Branching-Rebasing) with master.

## `wa get` _`<package> ...`_

Install one _or more_ themes or packages. To list available packages type `wa use`.

> You can fetch packages by URL as well via `wa get URL`

## `wa list`

List installed packages.

> To list packages available for download use `wa get`.

## `wa use` _`<theme>`_

Apply a theme. To list available themes type `wa use`.

## `wa remove` _`<name>`_

Remove a theme or package.

> Packages subscribed to `uninstall_<pkg>` events are notified before the package is removed to allow custom cleanup of resources. See [Uninstall](#uninstall).

## `wa new pkg | theme` _`<name>`_

Scaffold out a new package or theme.

> This creates a new directory under `$WAHOO_CUSTOM/{pkg or themes}/` with a starting template.

## `wa submit` _`pkg/<name>`_ _`[<url>]`_

Add a new package. To add a theme use `wa submit` _`themes/<name>`_ _`<url>`_.

Make sure to [send us a PR][wahoo-pulls-link] to update the registry.

## `wa query` _`<variable name>`_

Use `wa query` to inspect all session variables. Useful to pretty dump _path_ variables like `$fish_function_path`, `$fish_complete_path`, `$PATH`, etc.

## `wa destroy`

Uninstall _Wahoo_. See [uninstall](#uninstall) for more information.

# Advanced

> Hoot! Ho, brave sir or madam, on your quest to wake the dreamer! Read on if you wish to learn more about Wahoo.

+ [Bootstrap](#bootstrap)
+ [Startup](#startup)
+ [Core Library](#core-library)
+ [Packages](#packages)
  + [Creating](#creating)
  + [Submitting](#submitting)
  + [Initialization](#initialization)
  + [Uninstall](#uninstall)
  + [Ignoring](#ignoring)

## Bootstrap

Wahoo's bootstrap script will install `git` and `fish` if not available, switch your default shell and modify `$HOME/.config/fish/config.fish` to source Wahoo's `init.fish` script.

## Startup

This script runs each time a new session begins, autoloading packages, themes and your _custom_ path (dotfiles) in that order.

The _custom_ path (`$HOME/.dotfiles` by default) is defined by `$WAHOO_CUSTOM` in `$HOME/.config/fish/config.fish`. Modify this to load your own dotfiles if you have any.

## Core Library

The core library is a minimum set of basic utility functions that extend your shell.

+ [See the documentation](/lib/README.md).


## Packages

### Creating

> A package name may only contain lowercase letters and hyphens to separate words.

To scaffold out a new package:

```fish
$ wa new pkg my_package

my_package/
  README.md
  my_package.fish
  completions/my_package.fish
```

> Use `wa new theme my_theme` for themes.

Please provide [auto completion](http://fishshell.com/docs/current/commands.html#complete) for your utilities if applicable and describe how your package works in the `README.md`.


`my_package.fish` defines a single function:

```fish
function my_package -d "My package"

end
```

> Bear in mind that fish lacks a private scope so consider the following options to avoid polluting the global namespace:

+ Prefix functions: `my_package_my_func`.
+ Using [blocks](http://fishshell.com/docs/current/commands.html#block).


### Submitting

Wahoo keeps a registry of packages under `$WAHOO_PATH/db/`.

To create a new entry run:

```fish
wa submit pkg/my_package .../my_package.git
```

Similarly for themes use:

```fish
wa submit theme/my_theme .../my_theme.git
```

This will add a new entry to your local copy of the registry. Please [send us a PR][wahoo-pulls-link] to update the global registry.


### Initialization

If you want to be [notified](http://fishshell.com/docs/current/commands.html#emit) when your package is loads, declare the following function in your `my_package.fish`:

```fish
function init -a path --on-event init_mypkg

end
```

Use this event to modify the environment, load resources, autoload functions, etc. If your package does not export any functions, you can still use this event to add functionality to your package.

### Uninstall

Wahoo emits `uninstall_<pkg>` events before a package is removed via `wahoo remove <pkg>`. Subscribers can use the event to clean up custom resources, etc.

```fish
function uninstall --on-event uninstall_pkg

end
```

### Ignoring

Remove any packages you wish to turn off using `wa remove <package name>`. Alternatively, you can set a global env variable `$WAHOO_IGNORE` in your `~/.config/fish/config.fish` with the packages you wish to ignore. For example:

```fish
set -g WAHOO_IGNORE skip this that ...
```


# License

[MIT][license] © [Authors][contributors] :heart:



[fish-badge]: https://img.shields.io/badge/fish-v2.2.0-FF3157.svg?style=flat-square
[license]: http://opensource.org/licenses/MIT
[license-badge]: https://img.shields.io/badge/license-mit-707070.svg?style=flat-square
[contributors]: https://github.com/fish-shell/wahoo/graphs/contributors
[travis-logo]: http://img.shields.io/travis/fish-shell/wahoo.svg?style=flat-square
[travis]: https://travis-ci.org/fish-shell/wahoo
[fishshell]: http://fishshell.com
[wahoo-pulls-link]: https://github.com/fish-shell/wahoo/pulls
