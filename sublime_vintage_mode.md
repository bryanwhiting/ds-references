# Sublime Vintage mode
## Table of Contents

1. [Getting Started with Sublime Vintage mode](#gs)
    1. [Introduction](#gsintro)
        1. [What is Vintage mode?](#gswhatis)
        1. [Why use Vintage mode?](#gswhyuse)
    1. [Using Vintage Mode](#gs_using)
    1. [Top 10 Commands](#gstop)
1. [Vi Commands for Sublime](#vc)
    1. [Moving Around](#vcma)
    1. [Copy and Paste](#vccp)
    1. [Editing](#vced)
    1. [Visual ](#vcv)
    1. [Search and Screen](#vcss)
    1. [Marking](#vcm)
    1. [Macros](#vcmacros)
    2. [Registers](#vcregisters)
1. [Advanced](#ad)
    1. [Frequently used combos](#adfc)
    1. [Protips](#adp)
    1. [Command groupings](#adcg)

#<a name="gs"></a>Getting Started with Sublime Vintage mode
##<a name="gsintro"></a>Introduction
###<a name="gswhatis"></a>What is Vintage mode?
Welcome to an introduction for Sublime's Vintage mode. [Vintage Mode](https://www.sublimetext.com/docs/2/vintage.html) is a vi text editing implementation for Sublime. To get Vintage Mode enabled, click on the previous link and follow the instructions (2 min).

What is a vi editing package? [vi](https://en.wikipedia.org/wiki/Vi) is like using hot keys/key-bindings for editing text. Vi a standard for what the hot keys should do. To introduce it, think more broadly about the <kbd>&uarr;</kbd> key. You don't have to wonder what the <kbd>&uarr;</kbd> key does. You'd expect every keyboard to behave the same when you press <kbd>&uarr;</kbd>: move cursor up. The disadvantage of using the <kbd>&uarr;</kbd> key is that it's removed from your keyboard. What if you could use <kbd>k</kbd> in place of the <kbd>&uarr;</kbd> key?

###<a name="gswhyuse"></a>Why use Vintage mode?
Why do you use the <kbd>&uarr;</kbd>, <kbd>&darr;</kbd>, <kbd>&larr;</kbd>, <kbd>&rarr;</kbd>, keys anyway? It's because using the mouse would slow you down. That's the main concept behind vi: speed. Reduce the keystrokes you use and ultimately improve how quickly you can edit text or code.

Vi has hot keys for just about anything you do while editing text. For example, instead of <kbd>Ctrl</kbd><kbd>z</kbd> for "undo", you could type <kbd>u</kbd>. Instead of <kbd>Ctrl</kbd><kbd>z</kbd>, for "copy", you could type <kbd>p</kbd>.

Going one step further, what if you want to replace all of the text within a parenthesis, say in the following line of R code?
```{r}
a <- c("red", "blue", "green", "yellow", "purple")
```
The quick keystrokes <kbd>d</kbd><kbd>i</kbd><kbd>(</kbd> will delete `"red", "blue", "green", "yellow", "purple"`, leaving you with just `inlist()`. Or, if you don't want to delete, but just highlight and copy everything within `()`, <kbd>y</kbd><kbd>i</kbd><kbd>(</kbd> will do just that.

Even faster, <kbd>v</kbd><kbd>a</kbd><kbd>p</kbd> will highlight an entire paragraph (think chunk of contiguous code). If you were to do that with regular keys, and depending on the length of the paragraph, it's quicker to type three keys than to type <kbd>shift</kbd><kbd>&uarr;</kbd><kbd>&uarr;</kbd><kbd>&uarr;</kbd><kbd>&uarr;</kbd><kbd>&larr;</kbd><kbd>&larr;</kbd><kbd>&larr;</kbd>...Are you getting convinced?

And no, you don't memorize random combinations of keystrokes. But rather, you learn what individual keystrokes do and how to naturally combine them. For example, <kbd>d</kbd> enters delete mode. But it doesn't operate by just itself. It needs another keystroke to execute. And <kbd>i</kbd><kbd>(</kbd> tells the <kbd>d</kbd> command "inside the current `()`". Therefore, <kbd>d</kbd>elete <kbd>i</kbd>nside the <kbd>(</kbd>. Or to copy,  <kbd>y</kbd><kbd>i</kbd><kbd>(</kbd>, where <kbd>y</kbd> is for "yank". Vi's commands have meaning.

##<a name="gs_using"></a>Using Vintage Mode
Back to where we started - you may be wondering how <kbd>k</kbd> can be <kbd>&uarr;</kbd>. To get started, there are two modes when you have Vintage mode turn on:
* `INSERT MODE`: The mode you need to be in to type text
* `COMMAND MODE`: The mode you need to be in to execute vi commands

In Sublime, you can see what mode you're in by looking in the bottom left corner of the Sublime Graphical User Interface (GUI). Use <kbd>i</kbd> to enter `INSERT MODE` and <kbd>Esc</kbd> to go back to `COMMAND MODE`.


If I were to learn only 10 commands to improve
##<a name="gsgs"></a>Top 10 Commands
Keys    | Command
---     | ---
<kbd>j</kbd>     | Move down one line
<kbd>k</kbd>     | Move up one line
<kbd>l</kbd>     | Move right one column (<kbd>l</kbd> = "ell")
<kbd>h</kbd>     | Move left one column
<kbd>i</kbd>     | Enter insert mode (i is for insert)
<kbd>Esc</kbd>   | Enter command mode
<kbd>d</kbd><kbd>d</kbd>    | Delete current line (d is for delete)
<kbd>y</kbd><kbd>y</kbd>    | Copy current line (y is for yank)
<kbd>p</kbd>     | Paste (p is for paste)
<kbd>u</kbd>     | Undo (u is for undo)
<kbd>I</kbd>     | Enter insert mode at start of current line (I is for append)
<kbd>A</kbd>     | Enter insert mode at end of current line (A is for append)
<kbd>C</kbd>     | Delete to the end of the line and enter insert mode. (Note, that's <kbd>shift</kbd>+<kbd>c</kbd>)
<kbd>v</kbd><kbd>i</kbd><kbd>b</kbd>   | Highlight everything within current `()`

If you want more of an introduction, you can explore the following links:

1. [This tutorial] provides a great introduction to vi.
1. Here's a [web video game] dedicated to practicing vi from the basics.

To provide more historical context, [Vim] is a text editor that implements vi (it stands for [vi iMproved]). Sometimes they can be confused as the same thing, but Vim's commands are the superset of vi. As you Google possible vi commands, you can usually enter vi or Vim into Google. But Vim has many features that vi lacks, including a mode called "Ex" mode. But the purpose of this tutorial is to expose you to Vintage mode, Sublime's implementation of vi. A few keystrokes from vi don't work in Vintage mode, but most do. This tutorial should prove useful while you're using Sublime.

[Vim]:http://www.vim.org/
[vi iMproved]:https://en.wikipedia.org/wiki/Vim_(text_editor)
[interactive tutorial]:http://www.openvim.com/
[web video game]:http://vim-adventures.com/
[This tutorial]:https://blog.interlinked.org/tutorials/vim_tutorial.html

#<a name="vc"></a>Vi Commands for Sublime
Sublime's Vintage mode is an implementation of vi, but is not vi. Again, vi is a standard for executing commands in a text editor, and Sublime implements that standard. That being said, many of the basic vi commands for editing text are available. (The vi commands that largely aren't available include using the <kbd>:</kbd> key, or <kbd>ctrl</kbd>, because Sublime's hotkeys override them.) The following list are commands that work in Sublime's Vintage mode.

##<a name="vcma"></a>Moving Around
Keys    | Command
---     | ---
`j`     | Move down one line
`k`     | Move up one line
`l`     | Move right one column (`l` = "ell")
`h`     | Move left one column
`e`     | Move to end of current word
`w`     | Move to start of next word
`b`     | Move to start of previous word
`#j`    | Move down # lines (You can use #j, #k, #l, #h too)
`H`     | Move to top of current page
`L`     | Move to bottom of current page
`$`     | Go to end of line (`A` = insert at end of line)
`0`     | Go to start of line, first column (`I` = insert at start of line)
`''`    | Go to start of line, first column
`^`     | Go to start of line, first non-whitespace character
`_`     | Go to start of line, first non-whitespace character
`g_`    | Go to start of line, first non-whitespace character (same as `^`) (In traditional vi, this would take you to the last non-whitespace character)
`gg`    | Go to top of script
`G`     | Go to end of script
`#gg`   | Go to line #
`#G`    | Go to line #
`fx`    | Go to next occurrence of x on line (replace x with any character)
`Fx`    | Go to previous occurrence of x on line
`tx`    | Go until next occurrence of x on line, (replace x with any character)
`Tx`    | Go until previous occurrence of x on line
`}`     | Go to next block of code
`{`     | Go to previous block of code
`%`     | Moves to matching brace { }, parenthesis ( ) or bracket [ ]
`,`     | Moves to previous `.` in line (`,` = comma)

##<a name="vccp"></a>Copy and Paste
Keys    | Command
---     | ---
`yw`    | Copy (yank) characters from current position to start of next word
`y$`    | Copy to end of line
`yi(`   | Copy everything within current `()` (also works with `{}`, `[]`, `""`, `''`)
`ya(`   | Copy everything within and including current `()` (also works with `{}`, `[]`, `""`, `''`)
`y0`    | Copy to beginning of line
`yy`    | Copy line
`Y`     | Copy line (duplicate)
`#yy`   | Copy # lines
`p`     | Paste after position (or paste below line if using `yy`)
`P`     | Paste before position (or paste above line if using `yy`)

Pro tips:

* Add the following line to your Settings-User file to have `yy` copy into your machine's clip board:

```{JSON}
"vintage_use_clipboard": true,
```

* By default, `yy` uses a Sublime-internal copy-and-paste register (see [Registers](#vcregisters)). Adding this line of code will enable you to `yy` from Sublime and `ctrl+v` into any other application, including Stata. (Think `yy+alt+tab` to copy the current line and then switch to Stata's console.


##<a name="vced"></a>Editing
Keys    | Command
---     | ---
`i`		| Insert mode before text
`a`     | Insert mode after text ("a" for "append")
`I`     | Insert mode at start of line
`A`	    | Insert mode at end of line
`s`	    | Substitute current selection
`S`     | Delete text in current line, enter insert mode at start of text
`cc`	| Delete text in current line, enter insert mode at start of text
`ce`	| Delete text to end of word, enter insert mode
`cw`	| Delete text to end of word, enter insert mode (mimics `ce`)
`C`     | Delete to end of line and enter insert mode
`dd`    | Delete current line
`dj`    | Delete current line and line below
`dk`    | Delete current line and line above
`d#j`	| Delete current line and # lines below (d#k as well for lines "above")
`#dj`	| Delete current line and # lines below (d#k as well for lines "above")
`#dd`	| Delete # lines below including current line
`db`	| Delete to start of current word (deletes left)
`dw`	| Delete to start of next word
`de`	| Delete to end of current word
`dfx`   | Delete through next occurrence of x (replace x with any letter)
`dtx`   | Delete until next occurrence of x
`D`     | Delete to end of line
`#D`	| Delete to end of line and (#-1) of the next lines
`x`     | Delete character under cursor
`X`     | Delete character left of cursor
`#x`	| Delete # characters to the right (starting with current)
`xp`	| Delete and paste current letters (sawps to swaps)
`u`     | Undo
`ctrl+y`| Redo
`ctrl+y`| Repeat last command (after all `undo`s have been made)
`.`     | Repeat last command
`~`	    | Switch case of letter under cursor (upper / lower case)
`di(`   | Delete everything within current `()` (also works with `{}`, `[]`, `""`, `''`)
`da(`   | Delete everything within and including current `()` (also works with `{}`, `[]`, `""`, `''`)
`ci(`   | Delete everything within current `()`, enter insert mode (also works with `{}`, `[]`, `""`, `''`)
`ca(`   | Delete everything within and including current `()`, enter insert mode (also works with `{}`, `[]`, `""`, `''`)
`>>`    | In/dent current line
`#>j`   | Indent `#` lines below (works like `d` key)
`<<`    | Unindent current line
`#<j`   | Unindent `#` lines below (works like `d` key)
`==`    | Update indentation to match indentation of line above
`#=j`   | Update indentation of this and `#` lines below to match indentation of line above (works like `d` key)

Protips:
* Anytime you delete something, either using x, dd, cw, etc., it's really just a "cut". So you can always paste what you just deleted using "p".
    - If you yank something, and then highlight and replace something else, it’ll copy the word you just overwrote. So anytime you paste over something, and it deletes that something, whatever you delete will be stored in the register (which isn’t the clipboard). The key is, anytime you delete something it gets stored in the register
    - Protip: use ctrl+d to highlight multiple words and p to paste over all of them. But note, now whatever you highlighted using ctrl+d will be in your register
* `d` and `c` enter into "delete" mode or "change" mode. They behave the same, except `c` enters into insert mode after the delete has been made. `v` and `y` also have the same keystrokes. Therefore, these four keys require a second command before they become activated.
* Any command deleting everything within  `()`, `{}`, `[]`, doesn't work when the `()` are within a string, but you can use it `''` is nested within `""`, as in `"This is a long 'string' hello".
* `dj` = `1dj` = `2dj` (They all delete 2 lines). 3dj = delete 3 lines. 4 dj = delete 4 lines. So $N$`dj` deletes N lines when $N \geq 3$. Same applies for keys `v`,`y`,`c`. (Sometimes this is true. Othertimes, it can delete more lines.)*


##<a name="vcv"></a>Visual
Terminology: a “block” is a section of selected/highlighted text. "Visual" is the vi term for "Select". A "visual block" is a group of selected/highlighted text.

Keys    | Command
---     | ---
`v`     | Begin selection mode. Use movement keys `j`, `k`, `l`, `h`, or anything in [Moving Around](#moving-around) to select.
`V`     | Select line

When in selection mode (called "visual" mode in vi):

Keys    | Command
---     | ---
`I`     | Insert mode at start of selection (`i` has different function)
`A`     | Insert mode at end of selection (`a` has different function)
`d`     | Delete selection
`x`     | Delete current selection
`c`     | Delete current selection and enter insert mode
`s`     | Delete current selection + 1 to the right (use `c` instead)
`rx`    | Replace current selection with character x
`ctrl + shift+l`    | Add multiple cursors in visual mode to end of the line. `v` to exit visual mode and maintain cursors.
`iw`    | Select current word (inner word)
`aw`    | Select current word plus space (outer word)
`ib`    | Select everything within current parenthesis, excluding ()
`ab`    | Select everything within current parentheses, including ()
`iB`    | Select everything within current braces, excluding {}
`aB`    | Select everything within current parentheses, including {}
`i(`    | Select everything within current `()` (also works with `{}`, `[]`, `""`, `''`)
`o`     | Move cursor to other end of selected block
`0`     | Select to start of line (if stuff to the right and below is selected), or select to start of previous line (if everything above and to the left is selected)
`aw`    | Select current word, including whitespace before next word
`ctrl+d`| Highlight other instances of selected text (Sublime standard)
`ap`    | Select current paragraph (contiguous lines without carriage return)
`u`     | Convert visual block to lower case
`U`     | Convert visual block to upper case
`~`     | Switch case of visual block (upper / lower case)
`>`     | Indent selection
`<`     | Unindent selection
`=`     | Re-indents selected lines to have same indentation as line above
`ctrl+shift+j`     | Visual block on indented text

Protips:

Keys    | Command
---     | ---
`viw`   | Select current word only
`g~iw`  | Toggles case of word under cursor
`gUiw`  | Converts word under cursor to upper case

Note: `g` is a "motion" command. g~: This changes the case of whatever      text-motion comes next. iw is the text motion for "inner-word", so g~iw changes the case of what Vim defines as a word (pretty much what English defines as a word). `g` is limited in Sublime Vintage Mode, but has a lot of power in Vim.

##<a name="vcss"></a>Search and Screen
Keys    | Command
---     | ---
`/`     | Search forward. Hit <kbd>Enter</kbd> to find. (similar `ctrl+f`, except `/` always is empty. `ctrl+f` can contain what's presently selected.)
`?`     | Search previous
`n`     | Move to next occurrence of last search
`N`     | Move to previous occurrence of last search
`*`     | Move to next occurrence of word under cursor (not in select mode). Can be combined with `n` and `N`.
`#`     | Move to previous occurrence of word under cursor (cannot use selection mode). Can be combined with `n` and `N`.
`zz`    | Move screen to center cursor (equivalent to `ctrl+k ctrl+c` in Sublime)
`z.`    | Move screen to center cursor (duplicate)
`zt`    | Move screen to place cursor at top
`zb`    | Move screen to place cursor at bottom
`M`     | Move cursor to center of screen
`zc`    | Fold highlighted text / current 'level' (Sublime 'hides' the selected text)
`zo`    | Unfold current level

* Hit `/`, type in a search term, and hit <kbd>Enter</kbd>. Then use `n` and `N` to cycle between search words.
* Hit `/`, type in a search term. Now hit `ctrl+g` and <kbd>Enter</kbd>. You can now use `n` and `N` to cycle through your highlighted search term. Use <kbd>Alt</kbd>+<kbd>F3</kbd> to highlight every instance of that word.
* Hit `/`, type in a search term. Now hit <kbd>Alt</kbd><kbd>F3</kbd> and <kbd>Enter</kbd>. You can now edit every word using <kbd>c</kbd>, or <kbd>I</kbd>. Or, you can use <kbd>V</kbd> to highlight every row with that search term (and then use <kbd>d</kbd> to delete, or <kbd>y</kbd> to copy.)
* Also, <kbd>Alt</kbd>+<kbd>F3</kbd> works as a good addition for <kbd>Ctrl</kbd>+<kbd>d</kbd>. Where <kbd>Ctrl</kbd>+<kbd>d</kbd> highlights one by one, <kbd>Alt</kbd>+<kbd>F3</kbd> highlights all at once.

##<a name="vcm"></a>Marking (Bookmarking)
To set a "real" bookmark in Sublime, use <kbd>Ctrl</kbd>+<kbd>F2</kbd>. This will leave a white arrow on the line number you bookmarked. Alternatively, you can use Vintage mode to mark the line (and cursor position). However, you will not see a white arrow when using Vintage mode marks. FYI, bookmarks only last as long as the file is open. They're useful if you go between two chunks of code repeatedly. Or, they're useful if you want to leave but come right back.

Keys    | Command
---     |---
`mx`    | Mark the current cursor position (`x` can be any letter or number, and is case sensitive).
``x`    | Go to bookmark x

* Note, if you have `StataEditor` as your Stata Package for Sublime, you'll notice that <kbd>\`</kbd> creates <kbd>\`'</kbd> by default. This `StataEditor` feature is useful for making locals. But if you want to override the <kbd>\`'</kbd> Sublime command, you'll have to install `VintageES`.

##<a name="vcmacros"></a>Macros
Vintage mode allows you to record macros. While recording, the macro will track your every move, even in and out of command mode. Any macros will then be stored as long as Sublime is open. You can close the current file, and your macros will still be there. Sublime lets you record macros using <kbd>ctrl</kbd>+<kbd>q</kbd>, but it will only let you record macros one at a time. Vintage mode lets you name your macros.

Keys    | Command
---     |---
`qx`    | Start recording macro, assign macro to letter `x` (replace `x` with any letter or number)
`q`     | Stop macro recorder
`@x`    | Run macro `x`

##<a name="vcregisters"></a>Registers
Every time you press <kbd>Ctrl</kbd><kbd>c</kbd> on your Windows machine, data is stored in the Windows clipboard. If you highlight new text and press <kbd>Ctrl</kbd><kbd>c</kbd> again, however, the old copied text is deleted and replaced with the newly copied text.

What if you could copy two things at once? That way, you can paste two different things at once. Well, vi allows for this. [Registers] are vi's clipboard.  You can access a register using `"a` where `a` is any letter. For example, to store highlighted text in register `a`, type `"ay`. Then highlight additional text and type `"by` to store newly copied text in register `b`. You'll noticed that if you type `p`, the stuff from `a` nor `b` will come out.

By default, there are three main, the system register, or clipboard (named `*`), the last-yanked register (named `0`), and the default register (which is filled every time you yank or delete without using registers).

Keys    | Command
---     |---
`"ay`   | Fills register `a` with highlighted text. `y` can be replaced with any `y` command, such as `yy`, `yw`, `yiw`, `yi(`, etc. `y` can also be replaced with `d`.
`"*p`   | Paste your Windows clipboard (equivalent to <kbd>Ctrl</kbd><kbd>v</kbd>). <kbd>p</kbd> can be replaced with <kbd>y</kbd>.
`"+p`   | Paste your Windows clipboard. (Same as `"*p`)
`"0p`   | Paste whatever was last yanked
`"1p`   | Paste whatever was last deleted (`1` can be used as a register, but if something is deleted after you create the register with `"1y`, `"1p` will paste what was last deleted.)
`p`     | Paste from the default register (equivalent to `""p`)
`"ap`   | Paste from register `a`

`"0p` will allow you to yank something, go and delete something (remember that when you delete something, it fills the unnamed register with whatever you deleted), and then paste what was last yanked. Here is another useful intro on [how to use registers]. Also, the 'unnamed' register is really just the register named `"`.

[Registers]:http://usevim.com/2012/04/13/registers/
[how to use registers]:http://stackoverflow.com/questions/1497958/how-do-i-use-vim-registers

#<a name="ad"></a>Advanced
##<a name="adfc"></a>Frequently used combos
Keys    | Command
---     | ---
`vgg`   | Select to start of script (useful when sending to Stata)
`r<enter>`   | Breaks current line if on whitespace (opposite of `J`)
`ct.`   | Delete to the `.` in a file path and enter insert mode.
`ddp`   | Transpose current line with line below it (`ctrl+shift+down` in Sublime)
`xp`    | Transpose two lettres...letters.
`#n`    | Put the word currently under cursor and use `n` or `N` to find other instances of that word

##<a name="adp"></a>Protips
* Beware of <kbd>Caps Lock</kbd>. It messes up all of your keystrokes when in `Command Mode`.
* To surround "something" in "quotes", enter visual mode and highlight the selection, hit shift "", and then hit any arrow key <kbd>&larr;</kbd> key. Note, this functionality may be native to Sublime, but Sublime Vintage mode disables it, as `""` is a command within `visual` mode. The arrow keys are not part of vi, and so that allows you to execute the code. Or, just go into `INSERT MODE` and the functionality will work.

##<a name="adcg"></a>Command groupings
* Commands that behave similarly:
    - <kbd>v</kbd>, <kbd>d</kbd>, <kbd>c</kbd>, <kbd>y</kbd>, <kbd>></kbd>, <kbd><</kbd>, <kbd>=</kbd>
    - Use same keystrokes
* Commands that require second keystrokes:
    - <kbd>r</kbd>, <kbd>z</kbd>, <kbd>f</kbd>, <kbd>t</kbd>, <kbd>g</kbd>, <kbd>@</kbd>, <kbd>\</kbd>

Here's a helpful cheat sheet from [viemu.com](http://www.viemu.com/vi-vim-cheat-sheet.gif):
![](http://www.viemu.com/vi-vim-cheat-sheet.gif "Source: http://www.viemu.com/vi-vim-cheat-sheet.gif")
<!-- ![](Sublime Vintage Mode/qwerty_1.jpg "Image") -->

<!-- * Red: Movement keys
* Blue: Edit keys
* Green: Ways to enter insert mode
* Yellow: Search
* Pink: Visual mode
* Purple: Macros, Registers, and Screens and Other
 -->

##<a name="adpackages"></a>Sublime Vi Packages
* VintageES
    - Downfalls:
        + The goto line command, "20G" won't work if you have a "0" in the number. For example, 21G will take you to line 21. But 20G will just take you to the bottom. 94G will take you to line 94. 90G to the bottom. This means you can't go to any line such as 100-109, but you can go to 111.
