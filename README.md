# Welcome!

Today, we will try to learn Elm together. Before starting to develop in Elm, we need to follow some instructions to have a working dev environment.


## Install Elm

You need to download and install Elm through [the following link](https://guide.elm-lang.org/install.html).

## Install a plugin for your editor

Install a plugin for your editor to be able to understand Elm. You can find some instructions for these editors (I advice you to use IntelliJ or VS Code): 

 - [Atom](https://atom.io/packages/language-elm)
 - [Brackets](https://github.com/tommot348/elm-brackets)
 - [Emacs](https://github.com/jcollard/elm-mode)
 - [Webstorm / IntelliJ](https://github.com/klazuka/intellij-elm)
 - [Sublime Text](https://packagecontrol.io/packages/Elm%20Language%20Support)
 - [Vim](https://github.com/ElmCast/elm-vim)
 - [VS Code](https://github.com/sbrink/vscode-elm)

If you don't want to set up a dev environment, you can use the Ellie online editor – a link will be provided at each step.

## Install `elm-format`

`elm-format` is a code formatter that will format your Elm code according to a standard set of rules. It looks a lot like `prettier`, for those who know it. This is not mandatory but strongly advised as it will really improve your experience with Elm.

Follow the instructions on the [elm-format page](https://github.com/avh4/elm-format#installation-) and don't forget to configure your IDE to work with `elm-format`.

## Get the code

You now need to get the code from this repository, either by [downloading the archive (click here)](https://github.com/jgrenat/elm-workshop/archive/master.zip) or by cloning it:

```
git clone https://github.com/jgrenat/elm-workshop.git
cd elm-workshop
```

# Workshop

This workshop is divided into several folders corresponding to one step each. To start, first execute the following commands into your terminal at the root of this repository:

```sh
elm make && elm reactor
```

You can then open the link [http://localhost:8000/](http://localhost:8000/). As you can see, `elm-reactor` allowed us to launch a basic dev environment, and you can see the different folders for each step of the project. You can now start by going into the step 1.

