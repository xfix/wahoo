<div align="center">
  <a href="http://github.com/fish-shell/wahoo">
    <img width=120px  src="https://cloud.githubusercontent.com/assets/8317250/8775571/6930d858-2f24-11e5-9629-c3cc833d71e8.png">
  </a>
</div>

<br>

# FAQ

Thanks for taking the time to read this FAQ. Feel free to create a new issue if your question is not answered here.


## What is Wahoo and why do I want it?

_Wahoo_ is a framework for the [fishshell](https://fishshell.org). It helps you manage your configuration, themes and packages.


## What do I need to know to use Wahoo?

_Nothing_. You can install Wahoo just to take advantage of the universal fish installer in `bootstrap.sh` and keep using fish as usual. When you are ready to learn more just type `wa help`.


## What are Wahoo packages?

Wahoo packages are themes or plugins written in fish that extend the shell core functionality, run code during initialization, add auto completion for known utilities, etc.


## What kind of Wahoo packages are there?

There are roughly 3 kinds of packages:

1. Configuration utilities. For example [`pkg-pyenv`](https://github.com/wa/pkg-pyenv) checks whether `pyenv` exists in your system and runs `(pyenv init - | psub)` for you during startup.

2. Themes. Check our [theme gallery](https://github.com/wa).

3. Traditional shell utilities. For example [`pkg-copy`](https://github.com/wa/pkg-copy), a clipboard utility compatible across Linux and OSX.


## What does Wahoo do exactly?

+ Autoload installed packages and themes under `$WAHOO_PATH/`.

+ Autoload your custom path. `$HOME/.dotfiles` by default, but configurable via `$WAHOO_CUSTOM`.

+ Autoload any `functions` directory under `$WAHOO_PATH` and `$WAHOO_CUSTOM`

+ Run `$WAHOO_CUSTOM/init.fish` if available.



## How is Wahoo better than Oh My Fish?

Oh My Fish is inspired by Oh My ZSH. Wahoo was carefully designed from day one to use fishshell powerful features such as [autoloading](http://fishshell.com/docs/current/tutorial.html#tut_autoload), [completions](http://fishshell.com/docs/current/commands.html#complete) and [events](http://fishshell.com/docs/current/commands.html#emit) consistently.

### Wahoo...

+ _has_ a cleaner and higher level plugin system based in events.

+ _is_ thoroughly documented. Everything you need to know is in the README.

+ _is_ a decentralized package manager. We keep a database with URLs to packages.

> You can still run `wa get <URL>` to install a package from any URL you provide.

+ _features_ `wa`, a powerful utility to let you get / remove packages, switch themes, scaffold out new packages, submit plugins/themes, uninstall Wahoo, etc.

## How can I upgrade from an existing Oh My Fish installation?

+ Remove Oh My Fish install path and curl Wahoo.

```
rm -rf "$fish_path"
curl -L git.io/wa | sh
```

## Does Wahoo support Oh My Fish themes?

Yes. To install a theme:

+ Move the theme directory to `$WAHOO_PATH/themes` or `$WAHOO_CUSTOM/themes`.

## Does Wahoo support Oh My Fish plugins?

No, but we got you covered in the [Wahoo Foundry](https://github.com/wa/).

#### Long Answer

Wahoo uses event emitters to initialize and uninstall plugins. Some Oh My Fish plugins may work out of the box, but it's recommended to use Wahoo plugins instead.

## I changed my prompt with `fish_config` and now I can't get my Wahoo theme's prompt back, what do I do?

`fish_config` persists the prompt to `~/.config/fish/functions/fish_prompt.fish`. That file gets loaded _after_ the Wahoo theme, therefore it takes precedence over the Wahoo theme's prompt. To restore your Wahoo theme prompt, simply remove that file by running:

```
rm ~/.config/fish/functions/fish_prompt.fish
```
